From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [PATCH v2] arm64: head.S: Fix CNTHCTL_EL2 access on VHE system
Date: Mon, 28 Nov 2016 21:13:02 -0500
Message-ID: <1480385582-24176-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9ACD840665
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 21:22:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QHxldOSroVQU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Nov 2016 21:21:59 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E3D2B405E6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 21:21:59 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id uAT2IuM8053137
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 21:22:48 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 1CEBB6D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 21:22:48 -0500 (EST)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu
 [128.59.72.14]) by hazelnut (Postfix) with ESMTP id CF58F6D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 21:22:47 -0500 (EST)
Received: from mail-qk0-f197.google.com (mail-qk0-f197.google.com
 [209.85.220.197])
 by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id uAT2MlNI044302
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 21:22:47 -0500
Received: by mail-qk0-f197.google.com with SMTP id g193so124135482qke.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 18:22:47 -0800 (PST)
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
Acked-by: Marc Zyngier <marc.zyngier@arm.com>

---
v2: Add comments about accessing CNTHCTL_EL2 when HCR_EL2.ECH == 1

---
 arch/arm64/kernel/head.S | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 332e331..136cb0d 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -524,10 +524,21 @@ set_hcr:
 	msr	hcr_el2, x0
 	isb
 
-	/* Generic timers. */
+	/*
+	 * Allow Non-secure EL1 and EL0 to access physical timer and counter.
+	 * This is not necessary for VHE, since the host kernel runs in EL2,
+	 * and EL0 accesses are configured in the later stage of boot process.
+	 * Note that when HCR_EL2.E2H == 1, CNTHCTL_EL2 has the same bit layout
+	 * as CNTKCTL_EL1, and CNTKCTL_EL1 accessing instructions are redefined
+	 * to access CNTHCTL_EL2. This allows the kernel designed to run at EL1
+	 * to transparently mess with the EL0 bits via CNTKCTL_EL1 access in
+	 * EL2.
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
