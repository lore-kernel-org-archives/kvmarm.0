From: James Morse <james.morse@arm.com>
Subject: [PATCH 01/11] KVM: arm64: Store vcpu on the stack during
 __guest_enter()
Date: Mon, 15 May 2017 18:43:49 +0100
Message-ID: <20170515174400.29735-2-james.morse@arm.com>
References: <20170515174400.29735-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 994A340905
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 May 2017 13:42:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5X0MU2rOgPkd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 May 2017 13:42:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B98440187
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 May 2017 13:42:30 -0400 (EDT)
In-Reply-To: <20170515174400.29735-1-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: devicetree@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

KVM uses tpidr_el2 as its private vcpu register, which makes sense for
non-vhe world switch as only KVM can access this register. This means
vhe Linux has to use tpidr_el1, which KVM has to save/restore as part
of the host context.

__guest_enter() stores the host_ctxt on the stack, do the same with
the vcpu.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kvm/hyp/entry.S     | 12 ++++++++----
 arch/arm64/kvm/hyp/hyp-entry.S |  6 +++---
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 12ee62d6d410..113735df7d01 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -62,8 +62,8 @@ ENTRY(__guest_enter)
 	// Store the host regs
 	save_callee_saved_regs x1
 
-	// Store the host_ctxt for use at exit time
-	str	x1, [sp, #-16]!
+	// Store host_ctxt and vcpu for use at exit time
+	stp	x1, x0, [sp, #-16]!
 
 	add	x18, x0, #VCPU_CONTEXT
 
@@ -159,9 +159,15 @@ abort_guest_exit_end:
 ENDPROC(__guest_exit)
 
 ENTRY(__fpsimd_guest_restore)
+	// x0: esr
+	// x1: vcpu
+	// x2-x29,lr: vcpu regs
+	// vcpu x0-x1 on the stack
 	stp	x2, x3, [sp, #-16]!
 	stp	x4, lr, [sp, #-16]!
 
+	mov	x3, x1
+
 alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
 	mrs	x2, cptr_el2
 	bic	x2, x2, #CPTR_EL2_TFP
@@ -173,8 +179,6 @@ alternative_else
 alternative_endif
 	isb
 
-	mrs	x3, tpidr_el2
-
 	ldr	x0, [x3, #VCPU_HOST_CONTEXT]
 	kern_hyp_va x0
 	add	x0, x0, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 5170ce1021da..fce7cc507e0a 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -104,6 +104,7 @@ el1_trap:
 	/*
 	 * x0: ESR_EC
 	 */
+	ldr	x1, [sp, #16 + 8]	// vcpu stored by __guest_enter
 
 	/*
 	 * We trap the first access to the FP/SIMD to save the host context
@@ -116,19 +117,18 @@ alternative_if_not ARM64_HAS_NO_FPSIMD
 	b.eq	__fpsimd_guest_restore
 alternative_else_nop_endif
 
-	mrs	x1, tpidr_el2
 	mov	x0, #ARM_EXCEPTION_TRAP
 	b	__guest_exit
 
 el1_irq:
 	stp     x0, x1, [sp, #-16]!
-	mrs	x1, tpidr_el2
+	ldr	x1, [sp, #16 + 8]
 	mov	x0, #ARM_EXCEPTION_IRQ
 	b	__guest_exit
 
 el1_error:
 	stp     x0, x1, [sp, #-16]!
-	mrs	x1, tpidr_el2
+	ldr	x1, [sp, #16 + 8]
 	mov	x0, #ARM_EXCEPTION_EL1_SERROR
 	b	__guest_exit
 
-- 
2.10.1
