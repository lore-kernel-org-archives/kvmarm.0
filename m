From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 14/29] kvm-arm: Cleanup kvm_* wrappers
Date: Wed, 11 May 2016 15:30:07 +0200
Message-ID: <1462973422-10021-15-git-send-email-christoffer.dall@linaro.org>
References: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Now that we have switched to explicit page table routines,
get rid of the obsolete kvm_* wrappers.

Also, kvm_tlb_flush_vmid_by_ipa is now called only on stage2
page tables, hence get rid of the redundant check.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   | 16 ----------------
 arch/arm/kvm/mmu.c               |  9 +--------
 arch/arm64/include/asm/kvm_mmu.h | 24 ------------------------
 3 files changed, 1 insertion(+), 48 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 5522cdd..a7736d5 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -136,22 +136,6 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
 	return (pmd_val(*pmd) & L_PMD_S2_RDWR) == L_PMD_S2_RDONLY;
 }
 
-
-/* Open coded p*d_addr_end that can deal with 64bit addresses */
-#define kvm_pgd_addr_end(addr, end)					\
-({	u64 __boundary = ((addr) + PGDIR_SIZE) & PGDIR_MASK;		\
-	(__boundary - 1 < (end) - 1)? __boundary: (end);		\
-})
-
-#define kvm_pud_addr_end(addr,end)		(end)
-
-#define kvm_pmd_addr_end(addr, end)					\
-({	u64 __boundary = ((addr) + PMD_SIZE) & PMD_MASK;		\
-	(__boundary - 1 < (end) - 1)? __boundary: (end);		\
-})
-
-#define kvm_pgd_index(addr)			pgd_index(addr)
-
 static inline bool kvm_page_empty(void *ptr)
 {
 	struct page *ptr_page = virt_to_page(ptr);
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index f2a6d9b..d3fa96e 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -66,14 +66,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 
 static void kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 {
-	/*
-	 * This function also gets called when dealing with HYP page
-	 * tables. As HYP doesn't have an associated struct kvm (and
-	 * the HYP page tables are fairly static), we don't do
-	 * anything there.
-	 */
-	if (kvm)
-		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, kvm, ipa);
+	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, kvm, ipa);
 }
 
 /*
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index edf3c62..a3c0d05 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -153,13 +153,6 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
 	return (pmd_val(*pmd) & PMD_S2_RDWR) == PMD_S2_RDONLY;
 }
 
-
-#define kvm_pgd_addr_end(addr, end)	pgd_addr_end(addr, end)
-#define kvm_pud_addr_end(addr, end)	pud_addr_end(addr, end)
-#define kvm_pmd_addr_end(addr, end)	pmd_addr_end(addr, end)
-
-#define kvm_pgd_index(addr)	(((addr) >> PGDIR_SHIFT) & (PTRS_PER_S2_PGD - 1))
-
 static inline void *kvm_get_hwpgd(struct kvm *kvm)
 {
 	pgd_t *pgd = kvm->arch.pgd;
@@ -232,23 +225,6 @@ static inline bool kvm_page_empty(void *ptr)
 	return page_count(ptr_page) == 1;
 }
 
-#define kvm_pte_table_empty(kvm, ptep) kvm_page_empty(ptep)
-
-#ifdef __PAGETABLE_PMD_FOLDED
-#define kvm_pmd_table_empty(kvm, pmdp) (0)
-#else
-#define kvm_pmd_table_empty(kvm, pmdp) \
-	(kvm_page_empty(pmdp) && (!(kvm) || KVM_PREALLOC_LEVEL < 2))
-#endif
-
-#ifdef __PAGETABLE_PUD_FOLDED
-#define kvm_pud_table_empty(kvm, pudp) (0)
-#else
-#define kvm_pud_table_empty(kvm, pudp) \
-	(kvm_page_empty(pudp) && (!(kvm) || KVM_PREALLOC_LEVEL < 1))
-#endif
-
-
 #define hyp_pte_table_empty(ptep) kvm_page_empty(ptep)
 
 #ifdef __PAGETABLE_PMD_FOLDED
-- 
2.1.2.330.g565301e.dirty

