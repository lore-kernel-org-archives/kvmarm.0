From: James Morse <james.morse@arm.com>
Subject: [PATCH v8 16/26] ACPI / APEI: Let the notification helper specify the
 fixmap slot
Date: Tue, 29 Jan 2019 18:48:52 +0000
Message-ID: <20190129184902.102850-17-james.morse@arm.com>
References: <20190129184902.102850-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 479434A2E5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:50:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aGNR74gvJcKi for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Jan 2019 13:50:27 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB9B44A3D5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:50:25 -0500 (EST)
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

ghes_copy_tofrom_phys() uses a different fixmap slot depending on in_nmi().
This doesn't work when there are multiple NMI-like notifications, that
could interrupt each other.

As with the locking, move the chosen fixmap_idx to the notification helper.
This only matters for NMI-like notifications, anything calling
ghes_proc() can use the IRQ fixmap slot as its already holding an irqsave
spinlock.

This lets us collapse the ghes_ioremap_pfn_*() helpers.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Borislav Petkov <bp@suse.de>
---

The fixmap-idx and vaddr are passed back to ghes_unmap()
to allow ioremap() to be used in process context in the
future. This will let us send tlbi-ipi for notifications
that don't mask irqs.

Changes since v7:
 * Wwitched unmap arg order for concistency, p/v addr is always first
 * use the enum name for the fixmap_idx, in the hope the compiler validates it.
---
 drivers/acpi/apei/ghes.c | 92 +++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 53 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index c6bc73281d6a..ccad57468ab7 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -41,6 +41,7 @@
 #include <linux/llist.h>
 #include <linux/genalloc.h>
 #include <linux/pci.h>
+#include <linux/pfn.h>
 #include <linux/aer.h>
 #include <linux/nmi.h>
 #include <linux/sched/clock.h>
@@ -127,38 +128,24 @@ static atomic_t ghes_estatus_cache_alloced;
 
 static int ghes_panic_timeout __read_mostly = 30;
 
-static void __iomem *ghes_ioremap_pfn_nmi(u64 pfn)
+static void __iomem *ghes_map(u64 pfn, enum fixed_addresses fixmap_idx)
 {
 	phys_addr_t paddr;
 	pgprot_t prot;
 
-	paddr = pfn << PAGE_SHIFT;
+	paddr = PFN_PHYS(pfn);
 	prot = arch_apei_get_mem_attribute(paddr);
-	__set_fixmap(FIX_APEI_GHES_NMI, paddr, prot);
+	__set_fixmap(fixmap_idx, paddr, prot);
 
-	return (void __iomem *) fix_to_virt(FIX_APEI_GHES_NMI);
+	return (void __iomem *) __fix_to_virt(fixmap_idx);
 }
 
-static void __iomem *ghes_ioremap_pfn_irq(u64 pfn)
+static void ghes_unmap(void __iomem *vaddr, enum fixed_addresses fixmap_idx)
 {
-	phys_addr_t paddr;
-	pgprot_t prot;
-
-	paddr = pfn << PAGE_SHIFT;
-	prot = arch_apei_get_mem_attribute(paddr);
-	__set_fixmap(FIX_APEI_GHES_IRQ, paddr, prot);
+	int _idx = virt_to_fix((unsigned long)vaddr);
 
-	return (void __iomem *) fix_to_virt(FIX_APEI_GHES_IRQ);
-}
-
-static void ghes_iounmap_nmi(void)
-{
-	clear_fixmap(FIX_APEI_GHES_NMI);
-}
-
-static void ghes_iounmap_irq(void)
-{
-	clear_fixmap(FIX_APEI_GHES_IRQ);
+	WARN_ON_ONCE(fixmap_idx != _idx);
+	clear_fixmap(fixmap_idx);
 }
 
 int ghes_estatus_pool_init(int num_ghes)
@@ -283,20 +270,16 @@ static inline int ghes_severity(int severity)
 }
 
 static void ghes_copy_tofrom_phys(void *buffer, u64 paddr, u32 len,
-				  int from_phys)
+				  int from_phys,
+				  enum fixed_addresses fixmap_idx)
 {
 	void __iomem *vaddr;
-	int in_nmi = in_nmi();
 	u64 offset;
 	u32 trunk;
 
 	while (len > 0) {
 		offset = paddr - (paddr & PAGE_MASK);
-		if (in_nmi) {
-			vaddr = ghes_ioremap_pfn_nmi(paddr >> PAGE_SHIFT);
-		} else {
-			vaddr = ghes_ioremap_pfn_irq(paddr >> PAGE_SHIFT);
-		}
+		vaddr = ghes_map(PHYS_PFN(paddr), fixmap_idx);
 		trunk = PAGE_SIZE - offset;
 		trunk = min(trunk, len);
 		if (from_phys)
@@ -306,15 +289,13 @@ static void ghes_copy_tofrom_phys(void *buffer, u64 paddr, u32 len,
 		len -= trunk;
 		paddr += trunk;
 		buffer += trunk;
-		if (in_nmi) {
-			ghes_iounmap_nmi();
-		} else {
-			ghes_iounmap_irq();
-		}
+		ghes_unmap(vaddr, fixmap_idx);
 	}
 }
 
-static int ghes_read_estatus(struct ghes *ghes, u64 *buf_paddr)
+static int ghes_read_estatus(struct ghes *ghes, u64 *buf_paddr,
+			     enum fixed_addresses fixmap_idx)
+
 {
 	struct acpi_hest_generic *g = ghes->generic;
 	u32 len;
@@ -332,7 +313,7 @@ static int ghes_read_estatus(struct ghes *ghes, u64 *buf_paddr)
 		return -ENOENT;
 
 	ghes_copy_tofrom_phys(ghes->estatus, *buf_paddr,
-			      sizeof(*ghes->estatus), 1);
+			      sizeof(*ghes->estatus), 1, fixmap_idx);
 	if (!ghes->estatus->block_status) {
 		*buf_paddr = 0;
 		return -ENOENT;
@@ -348,7 +329,7 @@ static int ghes_read_estatus(struct ghes *ghes, u64 *buf_paddr)
 		goto err_read_block;
 	ghes_copy_tofrom_phys(ghes->estatus + 1,
 			      *buf_paddr + sizeof(*ghes->estatus),
-			      len - sizeof(*ghes->estatus), 1);
+			      len - sizeof(*ghes->estatus), 1, fixmap_idx);
 	if (cper_estatus_check(ghes->estatus))
 		goto err_read_block;
 	rc = 0;
@@ -361,7 +342,8 @@ static int ghes_read_estatus(struct ghes *ghes, u64 *buf_paddr)
 	return rc;
 }
 
-static void ghes_clear_estatus(struct ghes *ghes, u64 buf_paddr)
+static void ghes_clear_estatus(struct ghes *ghes, u64 buf_paddr,
+			       enum fixed_addresses fixmap_idx)
 {
 	ghes->estatus->block_status = 0;
 
@@ -369,7 +351,8 @@ static void ghes_clear_estatus(struct ghes *ghes, u64 buf_paddr)
 		return;
 
 	ghes_copy_tofrom_phys(ghes->estatus, buf_paddr,
-			      sizeof(ghes->estatus->block_status), 0);
+			      sizeof(ghes->estatus->block_status), 0,
+			      fixmap_idx);
 
 	/*
 	 * GHESv2 type HEST entries introduce support for error acknowledgment,
@@ -668,11 +651,12 @@ static void ghes_estatus_cache_add(
 	rcu_read_unlock();
 }
 
-static void __ghes_panic(struct ghes *ghes, u64 buf_paddr)
+static void __ghes_panic(struct ghes *ghes, u64 buf_paddr,
+			 enum fixed_addresses fixmap_idx)
 {
 	__ghes_print_estatus(KERN_EMERG, ghes->generic, ghes->estatus);
 
-	ghes_clear_estatus(ghes, buf_paddr);
+	ghes_clear_estatus(ghes, buf_paddr, fixmap_idx);
 
 	/* reboot to log the error! */
 	if (!panic_timeout)
@@ -685,12 +669,12 @@ static int ghes_proc(struct ghes *ghes)
 	u64 buf_paddr;
 	int rc;
 
-	rc = ghes_read_estatus(ghes, &buf_paddr);
+	rc = ghes_read_estatus(ghes, &buf_paddr, FIX_APEI_GHES_IRQ);
 	if (rc)
 		goto out;
 
 	if (ghes_severity(ghes->estatus->error_severity) >= GHES_SEV_PANIC) {
-		__ghes_panic(ghes, buf_paddr);
+		__ghes_panic(ghes, buf_paddr, FIX_APEI_GHES_IRQ);
 	}
 
 	if (!ghes_estatus_cached(ghes->estatus)) {
@@ -700,7 +684,7 @@ static int ghes_proc(struct ghes *ghes)
 	ghes_do_proc(ghes, ghes->estatus);
 
 out:
-	ghes_clear_estatus(ghes, buf_paddr);
+	ghes_clear_estatus(ghes, buf_paddr, FIX_APEI_GHES_IRQ);
 
 	return rc;
 }
@@ -866,36 +850,38 @@ static void __process_error(struct ghes *ghes)
 #endif
 }
 
-static int ghes_in_nmi_queue_one_entry(struct ghes *ghes)
+static int ghes_in_nmi_queue_one_entry(struct ghes *ghes,
+				       enum fixed_addresses fixmap_idx)
 {
 	u64 buf_paddr;
 	int sev;
 
-	if (ghes_read_estatus(ghes, &buf_paddr)) {
-		ghes_clear_estatus(ghes, buf_paddr);
+	if (ghes_read_estatus(ghes, &buf_paddr, fixmap_idx)) {
+		ghes_clear_estatus(ghes, buf_paddr, fixmap_idx);
 		return -ENOENT;
 	}
 
 	sev = ghes_severity(ghes->estatus->error_severity);
 	if (sev >= GHES_SEV_PANIC) {
 		ghes_print_queued_estatus();
-		__ghes_panic(ghes, buf_paddr);
+		__ghes_panic(ghes, buf_paddr, fixmap_idx);
 	}
 
 	__process_error(ghes);
-	ghes_clear_estatus(ghes, buf_paddr);
+	ghes_clear_estatus(ghes, buf_paddr, fixmap_idx);
 
 	return 0;
 }
 
-static int ghes_in_nmi_spool_from_list(struct list_head *rcu_list)
+static int ghes_in_nmi_spool_from_list(struct list_head *rcu_list,
+				       enum fixed_addresses fixmap_idx)
 {
 	int err, ret = -ENOENT;
 	struct ghes *ghes;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(ghes, rcu_list, list) {
-		err = ghes_in_nmi_queue_one_entry(ghes);
+		err = ghes_in_nmi_queue_one_entry(ghes, fixmap_idx);
 		if (!err)
 			ret = 0;
 	}
@@ -920,7 +906,7 @@ int ghes_notify_sea(void)
 	int rv;
 
 	raw_spin_lock(&ghes_notify_lock_sea);
-	rv = ghes_in_nmi_spool_from_list(&ghes_sea);
+	rv = ghes_in_nmi_spool_from_list(&ghes_sea, FIX_APEI_GHES_NMI);
 	raw_spin_unlock(&ghes_notify_lock_sea);
 
 	return rv;
@@ -963,7 +949,7 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 		return ret;
 
 	raw_spin_lock(&ghes_notify_lock_nmi);
-	err = ghes_in_nmi_spool_from_list(&ghes_nmi);
+	err = ghes_in_nmi_spool_from_list(&ghes_nmi, FIX_APEI_GHES_NMI);
 	if (!err)
 		ret = NMI_HANDLED;
 	raw_spin_unlock(&ghes_notify_lock_nmi);
-- 
2.20.1
