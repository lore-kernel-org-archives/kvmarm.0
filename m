From: James Morse <james.morse@arm.com>
Subject: [PATCH v8 06/26] ACPI / APEI: Don't store CPER records physical
 address in struct ghes
Date: Tue, 29 Jan 2019 18:48:42 +0000
Message-ID: <20190129184902.102850-7-james.morse@arm.com>
References: <20190129184902.102850-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE4474A3C5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:49:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OvnzYGbbHrh2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Jan 2019 13:49:56 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90A2349E3E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:49:56 -0500 (EST)
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
Reviewed-by: Borislav Petkov <bp@suse.de>
---
Changes since v7:
 * Added buf_paddr to ghes_panic, as it wants to print the estatus

Changes since v6:
 * Moved earlier in the series
 * Added buf_adder = 0 on all the error paths, and test for it in
   ghes_estatus_clear() for extra sanity.
---
 drivers/acpi/apei/ghes.c | 46 +++++++++++++++++++++++-----------------
 include/acpi/ghes.h      |  1 -
 2 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 33144ab0661a..a34f79153b1a 100644
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
@@ -349,15 +350,20 @@ static int ghes_read_estatus(struct ghes *ghes)
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
+
+	if (!buf_paddr)
+		return;
+
+	ghes_copy_tofrom_phys(ghes->estatus, buf_paddr,
 			      sizeof(ghes->estatus->block_status), 0);
 	ghes->flags &= ~GHES_TO_CLEAR;
 }
@@ -666,11 +672,11 @@ static int ghes_ack_error(struct acpi_hest_generic_v2 *gv2)
 	return apei_write(val, &gv2->read_ack_register);
 }
 
-static void __ghes_panic(struct ghes *ghes)
+static void __ghes_panic(struct ghes *ghes, u64 buf_paddr)
 {
 	__ghes_print_estatus(KERN_EMERG, ghes->generic, ghes->estatus);
 
-	ghes_clear_estatus(ghes);
+	ghes_clear_estatus(ghes, buf_paddr);
 
 	/* reboot to log the error! */
 	if (!panic_timeout)
@@ -680,14 +686,15 @@ static void __ghes_panic(struct ghes *ghes)
 
 static int ghes_proc(struct ghes *ghes)
 {
+	u64 buf_paddr;
 	int rc;
 
-	rc = ghes_read_estatus(ghes);
+	rc = ghes_read_estatus(ghes, &buf_paddr);
 	if (rc)
 		goto out;
 
 	if (ghes_severity(ghes->estatus->error_severity) >= GHES_SEV_PANIC) {
-		__ghes_panic(ghes);
+		__ghes_panic(ghes, buf_paddr);
 	}
 
 	if (!ghes_estatus_cached(ghes->estatus)) {
@@ -697,7 +704,7 @@ static int ghes_proc(struct ghes *ghes)
 	ghes_do_proc(ghes, ghes->estatus);
 
 out:
-	ghes_clear_estatus(ghes);
+	ghes_clear_estatus(ghes, buf_paddr);
 
 	if (rc == -ENOENT)
 		return rc;
@@ -912,6 +919,7 @@ static void __process_error(struct ghes *ghes)
 
 static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 {
+	u64 buf_paddr;
 	struct ghes *ghes;
 	int sev, ret = NMI_DONE;
 
@@ -919,8 +927,8 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 		return ret;
 
 	list_for_each_entry_rcu(ghes, &ghes_nmi, list) {
-		if (ghes_read_estatus(ghes)) {
-			ghes_clear_estatus(ghes);
+		if (ghes_read_estatus(ghes, &buf_paddr)) {
+			ghes_clear_estatus(ghes, buf_paddr);
 			continue;
 		} else {
 			ret = NMI_HANDLED;
@@ -929,14 +937,14 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 		sev = ghes_severity(ghes->estatus->error_severity);
 		if (sev >= GHES_SEV_PANIC) {
 			ghes_print_queued_estatus();
-			__ghes_panic(ghes);
+			__ghes_panic(ghes, buf_paddr);
 		}
 
 		if (!(ghes->flags & GHES_TO_CLEAR))
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
2.20.1
