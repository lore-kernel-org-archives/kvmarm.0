From: James Morse <james.morse@arm.com>
Subject: [PATCH v7 06/25] ACPI / APEI: Don't store CPER records physical
 address in struct ghes
Date: Mon,  3 Dec 2018 18:05:54 +0000
Message-ID: <20181203180613.228133-7-james.morse@arm.com>
References: <20181203180613.228133-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFB144A357
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 13:06:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c3-kvvHFYZlx for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Dec 2018 13:06:57 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78CF44A363
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 13:06:57 -0500 (EST)
In-Reply-To: <20181203180613.228133-1-james.morse@arm.com>
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
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Fan Wu <wufan@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

When CPER records are found the address of the records is stashed
in the struct ghes. Once the records have been processed, this
address is overwritten with zero so that it won't be processed
again without being re-populated by firmware.

This goes wrong if a struct ghes can be processed concurrently,
as can happen at probe time when an NMI occurs. If the NMI arrives
on another CPU, the probing CPU may call ghes_clear_estatus() on the
records before the handler had finished with them.
Even on the same CPU, once the interrupted handler is resumed, it
will call ghes_clear_estatus() on the NMIs records, this memory may
have already been re-used by firmware.

Avoid this stashing by letting the caller hold the address. A
later patch will do away with the use of ghes->flags in the
read/clear code too.

Signed-off-by: James Morse <james.morse@arm.com>

---
Changes since v6:
 * Moved earlier in the series
 * Added buf_adder = 0 on all the error paths, and test for it in
   ghes_estatus_clear() for extra sanity.
---
 drivers/acpi/apei/ghes.c | 40 +++++++++++++++++++++++-----------------
 include/acpi/ghes.h      |  1 -
 2 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 7c2e9ac140d4..acf0c37e9af9 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -305,29 +305,30 @@ static void ghes_copy_tofrom_phys(void *buffer, u64 paddr, u32 len,
 	}
 }
 
-static int ghes_read_estatus(struct ghes *ghes)
+static int ghes_read_estatus(struct ghes *ghes, u64 *buf_paddr)
 {
 	struct acpi_hest_generic *g = ghes->generic;
-	u64 buf_paddr;
 	u32 len;
 	int rc;
 
-	rc = apei_read(&buf_paddr, &g->error_status_address);
+	rc = apei_read(buf_paddr, &g->error_status_address);
 	if (rc) {
+		*buf_paddr = 0;
 		pr_warn_ratelimited(FW_WARN GHES_PFX
 "Failed to read error status block address for hardware error source: %d.\n",
 				   g->header.source_id);
 		return -EIO;
 	}
-	if (!buf_paddr)
+	if (!*buf_paddr)
 		return -ENOENT;
 
-	ghes_copy_tofrom_phys(ghes->estatus, buf_paddr,
+	ghes_copy_tofrom_phys(ghes->estatus, *buf_paddr,
 			      sizeof(*ghes->estatus), 1);
-	if (!ghes->estatus->block_status)
+	if (!ghes->estatus->block_status) {
+		*buf_paddr = 0;
 		return -ENOENT;
+	}
 
-	ghes->buffer_paddr = buf_paddr;
 	ghes->flags |= GHES_TO_CLEAR;
 
 	rc = -EIO;
@@ -339,7 +340,7 @@ static int ghes_read_estatus(struct ghes *ghes)
 	if (cper_estatus_check_header(ghes->estatus))
 		goto err_read_block;
 	ghes_copy_tofrom_phys(ghes->estatus + 1,
-			      buf_paddr + sizeof(*ghes->estatus),
+			      *buf_paddr + sizeof(*ghes->estatus),
 			      len - sizeof(*ghes->estatus), 1);
 	if (cper_estatus_check(ghes->estatus))
 		goto err_read_block;
@@ -349,17 +350,20 @@ static int ghes_read_estatus(struct ghes *ghes)
 	if (rc)
 		pr_warn_ratelimited(FW_WARN GHES_PFX
 				    "Failed to read error status block!\n");
+
 	return rc;
 }
 
-static void ghes_clear_estatus(struct ghes *ghes)
+static void ghes_clear_estatus(struct ghes *ghes, u64 buf_paddr)
 {
 	ghes->estatus->block_status = 0;
 	if (!(ghes->flags & GHES_TO_CLEAR))
 		return;
-	ghes_copy_tofrom_phys(ghes->estatus, ghes->buffer_paddr,
-			      sizeof(ghes->estatus->block_status), 0);
-	ghes->flags &= ~GHES_TO_CLEAR;
+	if (buf_paddr) {
+		ghes_copy_tofrom_phys(ghes->estatus, buf_paddr,
+				      sizeof(ghes->estatus->block_status), 0);
+		ghes->flags &= ~GHES_TO_CLEAR;
+	}
 }
 
 static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int sev)
@@ -678,9 +682,10 @@ static void __ghes_panic(struct ghes *ghes)
 
 static int ghes_proc(struct ghes *ghes)
 {
+	u64 buf_paddr;
 	int rc;
 
-	rc = ghes_read_estatus(ghes);
+	rc = ghes_read_estatus(ghes, &buf_paddr);
 	if (rc)
 		goto out;
 
@@ -695,7 +700,7 @@ static int ghes_proc(struct ghes *ghes)
 	ghes_do_proc(ghes, ghes->estatus);
 
 out:
-	ghes_clear_estatus(ghes);
+	ghes_clear_estatus(ghes, buf_paddr);
 
 	if (rc == -ENOENT)
 		return rc;
@@ -910,6 +915,7 @@ static void __process_error(struct ghes *ghes)
 
 static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 {
+	u64 buf_paddr;
 	struct ghes *ghes;
 	int sev, ret = NMI_DONE;
 
@@ -917,8 +923,8 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 		return ret;
 
 	list_for_each_entry_rcu(ghes, &ghes_nmi, list) {
-		if (ghes_read_estatus(ghes)) {
-			ghes_clear_estatus(ghes);
+		if (ghes_read_estatus(ghes, &buf_paddr)) {
+			ghes_clear_estatus(ghes, buf_paddr);
 			continue;
 		} else {
 			ret = NMI_HANDLED;
@@ -934,7 +940,7 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 			continue;
 
 		__process_error(ghes);
-		ghes_clear_estatus(ghes);
+		ghes_clear_estatus(ghes, buf_paddr);
 	}
 
 #ifdef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
index cd9ee507d860..f82f4a7ddd90 100644
--- a/include/acpi/ghes.h
+++ b/include/acpi/ghes.h
@@ -22,7 +22,6 @@ struct ghes {
 		struct acpi_hest_generic_v2 *generic_v2;
 	};
 	struct acpi_hest_generic_status *estatus;
-	u64 buffer_paddr;
 	unsigned long flags;
 	union {
 		struct list_head list;
-- 
2.19.2
