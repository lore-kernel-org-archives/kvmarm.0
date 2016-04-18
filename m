From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH] arm64: Fix EL1/EL2 early init inconsistencies with VHE
Date: Mon, 18 Apr 2016 18:57:26 +0100
Message-ID: <1461002246-25314-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D86449BC4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2016 13:55:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XeSiI1q9rTHg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Apr 2016 13:55:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F26F049BC2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2016 13:55:38 -0400 (EDT)
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
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

When using the Virtualisation Host Extensions, EL1 is not used in
the host and requires no separate configuration.

In addition, with VHE enabled, non-hyp-specific EL2 configuration
that does not need to be done early will be done anyway in
__cpu_setup via the _EL1 system register aliases.  In particular,
the layout and definition of CPTR_EL2 are changed by enabling VHE
so that they resemble CPACR_EL1, so existing code to initialise
CPTR_EL2 becomes architecturally wrong in this case.

This patch simply skips the affected initialisation code in the
non-VHE case.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---

Note -- not tested yet, and I'm still unclear on whether this is the
correct architectural approach...

 arch/arm64/kernel/head.S | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 4203d5f..67132c1 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -588,6 +588,15 @@ set_hcr:
 	msr	vpidr_el2, x0
 	msr	vmpidr_el2, x1
 
+	/*
+	 * When VHE is not in use, early init of EL2 and EL1 needs to be
+	 * done here.
+	 * When VHE _is_ in use, EL1 will not be used in the host and
+	 * requires no configuration, and all non-hyp-specific EL2 setup
+	 * will be done via the _EL1 system register aliases in __cpu_setup.
+	 */
+	cbnz	x2, 1f
+
 	/* sctlr_el1 */
 	mov	x0, #0x0800			// Set/clear RES{1,0} bits
 CPU_BE(	movk	x0, #0x33d0, lsl #16	)	// Set EE and E0E on BE systems
@@ -597,6 +606,7 @@ CPU_LE(	movk	x0, #0x30d0, lsl #16	)	// Clear EE and E0E on LE systems
 	/* Coprocessor traps. */
 	mov	x0, #0x33ff
 	msr	cptr_el2, x0			// Disable copro. traps to EL2
+1:
 
 #ifdef CONFIG_COMPAT
 	msr	hstr_el2, xzr			// Disable CP15 traps to EL2
-- 
2.1.4
