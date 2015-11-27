From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 14/21] arm64: KVM: HYP mode entry points
Date: Fri, 27 Nov 2015 18:50:08 +0000
Message-ID: <1448650215-15218-15-git-send-email-marc.zyngier@arm.com>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B04948535
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2015 13:49:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F4FZA4H+50Y1 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Nov 2015 13:49:46 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AB7D41AF6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2015 13:49:46 -0500 (EST)
In-Reply-To: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Add the entry points for HYP mode (both for hypercalls and
exception handling).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/Makefile    |   1 +
 arch/arm64/kvm/hyp/hyp-entry.S | 198 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 199 insertions(+)
 create mode 100644 arch/arm64/kvm/hyp/hyp-entry.S

diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 1a529f5..826032b 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_KVM_ARM_HOST) += entry.o
 obj-$(CONFIG_KVM_ARM_HOST) += switch.o
 obj-$(CONFIG_KVM_ARM_HOST) += fpsimd.o
 obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
+obj-$(CONFIG_KVM_ARM_HOST) += hyp-entry.o
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
new file mode 100644
index 0000000..8334407
--- /dev/null
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -0,0 +1,198 @@
+/*
+ * Copyright (C) 2015 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/linkage.h>
+
+#include <asm/alternative.h>
+#include <asm/assembler.h>
+#include <asm/asm-offsets.h>
+#include <asm/cpufeature.h>
+#include <asm/kvm_arm.h>
+#include <asm/kvm_asm.h>
+#include <asm/kvm_mmu.h>
+
+	.text
+	.pushsection	.hyp.text, "ax"
+
+el1_sync:					// Guest trapped into EL2
+	push	x0, x1
+	push	x2, x3
+
+	mrs	x1, esr_el2
+	lsr	x2, x1, #ESR_ELx_EC_SHIFT
+
+	cmp	x2, #ESR_ELx_EC_HVC64
+	b.ne	el1_trap
+
+	mrs	x3, vttbr_el2			// If vttbr is valid, the 64bit guest
+	cbnz	x3, el1_trap			// called HVC
+
+	/* Here, we're pretty sure the host called HVC. */
+	pop	x2, x3
+	pop	x0, x1
+
+	/* Check for __hyp_get_vectors */
+	cbnz	x0, 1f
+	mrs	x0, vbar_el2
+	b	2f
+
+1:	push	lr, xzr
+
+	/*
+	 * Compute the function address in EL2, and shuffle the parameters.
+	 */
+	kern_hyp_va	x0
+	mov	lr, x0
+	mov	x0, x1
+	mov	x1, x2
+	mov	x2, x3
+	blr	lr
+
+	pop	lr, xzr
+2:	eret
+
+el1_trap:
+	/*
+	 * x1: ESR
+	 * x2: ESR_EC
+	 */
+
+	/* Guest accessed VFP/SIMD registers, save host, restore Guest */
+	cmp	x2, #ESR_ELx_EC_FP_ASIMD
+	b.eq	__fpsimd_guest_restore
+
+	cmp	x2, #ESR_ELx_EC_DABT_LOW
+	mov	x0, #ESR_ELx_EC_IABT_LOW
+	ccmp	x2, x0, #4, ne
+	b.ne	1f		// Not an abort we care about
+
+	/* This is an abort. Check for permission fault */
+alternative_if_not ARM64_WORKAROUND_834220
+	and	x2, x1, #ESR_ELx_FSC_TYPE
+	cmp	x2, #FSC_PERM
+	b.ne	1f		// Not a permission fault
+alternative_else
+	nop			// Use the permission fault path to
+	nop			// check for a valid S1 translation,
+	nop			// regardless of the ESR value.
+alternative_endif
+
+
+	/*
+	 * Check for Stage-1 page table walk, which is guaranteed
+	 * to give a valid HPFAR_EL2.
+	 */
+	tbnz	x1, #7, 1f	// S1PTW is set
+
+	/* Preserve PAR_EL1 */
+	mrs	x3, par_el1
+	push	x3, xzr
+
+	/*
+	 * Permission fault, HPFAR_EL2 is invalid.
+	 * Resolve the IPA the hard way using the guest VA.
+	 * Stage-1 translation already validated the memory access rights.
+	 * As such, we can use the EL1 translation regime, and don't have
+	 * to distinguish between EL0 and EL1 access.
+	 */
+	mrs	x2, far_el2
+	at	s1e1r, x2
+	isb
+
+	/* Read result */
+	mrs	x3, par_el1
+	pop	x0, xzr			// Restore PAR_EL1 from the stack
+	msr	par_el1, x0
+	tbnz	x3, #0, 3f		// Bail out if we failed the translation
+	ubfx	x3, x3, #12, #36	// Extract IPA
+	lsl	x3, x3, #4		// and present it like HPFAR
+	b	2f
+
+1:	mrs	x3, hpfar_el2
+	mrs	x2, far_el2
+
+2:	mrs	x0, tpidr_el2
+	str	w1, [x0, #VCPU_ESR_EL2]
+	str	x2, [x0, #VCPU_FAR_EL2]
+	str	x3, [x0, #VCPU_HPFAR_EL2]
+
+	mov	x1, #ARM_EXCEPTION_TRAP
+	b	__guest_exit
+
+	/*
+	 * Translation failed. Just return to the guest and
+	 * let it fault again. Another CPU is probably playing
+	 * behind our back.
+	 */
+3:	pop	x2, x3
+	pop	x0, x1
+
+	eret
+
+el1_irq:
+	push	x0, x1
+	push	x2, x3
+	mrs	x0, tpidr_el2
+	mov	x1, #ARM_EXCEPTION_IRQ
+	b	__guest_exit
+
+.macro invalid_vector	label, target = __kvm_hyp_panic
+	.align	2
+\label:
+	b \target
+ENDPROC(\label)
+.endm
+
+	/* None of these should ever happen */
+	invalid_vector	el2t_sync_invalid
+	invalid_vector	el2t_irq_invalid
+	invalid_vector	el2t_fiq_invalid
+	invalid_vector	el2t_error_invalid
+	invalid_vector	el2h_sync_invalid
+	invalid_vector	el2h_irq_invalid
+	invalid_vector	el2h_fiq_invalid
+	invalid_vector	el2h_error_invalid
+	invalid_vector	el1_sync_invalid
+	invalid_vector	el1_irq_invalid
+	invalid_vector	el1_fiq_invalid
+	invalid_vector	el1_error_invalid
+
+	.ltorg
+
+	.align 11
+
+ENTRY(__hyp_vector)
+	ventry	el2t_sync_invalid		// Synchronous EL2t
+	ventry	el2t_irq_invalid		// IRQ EL2t
+	ventry	el2t_fiq_invalid		// FIQ EL2t
+	ventry	el2t_error_invalid		// Error EL2t
+
+	ventry	el2h_sync_invalid		// Synchronous EL2h
+	ventry	el2h_irq_invalid		// IRQ EL2h
+	ventry	el2h_fiq_invalid		// FIQ EL2h
+	ventry	el2h_error_invalid		// Error EL2h
+
+	ventry	el1_sync			// Synchronous 64-bit EL1
+	ventry	el1_irq				// IRQ 64-bit EL1
+	ventry	el1_fiq_invalid			// FIQ 64-bit EL1
+	ventry	el1_error_invalid		// Error 64-bit EL1
+
+	ventry	el1_sync			// Synchronous 32-bit EL1
+	ventry	el1_irq				// IRQ 32-bit EL1
+	ventry	el1_fiq_invalid			// FIQ 32-bit EL1
+	ventry	el1_error_invalid		// Error 32-bit EL1
+ENDPROC(__hyp_vector)
-- 
2.1.4
