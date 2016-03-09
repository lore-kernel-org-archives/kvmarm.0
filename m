From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 26/95] ARM: KVM: Cleanup asm-offsets.c
Date: Wed,  9 Mar 2016 07:30:20 +0000
Message-ID: <1457508689-19672-27-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Since we don't have much assembler left, most of the KVM stuff
in asm-offsets.c is now superfluous. Let's get rid of it.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kernel/asm-offsets.c | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
index 2f3e0b0..1f24c32 100644
--- a/arch/arm/kernel/asm-offsets.c
+++ b/arch/arm/kernel/asm-offsets.c
@@ -170,42 +170,12 @@ int main(void)
   DEFINE(CACHE_WRITEBACK_GRANULE, __CACHE_WRITEBACK_GRANULE);
   BLANK();
 #ifdef CONFIG_KVM_ARM_HOST
-  DEFINE(VCPU_KVM,		offsetof(struct kvm_vcpu, kvm));
-  DEFINE(VCPU_MIDR,		offsetof(struct kvm_vcpu, arch.midr));
   DEFINE(VCPU_GUEST_CTXT,	offsetof(struct kvm_vcpu, arch.ctxt));
   DEFINE(VCPU_HOST_CTXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
   DEFINE(CPU_CTXT_VFP,		offsetof(struct kvm_cpu_context, vfp));
-  DEFINE(CPU_CTXT_CP15,		offsetof(struct kvm_cpu_context, cp15));
   DEFINE(CPU_CTXT_GP_REGS,	offsetof(struct kvm_cpu_context, gp_regs));
   DEFINE(GP_REGS_USR,		offsetof(struct kvm_regs, usr_regs));
-  DEFINE(GP_REGS_SVC,		offsetof(struct kvm_regs, svc_regs));
-  DEFINE(GP_REGS_ABT,		offsetof(struct kvm_regs, abt_regs));
-  DEFINE(GP_REGS_UND,		offsetof(struct kvm_regs, und_regs));
-  DEFINE(GP_REGS_IRQ,		offsetof(struct kvm_regs, irq_regs));
-  DEFINE(GP_REGS_FIQ,		offsetof(struct kvm_regs, fiq_regs));
-  DEFINE(GP_REGS_PC,		offsetof(struct kvm_regs, usr_regs.ARM_pc));
-  DEFINE(GP_REGS_CPSR,		offsetof(struct kvm_regs, usr_regs.ARM_cpsr));
-  DEFINE(VCPU_HCR,		offsetof(struct kvm_vcpu, arch.hcr));
-  DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
-  DEFINE(VCPU_HSR,		offsetof(struct kvm_vcpu, arch.fault.hsr));
-  DEFINE(VCPU_HxFAR,		offsetof(struct kvm_vcpu, arch.fault.hxfar));
-  DEFINE(VCPU_HPFAR,		offsetof(struct kvm_vcpu, arch.fault.hpfar));
   DEFINE(VCPU_HYP_PC,		offsetof(struct kvm_vcpu, arch.fault.hyp_pc));
-  DEFINE(VCPU_VGIC_CPU,		offsetof(struct kvm_vcpu, arch.vgic_cpu));
-  DEFINE(VGIC_V2_CPU_HCR,	offsetof(struct vgic_cpu, vgic_v2.vgic_hcr));
-  DEFINE(VGIC_V2_CPU_VMCR,	offsetof(struct vgic_cpu, vgic_v2.vgic_vmcr));
-  DEFINE(VGIC_V2_CPU_MISR,	offsetof(struct vgic_cpu, vgic_v2.vgic_misr));
-  DEFINE(VGIC_V2_CPU_EISR,	offsetof(struct vgic_cpu, vgic_v2.vgic_eisr));
-  DEFINE(VGIC_V2_CPU_ELRSR,	offsetof(struct vgic_cpu, vgic_v2.vgic_elrsr));
-  DEFINE(VGIC_V2_CPU_APR,	offsetof(struct vgic_cpu, vgic_v2.vgic_apr));
-  DEFINE(VGIC_V2_CPU_LR,	offsetof(struct vgic_cpu, vgic_v2.vgic_lr));
-  DEFINE(VGIC_CPU_NR_LR,	offsetof(struct vgic_cpu, nr_lr));
-  DEFINE(VCPU_TIMER_CNTV_CTL,	offsetof(struct kvm_vcpu, arch.timer_cpu.cntv_ctl));
-  DEFINE(VCPU_TIMER_CNTV_CVAL,	offsetof(struct kvm_vcpu, arch.timer_cpu.cntv_cval));
-  DEFINE(KVM_TIMER_CNTVOFF,	offsetof(struct kvm, arch.timer.cntvoff));
-  DEFINE(KVM_TIMER_ENABLED,	offsetof(struct kvm, arch.timer.enabled));
-  DEFINE(KVM_VGIC_VCTRL,	offsetof(struct kvm, arch.vgic.vctrl_base));
-  DEFINE(KVM_VTTBR,		offsetof(struct kvm, arch.vttbr));
 #endif
   BLANK();
 #ifdef CONFIG_VDSO
-- 
2.1.4

