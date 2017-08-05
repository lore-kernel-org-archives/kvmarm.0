From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 05/15] ARM: head: use PC-relative insn sequence for __smp_alt
Date: Sat,  5 Aug 2017 21:52:12 +0100
Message-ID: <20170805205222.19868-6-ard.biesheuvel@linaro.org>
References: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62F2A49C63
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:52:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w3+nStmMgh6c for <kvmarm@lists.cs.columbia.edu>;
 Sat,  5 Aug 2017 16:52:00 -0400 (EDT)
Received: from mail-wr0-f182.google.com (mail-wr0-f182.google.com
 [209.85.128.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 825CF49C2F
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:52:00 -0400 (EDT)
Received: by mail-wr0-f182.google.com with SMTP id v105so27163383wrb.0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 05 Aug 2017 13:53:24 -0700 (PDT)
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

Replace the open coded PC relative offset calculations with a pair
of adr_l invocations.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/kernel/head.S | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 6e9df3663a57..aed341e0f530 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -523,19 +523,11 @@ ARM_BE8(rev	r0, r0)			@ byteswap if big endian
 	retne	lr
 
 __fixup_smp_on_up:
-	adr	r0, 1f
-	ldmia	r0, {r3 - r5}
-	sub	r3, r0, r3
-	add	r4, r4, r3
-	add	r5, r5, r3
+	adr_l	r4, __smpalt_begin
+	adr_l	r5, __smpalt_end
 	b	__do_fixup_smp_on_up
 ENDPROC(__fixup_smp)
 
-	.align
-1:	.word	.
-	.word	__smpalt_begin
-	.word	__smpalt_end
-
 	.pushsection .data
 	.globl	smp_on_up
 smp_on_up:
-- 
2.11.0
