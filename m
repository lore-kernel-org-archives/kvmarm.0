From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 06/14] ARM: spectre-v2: harden branch predictor on context
 switches
Date: Wed, 16 May 2018 12:01:08 +0100
Message-ID: <E1fIuBA-0003pt-00@rmk-PC.armlinux.org.uk>
References: <20180516105949.GJ16141@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF27D4A0F4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 06:52:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FsDNoyiAl7IW for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 May 2018 06:51:52 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6930F49F88
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 06:51:20 -0400 (EDT)
In-Reply-To: <20180516105949.GJ16141@n2100.armlinux.org.uk>
Content-Disposition: inline
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Florian Fainelli <f.fainelli@gmail.com>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Harden the branch predictor against Spectre v2 attacks on context
switches for ARMv7 and later CPUs.  We do this by:

Cortex A9, A12, A17, A73, A75, R7, R8: invalidating the BTB.
Cortex A15, Brahma B15: invalidating the instruction cache.

Cortex A57 and Cortex A72 are not addressed in this patch.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 arch/arm/mm/Kconfig          |  19 +++++++
 arch/arm/mm/proc-v7-2level.S |   6 --
 arch/arm/mm/proc-v7.S        | 129 ++++++++++++++++++++++++++++++++-----------
 3 files changed, 117 insertions(+), 37 deletions(-)

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 8a5a1bb415c4..faede0401d2e 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -830,6 +830,25 @@ config CPU_BPREDICT_DISABLE
 config CPU_SPECTRE
 	bool
 
+config HARDEN_BRANCH_PREDICTOR
+	bool "Harden the branch predictor against aliasing attacks" if EXPERT
+	depends on CPU_SPECTRE
+	default y
+	help
+	   Speculation attacks against some high-performance processors rely
+	   on being able to manipulate the branch predictor for a victim
+	   context by executing aliasing branches in the attacker context.
+	   Such attacks can be partially mitigated against by clearing
+	   internal branch predictor state and limiting the prediction
+	   logic in some situations.
+
+	   This config option will take CPU-specific actions to harden
+	   the branch predictor against aliasing attacks and may rely on
+	   specific instruction sequences or control bits being set by
+	   the system firmware.
+
+	   If unsure, say Y.
+
 config TLS_REG_EMUL
 	bool
 	select NEED_KUSER_HELPERS
diff --git a/arch/arm/mm/proc-v7-2level.S b/arch/arm/mm/proc-v7-2level.S
index c6141a5435c3..f8d45ad2a515 100644
--- a/arch/arm/mm/proc-v7-2level.S
+++ b/arch/arm/mm/proc-v7-2level.S
@@ -41,11 +41,6 @@
  *	even on Cortex-A8 revisions not affected by 430973.
  *	If IBE is not set, the flush BTAC/BTB won't do anything.
  */
-ENTRY(cpu_ca8_switch_mm)
-#ifdef CONFIG_MMU
-	mov	r2, #0
-	mcr	p15, 0, r2, c7, c5, 6		@ flush BTAC/BTB
-#endif
 ENTRY(cpu_v7_switch_mm)
 #ifdef CONFIG_MMU
 	mmid	r1, r1				@ get mm->context.id
@@ -66,7 +61,6 @@ ENTRY(cpu_v7_switch_mm)
 #endif
 	bx	lr
 ENDPROC(cpu_v7_switch_mm)
-ENDPROC(cpu_ca8_switch_mm)
 
 /*
  *	cpu_v7_set_pte_ext(ptep, pte)
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index b528a15f460d..9c3d4c24f720 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -93,6 +93,17 @@ ENTRY(cpu_v7_dcache_clean_area)
 	ret	lr
 ENDPROC(cpu_v7_dcache_clean_area)
 
+ENTRY(cpu_v7_iciallu_switch_mm)
+	mov	r3, #0
+	mcr	p15, 0, r3, c7, c5, 0		@ ICIALLU
+	b	cpu_v7_switch_mm
+ENDPROC(cpu_v7_iciallu_switch_mm)
+ENTRY(cpu_v7_bpiall_switch_mm)
+	mov	r3, #0
+	mcr	p15, 0, r3, c7, c5, 6		@ flush BTAC/BTB
+	b	cpu_v7_switch_mm
+ENDPROC(cpu_v7_bpiall_switch_mm)
+
 	string	cpu_v7_name, "ARMv7 Processor"
 	.align
 
@@ -158,31 +169,6 @@ ENTRY(cpu_v7_do_resume)
 ENDPROC(cpu_v7_do_resume)
 #endif
 
-/*
- * Cortex-A8
- */
-	globl_equ	cpu_ca8_proc_init,	cpu_v7_proc_init
-	globl_equ	cpu_ca8_proc_fin,	cpu_v7_proc_fin
-	globl_equ	cpu_ca8_reset,		cpu_v7_reset
-	globl_equ	cpu_ca8_do_idle,	cpu_v7_do_idle
-	globl_equ	cpu_ca8_dcache_clean_area, cpu_v7_dcache_clean_area
-	globl_equ	cpu_ca8_set_pte_ext,	cpu_v7_set_pte_ext
-	globl_equ	cpu_ca8_suspend_size,	cpu_v7_suspend_size
-#ifdef CONFIG_ARM_CPU_SUSPEND
-	globl_equ	cpu_ca8_do_suspend,	cpu_v7_do_suspend
-	globl_equ	cpu_ca8_do_resume,	cpu_v7_do_resume
-#endif
-
-/*
- * Cortex-A9 processor functions
- */
-	globl_equ	cpu_ca9mp_proc_init,	cpu_v7_proc_init
-	globl_equ	cpu_ca9mp_proc_fin,	cpu_v7_proc_fin
-	globl_equ	cpu_ca9mp_reset,	cpu_v7_reset
-	globl_equ	cpu_ca9mp_do_idle,	cpu_v7_do_idle
-	globl_equ	cpu_ca9mp_dcache_clean_area, cpu_v7_dcache_clean_area
-	globl_equ	cpu_ca9mp_switch_mm,	cpu_v7_switch_mm
-	globl_equ	cpu_ca9mp_set_pte_ext,	cpu_v7_set_pte_ext
 .globl	cpu_ca9mp_suspend_size
 .equ	cpu_ca9mp_suspend_size, cpu_v7_suspend_size + 4 * 2
 #ifdef CONFIG_ARM_CPU_SUSPEND
@@ -549,10 +535,75 @@ ENDPROC(__v7_setup)
 
 	@ define struct processor (see <asm/proc-fns.h> and proc-macros.S)
 	define_processor_functions v7, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
+
+#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
+	@ generic v7 bpiall on context switch
+	globl_equ	cpu_v7_bpiall_proc_init,	cpu_v7_proc_init
+	globl_equ	cpu_v7_bpiall_proc_fin,		cpu_v7_proc_fin
+	globl_equ	cpu_v7_bpiall_reset,		cpu_v7_reset
+	globl_equ	cpu_v7_bpiall_do_idle,		cpu_v7_do_idle
+	globl_equ	cpu_v7_bpiall_dcache_clean_area, cpu_v7_dcache_clean_area
+	globl_equ	cpu_v7_bpiall_set_pte_ext,	cpu_v7_set_pte_ext
+	globl_equ	cpu_v7_bpiall_suspend_size,	cpu_v7_suspend_size
+#ifdef CONFIG_ARM_CPU_SUSPEND
+	globl_equ	cpu_v7_bpiall_do_suspend,	cpu_v7_do_suspend
+	globl_equ	cpu_v7_bpiall_do_resume,	cpu_v7_do_resume
+#endif
+	define_processor_functions v7_bpiall, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
+
+#define HARDENED_BPIALL_PROCESSOR_FUNCTIONS v7_bpiall_processor_functions
+#else
+#define HARDENED_BPIALL_PROCESSOR_FUNCTIONS v7_processor_functions
+#endif
+
 #ifndef CONFIG_ARM_LPAE
+	@ Cortex-A8 - always needs bpiall switch_mm implementation
+	globl_equ	cpu_ca8_proc_init,	cpu_v7_proc_init
+	globl_equ	cpu_ca8_proc_fin,	cpu_v7_proc_fin
+	globl_equ	cpu_ca8_reset,		cpu_v7_reset
+	globl_equ	cpu_ca8_do_idle,	cpu_v7_do_idle
+	globl_equ	cpu_ca8_dcache_clean_area, cpu_v7_dcache_clean_area
+	globl_equ	cpu_ca8_set_pte_ext,	cpu_v7_set_pte_ext
+	globl_equ	cpu_ca8_switch_mm,	cpu_v7_bpiall_switch_mm
+	globl_equ	cpu_ca8_suspend_size,	cpu_v7_suspend_size
+#ifdef CONFIG_ARM_CPU_SUSPEND
+	globl_equ	cpu_ca8_do_suspend,	cpu_v7_do_suspend
+	globl_equ	cpu_ca8_do_resume,	cpu_v7_do_resume
+#endif
 	define_processor_functions ca8, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
+
+	@ Cortex-A9 - needs more registers preserved across suspend/resume
+	@ and bpiall switch_mm for hardening
+	globl_equ	cpu_ca9mp_proc_init,	cpu_v7_proc_init
+	globl_equ	cpu_ca9mp_proc_fin,	cpu_v7_proc_fin
+	globl_equ	cpu_ca9mp_reset,	cpu_v7_reset
+	globl_equ	cpu_ca9mp_do_idle,	cpu_v7_do_idle
+	globl_equ	cpu_ca9mp_dcache_clean_area, cpu_v7_dcache_clean_area
+#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
+	globl_equ	cpu_ca9mp_switch_mm,	cpu_v7_bpiall_switch_mm
+#else
+	globl_equ	cpu_ca9mp_switch_mm,	cpu_v7_switch_mm
+#endif
+	globl_equ	cpu_ca9mp_set_pte_ext,	cpu_v7_set_pte_ext
 	define_processor_functions ca9mp, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
 #endif
+
+	@ Cortex-A15 - needs iciallu switch_mm for hardening
+	globl_equ	cpu_ca15_proc_init,	cpu_v7_proc_init
+	globl_equ	cpu_ca15_proc_fin,	cpu_v7_proc_fin
+	globl_equ	cpu_ca15_reset,		cpu_v7_reset
+	globl_equ	cpu_ca15_do_idle,	cpu_v7_do_idle
+	globl_equ	cpu_ca15_dcache_clean_area, cpu_v7_dcache_clean_area
+#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
+	globl_equ	cpu_ca15_switch_mm,	cpu_v7_iciallu_switch_mm
+#else
+	globl_equ	cpu_ca15_switch_mm,	cpu_v7_switch_mm
+#endif
+	globl_equ	cpu_ca15_set_pte_ext,	cpu_v7_set_pte_ext
+	globl_equ	cpu_ca15_suspend_size,	cpu_v7_suspend_size
+	globl_equ	cpu_ca15_do_suspend,	cpu_v7_do_suspend
+	globl_equ	cpu_ca15_do_resume,	cpu_v7_do_resume
+	define_processor_functions ca15, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
 #ifdef CONFIG_CPU_PJ4B
 	define_processor_functions pj4b, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
 #endif
@@ -639,7 +690,7 @@ ENDPROC(__v7_setup)
 __v7_cr7mp_proc_info:
 	.long	0x410fc170
 	.long	0xff0ffff0
-	__v7_proc __v7_cr7mp_proc_info, __v7_cr7mp_setup
+	__v7_proc __v7_cr7mp_proc_info, __v7_cr7mp_setup, proc_fns = HARDENED_BPIALL_PROCESSOR_FUNCTIONS
 	.size	__v7_cr7mp_proc_info, . - __v7_cr7mp_proc_info
 
 	/*
@@ -649,7 +700,7 @@ ENDPROC(__v7_setup)
 __v7_cr8mp_proc_info:
 	.long	0x410fc180
 	.long	0xff0ffff0
-	__v7_proc __v7_cr8mp_proc_info, __v7_cr8mp_setup
+	__v7_proc __v7_cr8mp_proc_info, __v7_cr8mp_setup, proc_fns = HARDENED_BPIALL_PROCESSOR_FUNCTIONS
 	.size	__v7_cr8mp_proc_info, . - __v7_cr8mp_proc_info
 
 	/*
@@ -669,7 +720,7 @@ ENDPROC(__v7_setup)
 __v7_ca12mp_proc_info:
 	.long	0x410fc0d0
 	.long	0xff0ffff0
-	__v7_proc __v7_ca12mp_proc_info, __v7_ca12mp_setup
+	__v7_proc __v7_ca12mp_proc_info, __v7_ca12mp_setup, proc_fns = HARDENED_BPIALL_PROCESSOR_FUNCTIONS
 	.size	__v7_ca12mp_proc_info, . - __v7_ca12mp_proc_info
 
 	/*
@@ -679,7 +730,7 @@ ENDPROC(__v7_setup)
 __v7_ca15mp_proc_info:
 	.long	0x410fc0f0
 	.long	0xff0ffff0
-	__v7_proc __v7_ca15mp_proc_info, __v7_ca15mp_setup
+	__v7_proc __v7_ca15mp_proc_info, __v7_ca15mp_setup, proc_fns = ca15_processor_functions
 	.size	__v7_ca15mp_proc_info, . - __v7_ca15mp_proc_info
 
 	/*
@@ -689,7 +740,7 @@ ENDPROC(__v7_setup)
 __v7_b15mp_proc_info:
 	.long	0x420f00f0
 	.long	0xff0ffff0
-	__v7_proc __v7_b15mp_proc_info, __v7_b15mp_setup, cache_fns = b15_cache_fns
+	__v7_proc __v7_b15mp_proc_info, __v7_b15mp_setup, proc_fns = ca15_processor_functions, cache_fns = b15_cache_fns
 	.size	__v7_b15mp_proc_info, . - __v7_b15mp_proc_info
 
 	/*
@@ -699,9 +750,25 @@ ENDPROC(__v7_setup)
 __v7_ca17mp_proc_info:
 	.long	0x410fc0e0
 	.long	0xff0ffff0
-	__v7_proc __v7_ca17mp_proc_info, __v7_ca17mp_setup
+	__v7_proc __v7_ca17mp_proc_info, __v7_ca17mp_setup, proc_fns = HARDENED_BPIALL_PROCESSOR_FUNCTIONS
 	.size	__v7_ca17mp_proc_info, . - __v7_ca17mp_proc_info
 
+	/* ARM Ltd. Cortex A73 processor */
+	.type	__v7_ca73_proc_info, #object
+__v7_ca73_proc_info:
+	.long	0x410fd090
+	.long	0xff0ffff0
+	__v7_proc __v7_ca73_proc_info, __v7_setup, proc_fns = HARDENED_BPIALL_PROCESSOR_FUNCTIONS
+	.size	__v7_ca73_proc_info, . - __v7_ca73_proc_info
+
+	/* ARM Ltd. Cortex A75 processor */
+	.type	__v7_ca75_proc_info, #object
+__v7_ca75_proc_info:
+	.long	0x410fd0a0
+	.long	0xff0ffff0
+	__v7_proc __v7_ca75_proc_info, __v7_setup, proc_fns = HARDENED_BPIALL_PROCESSOR_FUNCTIONS
+	.size	__v7_ca75_proc_info, . - __v7_ca75_proc_info
+
 	/*
 	 * Qualcomm Inc. Krait processors.
 	 */
-- 
2.7.4
