From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v1 10/16] kvm: arm/arm64: Prepare for VM specific stage2
 translations
Date: Tue,  9 Jan 2018 19:04:05 +0000
Message-ID: <20180109190414.4017-11-suzuki.poulose@arm.com>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C613549D95
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jan 2018 14:00:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XVmluBcmnejw for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jan 2018 14:00:33 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5384B49DB4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jan 2018 14:00:33 -0500 (EST)
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

Right now the stage2 page table for a VM is hard coded, assuming
an IPA of 40bits. As we are about to add support for per VM IPA,
prepare the stage2 page table helpers to accept the kvm instance
to make the right decision. No functional changes.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/include/asm/kvm_arm.h                |   2 -
 arch/arm/include/asm/kvm_mmu.h                |  11 ++-
 arch/arm/include/asm/stage2_pgtable.h         |  46 ++++++-----
 arch/arm64/include/asm/kvm_mmu.h              |   6 +-
 arch/arm64/include/asm/pgtable.h              |   2 +-
 arch/arm64/include/asm/stage2_pgtable-nopmd.h |  18 ++--
 arch/arm64/include/asm/stage2_pgtable-nopud.h |  16 ++--
 arch/arm64/include/asm/stage2_pgtable.h       |  49 ++++++-----
 virt/kvm/arm/mmu.c                            | 114 +++++++++++++-------------
 virt/kvm/arm/vgic/vgic-kvm-device.c           |   2 +-
 10 files changed, 140 insertions(+), 126 deletions(-)

diff --git a/arch/arm/include/asm/kvm_arm.h b/arch/arm/include/asm/kvm_arm.h
index 3ab8b3781bfe..4ebaf0c29723 100644
--- a/arch/arm/include/asm/kvm_arm.h
+++ b/arch/arm/include/asm/kvm_arm.h
@@ -133,8 +133,6 @@
  * space.
  */
 #define KVM_PHYS_SHIFT	(40)
-#define KVM_PHYS_SIZE	(_AC(1, ULL) << KVM_PHYS_SHIFT)
-#define KVM_PHYS_MASK	(KVM_PHYS_SIZE - _AC(1, ULL))
 #define PTRS_PER_S2_PGD	(_AC(1, ULL) << (KVM_PHYS_SHIFT - 30))
 
 /* Virtualization Translation Control Register (VTCR) bits */
diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 8c5643e2eea4..a3312f87a6e0 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -29,17 +29,24 @@
 #define kern_hyp_va(kva)	(kva)
 
 /*
- * KVM_MMU_CACHE_MIN_PAGES is the number of stage2 page table translation levels.
+ * kvm_mmu_cache_min_pages is the number of stage2 page table
+ * translation levels excluding the top level.
  */
-#define KVM_MMU_CACHE_MIN_PAGES	2
+#define kvm_mmu_cache_min_pages(kvm)	2
 
 #ifndef __ASSEMBLY__
 
 #include <linux/highmem.h>
 #include <asm/cacheflush.h>
+#include <asm/kvm_arm.h>
 #include <asm/pgalloc.h>
 #include <asm/stage2_pgtable.h>
 
+#define kvm_phys_shift(kvm)		KVM_PHYS_SHIFT
+#define kvm_phys_size(kvm)		(_AC(1, ULL) << kvm_phys_shift(kvm))
+#define kvm_phys_mask(kvm)		(kvm_phys_size(kvm) - _AC(1, ULL))
+
+#define stage2_pgd_size(kvm)	(PTRS_PER_S2_PGD * sizeof(pgd_t))
 int create_hyp_mappings(void *from, void *to, pgprot_t prot);
 int create_hyp_io_mappings(void *from, void *to, phys_addr_t);
 void free_hyp_pgds(void);
diff --git a/arch/arm/include/asm/stage2_pgtable.h b/arch/arm/include/asm/stage2_pgtable.h
index 460d616bb2d6..e22ae94f0bf9 100644
--- a/arch/arm/include/asm/stage2_pgtable.h
+++ b/arch/arm/include/asm/stage2_pgtable.h
@@ -19,43 +19,45 @@
 #ifndef __ARM_S2_PGTABLE_H_
 #define __ARM_S2_PGTABLE_H_
 
-#define stage2_pgd_none(pgd)			pgd_none(pgd)
-#define stage2_pgd_clear(pgd)			pgd_clear(pgd)
-#define stage2_pgd_present(pgd)			pgd_present(pgd)
-#define stage2_pgd_populate(pgd, pud)		pgd_populate(NULL, pgd, pud)
-#define stage2_pud_offset(pgd, address)		pud_offset(pgd, address)
-#define stage2_pud_free(pud)			pud_free(NULL, pud)
-
-#define stage2_pud_none(pud)			pud_none(pud)
-#define stage2_pud_clear(pud)			pud_clear(pud)
-#define stage2_pud_present(pud)			pud_present(pud)
-#define stage2_pud_populate(pud, pmd)		pud_populate(NULL, pud, pmd)
-#define stage2_pmd_offset(pud, address)		pmd_offset(pud, address)
-#define stage2_pmd_free(pmd)			pmd_free(NULL, pmd)
-
-#define stage2_pud_huge(pud)			pud_huge(pud)
+#define stage2_pgd_none(kvm, pgd)		pgd_none(pgd)
+#define stage2_pgd_clear(kvm, pgd)		pgd_clear(pgd)
+#define stage2_pgd_present(kvm, pgd)		pgd_present(pgd)
+#define stage2_pgd_populate(kvm, pgd, pud)	pgd_populate(NULL, pgd, pud)
+#define stage2_pud_offset(kvm, pgd, address)	pud_offset(pgd, address)
+#define stage2_pud_free(kvm, pud)		pud_free(NULL, pud)
+
+#define stage2_pud_none(kvm, pud)		pud_none(pud)
+#define stage2_pud_clear(kvm, pud)		pud_clear(pud)
+#define stage2_pud_present(kvm, pud)		pud_present(pud)
+#define stage2_pud_populate(kvm, pud, pmd)	pud_populate(NULL, pud, pmd)
+#define stage2_pmd_offset(kvm, pud, address)	pmd_offset(pud, address)
+#define stage2_pmd_free(kvm, pmd)		pmd_free(NULL, pmd)
+
+#define stage2_pud_huge(kvm, pud)		pud_huge(pud)
 
 /* Open coded p*d_addr_end that can deal with 64bit addresses */
-static inline phys_addr_t stage2_pgd_addr_end(phys_addr_t addr, phys_addr_t end)
+static inline phys_addr_t
+stage2_pgd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 {
 	phys_addr_t boundary = (addr + PGDIR_SIZE) & PGDIR_MASK;
 
 	return (boundary - 1 < end - 1) ? boundary : end;
 }
 
-#define stage2_pud_addr_end(addr, end)		(end)
+#define stage2_pud_addr_end(kvm, addr, end)	(end)
 
-static inline phys_addr_t stage2_pmd_addr_end(phys_addr_t addr, phys_addr_t end)
+static inline phys_addr_t
+stage2_pmd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 {
 	phys_addr_t boundary = (addr + PMD_SIZE) & PMD_MASK;
 
 	return (boundary - 1 < end - 1) ? boundary : end;
 }
 
-#define stage2_pgd_index(addr)				pgd_index(addr)
+#define stage2_pgd_index(kvm, addr)		pgd_index(addr)
 
-#define stage2_pte_table_empty(ptep)			kvm_page_empty(ptep)
-#define stage2_pmd_table_empty(pmdp)			kvm_page_empty(pmdp)
-#define stage2_pud_table_empty(pudp)			false
+#define stage2_pte_table_empty(kvm, ptep)	kvm_page_empty(ptep)
+#define stage2_pmd_table_empty(kvm, pmdp)	kvm_page_empty(pmdp)
+#define stage2_pud_table_empty(kvm, pudp)	false
 
 #endif	/* __ARM_S2_PGTABLE_H_ */
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index b33bdb5eeb3d..de542aa72d80 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -134,8 +134,10 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
  * We currently only support a 40bit IPA.
  */
 #define KVM_PHYS_SHIFT	(40)
-#define KVM_PHYS_SIZE	(1UL << KVM_PHYS_SHIFT)
-#define KVM_PHYS_MASK	(KVM_PHYS_SIZE - 1UL)
+
+#define kvm_phys_shift(kvm)		KVM_PHYS_SHIFT
+#define kvm_phys_size(kvm)		(_AC(1, ULL) << kvm_phys_shift(kvm))
+#define kvm_phys_mask(kvm)		(kvm_phys_size(kvm) - _AC(1, ULL))
 
 #include <asm/stage2_pgtable.h>
 
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index a1c6e93a1a11..50d72be469ca 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -467,7 +467,7 @@ static inline phys_addr_t pmd_page_paddr(pmd_t pmd)
 
 #define __raw_pud_none(pud)		(!pud_val((pud)))
 #define __raw_pud_bad(pud)		(!(pud_val((pud)) & PUD_TABLE_BIT))
-#define __raw_pud_present(pud)	pte_present(pud_pte((pud)))
+#define __raw_pud_present(pud)		pte_present(pud_pte((pud)))
 
 static inline int __raw_pud_huge(pud_t pud)
 {
diff --git a/arch/arm64/include/asm/stage2_pgtable-nopmd.h b/arch/arm64/include/asm/stage2_pgtable-nopmd.h
index 2656a0fd05a6..0280dedbf75f 100644
--- a/arch/arm64/include/asm/stage2_pgtable-nopmd.h
+++ b/arch/arm64/include/asm/stage2_pgtable-nopmd.h
@@ -26,17 +26,17 @@
 #define S2_PMD_SIZE		(1UL << S2_PMD_SHIFT)
 #define S2_PMD_MASK		(~(S2_PMD_SIZE-1))
 
-#define stage2_pud_none(pud)			(0)
-#define stage2_pud_present(pud)			(1)
-#define stage2_pud_clear(pud)			do { } while (0)
-#define stage2_pud_populate(pud, pmd)		do { } while (0)
-#define stage2_pmd_offset(pud, address)		((pmd_t *)(pud))
+#define stage2_pud_none(kvm, pud)		(0)
+#define stage2_pud_present(kvm, pud)		(1)
+#define stage2_pud_clear(kvm, pud)		do { } while (0)
+#define stage2_pud_populate(kvm, pud, pmd)	do { } while (0)
+#define stage2_pmd_offset(kvm, pud, address)	((pmd_t *)(pud))
 
-#define stage2_pmd_free(pmd)			do { } while (0)
+#define stage2_pmd_free(kvm, pmd)		do { } while (0)
 
-#define stage2_pmd_addr_end(addr, end)		(end)
+#define stage2_pmd_addr_end(kvm, addr, end)	(end)
 
-#define stage2_pud_huge(pud)			(0)
-#define stage2_pmd_table_empty(pmdp)		(0)
+#define stage2_pud_huge(kvm, pud)		(0)
+#define stage2_pmd_table_empty(kvm, pmdp)	(0)
 
 #endif
diff --git a/arch/arm64/include/asm/stage2_pgtable-nopud.h b/arch/arm64/include/asm/stage2_pgtable-nopud.h
index 5ee87b54ebf3..cd6304e203be 100644
--- a/arch/arm64/include/asm/stage2_pgtable-nopud.h
+++ b/arch/arm64/include/asm/stage2_pgtable-nopud.h
@@ -24,16 +24,16 @@
 #define S2_PUD_SIZE		(_AC(1, UL) << S2_PUD_SHIFT)
 #define S2_PUD_MASK		(~(S2_PUD_SIZE-1))
 
-#define stage2_pgd_none(pgd)			(0)
-#define stage2_pgd_present(pgd)			(1)
-#define stage2_pgd_clear(pgd)			do { } while (0)
-#define stage2_pgd_populate(pgd, pud)	do { } while (0)
+#define stage2_pgd_none(kvm, pgd)		(0)
+#define stage2_pgd_present(kvm, pgd)		(1)
+#define stage2_pgd_clear(kvm, pgd)		do { } while (0)
+#define stage2_pgd_populate(kvm, pgd, pud)	do { } while (0)
 
-#define stage2_pud_offset(pgd, address)		((pud_t *)(pgd))
+#define stage2_pud_offset(kvm, pgd, address)	((pud_t *)(pgd))
 
-#define stage2_pud_free(x)			do { } while (0)
+#define stage2_pud_free(kvm, x)			do { } while (0)
 
-#define stage2_pud_addr_end(addr, end)		(end)
-#define stage2_pud_table_empty(pmdp)		(0)
+#define stage2_pud_addr_end(kvm, addr, end)	(end)
+#define stage2_pud_table_empty(kvm, pmdp)	(0)
 
 #endif
diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
index 8b68099348e5..057a405fa727 100644
--- a/arch/arm64/include/asm/stage2_pgtable.h
+++ b/arch/arm64/include/asm/stage2_pgtable.h
@@ -65,10 +65,10 @@
 #define PTRS_PER_S2_PGD			(1 << (KVM_PHYS_SHIFT - S2_PGDIR_SHIFT))
 
 /*
- * KVM_MMU_CACHE_MIN_PAGES is the number of stage2 page table translation
+ * kvm_mmmu_cache_min_pages is the number of stage2 page table translation
  * levels in addition to the PGD.
  */
-#define KVM_MMU_CACHE_MIN_PAGES		(STAGE2_PGTABLE_LEVELS - 1)
+#define kvm_mmu_cache_min_pages(kvm)	(STAGE2_PGTABLE_LEVELS - 1)
 
 
 #if STAGE2_PGTABLE_LEVELS > 3
@@ -77,16 +77,17 @@
 #define S2_PUD_SIZE			(_AC(1, UL) << S2_PUD_SHIFT)
 #define S2_PUD_MASK			(~(S2_PUD_SIZE - 1))
 
-#define stage2_pgd_none(pgd)				pgd_none(pgd)
-#define stage2_pgd_clear(pgd)				pgd_clear(pgd)
-#define stage2_pgd_present(pgd)				pgd_present(pgd)
-#define stage2_pgd_populate(pgd, pud)			pgd_populate(NULL, pgd, pud)
-#define stage2_pud_offset(pgd, address)			pud_offset(pgd, address)
-#define stage2_pud_free(pud)				pud_free(NULL, pud)
+#define stage2_pgd_none(kvm, pgd)		pgd_none(pgd)
+#define stage2_pgd_clear(kvm, pgd)		pgd_clear(pgd)
+#define stage2_pgd_present(kvm, pgd)		pgd_present(pgd)
+#define stage2_pgd_populate(kvm, pgd, pud)	pgd_populate(NULL, pgd, pud)
+#define stage2_pud_offset(kvm, pgd, address)	pud_offset(pgd, address)
+#define stage2_pud_free(kvm, pud)		pud_free(NULL, pud)
 
-#define stage2_pud_table_empty(pudp)			kvm_page_empty(pudp)
+#define stage2_pud_table_empty(kvm, pudp)	kvm_page_empty(pudp)
 
-static inline phys_addr_t stage2_pud_addr_end(phys_addr_t addr, phys_addr_t end)
+static inline phys_addr_t
+stage2_pud_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 {
 	phys_addr_t boundary = (addr + S2_PUD_SIZE) & S2_PUD_MASK;
 
@@ -102,17 +103,18 @@ static inline phys_addr_t stage2_pud_addr_end(phys_addr_t addr, phys_addr_t end)
 #define S2_PMD_SIZE			(_AC(1, UL) << S2_PMD_SHIFT)
 #define S2_PMD_MASK			(~(S2_PMD_SIZE - 1))
 
-#define stage2_pud_none(pud)				pud_none(pud)
-#define stage2_pud_clear(pud)				pud_clear(pud)
-#define stage2_pud_present(pud)				pud_present(pud)
-#define stage2_pud_populate(pud, pmd)			pud_populate(NULL, pud, pmd)
-#define stage2_pmd_offset(pud, address)			pmd_offset(pud, address)
-#define stage2_pmd_free(pmd)				pmd_free(NULL, pmd)
+#define stage2_pud_none(kvm, pud)		pud_none(pud)
+#define stage2_pud_clear(kvm, pud)		pud_clear(pud)
+#define stage2_pud_present(kvm, pud)		pud_present(pud)
+#define stage2_pud_populate(kvm, pud, pmd)	pud_populate(NULL, pud, pmd)
+#define stage2_pmd_offset(kvm, pud, address)	pmd_offset(pud, address)
+#define stage2_pmd_free(kvm, pmd)		pmd_free(NULL, pmd)
 
-#define stage2_pud_huge(pud)				pud_huge(pud)
-#define stage2_pmd_table_empty(pmdp)			kvm_page_empty(pmdp)
+#define stage2_pud_huge(kvm, pud)		pud_huge(pud)
+#define stage2_pmd_table_empty(kvm, pmdp)	kvm_page_empty(pmdp)
 
-static inline phys_addr_t stage2_pmd_addr_end(phys_addr_t addr, phys_addr_t end)
+static inline phys_addr_t
+stage2_pmd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 {
 	phys_addr_t boundary = (addr + S2_PMD_SIZE) & S2_PMD_MASK;
 
@@ -121,7 +123,7 @@ static inline phys_addr_t stage2_pmd_addr_end(phys_addr_t addr, phys_addr_t end)
 
 #endif		/* STAGE2_PGTABLE_LEVELS > 2 */
 
-#define stage2_pte_table_empty(ptep)			kvm_page_empty(ptep)
+#define stage2_pte_table_empty(kvm, ptep)	kvm_page_empty(ptep)
 
 #if STAGE2_PGTABLE_LEVELS == 2
 #include <asm/stage2_pgtable-nopmd.h>
@@ -129,10 +131,13 @@ static inline phys_addr_t stage2_pmd_addr_end(phys_addr_t addr, phys_addr_t end)
 #include <asm/stage2_pgtable-nopud.h>
 #endif
 
+#define stage2_pgd_size(kvm)	(PTRS_PER_S2_PGD * sizeof(pgd_t))
 
-#define stage2_pgd_index(addr)				(((addr) >> S2_PGDIR_SHIFT) & (PTRS_PER_S2_PGD - 1))
+#define stage2_pgd_index(kvm, addr) \
+	(((addr) >> S2_PGDIR_SHIFT) & (PTRS_PER_S2_PGD - 1))
 
-static inline phys_addr_t stage2_pgd_addr_end(phys_addr_t addr, phys_addr_t end)
+static inline phys_addr_t
+stage2_pgd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 {
 	phys_addr_t boundary = (addr + S2_PGDIR_SIZE) & S2_PGDIR_MASK;
 
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 257f2a8ccfc7..cd355aa70c61 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -43,7 +43,6 @@ static unsigned long hyp_idmap_start;
 static unsigned long hyp_idmap_end;
 static phys_addr_t hyp_idmap_vector;
 
-#define S2_PGD_SIZE	(PTRS_PER_S2_PGD * sizeof(pgd_t))
 #define hyp_pgd_order get_order(PTRS_PER_PGD * sizeof(pgd_t))
 
 #define KVM_S2PTE_FLAG_IS_IOMAP		(1UL << 0)
@@ -148,20 +147,20 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 
 static void clear_stage2_pgd_entry(struct kvm *kvm, pgd_t *pgd, phys_addr_t addr)
 {
-	pud_t *pud_table __maybe_unused = stage2_pud_offset(pgd, 0UL);
-	stage2_pgd_clear(pgd);
+	pud_t *pud_table __maybe_unused = stage2_pud_offset(kvm, pgd, 0UL);
+	stage2_pgd_clear(kvm, pgd);
 	kvm_tlb_flush_vmid_ipa(kvm, addr);
-	stage2_pud_free(pud_table);
+	stage2_pud_free(kvm, pud_table);
 	put_page(virt_to_page(pgd));
 }
 
 static void clear_stage2_pud_entry(struct kvm *kvm, pud_t *pud, phys_addr_t addr)
 {
-	pmd_t *pmd_table __maybe_unused = stage2_pmd_offset(pud, 0);
-	VM_BUG_ON(stage2_pud_huge(*pud));
-	stage2_pud_clear(pud);
+	pmd_t *pmd_table __maybe_unused = stage2_pmd_offset(kvm, pud, 0);
+	VM_BUG_ON(stage2_pud_huge(kvm, *pud));
+	stage2_pud_clear(kvm, pud);
 	kvm_tlb_flush_vmid_ipa(kvm, addr);
-	stage2_pmd_free(pmd_table);
+	stage2_pmd_free(kvm, pmd_table);
 	put_page(virt_to_page(pud));
 }
 
@@ -217,7 +216,7 @@ static void unmap_stage2_ptes(struct kvm *kvm, pmd_t *pmd,
 		}
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
-	if (stage2_pte_table_empty(start_pte))
+	if (stage2_pte_table_empty(kvm, start_pte))
 		clear_stage2_pmd_entry(kvm, pmd, start_addr);
 }
 
@@ -227,9 +226,9 @@ static void unmap_stage2_pmds(struct kvm *kvm, pud_t *pud,
 	phys_addr_t next, start_addr = addr;
 	pmd_t *pmd, *start_pmd;
 
-	start_pmd = pmd = stage2_pmd_offset(pud, addr);
+	start_pmd = pmd = stage2_pmd_offset(kvm, pud, addr);
 	do {
-		next = stage2_pmd_addr_end(addr, end);
+		next = stage2_pmd_addr_end(kvm, addr, end);
 		if (!pmd_none(*pmd)) {
 			if (pmd_thp_or_huge(*pmd)) {
 				pmd_t old_pmd = *pmd;
@@ -246,7 +245,7 @@ static void unmap_stage2_pmds(struct kvm *kvm, pud_t *pud,
 		}
 	} while (pmd++, addr = next, addr != end);
 
-	if (stage2_pmd_table_empty(start_pmd))
+	if (stage2_pmd_table_empty(kvm, start_pmd))
 		clear_stage2_pud_entry(kvm, pud, start_addr);
 }
 
@@ -256,14 +255,14 @@ static void unmap_stage2_puds(struct kvm *kvm, pgd_t *pgd,
 	phys_addr_t next, start_addr = addr;
 	pud_t *pud, *start_pud;
 
-	start_pud = pud = stage2_pud_offset(pgd, addr);
+	start_pud = pud = stage2_pud_offset(kvm, pgd, addr);
 	do {
-		next = stage2_pud_addr_end(addr, end);
-		if (!stage2_pud_none(*pud)) {
-			if (stage2_pud_huge(*pud)) {
+		next = stage2_pud_addr_end(kvm, addr, end);
+		if (!stage2_pud_none(kvm, *pud)) {
+			if (stage2_pud_huge(kvm, *pud)) {
 				pud_t old_pud = *pud;
 
-				stage2_pud_clear(pud);
+				stage2_pud_clear(kvm, pud);
 				kvm_tlb_flush_vmid_ipa(kvm, addr);
 				kvm_flush_dcache_pud(old_pud);
 				put_page(virt_to_page(pud));
@@ -273,7 +272,7 @@ static void unmap_stage2_puds(struct kvm *kvm, pgd_t *pgd,
 		}
 	} while (pud++, addr = next, addr != end);
 
-	if (stage2_pud_table_empty(start_pud))
+	if (stage2_pud_table_empty(kvm, start_pud))
 		clear_stage2_pgd_entry(kvm, pgd, start_addr);
 }
 
@@ -295,7 +294,7 @@ static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
 	phys_addr_t next;
 
 	assert_spin_locked(&kvm->mmu_lock);
-	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
+	pgd = kvm->arch.pgd + stage2_pgd_index(kvm, addr);
 	do {
 		/*
 		 * The page table shouldn't be free'd as we still hold a reference
@@ -303,8 +302,8 @@ static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
 		 */
 		if (WARN_ON(!READ_ONCE(kvm->arch.pgd)))
 			break;
-		next = stage2_pgd_addr_end(addr, end);
-		if (!stage2_pgd_none(*pgd))
+		next = stage2_pgd_addr_end(kvm, addr, end);
+		if (!stage2_pgd_none(kvm, *pgd))
 			unmap_stage2_puds(kvm, pgd, addr, next);
 		/*
 		 * If the range is too large, release the kvm->mmu_lock
@@ -333,9 +332,9 @@ static void stage2_flush_pmds(struct kvm *kvm, pud_t *pud,
 	pmd_t *pmd;
 	phys_addr_t next;
 
-	pmd = stage2_pmd_offset(pud, addr);
+	pmd = stage2_pmd_offset(kvm, pud, addr);
 	do {
-		next = stage2_pmd_addr_end(addr, end);
+		next = stage2_pmd_addr_end(kvm, addr, end);
 		if (!pmd_none(*pmd)) {
 			if (pmd_thp_or_huge(*pmd))
 				kvm_flush_dcache_pmd(*pmd);
@@ -351,11 +350,11 @@ static void stage2_flush_puds(struct kvm *kvm, pgd_t *pgd,
 	pud_t *pud;
 	phys_addr_t next;
 
-	pud = stage2_pud_offset(pgd, addr);
+	pud = stage2_pud_offset(kvm, pgd, addr);
 	do {
-		next = stage2_pud_addr_end(addr, end);
-		if (!stage2_pud_none(*pud)) {
-			if (stage2_pud_huge(*pud))
+		next = stage2_pud_addr_end(kvm, addr, end);
+		if (!stage2_pud_none(kvm, *pud)) {
+			if (stage2_pud_huge(kvm, *pud))
 				kvm_flush_dcache_pud(*pud);
 			else
 				stage2_flush_pmds(kvm, pud, addr, next);
@@ -371,10 +370,10 @@ static void stage2_flush_memslot(struct kvm *kvm,
 	phys_addr_t next;
 	pgd_t *pgd;
 
-	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
+	pgd = kvm->arch.pgd + stage2_pgd_index(kvm, addr);
 	do {
-		next = stage2_pgd_addr_end(addr, end);
-		if (!stage2_pgd_none(*pgd))
+		next = stage2_pgd_addr_end(kvm, addr, end);
+		if (!stage2_pgd_none(kvm, *pgd))
 			stage2_flush_puds(kvm, pgd, addr, next);
 	} while (pgd++, addr = next, addr != end);
 }
@@ -762,7 +761,7 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
 	}
 
 	/* Allocate the HW PGD, making sure that each page gets its own refcount */
-	pgd = alloc_pages_exact(S2_PGD_SIZE, GFP_KERNEL | __GFP_ZERO);
+	pgd = alloc_pages_exact(stage2_pgd_size(kvm), GFP_KERNEL | __GFP_ZERO);
 	if (!pgd)
 		return -ENOMEM;
 
@@ -844,7 +843,7 @@ static void kvm_flush_stage2_all(struct kvm *kvm)
 {
 	spin_lock(&kvm->mmu_lock);
 	if (kvm->arch.pgd)
-		unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
+		unmap_stage2_range(kvm, 0, kvm_phys_size(kvm));
 	spin_unlock(&kvm->mmu_lock);
 }
 
@@ -861,7 +860,7 @@ static void kvm_flush_stage2_all(struct kvm *kvm)
 void kvm_free_stage2_pgd(struct kvm *kvm)
 {
 	kvm_flush_stage2_all(kvm);
-	free_pages_exact(kvm->arch.pgd, S2_PGD_SIZE);
+	free_pages_exact(kvm->arch.pgd, stage2_pgd_size(kvm));
 	kvm->arch.pgd = NULL;
 }
 
@@ -871,16 +870,16 @@ static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	pgd_t *pgd;
 	pud_t *pud;
 
-	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
-	if (stage2_pgd_none(*pgd)) {
+	pgd = kvm->arch.pgd + stage2_pgd_index(kvm, addr);
+	if (stage2_pgd_none(kvm, *pgd)) {
 		if (!cache)
 			return NULL;
 		pud = mmu_memory_cache_alloc(cache);
-		stage2_pgd_populate(pgd, pud);
+		stage2_pgd_populate(kvm, pgd, pud);
 		get_page(virt_to_page(pgd));
 	}
 
-	return stage2_pud_offset(pgd, addr);
+	return stage2_pud_offset(kvm, pgd, addr);
 }
 
 static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
@@ -893,15 +892,15 @@ static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	if (!pud)
 		return NULL;
 
-	if (stage2_pud_none(*pud)) {
+	if (stage2_pud_none(kvm, *pud)) {
 		if (!cache)
 			return NULL;
 		pmd = mmu_memory_cache_alloc(cache);
-		stage2_pud_populate(pud, pmd);
+		stage2_pud_populate(kvm, pud, pmd);
 		get_page(virt_to_page(pud));
 	}
 
-	return stage2_pmd_offset(pud, addr);
+	return stage2_pmd_offset(kvm, pud, addr);
 }
 
 static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
@@ -1060,7 +1059,7 @@ static int __kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 		if (writable)
 			pte = kvm_s2pte_mkwrite(pte);
 
-		ret = mmu_topup_memory_cache(&cache, KVM_MMU_CACHE_MIN_PAGES,
+		ret = mmu_topup_memory_cache(&cache, kvm_mmu_cache_min_pages(kvm),
 						KVM_NR_MEM_OBJS);
 		if (ret)
 			goto out;
@@ -1166,19 +1165,20 @@ static void stage2_wp_ptes(pmd_t *pmd, phys_addr_t addr, phys_addr_t end)
 
 /**
  * stage2_wp_pmds - write protect PUD range
+ * kvm:		kvm instance for the VM
  * @pud:	pointer to pud entry
  * @addr:	range start address
  * @end:	range end address
  */
-static void stage2_wp_pmds(pud_t *pud, phys_addr_t addr, phys_addr_t end)
+static void stage2_wp_pmds(struct kvm *kvm, pud_t *pud, phys_addr_t addr, phys_addr_t end)
 {
 	pmd_t *pmd;
 	phys_addr_t next;
 
-	pmd = stage2_pmd_offset(pud, addr);
+	pmd = stage2_pmd_offset(kvm, pud, addr);
 
 	do {
-		next = stage2_pmd_addr_end(addr, end);
+		next = stage2_pmd_addr_end(kvm, addr, end);
 		if (!pmd_none(*pmd)) {
 			if (pmd_thp_or_huge(*pmd)) {
 				if (!kvm_s2pmd_readonly(pmd))
@@ -1198,18 +1198,18 @@ static void stage2_wp_pmds(pud_t *pud, phys_addr_t addr, phys_addr_t end)
   *
   * Process PUD entries, for a huge PUD we cause a panic.
   */
-static void  stage2_wp_puds(pgd_t *pgd, phys_addr_t addr, phys_addr_t end)
+static void  stage2_wp_puds(struct kvm *kvm, pgd_t *pgd, phys_addr_t addr, phys_addr_t end)
 {
 	pud_t *pud;
 	phys_addr_t next;
 
-	pud = stage2_pud_offset(pgd, addr);
+	pud = stage2_pud_offset(kvm, pgd, addr);
 	do {
-		next = stage2_pud_addr_end(addr, end);
-		if (!stage2_pud_none(*pud)) {
+		next = stage2_pud_addr_end(kvm, addr, end);
+		if (!stage2_pud_none(kvm, *pud)) {
 			/* TODO:PUD not supported, revisit later if supported */
-			BUG_ON(stage2_pud_huge(*pud));
-			stage2_wp_pmds(pud, addr, next);
+			BUG_ON(stage2_pud_huge(kvm, *pud));
+			stage2_wp_pmds(kvm, pud, addr, next);
 		}
 	} while (pud++, addr = next, addr != end);
 }
@@ -1225,7 +1225,7 @@ static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 	pgd_t *pgd;
 	phys_addr_t next;
 
-	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
+	pgd = kvm->arch.pgd + stage2_pgd_index(kvm, addr);
 	do {
 		/*
 		 * Release kvm_mmu_lock periodically if the memory region is
@@ -1239,9 +1239,9 @@ static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 		cond_resched_lock(&kvm->mmu_lock);
 		if (WARN_ON(!READ_ONCE(kvm->arch.pgd)))
 			break;
-		next = stage2_pgd_addr_end(addr, end);
-		if (stage2_pgd_present(*pgd))
-			stage2_wp_puds(pgd, addr, next);
+		next = stage2_pgd_addr_end(kvm, addr, end);
+		if (stage2_pgd_present(kvm, *pgd))
+			stage2_wp_puds(kvm, pgd, addr, next);
 	} while (pgd++, addr = next, addr != end);
 }
 
@@ -1382,7 +1382,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	up_read(&current->mm->mmap_sem);
 
 	/* We need minimum second+third level pages */
-	ret = mmu_topup_memory_cache(memcache, KVM_MMU_CACHE_MIN_PAGES,
+	ret = mmu_topup_memory_cache(memcache, kvm_mmu_cache_min_pages(kvm),
 				     KVM_NR_MEM_OBJS);
 	if (ret)
 		return ret;
@@ -1601,7 +1601,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	}
 
 	/* Userspace should not be able to register out-of-bounds IPAs */
-	VM_BUG_ON(fault_ipa >= KVM_PHYS_SIZE);
+	VM_BUG_ON(fault_ipa >= kvm_phys_size(vcpu->kvm));
 
 	if (fault_status == FSC_ACCESS) {
 		handle_access_fault(vcpu, fault_ipa);
@@ -1901,7 +1901,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	 * space addressable by the KVM guest IPA space.
 	 */
 	if (memslot->base_gfn + memslot->npages >=
-	    (KVM_PHYS_SIZE >> PAGE_SHIFT))
+	    (kvm_phys_size(kvm) >> PAGE_SHIFT))
 		return -EFAULT;
 
 	down_read(&current->mm->mmap_sem);
diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 10ae6f394b71..613ff4abcad5 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -25,7 +25,7 @@
 int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
 		      phys_addr_t addr, phys_addr_t alignment)
 {
-	if (addr & ~KVM_PHYS_MASK)
+	if (addr & ~kvm_phys_mask(kvm))
 		return -E2BIG;
 
 	if (!IS_ALIGNED(addr, alignment))
-- 
2.13.6
