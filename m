From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 14/19] arm: KVM: Handle async aborts delivered while at HYP
Date: Tue,  6 Sep 2016 14:02:12 +0100
Message-ID: <1473166937-15271-15-git-send-email-marc.zyngier@arm.com>
References: <1473166937-15271-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1473166937-15271-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Just like for arm64, we can handle asynchronous aborts being
delivered at HYP while being caused by the guest. We use
the exact same method to catch such an abort, and soldier on.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/hyp/entry.S     | 31 +++++++++++++++++++++++++++++++
 arch/arm/kvm/hyp/hyp-entry.S | 16 +++++++++++++++-
 2 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/hyp/entry.S b/arch/arm/kvm/hyp/entry.S
index 21c2388..60783f3 100644
--- a/arch/arm/kvm/hyp/entry.S
+++ b/arch/arm/kvm/hyp/entry.S
@@ -18,6 +18,7 @@
 #include <linux/linkage.h>
 #include <asm/asm-offsets.h>
 #include <asm/kvm_arm.h>
+#include <asm/kvm_asm.h>
 
 	.arch_extension     virt
 
@@ -63,6 +64,36 @@ ENTRY(__guest_exit)
 	ldr	lr, [r0, #4]
 
 	mov	r0, r1
+	mrs	r1, SPSR
+	mrs	r2, ELR_hyp
+	mrc	p15, 4, r3, c5, c2, 0	@ HSR
+
+	/*
+	 * Force loads and stores to complete before unmasking aborts
+	 * and forcing the delivery of the exception. This gives us a
+	 * single instruction window, which the handler will try to
+	 * match.
+	 */
+	dsb	sy
+	cpsie	a
+
+	.global	abort_guest_exit_start
+abort_guest_exit_start:
+
+	isb
+
+	.global	abort_guest_exit_end
+abort_guest_exit_end:
+
+	/*
+	 * If we took an abort, r0[31] will be set, and cmp will set
+	 * the N bit in PSTATE.
+	 */
+	cmp	r0, #0
+	msrmi	SPSR_cxsf, r1
+	msrmi	ELR_hyp, r2
+	mcrmi	p15, 4, r3, c5, c2, 0	@ HSR
+
 	bx	lr
 ENDPROC(__guest_exit)
 
diff --git a/arch/arm/kvm/hyp/hyp-entry.S b/arch/arm/kvm/hyp/hyp-entry.S
index 7809138..96beb53 100644
--- a/arch/arm/kvm/hyp/hyp-entry.S
+++ b/arch/arm/kvm/hyp/hyp-entry.S
@@ -81,7 +81,6 @@ __kvm_hyp_vector:
 	invalid_vector	hyp_undef	ARM_EXCEPTION_UNDEFINED
 	invalid_vector	hyp_svc		ARM_EXCEPTION_SOFTWARE
 	invalid_vector	hyp_pabt	ARM_EXCEPTION_PREF_ABORT
-	invalid_vector	hyp_dabt	ARM_EXCEPTION_DATA_ABORT
 	invalid_vector	hyp_fiq		ARM_EXCEPTION_FIQ
 
 ENTRY(__hyp_do_panic)
@@ -164,6 +163,21 @@ hyp_irq:
 	load_vcpu r0			@ Load VCPU pointer to r0
 	b	__guest_exit
 
+hyp_dabt:
+	push	{r0, r1}
+	mrs	r0, ELR_hyp
+	ldr	r1, =abort_guest_exit_start
+THUMB(	add	r1, r1, #1)
+	cmp	r0, r1
+	ldrne	r1, =abort_guest_exit_end
+THUMB(	addne	r1, r1, #1)
+	cmpne	r0, r1
+	pop	{r0, r1}
+	bne	__hyp_panic
+
+	orr	r0, r0, #(1 << ARM_EXIT_WITH_ABORT_BIT)
+	eret
+
 	.ltorg
 
 	.popsection
-- 
2.1.4

