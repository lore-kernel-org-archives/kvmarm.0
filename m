From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: [PATCH] arm64: KVM: Save two instructions in __guest_enter()
Date: Tue,  9 Aug 2016 20:15:36 -0500
Message-ID: <1470791736-13949-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F039449B32
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2016 21:08:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hTN0voLnqFIo for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2016 21:08:44 -0400 (EDT)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE4C549B2C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2016 21:08:44 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, kvmarm <kvmarm@lists.cs.columbia.edu>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

We are doing an unnecessary stack push/pop operation when restoring
the guest registers x0-x18 in __guest_enter(). This patch saves the
two instructions by using x18 as a base register. No need to store
the vcpu context pointer in stack because it is redundant and not
being used anywhere, the same information is available in tpidr_el2.

Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
---
 arch/arm64/kvm/hyp/entry.S | 66 ++++++++++++++++++++++------------------------
 1 file changed, 32 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index ce9e5e5..d2e09a1 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -55,37 +55,32 @@
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
+	// Preserve the host_ctxt for use at exit time
+	str	x1, [sp, #-16]!
 
-	add	x1, x0, #VCPU_CONTEXT
+	add	x18, x0, #VCPU_CONTEXT
 
-	// Prepare x0-x1 for later restore by pushing them onto the stack
-	ldp	x2, x3, [x1, #CPU_XREG_OFFSET(0)]
-	stp	x2, x3, [sp, #-16]!
+	// Restore guest regs x19-x29, lr
+	restore_callee_saved_regs x18
 
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
-
-	// x19-x29, lr
-	restore_callee_saved_regs x1
-
-	// Last bits of the 64bit state
-	ldp	x0, x1, [sp], #16
+	// Restore guest regs x0-x18
+	ldp	x0, x1,   [x18, #CPU_XREG_OFFSET(0)]
+	ldp	x2, x3,   [x18, #CPU_XREG_OFFSET(2)]
+	ldp	x4, x5,   [x18, #CPU_XREG_OFFSET(4)]
+	ldp	x6, x7,   [x18, #CPU_XREG_OFFSET(6)]
+	ldp	x8, x9,   [x18, #CPU_XREG_OFFSET(8)]
+	ldp	x10, x11, [x18, #CPU_XREG_OFFSET(10)]
+	ldp	x12, x13, [x18, #CPU_XREG_OFFSET(12)]
+	ldp	x14, x15, [x18, #CPU_XREG_OFFSET(14)]
+	ldp	x16, x17, [x18, #CPU_XREG_OFFSET(16)]
+	ldr	x18,      [x18, #CPU_XREG_OFFSET(18)]
 
 	// Do not touch any register after this!
 	eret
@@ -100,6 +95,16 @@ ENTRY(__guest_exit)
 
 	add	x2, x0, #VCPU_CONTEXT
 
+	// Store the guest regs x19-x29, lr
+	save_callee_saved_regs x2
+
+	// Retrieve the guest regs x0-x3 from the stack
+	ldp	x21, x22, [sp], #16	// x2, x3
+	ldp	x19, x20, [sp], #16	// x0, x1
+
+	// Store the guest regs x0-x18
+	stp	x19, x20, [x2, #CPU_XREG_OFFSET(0)]
+	stp	x21, x22, [x2, #CPU_XREG_OFFSET(2)]
 	stp	x4, x5,   [x2, #CPU_XREG_OFFSET(4)]
 	stp	x6, x7,   [x2, #CPU_XREG_OFFSET(6)]
 	stp	x8, x9,   [x2, #CPU_XREG_OFFSET(8)]
@@ -109,20 +114,13 @@ ENTRY(__guest_exit)
 	stp	x16, x17, [x2, #CPU_XREG_OFFSET(16)]
 	str	x18,      [x2, #CPU_XREG_OFFSET(18)]
 
-	ldp	x6, x7, [sp], #16	// x2, x3
-	ldp	x4, x5, [sp], #16	// x0, x1
+	// Restore the host_ctxt from the stack
+	ldr	x2, [sp], #16
 
-	stp	x4, x5, [x2, #CPU_XREG_OFFSET(0)]
-	stp	x6, x7, [x2, #CPU_XREG_OFFSET(2)]
-
-	save_callee_saved_regs x2
-
-	// Restore vcpu & host_ctxt from the stack
-	// (preserving return code in x1)
-	ldp	x0, x2, [sp], #16
 	// Now restore the host regs
 	restore_callee_saved_regs x2
 
+	// Preserving return code (x1)
 	mov	x0, x1
 	ret
 ENDPROC(__guest_exit)
-- 
Qualcomm Datacenter Technologies, Inc. on behalf of the Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
