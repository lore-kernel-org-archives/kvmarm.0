From: James Morse <james.morse@arm.com>
Subject: [PATCH v7 17/25] ACPI / APEI: Pass ghes and estatus separately to
 avoid a later copy
Date: Mon,  3 Dec 2018 18:06:05 +0000
Message-ID: <20181203180613.228133-18-james.morse@arm.com>
References: <20181203180613.228133-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A6F324A2AC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 13:07:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DKkNcg75oUhZ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Dec 2018 13:07:38 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B1904A1DF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 13:07:38 -0500 (EST)
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

The NMI-like notifications scribble over ghes->estatus, before
copying it somewhere else. If this interrupts the ghes_probe() code
calling ghes_proc() on each struct ghes, the data is corrupted.

All the NMI-like notifications should use a queued estatus entry
from the beginning, instead of the ghes version, then copying it.
To do this, break up any use of "ghes->estatus" so that all
functions take the estatus as an argument.

This patch just moves these ghes->estatus dereferences into separate
arguments, no change in behaviour. struct ghes becomes unused in
ghes_clear_estatus() as it only wanted ghes->estatus, which we now
pass directly. This is removed.

Signed-off-by: James Morse <james.morse@arm.com>

---
Changes since v6:
 * Changed subject
 * Renamed ghes_estatus to src_estatus, which is a little clearer
 * Removed struct ghes from ghes_clear_estatus() now that this becomes
   unused in this patch.
 * Mangled the commit message to be different
---
 drivers/acpi/apei/ghes.c | 84 +++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 39 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index b5c31f65a1c0..b70f5fd962cc 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -277,8 +277,9 @@ static void ghes_copy_tofrom_phys(void *buffer, u64 paddr, u32 len,
 	}
 }
 
-static int ghes_read_estatus(struct ghes *ghes, u64 *buf_paddr, int fixmap_idx)
-
+static int ghes_read_estatus(struct ghes *ghes,
+			     struct acpi_hest_generic_status *estatus,
+			     u64 *buf_paddr, int fixmap_idx)
 {
 	struct acpi_hest_generic *g = ghes->generic;
 	u32 len;
@@ -295,25 +296,25 @@ static int ghes_read_estatus(struct ghes *ghes, u64 *buf_paddr, int fixmap_idx)
 	if (!*buf_paddr)
 		return -ENOENT;
 
-	ghes_copy_tofrom_phys(ghes->estatus, *buf_paddr,
-			      sizeof(*ghes->estatus), 1, fixmap_idx);
-	if (!ghes->estatus->block_status) {
+	ghes_copy_tofrom_phys(estatus, *buf_paddr, sizeof(*estatus), 1,
+			      fixmap_idx);
+	if (!estatus->block_status) {
 		*buf_paddr = 0;
 		return -ENOENT;
 	}
 
 	rc = -EIO;
-	len = cper_estatus_len(ghes->estatus);
-	if (len < sizeof(*ghes->estatus))
+	len = cper_estatus_len(estatus);
+	if (len < sizeof(*estatus))
 		goto err_read_block;
 	if (len > ghes->generic->error_block_length)
 		goto err_read_block;
-	if (cper_estatus_check_header(ghes->estatus))
+	if (cper_estatus_check_header(estatus))
 		goto err_read_block;
-	ghes_copy_tofrom_phys(ghes->estatus + 1,
-			      *buf_paddr + sizeof(*ghes->estatus),
-			      len - sizeof(*ghes->estatus), 1, fixmap_idx);
-	if (cper_estatus_check(ghes->estatus))
+	ghes_copy_tofrom_phys(estatus + 1,
+			      *buf_paddr + sizeof(*estatus),
+			      len - sizeof(*estatus), 1, fixmap_idx);
+	if (cper_estatus_check(estatus))
 		goto err_read_block;
 	rc = 0;
 
@@ -325,12 +326,13 @@ static int ghes_read_estatus(struct ghes *ghes, u64 *buf_paddr, int fixmap_idx)
 	return rc;
 }
 
-static void ghes_clear_estatus(struct ghes *ghes, u64 buf_paddr, int fixmap_idx)
+static void ghes_clear_estatus(struct acpi_hest_generic_status *estatus,
+			       u64 buf_paddr, int fixmap_idx)
 {
-	ghes->estatus->block_status = 0;
+	estatus->block_status = 0;
 	if (buf_paddr)
-		ghes_copy_tofrom_phys(ghes->estatus, buf_paddr,
-				      sizeof(ghes->estatus->block_status), 0,
+		ghes_copy_tofrom_phys(estatus, buf_paddr,
+				      sizeof(estatus->block_status), 0,
 				      fixmap_idx);
 }
 
@@ -638,9 +640,10 @@ static int ghes_ack_error(struct acpi_hest_generic_v2 *gv2)
 	return apei_write(val, &gv2->read_ack_register);
 }
 
-static void __ghes_panic(struct ghes *ghes)
+static void __ghes_panic(struct ghes *ghes,
+			 struct acpi_hest_generic_status *estatus)
 {
-	__ghes_print_estatus(KERN_EMERG, ghes->generic, ghes->estatus);
+	__ghes_print_estatus(KERN_EMERG, ghes->generic, estatus);
 
 	/* reboot to log the error! */
 	if (!panic_timeout)
@@ -650,25 +653,25 @@ static void __ghes_panic(struct ghes *ghes)
 
 static int ghes_proc(struct ghes *ghes)
 {
+	struct acpi_hest_generic_status *estatus = ghes->estatus;
 	u64 buf_paddr;
 	int rc;
 
-	rc = ghes_read_estatus(ghes, &buf_paddr, FIX_APEI_GHES_IRQ);
+	rc = ghes_read_estatus(ghes, estatus, &buf_paddr, FIX_APEI_GHES_IRQ);
 	if (rc)
 		goto out;
 
-	if (ghes_severity(ghes->estatus->error_severity) >= GHES_SEV_PANIC) {
-		__ghes_panic(ghes);
-	}
+	if (ghes_severity(estatus->error_severity) >= GHES_SEV_PANIC)
+		__ghes_panic(ghes, estatus);
 
-	if (!ghes_estatus_cached(ghes->estatus)) {
-		if (ghes_print_estatus(NULL, ghes->generic, ghes->estatus))
-			ghes_estatus_cache_add(ghes->generic, ghes->estatus);
+	if (!ghes_estatus_cached(estatus)) {
+		if (ghes_print_estatus(NULL, ghes->generic, estatus))
+			ghes_estatus_cache_add(ghes->generic, estatus);
 	}
-	ghes_do_proc(ghes, ghes->estatus);
+	ghes_do_proc(ghes, estatus);
 
 out:
-	ghes_clear_estatus(ghes, buf_paddr, FIX_APEI_GHES_IRQ);
+	ghes_clear_estatus(estatus, buf_paddr, FIX_APEI_GHES_IRQ);
 
 	if (rc == -ENOENT)
 		return rc;
@@ -819,17 +822,20 @@ static void ghes_print_queued_estatus(void)
 }
 
 /* Save estatus for further processing in IRQ context */
-static void __process_error(struct ghes *ghes)
+static void __process_error(struct ghes *ghes,
+			    struct acpi_hest_generic_status *src_estatus)
 {
-#ifdef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
 	u32 len, node_len;
 	struct ghes_estatus_node *estatus_node;
 	struct acpi_hest_generic_status *estatus;
 
-	if (ghes_estatus_cached(ghes->estatus))
+	if (!IS_ENABLED(CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG))
 		return;
 
-	len = cper_estatus_len(ghes->estatus);
+	if (ghes_estatus_cached(src_estatus))
+		return;
+
+	len = cper_estatus_len(src_estatus);
 	node_len = GHES_ESTATUS_NODE_LEN(len);
 
 	estatus_node = (void *)gen_pool_alloc(ghes_estatus_pool, node_len);
@@ -839,29 +845,29 @@ static void __process_error(struct ghes *ghes)
 	estatus_node->ghes = ghes;
 	estatus_node->generic = ghes->generic;
 	estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
-	memcpy(estatus, ghes->estatus, len);
+	memcpy(estatus, src_estatus, len);
 	llist_add(&estatus_node->llnode, &ghes_estatus_llist);
-#endif
 }
 
 static int _in_nmi_notify_one(struct ghes *ghes, int fixmap_idx)
 {
+	struct acpi_hest_generic_status *estatus = ghes->estatus;
 	u64 buf_paddr;
 	int sev;
 
-	if (ghes_read_estatus(ghes, &buf_paddr, fixmap_idx)) {
-		ghes_clear_estatus(ghes, buf_paddr, fixmap_idx);
+	if (ghes_read_estatus(ghes, estatus, &buf_paddr, fixmap_idx)) {
+		ghes_clear_estatus(estatus, buf_paddr, fixmap_idx);
 		return -ENOENT;
 	}
 
-	sev = ghes_severity(ghes->estatus->error_severity);
+	sev = ghes_severity(estatus->error_severity);
 	if (sev >= GHES_SEV_PANIC) {
 		ghes_print_queued_estatus();
-		__ghes_panic(ghes);
+		__ghes_panic(ghes, estatus);
 	}
 
-	__process_error(ghes);
-	ghes_clear_estatus(ghes, buf_paddr, fixmap_idx);
+	__process_error(ghes, estatus);
+	ghes_clear_estatus(estatus, buf_paddr, fixmap_idx);
 
 	if (is_hest_type_generic_v2(ghes) && ghes_ack_error(ghes->generic_v2))
 		pr_warn_ratelimited(FW_WARN GHES_PFX
-- 
2.19.2
