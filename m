From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 27/95] ARM: KVM: Remove unused hyp_pc field
Date: Wed,  9 Mar 2016 07:30:21 +0000
Message-ID: <1457508689-19672-28-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This field was never populated, and the panic code already
does something similar. Delete the related code.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_emulate.h | 5 -----
 arch/arm/include/asm/kvm_host.h    | 1 -
 arch/arm/kernel/asm-offsets.c      | 1 -
 arch/arm/kvm/handle_exit.c         | 5 -----
 4 files changed, 12 deletions(-)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index f710616..8a8c6de 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -108,11 +108,6 @@ static inline phys_addr_t kvm_vcpu_get_fault_ipa(struct kvm_vcpu *vcpu)
 	return ((phys_addr_t)vcpu->arch.fault.hpfar & HPFAR_MASK) << 8;
 }
 
-static inline unsigned long kvm_vcpu_get_hyp_pc(struct kvm_vcpu *vcpu)
-{
-	return vcpu->arch.fault.hyp_pc;
-}
-
 static inline bool kvm_vcpu_dabt_isvalid(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_get_hsr(vcpu) & HSR_ISV;
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index daf6a71..19e9aba 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -85,7 +85,6 @@ struct kvm_vcpu_fault_info {
 	u32 hsr;		/* Hyp Syndrome Register */
 	u32 hxfar;		/* Hyp Data/Inst. Fault Address Register */
 	u32 hpfar;		/* Hyp IPA Fault Address Register */
-	u32 hyp_pc;		/* PC when exception was taken from Hyp mode */
 };
 
 /*
diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
index 1f24c32..27d0581 100644
--- a/arch/arm/kernel/asm-offsets.c
+++ b/arch/arm/kernel/asm-offsets.c
@@ -175,7 +175,6 @@ int main(void)
   DEFINE(CPU_CTXT_VFP,		offsetof(struct kvm_cpu_context, vfp));
   DEFINE(CPU_CTXT_GP_REGS,	offsetof(struct kvm_cpu_context, gp_regs));
   DEFINE(GP_REGS_USR,		offsetof(struct kvm_regs, usr_regs));
-  DEFINE(VCPU_HYP_PC,		offsetof(struct kvm_vcpu, arch.fault.hyp_pc));
 #endif
   BLANK();
 #ifdef CONFIG_VDSO
diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
index 3ede90d..5377d753 100644
--- a/arch/arm/kvm/handle_exit.c
+++ b/arch/arm/kvm/handle_exit.c
@@ -147,11 +147,6 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	switch (exception_index) {
 	case ARM_EXCEPTION_IRQ:
 		return 1;
-	case ARM_EXCEPTION_UNDEFINED:
-		kvm_err("Undefined exception in Hyp mode at: %#08lx\n",
-			kvm_vcpu_get_hyp_pc(vcpu));
-		BUG();
-		panic("KVM: Hypervisor undefined exception!\n");
 	case ARM_EXCEPTION_DATA_ABORT:
 	case ARM_EXCEPTION_PREF_ABORT:
 	case ARM_EXCEPTION_HVC:
-- 
2.1.4

