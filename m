From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 25/28] ARM: KVM: Cleanup asm-offsets.c
Date: Thu,  4 Feb 2016 11:00:42 +0000
Message-ID: <1454583645-10144-26-git-send-email-marc.zyngier@arm.com>
References: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C8814968B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 05:55:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xT6Yc-YsomOG for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2016 05:55:55 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9545B49861
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 05:55:48 -0500 (EST)
In-Reply-To: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Since we don't have much assembler left, most of the KVM stuff
in asm-offsets.c is now superfluous. Let's get rid of it.

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
