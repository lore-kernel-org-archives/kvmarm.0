From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 72/85] arm64: KVM: Move stashing of x0/x1 into the vector code
 itself
Date: Wed, 28 Mar 2018 13:52:41 +0100
Message-ID: <20180328125254.31380-73-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A866F4A15D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 09:00:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mfucScQUM8Mx for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:59:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA1E34A0E8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:49:53 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

All our useful entry points into the hypervisor are starting by
saving x0 and x1 on the stack. Let's move those into the vectors
by introducing macros that annotate whether a vector is valid or
not, thus indicating whether we want to stash registers or not.

The only drawback is that we now also stash registers for el2_error,
but this should never happen, and we pop them back right at the
start of the handling sequence.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/hyp-entry.S | 56 ++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 82fbc368f738..8359fed89098 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -55,7 +55,6 @@ ENTRY(__vhe_hyp_call)
 ENDPROC(__vhe_hyp_call)
 
 el1_sync:				// Guest trapped into EL2
-	stp	x0, x1, [sp, #-16]!
 
 	mrs	x0, esr_el2
 	lsr	x0, x0, #ESR_ELx_EC_SHIFT
@@ -136,18 +135,18 @@ alternative_else_nop_endif
 	b	__guest_exit
 
 el1_irq:
-	stp     x0, x1, [sp, #-16]!
 	get_vcpu_ptr	x1, x0
 	mov	x0, #ARM_EXCEPTION_IRQ
 	b	__guest_exit
 
 el1_error:
-	stp     x0, x1, [sp, #-16]!
 	get_vcpu_ptr	x1, x0
 	mov	x0, #ARM_EXCEPTION_EL1_SERROR
 	b	__guest_exit
 
 el2_error:
+	ldp	x0, x1, [sp], #16
+
 	/*
 	 * Only two possibilities:
 	 * 1) Either we come from the exit path, having just unmasked
@@ -198,32 +197,41 @@ ENDPROC(\label)
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
