From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v4 2/2] arm: KVM: keep arm vfp/simd exit handling consistent
 with arm64
Date: Thu, 16 Jul 2015 14:29:38 -0700
Message-ID: <1437082178-11039-3-git-send-email-m.smarduch@samsung.com>
References: <1437082178-11039-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C36A58B91
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jul 2015 17:18:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Uu3Os72bCqii for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jul 2015 17:18:31 -0400 (EDT)
Received: from usmailout3.samsung.com (mailout3.w2.samsung.com
 [211.189.100.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D741F58B93
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jul 2015 17:18:31 -0400 (EDT)
Received: from uscpsbgex4.samsung.com
 (u125.gpu85.samsung.co.kr [203.254.195.125]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NRL004T7NQRSL60@usmailout3.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Thu, 16 Jul 2015 17:30:27 -0400 (EDT)
In-reply-to: <1437082178-11039-1-git-send-email-m.smarduch@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

After enhancing arm64 FP/SIMD exit handling, ARMv7 VFP exit branch is moved
to guest trap handling. This allows us to keep exit handling flow between both
architectures consistent.

Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
---
 arch/arm/kvm/interrupts.S | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
index 79caf79..b245b4e 100644
--- a/arch/arm/kvm/interrupts.S
+++ b/arch/arm/kvm/interrupts.S
@@ -363,10 +363,6 @@ hyp_hvc:
 	@ Check syndrome register
 	mrc	p15, 4, r1, c5, c2, 0	@ HSR
 	lsr	r0, r1, #HSR_EC_SHIFT
-#ifdef CONFIG_VFPv3
-	cmp	r0, #HSR_EC_CP_0_13
-	beq	switch_to_guest_vfp
-#endif
 	cmp	r0, #HSR_EC_HVC
 	bne	guest_trap		@ Not HVC instr.
 
@@ -380,7 +376,10 @@ hyp_hvc:
 	cmp     r2, #0
 	bne	guest_trap		@ Guest called HVC
 
-host_switch_to_hyp:
+	/*
+	 * Getting here means host called HVC, we shift parameters and branch
+	 * to Hyp function.
+	 */
 	pop	{r0, r1, r2}
 
 	/* Check for __hyp_get_vectors */
@@ -411,6 +410,10 @@ guest_trap:
 
 	@ Check if we need the fault information
 	lsr	r1, r1, #HSR_EC_SHIFT
+#ifdef CONFIG_VFPv3
+	cmp	r1, #HSR_EC_CP_0_13
+	beq	switch_to_guest_vfp
+#endif
 	cmp	r1, #HSR_EC_IABT
 	mrceq	p15, 4, r2, c6, c0, 2	@ HIFAR
 	beq	2f
@@ -479,7 +482,6 @@ guest_trap:
  */
 #ifdef CONFIG_VFPv3
 switch_to_guest_vfp:
-	load_vcpu			@ Load VCPU pointer to r0
 	push	{r3-r7}
 
 	@ NEON/VFP used.  Turn on VFP access.
-- 
1.9.1
