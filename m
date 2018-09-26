From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v6 08/18] kvm: arm/arm64: Prepare for VM specific stage2 translations
Date: Wed, 26 Sep 2018 17:32:44 +0100
Message-ID: <20180926163258.20218-9-suzuki.poulose@arm.com>
References: <20180926163258.20218-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180926163258.20218-1-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, cdall@kernel.org, eric.auger@redhat.com, suzuki.poulose@arm.com, will.deacon@arm.com, dave.martin@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, julien.grall@arm.com, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Right now the stage2 page table for a VM is hard coded, assuming
an IPA of 40bits. As we are about to add support for per VM IPA,
prepare the stage2 page table helpers to accept the kvm instance
to make the right decision for the VM. No functional changes.
Adds stage2_pgd_size(kvm) to replace S2_PGD_SIZE. Also, moves
some of the definitions in arm32 to align with the arm64.
Also drop the _AC() specifier constants wherever possible.

Cc: Christoffer Dall <cdall@kernel.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since V3:
 - Improve the comment about kvm_mmu_cache_min_pages()
 - Drop _AC() in arm64 definitions
 - Move kvm_mmu_cache_min_pages() in arm to stage2_pgtable.h in
   line with arm64.
---
 arch/arm/include/asm/kvm_arm.h                |   3 +-
 arch/arm/include/asm/kvm_mmu.h                |  13 +-
 arch/arm/include/asm/stage2_pgtable.h         |  50 +++++---
 arch/arm64/include/asm/kvm_mmu.h              |   7 +-
 arch/arm64/include/asm/stage2_pgtable-nopmd.h |  18 +--
 arch/arm64/include/asm/stage2_pgtable-nopud.h |  16 +--
 arch/arm64/include/asm/stage2_pgtable.h       |  58 +++++----
 virt/kvm/arm/arm.c                            |   2 +-
 virt/kvm/arm/mmu.c                            | 119 +++++++++---------
 virt/kvm/arm/vgic/vgic-kvm-device.c           |   2 +-
 10 files changed, 156 insertions(+), 132 deletions(-)

diff --git a/arch/arm/include/asm/kvm_arm.h b/arch/arm/include/asm/kvm_arm.h
index 3ab8b3781bfe..c3f1f9b304b7 100644
--- a/arch/arm/include/asm/kvm_arm.h
+++ b/arch/arm/include/asm/kvm_arm.h
@@ -133,8 +133,7 @@
  * space.
  */
 #define KVM_PHYS_SHIFT	(40)
-#define KVM_PHYS_SIZE	(_AC(1, ULL) << KVM_PHYS_SHIFT)
-#define KVM_PHYS_MASK	(KVM_PHYS_SIZE - _AC(1, ULL))
+
 #define PTRS_PER_S2_PGD	(_AC(1, ULL) << (KVM_PHYS_SHIFT - 30))
 
 /* Virtualization Translation Control Register (VTCR) bits */
diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 265ea9cf7df7..12ae5fbbcf01 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -35,16 +35,12 @@
 		addr;							\
 	})
 
-/*
- * KVM_MMU_CACHE_MIN_PAGES is the number of stage2 page table translation levels.
- */
-#define KVM_MMU_CACHE_MIN_PAGES	2
-
 #ifndef __ASSEMBLY__
 
 #include <linux/highmem.h>
 #include <asm/cacheflush.h>
 #include <asm/cputype.h>
+#include <asm/kvm_arm.h>
 #include <asm/kvm_hyp.h>
 #include <asm/pgalloc.h>
 #include <asm/stage2_pgtable.h>
@@ -52,6 +48,13 @@
 /* Ensure compatibility with arm64 */
 #define VA_BITS			32
 
+#define kvm_phys_shift(kvm)		KVM_PHYS_SHIFT
+#define kvm_phys_size(kvm)		(1ULL << kvm_phys_shift(kvm))
+#define kvm_phys_mask(kvm)		(kvm_phys_size(kvm) - 1ULL)
+#define kvm_vttbr_baddr_mask(kvm)	VTTBR_BADDR_MASK
+
+#define stage2_pgd_size(kvm)		(PTRS_PER_S2_PGD * sizeof(pgd_t))
+
 int create_hyp_mappings(void *from, void *to, pgprot_t prot);
 int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 			   void __iomem **kaddr,
diff --git a/arch/arm/include/asm/stage2_pgtable.h b/arch/arm/include/asm/stage2_pgtable.h
index 460d616bb2d6..f6a7ea805232 100644
--- a/arch/arm/include/asm/stage2_pgtable.h
+++ b/arch/arm/include/asm/stage2_pgtable.h
@@ -19,43 +19,53 @@
 #ifndef __ARM_S2_PGTABLE_H_
 #define __ARM_S2_PGTABLE_H_
 
-#define stage2_pgd_none(pgd)			pgd_none(pgd)
-#define stage2_pgd_clear(pgd)			pgd_clear(pgd)
-#define stage2_pgd_present(pgd)			pgd_present(pgd)
-#define stage2_pgd_populate(pgd, pud)		pgd_populate(NULL, pgd, pud)
-#define stage2_pud_offset(pgd, address)		pud_offset(pgd, address)
-#define stage2_pud_free(pud)			pud_free(NULL, pud)
+/*
+ * kvm_mmu_cache_min_pages() is the number of pages required
+ * to install a stage-2 translation. We pre-allocate the entry
+ * level table at VM creation. Since we have a 3 level page-table,
+ * we need only two pages to add a new mapping.
+ */
+#define kvm_mmu_cache_min_pages(kvm)	2
 
-#define stage2_pud_none(pud)			pud_none(pud)
-#define stage2_pud_clear(pud)			pud_clear(pud)
-#define stage2_pud_present(pud)			pud_present(pud)
-#define stage2_pud_populate(pud, pmd)		pud_populate(NULL, pud, pmd)
-#define stage2_pmd_offset(pud, address)		pmd_offset(pud, address)
-#define stage2_pmd_free(pmd)			pmd_free(NULL, pmd)
+#define stage2_pgd_none(kvm, pgd)		pgd_none(pgd)
+#define stage2_pgd_clear(kvm, pgd)		pgd_clear(pgd)
+#define stage2_pgd_present(kvm, pgd)		pgd_present(pgd)
+#define stage2_pgd_populate(kvm, pgd, pud)	pgd_populate(NULL, pgd, pud)
+#define stage2_pud_offset(kvm, pgd, address)	pud_offset(pgd, address)
+#define stage2_pud_free(kvm, pud)		pud_free(NULL, pud)
 
-#define stage2_pud_huge(pud)			pud_huge(pud)
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
index d6fff7de5539..3a032066e52c 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -141,8 +141,11 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
  * We currently only support a 40bit IPA.
  */
 #define KVM_PHYS_SHIFT	(40)
-#define KVM_PHYS_SIZE	(1UL << KVM_PHYS_SHIFT)
-#define KVM_PHYS_MASK	(KVM_PHYS_SIZE - 1UL)
+
+#define kvm_phys_shift(kvm)		KVM_PHYS_SHIFT
+#define kvm_phys_size(kvm)		(_AC(1, ULL) << kvm_phys_shift(kvm))
+#define kvm_phys_mask(kvm)		(kvm_phys_size(kvm) - _AC(1, ULL))
+#define kvm_vttbr_baddr_mask(kvm)	VTTBR_BADDR_MASK
 
 #include <asm/stage2_pgtable.h>
 
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
index 8b68099348e5..11891612be14 100644
--- a/arch/arm64/include/asm/stage2_pgtable.h
+++ b/arch/arm64/include/asm/stage2_pgtable.h
@@ -55,7 +55,7 @@
 
 /* S2_PGDIR_SHIFT is the size mapped by top-level stage2 entry */
 #define S2_PGDIR_SHIFT			ARM64_HW_PGTABLE_LEVEL_SHIFT(4 - STAGE2_PGTABLE_LEVELS)
-#define S2_PGDIR_SIZE			(_AC(1, UL) << S2_PGDIR_SHIFT)
+#define S2_PGDIR_SIZE			(1UL << S2_PGDIR_SHIFT)
 #define S2_PGDIR_MASK			(~(S2_PGDIR_SIZE - 1))
 
 /*
@@ -65,28 +65,30 @@
 #define PTRS_PER_S2_PGD			(1 << (KVM_PHYS_SHIFT - S2_PGDIR_SHIFT))
 
 /*
- * KVM_MMU_CACHE_MIN_PAGES is the number of stage2 page table translation
- * levels in addition to the PGD.
+ * kvm_mmmu_cache_min_pages() is the number of pages required to install
+ * a stage-2 translation. We pre-allocate the entry level page table at
+ * the VM creation.
  */
-#define KVM_MMU_CACHE_MIN_PAGES		(STAGE2_PGTABLE_LEVELS - 1)
+#define kvm_mmu_cache_min_pages(kvm)	(STAGE2_PGTABLE_LEVELS - 1)
 
 
 #if STAGE2_PGTABLE_LEVELS > 3
 
 #define S2_PUD_SHIFT			ARM64_HW_PGTABLE_LEVEL_SHIFT(1)
-#define S2_PUD_SIZE			(_AC(1, UL) << S2_PUD_SHIFT)
+#define S2_PUD_SIZE			(1UL << S2_PUD_SHIFT)
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
 
@@ -99,20 +101,21 @@ static inline phys_addr_t stage2_pud_addr_end(phys_addr_t addr, phys_addr_t end)
 #if STAGE2_PGTABLE_LEVELS > 2
 
 #define S2_PMD_SHIFT			ARM64_HW_PGTABLE_LEVEL_SHIFT(2)
-#define S2_PMD_SIZE			(_AC(1, UL) << S2_PMD_SHIFT)
+#define S2_PMD_SIZE			(1UL << S2_PMD_SHIFT)
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
 
@@ -121,7 +124,7 @@ static inline phys_addr_t stage2_pmd_addr_end(phys_addr_t addr, phys_addr_t end)
 
 #endif		/* STAGE2_PGTABLE_LEVELS > 2 */
 
-#define stage2_pte_table_empty(ptep)			kvm_page_empty(ptep)
+#define stage2_pte_table_empty(kvm, ptep)	kvm_page_empty(ptep)
 
 #if STAGE2_PGTABLE_LEVELS == 2
 #include <asm/stage2_pgtable-nopmd.h>
@@ -129,10 +132,13 @@ static inline phys_addr_t stage2_pmd_addr_end(phys_addr_t addr, phys_addr_t end)
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
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 327d0fd28380..43e716bc3f08 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -545,7 +545,7 @@ static void update_vttbr(struct kvm *kvm)
 
 	/* update vttbr to be used with the new vmid */
 	pgd_phys = virt_to_phys(kvm->arch.pgd);
-	BUG_ON(pgd_phys & ~VTTBR_BADDR_MASK);
+	BUG_ON(pgd_phys & ~kvm_vttbr_baddr_mask(kvm));
 	vmid = ((u64)(kvm->arch.vmid) << VTTBR_VMID_SHIFT) & VTTBR_VMID_MASK(kvm_vmid_bits);
 	kvm->arch.vttbr = kvm_phys_to_vttbr(pgd_phys) | vmid;
 
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 4a285d760ce0..7e477b3cae5b 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -45,7 +45,6 @@ static phys_addr_t hyp_idmap_vector;
 
 static unsigned long io_map_base;
 
-#define S2_PGD_SIZE	(PTRS_PER_S2_PGD * sizeof(pgd_t))
 #define hyp_pgd_order get_order(PTRS_PER_PGD * sizeof(pgd_t))
 
 #define KVM_S2PTE_FLAG_IS_IOMAP		(1UL << 0)
@@ -150,20 +149,20 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 
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
 
@@ -252,7 +251,7 @@ static void unmap_stage2_ptes(struct kvm *kvm, pmd_t *pmd,
 		}
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
-	if (stage2_pte_table_empty(start_pte))
+	if (stage2_pte_table_empty(kvm, start_pte))
 		clear_stage2_pmd_entry(kvm, pmd, start_addr);
 }
 
@@ -262,9 +261,9 @@ static void unmap_stage2_pmds(struct kvm *kvm, pud_t *pud,
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
@@ -281,7 +280,7 @@ static void unmap_stage2_pmds(struct kvm *kvm, pud_t *pud,
 		}
 	} while (pmd++, addr = next, addr != end);
 
-	if (stage2_pmd_table_empty(start_pmd))
+	if (stage2_pmd_table_empty(kvm, start_pmd))
 		clear_stage2_pud_entry(kvm, pud, start_addr);
 }
 
@@ -291,14 +290,14 @@ static void unmap_stage2_puds(struct kvm *kvm, pgd_t *pgd,
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
@@ -308,7 +307,7 @@ static void unmap_stage2_puds(struct kvm *kvm, pgd_t *pgd,
 		}
 	} while (pud++, addr = next, addr != end);
 
-	if (stage2_pud_table_empty(start_pud))
+	if (stage2_pud_table_empty(kvm, start_pud))
 		clear_stage2_pgd_entry(kvm, pgd, start_addr);
 }
 
@@ -332,7 +331,7 @@ static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
 	assert_spin_locked(&kvm->mmu_lock);
 	WARN_ON(size & ~PAGE_MASK);
 
-	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
+	pgd = kvm->arch.pgd + stage2_pgd_index(kvm, addr);
 	do {
 		/*
 		 * Make sure the page table is still active, as another thread
@@ -341,8 +340,8 @@ static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
 		 */
 		if (!READ_ONCE(kvm->arch.pgd))
 			break;
-		next = stage2_pgd_addr_end(addr, end);
-		if (!stage2_pgd_none(*pgd))
+		next = stage2_pgd_addr_end(kvm, addr, end);
+		if (!stage2_pgd_none(kvm, *pgd))
 			unmap_stage2_puds(kvm, pgd, addr, next);
 		/*
 		 * If the range is too large, release the kvm->mmu_lock
@@ -371,9 +370,9 @@ static void stage2_flush_pmds(struct kvm *kvm, pud_t *pud,
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
@@ -389,11 +388,11 @@ static void stage2_flush_puds(struct kvm *kvm, pgd_t *pgd,
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
@@ -409,10 +408,10 @@ static void stage2_flush_memslot(struct kvm *kvm,
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
@@ -898,7 +897,7 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
 	}
 
 	/* Allocate the HW PGD, making sure that each page gets its own refcount */
-	pgd = alloc_pages_exact(S2_PGD_SIZE, GFP_KERNEL | __GFP_ZERO);
+	pgd = alloc_pages_exact(stage2_pgd_size(kvm), GFP_KERNEL | __GFP_ZERO);
 	if (!pgd)
 		return -ENOMEM;
 
@@ -987,7 +986,7 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
 
 	spin_lock(&kvm->mmu_lock);
 	if (kvm->arch.pgd) {
-		unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
+		unmap_stage2_range(kvm, 0, kvm_phys_size(kvm));
 		pgd = READ_ONCE(kvm->arch.pgd);
 		kvm->arch.pgd = NULL;
 	}
@@ -995,7 +994,7 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
 
 	/* Free the HW pgd, one page at a time */
 	if (pgd)
-		free_pages_exact(pgd, S2_PGD_SIZE);
+		free_pages_exact(pgd, stage2_pgd_size(kvm));
 }
 
 static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
@@ -1004,16 +1003,16 @@ static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
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
@@ -1026,15 +1025,15 @@ static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
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
@@ -1208,8 +1207,9 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 		if (writable)
 			pte = kvm_s2pte_mkwrite(pte);
 
-		ret = mmu_topup_memory_cache(&cache, KVM_MMU_CACHE_MIN_PAGES,
-						KVM_NR_MEM_OBJS);
+		ret = mmu_topup_memory_cache(&cache,
+					     kvm_mmu_cache_min_pages(kvm),
+					     KVM_NR_MEM_OBJS);
 		if (ret)
 			goto out;
 		spin_lock(&kvm->mmu_lock);
@@ -1297,19 +1297,21 @@ static void stage2_wp_ptes(pmd_t *pmd, phys_addr_t addr, phys_addr_t end)
 
 /**
  * stage2_wp_pmds - write protect PUD range
+ * kvm:		kvm instance for the VM
  * @pud:	pointer to pud entry
  * @addr:	range start address
  * @end:	range end address
  */
-static void stage2_wp_pmds(pud_t *pud, phys_addr_t addr, phys_addr_t end)
+static void stage2_wp_pmds(struct kvm *kvm, pud_t *pud,
+			   phys_addr_t addr, phys_addr_t end)
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
@@ -1329,18 +1331,19 @@ static void stage2_wp_pmds(pud_t *pud, phys_addr_t addr, phys_addr_t end)
   *
   * Process PUD entries, for a huge PUD we cause a panic.
   */
-static void  stage2_wp_puds(pgd_t *pgd, phys_addr_t addr, phys_addr_t end)
+static void  stage2_wp_puds(struct kvm *kvm, pgd_t *pgd,
+			    phys_addr_t addr, phys_addr_t end)
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
@@ -1356,7 +1359,7 @@ static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 	pgd_t *pgd;
 	phys_addr_t next;
 
-	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
+	pgd = kvm->arch.pgd + stage2_pgd_index(kvm, addr);
 	do {
 		/*
 		 * Release kvm_mmu_lock periodically if the memory region is
@@ -1370,9 +1373,9 @@ static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 		cond_resched_lock(&kvm->mmu_lock);
 		if (!READ_ONCE(kvm->arch.pgd))
 			break;
-		next = stage2_pgd_addr_end(addr, end);
-		if (stage2_pgd_present(*pgd))
-			stage2_wp_puds(pgd, addr, next);
+		next = stage2_pgd_addr_end(kvm, addr, end);
+		if (stage2_pgd_present(kvm, *pgd))
+			stage2_wp_puds(kvm, pgd, addr, next);
 	} while (pgd++, addr = next, addr != end);
 }
 
@@ -1521,7 +1524,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	up_read(&current->mm->mmap_sem);
 
 	/* We need minimum second+third level pages */
-	ret = mmu_topup_memory_cache(memcache, KVM_MMU_CACHE_MIN_PAGES,
+	ret = mmu_topup_memory_cache(memcache, kvm_mmu_cache_min_pages(kvm),
 				     KVM_NR_MEM_OBJS);
 	if (ret)
 		return ret;
@@ -1764,7 +1767,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	}
 
 	/* Userspace should not be able to register out-of-bounds IPAs */
-	VM_BUG_ON(fault_ipa >= KVM_PHYS_SIZE);
+	VM_BUG_ON(fault_ipa >= kvm_phys_size(vcpu->kvm));
 
 	if (fault_status == FSC_ACCESS) {
 		handle_access_fault(vcpu, fault_ipa);
@@ -2063,7 +2066,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	 * space addressable by the KVM guest IPA space.
 	 */
 	if (memslot->base_gfn + memslot->npages >=
-	    (KVM_PHYS_SIZE >> PAGE_SHIFT))
+	    (kvm_phys_size(kvm) >> PAGE_SHIFT))
 		return -EFAULT;
 
 	down_read(&current->mm->mmap_sem);
diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 6ada2432e37c..114dce9f4bf5 100644
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
2.19.0
