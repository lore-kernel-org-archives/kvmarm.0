From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 7/8] KVM: arm/arm64: Drop vcpu parameter from guest cache
 maintenance operartions
Date: Fri, 20 Oct 2017 16:49:03 +0100
Message-ID: <20171020154904.31427-8-marc.zyngier@arm.com>
References: <20171020154904.31427-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0EEE49D43
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 11:48:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SiM-GRAcSVyZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Oct 2017 11:48:23 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2210249D3F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 11:48:22 -0400 (EDT)
In-Reply-To: <20171020154904.31427-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The vcpu parameter isn't used for anything, and gets in the way of
further cleanups. Let's get rid of it.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   |  7 ++-----
 arch/arm64/include/asm/kvm_mmu.h |  7 ++-----
 virt/kvm/arm/mmu.c               | 18 ++++++++----------
 3 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index aab64fe52146..bc70a1f0f42d 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -150,9 +150,7 @@ static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
 	return (vcpu_cp15(vcpu, c1_SCTLR) & 0b101) == 0b101;
 }
 
-static inline void __clean_dcache_guest_page(struct kvm_vcpu *vcpu,
-					     kvm_pfn_t pfn,
-					     unsigned long size)
+static inline void __clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
 {
 	/*
 	 * Clean the dcache to the Point of Coherency.
@@ -177,8 +175,7 @@ static inline void __clean_dcache_guest_page(struct kvm_vcpu *vcpu,
 	}
 }
 
-static inline void __invalidate_icache_guest_page(struct kvm_vcpu *vcpu,
-						  kvm_pfn_t pfn,
+static inline void __invalidate_icache_guest_page(kvm_pfn_t pfn,
 						  unsigned long size)
 {
 	u32 iclsz;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 126abefffe7f..06f1f9794679 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -252,17 +252,14 @@ static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
 	return (vcpu_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
 }
 
-static inline void __clean_dcache_guest_page(struct kvm_vcpu *vcpu,
-					     kvm_pfn_t pfn,
-					     unsigned long size)
+static inline void __clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
 {
 	void *va = page_address(pfn_to_page(pfn));
 
 	kvm_flush_dcache_to_poc(va, size);
 }
 
-static inline void __invalidate_icache_guest_page(struct kvm_vcpu *vcpu,
-						  kvm_pfn_t pfn,
+static inline void __invalidate_icache_guest_page(kvm_pfn_t pfn,
 						  unsigned long size)
 {
 	if (icache_is_aliasing()) {
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index b83b5a8442bb..a1ea43fa75cf 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1276,16 +1276,14 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
 }
 
-static void clean_dcache_guest_page(struct kvm_vcpu *vcpu, kvm_pfn_t pfn,
-				    unsigned long size)
+static void clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
 {
-	__clean_dcache_guest_page(vcpu, pfn, size);
+	__clean_dcache_guest_page(pfn, size);
 }
 
-static void invalidate_icache_guest_page(struct kvm_vcpu *vcpu, kvm_pfn_t pfn,
-					 unsigned long size)
+static void invalidate_icache_guest_page(kvm_pfn_t pfn, unsigned long size)
 {
-	__invalidate_icache_guest_page(vcpu, pfn, size);
+	__invalidate_icache_guest_page(pfn, size);
 }
 
 static void kvm_send_hwpoison_signal(unsigned long address,
@@ -1421,11 +1419,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		}
 
 		if (fault_status != FSC_PERM)
-			clean_dcache_guest_page(vcpu, pfn, PMD_SIZE);
+			clean_dcache_guest_page(pfn, PMD_SIZE);
 
 		if (exec_fault) {
 			new_pmd = kvm_s2pmd_mkexec(new_pmd);
-			invalidate_icache_guest_page(vcpu, pfn, PMD_SIZE);
+			invalidate_icache_guest_page(pfn, PMD_SIZE);
 		} else if (fault_status == FSC_PERM) {
 			/* Preserve execute if XN was already cleared */
 			if (stage2_is_exec(kvm, fault_ipa))
@@ -1443,11 +1441,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		}
 
 		if (fault_status != FSC_PERM)
-			clean_dcache_guest_page(vcpu, pfn, PAGE_SIZE);
+			clean_dcache_guest_page(pfn, PAGE_SIZE);
 
 		if (exec_fault) {
 			new_pte = kvm_s2pte_mkexec(new_pte);
-			invalidate_icache_guest_page(vcpu, pfn, PAGE_SIZE);
+			invalidate_icache_guest_page(pfn, PAGE_SIZE);
 		} else if (fault_status == FSC_PERM) {
 			/* Preserve execute if XN was already cleared */
 			if (stage2_is_exec(kvm, fault_ipa))
-- 
2.14.1
