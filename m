From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [PATCH] arm64: head.S: Fix CNTHCTL_EL2 access on VHE system
Date: Mon, 28 Nov 2016 11:43:58 -0500
Message-ID: <1480351438-11548-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41DDE405C4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 11:44:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KqBWcl0YQRbu for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Nov 2016 11:44:11 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 24ED240537
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 11:44:11 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id uASGe4WZ050101
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 11:44:58 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 8C92484
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 11:44:58 -0500 (EST)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu
 [128.59.72.14]) by hazelnut (Postfix) with ESMTP id 1E89281
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 11:44:58 -0500 (EST)
Received: from mail-qk0-f198.google.com (mail-qk0-f198.google.com
 [209.85.220.198])
 by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id uASGivRc026850
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 11:44:58 -0500
Received: by mail-qk0-f198.google.com with SMTP id x190so114612853qkb.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 08:44:58 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, andre.przywara@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Jintack <jintack@cs.columbia.edu>

Bit positions of CNTHCTL_EL2 are changing depending on HCR_EL2.E2H bit.
EL1PCEN and EL1PCTEN are 1st and 0th bits when E2H is not set, but they
are 11th and 10th bits respectively when E2H is set.  Current code is
unintentionally setting wrong bits to CNTHCTL_EL2 with E2H set.

In fact, we don't need to set those two bits, which allow EL1 and EL0 to
access physical timer and counter respectively, if E2H and TGE are set
for the host kernel. They will be configured later as necessary. First,
we don't need to configure those bits for EL1, since the host kernel
runs in EL2.  It is a hypervisor's responsibility to configure them
before entering a VM, which runs in EL0 and EL1. Second, EL0 accesses
are configured in the later stage of boot process.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/kernel/head.S | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 332e331..bc3d2db 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -524,10 +524,16 @@ set_hcr:
 	msr	hcr_el2, x0
 	isb
 
-	/* Generic timers. */
+	/*
+	 * Allow Non-secure EL1 and EL0 to access physical timer and counter.
+	 * This is not necessary for VHE, since the host kernel runs in EL2,
+	 * and EL0 accesses are configured in the later stage of boot process.
+	 */
+	cbnz	x2, 1f
 	mrs	x0, cnthctl_el2
 	orr	x0, x0, #3			// Enable EL1 physical timers
 	msr	cnthctl_el2, x0
+1:
 	msr	cntvoff_el2, xzr		// Clear virtual offset
 
 #ifdef CONFIG_ARM_GIC_V3
-- 
1.9.1
