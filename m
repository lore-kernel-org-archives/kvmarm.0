From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 10/15] arm-soc: exynos: replace open coded VA->PA conversions
Date: Sat,  5 Aug 2017 21:52:17 +0100
Message-ID: <20170805205222.19868-11-ard.biesheuvel@linaro.org>
References: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5060C49C63
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:52:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9lde6ISAsrPt for <kvmarm@lists.cs.columbia.edu>;
 Sat,  5 Aug 2017 16:52:18 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 28AF649C40
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:52:17 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id t201so42547388wmt.0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 05 Aug 2017 13:53:42 -0700 (PDT)
In-Reply-To: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, linux-renesas-soc@vger.kernel.org, linux@armlinux.org.uk, linux-omap@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, krzk@kernel.org, jason@lakedaemon.net, arm@kernel.org, andrew@lunn.ch, gregory.clement@free-electrons.com, sebastian.hesselbarth@gmail.com, tony@atomide.com, baohua@kernel.org, horms@verge.net.au, magnus.damm@gmail.com, vireshk@kernel.org, shiraz.linux.kernel@gmail.com, patrice.chotard@st.com, nico@linaro.org, dave.martin@arm.com, marc.zyngier@arm.com
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This replaces a couple of open coded calculations to obtain the
physical address of a far symbol with calls to the new adr_l etc
macros.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/mach-exynos/headsmp.S |  9 +------
 arch/arm/mach-exynos/sleep.S   | 26 ++++----------------
 2 files changed, 6 insertions(+), 29 deletions(-)

diff --git a/arch/arm/mach-exynos/headsmp.S b/arch/arm/mach-exynos/headsmp.S
index d3d24ab351ae..25de5aff1c41 100644
--- a/arch/arm/mach-exynos/headsmp.S
+++ b/arch/arm/mach-exynos/headsmp.S
@@ -23,10 +23,7 @@ ENTRY(exynos4_secondary_startup)
 ARM_BE8(setend	be)
 	mrc	p15, 0, r0, c0, c0, 5
 	and	r0, r0, #15
-	adr	r4, 1f
-	ldmia	r4, {r5, r6}
-	sub	r4, r4, r5
-	add	r6, r6, r4
+	adr_l	r6, pen_release
 pen:	ldr	r7, [r6]
 	cmp	r7, r0
 	bne	pen
@@ -37,7 +34,3 @@ pen:	ldr	r7, [r6]
 	 */
 	b	secondary_startup
 ENDPROC(exynos4_secondary_startup)
-
-	.align 2
-1:	.long	.
-	.long	pen_release
diff --git a/arch/arm/mach-exynos/sleep.S b/arch/arm/mach-exynos/sleep.S
index cf950790fbdc..003465699263 100644
--- a/arch/arm/mach-exynos/sleep.S
+++ b/arch/arm/mach-exynos/sleep.S
@@ -17,6 +17,7 @@
 
 #include <linux/linkage.h>
 #include <asm/asm-offsets.h>
+#include <asm/assembler.h>
 #include <asm/hardware/cache-l2x0.h>
 #include "smc.h"
 
@@ -62,19 +63,13 @@ ENTRY(exynos_cpu_resume_ns)
 	cmp	r0, r1
 	bne	skip_cp15
 
-	adr	r0, _cp15_save_power
-	ldr	r1, [r0]
-	ldr	r1, [r0, r1]
-	adr	r0, _cp15_save_diag
-	ldr	r2, [r0]
-	ldr	r2, [r0, r2]
+	ldr_l	r1, cp15_save_power
+	ldr_l	r2, cp15_save_diag
 	mov	r0, #SMC_CMD_C15RESUME
 	dsb
 	smc	#0
 #ifdef CONFIG_CACHE_L2X0
-	adr	r0, 1f
-	ldr	r2, [r0]
-	add	r0, r2, r0
+	adr_l	r0, l2x0_saved_regs
 
 	/* Check that the address has been initialised. */
 	ldr	r1, [r0, #L2X0_R_PHY_BASE]
@@ -93,9 +88,7 @@ ENTRY(exynos_cpu_resume_ns)
 	smc	#0
 
 	/* Reload saved regs pointer because smc corrupts registers. */
-	adr	r0, 1f
-	ldr	r2, [r0]
-	add	r0, r2, r0
+	adr_l	r0, l2x0_saved_regs
 
 	ldr	r1, [r0, #L2X0_R_PWR_CTRL]
 	ldr	r2, [r0, #L2X0_R_AUX_CTRL]
@@ -114,15 +107,6 @@ skip_cp15:
 	b	cpu_resume
 ENDPROC(exynos_cpu_resume_ns)
 
-	.align
-_cp15_save_power:
-	.long	cp15_save_power - .
-_cp15_save_diag:
-	.long	cp15_save_diag - .
-#ifdef CONFIG_CACHE_L2X0
-1:	.long	l2x0_saved_regs - .
-#endif /* CONFIG_CACHE_L2X0 */
-
 	.data
 	.globl cp15_save_diag
 cp15_save_diag:
-- 
2.11.0
