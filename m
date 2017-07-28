From: James Morse <james.morse@arm.com>
Subject: [PATCH v2 03/16] arm64: unmask all exceptions from C code on CPU
 startup
Date: Fri, 28 Jul 2017 15:10:06 +0100
Message-ID: <20170728141019.9084-4-james.morse@arm.com>
References: <20170728141019.9084-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B594249C22
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jul 2017 10:10:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XRe9mpw1eoZf for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Jul 2017 10:10:37 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 683E849C24
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jul 2017 10:10:36 -0400 (EDT)
In-Reply-To: <20170728141019.9084-1-james.morse@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Wang Xiongfeng <wangxiongfeng2@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On startup (and before any C code) __cpu_setup() resets the debug
configuration register MDSCR_EL1 to disable MDE and KDE, it then umasks
Debug exceptions.

On first boot, once we get into the setup.c on CPU0, we unmask SError.
IRQs are unmasked some time later by core code. FIQ is only unmasked
when we enter user-spce.
On secondary CPUs the __cpu_setup() code unmasks Debug exceptions early,
(cpuidle then has to mask them when it restores MDSCR_EL1), smp.c then
unmasks SError and Interrupts.

Move the Debug unmask into {setup,smp}.c to preserve our expected
priority order: SError should be unmasked before Debug and we can't
unmask SError until we have the earlycon available.

The same goes for secondary CPUs only here we are ready to receive
interrupts. Just unmask everything.

Remove the local_fiq_{en,dis}able macros as they don't respect our newly
defined order, and don't have any users.

This patch removes the isb that synchronized the MDSCR_el1 write in
__cpu_setup() with the PSTATE.D write. Now the PSTATE.D write happens
after __enable_mmu().

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/irqflags.h |  6 ------
 arch/arm64/kernel/setup.c         |  7 ++++---
 arch/arm64/kernel/smp.c           |  4 ++--
 arch/arm64/mm/proc.S              | 12 +-----------
 4 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/irqflags.h b/arch/arm64/include/asm/irqflags.h
index 6904f2247394..df61dcbce22e 100644
--- a/arch/arm64/include/asm/irqflags.h
+++ b/arch/arm64/include/asm/irqflags.h
@@ -67,12 +67,6 @@ static inline void arch_local_irq_disable(void)
 		: "memory");
 }
 
-#define local_fiq_enable()	asm("msr	daifclr, #1" : : : "memory")
-#define local_fiq_disable()	asm("msr	daifset, #1" : : : "memory")
-
-#define local_async_enable()	asm("msr	daifclr, #4" : : : "memory")
-#define local_async_disable()	asm("msr	daifset, #4" : : : "memory")
-
 /*
  * Save the current interrupt enable state.
  */
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index d4b740538ad5..133735cede73 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -262,10 +262,11 @@ void __init setup_arch(char **cmdline_p)
 	parse_early_param();
 
 	/*
-	 *  Unmask asynchronous aborts after bringing up possible earlycon.
-	 * (Report possible System Errors once we can report this occurred)
+	 * Unmask asynchronous aborts, debug and fiq exceptions after bringing
+	 * up possible earlycon. (Report possible System Errors once we can
+	 * report this occurred).
 	 */
-	local_async_enable();
+	local_restore_daif(PSR_I_BIT);
 
 	/*
 	 * TTBR0 is only used for the identity mapping at this stage. Make it
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index cb2e5dd0f429..ccd63681c327 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -271,8 +271,8 @@ asmlinkage void secondary_start_kernel(void)
 	set_cpu_online(cpu, true);
 	complete(&cpu_running);
 
-	local_irq_enable();
-	local_async_enable();
+	trace_hardirqs_on();
+	local_unmask_daif();
 
 	/*
 	 * OK, it's off to the idle thread for us
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 95233dfc4c39..9b18ef0c8ae0 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -83,6 +83,7 @@ ENDPROC(cpu_do_suspend)
 
 /**
  * cpu_do_resume - restore CPU register context
+ * Call with debug exceptions masked
  *
  * x0: Address of context pointer
  */
@@ -105,16 +106,7 @@ ENTRY(cpu_do_resume)
 
 	msr	tcr_el1, x8
 	msr	vbar_el1, x9
-
-	/*
-	 * __cpu_setup() cleared MDSCR_EL1.MDE and friends, before unmasking
-	 * debug exceptions. By restoring MDSCR_EL1 here, we may take a debug
-	 * exception. Mask them until local_daif_restore() in cpu_suspend()
-	 * resets them.
-	 */
-	disable_daif
 	msr	mdscr_el1, x10
-
 	msr	sctlr_el1, x12
 	msr	tpidr_el1, x13
 	msr	sp_el0, x14
@@ -189,8 +181,6 @@ ENTRY(__cpu_setup)
 	msr	cpacr_el1, x0			// Enable FP/ASIMD
 	mov	x0, #1 << 12			// Reset mdscr_el1 and disable
 	msr	mdscr_el1, x0			// access to the DCC from EL0
-	isb					// Unmask debug exceptions now,
-	enable_dbg				// since this is per-cpu
 	reset_pmuserenr_el0 x0			// Disable PMU access from EL0
 	/*
 	 * Memory region attributes for LPAE:
-- 
2.13.2
