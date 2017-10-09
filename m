From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 08/10] KVM: arm/arm64: Drop vcpu parameter from coherent_{d,i}cache_guest_page
Date: Mon,  9 Oct 2017 16:20:30 +0100
Message-ID: <20171009152032.27804-9-marc.zyngier@arm.com>
References: <20171009152032.27804-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171009152032.27804-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The vcpu parameter isn't used for anything, and gets in the way of
further cleanups. Let's get rid of it.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   |  6 ++----
 arch/arm64/include/asm/kvm_mmu.h |  6 ++----
 virt/kvm/arm/mmu.c               | 18 ++++++++----------
 3 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index ad442d86c23e..5f1ac88a5951 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -150,8 +150,7 @@ static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
 	return (vcpu_cp15(vcpu, c1_SCTLR) & 0b101) == 0b101;
 }
 
-static inline void __coherent_dcache_guest_page(struct kvm_vcpu *vcpu,
-						kvm_pfn_t pfn,
+static inline void __coherent_dcache_guest_page(kvm_pfn_t pfn,
 						unsigned long size)
 {
 	/*
@@ -177,8 +176,7 @@ static inline void __coherent_dcache_guest_page(struct kvm_vcpu *vcpu,
 	}
 }
 
-static inline void __coherent_icache_guest_page(struct kvm_vcpu *vcpu,
-						kvm_pfn_t pfn,
+static inline void __coherent_icache_guest_page(kvm_pfn_t pfn,
 						unsigned long size)
 {
 	u32 iclsz;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index e7af74b8b51a..33dcc3c79574 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -252,8 +252,7 @@ static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
 	return (vcpu_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
 }
 
-static inline void __coherent_dcache_guest_page(struct kvm_vcpu *vcpu,
-						kvm_pfn_t pfn,
+static inline void __coherent_dcache_guest_page(kvm_pfn_t pfn,
 						unsigned long size)
 {
 	void *va = page_address(pfn_to_page(pfn));
@@ -261,8 +260,7 @@ static inline void __coherent_dcache_guest_page(struct kvm_vcpu *vcpu,
 	kvm_flush_dcache_to_poc(va, size);
 }
 
-static inline void __coherent_icache_guest_page(struct kvm_vcpu *vcpu,
-						kvm_pfn_t pfn,
+static inline void __coherent_icache_guest_page(kvm_pfn_t pfn,
 						unsigned long size)
 {
 	if (icache_is_aliasing()) {
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index ccc6106764a6..5b495450e92f 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1268,16 +1268,14 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
 }
 
-static void coherent_dcache_guest_page(struct kvm_vcpu *vcpu, kvm_pfn_t pfn,
-				       unsigned long size)
+static void coherent_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
 {
-	__coherent_dcache_guest_page(vcpu, pfn, size);
+	__coherent_dcache_guest_page(pfn, size);
 }
 
-static void coherent_icache_guest_page(struct kvm_vcpu *vcpu, kvm_pfn_t pfn,
-				       unsigned long size)
+static void coherent_icache_guest_page(kvm_pfn_t pfn, unsigned long size)
 {
-	__coherent_icache_guest_page(vcpu, pfn, size);
+	__coherent_icache_guest_page(pfn, size);
 }
 
 static void kvm_send_hwpoison_signal(unsigned long address,
@@ -1413,11 +1411,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		}
 
 		if (fault_status != FSC_PERM)
-			coherent_dcache_guest_page(vcpu, pfn, PMD_SIZE);
+			coherent_dcache_guest_page(pfn, PMD_SIZE);
 
 		if (exec_fault) {
 			new_pmd = kvm_s2pmd_mkexec(new_pmd);
-			coherent_icache_guest_page(vcpu, pfn, PMD_SIZE);
+			coherent_icache_guest_page(pfn, PMD_SIZE);
 		} else if (fault_status == FSC_PERM) {
 			/* Preserve execute if XN was already cleared */
 			pmd_t *old_pmdp = stage2_get_pmd(kvm, NULL, fault_ipa);
@@ -1438,11 +1436,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		}
 
 		if (fault_status != FSC_PERM)
-			coherent_dcache_guest_page(vcpu, pfn, PAGE_SIZE);
+			coherent_dcache_guest_page(pfn, PAGE_SIZE);
 
 		if (exec_fault) {
 			new_pte = kvm_s2pte_mkexec(new_pte);
-			coherent_icache_guest_page(vcpu, pfn, PAGE_SIZE);
+			coherent_icache_guest_page(pfn, PAGE_SIZE);
 		} else if (fault_status == FSC_PERM) {
 			/* Preserve execute if XN was already cleared */
 			pte_t *old_ptep = stage2_get_pte(kvm, fault_ipa);
-- 
2.14.1
