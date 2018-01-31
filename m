From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 21/28] KVM: arm/arm64: Drop vcpu parameter from guest cache maintenance operartions
Date: Wed, 31 Jan 2018 10:35:00 +0100
Message-ID: <20180131093507.22219-22-christoffer.dall@linaro.org>
References: <20180131093507.22219-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180131093507.22219-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

The vcpu parameter isn't used for anything, and gets in the way of
further cleanups. Let's get rid of it.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
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
2.14.2
