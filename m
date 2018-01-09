From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v1 11/16] kvm: arm64: Make stage2 page table layout dynamic
Date: Tue,  9 Jan 2018 19:04:06 +0000
Message-ID: <20180109190414.4017-12-suzuki.poulose@arm.com>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5148B49D51
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jan 2018 14:00:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GlPY8SjmF8XR for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jan 2018 14:00:36 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CD5E49D95
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jan 2018 14:00:36 -0500 (EST)
In-Reply-To: <20180109190414.4017-1-suzuki.poulose@arm.com>
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
Cc: ard.biesheuvel@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, Christoffer Dall <cdall@linaro.org>, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

So far we had a static stage2 page table handling code, based on a
fixed IPA of 40bits. As we prepare for a configurable IPA size per
VM, make the our stage2 page table code dynamic to do the right thing
for a given VM.

Support for the IPA size configuration needs other changes in the way
we configure the EL2 registers (VTTBR and VTCR). So, the IPA is still
fixed to 40bits.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h                |   1 +
 arch/arm64/include/asm/kvm_mmu.h              |  16 +-
 arch/arm64/include/asm/stage2_pgtable-nopmd.h |  42 ------
 arch/arm64/include/asm/stage2_pgtable-nopud.h |  39 -----
 arch/arm64/include/asm/stage2_pgtable.h       | 203 +++++++++++++++++---------
 virt/kvm/arm/arm.c                            |   2 +-
 6 files changed, 147 insertions(+), 156 deletions(-)
 delete mode 100644 arch/arm64/include/asm/stage2_pgtable-nopmd.h
 delete mode 100644 arch/arm64/include/asm/stage2_pgtable-nopud.h

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index a3312f87a6e0..440c80589453 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -45,6 +45,7 @@
 #define kvm_phys_shift(kvm)		KVM_PHYS_SHIFT
 #define kvm_phys_size(kvm)		(_AC(1, ULL) << kvm_phys_shift(kvm))
 #define kvm_phys_mask(kvm)		(kvm_phys_size(kvm) - _AC(1, ULL))
+#define kvm_vttbr_baddr_mask(kvm)	VTTBR_BADDR_MASK
 
 #define stage2_pgd_size(kvm)	(PTRS_PER_S2_PGD * sizeof(pgd_t))
 int create_hyp_mappings(void *from, void *to, pgprot_t prot);
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index de542aa72d80..df2ee97f4428 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -18,9 +18,10 @@
 #ifndef __ARM64_KVM_MMU_H__
 #define __ARM64_KVM_MMU_H__
 
+#include <asm/cpufeature.h>
 #include <asm/page.h>
 #include <asm/memory.h>
-#include <asm/cpufeature.h>
+#include <asm/kvm_arm.h>
 
 /*
  * As ARMv8.0 only has the TTBR0_EL2 register, we cannot express
@@ -138,6 +139,13 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
 #define kvm_phys_shift(kvm)		KVM_PHYS_SHIFT
 #define kvm_phys_size(kvm)		(_AC(1, ULL) << kvm_phys_shift(kvm))
 #define kvm_phys_mask(kvm)		(kvm_phys_size(kvm) - _AC(1, ULL))
+#define kvm_vttbr_baddr_mask(kvm)	VTTBR_BADDR_MASK
+
+static inline bool kvm_page_empty(void *ptr)
+{
+	struct page *ptr_page = virt_to_page(ptr);
+	return page_count(ptr_page) == 1;
+}
 
 #include <asm/stage2_pgtable.h>
 
@@ -203,12 +211,6 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
 	return kvm_s2pte_readonly((pte_t *)pmd);
 }
 
-static inline bool kvm_page_empty(void *ptr)
-{
-	struct page *ptr_page = virt_to_page(ptr);
-	return page_count(ptr_page) == 1;
-}
-
 #define hyp_pte_table_empty(ptep) kvm_page_empty(ptep)
 
 #ifdef __PAGETABLE_PMD_FOLDED
diff --git a/arch/arm64/include/asm/stage2_pgtable-nopmd.h b/arch/arm64/include/asm/stage2_pgtable-nopmd.h
deleted file mode 100644
index 0280dedbf75f..000000000000
--- a/arch/arm64/include/asm/stage2_pgtable-nopmd.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- * Copyright (C) 2016 - ARM Ltd
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-
-#ifndef __ARM64_S2_PGTABLE_NOPMD_H_
-#define __ARM64_S2_PGTABLE_NOPMD_H_
-
-#include <asm/stage2_pgtable-nopud.h>
-
-#define __S2_PGTABLE_PMD_FOLDED
-
-#define S2_PMD_SHIFT		S2_PUD_SHIFT
-#define S2_PTRS_PER_PMD		1
-#define S2_PMD_SIZE		(1UL << S2_PMD_SHIFT)
-#define S2_PMD_MASK		(~(S2_PMD_SIZE-1))
-
-#define stage2_pud_none(kvm, pud)		(0)
-#define stage2_pud_present(kvm, pud)		(1)
-#define stage2_pud_clear(kvm, pud)		do { } while (0)
-#define stage2_pud_populate(kvm, pud, pmd)	do { } while (0)
-#define stage2_pmd_offset(kvm, pud, address)	((pmd_t *)(pud))
-
-#define stage2_pmd_free(kvm, pmd)		do { } while (0)
-
-#define stage2_pmd_addr_end(kvm, addr, end)	(end)
-
-#define stage2_pud_huge(kvm, pud)		(0)
-#define stage2_pmd_table_empty(kvm, pmdp)	(0)
-
-#endif
diff --git a/arch/arm64/include/asm/stage2_pgtable-nopud.h b/arch/arm64/include/asm/stage2_pgtable-nopud.h
deleted file mode 100644
index cd6304e203be..000000000000
--- a/arch/arm64/include/asm/stage2_pgtable-nopud.h
+++ /dev/null
@@ -1,39 +0,0 @@
-/*
- * Copyright (C) 2016 - ARM Ltd
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-
-#ifndef __ARM64_S2_PGTABLE_NOPUD_H_
-#define __ARM64_S2_PGTABLE_NOPUD_H_
-
-#define __S2_PGTABLE_PUD_FOLDED
-
-#define S2_PUD_SHIFT		S2_PGDIR_SHIFT
-#define S2_PTRS_PER_PUD		1
-#define S2_PUD_SIZE		(_AC(1, UL) << S2_PUD_SHIFT)
-#define S2_PUD_MASK		(~(S2_PUD_SIZE-1))
-
-#define stage2_pgd_none(kvm, pgd)		(0)
-#define stage2_pgd_present(kvm, pgd)		(1)
-#define stage2_pgd_clear(kvm, pgd)		do { } while (0)
-#define stage2_pgd_populate(kvm, pgd, pud)	do { } while (0)
-
-#define stage2_pud_offset(kvm, pgd, address)	((pud_t *)(pgd))
-
-#define stage2_pud_free(kvm, x)			do { } while (0)
-
-#define stage2_pud_addr_end(kvm, addr, end)	(end)
-#define stage2_pud_table_empty(kvm, pmdp)	(0)
-
-#endif
diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
index 057a405fa727..33e8ebb25037 100644
--- a/arch/arm64/include/asm/stage2_pgtable.h
+++ b/arch/arm64/include/asm/stage2_pgtable.h
@@ -21,6 +21,9 @@
 
 #include <asm/pgtable.h>
 
+/* The PGDIR shift for a given page table with "n" levels. */
+#define pt_levels_pgdir_shift(n)	ARM64_HW_PGTABLE_LEVEL_SHIFT(4 - (n))
+
 /*
  * The hardware supports concatenation of up to 16 tables at stage2 entry level
  * and we use the feature whenever possible.
@@ -29,118 +32,184 @@
  * On arm64, the smallest PAGE_SIZE supported is 4k, which means
  *             (PAGE_SHIFT - 3) > 4 holds for all page sizes.
  * This implies, the total number of page table levels at stage2 expected
- * by the hardware is actually the number of levels required for (KVM_PHYS_SHIFT - 4)
+ * by the hardware is actually the number of levels required for (IPA_SHIFT - 4)
  * in normal translations(e.g, stage1), since we cannot have another level in
- * the range (KVM_PHYS_SHIFT, KVM_PHYS_SHIFT - 4).
- */
-#define STAGE2_PGTABLE_LEVELS		ARM64_HW_PGTABLE_LEVELS(KVM_PHYS_SHIFT - 4)
-
-/*
- * With all the supported VA_BITs and 40bit guest IPA, the following condition
- * is always true:
- *
- *       STAGE2_PGTABLE_LEVELS <= CONFIG_PGTABLE_LEVELS
- *
- * We base our stage-2 page table walker helpers on this assumption and
- * fall back to using the host version of the helper wherever possible.
- * i.e, if a particular level is not folded (e.g, PUD) at stage2, we fall back
- * to using the host version, since it is guaranteed it is not folded at host.
- *
- * If the condition breaks in the future, we can rearrange the host level
- * definitions and reuse them for stage2. Till then...
+ * the range (IPA_SHIFT, IPA_SHIFT - 4).
  */
-#if STAGE2_PGTABLE_LEVELS > CONFIG_PGTABLE_LEVELS
-#error "Unsupported combination of guest IPA and host VA_BITS."
-#endif
-
-/* S2_PGDIR_SHIFT is the size mapped by top-level stage2 entry */
-#define S2_PGDIR_SHIFT			ARM64_HW_PGTABLE_LEVEL_SHIFT(4 - STAGE2_PGTABLE_LEVELS)
-#define S2_PGDIR_SIZE			(_AC(1, UL) << S2_PGDIR_SHIFT)
-#define S2_PGDIR_MASK			(~(S2_PGDIR_SIZE - 1))
+#define stage2_pt_levels(ipa_shift)	ARM64_HW_PGTABLE_LEVELS((ipa_shift) - 4)
 
 /*
  * The number of PTRS across all concatenated stage2 tables given by the
  * number of bits resolved at the initial level.
  */
-#define PTRS_PER_S2_PGD			(1 << (KVM_PHYS_SHIFT - S2_PGDIR_SHIFT))
+#define __s2_pgd_ptrs(pa, lvls)	(1 << ((pa) - pt_levels_pgdir_shift((lvls))))
+
+#define kvm_stage2_levels(kvm)		stage2_pt_levels(kvm_phys_shift(kvm))
+#define stage2_pgdir_shift(kvm)	\
+		pt_levels_pgdir_shift(kvm_stage2_levels(kvm))
+#define stage2_pgdir_size(kvm)		(_AC(1, UL) << stage2_pgdir_shift((kvm)))
+#define stage2_pgdir_mask(kvm)		(~(stage2_pgdir_size((kvm)) - 1))
+#define stage2_pgd_ptrs(kvm)	\
+	__s2_pgd_ptrs(kvm_phys_shift(kvm), kvm_stage2_levels(kvm))
+
 
 /*
  * kvm_mmmu_cache_min_pages is the number of stage2 page table translation
  * levels in addition to the PGD.
  */
-#define kvm_mmu_cache_min_pages(kvm)	(STAGE2_PGTABLE_LEVELS - 1)
+#define kvm_mmu_cache_min_pages(kvm)	(kvm_stage2_levels(kvm) - 1)
+
 
+/* PUD/PMD definitions if present */
+#define __S2_PUD_SHIFT			ARM64_HW_PGTABLE_LEVEL_SHIFT(1)
+#define __S2_PUD_SIZE			(_AC(1, UL) << __S2_PUD_SHIFT)
+#define __S2_PUD_MASK			(~(__S2_PUD_SIZE - 1))
 
-#if STAGE2_PGTABLE_LEVELS > 3
+#define __S2_PMD_SHIFT			ARM64_HW_PGTABLE_LEVEL_SHIFT(2)
+#define __S2_PMD_SIZE			(_AC(1, UL) << __S2_PMD_SHIFT)
+#define __S2_PMD_MASK			(~(__S2_PMD_SIZE - 1))
 
-#define S2_PUD_SHIFT			ARM64_HW_PGTABLE_LEVEL_SHIFT(1)
-#define S2_PUD_SIZE			(_AC(1, UL) << S2_PUD_SHIFT)
-#define S2_PUD_MASK			(~(S2_PUD_SIZE - 1))
+#define __s2_pud_index(addr) \
+	(((addr) >> __S2_PUD_SHIFT) & (PTRS_PER_PTE - 1))
+#define __s2_pmd_index(addr) \
+	(((addr) >> __S2_PMD_SHIFT) & (PTRS_PER_PTE - 1))
+
+static inline int stage2_pgd_none(struct kvm *kvm, pgd_t pgd)
+{
+	return (kvm_stage2_levels(kvm) > 3) ? __raw_pgd_none(pgd) : 0;
+}
+
+static inline void stage2_pgd_clear(struct kvm *kvm, pgd_t *pgdp)
+{
+	if (kvm_stage2_levels(kvm) > 3)
+		__raw_pgd_clear(pgdp);
+}
+
+static inline int stage2_pgd_present(struct kvm *kvm, pgd_t pgd)
+{
+	return kvm_stage2_levels(kvm) > 3 ? __raw_pgd_present(pgd) : 1;
+}
+
+static inline void stage2_pgd_populate(struct kvm *kvm, pgd_t *pgdp, pud_t *pud)
+{
+	if (kvm_stage2_levels(kvm) > 3)
+		__raw_pgd_populate(pgdp, __pa(pud), PUD_TYPE_TABLE);
+	else
+		BUG();
+}
+
+static inline pud_t *stage2_pud_offset(struct kvm *kvm,
+					 pgd_t *pgd, unsigned long address)
+{
+	if (kvm_stage2_levels(kvm) > 3) {
+		phys_addr_t pud_phys = __raw_pgd_page_paddr(*pgd);
+
+		pud_phys += __s2_pud_index(address) * sizeof(pud_t);
+		return __va(pud_phys);
+	}
+	return (pud_t *)pgd;
+}
 
-#define stage2_pgd_none(kvm, pgd)		pgd_none(pgd)
-#define stage2_pgd_clear(kvm, pgd)		pgd_clear(pgd)
-#define stage2_pgd_present(kvm, pgd)		pgd_present(pgd)
-#define stage2_pgd_populate(kvm, pgd, pud)	pgd_populate(NULL, pgd, pud)
-#define stage2_pud_offset(kvm, pgd, address)	pud_offset(pgd, address)
-#define stage2_pud_free(kvm, pud)		pud_free(NULL, pud)
+static inline void stage2_pud_free(struct kvm *kvm, pud_t *pud)
+{
+	if (kvm_stage2_levels(kvm) > 3)
+		__raw_pud_free(pud);
+}
 
-#define stage2_pud_table_empty(kvm, pudp)	kvm_page_empty(pudp)
+static inline int stage2_pud_table_empty(struct kvm *kvm, pud_t *pudp)
+{
+	return kvm_stage2_levels(kvm) > 3 && kvm_page_empty(pudp);
+}
 
 static inline phys_addr_t
 stage2_pud_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 {
-	phys_addr_t boundary = (addr + S2_PUD_SIZE) & S2_PUD_MASK;
+	if (kvm_stage2_levels(kvm) > 3) {
+		phys_addr_t boundary = (addr + __S2_PUD_SIZE) & __S2_PUD_MASK;
 
-	return (boundary - 1 < end - 1) ? boundary : end;
+		return (boundary - 1 < end - 1) ? boundary : end;
+	}
+	return end;
 }
 
-#endif		/* STAGE2_PGTABLE_LEVELS > 3 */
+static inline int stage2_pud_none(struct kvm *kvm, pud_t pud)
+{
+	return kvm_stage2_levels(kvm) > 2 ? __raw_pud_none(pud) : 0;
+}
 
+static inline void stage2_pud_clear(struct kvm *kvm, pud_t *pudp)
+{
+	if (kvm_stage2_levels(kvm) > 2)
+		__raw_pud_clear(pudp);
+}
 
-#if STAGE2_PGTABLE_LEVELS > 2
+static inline int stage2_pud_present(struct kvm *kvm, pud_t pud)
+{
+	return kvm_stage2_levels(kvm) > 2 ? __raw_pud_present(pud) : 1;
+}
 
-#define S2_PMD_SHIFT			ARM64_HW_PGTABLE_LEVEL_SHIFT(2)
-#define S2_PMD_SIZE			(_AC(1, UL) << S2_PMD_SHIFT)
-#define S2_PMD_MASK			(~(S2_PMD_SIZE - 1))
+static inline void stage2_pud_populate(struct kvm *kvm, pud_t *pudp, pmd_t *pmd)
+{
+	if (kvm_stage2_levels(kvm) > 2)
+		__raw_pud_populate(pudp, __pa(pmd), PMD_TYPE_TABLE);
+	else
+		BUG();
+}
 
-#define stage2_pud_none(kvm, pud)		pud_none(pud)
-#define stage2_pud_clear(kvm, pud)		pud_clear(pud)
-#define stage2_pud_present(kvm, pud)		pud_present(pud)
-#define stage2_pud_populate(kvm, pud, pmd)	pud_populate(NULL, pud, pmd)
-#define stage2_pmd_offset(kvm, pud, address)	pmd_offset(pud, address)
-#define stage2_pmd_free(kvm, pmd)		pmd_free(NULL, pmd)
+static inline pmd_t *stage2_pmd_offset(struct kvm *kvm,
+					 pud_t *pud, unsigned long address)
+{
+	if (kvm_stage2_levels(kvm) > 2) {
+		phys_addr_t pmd_phys = __raw_pud_page_paddr(*pud);
 
-#define stage2_pud_huge(kvm, pud)		pud_huge(pud)
-#define stage2_pmd_table_empty(kvm, pmdp)	kvm_page_empty(pmdp)
+		pmd_phys += __s2_pmd_index(address) * sizeof(pmd_t);
+		return __va(pmd_phys);
+	}
+	return (pmd_t *)pud;
+}
+
+static inline void stage2_pmd_free(struct kvm *kvm, pmd_t *pmd)
+{
+	if (kvm_stage2_levels(kvm) > 2)
+		__raw_pmd_free(pmd);
+}
+
+static inline int stage2_pmd_table_empty(struct kvm *kvm, pmd_t *pmdp)
+{
+	return kvm_stage2_levels(kvm) > 2 && kvm_page_empty(pmdp);
+}
 
 static inline phys_addr_t
 stage2_pmd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 {
-	phys_addr_t boundary = (addr + S2_PMD_SIZE) & S2_PMD_MASK;
+	if (kvm_stage2_levels(kvm) > 2) {
+		phys_addr_t boundary = (addr + __S2_PMD_SIZE) & __S2_PMD_MASK;
 
-	return (boundary - 1 < end - 1) ? boundary : end;
+		return (boundary - 1 < end - 1) ? boundary : end;
+	}
+	return end;
 }
 
-#endif		/* STAGE2_PGTABLE_LEVELS > 2 */
+static inline int stage2_pud_huge(struct kvm *kvm, pud_t pud)
+{
+	return kvm_stage2_levels(kvm) > 2 ? __raw_pud_huge(pud) : 0;
+}
 
 #define stage2_pte_table_empty(kvm, ptep)	kvm_page_empty(ptep)
 
-#if STAGE2_PGTABLE_LEVELS == 2
-#include <asm/stage2_pgtable-nopmd.h>
-#elif STAGE2_PGTABLE_LEVELS == 3
-#include <asm/stage2_pgtable-nopud.h>
-#endif
+#define stage2_pgd_size(kvm)		(stage2_pgd_ptrs(kvm) * sizeof(pgd_t))
 
-#define stage2_pgd_size(kvm)	(PTRS_PER_S2_PGD * sizeof(pgd_t))
-
-#define stage2_pgd_index(kvm, addr) \
-	(((addr) >> S2_PGDIR_SHIFT) & (PTRS_PER_S2_PGD - 1))
+static inline unsigned long stage2_pgd_index(struct kvm *kvm, phys_addr_t addr)
+{
+	return (addr >> stage2_pgdir_shift(kvm)) & (stage2_pgd_ptrs(kvm) - 1);
+}
 
 static inline phys_addr_t
 stage2_pgd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 {
-	phys_addr_t boundary = (addr + S2_PGDIR_SIZE) & S2_PGDIR_MASK;
+	phys_addr_t boundary;
 
+	boundary = (addr + stage2_pgdir_size(kvm)) & stage2_pgdir_mask(kvm);
 	return (boundary - 1 < end - 1) ? boundary : end;
 }
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index d06f00566664..8564ed907b18 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -502,7 +502,7 @@ static void update_vttbr(struct kvm *kvm)
 
 	/* update vttbr to be used with the new vmid */
 	pgd_phys = virt_to_phys(kvm->arch.pgd);
-	BUG_ON(pgd_phys & ~VTTBR_BADDR_MASK);
+	BUG_ON(pgd_phys & ~kvm_vttbr_baddr_mask(kvm));
 	vmid = ((u64)(kvm->arch.vmid) << VTTBR_VMID_SHIFT) & VTTBR_VMID_MASK(kvm_vmid_bits);
 	kvm->arch.vttbr = kvm_phys_to_vttbr(pgd_phys) | vmid;
 
-- 
2.13.6
