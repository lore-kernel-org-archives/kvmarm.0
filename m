From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 01/10] KVM: arm/arm64: Split dcache/icache flushing
Date: Mon,  9 Oct 2017 16:20:23 +0100
Message-ID: <20171009152032.27804-2-marc.zyngier@arm.com>
References: <20171009152032.27804-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171009152032.27804-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

As we're about to introduce opportunistic invalidation of the icache,
let's split dcache and icache flushing.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   | 60 ++++++++++++++++++++++++++++------------
 arch/arm64/include/asm/kvm_mmu.h | 13 +++++++--
 virt/kvm/arm/mmu.c               | 20 ++++++++++----
 3 files changed, 67 insertions(+), 26 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index fa6f2174276b..f553aa62d0c3 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -126,21 +126,12 @@ static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
 	return (vcpu_cp15(vcpu, c1_SCTLR) & 0b101) == 0b101;
 }
 
-static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu,
-					       kvm_pfn_t pfn,
-					       unsigned long size)
+static inline void __coherent_dcache_guest_page(struct kvm_vcpu *vcpu,
+						kvm_pfn_t pfn,
+						unsigned long size)
 {
 	/*
-	 * If we are going to insert an instruction page and the icache is
-	 * either VIPT or PIPT, there is a potential problem where the host
-	 * (or another VM) may have used the same page as this guest, and we
-	 * read incorrect data from the icache.  If we're using a PIPT cache,
-	 * we can invalidate just that page, but if we are using a VIPT cache
-	 * we need to invalidate the entire icache - damn shame - as written
-	 * in the ARM ARM (DDI 0406C.b - Page B3-1393).
-	 *
-	 * VIVT caches are tagged using both the ASID and the VMID and doesn't
-	 * need any kind of flushing (DDI 0406C.b - Page B3-1392).
+	 * Clean the dcache to the Point of Coherency.
 	 *
 	 * We need to do this through a kernel mapping (using the
 	 * user-space mapping has proved to be the wrong
@@ -155,19 +146,52 @@ static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu,
 
 		kvm_flush_dcache_to_poc(va, PAGE_SIZE);
 
-		if (icache_is_pipt())
-			__cpuc_coherent_user_range((unsigned long)va,
-						   (unsigned long)va + PAGE_SIZE);
-
 		size -= PAGE_SIZE;
 		pfn++;
 
 		kunmap_atomic(va);
 	}
+}
 
-	if (!icache_is_pipt() && !icache_is_vivt_asid_tagged()) {
+static inline void __coherent_icache_guest_page(struct kvm_vcpu *vcpu,
+						kvm_pfn_t pfn,
+						unsigned long size)
+{
+	/*
+	 * If we are going to insert an instruction page and the icache is
+	 * either VIPT or PIPT, there is a potential problem where the host
+	 * (or another VM) may have used the same page as this guest, and we
+	 * read incorrect data from the icache.  If we're using a PIPT cache,
+	 * we can invalidate just that page, but if we are using a VIPT cache
+	 * we need to invalidate the entire icache - damn shame - as written
+	 * in the ARM ARM (DDI 0406C.b - Page B3-1393).
+	 *
+	 * VIVT caches are tagged using both the ASID and the VMID and doesn't
+	 * need any kind of flushing (DDI 0406C.b - Page B3-1392).
+	 */
+
+	VM_BUG_ON(size & ~PAGE_MASK);
+
+	if (icache_is_vivt_asid_tagged())
+		return;
+
+	if (!icache_is_pipt()) {
 		/* any kind of VIPT cache */
 		__flush_icache_all();
+		return;
+	}
+
+	/* PIPT cache. As for the d-side, use a temporary kernel mapping. */
+	while (size) {
+		void *va = kmap_atomic_pfn(pfn);
+
+		__cpuc_coherent_user_range((unsigned long)va,
+					   (unsigned long)va + PAGE_SIZE);
+
+		size -= PAGE_SIZE;
+		pfn++;
+
+		kunmap_atomic(va);
 	}
 }
 
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 672c8684d5c2..4c4cb4f0e34f 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -230,19 +230,26 @@ static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
 	return (vcpu_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
 }
 
-static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu,
-					       kvm_pfn_t pfn,
-					       unsigned long size)
+static inline void __coherent_dcache_guest_page(struct kvm_vcpu *vcpu,
+						kvm_pfn_t pfn,
+						unsigned long size)
 {
 	void *va = page_address(pfn_to_page(pfn));
 
 	kvm_flush_dcache_to_poc(va, size);
+}
 
+static inline void __coherent_icache_guest_page(struct kvm_vcpu *vcpu,
+						kvm_pfn_t pfn,
+						unsigned long size)
+{
 	if (icache_is_aliasing()) {
 		/* any kind of VIPT cache */
 		__flush_icache_all();
 	} else if (is_kernel_in_hyp_mode() || !icache_is_vpipt()) {
 		/* PIPT or VPIPT at EL2 (see comment in __kvm_tlb_flush_vmid_ipa) */
+		void *va = page_address(pfn_to_page(pfn));
+
 		flush_icache_range((unsigned long)va,
 				   (unsigned long)va + size);
 	}
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index b36945d49986..9e5628388af8 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1257,10 +1257,16 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
 }
 
-static void coherent_cache_guest_page(struct kvm_vcpu *vcpu, kvm_pfn_t pfn,
-				      unsigned long size)
+static void coherent_dcache_guest_page(struct kvm_vcpu *vcpu, kvm_pfn_t pfn,
+				       unsigned long size)
 {
-	__coherent_cache_guest_page(vcpu, pfn, size);
+	__coherent_dcache_guest_page(vcpu, pfn, size);
+}
+
+static void coherent_icache_guest_page(struct kvm_vcpu *vcpu, kvm_pfn_t pfn,
+				       unsigned long size)
+{
+	__coherent_icache_guest_page(vcpu, pfn, size);
 }
 
 static void kvm_send_hwpoison_signal(unsigned long address,
@@ -1391,7 +1397,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			new_pmd = kvm_s2pmd_mkwrite(new_pmd);
 			kvm_set_pfn_dirty(pfn);
 		}
-		coherent_cache_guest_page(vcpu, pfn, PMD_SIZE);
+		coherent_dcache_guest_page(vcpu, pfn, PMD_SIZE);
+		coherent_icache_guest_page(vcpu, pfn, PMD_SIZE);
+
 		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
 	} else {
 		pte_t new_pte = pfn_pte(pfn, mem_type);
@@ -1401,7 +1409,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			kvm_set_pfn_dirty(pfn);
 			mark_page_dirty(kvm, gfn);
 		}
-		coherent_cache_guest_page(vcpu, pfn, PAGE_SIZE);
+		coherent_dcache_guest_page(vcpu, pfn, PAGE_SIZE);
+		coherent_icache_guest_page(vcpu, pfn, PAGE_SIZE);
+
 		ret = stage2_set_pte(kvm, memcache, fault_ipa, &new_pte, flags);
 	}
 
-- 
2.14.1
