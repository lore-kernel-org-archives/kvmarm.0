From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 25/50] arm64: KVM: Handle async aborts delivered while at EL2
Date: Tue, 27 Sep 2016 20:05:33 +0200
Message-ID: <20160927180558.14699-26-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F2A149BBB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mKJxdw4hdFPL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:56:52 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DD753499A1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:47 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id b130so27066714wmc.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:06:11 -0700 (PDT)
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

If EL1 generates an asynchronous abort and then traps into EL2
before the abort has been delivered, we may end-up with the
abort firing at the worse possible place: on the host.

In order to avoid this, it is necessary to take the abort at EL2,
by clearing the PSTATE.A bit. In order to survive this abort,
we do it at a point where we're in a known state with respect
to the world switch, and handle the resulting exception,
overloading the exit code in the process.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/entry.S     | 33 ++++++++++++++++++++++++++++++++-
 arch/arm64/kvm/hyp/hyp-entry.S | 25 +++++++++++++++++++++++--
 arch/arm64/kvm/hyp/switch.c    |  6 ++++++
 3 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index b5926ee..12ee62d 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -124,7 +124,38 @@ ENTRY(__guest_exit)
 	// Now restore the host regs
 	restore_callee_saved_regs x2
 
-	ret
+	// If we have a pending asynchronous abort, now is the
+	// time to find out. From your VAXorcist book, page 666:
+	// "Threaten me not, oh Evil one!  For I speak with
+	// the power of DEC, and I command thee to show thyself!"
+	mrs	x2, elr_el2
+	mrs	x3, esr_el2
+	mrs	x4, spsr_el2
+	mov	x5, x0
+
+	dsb	sy		// Synchronize against in-flight ld/st
+	msr	daifclr, #4	// Unmask aborts
+
+	// This is our single instruction exception window. A pending
+	// SError is guaranteed to occur at the earliest when we unmask
+	// it, and at the latest just after the ISB.
+	.global	abort_guest_exit_start
+abort_guest_exit_start:
+
+	isb
+
+	.global	abort_guest_exit_end
+abort_guest_exit_end:
+
+	// If the exception took place, restore the EL1 exception
+	// context so that we can report some information.
+	// Merge the exception code with the SError pending bit.
+	tbz	x0, #ARM_EXIT_WITH_SERROR_BIT, 1f
+	msr	elr_el2, x2
+	msr	esr_el2, x3
+	msr	spsr_el2, x4
+	orr	x0, x0, x5
+1:	ret
 ENDPROC(__guest_exit)
 
 ENTRY(__fpsimd_guest_restore)
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index d2f6640..4e92399 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -126,6 +126,28 @@ el1_error:
 	mov	x0, #ARM_EXCEPTION_EL1_SERROR
 	b	__guest_exit
 
+el2_error:
+	/*
+	 * Only two possibilities:
+	 * 1) Either we come from the exit path, having just unmasked
+	 *    PSTATE.A: change the return code to an EL2 fault, and
+	 *    carry on, as we're already in a sane state to handle it.
+	 * 2) Or we come from anywhere else, and that's a bug: we panic.
+	 *
+	 * For (1), x0 contains the original return code and x1 doesn't
+	 * contain anything meaningful at that stage. We can reuse them
+	 * as temp registers.
+	 * For (2), who cares?
+	 */
+	mrs	x0, elr_el2
+	adr	x1, abort_guest_exit_start
+	cmp	x0, x1
+	adr	x1, abort_guest_exit_end
+	ccmp	x0, x1, #4, ne
+	b.ne	__hyp_panic
+	mov	x0, #(1 << ARM_EXIT_WITH_SERROR_BIT)
+	eret
+
 ENTRY(__hyp_do_panic)
 	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
 		      PSR_MODE_EL1h)
@@ -150,7 +172,6 @@ ENDPROC(\label)
 	invalid_vector	el2h_sync_invalid
 	invalid_vector	el2h_irq_invalid
 	invalid_vector	el2h_fiq_invalid
-	invalid_vector	el2h_error_invalid
 	invalid_vector	el1_sync_invalid
 	invalid_vector	el1_irq_invalid
 	invalid_vector	el1_fiq_invalid
@@ -168,7 +189,7 @@ ENTRY(__kvm_hyp_vector)
 	ventry	el2h_sync_invalid		// Synchronous EL2h
 	ventry	el2h_irq_invalid		// IRQ EL2h
 	ventry	el2h_fiq_invalid		// FIQ EL2h
-	ventry	el2h_error_invalid		// Error EL2h
+	ventry	el2_error			// Error EL2h
 
 	ventry	el1_sync			// Synchronous 64-bit EL1
 	ventry	el1_irq				// IRQ 64-bit EL1
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 8246de2..8b81cc6 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -292,6 +292,12 @@ again:
 	exit_code = __guest_enter(vcpu, host_ctxt);
 	/* And we're baaack! */
 
+	/*
+	 * We're using the raw exception code in order to only process
+	 * the trap if no SError is pending. We will come back to the
+	 * same PC once the SError has been injected, and replay the
+	 * trapping instruction.
+	 */
 	if (exit_code == ARM_EXCEPTION_TRAP && !__populate_fault_info(vcpu))
 		goto again;
 
-- 
2.9.0
