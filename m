From: James Morse <james.morse@arm.com>
Subject: [PATCH v2 01/16] arm64: explicitly mask all exceptions
Date: Fri, 28 Jul 2017 15:10:04 +0100
Message-ID: <20170728141019.9084-2-james.morse@arm.com>
References: <20170728141019.9084-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B4F640D1D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jul 2017 10:10:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 41ENLEDZh1o0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Jul 2017 10:10:31 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93D3340FA5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jul 2017 10:10:31 -0400 (EDT)
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

There are a few places where we want to mask all exceptions. Today we
do this in a piecemeal fashion, typically we expect the caller to
have masked irqs and the arch code masks debug exceptions, ignoring
serror which is probably masked.

Make it clear that 'mask all exceptions' is the intention by adding
helpers to do exactly that.

The caller should update trace_hardirqs where appropriate, adding this
logic to the mask/unmask helpers causes asm/irqflags.h and
linux/irqflag.h to include each other.

Signed-off-by: James Morse <james.morse@arm.com>
---
Remove the 'disable IRQs' comment above cpu_die(), nothing returns via
this path, cpu's are resurrected via kernel/smp.c's
secondary_start_kernel().

 arch/arm64/include/asm/assembler.h | 19 +++++++++++++++++++
 arch/arm64/include/asm/irqflags.h  | 34 ++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/hibernate.c      |  4 ++--
 arch/arm64/kernel/machine_kexec.c  |  3 +--
 arch/arm64/kernel/smp.c            |  8 ++------
 arch/arm64/kernel/suspend.c        |  6 +++---
 arch/arm64/kernel/traps.c          |  2 +-
 arch/arm64/mm/proc.S               |  9 ++++-----
 8 files changed, 66 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 1b67c3782d00..896ddd9b21a6 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -31,6 +31,25 @@
 #include <asm/ptrace.h>
 #include <asm/thread_info.h>
 
+	.macro save_and_disable_daif, flags
+	.ifnb	\flags
+	mrs	\flags, daif
+	.endif
+	msr	daifset, #0xf
+	.endm
+
+	.macro disable_daif
+	msr	daifset, #0xf
+	.endm
+
+	.macro enable_daif
+	msr	daifclr, #0xf
+	.endm
+
+	.macro	restore_daif, flags:req
+	msr	daif, \flags
+	.endm
+
 /*
  * Enable and disable interrupts.
  */
diff --git a/arch/arm64/include/asm/irqflags.h b/arch/arm64/include/asm/irqflags.h
index 8c581281fa12..578d14f376ce 100644
--- a/arch/arm64/include/asm/irqflags.h
+++ b/arch/arm64/include/asm/irqflags.h
@@ -110,5 +110,39 @@ static inline int arch_irqs_disabled_flags(unsigned long flags)
 		: : "r" (flags) : "memory");				\
 	} while (0)
 
+/*
+ * Mask/unmask/restore all exceptions, including interrupts. If the I bit
+ * is modified the caller should call trace_hardirqs_{on,off}().
+ */
+static inline unsigned long local_mask_daif(void)
+{
+	unsigned long flags;
+
+	asm volatile(
+		"mrs	%0, daif		// local_mask_daif\n"
+		"msr	daifset, #0xf"
+		: "=r" (flags)
+		:
+		: "memory");
+	return flags;
+}
+
+static inline void local_unmask_daif(void)
+{
+	asm volatile(
+		"msr	daifclr, #0xf		// local_unmask_daif"
+		:
+		:
+		: "memory");
+}
+
+static inline void local_restore_daif(unsigned long flags)
+{
+	asm volatile(
+		"msr	daif, %0		// local_restore_daif"
+		:
+		: "r" (flags)
+		: "memory");
+}
 #endif
 #endif
diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index a44e13942d30..e29f85938ef5 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -285,7 +285,7 @@ int swsusp_arch_suspend(void)
 		return -EBUSY;
 	}
 
-	local_dbg_save(flags);
+	flags = local_mask_daif();
 
 	if (__cpu_suspend_enter(&state)) {
 		/* make the crash dump kernel image visible/saveable */
@@ -315,7 +315,7 @@ int swsusp_arch_suspend(void)
 		__cpu_suspend_exit();
 	}
 
-	local_dbg_restore(flags);
+	local_restore_daif(flags);
 
 	return ret;
 }
diff --git a/arch/arm64/kernel/machine_kexec.c b/arch/arm64/kernel/machine_kexec.c
index 481f54a866c5..24e0df967400 100644
--- a/arch/arm64/kernel/machine_kexec.c
+++ b/arch/arm64/kernel/machine_kexec.c
@@ -195,8 +195,7 @@ void machine_kexec(struct kimage *kimage)
 
 	pr_info("Bye!\n");
 
-	/* Disable all DAIF exceptions. */
-	asm volatile ("msr daifset, #0xf" : : : "memory");
+	local_mask_daif();
 
 	/*
 	 * cpu_soft_restart will shutdown the MMU, disable data caches, then
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 321119881abf..cb2e5dd0f429 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -368,10 +368,6 @@ void __cpu_die(unsigned int cpu)
 /*
  * Called from the idle thread for the CPU which has been shutdown.
  *
- * Note that we disable IRQs here, but do not re-enable them
- * before returning to the caller. This is also the behaviour
- * of the other hotplug-cpu capable cores, so presumably coming
- * out of idle fixes this.
  */
 void cpu_die(void)
 {
@@ -379,7 +375,7 @@ void cpu_die(void)
 
 	idle_task_exit();
 
-	local_irq_disable();
+	local_mask_daif();
 
 	/* Tell __cpu_die() that this CPU is now safe to dispose of */
 	(void)cpu_report_death();
@@ -837,7 +833,7 @@ static void ipi_cpu_stop(unsigned int cpu)
 {
 	set_cpu_online(cpu, false);
 
-	local_irq_disable();
+	local_mask_daif();
 
 	while (1)
 		cpu_relax();
diff --git a/arch/arm64/kernel/suspend.c b/arch/arm64/kernel/suspend.c
index 1e3be9064cfa..d135c70dec97 100644
--- a/arch/arm64/kernel/suspend.c
+++ b/arch/arm64/kernel/suspend.c
@@ -57,7 +57,7 @@ void notrace __cpu_suspend_exit(void)
 	/*
 	 * Restore HW breakpoint registers to sane values
 	 * before debug exceptions are possibly reenabled
-	 * through local_dbg_restore.
+	 * by cpu_suspend()s local_daif_restore() call.
 	 */
 	if (hw_breakpoint_restore)
 		hw_breakpoint_restore(cpu);
@@ -81,7 +81,7 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
 	 * updates to mdscr register (saved and restored along with
 	 * general purpose registers) from kernel debuggers.
 	 */
-	local_dbg_save(flags);
+	flags = local_mask_daif();
 
 	/*
 	 * Function graph tracer state gets incosistent when the kernel
@@ -114,7 +114,7 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
 	 * restored, so from this point onwards, debugging is fully
 	 * renabled if it was enabled when core started shutdown.
 	 */
-	local_dbg_restore(flags);
+	local_restore_daif(flags);
 
 	return ret;
 }
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index c7c7088097be..59efec10be15 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -656,7 +656,7 @@ asmlinkage void bad_mode(struct pt_regs *regs, int reason, unsigned int esr)
 		esr_get_class_string(esr));
 
 	die("Oops - bad mode", regs, 0);
-	local_irq_disable();
+	local_mask_daif();
 	panic("bad mode");
 }
 
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 877d42fb0df6..95233dfc4c39 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -109,10 +109,10 @@ ENTRY(cpu_do_resume)
 	/*
 	 * __cpu_setup() cleared MDSCR_EL1.MDE and friends, before unmasking
 	 * debug exceptions. By restoring MDSCR_EL1 here, we may take a debug
-	 * exception. Mask them until local_dbg_restore() in cpu_suspend()
+	 * exception. Mask them until local_daif_restore() in cpu_suspend()
 	 * resets them.
 	 */
-	disable_dbg
+	disable_daif
 	msr	mdscr_el1, x10
 
 	msr	sctlr_el1, x12
@@ -155,8 +155,7 @@ ENDPROC(cpu_do_switch_mm)
  * called by anything else. It can only be executed from a TTBR0 mapping.
  */
 ENTRY(idmap_cpu_replace_ttbr1)
-	mrs	x2, daif
-	msr	daifset, #0xf
+	save_and_disable_daif flags=x2
 
 	adrp	x1, empty_zero_page
 	msr	ttbr1_el1, x1
@@ -169,7 +168,7 @@ ENTRY(idmap_cpu_replace_ttbr1)
 	msr	ttbr1_el1, x0
 	isb
 
-	msr	daif, x2
+	restore_daif x2
 
 	ret
 ENDPROC(idmap_cpu_replace_ttbr1)
-- 
2.13.2
