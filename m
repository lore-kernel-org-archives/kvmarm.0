From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v6 4/6] arm: KVM: Delete unused macros
Date: Sat, 26 Dec 2015 13:54:58 -0800
Message-ID: <1451166900-3711-5-git-send-email-m.smarduch@samsung.com>
References: <1451166900-3711-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EEE24155B
 for <kvmarm@lists.cs.columbia.edu>; Sat, 26 Dec 2015 16:52:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Aahy9sQ-gfm5 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 26 Dec 2015 16:52:47 -0500 (EST)
Received: from usmailout1.samsung.com (mailout1.w2.samsung.com
 [211.189.100.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9DB7940F9B
 for <kvmarm@lists.cs.columbia.edu>; Sat, 26 Dec 2015 16:52:47 -0500 (EST)
Received: from uscpsbgex1.samsung.com
 (u122.gpu85.samsung.co.kr [203.254.195.122]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NZZ00786JKZ9020@mailout1.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Sat, 26 Dec 2015 16:55:47 -0500 (EST)
In-reply-to: <1451166900-3711-1-git-send-email-m.smarduch@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

set_hcptr is no longer used so delete it.

Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
---
 arch/arm/kvm/interrupts_head.S | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
index 51a5950..f4d8311 100644
--- a/arch/arm/kvm/interrupts_head.S
+++ b/arch/arm/kvm/interrupts_head.S
@@ -589,35 +589,6 @@ ARM_BE8(rev	r6, r6  )
 	mcr	p15, 4, r2, c1, c1, 3
 .endm
 
-/* Configures the HCPTR (Hyp Coprocessor Trap Register) on entry/return
- * (hardware reset value is 0). Keep previous value in r2.
- * An ISB is emited on vmexit/vmtrap, but executed on vmexit only if
- * VFP wasn't already enabled (always executed on vmtrap).
- * If a label is specified with vmexit, it is branched to if VFP wasn't
- * enabled.
- */
-.macro set_hcptr operation, mask, label = none
-	mrc	p15, 4, r2, c1, c1, 2
-	ldr	r3, =\mask
-	.if \operation == vmentry
-	orr	r3, r2, r3		@ Trap coproc-accesses defined in mask
-	.else
-	bic	r3, r2, r3		@ Don't trap defined coproc-accesses
-	.endif
-	mcr	p15, 4, r3, c1, c1, 2
-	.if \operation != vmentry
-	.if \operation == vmexit
-	tst	r2, #(HCPTR_TCP(10) | HCPTR_TCP(11))
-	beq	1f
-	.endif
-	isb
-	.if \label != none
-	b	\label
-	.endif
-1:
-	.endif
-.endm
-
 /* Configures the HDCR (Hyp Debug Configuration Register) on entry/return
  * (hardware reset value is 0) */
 .macro set_hdcr operation
-- 
1.9.1
