From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 2/3] arm64: use alternative auto-nop
Date: Wed,  7 Sep 2016 11:07:09 +0100
Message-ID: <1473242830-26246-3-git-send-email-mark.rutland@arm.com>
References: <1473242830-26246-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77B6D49B47
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Sep 2016 05:59:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2+PoSqOAifhJ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Sep 2016 05:59:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1059499A1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Sep 2016 05:59:12 -0400 (EDT)
In-Reply-To: <1473242830-26246-1-git-send-email-mark.rutland@arm.com>
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
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, will.deacon@arm.com, dave.martin@arm.com, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Make use of the new alternative_if and alternative_else_nop_endif and
get rid of our homebew NOP sleds, making the code simpler to read.

Note that for cpu_do_switch_mm the ret has been moved out of the
alternative sequence, and in the default case there will be three
additional NOPs executed.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/kernel/entry.S  | 10 ++--------
 arch/arm64/lib/copy_page.S | 13 ++++---------
 arch/arm64/mm/proc.S       |  9 ++-------
 3 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 441420c..1c76066 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -150,13 +150,7 @@
 	ldr	x23, [sp, #S_SP]		// load return stack pointer
 	msr	sp_el0, x23
 #ifdef CONFIG_ARM64_ERRATUM_845719
-alternative_if_not ARM64_WORKAROUND_845719
-	nop
-	nop
-#ifdef CONFIG_PID_IN_CONTEXTIDR
-	nop
-#endif
-alternative_else
+alternative_if ARM64_WORKAROUND_845719
 	tbz	x22, #4, 1f
 #ifdef CONFIG_PID_IN_CONTEXTIDR
 	mrs	x29, contextidr_el1
@@ -165,7 +159,7 @@ alternative_else
 	msr contextidr_el1, xzr
 #endif
 1:
-alternative_endif
+alternative_else_nop_endif
 #endif
 	.endif
 	msr	elr_el1, x21			// set up the return data
diff --git a/arch/arm64/lib/copy_page.S b/arch/arm64/lib/copy_page.S
index 4c1e700..c3cd65e 100644
--- a/arch/arm64/lib/copy_page.S
+++ b/arch/arm64/lib/copy_page.S
@@ -29,14 +29,11 @@
  *	x1 - src
  */
 ENTRY(copy_page)
-alternative_if_not ARM64_HAS_NO_HW_PREFETCH
-	nop
-	nop
-alternative_else
+alternative_if ARM64_HAS_NO_HW_PREFETCH
 	# Prefetch two cache lines ahead.
 	prfm    pldl1strm, [x1, #128]
 	prfm    pldl1strm, [x1, #256]
-alternative_endif
+alternative_else_nop_endif
 
 	ldp	x2, x3, [x1]
 	ldp	x4, x5, [x1, #16]
@@ -52,11 +49,9 @@ alternative_endif
 1:
 	subs	x18, x18, #128
 
-alternative_if_not ARM64_HAS_NO_HW_PREFETCH
-	nop
-alternative_else
+alternative_if ARM64_HAS_NO_HW_PREFETCH
 	prfm    pldl1strm, [x1, #384]
-alternative_endif
+alternative_else_nop_endif
 
 	stnp	x2, x3, [x0]
 	ldp	x2, x3, [x1]
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 5bb61de..2bb088f 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -125,17 +125,12 @@ ENTRY(cpu_do_switch_mm)
 	bfi	x0, x1, #48, #16		// set the ASID
 	msr	ttbr0_el1, x0			// set TTBR0
 	isb
-alternative_if_not ARM64_WORKAROUND_CAVIUM_27456
-	ret
-	nop
-	nop
-	nop
-alternative_else
+alternative_if ARM64_WORKAROUND_CAVIUM_27456
 	ic	iallu
 	dsb	nsh
 	isb
+alternative_else_nop_endif
 	ret
-alternative_endif
 ENDPROC(cpu_do_switch_mm)
 
 	.pushsection ".idmap.text", "ax"
-- 
1.9.1
