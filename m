From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 19/95] ARM: KVM: Add HYP mode entry code
Date: Wed,  9 Mar 2016 07:30:13 +0000
Message-ID: <1457508689-19672-20-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C901A49AF5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:32:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id blKgNXzUFJg2 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:32:39 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 118D64113E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:32:39 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This part is almost entierely borrowed from the existing code, just
slightly simplifying the HYP function call (as we now save SPSR_hyp
in the world switch).

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/hyp/Makefile    |   1 +
 arch/arm/kvm/hyp/hyp-entry.S | 157 +++++++++++++++++++++++++++++++++++++++++++
 arch/arm/kvm/hyp/hyp.h       |   2 +
 3 files changed, 160 insertions(+)
 create mode 100644 arch/arm/kvm/hyp/hyp-entry.S

diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
index cfab402..a7d3a7e 100644
--- a/arch/arm/kvm/hyp/Makefile
+++ b/arch/arm/kvm/hyp/Makefile
@@ -9,4 +9,5 @@ obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += vfp.o
 obj-$(CONFIG_KVM_ARM_HOST) += banked-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += entry.o
+obj-$(CONFIG_KVM_ARM_HOST) += hyp-entry.o
 obj-$(CONFIG_KVM_ARM_HOST) += switch.o
diff --git a/arch/arm/kvm/hyp/hyp-entry.S b/arch/arm/kvm/hyp/hyp-entry.S
new file mode 100644
index 0000000..1b4aa02
--- /dev/null
+++ b/arch/arm/kvm/hyp/hyp-entry.S
@@ -0,0 +1,157 @@
+/*
+ * Copyright (C) 2012 - Virtual Open Systems and Columbia University
+ * Author: Christoffer Dall <c.dall@virtualopensystems.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#include <linux/linkage.h>
+#include <asm/kvm_arm.h>
+#include <asm/kvm_asm.h>
+
+	.arch_extension     virt
+
+	.text
+	.pushsection	.hyp.text, "ax"
+
+.macro load_vcpu	reg
+	mrc	p15, 4, \reg, c13, c0, 2	@ HTPIDR
+.endm
+
+/********************************************************************
+ * Hypervisor exception vector and handlers
+ *
+ *
+ * The KVM/ARM Hypervisor ABI is defined as follows:
+ *
+ * Entry to Hyp mode from the host kernel will happen _only_ when an HVC
+ * instruction is issued since all traps are disabled when running the host
+ * kernel as per the Hyp-mode initialization at boot time.
+ *
+ * HVC instructions cause a trap to the vector page + offset 0x14 (see hyp_hvc
+ * below) when the HVC instruction is called from SVC mode (i.e. a guest or the
+ * host kernel) and they cause a trap to the vector page + offset 0x8 when HVC
+ * instructions are called from within Hyp-mode.
+ *
+ * Hyp-ABI: Calling HYP-mode functions from host (in SVC mode):
+ *    Switching to Hyp mode is done through a simple HVC #0 instruction. The
+ *    exception vector code will check that the HVC comes from VMID==0.
+ *    - r0 contains a pointer to a HYP function
+ *    - r1, r2, and r3 contain arguments to the above function.
+ *    - The HYP function will be called with its arguments in r0, r1 and r2.
+ *    On HYP function return, we return directly to SVC.
+ *
+ * Note that the above is used to execute code in Hyp-mode from a host-kernel
+ * point of view, and is a different concept from performing a world-switch and
+ * executing guest code SVC mode (with a VMID != 0).
+ */
+
+	.align 5
+__hyp_vector:
+	.global	__hyp_vector
+__kvm_hyp_vector:
+	.weak __kvm_hyp_vector
+
+	@ Hyp-mode exception vector
+	W(b)	hyp_reset
+	W(b)	hyp_undef
+	W(b)	hyp_svc
+	W(b)	hyp_pabt
+	W(b)	hyp_dabt
+	W(b)	hyp_hvc
+	W(b)	hyp_irq
+	W(b)	hyp_fiq
+
+.macro invalid_vector label, cause
+	.align
+\label:	b	.
+.endm
+
+	invalid_vector	hyp_reset
+	invalid_vector	hyp_undef
+	invalid_vector	hyp_svc
+	invalid_vector	hyp_pabt
+	invalid_vector	hyp_dabt
+	invalid_vector	hyp_fiq
+
+hyp_hvc:
+	/*
+	 * Getting here is either because of a trap from a guest,
+	 * or from executing HVC from the host kernel, which means
+	 * "do something in Hyp mode".
+	 */
+	push	{r0, r1, r2}
+
+	@ Check syndrome register
+	mrc	p15, 4, r1, c5, c2, 0	@ HSR
+	lsr	r0, r1, #HSR_EC_SHIFT
+	cmp	r0, #HSR_EC_HVC
+	bne	guest_trap		@ Not HVC instr.
+
+	/*
+	 * Let's check if the HVC came from VMID 0 and allow simple
+	 * switch to Hyp mode
+	 */
+	mrrc    p15, 6, r0, r2, c2
+	lsr     r2, r2, #16
+	and     r2, r2, #0xff
+	cmp     r2, #0
+	bne	guest_trap		@ Guest called HVC
+
+	/*
+	 * Getting here means host called HVC, we shift parameters and branch
+	 * to Hyp function.
+	 */
+	pop	{r0, r1, r2}
+
+	/* Check for __hyp_get_vectors */
+	cmp	r0, #-1
+	mrceq	p15, 4, r0, c12, c0, 0	@ get HVBAR
+	beq	1f
+
+	push	{lr}
+
+	mov	lr, r0
+	mov	r0, r1
+	mov	r1, r2
+	mov	r2, r3
+
+THUMB(	orr	lr, #1)
+	blx	lr			@ Call the HYP function
+
+	pop	{lr}
+1:	eret
+
+guest_trap:
+	load_vcpu r0			@ Load VCPU pointer to r0
+
+#ifdef CONFIG_VFPv3
+	@ Check for a VFP access
+	lsr	r1, r1, #HSR_EC_SHIFT
+	cmp	r1, #HSR_EC_CP_0_13
+	beq	__vfp_guest_restore
+#endif
+
+	mov	r1, #ARM_EXCEPTION_HVC
+	b	__guest_exit
+
+hyp_irq:
+	push	{r0, r1, r2}
+	mov	r1, #ARM_EXCEPTION_IRQ
+	load_vcpu r0			@ Load VCPU pointer to r0
+	b	__guest_exit
+
+	.ltorg
+
+	.popsection
diff --git a/arch/arm/kvm/hyp/hyp.h b/arch/arm/kvm/hyp/hyp.h
index 8b1156b..8b9c2eb 100644
--- a/arch/arm/kvm/hyp/hyp.h
+++ b/arch/arm/kvm/hyp/hyp.h
@@ -123,4 +123,6 @@ void __hyp_text __banked_restore_state(struct kvm_cpu_context *ctxt);
 
 int asmlinkage __guest_enter(struct kvm_vcpu *vcpu,
 			     struct kvm_cpu_context *host);
+int asmlinkage __hyp_do_panic(const char *, int, u32);
+
 #endif /* __ARM_KVM_HYP_H__ */
-- 
2.1.4
