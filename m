From: Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH] kvm: arm64: Enable hardware updates of the Access Flag for
 Stage 2 page tables
Date: Wed, 13 Apr 2016 17:57:37 +0100
Message-ID: <1460566657-30221-1-git-send-email-catalin.marinas@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6409E49B60
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2016 12:56:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xj7JlLDR4ZnN for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Apr 2016 12:56:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF42840B58
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2016 12:56:04 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The ARMv8.1 architecture extensions introduce support for hardware
updates of the access and dirty information in page table entries. With
VTCR_EL2.HA enabled (bit 21), when the CPU accesses an IPA with the
PTE_AF bit cleared in the stage 2 page table, instead of raising an
Access Flag fault to EL2 the CPU sets the actual page table entry bit
(10). To ensure that kernel modifications to the page table do not
inadvertently revert a bit set by hardware updates, certain Stage 2
software pte/pmd operations must be performed atomically.

The main user of the AF bit is the kvm_age_hva() mechanism. The
kvm_age_hva_handler() function performs a "test and clear young" action
on the pte/pmd. This needs to be atomic in respect of automatic hardware
updates of the AF bit. Since the AF bit is in the same position for both
Stage 1 and Stage 2, the patch reuses the existing
ptep_test_and_clear_young() functionality if
__HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG is defined. Otherwise, the
existing pte_young/pte_mkold mechanism is preserved.

The kvm_set_s2pte_readonly() (and the corresponding pmd equivalent) have
to perform atomic modifications in order to avoid a race with updates of
the AF bit. The arm64 implementation has been re-written using
exclusives.

Currently, kvm_set_s2pte_writable() (and pmd equivalent) take a pointer
argument and modify the pte/pmd in place. However, these functions are
only used on local variables rather than actual page table entries, so
it makes more sense to follow the pte_mkwrite() approach for stage 1
attributes. The change to kvm_s2pte_mkwrite() makes it clear that these
functions do not modify the actual page table entries.

The (pte|pmd)_mkyoung() uses on Stage 2 entries (setting the AF bit
explicitly) do not need to be modified since hardware updates of the
dirty status are not supported by KVM, so there is no possibility of
losing such information.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
---

After some digging through the KVM code, I concluded that hardware DBM
(dirty bit management) support is not feasible for Stage 2. A potential
user would be dirty logging but this requires a different bitmap exposed
to Qemu and, to avoid races, the stage 2 mappings need to be mapped
read-only on clean, writable on fault. This assumption simplifies the
hardware Stage 2 AF support.

Tested on a model with handle_access_fault() no longer being called when
the hardware AF is present and enabled. It needs swap enabling and light
memory pressure to trigger the page aging.

 arch/arm/include/asm/kvm_mmu.h   | 10 +++++----
 arch/arm/kvm/mmu.c               | 46 +++++++++++++++++++++++++---------------
 arch/arm64/include/asm/kvm_arm.h |  2 ++
 arch/arm64/include/asm/kvm_mmu.h | 27 +++++++++++++++++------
 arch/arm64/include/asm/pgtable.h | 13 ++++++++----
 arch/arm64/kvm/hyp/s2-setup.c    |  8 +++++++
 6 files changed, 74 insertions(+), 32 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index da44be9db4fa..bff1ca42a97e 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -105,14 +105,16 @@ static inline void kvm_clean_pte(pte_t *pte)
 	clean_pte_table(pte);
 }
 
-static inline void kvm_set_s2pte_writable(pte_t *pte)
+static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
 {
-	pte_val(*pte) |= L_PTE_S2_RDWR;
+	pte_val(pte) |= L_PTE_S2_RDWR;
+	return pte;
 }
 
-static inline void kvm_set_s2pmd_writable(pmd_t *pmd)
+static inline pmd_t kvm_s2pmd_mkwrite(pmd_t pmd)
 {
-	pmd_val(*pmd) |= L_PMD_S2_RDWR;
+	pmd_val(pmd) |= L_PMD_S2_RDWR;
+	return pmd;
 }
 
 static inline void kvm_set_s2pte_readonly(pte_t *pte)
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 58dbd5c439df..b6736ea85722 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -955,6 +955,27 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 	return 0;
 }
 
+#ifndef __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
+static int stage2_ptep_test_and_clear_young(pte_t *pte)
+{
+	if (pte_young(*pte)) {
+		*pte = pte_mkold(*pte);
+		return 1;
+	}
+	return 0;
+}
+#else
+static int stage2_ptep_test_and_clear_young(pte_t *pte)
+{
+	return __ptep_test_and_clear_young(pte);
+}
+#endif
+
+static int stage2_pmdp_test_and_clear_young(pmd_t *pmd)
+{
+	return stage2_ptep_test_and_clear_young((pte_t *)pmd);
+}
+
 /**
  * kvm_phys_addr_ioremap - map a device range to guest IPA
  *
@@ -978,7 +999,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 		pte_t pte = pfn_pte(pfn, PAGE_S2_DEVICE);
 
 		if (writable)
-			kvm_set_s2pte_writable(&pte);
+			pte = kvm_s2pte_mkwrite(pte);
 
 		ret = mmu_topup_memory_cache(&cache, KVM_MMU_CACHE_MIN_PAGES,
 						KVM_NR_MEM_OBJS);
@@ -1320,7 +1341,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		pmd_t new_pmd = pfn_pmd(pfn, mem_type);
 		new_pmd = pmd_mkhuge(new_pmd);
 		if (writable) {
-			kvm_set_s2pmd_writable(&new_pmd);
+			new_pmd = kvm_s2pmd_mkwrite(new_pmd);
 			kvm_set_pfn_dirty(pfn);
 		}
 		coherent_cache_guest_page(vcpu, pfn, PMD_SIZE, fault_ipa_uncached);
@@ -1329,7 +1350,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		pte_t new_pte = pfn_pte(pfn, mem_type);
 
 		if (writable) {
-			kvm_set_s2pte_writable(&new_pte);
+			new_pte = kvm_s2pte_mkwrite(new_pte);
 			kvm_set_pfn_dirty(pfn);
 			mark_page_dirty(kvm, gfn);
 		}
@@ -1348,6 +1369,8 @@ out_unlock:
  * Resolve the access fault by making the page young again.
  * Note that because the faulting entry is guaranteed not to be
  * cached in the TLB, we don't need to invalidate anything.
+ * Only the HW Access Flag updates are supported for Stage 2 (no DBM),
+ * so there is no need for atomic (pte|pmd)_mkyoung operations.
  */
 static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 {
@@ -1588,25 +1611,14 @@ static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
 	if (!pmd || pmd_none(*pmd))	/* Nothing there */
 		return 0;
 
-	if (kvm_pmd_huge(*pmd)) {	/* THP, HugeTLB */
-		if (pmd_young(*pmd)) {
-			*pmd = pmd_mkold(*pmd);
-			return 1;
-		}
-
-		return 0;
-	}
+	if (kvm_pmd_huge(*pmd))		/* THP, HugeTLB */
+		return stage2_pmdp_test_and_clear_young(pmd);
 
 	pte = pte_offset_kernel(pmd, gpa);
 	if (pte_none(*pte))
 		return 0;
 
-	if (pte_young(*pte)) {
-		*pte = pte_mkold(*pte);	/* Just a page... */
-		return 1;
-	}
-
-	return 0;
+	return stage2_ptep_test_and_clear_young(pte);
 }
 
 static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 4150fd8bae01..bbed53c2735a 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -110,6 +110,8 @@
 
 /* VTCR_EL2 Registers bits */
 #define VTCR_EL2_RES1		(1 << 31)
+#define VTCR_EL2_HD		(1 << 22)
+#define VTCR_EL2_HA		(1 << 21)
 #define VTCR_EL2_PS_MASK	(7 << 16)
 #define VTCR_EL2_TG0_MASK	(1 << 14)
 #define VTCR_EL2_TG0_4K		(0 << 14)
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 22732a5e3119..28bdf9ddaa0c 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -121,19 +121,32 @@ static inline void kvm_clean_pmd_entry(pmd_t *pmd) {}
 static inline void kvm_clean_pte(pte_t *pte) {}
 static inline void kvm_clean_pte_entry(pte_t *pte) {}
 
-static inline void kvm_set_s2pte_writable(pte_t *pte)
+static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
 {
-	pte_val(*pte) |= PTE_S2_RDWR;
+	pte_val(pte) |= PTE_S2_RDWR;
+	return pte;
 }
 
-static inline void kvm_set_s2pmd_writable(pmd_t *pmd)
+static inline pmd_t kvm_s2pmd_mkwrite(pmd_t pmd)
 {
-	pmd_val(*pmd) |= PMD_S2_RDWR;
+	pmd_val(pmd) |= PMD_S2_RDWR;
+	return pmd;
 }
 
 static inline void kvm_set_s2pte_readonly(pte_t *pte)
 {
-	pte_val(*pte) = (pte_val(*pte) & ~PTE_S2_RDWR) | PTE_S2_RDONLY;
+	pteval_t pteval;
+	unsigned long tmp;
+
+	asm volatile("//	kvm_set_s2pte_readonly\n"
+	"	prfm	pstl1strm, %2\n"
+	"1:	ldxr	%0, %2\n"
+	"	and	%0, %0, %3		// clear PTE_S2_RDWR\n"
+	"	orr	%0, %0, %4		// set PTE_S2_RDONLY\n"
+	"	stxr	%w1, %0, %2\n"
+	"	cbnz	%w1, 1b\n"
+	: "=&r" (pteval), "=&r" (tmp), "+Q" (pte_val(*pte))
+	: "L" (~PTE_S2_RDWR), "L" (PTE_S2_RDONLY));
 }
 
 static inline bool kvm_s2pte_readonly(pte_t *pte)
@@ -143,12 +156,12 @@ static inline bool kvm_s2pte_readonly(pte_t *pte)
 
 static inline void kvm_set_s2pmd_readonly(pmd_t *pmd)
 {
-	pmd_val(*pmd) = (pmd_val(*pmd) & ~PMD_S2_RDWR) | PMD_S2_RDONLY;
+	kvm_set_s2pte_readonly((pte_t *)pmd);
 }
 
 static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
 {
-	return (pmd_val(*pmd) & PMD_S2_RDWR) == PMD_S2_RDONLY;
+	return kvm_s2pte_readonly((pte_t *)pmd);
 }
 
 
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 989fef16d461..8d29e6eb33f7 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -530,14 +530,12 @@ static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
  * Atomic pte/pmd modifications.
  */
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long address,
-					    pte_t *ptep)
+static inline int __ptep_test_and_clear_young(pte_t *ptep)
 {
 	pteval_t pteval;
 	unsigned int tmp, res;
 
-	asm volatile("//	ptep_test_and_clear_young\n"
+	asm volatile("//	__ptep_test_and_clear_young\n"
 	"	prfm	pstl1strm, %2\n"
 	"1:	ldxr	%0, %2\n"
 	"	ubfx	%w3, %w0, %5, #1	// extract PTE_AF (young)\n"
@@ -550,6 +548,13 @@ static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
 	return res;
 }
 
+static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
+					    unsigned long address,
+					    pte_t *ptep)
+{
+	return __ptep_test_and_clear_young(ptep);
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
 static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
diff --git a/arch/arm64/kvm/hyp/s2-setup.c b/arch/arm64/kvm/hyp/s2-setup.c
index 5a9f3bf542b0..110267af0b83 100644
--- a/arch/arm64/kvm/hyp/s2-setup.c
+++ b/arch/arm64/kvm/hyp/s2-setup.c
@@ -33,6 +33,14 @@ void __hyp_text __init_stage2_translation(void)
 	val |= (read_sysreg(id_aa64mmfr0_el1) & 7) << 16;
 
 	/*
+	 * Check the availability of Hardware Access Flag / Dirty Bit
+	 * Management in ID_AA64MMFR1_EL1 and enable the feature in VTCR_EL2.
+	 */
+	tmp = (read_sysreg(id_aa64mmfr1_el1) >> ID_AA64MMFR1_HADBS_SHIFT) & 0xf;
+	if (IS_ENABLED(CONFIG_ARM64_HW_AFDBM) && tmp)
+		val |= VTCR_EL2_HA;
+
+	/*
 	 * Read the VMIDBits bits from ID_AA64MMFR1_EL1 and set the VS
 	 * bit in VTCR_EL2.
 	 */
