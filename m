From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 12/15] arm-soc: omap: replace open coded VA->PA calculations
Date: Sat,  5 Aug 2017 21:52:19 +0100
Message-ID: <20170805205222.19868-13-ard.biesheuvel@linaro.org>
References: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AAC449C29
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:52:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rRnz4azu-kvr for <kvmarm@lists.cs.columbia.edu>;
 Sat,  5 Aug 2017 16:52:25 -0400 (EDT)
Received: from mail-wr0-f175.google.com (mail-wr0-f175.google.com
 [209.85.128.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0E56D49C27
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:52:24 -0400 (EDT)
Received: by mail-wr0-f175.google.com with SMTP id 33so27141023wrz.4
 for <kvmarm@lists.cs.columbia.edu>; Sat, 05 Aug 2017 13:53:49 -0700 (PDT)
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
 arch/arm/mach-omap2/sleep34xx.S | 21 ++++----------------
 arch/arm/mach-omap2/sleep44xx.S | 12 ++---------
 2 files changed, 6 insertions(+), 27 deletions(-)

diff --git a/arch/arm/mach-omap2/sleep34xx.S b/arch/arm/mach-omap2/sleep34xx.S
index 1b9f0520dea9..418a4478622d 100644
--- a/arch/arm/mach-omap2/sleep34xx.S
+++ b/arch/arm/mach-omap2/sleep34xx.S
@@ -86,9 +86,7 @@ ENTRY(enable_omap3630_toggle_l2_on_restore)
 	stmfd	sp!, {lr}	@ save registers on stack
 	/* Setup so that we will disable and enable l2 */
 	mov	r1, #0x1
-	adrl	r3, l2dis_3630_offset	@ may be too distant for plain adr
-	ldr	r2, [r3]		@ value for offset
-	str	r1, [r2, r3]		@ write to l2dis_3630
+	str_l	r1, l2dis_3630, r2	@ write to l2dis_3630
 	ldmfd	sp!, {pc}	@ restore regs and return
 ENDPROC(enable_omap3630_toggle_l2_on_restore)
 
@@ -422,9 +420,7 @@ ENTRY(omap3_restore)
 	cmp	r2, #0x0	@ Check if target power state was OFF or RET
 	bne	logic_l1_restore
 
-	adr	r1, l2dis_3630_offset	@ address for offset
-	ldr	r0, [r1]		@ value for offset
-	ldr	r0, [r1, r0]		@ value at l2dis_3630
+	ldr_l	r0, l2dis_3630	@ value at l2dis_3630
 	cmp	r0, #0x1	@ should we disable L2 on 3630?
 	bne	skipl2dis
 	mrc	p15, 0, r0, c1, c0, 1
@@ -436,9 +432,7 @@ skipl2dis:
 	and	r1, #0x700
 	cmp	r1, #0x300
 	beq	l2_inv_gp
-	adr	r0, l2_inv_api_params_offset
-	ldr	r3, [r0]
-	add	r3, r3, r0		@ r3 points to dummy parameters
+	adr_l	r3, l2_inv_api_params	@ r3 points to dummy parameters
 	mov	r0, #40			@ set service ID for PPA
 	mov	r12, r0			@ copy secure Service ID in r12
 	mov	r1, #0			@ set task id for ROM code in r1
@@ -476,9 +470,6 @@ skipl2dis:
 #endif
 	b	logic_l1_restore
 
-	.align
-l2_inv_api_params_offset:
-	.long	l2_inv_api_params - .
 l2_inv_gp:
 	/* Execute smi to invalidate L2 cache */
 	mov r12, #0x1			@ set up to invalidate L2
@@ -495,9 +486,7 @@ l2_inv_gp:
 	mov	r12, #0x2
 	smc	#0			@ Call SMI monitor (smieq)
 logic_l1_restore:
-	adr	r0, l2dis_3630_offset	@ adress for offset
-	ldr	r1, [r0]		@ value for offset
-	ldr	r1, [r0, r1]		@ value at l2dis_3630
+	ldr_l	r1, l2dis_3630		@ value at l2dis_3630
 	cmp	r1, #0x1		@ Test if L2 re-enable needed on 3630
 	bne	skipl2reen
 	mrc	p15, 0, r1, c1, c0, 1
@@ -526,8 +515,6 @@ control_stat:
 	.word	CONTROL_STAT
 control_mem_rta:
 	.word	CONTROL_MEM_RTA_CTRL
-l2dis_3630_offset:
-	.long	l2dis_3630 - .
 
 	.data
 l2dis_3630:
diff --git a/arch/arm/mach-omap2/sleep44xx.S b/arch/arm/mach-omap2/sleep44xx.S
index c7a3b4aab4b5..274fbb91f08f 100644
--- a/arch/arm/mach-omap2/sleep44xx.S
+++ b/arch/arm/mach-omap2/sleep44xx.S
@@ -260,9 +260,7 @@ ENTRY(omap4_cpu_resume)
 	beq	skip_ns_smp_enable
 ppa_actrl_retry:
 	mov     r0, #OMAP4_PPA_CPU_ACTRL_SMP_INDEX
-	adr	r1, ppa_zero_params_offset
-	ldr	r3, [r1]
-	add	r3, r3, r1			@ Pointer to ppa_zero_params
+	adr_l	r3, ppa_zero_params		@ Pointer to ppa_zero_params
 	mov	r1, #0x0			@ Process ID
 	mov	r2, #0x4			@ Flag
 	mov	r6, #0xff
@@ -299,9 +297,7 @@ skip_ns_smp_enable:
 	ldr     r0, =OMAP4_PPA_L2_POR_INDEX
 	ldr     r1, =OMAP44XX_SAR_RAM_BASE
 	ldr     r4, [r1, #L2X0_PREFETCH_CTRL_OFFSET]
-	adr     r1, ppa_por_params_offset
-	ldr	r3, [r1]
-	add	r3, r3, r1			@ Pointer to ppa_por_params
+	adr_l	r3, ppa_por_params		@ Pointer to ppa_por_params
 	str     r4, [r3, #0x04]
 	mov	r1, #0x0			@ Process ID
 	mov	r2, #0x4			@ Flag
@@ -326,8 +322,6 @@ skip_l2en:
 #endif
 
 	b	cpu_resume			@ Jump to generic resume
-ppa_por_params_offset:
-	.long	ppa_por_params - .
 ENDPROC(omap4_cpu_resume)
 #endif	/* CONFIG_ARCH_OMAP4 */
 
@@ -380,8 +374,6 @@ ENTRY(omap_do_wfi)
 	nop
 
 	ldmfd	sp!, {pc}
-ppa_zero_params_offset:
-	.long	ppa_zero_params - .
 ENDPROC(omap_do_wfi)
 
 	.data
-- 
2.11.0
