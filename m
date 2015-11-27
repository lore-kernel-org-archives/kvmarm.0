From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 09/21] arm64: KVM: Implement guest entry
Date: Fri, 27 Nov 2015 18:50:03 +0000
Message-ID: <1448650215-15218-10-git-send-email-marc.zyngier@arm.com>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF8D249630
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2015 13:49:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aYq4Dp4AGdqG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Nov 2015 13:49:33 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90DC441267
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2015 13:49:33 -0500 (EST)
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

Contrary to the previous patch, the guest entry is fairly different
from its assembly counterpart, mostly because it is only concerned
with saving/restoring the GP registers, and nothing else.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/Makefile |   1 +
 arch/arm64/kvm/hyp/entry.S  | 155 ++++++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/hyp.h    |   2 +
 3 files changed, 158 insertions(+)
 create mode 100644 arch/arm64/kvm/hyp/entry.S

diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index ec14cac..1e1ff06 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_KVM_ARM_HOST) += vgic-v3-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += timer-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += sysreg-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += debug-sr.o
+obj-$(CONFIG_KVM_ARM_HOST) += entry.o
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
new file mode 100644
index 0000000..2c4449a
--- /dev/null
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -0,0 +1,155 @@
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
+#include <asm/asm-offsets.h>
+#include <asm/assembler.h>
+#include <asm/fpsimdmacros.h>
+#include <asm/kvm.h>
+#include <asm/kvm_arm.h>
+#include <asm/kvm_asm.h>
+#include <asm/kvm_mmu.h>
+
+#define CPU_GP_REG_OFFSET(x)	(CPU_GP_REGS + x)
+#define CPU_XREG_OFFSET(x)	CPU_GP_REG_OFFSET(CPU_USER_PT_REGS + 8*x)
+
+	.text
+	.pushsection	.hyp.text, "ax"
+
+.macro save_common_regs ctxt
+	stp	x19, x20, [\ctxt, #CPU_XREG_OFFSET(19)]
+	stp	x21, x22, [\ctxt, #CPU_XREG_OFFSET(21)]
+	stp	x23, x24, [\ctxt, #CPU_XREG_OFFSET(23)]
+	stp	x25, x26, [\ctxt, #CPU_XREG_OFFSET(25)]
+	stp	x27, x28, [\ctxt, #CPU_XREG_OFFSET(27)]
+	stp	x29, lr,  [\ctxt, #CPU_XREG_OFFSET(29)]
+.endm
+
+.macro restore_common_regs ctxt
+	ldp	x19, x20, [\ctxt, #CPU_XREG_OFFSET(19)]
+	ldp	x21, x22, [\ctxt, #CPU_XREG_OFFSET(21)]
+	ldp	x23, x24, [\ctxt, #CPU_XREG_OFFSET(23)]
+	ldp	x25, x26, [\ctxt, #CPU_XREG_OFFSET(25)]
+	ldp	x27, x28, [\ctxt, #CPU_XREG_OFFSET(27)]
+	ldp	x29, lr,  [\ctxt, #CPU_XREG_OFFSET(29)]
+.endm
+
+.macro save_host_regs reg
+	save_common_regs \reg
+.endm
+
+.macro restore_host_regs reg
+	restore_common_regs \reg
+.endm
+
+.macro save_guest_regs
+	// x0 is the vcpu address
+	// x1 is the return code, do not corrupt!
+	// x2 is the cpu context
+	// x3 is a tmp register
+	// Guest's x0-x3 are on the stack
+
+	add	x2, x0, #VCPU_CONTEXT
+
+	// Compute base to save registers
+	stp	x4, x5,   [x2, #CPU_XREG_OFFSET(4)]
+	stp	x6, x7,   [x2, #CPU_XREG_OFFSET(6)]
+	stp	x8, x9,   [x2, #CPU_XREG_OFFSET(8)]
+	stp	x10, x11, [x2, #CPU_XREG_OFFSET(10)]
+	stp	x12, x13, [x2, #CPU_XREG_OFFSET(12)]
+	stp	x14, x15, [x2, #CPU_XREG_OFFSET(14)]
+	stp	x16, x17, [x2, #CPU_XREG_OFFSET(16)]
+	str	x18,      [x2, #CPU_XREG_OFFSET(18)]
+
+	pop	x6, x7			// x2, x3
+	pop	x4, x5			// x0, x1
+
+	stp	x4, x5, [x2, #CPU_XREG_OFFSET(0)]
+	stp	x6, x7, [x2, #CPU_XREG_OFFSET(2)]
+
+	save_common_regs x2
+.endm
+
+.macro restore_guest_regs
+	// Assume vcpu in x0, clobbers everything else
+
+	add	x2, x0, #VCPU_CONTEXT
+
+	// Prepare x0-x3 for later restore
+	ldp	x4, x5, [x2, #CPU_XREG_OFFSET(0)]
+	ldp	x6, x7, [x2, #CPU_XREG_OFFSET(2)]
+	push	x4, x5		// Push x0-x3 on the stack
+	push	x6, x7
+
+	// x4-x18
+	ldp	x4, x5,   [x2, #CPU_XREG_OFFSET(4)] 
+	ldp	x6, x7,   [x2, #CPU_XREG_OFFSET(6)] 
+	ldp	x8, x9,   [x2, #CPU_XREG_OFFSET(8)] 
+	ldp	x10, x11, [x2, #CPU_XREG_OFFSET(10)]
+	ldp	x12, x13, [x2, #CPU_XREG_OFFSET(12)]
+	ldp	x14, x15, [x2, #CPU_XREG_OFFSET(14)]
+	ldp	x16, x17, [x2, #CPU_XREG_OFFSET(16)]
+	ldr	x18,      [x2, #CPU_XREG_OFFSET(18)]
+
+	// x19-x29, lr
+	restore_common_regs x2
+
+	// Last bits of the 64bit state
+	pop	x2, x3
+	pop	x0, x1
+
+	// Do not touch any register after this!
+.endm
+
+/*
+ * u64 __guest_enter(struct kvm_vcpu *vcpu,
+ *		     struct kvm_cpu_context *host_ctxt);
+ */
+ENTRY(__guest_enter)
+	// x0: vcpu
+	// x1: host_ctxt
+	// x2, x3: parameter registers
+	// x4-x18: clobbered by macros
+
+	save_host_regs x1
+
+	// Preserve vcpu & host_ctxt for use at exit time
+	stp	x0, x1, [sp, #-16]!
+
+	restore_guest_regs
+	eret
+ENDPROC(__guest_enter)
+
+ENTRY(__guest_exit)
+	// x0: vcpu
+	// x1: return code
+	// x2-x3: free
+	// x4-x29,lr: vcpu regs
+	// vcpu x0-x3 on the stack
+	save_guest_regs
+
+	// Restore vcpu & host_ctxt from the stack
+	// (preserving return code in x1)
+	ldp	x0, x2, [sp], #16
+	restore_host_regs x2
+
+	mov	x0, x1
+	ret
+ENDPROC(__guest_exit)
+
+	/* Insert fault handling here */
diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
index 2581232..7ac8e11 100644
--- a/arch/arm64/kvm/hyp/hyp.h
+++ b/arch/arm64/kvm/hyp/hyp.h
@@ -50,5 +50,7 @@ void __debug_restore_state(struct kvm_vcpu *vcpu,
 void __debug_cond_save_host_state(struct kvm_vcpu *vcpu);
 void __debug_cond_restore_host_state(struct kvm_vcpu *vcpu);
 
+u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
+
 #endif /* __ARM64_KVM_HYP_H__ */
 
-- 
2.1.4
