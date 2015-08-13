From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Subject: [PATCH 11/14] arm64: kvm: Rewrite fake pgd handling
Date: Thu, 13 Aug 2015 12:34:01 +0100
Message-ID: <1439465645-22584-12-git-send-email-suzuki.poulose@arm.com>
References: <1439465645-22584-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68C465AE40
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Aug 2015 07:21:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D8yUU+2ae7QF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Aug 2015 07:21:29 -0400 (EDT)
Received: from eu-smtp-delivery-143.mimecast.com
 (eu-smtp-delivery-143.mimecast.com [146.101.78.143])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1C6E5AE15
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Aug 2015 07:21:28 -0400 (EDT)
In-Reply-To: <1439465645-22584-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc.Zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>

The existing fake pgd handling code assumes that the stage-2 entry
level can only be one level down that of the host, which may not be
true always(e.g, with the introduction of 16k pagesize).

e.g.
With 16k page size and 48bit VA and 40bit IPA we have the following
split for page table levels:

level:  0       1         2         3
bits : [47] [46 - 36] [35 - 25] [24 - 14] [13 - 0]
         ^       ^     ^
         |       |     |
   host entry    |     x---- stage-2 entry
                 |
        IPA -----x

The stage-2 entry level is 2, due to the concatenation of 16tables
at level 2(mandated by the hardware). So, we need to fake two levels
to actually reach the hyp page table. This case cannot be handled
with the existing code, as, all we know about is KVM_PREALLOC_LEVEL
which kind of stands for two different pieces of information.

1) Whether we have fake page table entry levels.
2) The entry level of stage-2 translation.

We loose the information about the number of fake levels that
we may have to use. Also, KVM_PREALLOC_LEVEL computation itself
is wrong, as we assume the hw entry level is always 1 level down
from the host.

This patch introduces two seperate indicators :
1) Accurate entry level for stage-2 translation - HYP_PGTABLE_ENTRY_LEVEL -
   using the new helpers.
2) Number of levels of fake pagetable entries. (KVM_FAKE_PGTABLE_LEVELS)

The following conditions hold true for all cases(with 40bit IPA)
1) The stage-2 entry level <= 2
2) Number of fake page-table entries is in the inclusive range [0, 2].

Cc: kvmarm@lists.cs.columbia.edu
Cc: christoffer.dall@linaro.org
Cc: Marc.Zyngier@arm.com
Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h |  114 ++++++++++++++++++++------------------
 1 file changed, 61 insertions(+), 53 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 2567fe8..72cfd9e 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -41,18 +41,6 @@
  */
 #define TRAMPOLINE_VA		(HYP_PAGE_OFFSET_MASK & PAGE_MASK)
 
-/*
- * KVM_MMU_CACHE_MIN_PAGES is the number of stage2 page table translation
- * levels in addition to the PGD and potentially the PUD which are
- * pre-allocated (we pre-allocate the fake PGD and the PUD when the Stage-2
- * tables use one level of tables less than the kernel.
- */
-#ifdef CONFIG_ARM64_64K_PAGES
-#define KVM_MMU_CACHE_MIN_PAGES	1
-#else
-#define KVM_MMU_CACHE_MIN_PAGES	2
-#endif
-
 #ifdef __ASSEMBLY__
 
 /*
@@ -80,6 +68,26 @@
 #define KVM_PHYS_SIZE	(1UL << KVM_PHYS_SHIFT)
 #define KVM_PHYS_MASK	(KVM_PHYS_SIZE - 1UL)
 
+/*
+ * At stage-2 entry level, upto 16 tables can be concatenated and
+ * the hardware expects us to use concatenation, whenever possible.
+ * So, number of page table levels for KVM_PHYS_SHIFT is always
+ * the number of normal page table levels for (KVM_PHYS_SHIFT - 4).
+ */
+#define HYP_PGTABLE_LEVELS	ARM64_HW_PGTABLE_LEVELS(KVM_PHYS_SHIFT - 4)
+/* Number of bits normally addressed by HYP_PGTABLE_LEVELS */
+#define HYP_PGTABLE_SHIFT	ARM64_HW_PGTABLE_LEVEL_SHIFT(HYP_PGTABLE_LEVELS + 1)
+#define HYP_PGDIR_SHIFT		ARM64_HW_PGTABLE_LEVEL_SHIFT(HYP_PGTABLE_LEVELS)
+#define HYP_PGTABLE_ENTRY_LEVEL	(4 - HYP_PGTABLE_LEVELS)
+
+/*
+ * KVM_MMU_CACHE_MIN_PAGES is the number of stage2 page table translation
+ * levels in addition to the PGD and potentially the PUD which are
+ * pre-allocated (we pre-allocate the fake PGD and the PUD when the Stage-2
+ * tables use one level of tables less than the kernel.
+ */
+#define KVM_MMU_CACHE_MIN_PAGES	(HYP_PGTABLE_LEVELS - 1)
+
 int create_hyp_mappings(void *from, void *to);
 int create_hyp_io_mappings(void *from, void *to, phys_addr_t);
 void free_boot_hyp_pgd(void);
@@ -145,56 +153,41 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
 #define kvm_pud_addr_end(addr, end)	pud_addr_end(addr, end)
 #define kvm_pmd_addr_end(addr, end)	pmd_addr_end(addr, end)
 
-/*
- * In the case where PGDIR_SHIFT is larger than KVM_PHYS_SHIFT, we can address
- * the entire IPA input range with a single pgd entry, and we would only need
- * one pgd entry.  Note that in this case, the pgd is actually not used by
- * the MMU for Stage-2 translations, but is merely a fake pgd used as a data
- * structure for the kernel pgtable macros to work.
- */
-#if PGDIR_SHIFT > KVM_PHYS_SHIFT
-#define PTRS_PER_S2_PGD_SHIFT	0
+/* Number of concatenated tables in stage-2 entry level */
+#if KVM_PHYS_SHIFT > HYP_PGTABLE_SHIFT
+#define S2_ENTRY_TABLES_SHIFT	(KVM_PHYS_SHIFT - HYP_PGTABLE_SHIFT)
 #else
-#define PTRS_PER_S2_PGD_SHIFT	(KVM_PHYS_SHIFT - PGDIR_SHIFT)
+#define S2_ENTRY_TABLES_SHIFT	0
 #endif
+#define S2_ENTRY_TABLES		(1 << (S2_ENTRY_TABLES_SHIFT))
+
+/* Number of page table levels we fake to reach the hw pgtable for hyp */
+#define KVM_FAKE_PGTABLE_LEVELS	(CONFIG_PGTABLE_LEVELS - HYP_PGTABLE_LEVELS)
+
+#define PTRS_PER_S2_PGD_SHIFT	(KVM_PHYS_SHIFT - HYP_PGDIR_SHIFT)
 #define PTRS_PER_S2_PGD		(1 << PTRS_PER_S2_PGD_SHIFT)
 #define S2_PGD_ORDER		get_order(PTRS_PER_S2_PGD * sizeof(pgd_t))
 
 #define kvm_pgd_index(addr)	(((addr) >> PGDIR_SHIFT) & (PTRS_PER_S2_PGD - 1))
 
-/*
- * If we are concatenating first level stage-2 page tables, we would have less
- * than or equal to 16 pointers in the fake PGD, because that's what the
- * architecture allows.  In this case, (4 - CONFIG_PGTABLE_LEVELS)
- * represents the first level for the host, and we add 1 to go to the next
- * level (which uses contatenation) for the stage-2 tables.
- */
-#if PTRS_PER_S2_PGD <= 16
-#define KVM_PREALLOC_LEVEL	(4 - CONFIG_PGTABLE_LEVELS + 1)
-#else
-#define KVM_PREALLOC_LEVEL	(0)
-#endif
-
 static inline void *kvm_get_hwpgd(struct kvm *kvm)
 {
 	pgd_t *pgd = kvm->arch.pgd;
 	pud_t *pud;
 
-	if (KVM_PREALLOC_LEVEL == 0)
+	if (KVM_FAKE_PGTABLE_LEVELS == 0)
 		return pgd;
 
 	pud = pud_offset(pgd, 0);
-	if (KVM_PREALLOC_LEVEL == 1)
+	if (HYP_PGTABLE_ENTRY_LEVEL == 1)
 		return pud;
 
-	BUG_ON(KVM_PREALLOC_LEVEL != 2);
+	BUG_ON(HYP_PGTABLE_ENTRY_LEVEL != 2);
 	return pmd_offset(pud, 0);
 }
 
 static inline unsigned int kvm_get_hwpgd_size(void)
 {
-	if (KVM_PREALLOC_LEVEL > 0)
-		return PTRS_PER_S2_PGD * PAGE_SIZE;
 	return PTRS_PER_S2_PGD * sizeof(pgd_t);
 }
 
@@ -207,27 +200,38 @@ static inline pgd_t* kvm_setup_fake_pgd(pgd_t *hwpgd)
 {
 	int i;
 	pgd_t *pgd;
+	pud_t *pud;
 
-	if (!KVM_PREALLOC_LEVEL)
+	if (KVM_FAKE_PGTABLE_LEVELS == 0)
 		return hwpgd;
-	/*
-	 * When KVM_PREALLOC_LEVEL==2, we allocate a single page for
-	 * the PMD and the kernel will use folded pud.
-	 * When KVM_PREALLOC_LEVEL==1, we allocate 2 consecutive PUD
-	 * pages.
-	 */
+
 	pgd = kmalloc(PTRS_PER_S2_PGD * sizeof(pgd_t),
 			GFP_KERNEL | __GFP_ZERO);
 
 	if (!pgd)
 		return ERR_PTR(-ENOMEM);
+	/*
+	 * If the stage-2 entry is two level down from that of the host,
+	 * we are using a 4-level table on host (since HYP_PGTABLE_ENTRY_LEVEL
+	 * cannot be < 2. So, this implies we need to allocat a PUD table
+	 * to map the concatenated PMD tables.
+	 */
+	if (KVM_FAKE_PGTABLE_LEVELS == 2) {
+		pud = (pud_t *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 0);
+		if (!pud) {
+			kfree(pgd);
+			return ERR_PTR(-ENOMEM);
+		}
+		/* plug the pud into the PGD */
+		pgd_populate(NULL, pgd, pud);
+	}
 
 	/* Plug the HW PGD into the fake one. */
-	for (i = 0; i < PTRS_PER_S2_PGD; i++) {
-		if (KVM_PREALLOC_LEVEL == 1)
+	for (i = 0; i < S2_ENTRY_TABLES; i++) {
+		if (HYP_PGTABLE_ENTRY_LEVEL == 1)
 			pgd_populate(NULL, pgd + i,
 				     (pud_t *)hwpgd + i * PTRS_PER_PUD);
-		else if (KVM_PREALLOC_LEVEL == 2)
+		else if (HYP_PGTABLE_ENTRY_LEVEL == 2)
 			pud_populate(NULL, pud_offset(pgd, 0) + i,
 				     (pmd_t *)hwpgd + i * PTRS_PER_PMD);
 	}
@@ -237,8 +241,12 @@ static inline pgd_t* kvm_setup_fake_pgd(pgd_t *hwpgd)
 
 static inline void kvm_free_fake_pgd(pgd_t *pgd)
 {
-	if (KVM_PREALLOC_LEVEL > 0)
+	if (KVM_FAKE_PGTABLE_LEVELS > 0) {
+		/* free the PUD table */
+		if (KVM_FAKE_PGTABLE_LEVELS == 2)
+			free_page((unsigned long)pud_offset(pgd, 0));
 		kfree(pgd);
+	}
 }
 
 static inline bool kvm_page_empty(void *ptr)
@@ -253,14 +261,14 @@ static inline bool kvm_page_empty(void *ptr)
 #define kvm_pmd_table_empty(kvm, pmdp) (0)
 #else
 #define kvm_pmd_table_empty(kvm, pmdp) \
-	(kvm_page_empty(pmdp) && (!(kvm) || KVM_PREALLOC_LEVEL < 2))
+	(kvm_page_empty(pmdp) && (!(kvm) || HYP_PGTABLE_ENTRY_LEVEL < 2))
 #endif
 
 #ifdef __PAGETABLE_PUD_FOLDED
 #define kvm_pud_table_empty(kvm, pudp) (0)
 #else
 #define kvm_pud_table_empty(kvm, pudp) \
-	(kvm_page_empty(pudp) && (!(kvm) || KVM_PREALLOC_LEVEL < 1))
+	(kvm_page_empty(pudp) && (!(kvm) || HYP_PGTABLE_ENTRY_LEVEL < 1))
 #endif
 
 
-- 
1.7.9.5
