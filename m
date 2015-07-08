From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 13/13] arm64: KVM: VHE: Early interrupt handling
Date: Wed,  8 Jul 2015 17:19:16 +0100
Message-ID: <1436372356-30410-14-git-send-email-marc.zyngier@arm.com>
References: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84D825812F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 12:08:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ib7xqYbJYcbP for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jul 2015 12:08:18 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CE8558147
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 12:08:15 -0400 (EDT)
In-Reply-To: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

With VHE enabled, it is possible to let the kernel handle an interrupt
without saving the full guest context, and without restoring the full
host context either. This reduces the latency of handling an interrupt.

When an interrupt fires we can:
- save the guest's general purpose registers, shared system registers
  and timer state
- switch to a host context (setting vectors, deactivating traps and
  stage-2 translation)
- restore the host's shared sysregs

At that stage, we're able to jump to the interrupt handler.

On return from the handler, we can finish the switch (save/restore
whatever is missing from the above).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/arm.c              |  3 +++
 arch/arm64/kvm/hyp.S            | 56 ++++++++++++++++++++++++++++++++++++++---
 arch/arm64/kvm/vgic-v2-switch.S | 19 +++++++++++---
 arch/arm64/kvm/vgic-v3-switch.S | 33 +++++++++++++-----------
 4 files changed, 90 insertions(+), 21 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index ca3c662..ab9333f 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -573,6 +573,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 * disabled.  Enabling the interrupts now will have
 		 * the effect of taking the interrupt again, in SVC
 		 * mode this time.
+		 *
+		 * With VHE, the interrupt is likely to have been
+		 * already taken already.
 		 */
 		local_irq_enable();
 
diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 3cbd2c4..ac95ba3 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -714,8 +714,10 @@ skip_el1_restore:
 .endm
 
 .macro skip_32bit_state tmp, target
-	// Skip 32bit state if not needed
-	mrs	\tmp, hcr_el2
+	// Skip 32bit state if not needed.
+	// With VHE, we may have cleared the RW bit in HCR_EL2 early,
+	// and have to rely on the memory version instead.
+ifnvhe "mrs	\tmp, hcr_el2",			_S_(ldr	\tmp, [x0, #VCPU_HCR_EL2])
 	tbnz	\tmp, #HCR_RW_SHIFT, \target
 .endm
 
@@ -1053,11 +1055,18 @@ __kvm_vcpu_return:
 	save_guest_32bit_state
 
 	save_timer_state
+ifnvhe "b	1f",		nop
+	alternative_insn	"bl __vgic_v2_disable", \
+				"bl __vgic_v3_disable", \
+				ARM64_HAS_SYSREG_GIC_CPUIF
+1:
 	save_vgic_state
 
 	deactivate_traps
 	deactivate_vm
 
+__kvm_vcpu_return_irq:
+
 	// Host context
 	ldr	x2, [x0, #VCPU_HOST_CONTEXT]
 	kern_hyp_va x2
@@ -1355,8 +1364,47 @@ el1_irq:
 	push	x0, x1
 	push	x2, x3
 	mrs	x0, tpidr_el2
-	mov	x1, #ARM_EXCEPTION_IRQ
-	b	__kvm_vcpu_return
+ifnvhe _S_(mov	x1, #ARM_EXCEPTION_IRQ),	nop
+ifnvhe "b	__kvm_vcpu_return", 		nop
+
+	// Fallthrough for VHE
+	add	x2, x0, #VCPU_CONTEXT
+
+	save_guest_regs
+	bl	__save_shared_sysregs
+	save_timer_state
+	alternative_insn	"bl __vgic_v2_disable", \
+				"bl __vgic_v3_disable", \
+				ARM64_HAS_SYSREG_GIC_CPUIF
+	deactivate_traps
+	deactivate_vm
+
+	isb	// Needed to ensure TGE is on and vectors have been switched
+
+	ldr	x2, [x0, #VCPU_HOST_CONTEXT]
+	restore_shared_sysregs
+
+	mov	x0, x2
+	adrp	x1, handle_arch_irq
+	add	x1, x1, #:lo12:handle_arch_irq
+	ldr	x1, [x1]
+	blr	x1
+
+	// Back from the interrupt handler, finalize the world switch
+	mrs	x0, tpidr_el2
+	add	x2, x0, #VCPU_CONTEXT
+
+	bl	__save_fpsimd
+	bl	__save_sysregs	// We've already saved the shared regs
+	save_guest_32bit_state
+
+	skip_debug_state x3, 1f
+	bl	__save_debug
+1:
+	save_vgic_state
+
+	mov	x1,	#ARM_EXCEPTION_IRQ
+	b	__kvm_vcpu_return_irq
 
 	.ltorg
 
diff --git a/arch/arm64/kvm/vgic-v2-switch.S b/arch/arm64/kvm/vgic-v2-switch.S
index 3f00071..c8864b4 100644
--- a/arch/arm64/kvm/vgic-v2-switch.S
+++ b/arch/arm64/kvm/vgic-v2-switch.S
@@ -26,16 +26,30 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_mmu.h>
 
+#include "vhe-macros.h"
+
 	.text
 	.pushsection	.hyp.text, "ax"
 
+ENTRY(__vgic_v2_disable)
+	/* Get VGIC VCTRL base into x2 */
+	ldr	x2, [x0, #VCPU_KVM]
+	kern_hyp_va	x2
+	ldr	x2, [x2, #KVM_VGIC_VCTRL]
+	kern_hyp_va	x2
+	cbz	x2, 1f		// disabled
+
+	/* Clear GICH_HCR */
+	str	wzr, [x2, #GICH_HCR]
+1:	ret
+ENDPROC(__vgic_v2_disable)
+
 /*
  * Save the VGIC CPU state into memory
  * x0: Register pointing to VCPU struct
  * Do not corrupt x1!!!
  */
 ENTRY(__save_vgic_v2_state)
-__save_vgic_v2_state:
 	/* Get VGIC VCTRL base into x2 */
 	ldr	x2, [x0, #VCPU_KVM]
 	kern_hyp_va	x2
@@ -75,7 +89,7 @@ CPU_BE(	str	w10, [x3, #VGIC_V2_CPU_ELRSR] )
 	str	w11, [x3, #VGIC_V2_CPU_APR]
 
 	/* Clear GICH_HCR */
-	str	wzr, [x2, #GICH_HCR]
+ifnvhe	_S_(str	wzr, [x2, #GICH_HCR]),		nop
 
 	/* Save list registers */
 	add	x2, x2, #GICH_LR0
@@ -95,7 +109,6 @@ ENDPROC(__save_vgic_v2_state)
  * x0: Register pointing to VCPU struct
  */
 ENTRY(__restore_vgic_v2_state)
-__restore_vgic_v2_state:
 	/* Get VGIC VCTRL base into x2 */
 	ldr	x2, [x0, #VCPU_KVM]
 	kern_hyp_va	x2
diff --git a/arch/arm64/kvm/vgic-v3-switch.S b/arch/arm64/kvm/vgic-v3-switch.S
index 3c20730..b9b45e3 100644
--- a/arch/arm64/kvm/vgic-v3-switch.S
+++ b/arch/arm64/kvm/vgic-v3-switch.S
@@ -25,6 +25,8 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_arm.h>
 
+#include "vhe-macros.h"
+
 	.text
 	.pushsection	.hyp.text, "ax"
 
@@ -35,11 +37,21 @@
 #define LR_OFFSET(n)	(VGIC_V3_CPU_LR + (15 - n) * 8)
 
 /*
+ * Disable the vcpu interface, preventing interrupts from
+ * being delivered.
+ */
+ENTRY(__vgic_v3_disable)
+	// Nuke the HCR register.
+	msr_s	ICH_HCR_EL2, xzr
+	ret
+ENDPROC(__vgic_v3_disable)
+
+/*
  * Save the VGIC CPU state into memory
  * x0: Register pointing to VCPU struct
  * Do not corrupt x1!!!
  */
-.macro	save_vgic_v3_state
+ENTRY(__save_vgic_v3_state)
 	// Compute the address of struct vgic_cpu
 	add	x3, x0, #VCPU_VGIC_CPU
 
@@ -58,7 +70,7 @@
 	str	w7, [x3, #VGIC_V3_CPU_EISR]
 	str	w8, [x3, #VGIC_V3_CPU_ELRSR]
 
-	msr_s	ICH_HCR_EL2, xzr
+ifnvhe	_S_(msr_s	ICH_HCR_EL2, xzr),	nop
 
 	mrs_s	x21, ICH_VTR_EL2
 	mvn	w22, w21
@@ -137,15 +149,17 @@
 	orr	x5, x5, #ICC_SRE_EL2_ENABLE
 	msr_s	ICC_SRE_EL2, x5
 	isb
-	mov	x5, #1
+	// If using VHE, we don't care about EL1 and can early out.
+ifnvhe "mov	x5, #1",			ret
 	msr_s	ICC_SRE_EL1, x5
-.endm
+	ret
+ENDPROC(__save_vgic_v3_state)
 
 /*
  * Restore the VGIC CPU state from memory
  * x0: Register pointing to VCPU struct
  */
-.macro	restore_vgic_v3_state
+ENTRY(__restore_vgic_v3_state)
 	// Compute the address of struct vgic_cpu
 	add	x3, x0, #VCPU_VGIC_CPU
 
@@ -249,15 +263,6 @@
 	and	x5, x5, #~ICC_SRE_EL2_ENABLE
 	msr_s	ICC_SRE_EL2, x5
 1:
-.endm
-
-ENTRY(__save_vgic_v3_state)
-	save_vgic_v3_state
-	ret
-ENDPROC(__save_vgic_v3_state)
-
-ENTRY(__restore_vgic_v3_state)
-	restore_vgic_v3_state
 	ret
 ENDPROC(__restore_vgic_v3_state)
 
-- 
2.1.4
