From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 11/15] arm-soc: mvebu: replace open coded VA->PA conversion
Date: Sat,  5 Aug 2017 21:52:18 +0100
Message-ID: <20170805205222.19868-12-ard.biesheuvel@linaro.org>
References: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53E3949C63
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:52:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NzUT6bdkSz31 for <kvmarm@lists.cs.columbia.edu>;
 Sat,  5 Aug 2017 16:52:21 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7777A49C54
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:52:21 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id t201so42450334wmt.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 05 Aug 2017 13:53:45 -0700 (PDT)
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
address of a far symbol with a call to the new ldr_l etc macro.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/mach-mvebu/coherency_ll.S | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/arm/mach-mvebu/coherency_ll.S b/arch/arm/mach-mvebu/coherency_ll.S
index 8b2fbc8b6bc6..df0ccb5cef1d 100644
--- a/arch/arm/mach-mvebu/coherency_ll.S
+++ b/arch/arm/mach-mvebu/coherency_ll.S
@@ -42,9 +42,7 @@ ENTRY(ll_get_coherency_base)
 	ldr	r1, =coherency_base
 	cmp	r1, #0
 	beq	2f
-	adr	r1, 3f
-	ldr	r3, [r1]
-	ldr	r1, [r1, r3]
+	ldr_l	r1, coherency_phys_base
 	b	2f
 1:
 	/*
@@ -160,7 +158,3 @@ ENTRY(ll_disable_coherency)
 	dsb
 	ret	lr
 ENDPROC(ll_disable_coherency)
-
-	.align 2
-3:
-	.long	coherency_phys_base - .
-- 
2.11.0
