From: James Morse <james.morse@arm.com>
Subject: [PATCH v4 01/21] arm64: explicitly mask all exceptions
Date: Thu, 19 Oct 2017 15:57:47 +0100
Message-ID: <20171019145807.23251-2-james.morse@arm.com>
References: <20171019145807.23251-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DDD0406BB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Oct 2017 10:58:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z4ysR3y3kOVM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Oct 2017 10:58:52 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7A1749D1F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Oct 2017 10:58:51 -0400 (EDT)
In-Reply-To: <20171019145807.23251-1-james.morse@arm.com>
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
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

There are a few places where we want to mask all exceptions. Today we
do this in a piecemeal fashion, typically we expect the caller to
have masked irqs and the arch code masks debug exceptions, ignoring
serror which is probably masked.

Make it clear that 'mask all exceptions' is the intention by adding
helpers to do exactly that.

This will let us unmask SError without having to add 'oh and SError'
to these paths.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

---
Remove the disable IRQs comment above cpu_die(): we return from idle via
cpu_resume. This comment is confusing once the local_irq_disable() call
is changed.

Changes since v3:
 * Split local_mask_daif into a save and mask versions,
 * swapped verb/daif word-order.
 * Removed {asm,linux} includes - one will always include the other

 arch/arm64/include/asm/assembler.h | 17 ++++++++++
 arch/arm64/include/asm/daifflags.h | 69 ++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/hibernate.c      |  5 +--
 arch/arm64/kernel/machine_kexec.c  |  4 +--
 arch/arm64/kernel/smp.c            |  9 ++---
 arch/arm64/kernel/suspend.c        |  7 ++--
 arch/arm64/kernel/traps.c          |  3 +-
 arch/arm64/mm/proc.S               |  9 +++--
 8 files changed, 104 insertions(+), 19 deletions(-)
 create mode 100644 arch/arm64/include/asm/daifflags.h

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index d58a6253c6ab..114e741ca873 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -31,6 +31,23 @@
 #include <asm/ptrace.h>
 #include <asm/thread_info.h>
 
+	.macro save_and_disable_daif, flags
+	mrs	\flags, daif
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
diff --git a/arch/arm64/include/asm/daifflags.h b/arch/arm64/include/asm/daifflags.h
new file mode 100644
index 000000000000..55e2598a8c4c
--- /dev/null
+++ b/arch/arm64/include/asm/daifflags.h
@@ -0,0 +1,69 @@
+/*
+ * Copyright (C) 2017 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_DAIFFLAGS_H
+#define __ASM_DAIFFLAGS_H
+
+#include <linux/irqflags.h>
+
+/* mask/save/unmask/restore all exceptions, including interrupts. */
+static inline void local_daif_mask(void)
+{
+	asm volatile(
+		"msr	daifset, #0xf		// local_daif_mask\n"
+		:
+		:
+		: "memory");
+	trace_hardirqs_off();
+}
+
+static inline unsigned long local_daif_save(void)
+{
+	unsigned long flags;
+
+	asm volatile(
+		"mrs	%0, daif		// local_daif_save\n"
+		: "=r" (flags)
+		:
+		: "memory");
+	local_daif_mask();
+
+	return flags;
+}
+
+static inline void local_daif_unmask(void)
+{
+	trace_hardirqs_on();
+	asm volatile(
+		"msr	daifclr, #0xf		// local_daif_unmask"
+		:
+		:
+		: "memory");
+}
+
+static inline void local_daif_restore(unsigned long flags)
+{
+	if (!arch_irqs_disabled_flags(flags))
+		trace_hardirqs_on();
+	asm volatile(
+		"msr	daif, %0		// local_daif_restore"
+		:
+		: "r" (flags)
+		: "memory");
+	if (arch_irqs_disabled_flags(flags))
+		trace_hardirqs_off();
+}
+
+#endif
diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index 095d3c170f5d..3009b8b80f08 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -27,6 +27,7 @@
 #include <asm/barrier.h>
 #include <asm/cacheflush.h>
 #include <asm/cputype.h>
+#include <asm/daifflags.h>
 #include <asm/irqflags.h>
 #include <asm/kexec.h>
 #include <asm/memory.h>
@@ -285,7 +286,7 @@ int swsusp_arch_suspend(void)
 		return -EBUSY;
 	}
 
-	local_dbg_save(flags);
+	flags = local_daif_save();
 
 	if (__cpu_suspend_enter(&state)) {
 		/* make the crash dump kernel image visible/saveable */
@@ -315,7 +316,7 @@ int swsusp_arch_suspend(void)
 		__cpu_suspend_exit();
 	}
 
-	local_dbg_restore(flags);
+	local_daif_restore(flags);
 
 	return ret;
 }
diff --git a/arch/arm64/kernel/machine_kexec.c b/arch/arm64/kernel/machine_kexec.c
index 11121f608eb5..f76ea92dff91 100644
--- a/arch/arm64/kernel/machine_kexec.c
+++ b/arch/arm64/kernel/machine_kexec.c
@@ -18,6 +18,7 @@
 
 #include <asm/cacheflush.h>
 #include <asm/cpu_ops.h>
+#include <asm/daifflags.h>
 #include <asm/memory.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
@@ -195,8 +196,7 @@ void machine_kexec(struct kimage *kimage)
 
 	pr_info("Bye!\n");
 
-	/* Disable all DAIF exceptions. */
-	asm volatile ("msr daifset, #0xf" : : : "memory");
+	local_daif_mask();
 
 	/*
 	 * cpu_soft_restart will shutdown the MMU, disable data caches, then
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 9f7195a5773e..5a407eba01f7 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -47,6 +47,7 @@
 #include <asm/cpu.h>
 #include <asm/cputype.h>
 #include <asm/cpu_ops.h>
+#include <asm/daifflags.h>
 #include <asm/mmu_context.h>
 #include <asm/numa.h>
 #include <asm/pgtable.h>
@@ -368,10 +369,6 @@ void __cpu_die(unsigned int cpu)
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
@@ -379,7 +376,7 @@ void cpu_die(void)
 
 	idle_task_exit();
 
-	local_irq_disable();
+	local_daif_mask();
 
 	/* Tell __cpu_die() that this CPU is now safe to dispose of */
 	(void)cpu_report_death();
@@ -837,7 +834,7 @@ static void ipi_cpu_stop(unsigned int cpu)
 {
 	set_cpu_online(cpu, false);
 
-	local_irq_disable();
+	local_daif_mask();
 
 	while (1)
 		cpu_relax();
diff --git a/arch/arm64/kernel/suspend.c b/arch/arm64/kernel/suspend.c
index 1e3be9064cfa..d2d2edac78f2 100644
--- a/arch/arm64/kernel/suspend.c
+++ b/arch/arm64/kernel/suspend.c
@@ -4,6 +4,7 @@
 #include <asm/alternative.h>
 #include <asm/cacheflush.h>
 #include <asm/cpufeature.h>
+#include <asm/daifflags.h>
 #include <asm/debug-monitors.h>
 #include <asm/exec.h>
 #include <asm/pgtable.h>
@@ -57,7 +58,7 @@ void notrace __cpu_suspend_exit(void)
 	/*
 	 * Restore HW breakpoint registers to sane values
 	 * before debug exceptions are possibly reenabled
-	 * through local_dbg_restore.
+	 * by cpu_suspend()s local_daif_restore() call.
 	 */
 	if (hw_breakpoint_restore)
 		hw_breakpoint_restore(cpu);
@@ -81,7 +82,7 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
 	 * updates to mdscr register (saved and restored along with
 	 * general purpose registers) from kernel debuggers.
 	 */
-	local_dbg_save(flags);
+	flags = local_daif_save();
 
 	/*
 	 * Function graph tracer state gets incosistent when the kernel
@@ -114,7 +115,7 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
 	 * restored, so from this point onwards, debugging is fully
 	 * renabled if it was enabled when core started shutdown.
 	 */
-	local_dbg_restore(flags);
+	local_daif_restore(flags);
 
 	return ret;
 }
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 5ea4b85aee0e..1808be65d22f 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -38,6 +38,7 @@
 
 #include <asm/atomic.h>
 #include <asm/bug.h>
+#include <asm/daifflags.h>
 #include <asm/debug-monitors.h>
 #include <asm/esr.h>
 #include <asm/insn.h>
@@ -642,7 +643,7 @@ asmlinkage void bad_mode(struct pt_regs *regs, int reason, unsigned int esr)
 		esr_get_class_string(esr));
 
 	die("Oops - bad mode", regs, 0);
-	local_irq_disable();
+	local_daif_mask();
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
2.13.3
