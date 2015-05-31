From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: [PATCH v2 08/11] KVM: arm: implement dirty bit mechanism for debug
 registers
Date: Sun, 31 May 2015 12:27:09 +0800
Message-ID: <1433046432-1824-9-git-send-email-zhichao.huang@linaro.org>
References: <1433046432-1824-1-git-send-email-zhichao.huang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6936852715
 for <kvmarm@lists.cs.columbia.edu>; Sun, 31 May 2015 00:19:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N2P5tLoxM2IE for <kvmarm@lists.cs.columbia.edu>;
 Sun, 31 May 2015 00:19:19 -0400 (EDT)
Received: from mail-pa0-f42.google.com (mail-pa0-f42.google.com
 [209.85.220.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 66F70525BA
 for <kvmarm@lists.cs.columbia.edu>; Sun, 31 May 2015 00:19:19 -0400 (EDT)
Received: by padjw17 with SMTP id jw17so13613229pad.2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 30 May 2015 21:29:11 -0700 (PDT)
In-Reply-To: <1433046432-1824-1-git-send-email-zhichao.huang@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com
Cc: huangzhichao@huawei.com, Zhichao Huang <zhichao.huang@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

The trapping code keeps track of the state of the debug registers,
allowing for the switch code to implement a lazy switching strategy.

Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
---
 arch/arm/include/asm/kvm_asm.h  |  3 +++
 arch/arm/include/asm/kvm_host.h |  3 +++
 arch/arm/kernel/asm-offsets.c   |  1 +
 arch/arm/kvm/coproc.c           | 32 +++++++++++++++++++++++++++++--
 arch/arm/kvm/interrupts_head.S  | 42 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index ba65e05..4fb64cf 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -64,6 +64,9 @@
 #define cp14_DBGDSCRext	65	/* Debug Status and Control external */
 #define NR_CP14_REGS	66	/* Number of regs (incl. invalid) */
 
+#define KVM_ARM_DEBUG_DIRTY_SHIFT	0
+#define KVM_ARM_DEBUG_DIRTY		(1 << KVM_ARM_DEBUG_DIRTY_SHIFT)
+
 #define ARM_EXCEPTION_RESET	  0
 #define ARM_EXCEPTION_UNDEFINED   1
 #define ARM_EXCEPTION_SOFTWARE    2
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 3d16820..09b54bf 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -127,6 +127,9 @@ struct kvm_vcpu_arch {
 	/* System control coprocessor (cp14) */
 	u32 cp14[NR_CP14_REGS];
 
+	/* Debug state */
+	u32 debug_flags;
+
 	/*
 	 * Anything that is not used directly from assembly code goes
 	 * here.
diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
index 9158de0..e876109 100644
--- a/arch/arm/kernel/asm-offsets.c
+++ b/arch/arm/kernel/asm-offsets.c
@@ -185,6 +185,7 @@ int main(void)
   DEFINE(VCPU_FIQ_REGS,		offsetof(struct kvm_vcpu, arch.regs.fiq_regs));
   DEFINE(VCPU_PC,		offsetof(struct kvm_vcpu, arch.regs.usr_regs.ARM_pc));
   DEFINE(VCPU_CPSR,		offsetof(struct kvm_vcpu, arch.regs.usr_regs.ARM_cpsr));
+  DEFINE(VCPU_DEBUG_FLAGS,	offsetof(struct kvm_vcpu, arch.debug_flags));
   DEFINE(VCPU_HCR,		offsetof(struct kvm_vcpu, arch.hcr));
   DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
   DEFINE(VCPU_HSR,		offsetof(struct kvm_vcpu, arch.fault.hsr));
diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index eeee648..1cc74d8 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -220,14 +220,42 @@ bool access_vm_reg(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+/*
+ * We want to avoid world-switching all the DBG registers all the
+ * time:
+ *
+ * - If we've touched any debug register, it is likely that we're
+ *   going to touch more of them. It then makes sense to disable the
+ *   traps and start doing the save/restore dance
+ * - If debug is active (ARM_DSCR_MDBGEN set), it is then mandatory
+ *   to save/restore the registers, as the guest depends on them.
+ *
+ * For this, we use a DIRTY bit, indicating the guest has modified the
+ * debug registers, used as follow:
+ *
+ * On guest entry:
+ * - If the dirty bit is set (because we're coming back from trapping),
+ *   disable the traps, save host registers, restore guest registers.
+ * - If debug is actively in use (ARM_DSCR_MDBGEN set),
+ *   set the dirty bit, disable the traps, save host registers,
+ *   restore guest registers.
+ * - Otherwise, enable the traps
+ *
+ * On guest exit:
+ * - If the dirty bit is set, save guest registers, restore host
+ *   registers and clear the dirty bit. This ensure that the host can
+ *   now use the debug registers.
+ */
 static bool trap_debug32(struct kvm_vcpu *vcpu,
 			const struct coproc_params *p,
 			const struct coproc_reg *r)
 {
-	if (p->is_write)
+	if (p->is_write) {
 		vcpu->arch.cp14[r->reg] = *vcpu_reg(vcpu, p->Rt1);
-	else
+		vcpu->arch.debug_flags |= KVM_ARM_DEBUG_DIRTY;
+	} else {
 		*vcpu_reg(vcpu, p->Rt1) = vcpu->arch.cp14[r->reg];
+	}
 
 	return true;
 }
diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
index 35e4a3a..3a0128c 100644
--- a/arch/arm/kvm/interrupts_head.S
+++ b/arch/arm/kvm/interrupts_head.S
@@ -1,4 +1,6 @@
 #include <linux/irqchip/arm-gic.h>
+#include <asm/hw_breakpoint.h>
+#include <asm/kvm_asm.h>
 #include <asm/assembler.h>
 
 #define VCPU_USR_REG(_reg_nr)	(VCPU_USR_REGS + (_reg_nr * 4))
@@ -396,6 +398,46 @@ vcpu	.req	r0		@ vcpu pointer always in r0
 	mcr	p15, 2, r12, c0, c0, 0	@ CSSELR
 .endm
 
+/* Assume vcpu pointer in vcpu reg, clobbers r5 */
+.macro skip_debug_state target
+	ldr	r5, [vcpu, #VCPU_DEBUG_FLAGS]
+	cmp	r5, #KVM_ARM_DEBUG_DIRTY
+	bne	\target
+1:
+.endm
+
+/* Compute debug state: If ARM_DSCR_MDBGEN or KVM_ARM_DEBUG_DIRTY
+ * is set, we do a full save/restore cycle and disable trapping.
+ *
+ * Assumes vcpu pointer in vcpu reg
+ *
+ * Clobbers r5, r6
+ */
+.macro compute_debug_state target
+	// Check the state of MDSCR_EL1
+	ldr	r5, [vcpu, #CP14_OFFSET(cp14_DBGDSCRext)]
+	and	r6, r5, #ARM_DSCR_MDBGEN
+	cmp	r6, #0
+	beq	9998f	   // Nothing to see there
+
+	// If ARM_DSCR_MDBGEN bit was set, we must set the flag
+	mov	r5, #KVM_ARM_DEBUG_DIRTY
+	str	r5, [vcpu, #VCPU_DEBUG_FLAGS]
+	b	9999f	   // Don't skip restore
+
+9998:
+	// Otherwise load the flags from memory in case we recently
+	// trapped
+	skip_debug_state \target
+9999:
+.endm
+
+/* Assume vcpu pointer in vcpu reg, clobbers r5 */
+.macro clear_debug_dirty_bit
+	mov	r5, #0
+	str	r5, [vcpu, #VCPU_DEBUG_FLAGS]
+.endm
+
 /*
  * Save the VGIC CPU state into memory
  *
-- 
1.7.12.4
