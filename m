From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 12/25] arm/arm64: KVM: Stop propagating cacheability status of a faulted page
Date: Thu,  9 Feb 2017 14:59:10 +0000
Message-ID: <1486652363-7696-13-git-send-email-marc.zyngier@arm.com>
References: <1486652363-7696-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1486652363-7696-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, Pavel Fedin <p.fedin@samsung.com>, Shanker Donthineni <shankerd@codeaurora.org>, Jintack Lim <jintack@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Now that we unconditionally flush newly mapped pages to the PoC,
there is no need to care about the "uncached" status of individual
pages - they must all be visible all the way down.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   |  3 +--
 arch/arm/kvm/mmu.c               | 11 ++++-------
 arch/arm64/include/asm/kvm_mmu.h |  3 +--
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index a58bbaa..95f38dc 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -129,8 +129,7 @@ static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
 
 static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu,
 					       kvm_pfn_t pfn,
-					       unsigned long size,
-					       bool ipa_uncached)
+					       unsigned long size)
 {
 	/*
 	 * If we are going to insert an instruction page and the icache is
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index a5265ed..5cc35080 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1232,9 +1232,9 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 }
 
 static void coherent_cache_guest_page(struct kvm_vcpu *vcpu, kvm_pfn_t pfn,
-				      unsigned long size, bool uncached)
+				      unsigned long size)
 {
-	__coherent_cache_guest_page(vcpu, pfn, size, uncached);
+	__coherent_cache_guest_page(vcpu, pfn, size);
 }
 
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
@@ -1250,7 +1250,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	struct vm_area_struct *vma;
 	kvm_pfn_t pfn;
 	pgprot_t mem_type = PAGE_S2;
-	bool fault_ipa_uncached;
 	bool logging_active = memslot_is_logging(memslot);
 	unsigned long flags = 0;
 
@@ -1337,8 +1336,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (!hugetlb && !force_pte)
 		hugetlb = transparent_hugepage_adjust(&pfn, &fault_ipa);
 
-	fault_ipa_uncached = memslot->flags & KVM_MEMSLOT_INCOHERENT;
-
 	if (hugetlb) {
 		pmd_t new_pmd = pfn_pmd(pfn, mem_type);
 		new_pmd = pmd_mkhuge(new_pmd);
@@ -1346,7 +1343,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			new_pmd = kvm_s2pmd_mkwrite(new_pmd);
 			kvm_set_pfn_dirty(pfn);
 		}
-		coherent_cache_guest_page(vcpu, pfn, PMD_SIZE, fault_ipa_uncached);
+		coherent_cache_guest_page(vcpu, pfn, PMD_SIZE);
 		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
 	} else {
 		pte_t new_pte = pfn_pte(pfn, mem_type);
@@ -1356,7 +1353,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			kvm_set_pfn_dirty(pfn);
 			mark_page_dirty(kvm, gfn);
 		}
-		coherent_cache_guest_page(vcpu, pfn, PAGE_SIZE, fault_ipa_uncached);
+		coherent_cache_guest_page(vcpu, pfn, PAGE_SIZE);
 		ret = stage2_set_pte(kvm, memcache, fault_ipa, &new_pte, flags);
 	}
 
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 6d22017..aa1e6db 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -236,8 +236,7 @@ static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
 
 static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu,
 					       kvm_pfn_t pfn,
-					       unsigned long size,
-					       bool ipa_uncached)
+					       unsigned long size)
 {
 	void *va = page_address(pfn_to_page(pfn));
 
-- 
2.1.4
