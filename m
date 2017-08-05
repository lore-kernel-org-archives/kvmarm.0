From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 09/15] ARM: kvm: replace open coded VA->PA calculations with
 adr_l call
Date: Sat,  5 Aug 2017 21:52:16 +0100
Message-ID: <20170805205222.19868-10-ard.biesheuvel@linaro.org>
References: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11E7E49C3F
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:52:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6BYveoy9YLCg for <kvmarm@lists.cs.columbia.edu>;
 Sat,  5 Aug 2017 16:52:15 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E8A2949C27
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:52:14 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id m85so42571705wma.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 05 Aug 2017 13:53:39 -0700 (PDT)
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

Replace the open coded calculations of the actual physical address
of the KVM stub vector table with a single adr_l invocation.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/boot/compressed/head.S | 15 ++-------
 arch/arm/kernel/hyp-stub.S      | 33 +++++++-------------
 arch/arm/kvm/init.S             |  8 +----
 3 files changed, 15 insertions(+), 41 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 8a756870c238..5884e8151376 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -427,15 +427,10 @@ dtb_check_done:
 
 		/*
 		 * Compute the address of the hyp vectors after relocation.
-		 * This requires some arithmetic since we cannot directly
-		 * reference __hyp_stub_vectors in a PC-relative way.
 		 * Call __hyp_set_vectors with the new address so that we
 		 * can HVC again after the copy.
 		 */
-0:		adr	r0, 0b
-		movw	r1, #:lower16:__hyp_stub_vectors - 0b
-		movt	r1, #:upper16:__hyp_stub_vectors - 0b
-		add	r0, r0, r1
+		adr_l	r0, __hyp_stub_vectors
 		sub	r0, r0, r5
 		add	r0, r0, r10
 		bl	__hyp_set_vectors
@@ -568,17 +563,11 @@ not_relocated:	mov	r0, #0
 		cmp	r0, #HYP_MODE		@ if not booted in HYP mode...
 		bne	__enter_kernel		@ boot kernel directly
 
-		adr	r12, .L__hyp_reentry_vectors_offset
-		ldr	r0, [r12]
-		add	r0, r0, r12
-
+		adr_l	r0, __hyp_reentry_vectors
 		bl	__hyp_set_vectors
 		__HVC(0)			@ otherwise bounce to hyp mode
 
 		b	.			@ should never be reached
-
-		.align	2
-.L__hyp_reentry_vectors_offset:	.long	__hyp_reentry_vectors - .
 #else
 		b	__enter_kernel
 #endif
diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
index ec7e7377d423..55b5fab83861 100644
--- a/arch/arm/kernel/hyp-stub.S
+++ b/arch/arm/kernel/hyp-stub.S
@@ -36,41 +36,38 @@ ENTRY(__boot_cpu_mode)
 .text
 
 	/*
-	 * Save the primary CPU boot mode. Requires 3 scratch registers.
+	 * Save the primary CPU boot mode. Requires 2 scratch registers.
 	 */
-	.macro	store_primary_cpu_mode	reg1, reg2, reg3
+	.macro	store_primary_cpu_mode	reg1, reg2
 	mrs	\reg1, cpsr
 	and	\reg1, \reg1, #MODE_MASK
-	adr	\reg2, .L__boot_cpu_mode_offset
-	ldr	\reg3, [\reg2]
-	str	\reg1, [\reg2, \reg3]
+	str_l	\reg1, __boot_cpu_mode, \reg2
 	.endm
 
 	/*
 	 * Compare the current mode with the one saved on the primary CPU.
 	 * If they don't match, record that fact. The Z bit indicates
 	 * if there's a match or not.
-	 * Requires 3 additionnal scratch registers.
+	 * Requires 2 additionnal scratch registers.
 	 */
-	.macro	compare_cpu_mode_with_primary mode, reg1, reg2, reg3
-	adr	\reg2, .L__boot_cpu_mode_offset
-	ldr	\reg3, [\reg2]
-	ldr	\reg1, [\reg2, \reg3]
+	.macro	compare_cpu_mode_with_primary mode, reg1, reg2
+	adr_l	\reg2, __boot_cpu_mode
+	ldr	\reg1, [\reg2]
 	cmp	\mode, \reg1		@ matches primary CPU boot mode?
 	orrne	\reg1, \reg1, #BOOT_CPU_MODE_MISMATCH
-	strne	\reg1, [\reg2, \reg3]	@ record what happened and give up
+	strne	\reg1, [\reg2]		@ record what happened and give up
 	.endm
 
 #else	/* ZIMAGE */
 
-	.macro	store_primary_cpu_mode	reg1:req, reg2:req, reg3:req
+	.macro	store_primary_cpu_mode	reg1:req, reg2:req
 	.endm
 
 /*
  * The zImage loader only runs on one CPU, so we don't bother with mult-CPU
  * consistency checking:
  */
-	.macro	compare_cpu_mode_with_primary mode, reg1, reg2, reg3
+	.macro	compare_cpu_mode_with_primary mode, reg1, reg2
 	cmp	\mode, \mode
 	.endm
 
@@ -85,7 +82,7 @@ ENTRY(__boot_cpu_mode)
  */
 @ Call this from the primary CPU
 ENTRY(__hyp_stub_install)
-	store_primary_cpu_mode	r4, r5, r6
+	store_primary_cpu_mode	r4, r5
 ENDPROC(__hyp_stub_install)
 
 	@ fall through...
@@ -99,7 +96,7 @@ ENTRY(__hyp_stub_install_secondary)
 	 * If the secondary has booted with a different mode, give up
 	 * immediately.
 	 */
-	compare_cpu_mode_with_primary	r4, r5, r6, r7
+	compare_cpu_mode_with_primary	r4, r5, r6
 	retne	lr
 
 	/*
@@ -264,12 +261,6 @@ ENTRY(__hyp_reset_vectors)
 	ret	lr
 ENDPROC(__hyp_reset_vectors)
 
-#ifndef ZIMAGE
-.align 2
-.L__boot_cpu_mode_offset:
-	.long	__boot_cpu_mode - .
-#endif
-
 .align 5
 ENTRY(__hyp_stub_vectors)
 __hyp_stub_reset:	W(b)	.
diff --git a/arch/arm/kvm/init.S b/arch/arm/kvm/init.S
index 5386528665b5..d777c6fbd869 100644
--- a/arch/arm/kvm/init.S
+++ b/arch/arm/kvm/init.S
@@ -143,13 +143,7 @@ reset:
 	bic	r1, r1, r0
 	mcr	p15, 4, r1, c1, c0, 0	@ HSCTLR
 
-	/*
-	 * Install stub vectors, using ardb's VA->PA trick.
-	 */
-0:	adr	r0, 0b					@ PA(0)
-	movw	r1, #:lower16:__hyp_stub_vectors - 0b   @ VA(stub) - VA(0)
-	movt	r1, #:upper16:__hyp_stub_vectors - 0b
-	add	r1, r1, r0				@ PA(stub)
+	adr_l	r1, __hyp_stub_vectors			@ PA(stub)
 	mcr	p15, 4, r1, c12, c0, 0	@ HVBAR
 	b	exit
 
-- 
2.11.0
