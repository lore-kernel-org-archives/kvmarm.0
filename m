From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 17/17] kvm: arm64: Allow IPA size supported by the system
Date: Tue, 27 Mar 2018 14:15:27 +0100
Message-ID: <1522156531-28348-18-git-send-email-suzuki.poulose@arm.com>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, cdall@kernel.org, marc.zyngier@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, ard.biesheuvel@linaro.org, peter.maydell@linaro.org, kristina.martsenko@arm.com, mark.rutland@arm.com, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

So far we have restricted the IPA size of the VM to the default
value (40bits). Now that we can manage the IPA size per VM and
support dynamic stage2 page tables, allow VMs to bigger IPA.
This is done by setting the IPA limit to the one supported by
the hardware and kernel. This patch also moves the check for
the default IPA size support to kvm_get_ipa_limit().

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  5 -----
 arch/arm64/include/asm/kvm_mmu.h  | 18 +++++++++++++++++-
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7b0af32..ec61e08 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -402,12 +402,7 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 
 static inline void __cpu_init_stage2(void)
 {
-	u32 ps;
-
 	kvm_call_hyp(__init_stage2_translation);
-	ps = id_aa64mmfr0_parange_to_phys_shift(read_sysreg(id_aa64mmfr0_el1));
-	WARN_ONCE(ps < 40,
-		  "PARange is %d bits, unsupported configuration!", ps);
 }
 
 /*
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index e86d7f4..6c5f0be 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -414,7 +414,23 @@ static inline u64 kvm_vttbr_baddr_mask(struct kvm *kvm)
 
 static inline u32 kvm_get_ipa_limit(void)
 {
-	return KVM_PHYS_SHIFT;
+	unsigned int ipa_max, parange;
+
+	parange = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1) & 0x7;
+	ipa_max = id_aa64mmfr0_parange_to_phys_shift(parange);
+
+	/* Raise the limit to the default size for backward compatibility */
+	if (ipa_max < KVM_PHYS_SHIFT) {
+		WARN_ONCE(1,
+			  "PARange is %d bits, unsupported configuration!",
+			  ipa_max);
+		ipa_max = KVM_PHYS_SHIFT;
+	}
+
+	/* Clamp it to the size supported by the kernel */
+	ipa_max = (ipa_max > PHYS_MASK_SHIFT) ? PHYS_MASK_SHIFT : ipa_max;
+
+	return ipa_max;
 }
 
 static inline void kvm_config_stage2(struct kvm *kvm, u8 ipa_shift)
-- 
2.7.4
