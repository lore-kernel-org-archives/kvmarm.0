From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 14/17] kvm: arm64: Switch to per VM IPA limit
Date: Tue, 27 Mar 2018 14:15:24 +0100
Message-ID: <1522156531-28348-15-git-send-email-suzuki.poulose@arm.com>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, cdall@kernel.org, marc.zyngier@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, ard.biesheuvel@linaro.org, peter.maydell@linaro.org, kristina.martsenko@arm.com, mark.rutland@arm.com, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Now that we can manage the stage2 page table per VM, switch the
configuration details to per VM instance. We keep track of the
IPA bits, number of page table levels and the VTCR bits (which
depends on the IPA and the number of levels). While at it, remove
unused pgd_lock field from kvm_arch for arm64.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_host.h       | 14 ++++++++++++--
 arch/arm64/include/asm/kvm_mmu.h        | 11 +++++++++--
 arch/arm64/include/asm/stage2_pgtable.h |  1 -
 arch/arm64/kvm/hyp/switch.c             |  3 +--
 virt/kvm/arm/mmu.c                      |  4 ++++
 5 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9f3c8b8..7b0af32 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -60,13 +60,23 @@ struct kvm_arch {
 	u64    vmid_gen;
 	u32    vmid;
 
-	/* 1-level 2nd stage table and lock */
-	spinlock_t pgd_lock;
+	/* stage-2 page table */
 	pgd_t *pgd;
 
 	/* VTTBR value associated with above pgd and vmid */
 	u64    vttbr;
 
+	/* Private bits of VTCR_EL2 for this VM */
+	u64    vtcr_private;
+	/* Size of the PA size for this guest */
+	u8     phys_shift;
+	/*
+	 * Number of levels in page table. We could always calculate
+	 * it from phys_shift above. We cache it for faster switches
+	 * in stage2 page table helpers.
+	 */
+	u8     s2_levels;
+
 	/* The last vcpu id that ran on each physical CPU */
 	int __percpu *last_vcpu_ran;
 
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index bb458bf..e86d7f4 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -136,9 +136,10 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
  */
 #define KVM_PHYS_SHIFT	(40)
 
-#define kvm_phys_shift(kvm)		KVM_PHYS_SHIFT
+#define kvm_phys_shift(kvm)		(kvm->arch.phys_shift)
 #define kvm_phys_size(kvm)		(_AC(1, ULL) << kvm_phys_shift(kvm))
 #define kvm_phys_mask(kvm)		(kvm_phys_size(kvm) - _AC(1, ULL))
+#define kvm_stage2_levels(kvm)		(kvm->arch.s2_levels)
 
 static inline bool kvm_page_empty(void *ptr)
 {
@@ -416,7 +417,13 @@ static inline u32 kvm_get_ipa_limit(void)
 	return KVM_PHYS_SHIFT;
 }
 
-static inline void kvm_config_stage2(struct kvm *kvm, u32 ipa_shift) {}
+static inline void kvm_config_stage2(struct kvm *kvm, u8 ipa_shift)
+{
+	kvm->arch.phys_shift = ipa_shift;
+	kvm->arch.s2_levels = stage2_pt_levels(ipa_shift);
+	kvm->arch.vtcr_private = VTCR_EL2_SL0(kvm->arch.s2_levels) |
+				 TCR_T0SZ(ipa_shift);
+}
 
 #endif /* __ASSEMBLY__ */
 #endif /* __ARM64_KVM_MMU_H__ */
diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
index 33e8ebb..9b75b83 100644
--- a/arch/arm64/include/asm/stage2_pgtable.h
+++ b/arch/arm64/include/asm/stage2_pgtable.h
@@ -44,7 +44,6 @@
  */
 #define __s2_pgd_ptrs(pa, lvls)	(1 << ((pa) - pt_levels_pgdir_shift((lvls))))
 
-#define kvm_stage2_levels(kvm)		stage2_pt_levels(kvm_phys_shift(kvm))
 #define stage2_pgdir_shift(kvm)	\
 		pt_levels_pgdir_shift(kvm_stage2_levels(kvm))
 #define stage2_pgdir_size(kvm)		(_AC(1, UL) << stage2_pgdir_shift((kvm)))
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 5ccd3ae..794da55 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -167,8 +167,7 @@ static void __hyp_text __activate_vm(struct kvm_vcpu *vcpu)
 	u64 vtcr = read_sysreg(vtcr_el2);
 
 	vtcr &= ~VTCR_EL2_PRIVATE_MASK;
-	vtcr |= VTCR_EL2_SL0(kvm_stage2_levels(kvm)) |
-		VTCR_EL2_T0SZ(kvm_phys_shift(kvm));
+	vtcr |= kvm->arch.vtcr_private;
 	write_sysreg(vtcr, vtcr_el2);
 	write_sysreg(kvm->arch.vttbr, vttbr_el2);
 }
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 7a264c6..746f38e 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -753,6 +753,10 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
 		return -EINVAL;
 	}
 
+	/* Make sure we have the stage2 configured for this VM */
+	if (WARN_ON(!kvm_stage2_levels(kvm)))
+		return -EINVAL;
+
 	/* Allocate the HW PGD, making sure that each page gets its own refcount */
 	pgd = alloc_pages_exact(stage2_pgd_size(kvm), GFP_KERNEL | __GFP_ZERO);
 	if (!pgd)
-- 
2.7.4
