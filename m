From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 15/15] ARM: l2c: replace open coded VA->PA calculation
Date: Sat,  5 Aug 2017 21:52:22 +0100
Message-ID: <20170805205222.19868-16-ard.biesheuvel@linaro.org>
References: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D41F649C29
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:52:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KGrkrzagXHCd for <kvmarm@lists.cs.columbia.edu>;
 Sat,  5 Aug 2017 16:52:36 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1955E49C27
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:52:36 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id m85so42484440wma.0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 05 Aug 2017 13:54:00 -0700 (PDT)
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

This replaces an open coded calculation to obtain the physical
address of a far symbol with a call to the new adr_l macro.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/mm/l2c-l2x0-resume.S | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arm/mm/l2c-l2x0-resume.S b/arch/arm/mm/l2c-l2x0-resume.S
index fda415e4ca8f..3e75aa8c1aff 100644
--- a/arch/arm/mm/l2c-l2x0-resume.S
+++ b/arch/arm/mm/l2c-l2x0-resume.S
@@ -12,9 +12,7 @@
 	.text
 
 ENTRY(l2c310_early_resume)
-	adr	r0, 1f
-	ldr	r2, [r0]
-	add	r0, r2, r0
+	adr_l	r0, l2x0_saved_regs
 
 	ldmia	r0, {r1, r2, r3, r4, r5, r6, r7, r8}
 	@ r1 = phys address of L2C-310 controller
@@ -54,6 +52,3 @@ ENTRY(l2c310_early_resume)
 	str	r9, [r1, #L2X0_CTRL]
 	ret	lr
 ENDPROC(l2c310_early_resume)
-
-	.align
-1:	.long	l2x0_saved_regs - .
-- 
2.11.0
