From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 08/15] ARM: head.S: use PC relative insn sequence to calculate
 PHYS_OFFSET
Date: Sat,  5 Aug 2017 21:52:15 +0100
Message-ID: <20170805205222.19868-9-ard.biesheuvel@linaro.org>
References: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA30B49C2C
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:52:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WIk6S7npSF9Z for <kvmarm@lists.cs.columbia.edu>;
 Sat,  5 Aug 2017 16:52:11 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 12E5749C27
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:52:10 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id t201so42448842wmt.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 05 Aug 2017 13:53:35 -0700 (PDT)
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

Replace the open coded arithmetic with a simple adr_l/sub pair.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/kernel/head.S | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 939543e73874..e08a4623a980 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -106,10 +106,8 @@ ENTRY(stext)
 #endif
 
 #ifndef CONFIG_XIP_KERNEL
-	adr	r3, 2f
-	ldmia	r3, {r4, r8}
-	sub	r4, r3, r4			@ (PHYS_OFFSET - PAGE_OFFSET)
-	add	r8, r8, r4			@ PHYS_OFFSET
+	adr_l	r8, _text			@ __pa(_text)
+	sub	r8, r8, #TEXT_OFFSET		@ PHYS_OFFSET
 #else
 	ldr	r8, =PLAT_PHYS_OFFSET		@ always constant in this case
 #endif
@@ -161,10 +159,6 @@ ENTRY(stext)
 1:	b	__enable_mmu
 ENDPROC(stext)
 	.ltorg
-#ifndef CONFIG_XIP_KERNEL
-2:	.long	.
-	.long	PAGE_OFFSET
-#endif
 
 /*
  * Setup the initial page tables.  We only setup the barest
-- 
2.11.0
