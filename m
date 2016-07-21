From: Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH] kvm: arm: Enforce some NS-SVC initialisation
Date: Thu, 21 Jul 2016 13:01:12 +0100
Message-ID: <5322cdb9cb397741d15b60c6693ad39dbf74b6d5.1469101945.git.robin.murphy@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A16E849B32
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2016 07:55:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y0Vs91+DiNLs for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2016 07:55:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E09EB49B30
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2016 07:55:03 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Since the non-secure copies of banked registers lack architecturally
defined reset values, there is no actual guarantee when entering in Hyp
from secure-only firmware that the non-secure PL1 state will look the
way that kernel entry (in particular the decompressor stub) expects.
So far, we've been getting away with it thanks to implementation details
of ARMv7 cores and/or bootloader behaviour, but for the sake of forwards
compatibility let's try to ensure that we have a minimally sane state
before dropping down into it.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
---
 arch/arm/kernel/hyp-stub.S | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
index 0b1e4a93d67e..7de3fe15ab21 100644
--- a/arch/arm/kernel/hyp-stub.S
+++ b/arch/arm/kernel/hyp-stub.S
@@ -142,6 +142,18 @@ ARM_BE8(orr	r7, r7, #(1 << 25))     @ HSCTLR.EE
 	and	r7, #0x1f		@ Preserve HPMN
 	mcr	p15, 4, r7, c1, c1, 1	@ HDCR
 
+	@ Make sure NS-SVC is initialised appropriately
+	mrc	p15, 0, r7, c1, c0, 0	@ SCTLR
+	orr	r7, #(1 << 5)		@ CP15 barriers enabled
+	bic	r7, #(3 << 19)		@ WXN and UWXN disabled
+	mcr	p15, 0, r7, c1, c0, 0	@ SCTLR
+
+	mrc	p15, 0, r7, c0, c0, 0	@ MIDR
+	mcr	p15, 4, r7, c0, c0, 0	@ VPIDR
+
+	mrc	p15, 0, r7, c0, c0, 5	@ MPIDR
+	mcr	p15, 4, r7, c0, c0, 5	@ VMPIDR
+
 #if !defined(ZIMAGE) && defined(CONFIG_ARM_ARCH_TIMER)
 	@ make CNTP_* and CNTPCT accessible from PL1
 	mrc	p15, 0, r7, c0, c1, 1	@ ID_PFR1
-- 
2.8.1.dirty
