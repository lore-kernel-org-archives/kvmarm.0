From: Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH v2] kvm: arm: Enforce some NS-SVC initialisation
Date: Tue, 16 Aug 2016 18:49:18 +0100
Message-ID: <6d030bee2db08c2fe1b7569e692e8f66800b1e4c.1471369569.git.robin.murphy@arm.com>
References: <5322cdb9cb397741d15b60c6693ad39dbf74b6d5.1469101945.git.robin.murphy@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F238413E1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Aug 2016 13:41:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qsIr3d27S848 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Aug 2016 13:41:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 820FB412A2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Aug 2016 13:41:56 -0400 (EDT)
In-Reply-To: <5322cdb9cb397741d15b60c6693ad39dbf74b6d5.1469101945.git.robin.murphy@arm.com>
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
from secure-only firmware that the Non-Secure PL1 state will look the
way that kernel entry (in particular the decompressor stub) expects.
So far, we've been getting away with it thanks to implementation details
of ARMv7 cores and/or bootloader behaviour, but for the sake of forwards
compatibility let's try to ensure that we have a minimally sane state
before dropping down into it.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
---

v2: Initialise SED/ITD to safe values as well.

 arch/arm/kernel/hyp-stub.S | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
index 0b1e4a93d67e..15d073ae5da2 100644
--- a/arch/arm/kernel/hyp-stub.S
+++ b/arch/arm/kernel/hyp-stub.S
@@ -142,6 +142,19 @@ ARM_BE8(orr	r7, r7, #(1 << 25))     @ HSCTLR.EE
 	and	r7, #0x1f		@ Preserve HPMN
 	mcr	p15, 4, r7, c1, c1, 1	@ HDCR
 
+	@ Make sure NS-SVC is initialised appropriately
+	mrc	p15, 0, r7, c1, c0, 0	@ SCTLR
+	orr	r7, #(1 << 5)		@ CP15 barriers enabled
+	bic	r7, #(3 << 7)		@ Clear SED/ITD for v8 (RES0 for v7)
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
