From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 04/15] ARM: head.S: use PC-relative insn sequence for
 secondary_data
Date: Sat,  5 Aug 2017 21:52:11 +0100
Message-ID: <20170805205222.19868-5-ard.biesheuvel@linaro.org>
References: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0622749C27
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:51:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Tr6bLeboTTdf for <kvmarm@lists.cs.columbia.edu>;
 Sat,  5 Aug 2017 16:51:57 -0400 (EDT)
Received: from mail-wr0-f170.google.com (mail-wr0-f170.google.com
 [209.85.128.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 29CFB49C18
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:51:57 -0400 (EDT)
Received: by mail-wr0-f170.google.com with SMTP id 12so27171840wrb.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 05 Aug 2017 13:53:21 -0700 (PDT)
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

Replace the open coded PC relative offset calculations with adr_l
and ldr_l invocations.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/kernel/head.S | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 0a98aec0e39d..6e9df3663a57 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -386,10 +386,8 @@ ENTRY(secondary_startup)
 	/*
 	 * Use the page tables supplied from  __cpu_up.
 	 */
-	adr	r4, __secondary_data
-	ldmia	r4, {r5, r7, r12}		@ address to jump to after
-	sub	lr, r4, r5			@ mmu has been enabled
-	add	r3, r7, lr
+	adr_l	r3, secondary_data
+	mov_l	r12, __secondary_switched
 	ldrd	r4, [r3, #0]			@ get secondary_data.pgdir
 ARM_BE8(eor	r4, r4, r5)			@ Swap r5 and r4 in BE:
 ARM_BE8(eor	r5, r4, r5)			@ it can be done in 3 steps
@@ -404,22 +402,13 @@ ARM_BE8(eor	r4, r4, r5)			@ without using a temp reg.
 ENDPROC(secondary_startup)
 ENDPROC(secondary_startup_arm)
 
-	/*
-	 * r6  = &secondary_data
-	 */
 ENTRY(__secondary_switched)
-	ldr	sp, [r7, #12]			@ get secondary_data.stack
+	ldr_l	r7, secondary_data + 12		@ get secondary_data.stack
+	mov	sp, r7
 	mov	fp, #0
 	b	secondary_start_kernel
 ENDPROC(__secondary_switched)
 
-	.align
-
-	.type	__secondary_data, %object
-__secondary_data:
-	.long	.
-	.long	secondary_data
-	.long	__secondary_switched
 #endif /* defined(CONFIG_SMP) */
 
 
-- 
2.11.0
