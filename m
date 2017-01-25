From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 2/3] arm/arm64: KVM: Stop propagating cacheability status of a
 faulted page
Date: Wed, 25 Jan 2017 15:36:30 +0000
Message-ID: <1485358591-12278-3-git-send-email-marc.zyngier@arm.com>
References: <1485358591-12278-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4738340296
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jan 2017 10:36:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p+tF+IMAjU8P for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Jan 2017 10:36:29 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 754B840978
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jan 2017 10:36:29 -0500 (EST)
In-Reply-To: <1485358591-12278-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Now that we unconditionally flush newly mapped pages to the PoC,
there is no need to care about the "uncached" status of individual
pages - they must all be visible all the way down.

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
