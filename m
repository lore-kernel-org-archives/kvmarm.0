From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v6 10/18] kvm: arm64: Make stage2 page table layout dynamic
Date: Wed, 26 Sep 2018 17:32:46 +0100
Message-ID: <20180926163258.20218-11-suzuki.poulose@arm.com>
References: <20180926163258.20218-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180926163258.20218-1-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, cdall@kernel.org, eric.auger@redhat.com, suzuki.poulose@arm.com, will.deacon@arm.com, dave.martin@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, julien.grall@arm.com, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Switch to dynamic stage2 page table layout based on the given
VM. So far we had a common stage2 table layout determined at
compile time. Make decision based on the VM instance depending
on the IPA limit for the VM. Adds helpers to compute the stage2
parameters based on the guest's IPA and uses them to make the decisions.

The IPA limit is still fixed to 40bits and the build time check
to ensure the stage2 doesn't exceed the host kernels page table
levels is retained. Also make sure that we use the pud/pmd level
helpers from the host only when they are not folded.

Cc: Christoffer Dall <cdall@kernel.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Change since v5:
 - Reword commit description
 - Use "lvls" instead of "n" for pt_levels_pgdir_shift()
---
 arch/arm64/include/asm/stage2_pgtable.h | 84 +++++++++++++++----------
 1 file changed, 52 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
index 384f9e982cba..36a0a1165003 100644
--- a/arch/arm64/include/asm/stage2_pgtable.h
+++ b/arch/arm64/include/asm/stage2_pgtable.h
@@ -22,6 +22,13 @@
 #include <linux/hugetlb.h>
 #include <asm/pgtable.h>
 
+/*
+ * PGDIR_SHIFT determines the size a top-level page table entry can map
+ * and depends on the number of levels in the page table. Compute the
+ * PGDIR_SHIFT for a given number of levels.
+ */
+#define pt_levels_pgdir_shift(lvls)	ARM64_HW_PGTABLE_LEVEL_SHIFT(4 - (lvls))
+
 /*
  * The hardware supports concatenation of up to 16 tables at stage2 entry level
  * and we use the feature whenever possible.
@@ -30,11 +37,13 @@
  * On arm64, the smallest PAGE_SIZE supported is 4k, which means
  *             (PAGE_SHIFT - 3) > 4 holds for all page sizes.
  * This implies, the total number of page table levels at stage2 expected
- * by the hardware is actually the number of levels required for (KVM_PHYS_SHIFT - 4)
+ * by the hardware is actually the number of levels required for (IPA_SHIFT - 4)
  * in normal translations(e.g, stage1), since we cannot have another level in
- * the range (KVM_PHYS_SHIFT, KVM_PHYS_SHIFT - 4).
+ * the range (IPA_SHIFT, IPA_SHIFT - 4).
  */
-#define STAGE2_PGTABLE_LEVELS		ARM64_HW_PGTABLE_LEVELS(KVM_PHYS_SHIFT - 4)
+#define stage2_pgtable_levels(ipa)	ARM64_HW_PGTABLE_LEVELS((ipa) - 4)
+#define STAGE2_PGTABLE_LEVELS		stage2_pgtable_levels(KVM_PHYS_SHIFT)
+#define kvm_stage2_levels(kvm)		stage2_pgtable_levels(kvm_phys_shift(kvm))
 
 /*
  * With all the supported VA_BITs and 40bit guest IPA, the following condition
@@ -54,33 +63,42 @@
 #error "Unsupported combination of guest IPA and host VA_BITS."
 #endif
 
-/* S2_PGDIR_SHIFT is the size mapped by top-level stage2 entry */
-#define S2_PGDIR_SHIFT			ARM64_HW_PGTABLE_LEVEL_SHIFT(4 - STAGE2_PGTABLE_LEVELS)
-#define S2_PGDIR_SIZE			(1UL << S2_PGDIR_SHIFT)
-#define S2_PGDIR_MASK			(~(S2_PGDIR_SIZE - 1))
+
+/* stage2_pgdir_shift() is the size mapped by top-level stage2 entry for the VM */
+#define stage2_pgdir_shift(kvm)		pt_levels_pgdir_shift(kvm_stage2_levels(kvm))
+#define stage2_pgdir_size(kvm)		(1ULL << stage2_pgdir_shift(kvm))
+#define stage2_pgdir_mask(kvm)		~(stage2_pgdir_size(kvm) - 1)
 
 /*
  * The number of PTRS across all concatenated stage2 tables given by the
  * number of bits resolved at the initial level.
  */
-#define PTRS_PER_S2_PGD			(1 << (KVM_PHYS_SHIFT - S2_PGDIR_SHIFT))
+#define __s2_pgd_ptrs(ipa, lvls)	(1 << ((ipa) - pt_levels_pgdir_shift((lvls))))
+#define __s2_pgd_size(ipa, lvls)	(__s2_pgd_ptrs((ipa), (lvls)) * sizeof(pgd_t))
+
+#define stage2_pgd_ptrs(kvm)		__s2_pgd_ptrs(kvm_phys_shift(kvm), kvm_stage2_levels(kvm))
+#define stage2_pgd_size(kvm)		__s2_pgd_size(kvm_phys_shift(kvm), kvm_stage2_levels(kvm))
 
 /*
  * kvm_mmmu_cache_min_pages() is the number of pages required to install
  * a stage-2 translation. We pre-allocate the entry level page table at
  * the VM creation.
  */
-#define kvm_mmu_cache_min_pages(kvm)	(STAGE2_PGTABLE_LEVELS - 1)
+#define kvm_mmu_cache_min_pages(kvm)	(kvm_stage2_levels(kvm) - 1)
 
 /* Stage2 PUD definitions when the level is present */
-#define STAGE2_PGTABLE_HAS_PUD		(STAGE2_PGTABLE_LEVELS > 3)
+static inline bool kvm_stage2_has_pud(struct kvm *kvm)
+{
+	return (CONFIG_PGTABLE_LEVELS > 3) && (kvm_stage2_levels(kvm) > 3);
+}
+
 #define S2_PUD_SHIFT			ARM64_HW_PGTABLE_LEVEL_SHIFT(1)
 #define S2_PUD_SIZE			(1UL << S2_PUD_SHIFT)
 #define S2_PUD_MASK			(~(S2_PUD_SIZE - 1))
 
 static inline bool stage2_pgd_none(struct kvm *kvm, pgd_t pgd)
 {
-	if (STAGE2_PGTABLE_HAS_PUD)
+	if (kvm_stage2_has_pud(kvm))
 		return pgd_none(pgd);
 	else
 		return 0;
@@ -88,13 +106,13 @@ static inline bool stage2_pgd_none(struct kvm *kvm, pgd_t pgd)
 
 static inline void stage2_pgd_clear(struct kvm *kvm, pgd_t *pgdp)
 {
-	if (STAGE2_PGTABLE_HAS_PUD)
+	if (kvm_stage2_has_pud(kvm))
 		pgd_clear(pgdp);
 }
 
 static inline bool stage2_pgd_present(struct kvm *kvm, pgd_t pgd)
 {
-	if (STAGE2_PGTABLE_HAS_PUD)
+	if (kvm_stage2_has_pud(kvm))
 		return pgd_present(pgd);
 	else
 		return 1;
@@ -102,14 +120,14 @@ static inline bool stage2_pgd_present(struct kvm *kvm, pgd_t pgd)
 
 static inline void stage2_pgd_populate(struct kvm *kvm, pgd_t *pgd, pud_t *pud)
 {
-	if (STAGE2_PGTABLE_HAS_PUD)
+	if (kvm_stage2_has_pud(kvm))
 		pgd_populate(NULL, pgd, pud);
 }
 
 static inline pud_t *stage2_pud_offset(struct kvm *kvm,
 				       pgd_t *pgd, unsigned long address)
 {
-	if (STAGE2_PGTABLE_HAS_PUD)
+	if (kvm_stage2_has_pud(kvm))
 		return pud_offset(pgd, address);
 	else
 		return (pud_t *)pgd;
@@ -117,13 +135,13 @@ static inline pud_t *stage2_pud_offset(struct kvm *kvm,
 
 static inline void stage2_pud_free(struct kvm *kvm, pud_t *pud)
 {
-	if (STAGE2_PGTABLE_HAS_PUD)
+	if (kvm_stage2_has_pud(kvm))
 		pud_free(NULL, pud);
 }
 
 static inline bool stage2_pud_table_empty(struct kvm *kvm, pud_t *pudp)
 {
-	if (STAGE2_PGTABLE_HAS_PUD)
+	if (kvm_stage2_has_pud(kvm))
 		return kvm_page_empty(pudp);
 	else
 		return false;
@@ -132,7 +150,7 @@ static inline bool stage2_pud_table_empty(struct kvm *kvm, pud_t *pudp)
 static inline phys_addr_t
 stage2_pud_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 {
-	if (STAGE2_PGTABLE_HAS_PUD) {
+	if (kvm_stage2_has_pud(kvm)) {
 		phys_addr_t boundary = (addr + S2_PUD_SIZE) & S2_PUD_MASK;
 
 		return (boundary - 1 < end - 1) ? boundary : end;
@@ -142,14 +160,18 @@ stage2_pud_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 }
 
 /* Stage2 PMD definitions when the level is present */
-#define STAGE2_PGTABLE_HAS_PMD		(STAGE2_PGTABLE_LEVELS > 2)
+static inline bool kvm_stage2_has_pmd(struct kvm *kvm)
+{
+	return (CONFIG_PGTABLE_LEVELS > 2) && (kvm_stage2_levels(kvm) > 2);
+}
+
 #define S2_PMD_SHIFT			ARM64_HW_PGTABLE_LEVEL_SHIFT(2)
 #define S2_PMD_SIZE			(1UL << S2_PMD_SHIFT)
 #define S2_PMD_MASK			(~(S2_PMD_SIZE - 1))
 
 static inline bool stage2_pud_none(struct kvm *kvm, pud_t pud)
 {
-	if (STAGE2_PGTABLE_HAS_PMD)
+	if (kvm_stage2_has_pmd(kvm))
 		return pud_none(pud);
 	else
 		return 0;
@@ -157,13 +179,13 @@ static inline bool stage2_pud_none(struct kvm *kvm, pud_t pud)
 
 static inline void stage2_pud_clear(struct kvm *kvm, pud_t *pud)
 {
-	if (STAGE2_PGTABLE_HAS_PMD)
+	if (kvm_stage2_has_pmd(kvm))
 		pud_clear(pud);
 }
 
 static inline bool stage2_pud_present(struct kvm *kvm, pud_t pud)
 {
-	if (STAGE2_PGTABLE_HAS_PMD)
+	if (kvm_stage2_has_pmd(kvm))
 		return pud_present(pud);
 	else
 		return 1;
@@ -171,14 +193,14 @@ static inline bool stage2_pud_present(struct kvm *kvm, pud_t pud)
 
 static inline void stage2_pud_populate(struct kvm *kvm, pud_t *pud, pmd_t *pmd)
 {
-	if (STAGE2_PGTABLE_HAS_PMD)
+	if (kvm_stage2_has_pmd(kvm))
 		pud_populate(NULL, pud, pmd);
 }
 
 static inline pmd_t *stage2_pmd_offset(struct kvm *kvm,
 				       pud_t *pud, unsigned long address)
 {
-	if (STAGE2_PGTABLE_HAS_PMD)
+	if (kvm_stage2_has_pmd(kvm))
 		return pmd_offset(pud, address);
 	else
 		return (pmd_t *)pud;
@@ -186,13 +208,13 @@ static inline pmd_t *stage2_pmd_offset(struct kvm *kvm,
 
 static inline void stage2_pmd_free(struct kvm *kvm, pmd_t *pmd)
 {
-	if (STAGE2_PGTABLE_HAS_PMD)
+	if (kvm_stage2_has_pmd(kvm))
 		pmd_free(NULL, pmd);
 }
 
 static inline bool stage2_pud_huge(struct kvm *kvm, pud_t pud)
 {
-	if (STAGE2_PGTABLE_HAS_PMD)
+	if (kvm_stage2_has_pmd(kvm))
 		return pud_huge(pud);
 	else
 		return 0;
@@ -200,7 +222,7 @@ static inline bool stage2_pud_huge(struct kvm *kvm, pud_t pud)
 
 static inline bool stage2_pmd_table_empty(struct kvm *kvm, pmd_t *pmdp)
 {
-	if (STAGE2_PGTABLE_HAS_PMD)
+	if (kvm_stage2_has_pmd(kvm))
 		return kvm_page_empty(pmdp);
 	else
 		return 0;
@@ -209,7 +231,7 @@ static inline bool stage2_pmd_table_empty(struct kvm *kvm, pmd_t *pmdp)
 static inline phys_addr_t
 stage2_pmd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 {
-	if (STAGE2_PGTABLE_HAS_PMD) {
+	if (kvm_stage2_has_pmd(kvm)) {
 		phys_addr_t boundary = (addr + S2_PMD_SIZE) & S2_PMD_MASK;
 
 		return (boundary - 1 < end - 1) ? boundary : end;
@@ -223,17 +245,15 @@ static inline bool stage2_pte_table_empty(struct kvm *kvm, pte_t *ptep)
 	return kvm_page_empty(ptep);
 }
 
-#define stage2_pgd_size(kvm)	(PTRS_PER_S2_PGD * sizeof(pgd_t))
-
 static inline unsigned long stage2_pgd_index(struct kvm *kvm, phys_addr_t addr)
 {
-	return (((addr) >> S2_PGDIR_SHIFT) & (PTRS_PER_S2_PGD - 1));
+	return (((addr) >> stage2_pgdir_shift(kvm)) & (stage2_pgd_ptrs(kvm) - 1));
 }
 
 static inline phys_addr_t
 stage2_pgd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 {
-	phys_addr_t boundary = (addr + S2_PGDIR_SIZE) & S2_PGDIR_MASK;
+	phys_addr_t boundary = (addr + stage2_pgdir_size(kvm)) & stage2_pgdir_mask(kvm);
 
 	return (boundary - 1 < end - 1) ? boundary : end;
 }
-- 
2.19.0
