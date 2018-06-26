From: James Morse <james.morse@arm.com>
Subject: [PATCH v5 15/20] ACPI / APEI: Only use queued estatus entry during
 _in_nmi_notify_one()
Date: Tue, 26 Jun 2018 18:01:11 +0100
Message-ID: <20180626170116.25825-16-james.morse@arm.com>
References: <20180626170116.25825-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF7FC4A12E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jun 2018 12:53:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mp0FqI-W0J6E for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jun 2018 12:52:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD5E54A130
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jun 2018 12:50:43 -0400 (EDT)
In-Reply-To: <20180626170116.25825-1-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-acpi@vger.kernel.org
Cc: jonathan.zhang@cavium.com, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Punit Agrawal <punit.agrawal@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Each struct ghes has an worst-case sized buffer for storing the
estatus. If an error is being processed by ghes_proc() in process
context this buffer will be in use. If the error source then triggers
an NMI-like notification, the same buffer will be used by
_in_nmi_notify_one() to stage the estatus data, before
__process_error() copys it into a queued estatus entry.

Merge __process_error()s work into _in_nmi_notify_one() so that
the queued estatus entry is used from the beginning. Use the new
ghes_peek_estatus() so we know how much memory to allocate from
the ghes_estatus_pool before we read the records.

Reported-by: Borislav Petkov <bp@suse.de>
Signed-off-by: James Morse <james.morse@arm.com>
---
 drivers/acpi/apei/ghes.c | 45 ++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 1d59d85b38d2..f196f8797fc1 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -713,40 +713,32 @@ static void ghes_print_queued_estatus(void)
 	}
 }
 
-/* Save estatus for further processing in IRQ context */
-static void __process_error(struct ghes *ghes,
-			    struct acpi_hest_generic_status *ghes_estatus)
+static int _in_nmi_notify_one(struct ghes *ghes, int fixmap_idx)
 {
+	int sev, rc = 0;
 	u32 len, node_len;
+	phys_addr_t buf_paddr;
 	struct ghes_estatus_node *estatus_node;
 	struct acpi_hest_generic_status *estatus;
 
-	if (ghes_estatus_cached(ghes_estatus))
-		return;
+	rc = ghes_peek_estatus(ghes, fixmap_idx, &buf_paddr, &len);
+	if (rc)
+		return rc;
 
-	len = cper_estatus_len(ghes_estatus);
 	node_len = GHES_ESTATUS_NODE_LEN(len);
 
 	estatus_node = (void *)gen_pool_alloc(ghes_estatus_pool, node_len);
 	if (!estatus_node)
-		return;
+		return -ENOMEM;
 
 	estatus_node->ghes = ghes;
 	estatus_node->generic = ghes->generic;
 	estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
-	memcpy(estatus, ghes_estatus, len);
-	llist_add(&estatus_node->llnode, &ghes_estatus_llist);
-}
-
-static int _in_nmi_notify_one(struct ghes *ghes, int fixmap_idx)
-{
-	int sev;
-	phys_addr_t buf_paddr;
-	struct acpi_hest_generic_status *estatus = ghes->estatus;
 
-	if (ghes_read_estatus(ghes, estatus, &buf_paddr, fixmap_idx)) {
+	if (__ghes_read_estatus(estatus, buf_paddr, len, fixmap_idx)) {
 		ghes_clear_estatus(estatus, buf_paddr, fixmap_idx);
-		return -ENOENT;
+		rc = -ENOENT;
+		goto no_work;
 	}
 
 	sev = ghes_severity(estatus->error_severity);
@@ -755,13 +747,20 @@ static int _in_nmi_notify_one(struct ghes *ghes, int fixmap_idx)
 		__ghes_panic(ghes, estatus);
 	}
 
-	if (!buf_paddr)
-		return 0;
-
-	__process_error(ghes, estatus);
 	ghes_clear_estatus(estatus, buf_paddr, fixmap_idx);
 
-	return 0;
+	if (!buf_paddr || ghes_estatus_cached(estatus))
+		goto no_work;
+
+	llist_add(&estatus_node->llnode, &ghes_estatus_llist);
+
+	return rc;
+
+no_work:
+	gen_pool_free(ghes_estatus_pool, (unsigned long)estatus_node,
+			      node_len);
+
+	return rc;
 }
 
 static int ghes_estatus_queue_notified(struct list_head *rcu_list,
-- 
2.17.1
