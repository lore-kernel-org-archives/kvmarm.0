From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v2 2/2] arm: KVM: keep arm vfp/simd exit handling consistent
 with arm64
Date: Tue, 16 Jun 2015 14:50:52 -0700
Message-ID: <1434491452-19177-3-git-send-email-m.smarduch@samsung.com>
References: <1434491452-19177-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9573855C47
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jun 2015 17:41:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4ortxHAj4U+n for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jun 2015 17:41:26 -0400 (EDT)
Received: from usmailout1.samsung.com (mailout1.w2.samsung.com
 [211.189.100.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E377755C44
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jun 2015 17:41:26 -0400 (EDT)
Received: from uscpsbgex2.samsung.com
 (u123.gpu85.samsung.co.kr [203.254.195.123]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NQ200HUC4QRKL30@mailout1.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 16 Jun 2015 17:52:03 -0400 (EDT)
In-reply-to: <1434491452-19177-1-git-send-email-m.smarduch@samsung.com>
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
Cc: catalin.marinas@arm.com, will.deacon@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

After enhancing arm64 FP/SIMD exit handling, FP/SIMD exit branch is moved
to guest trap handling. This keeps exiting handling flow between both
architectures consistent.

Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
---
 arch/arm/kvm/interrupts.S |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
index 79caf79..fca2c56 100644
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
 
@@ -406,6 +402,12 @@ THUMB(	orr	lr, #1)
 1:	eret
 
 guest_trap:
+#ifdef CONFIG_VFPv3
+	/* Guest accessed VFP/SIMD registers, save host, restore Guest */
+	cmp	r0, #HSR_EC_CP_0_13
+	beq	switch_to_guest_fpsimd
+#endif
+
 	load_vcpu			@ Load VCPU pointer to r0
 	str	r1, [vcpu, #VCPU_HSR]
 
@@ -478,7 +480,7 @@ guest_trap:
  * inject an undefined exception to the guest.
  */
 #ifdef CONFIG_VFPv3
-switch_to_guest_vfp:
+switch_to_guest_fpsimd:
 	load_vcpu			@ Load VCPU pointer to r0
 	push	{r3-r7}
 
-- 
1.7.9.5
