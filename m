From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [PATCH] arm64: head.S: Fix CNTHCTL_EL2 access on VHE system
Date: Mon, 28 Nov 2016 11:37:39 -0500
Message-ID: <1480351059-11370-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 904D4405C4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 11:37:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nHqd03XMtlf4 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Nov 2016 11:37:18 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D85C40537
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 11:37:18 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id uASGXnvN045463
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 11:38:05 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id D7FD492
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 11:38:05 -0500 (EST)
Received: from sendprodmail01.cc.columbia.edu (sendprodmail01.cc.columbia.edu
 [128.59.72.13]) by hazelnut (Postfix) with ESMTP id 41985AE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 11:38:04 -0500 (EST)
Received: from mail-qk0-f200.google.com (mail-qk0-f200.google.com
 [209.85.220.200])
 by sendprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id uASGc4fW049822
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 11:38:04 -0500
Received: by mail-qk0-f200.google.com with SMTP id h201so114337535qke.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 08:38:04 -0800 (PST)
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
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu
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
