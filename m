From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 22/50] arm64: KVM: Route asynchronous aborts
Date: Tue, 27 Sep 2016 20:05:30 +0200
Message-ID: <20160927180558.14699-23-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AECA49B4E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6BlhCZr3NxlE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:56:51 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1FD2A49BB0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:44 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id b130so27063904wmc.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:06:08 -0700 (PDT)
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

As we now have some basic handling to EL1-triggered aborts, we can
actually report them to KVM.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/hyp-entry.S | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index d6cae54..d2f6640 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -120,6 +120,12 @@ el1_irq:
 	mov	x0, #ARM_EXCEPTION_IRQ
 	b	__guest_exit
 
+el1_error:
+	stp     x0, x1, [sp, #-16]!
+	mrs	x1, tpidr_el2
+	mov	x0, #ARM_EXCEPTION_EL1_SERROR
+	b	__guest_exit
+
 ENTRY(__hyp_do_panic)
 	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
 		      PSR_MODE_EL1h)
@@ -148,7 +154,6 @@ ENDPROC(\label)
 	invalid_vector	el1_sync_invalid
 	invalid_vector	el1_irq_invalid
 	invalid_vector	el1_fiq_invalid
-	invalid_vector	el1_error_invalid
 
 	.ltorg
 
@@ -168,10 +173,10 @@ ENTRY(__kvm_hyp_vector)
 	ventry	el1_sync			// Synchronous 64-bit EL1
 	ventry	el1_irq				// IRQ 64-bit EL1
 	ventry	el1_fiq_invalid			// FIQ 64-bit EL1
-	ventry	el1_error_invalid		// Error 64-bit EL1
+	ventry	el1_error			// Error 64-bit EL1
 
 	ventry	el1_sync			// Synchronous 32-bit EL1
 	ventry	el1_irq				// IRQ 32-bit EL1
 	ventry	el1_fiq_invalid			// FIQ 32-bit EL1
-	ventry	el1_error_invalid		// Error 32-bit EL1
+	ventry	el1_error			// Error 32-bit EL1
 ENDPROC(__kvm_hyp_vector)
-- 
2.9.0
