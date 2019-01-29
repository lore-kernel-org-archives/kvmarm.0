From: James Morse <james.morse@arm.com>
Subject: [PATCH v8 20/26] ACPI / APEI: Only use queued estatus entry during
 in_nmi_queue_one_entry()
Date: Tue, 29 Jan 2019 18:48:56 +0000
Message-ID: <20190129184902.102850-21-james.morse@arm.com>
References: <20190129184902.102850-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEB3A4A330
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:50:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0idvaxgXSV40 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Jan 2019 13:50:37 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 838244A319
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:50:37 -0500 (EST)
In-Reply-To: <20190129184902.102850-1-james.morse@arm.com>
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
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Each struct ghes has an worst-case sized buffer for storing the
estatus. If an error is being processed by ghes_proc() in process
context this buffer will be in use. If the error source then triggers
an NMI-like notification, the same buffer will be used by
in_nmi_queue_one_entry() to stage the estatus data, before
__process_error() copys it into a queued estatus entry.

Merge __process_error()s work into in_nmi_queue_one_entry() so that
the queued estatus entry is used from the beginning. Use the new
ghes_peek_estatus() to know how much memory to allocate from
the ghes_estatus_pool before reading the records.

Reported-by: Borislav Petkov <bp@suse.de>
Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Borislav Petkov <bp@suse.de>

Change since v6:
 * Added a comment explaining the 'ack-error, then goto no_work'.
 * Added missing esatus-clearing, which is necessary after reading the GAS,
---
 drivers/acpi/apei/ghes.c | 64 +++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 27 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 12375a82fa03..957c1559ebf5 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -862,57 +862,67 @@ static void ghes_print_queued_estatus(void)
 	}
 }
 
-/* Save estatus for further processing in IRQ context */
-static void __process_error(struct ghes *ghes,
-			    struct acpi_hest_generic_status *src_estatus)
+static int ghes_in_nmi_queue_one_entry(struct ghes *ghes,
+				       enum fixed_addresses fixmap_idx)
 {
-	u32 len, node_len;
+	struct acpi_hest_generic_status *estatus, tmp_header;
 	struct ghes_estatus_node *estatus_node;
-	struct acpi_hest_generic_status *estatus;
+	u32 len, node_len;
+	u64 buf_paddr;
+	int sev, rc;
 
 	if (!IS_ENABLED(CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG))
-		return;
+		return -EOPNOTSUPP;
 
-	if (ghes_estatus_cached(src_estatus))
-		return;
+	rc = __ghes_peek_estatus(ghes, &tmp_header, &buf_paddr, fixmap_idx);
+	if (rc) {
+		ghes_clear_estatus(ghes, &tmp_header, buf_paddr, fixmap_idx);
+		return rc;
+	}
 
-	len = cper_estatus_len(src_estatus);
-	node_len = GHES_ESTATUS_NODE_LEN(len);
+	rc = __ghes_check_estatus(ghes, &tmp_header);
+	if (rc) {
+		ghes_clear_estatus(ghes, &tmp_header, buf_paddr, fixmap_idx);
+		return rc;
+	}
 
+	len = cper_estatus_len(&tmp_header);
+	node_len = GHES_ESTATUS_NODE_LEN(len);
 	estatus_node = (void *)gen_pool_alloc(ghes_estatus_pool, node_len);
 	if (!estatus_node)
-		return;
+		return -ENOMEM;
 
 	estatus_node->ghes = ghes;
 	estatus_node->generic = ghes->generic;
 	estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
-	memcpy(estatus, src_estatus, len);
-	llist_add(&estatus_node->llnode, &ghes_estatus_llist);
-}
 
-static int ghes_in_nmi_queue_one_entry(struct ghes *ghes,
-				       enum fixed_addresses fixmap_idx)
-{
-	struct acpi_hest_generic_status *estatus = ghes->estatus;
-	u64 buf_paddr;
-	int sev;
-
-	if (ghes_read_estatus(ghes, estatus, &buf_paddr, fixmap_idx)) {
+	if (__ghes_read_estatus(estatus, buf_paddr, fixmap_idx, len)) {
 		ghes_clear_estatus(ghes, estatus, buf_paddr, fixmap_idx);
-		return -ENOENT;
+		rc = -ENOENT;
+		goto no_work;
 	}
 
 	sev = ghes_severity(estatus->error_severity);
 	if (sev >= GHES_SEV_PANIC) {
 		ghes_print_queued_estatus();
 		__ghes_panic(ghes, estatus, buf_paddr, fixmap_idx);
-
 	}
 
-	__process_error(ghes, estatus);
-	ghes_clear_estatus(ghes, estatus, buf_paddr, fixmap_idx);
+	ghes_clear_estatus(ghes, &tmp_header, buf_paddr, fixmap_idx);
 
-	return 0;
+	/* This error has been reported before, don't process it again. */
+	if (ghes_estatus_cached(estatus))
+		goto no_work;
+
+	llist_add(&estatus_node->llnode, &ghes_estatus_llist);
+
+	return rc;
+
+no_work:
+	gen_pool_free(ghes_estatus_pool, (unsigned long)estatus_node,
+		      node_len);
+
+	return rc;
 }
 
 static int ghes_in_nmi_spool_from_list(struct list_head *rcu_list,
-- 
2.20.1
