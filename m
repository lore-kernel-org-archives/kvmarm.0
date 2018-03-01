From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 17/23] arm64: KVM: Move stashing of x0/x1 into the vector
 code itself
Date: Thu,  1 Mar 2018 15:55:32 +0000
Message-ID: <20180301155538.26860-18-marc.zyngier@arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92F6049E96
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Mar 2018 10:51:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WLezV-ks7vkY for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Mar 2018 10:51:10 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EEE1849F70
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Mar 2018 10:49:21 -0500 (EST)
In-Reply-To: <20180301155538.26860-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

All our useful entry points into the hypervisor are starting by
saving x0 and x1 on the stack. Let's move those into the vectors
by introducing macros that annotate whether a vector is valid or
not, thus indicating whether we want to stash registers or not.

The only drawback is that we now also stash registers for el2_error,
but this should never happen, and we pop them back right at the
start of the handling sequence.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/hyp-entry.S | 56 ++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index f36464bd57c5..0f62b5f76aa5 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -55,7 +55,6 @@ ENTRY(__vhe_hyp_call)
 ENDPROC(__vhe_hyp_call)
 
 el1_sync:				// Guest trapped into EL2
-	stp	x0, x1, [sp, #-16]!
 
 alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
 	mrs	x1, esr_el2
@@ -137,18 +136,18 @@ alternative_else_nop_endif
 	b	__guest_exit
 
 el1_irq:
-	stp     x0, x1, [sp, #-16]!
 	ldr	x1, [sp, #16 + 8]
 	mov	x0, #ARM_EXCEPTION_IRQ
 	b	__guest_exit
 
 el1_error:
-	stp     x0, x1, [sp, #-16]!
 	ldr	x1, [sp, #16 + 8]
 	mov	x0, #ARM_EXCEPTION_EL1_SERROR
 	b	__guest_exit
 
 el2_error:
+	ldp	x0, x1, [sp], #16
+
 	/*
 	 * Only two possibilities:
 	 * 1) Either we come from the exit path, having just unmasked
@@ -206,32 +205,41 @@ ENDPROC(\label)
 	invalid_vector	el2h_sync_invalid
 	invalid_vector	el2h_irq_invalid
 	invalid_vector	el2h_fiq_invalid
-	invalid_vector	el1_sync_invalid
-	invalid_vector	el1_irq_invalid
 	invalid_vector	el1_fiq_invalid
 
 	.ltorg
 
 	.align 11
 
+.macro valid_vect target
+	.align 7
+	stp	x0, x1, [sp, #-16]!
+	b	\target
+.endm
+
+.macro invalid_vect target
+	.align 7
+	b	\target
+.endm
+
 ENTRY(__kvm_hyp_vector)
-	ventry	el2t_sync_invalid		// Synchronous EL2t
-	ventry	el2t_irq_invalid		// IRQ EL2t
-	ventry	el2t_fiq_invalid		// FIQ EL2t
-	ventry	el2t_error_invalid		// Error EL2t
-
-	ventry	el2h_sync_invalid		// Synchronous EL2h
-	ventry	el2h_irq_invalid		// IRQ EL2h
-	ventry	el2h_fiq_invalid		// FIQ EL2h
-	ventry	el2_error			// Error EL2h
-
-	ventry	el1_sync			// Synchronous 64-bit EL1
-	ventry	el1_irq				// IRQ 64-bit EL1
-	ventry	el1_fiq_invalid			// FIQ 64-bit EL1
-	ventry	el1_error			// Error 64-bit EL1
-
-	ventry	el1_sync			// Synchronous 32-bit EL1
-	ventry	el1_irq				// IRQ 32-bit EL1
-	ventry	el1_fiq_invalid			// FIQ 32-bit EL1
-	ventry	el1_error			// Error 32-bit EL1
+	invalid_vect	el2t_sync_invalid	// Synchronous EL2t
+	invalid_vect	el2t_irq_invalid	// IRQ EL2t
+	invalid_vect	el2t_fiq_invalid	// FIQ EL2t
+	invalid_vect	el2t_error_invalid	// Error EL2t
+
+	invalid_vect	el2h_sync_invalid	// Synchronous EL2h
+	invalid_vect	el2h_irq_invalid	// IRQ EL2h
+	invalid_vect	el2h_fiq_invalid	// FIQ EL2h
+	valid_vect	el2_error		// Error EL2h
+
+	valid_vect	el1_sync		// Synchronous 64-bit EL1
+	valid_vect	el1_irq			// IRQ 64-bit EL1
+	invalid_vect	el1_fiq_invalid		// FIQ 64-bit EL1
+	valid_vect	el1_error		// Error 64-bit EL1
+
+	valid_vect	el1_sync		// Synchronous 32-bit EL1
+	valid_vect	el1_irq			// IRQ 32-bit EL1
+	invalid_vect	el1_fiq_invalid		// FIQ 32-bit EL1
+	valid_vect	el1_error		// Error 32-bit EL1
 ENDPROC(__kvm_hyp_vector)
-- 
2.14.2
