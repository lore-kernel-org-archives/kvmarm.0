From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v5 13/18] kvm: arm64: Switch to per VM IPA limit
Date: Mon, 17 Sep 2018 11:41:35 +0100
Message-ID: <20180917104144.19188-14-suzuki.poulose@arm.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180917104144.19188-1-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, cdall@kernel.org, eric.auger@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, catalin.marinas@arm.com, james.morse@arm.com, dave.martin@arm.com, julien.grall@arm.com, linux-kernel@vger.kernel.org, suzuki.poulose@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Now that we can manage the stage2 page table per VM, switch the
configuration details to per VM instance. The VTCR is updated
with the values specific to the VM based on the configuration.
We store the IPA size and the number of stage2 page table levels
for the guest already in VTCR. Decode it back from the vtcr
field wherever we need it.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h        | 3 +++
 arch/arm64/include/asm/kvm_mmu.h        | 2 +-
 arch/arm64/include/asm/stage2_pgtable.h | 2 +-
 arch/arm64/kvm/reset.c                  | 4 +++-
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 5c1487dc5dca..0a37c0513ede 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -200,6 +200,9 @@
 	((sl0) + 4 - VTCR_EL2_TGRAN_SL0_BASE)
 #define VTCR_EL2_LVLS(vtcr)		\
 	VTCR_EL2_SL0_TO_LVLS(((vtcr) & VTCR_EL2_SL0_MASK) >> VTCR_EL2_SL0_SHIFT)
+
+#define VTCR_EL2_IPA(vtcr)	(64 - ((vtcr) & VTCR_EL2_T0SZ_MASK))
+
 /*
  * ARM VMSAv8-64 defines an algorithm for finding the translation table
  * descriptors in section D4.2.8 in ARM DDI 0487C.a.
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index ac3ca9690bad..77b1af9e64db 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -142,7 +142,7 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
  */
 #define KVM_PHYS_SHIFT	(40)
 
-#define kvm_phys_shift(kvm)		KVM_PHYS_SHIFT
+#define kvm_phys_shift(kvm)		VTCR_EL2_IPA(kvm->arch.vtcr)
 #define kvm_phys_size(kvm)		(_AC(1, ULL) << kvm_phys_shift(kvm))
 #define kvm_phys_mask(kvm)		(kvm_phys_size(kvm) - _AC(1, ULL))
 
diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
index e5acda8e2e31..352ec4158fdf 100644
--- a/arch/arm64/include/asm/stage2_pgtable.h
+++ b/arch/arm64/include/asm/stage2_pgtable.h
@@ -43,7 +43,7 @@
  */
 #define stage2_pgtable_levels(ipa)	ARM64_HW_PGTABLE_LEVELS((ipa) - 4)
 #define STAGE2_PGTABLE_LEVELS		stage2_pgtable_levels(KVM_PHYS_SHIFT)
-#define kvm_stage2_levels(kvm)		stage2_pgtable_levels(kvm_phys_shift(kvm))
+#define kvm_stage2_levels(kvm)		VTCR_EL2_LVLS(kvm->arch.vtcr)
 
 /*
  * With all the supported VA_BITs and 40bit guest IPA, the following condition
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index d9b7a00993b6..51ecf0f7c912 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -167,7 +167,9 @@ int kvm_arm_config_vm(struct kvm *kvm, unsigned long type)
 	vtcr |= (kvm_get_vmid_bits() == 16) ?
 		VTCR_EL2_VS_16BIT :
 		VTCR_EL2_VS_8BIT;
-	vtcr |= VTCR_EL2_LVLS_TO_SL0(kvm_stage2_levels(kvm));
+	vtcr |= VTCR_EL2_LVLS_TO_SL0(stage2_pgtable_levels(KVM_PHYS_SHIFT));
+	vtcr |= VTCR_EL2_T0SZ(KVM_PHYS_SHIFT);
+
 	kvm->arch.vtcr = vtcr;
 	return 0;
 }
-- 
2.19.0
