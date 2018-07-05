From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v4 2/7] KVM: arm/arm64: Introduce helpers to manupulate page table entries
Date: Thu,  5 Jul 2018 15:08:45 +0100
Message-ID: <20180705140850.5801-3-punit.agrawal@arm.com>
References: <20180705140850.5801-1-punit.agrawal@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180705140850.5801-1-punit.agrawal@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: Punit Agrawal <punit.agrawal@arm.com>, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@arm.com, linux-kernel@vger.kernel.org, suzuki.poulose@arm.com, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Introduce helpers to abstract architectural handling of the conversion
of pfn to page table entries and marking a PMD page table entry as a
block entry.

The helpers are introduced in preparation for supporting PUD hugepages
at stage 2 - which are supported on arm64 but do not exist on arm.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   | 5 +++++
 arch/arm64/include/asm/kvm_mmu.h | 5 +++++
 virt/kvm/arm/mmu.c               | 8 +++++---
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 8553d68b7c8a..d095c2d0b284 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -75,6 +75,11 @@ phys_addr_t kvm_get_idmap_vector(void);
 int kvm_mmu_init(void);
 void kvm_clear_hyp_idmap(void);
 
+#define kvm_pfn_pte(pfn, prot)	pfn_pte(pfn, prot)
+#define kvm_pfn_pmd(pfn, prot)	pfn_pmd(pfn, prot)
+
+#define kvm_pmd_mkhuge(pmd)	pmd_mkhuge(pmd)
+
 static inline void kvm_set_pmd(pmd_t *pmd, pmd_t new_pmd)
 {
 	*pmd = new_pmd;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index fb9a7127bb75..689def9bb9d5 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -172,6 +172,11 @@ void kvm_clear_hyp_idmap(void);
 #define	kvm_set_pte(ptep, pte)		set_pte(ptep, pte)
 #define	kvm_set_pmd(pmdp, pmd)		set_pmd(pmdp, pmd)
 
+#define kvm_pfn_pte(pfn, prot)		pfn_pte(pfn, prot)
+#define kvm_pfn_pmd(pfn, prot)		pfn_pmd(pfn, prot)
+
+#define kvm_pmd_mkhuge(pmd)		pmd_mkhuge(pmd)
+
 static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
 {
 	pte_val(pte) |= PTE_S2_RDWR;
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index dd14cc36c51c..040cd0bce5e1 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1557,8 +1557,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		invalidate_icache_guest_page(pfn, vma_pagesize);
 
 	if (hugetlb && vma_pagesize == PMD_SIZE) {
-		pmd_t new_pmd = pfn_pmd(pfn, mem_type);
-		new_pmd = pmd_mkhuge(new_pmd);
+		pmd_t new_pmd = kvm_pfn_pmd(pfn, mem_type);
+
+		new_pmd = kvm_pmd_mkhuge(new_pmd);
+
 		if (writable)
 			new_pmd = kvm_s2pmd_mkwrite(new_pmd);
 
@@ -1567,7 +1569,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
 	} else {
-		pte_t new_pte = pfn_pte(pfn, mem_type);
+		pte_t new_pte = kvm_pfn_pte(pfn, mem_type);
 
 		if (writable) {
 			new_pte = kvm_s2pte_mkwrite(new_pte);
-- 
2.17.1
