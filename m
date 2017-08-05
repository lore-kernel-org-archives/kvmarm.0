From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 13/15] arm-soc: various: replace open coded VA->PA calculation
 of pen_release
Date: Sat,  5 Aug 2017 21:52:20 +0100
Message-ID: <20170805205222.19868-14-ard.biesheuvel@linaro.org>
References: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9030D49C28
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:52:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o0JGE0M-+--6 for <kvmarm@lists.cs.columbia.edu>;
 Sat,  5 Aug 2017 16:52:28 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E33B49C27
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:52:28 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id t201so42451361wmt.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 05 Aug 2017 13:53:52 -0700 (PDT)
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

This replaces a few copies of the open coded calculations of the
physical address of 'pen_release' in the secondary startup code
of a couple of platforms.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/mach-prima2/headsmp.S    | 11 +++--------
 arch/arm/mach-spear/headsmp.S     | 11 +++--------
 arch/arm/mach-sti/headsmp.S       | 10 +++-------
 arch/arm/plat-versatile/headsmp.S |  9 +--------
 4 files changed, 10 insertions(+), 31 deletions(-)

diff --git a/arch/arm/mach-prima2/headsmp.S b/arch/arm/mach-prima2/headsmp.S
index 209d9fc5c16c..070df700bb38 100644
--- a/arch/arm/mach-prima2/headsmp.S
+++ b/arch/arm/mach-prima2/headsmp.S
@@ -9,6 +9,8 @@
 #include <linux/linkage.h>
 #include <linux/init.h>
 
+#include <asm/assembler.h>
+
 /*
  * SIRFSOC specific entry point for secondary CPUs.  This provides
  * a "holding pen" into which all secondary cores are held until we're
@@ -17,10 +19,7 @@
 ENTRY(sirfsoc_secondary_startup)
         mrc     p15, 0, r0, c0, c0, 5
         and     r0, r0, #15
-        adr     r4, 1f
-        ldmia   r4, {r5, r6}
-        sub     r4, r4, r5
-        add     r6, r6, r4
+        adr_l   r6, pen_release
 pen:    ldr     r7, [r6]
         cmp     r7, r0
         bne     pen
@@ -31,7 +30,3 @@ pen:    ldr     r7, [r6]
          */
         b       secondary_startup
 ENDPROC(sirfsoc_secondary_startup)
-
-        .align
-1:      .long   .
-        .long   pen_release
diff --git a/arch/arm/mach-spear/headsmp.S b/arch/arm/mach-spear/headsmp.S
index c52192dc3d9f..4da01b103f33 100644
--- a/arch/arm/mach-spear/headsmp.S
+++ b/arch/arm/mach-spear/headsmp.S
@@ -13,6 +13,8 @@
 #include <linux/linkage.h>
 #include <linux/init.h>
 
+#include <asm/assembler.h>
+
 	__INIT
 
 /*
@@ -23,10 +25,7 @@
 ENTRY(spear13xx_secondary_startup)
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
@@ -40,8 +39,4 @@ pen:	ldr	r7, [r6]
 	 * should now contain the SVC stack for this core
 	 */
 	b	secondary_startup
-
-	.align
-1:	.long	.
-	.long	pen_release
 ENDPROC(spear13xx_secondary_startup)
diff --git a/arch/arm/mach-sti/headsmp.S b/arch/arm/mach-sti/headsmp.S
index e0ad451700d5..cdf3442f397b 100644
--- a/arch/arm/mach-sti/headsmp.S
+++ b/arch/arm/mach-sti/headsmp.S
@@ -16,6 +16,8 @@
 #include <linux/linkage.h>
 #include <linux/init.h>
 
+#include <asm/assembler.h>
+
 /*
  * ST specific entry point for secondary CPUs.  This provides
  * a "holding pen" into which all secondary cores are held until we're
@@ -24,10 +26,7 @@
 ENTRY(sti_secondary_startup)
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
@@ -38,6 +37,3 @@ pen:	ldr	r7, [r6]
 	 */
 	b	secondary_startup
 ENDPROC(sti_secondary_startup)
-
-1:	.long	.
-	.long	pen_release
diff --git a/arch/arm/plat-versatile/headsmp.S b/arch/arm/plat-versatile/headsmp.S
index 40f27e52de75..0f2a5eddac5a 100644
--- a/arch/arm/plat-versatile/headsmp.S
+++ b/arch/arm/plat-versatile/headsmp.S
@@ -21,10 +21,7 @@ ENTRY(versatile_secondary_startup)
  ARM_BE8(setend	be)
 	mrc	p15, 0, r0, c0, c0, 5
 	bic	r0, #0xff000000
-	adr	r4, 1f
-	ldmia	r4, {r5, r6}
-	sub	r4, r4, r5
-	add	r6, r6, r4
+	adr_l	r6, pen_release
 pen:	ldr	r7, [r6]
 	cmp	r7, r0
 	bne	pen
@@ -34,8 +31,4 @@ pen:	ldr	r7, [r6]
 	 * should now contain the SVC stack for this core
 	 */
 	b	secondary_startup
-
-	.align
-1:	.long	.
-	.long	pen_release
 ENDPROC(versatile_secondary_startup)
-- 
2.11.0
