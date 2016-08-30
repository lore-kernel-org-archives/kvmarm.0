From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: [PATCH v2] arm64: KVM: Save four instructions in __guest_enter/exit()
Date: Mon, 29 Aug 2016 22:51:14 -0500
Message-ID: <1472529074-19261-1-git-send-email-shankerd@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, kvmarm <kvmarm@lists.cs.columbia.edu>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Shanker Donthineni <shankerd@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

We are doing an unnecessary stack push/pop operation when restoring
the guest registers x0-x18 in __guest_enter(). This patch saves the
two instructions by using x18 as a base register. No need to store
the vcpu context pointer in stack because it is redundant, the same
information is available in tpidr_el2. The function __guest_exit()
prototype is simplified and caller pushes the regs x0-x1 to stack
instead of regs x0-x3.

Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
---
Changes since v1:
  Incorporated Cristoffer suggestions.
  __guest_exit prototype is changed to 'void __guest_exit(u64 reason, struct kvm_vcpu *vcpu)'.

 arch/arm64/kvm/hyp/entry.S     | 101 +++++++++++++++++++++--------------------
 arch/arm64/kvm/hyp/hyp-entry.S |  11 +++--
 2 files changed, 57 insertions(+), 55 deletions(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index ce9e5e5..f70489a 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -55,75 +55,76 @@
  */
 ENTRY(__guest_enter)
 	// x0: vcpu
-	// x1: host/guest context
-	// x2-x18: clobbered by macros
+	// x1: host context
+	// x2-x17: clobbered by macros
+	// x18: guest context
 
 	// Store the host regs
 	save_callee_saved_regs x1
 
-	// Preserve vcpu & host_ctxt for use at exit time
-	stp	x0, x1, [sp, #-16]!
+	// Store the host_ctxt for use at exit time
+	str	x1, [sp, #-16]!
 
-	add	x1, x0, #VCPU_CONTEXT
+	add	x18, x0, #VCPU_CONTEXT
 
-	// Prepare x0-x1 for later restore by pushing them onto the stack
-	ldp	x2, x3, [x1, #CPU_XREG_OFFSET(0)]
-	stp	x2, x3, [sp, #-16]!
+	// Restore guest regs x0-x17
+	ldp	x0, x1,   [x18, #CPU_XREG_OFFSET(0)]
+	ldp	x2, x3,   [x18, #CPU_XREG_OFFSET(2)]
+	ldp	x4, x5,   [x18, #CPU_XREG_OFFSET(4)]
+	ldp	x6, x7,   [x18, #CPU_XREG_OFFSET(6)]
+	ldp	x8, x9,   [x18, #CPU_XREG_OFFSET(8)]
+	ldp	x10, x11, [x18, #CPU_XREG_OFFSET(10)]
+	ldp	x12, x13, [x18, #CPU_XREG_OFFSET(12)]
+	ldp	x14, x15, [x18, #CPU_XREG_OFFSET(14)]
+	ldp	x16, x17, [x18, #CPU_XREG_OFFSET(16)]
 
-	// x2-x18
-	ldp	x2, x3,   [x1, #CPU_XREG_OFFSET(2)]
-	ldp	x4, x5,   [x1, #CPU_XREG_OFFSET(4)]
-	ldp	x6, x7,   [x1, #CPU_XREG_OFFSET(6)]
-	ldp	x8, x9,   [x1, #CPU_XREG_OFFSET(8)]
-	ldp	x10, x11, [x1, #CPU_XREG_OFFSET(10)]
-	ldp	x12, x13, [x1, #CPU_XREG_OFFSET(12)]
-	ldp	x14, x15, [x1, #CPU_XREG_OFFSET(14)]
-	ldp	x16, x17, [x1, #CPU_XREG_OFFSET(16)]
-	ldr	x18,      [x1, #CPU_XREG_OFFSET(18)]
+	// Restore guest regs x19-x29, lr
+	restore_callee_saved_regs x18
 
-	// x19-x29, lr
-	restore_callee_saved_regs x1
-
-	// Last bits of the 64bit state
-	ldp	x0, x1, [sp], #16
+	// Restore guest reg x18
+	ldr	x18,      [x18, #CPU_XREG_OFFSET(18)]
 
 	// Do not touch any register after this!
 	eret
 ENDPROC(__guest_enter)
 
+/*
+ * void __guest_exit(u64 exit_reason, struct kvm_vcpu *vcpu);
+ */
 ENTRY(__guest_exit)
-	// x0: vcpu
-	// x1: return code
-	// x2-x3: free
-	// x4-x29,lr: vcpu regs
-	// vcpu x0-x3 on the stack
-
-	add	x2, x0, #VCPU_CONTEXT
-
-	stp	x4, x5,   [x2, #CPU_XREG_OFFSET(4)]
-	stp	x6, x7,   [x2, #CPU_XREG_OFFSET(6)]
-	stp	x8, x9,   [x2, #CPU_XREG_OFFSET(8)]
-	stp	x10, x11, [x2, #CPU_XREG_OFFSET(10)]
-	stp	x12, x13, [x2, #CPU_XREG_OFFSET(12)]
-	stp	x14, x15, [x2, #CPU_XREG_OFFSET(14)]
-	stp	x16, x17, [x2, #CPU_XREG_OFFSET(16)]
-	str	x18,      [x2, #CPU_XREG_OFFSET(18)]
-
-	ldp	x6, x7, [sp], #16	// x2, x3
-	ldp	x4, x5, [sp], #16	// x0, x1
-
-	stp	x4, x5, [x2, #CPU_XREG_OFFSET(0)]
-	stp	x6, x7, [x2, #CPU_XREG_OFFSET(2)]
+	// x0: return code
+	// x1: vcpu
+	// x2-x29,lr: vcpu regs
+	// vcpu x0-x1 on the stack
+
+	add	x1, x1, #VCPU_CONTEXT
+
+	// Store the guest regs x2 and x3
+	stp	x2, x3,   [x1, #CPU_XREG_OFFSET(2)]
+
+	// Retrieve the guest regs x0-x1 from the stack
+	ldp	x2, x3, [sp], #16	// x0, x1
+
+	// Store the guest regs x0-x1 and x4-x18
+	stp	x2, x3,   [x1, #CPU_XREG_OFFSET(0)]
+	stp	x4, x5,   [x1, #CPU_XREG_OFFSET(4)]
+	stp	x6, x7,   [x1, #CPU_XREG_OFFSET(6)]
+	stp	x8, x9,   [x1, #CPU_XREG_OFFSET(8)]
+	stp	x10, x11, [x1, #CPU_XREG_OFFSET(10)]
+	stp	x12, x13, [x1, #CPU_XREG_OFFSET(12)]
+	stp	x14, x15, [x1, #CPU_XREG_OFFSET(14)]
+	stp	x16, x17, [x1, #CPU_XREG_OFFSET(16)]
+	str	x18,      [x1, #CPU_XREG_OFFSET(18)]
+
+	// Store the guest regs x19-x29, lr
+	save_callee_saved_regs x1
 
-	save_callee_saved_regs x2
+	// Restore the host_ctxt from the stack
+	ldr	x2, [sp], #16
 
-	// Restore vcpu & host_ctxt from the stack
-	// (preserving return code in x1)
-	ldp	x0, x2, [sp], #16
 	// Now restore the host regs
 	restore_callee_saved_regs x2
 
-	mov	x0, x1
 	ret
 ENDPROC(__guest_exit)
 
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index f6d9694..06e8b3b 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -121,14 +121,15 @@ el1_trap:
 	cmp	x2, #ESR_ELx_EC_FP_ASIMD
 	b.eq	__fpsimd_guest_restore
 
-	mrs	x0, tpidr_el2
-	mov	x1, #ARM_EXCEPTION_TRAP
+	ldp     x2, x3, [sp], #16
+	mrs	x1, tpidr_el2
+	mov	x0, #ARM_EXCEPTION_TRAP
 	b	__guest_exit
 
 el1_irq:
-	save_x0_to_x3
-	mrs	x0, tpidr_el2
-	mov	x1, #ARM_EXCEPTION_IRQ
+	stp     x0, x1, [sp, #-16]!
+	mrs	x1, tpidr_el2
+	mov	x0, #ARM_EXCEPTION_IRQ
 	b	__guest_exit
 
 ENTRY(__hyp_do_panic)
-- 
Qualcomm Datacenter Technologies, Inc. on behalf of the Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
