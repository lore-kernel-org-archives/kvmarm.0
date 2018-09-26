From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH 7/7] arm64: kvm: Align stack for exception coming from EL2
Date: Wed, 26 Sep 2018 14:56:24 +0100
Message-ID: <1537970184-44348-8-git-send-email-julien.thierry@arm.com>
References: <1537970184-44348-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81F584A20D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Sep 2018 09:56:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B57exRhtrXQ5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Sep 2018 09:56:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A66E49EA2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Sep 2018 09:56:43 -0400 (EDT)
In-Reply-To: <1537970184-44348-1-git-send-email-julien.thierry@arm.com>
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
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, Dave.Martin@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

SP needs to be 16-bytes aligned before accessing memory through it. When
handling exceptions from EL2, there is no guarantee that SP is already
aligned.

Ensure SP is aligned upon entries from EL2.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/kvm/hyp/hyp-entry.S | 63 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 52 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index da31386..f611072 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -184,6 +184,10 @@ el2_error:
 	ccmp	x0, x1, #4, ne
 	b.ne	__hyp_panic
 	mov	x0, #(1 << ARM_EXIT_WITH_SERROR_BIT)
+
+	/* Restore the stack */
+	ldr	x1, [sp]
+	mov	sp, x1
 	eret

 ENTRY(__hyp_do_panic)
@@ -221,29 +225,66 @@ ENDPROC(\label)

 	.align 11

-.macro valid_vect target
+/*
+ * Aligns the stack and stores the old sp value. This is what the stack
+ * looks like after this code:
+ *
+ *  +--------+
+ *  |        |
+ *  |--------|--> old_sp (upon entry)
+ *  |   x1   |--> (only used for local save/restore)
+ *  |--------|--> old_sp - 8
+ *  |        |--> padding
+ *  |--------|--> aligned_sp + 8
+ *  | old_sp |
+ *  |--------|--> sp = aligned_sp
+ *  |        |
+ *  +--------+
+ */
+.macro align_sp_el2
+	xchg_sp	x0
+	str	x1, [x0, #-8]	// save x1
+	mov	x1, x0		// x1 = old_sp
+	sub	x0, x0, #0x10	// save space for x1 + old_sp
+	bic	x0, x0, #0xf	// align down to 16-bytes
+	xchg_sp	x0
+	str	x1, [sp]	// save old_sp
+	ldr	x1, [x1, #-8]
+.endm
+
+.macro valid_vect target, el=1
 	.align 7
+	.if \el == 2
+	align_sp_el2
+	.endif
+
 	stp	x0, x1, [sp, #-16]!
 	b	\target
 .endm

-.macro invalid_vect target
+.macro invalid_vect target, el=1
 	.align 7
+	.if \el == 2
+	align_sp_el2
+	.endif
+
 	b	\target
+	.if \el == 1
 	ldp	x0, x1, [sp], #16
 	b	\target
+	.endif
 .endm

 ENTRY(__kvm_hyp_vector)
-	invalid_vect	el2t_sync_invalid	// Synchronous EL2t
-	invalid_vect	el2t_irq_invalid	// IRQ EL2t
-	invalid_vect	el2t_fiq_invalid	// FIQ EL2t
-	invalid_vect	el2t_error_invalid	// Error EL2t
-
-	invalid_vect	el2h_sync_invalid	// Synchronous EL2h
-	invalid_vect	el2h_irq_invalid	// IRQ EL2h
-	invalid_vect	el2h_fiq_invalid	// FIQ EL2h
-	valid_vect	el2_error		// Error EL2h
+	invalid_vect	el2t_sync_invalid, 2	// Synchronous EL2t
+	invalid_vect	el2t_irq_invalid, 2	// IRQ EL2t
+	invalid_vect	el2t_fiq_invalid, 2	// FIQ EL2t
+	invalid_vect	el2t_error_invalid, 2	// Error EL2t
+
+	invalid_vect	el2h_sync_invalid, 2	// Synchronous EL2h
+	invalid_vect	el2h_irq_invalid, 2	// IRQ EL2h
+	invalid_vect	el2h_fiq_invalid, 2	// FIQ EL2h
+	valid_vect	el2_error, 2		// Error EL2h

 	valid_vect	el1_sync		// Synchronous 64-bit EL1
 	valid_vect	el1_irq			// IRQ 64-bit EL1
--
1.9.1
