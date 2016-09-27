From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 30/50] arm: KVM: Handle async aborts delivered while at HYP
Date: Tue, 27 Sep 2016 20:05:38 +0200
Message-ID: <20160927180558.14699-31-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C707549B94
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OAda1kHlF0Ij for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:56:56 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0748949BAF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:52 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id w84so190362392wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:06:16 -0700 (PDT)
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

Just like for arm64, we can handle asynchronous aborts being
delivered at HYP while being caused by the guest. We use
the exact same method to catch such an abort, and soldier on.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
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
2.9.0
