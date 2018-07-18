From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v4 14/20] kvm: arm64: Switch to per VM IPA limit
Date: Wed, 18 Jul 2018 10:18:57 +0100
Message-ID: <1531905547-25478-15-git-send-email-suzuki.poulose@arm.com>
References: <1531905547-25478-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B444B4A0D3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Jul 2018 05:07:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nhQm-hXEArgF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Jul 2018 05:06:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA10D49F87
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Jul 2018 05:06:58 -0400 (EDT)
In-Reply-To: <1531905547-25478-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: cdall@kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, dave.martin@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Now that we can manage the stage2 page table per VM, switch the
configuration details to per VM instance. The VTCR is updated
with the values specific to the VM based on the configuration.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/include/asm/kvm_host.h         | 6 ++++--
 arch/arm64/include/asm/kvm_arm.h        | 3 +++
 arch/arm64/include/asm/kvm_host.h       | 2 +-
 arch/arm64/include/asm/kvm_mmu.h        | 2 +-
 arch/arm64/include/asm/stage2_pgtable.h | 2 +-
 arch/arm64/kvm/guest.c                  | 8 ++++++--
 virt/kvm/arm/arm.c                      | 3 +--
 7 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 86f43ab..0ccfbc1 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -350,9 +350,11 @@ static inline void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu) {}
 struct kvm *kvm_arch_alloc_vm(void);
 void kvm_arch_free_vm(struct kvm *kvm);
 
-static inline int kvm_arm_config_vm(struct kvm *kvm)
+static inline int kvm_arm_config_vm(struct kvm *kvm, u32 ipa_shift)
 {
-	return 0;
+	if (ipa_shift == KVM_PHYS_SHIFT)
+		return 0;
+	return -EINVAL;
 }
 
 #endif /* __ARM_KVM_HOST_H__ */
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index abc7107..d7b6226 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -199,6 +199,9 @@
 	((sl0) + 4 - VTCR_EL2_TGRAN_SL0_BASE)
 #define VTCR_EL2_LVLS(vtcr)		\
 	VTCR_EL2_SL0_TO_LVLS(((vtcr) & VTCR_EL2_SL0_MASK) >> VTCR_EL2_SL0_SHIFT)
+
+#define VTCR_EL2_IPA(vtcr)	(64 - ((vtcr) & VTCR_EL2_T0SZ_MASK))
+
 /*
  * ARM VMSAv8-64 defines an algorithm for finding the translation table
  * descriptors in section D4.2.8 in ARM DDI 0487C.a.
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b1ffaf3..e64587c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -516,6 +516,6 @@ void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu);
 struct kvm *kvm_arch_alloc_vm(void);
 void kvm_arch_free_vm(struct kvm *kvm);
 
-int kvm_arm_config_vm(struct kvm *kvm);
+int kvm_arm_config_vm(struct kvm *kvm, u32 ipa_shift);
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 4f22772..4d1219b 100644
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
index a4fbb1a..1d7d3d7 100644
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
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index f7e1ece..af5520d 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -469,11 +469,13 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
  * all CPUs, as it is safe to run with or without the feature and
  * the bit is RES0 on CPUs that don't support it.
  */
-int kvm_arm_config_vm(struct kvm *kvm)
+int kvm_arm_config_vm(struct kvm *kvm, u32 ipa_shift)
 {
 	u64 vtcr = VTCR_EL2_FLAGS;
 	u64 parange;
 
+	if (ipa_shift != KVM_PHYS_SHIFT)
+		return -EINVAL;
 
 	parange = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1) & 7;
 	if (parange > ID_AA64MMFR0_PARANGE_MAX)
@@ -492,7 +494,9 @@ int kvm_arm_config_vm(struct kvm *kvm)
 		VTCR_EL2_VS_16BIT :
 		VTCR_EL2_VS_8BIT;
 
-	vtcr |= VTCR_EL2_LVLS_TO_SL0(kvm_stage2_levels(kvm));
+	vtcr |= VTCR_EL2_LVLS_TO_SL0(stage2_pgtable_levels(ipa_shift));
+	vtcr |= VTCR_EL2_T0SZ(ipa_shift);
+
 	kvm->arch.vtcr = vtcr;
 	return 0;
 }
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 2291487..21272dc 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -110,7 +110,6 @@ void kvm_arch_check_processor_compat(void *rtn)
 	*(int *)rtn = 0;
 }
 
-
 /**
  * kvm_arch_init_vm - initializes a VM data structure
  * @kvm:	pointer to the KVM struct
@@ -122,7 +121,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (type)
 		return -EINVAL;
 
-	ret = kvm_arm_config_vm(kvm);
+	ret = kvm_arm_config_vm(kvm, KVM_PHYS_SHIFT);
 	if (ret)
 		return ret;
 
-- 
2.7.4
