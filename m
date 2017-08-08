From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v2 08/11] arm64: kernel: Add arch-specific SDEI entry code and CPU masking
Date: Tue,  8 Aug 2017 17:46:13 +0100
Message-ID: <20170808164616.25949-9-james.morse@arm.com>
References: <20170808164616.25949-1-james.morse@arm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170808164616.25949-1-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

The Software Delegated Exception Interface (SDEI) is an ARM standard
for registering callbacks from the platform firmware into the OS.
This is typically used to implement RAS notifications.

Such notifications enter the kernel at the registered entry-point
with the register values of the interrupted CPU context. Because this
is not a CPU exception, it cannot reuse the existing entry code.
(crucially we don't immediately know which exception level we interrupted),

Add entry.S asm to set us up for calling into C code. If the event
interrupted code that had interrupts masked, we always return to that
location. Otherwise we pretend this was an IRQ, and use SDEI's
complete_and_resume call to return to vbar_el1 + offset.

This allows the kernel to deliver signals to user space processes. For
KVM this triggers the world switch, a quick spin round vcpu_run, then
back into the guest, unless there are pending signals.

Add sdei_mask_local_cpu() calls to the smp_send_stop() code, this covers
the panic() code-path, which doesn't invoke cpuhotplug notifiers, and
only calls the panic notifiers if there is no kdump kernel registered.

Because we can interrupt entry-from/exit-to EL0, we can't trust the value
in sp_el0 even if we interrupted the kernel, in this case the code in
entry.S will save/restore sp_el0 and use the value in __entry_task.

Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
---
 arch/arm64/Kconfig              |   2 +-
 arch/arm64/include/asm/sdei.h   |  48 ++++++++++++++++
 arch/arm64/kernel/Makefile      |   1 +
 arch/arm64/kernel/asm-offsets.c |   2 +
 arch/arm64/kernel/sdei-entry.S  |  92 +++++++++++++++++++++++++++++++
 arch/arm64/kernel/sdei.c        | 119 ++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/smp.c         |   7 +++
 drivers/firmware/Kconfig        |   1 +
 drivers/firmware/arm_sdei.c     |   1 +
 include/linux/sdei.h            |   2 +
 10 files changed, 274 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/sdei.h
 create mode 100644 arch/arm64/kernel/sdei-entry.S
 create mode 100644 arch/arm64/kernel/sdei.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index dfd908630631..d3913cffa3ac 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -97,7 +97,7 @@ config ARM64
 	select HAVE_IRQ_TIME_ACCOUNTING
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP if NUMA
-	select HAVE_NMI if ACPI_APEI_SEA
+	select HAVE_NMI
 	select HAVE_PATA_PLATFORM
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_REGS
diff --git a/arch/arm64/include/asm/sdei.h b/arch/arm64/include/asm/sdei.h
new file mode 100644
index 000000000000..9d1b2b44fedf
--- /dev/null
+++ b/arch/arm64/include/asm/sdei.h
@@ -0,0 +1,48 @@
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
+#ifndef __ASM_SDEI_H
+#define __ASM_SDEI_H
+
+/* Values for sdei_exit_mode */
+#define SDEI_EXIT_HVC  0
+#define SDEI_EXIT_SMC  1
+
+#ifndef __ASSEMBLY__
+
+#include <linux/linkage.h>
+#include <linux/types.h>
+
+#include <asm/virt.h>
+
+extern unsigned long sdei_exit_mode;
+
+/* Software Delegated Exception entry point from firmware*/
+asmlinkage void __sdei_asm_handler(unsigned long event_num, unsigned long arg,
+				   unsigned long pc, unsigned long pstate);
+
+/*
+ * The above entry points do the minimum to call C code. This function does
+ * anything else, before calling the driver.
+ */
+struct sdei_registered_event;
+asmlinkage unsigned long __sdei_handler(struct pt_regs *regs,
+					struct sdei_registered_event *arg);
+
+extern unsigned long sdei_arch_get_entry_point(int conduit);
+#define sdei_arch_get_entry_point(x)	sdei_arch_get_entry_point(x)
+
+#endif /* __ASSEMBLY__ */
+#endif	/* __ASM_SDEI_H */
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index f2b4e816b6de..d22bae586ade 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -53,6 +53,7 @@ arm64-obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o	\
 arm64-obj-$(CONFIG_ARM64_RELOC_TEST)	+= arm64-reloc-test.o
 arm64-reloc-test-y := reloc_test_core.o reloc_test_syms.o
 arm64-obj-$(CONFIG_CRASH_DUMP)		+= crash_dump.o
+arm64-obj-$(CONFIG_ARM_SDE_INTERFACE)	+= sdei.o sdei-entry.o
 
 obj-y					+= $(arm64-obj-y) vdso/ probes/
 obj-m					+= $(arm64-obj-m)
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index b3bb7ef97bc8..2dd036407046 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -22,6 +22,7 @@
 #include <linux/mm.h>
 #include <linux/dma-mapping.h>
 #include <linux/kvm_host.h>
+#include <linux/sdei.h>
 #include <linux/suspend.h>
 #include <asm/cpufeature.h>
 #include <asm/thread_info.h>
@@ -153,5 +154,6 @@ int main(void)
   DEFINE(HIBERN_PBE_ADDR,	offsetof(struct pbe, address));
   DEFINE(HIBERN_PBE_NEXT,	offsetof(struct pbe, next));
   DEFINE(ARM64_FTR_SYSVAL,	offsetof(struct arm64_ftr_reg, sys_val));
+  DEFINE(SDEI_EVENT_INTREGS,	offsetof(struct sdei_registered_event, interrupted_regs));
   return 0;
 }
diff --git a/arch/arm64/kernel/sdei-entry.S b/arch/arm64/kernel/sdei-entry.S
new file mode 100644
index 000000000000..00a637eee155
--- /dev/null
+++ b/arch/arm64/kernel/sdei-entry.S
@@ -0,0 +1,92 @@
+/*
+ * Software Delegated Exception entry point from firmware to the kernel.
+ *
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
+
+#include <linux/linkage.h>
+
+#include <asm/alternative.h>
+#include <asm/asm-offsets.h>
+#include <asm/assembler.h>
+#include <asm/ptrace.h>
+#include <asm/sdei.h>
+#include <uapi/linux/sdei.h>
+
+/*
+ * Software Delegated Exception entry point.
+ *
+ * x0: Event number
+ * x1: struct sdei_registered_event argument from registration time.
+ * x2: interrupted PC
+ * x3: interrupted PSTATE
+ *
+ * Firmware has preserved x0->x17 for us, we must save/restore the rest to
+ * follow SMC-CC. We save (or retrieve) all the registers as the handler may
+ * want them.
+ */
+ENTRY(__sdei_asm_handler)
+	stp     x2, x3, [x1, #SDEI_EVENT_INTREGS + S_PC]
+	stp     x4, x5, [x1, #SDEI_EVENT_INTREGS + 16 * 2]
+	stp     x6, x7, [x1, #SDEI_EVENT_INTREGS + 16 * 3]
+	stp     x8, x9, [x1, #SDEI_EVENT_INTREGS + 16 * 4]
+	stp     x10, x11, [x1, #SDEI_EVENT_INTREGS + 16 * 5]
+	stp     x12, x13, [x1, #SDEI_EVENT_INTREGS + 16 * 6]
+	stp     x14, x15, [x1, #SDEI_EVENT_INTREGS + 16 * 7]
+	stp     x16, x17, [x1, #SDEI_EVENT_INTREGS + 16 * 8]
+	stp     x18, x19, [x1, #SDEI_EVENT_INTREGS + 16 * 9]
+	stp     x20, x21, [x1, #SDEI_EVENT_INTREGS + 16 * 10]
+	stp     x22, x23, [x1, #SDEI_EVENT_INTREGS + 16 * 11]
+	stp     x24, x25, [x1, #SDEI_EVENT_INTREGS + 16 * 12]
+	stp     x26, x27, [x1, #SDEI_EVENT_INTREGS + 16 * 13]
+	stp     x28, x29, [x1, #SDEI_EVENT_INTREGS + 16 * 14]
+
+	mov	x19, x1
+
+	/*
+	 * We may have interrupted userspace, or a guest. Restore sp_el0 from
+	 * __entry_task.
+	 */
+	mrs	x0, sp_el0
+	stp     lr, x0, [x19, #SDEI_EVENT_INTREGS + S_LR]
+	ldr_this_cpu	dst=x0, sym=__entry_task, tmp=x1
+	msr	sp_el0, x0
+
+	add	x0, x19, #SDEI_EVENT_INTREGS
+	mov	x1, x19
+	bl	__sdei_handler
+
+	/* restore regs >x17 that we clobbered */
+	ldp     x28, x29, [x19, #SDEI_EVENT_INTREGS + 16 * 14]
+	ldp     lr, x1, [x19, #SDEI_EVENT_INTREGS + S_LR]
+	msr	sp_el0, x1
+	ldp     x18, x19, [x19, #SDEI_EVENT_INTREGS + 16 * 9]
+
+	mov	x1, x0			// address to complete_and_resume
+	/* x0 = (x0 <= 1) ? EVENT_COMPLETE:EVENT_COMPLETE_AND_RESUME */
+	cmp	x0, #1
+	mov_q	x2, SDEI_1_0_FN_SDEI_EVENT_COMPLETE
+	mov_q	x3, SDEI_1_0_FN_SDEI_EVENT_COMPLETE_AND_RESUME
+	csel	x0, x2, x3, ls
+
+	/* On success, this call never returns... */
+	ldr_l	x2, sdei_exit_mode
+	cmp	x2, #SDEI_EXIT_SMC
+	b.ne	1f
+	smc	#0
+	b	.
+1:	hvc	#0
+	b	.
+ENDPROC(__sdei_asm_handler)
diff --git a/arch/arm64/kernel/sdei.c b/arch/arm64/kernel/sdei.c
new file mode 100644
index 000000000000..60693a9728bb
--- /dev/null
+++ b/arch/arm64/kernel/sdei.c
@@ -0,0 +1,119 @@
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
+
+#include <linux/sched/task_stack.h>
+#include <linux/irqflags.h>
+#include <linux/hardirq.h>
+#include <linux/sdei.h>
+
+#include <asm/kprobes.h>
+#include <asm/ptrace.h>
+#include <asm/sysreg.h>
+
+unsigned long sdei_exit_mode;
+
+unsigned long sdei_arch_get_entry_point(int conduit)
+{
+	/*
+	 * SDEI works between adjacent exception levels. If we booted at EL1 we
+	 * assume a hypervisor is marshalling events. If we booted at EL2 and
+	 * dropped to EL1 because we don't support VHE, then we can't support
+	 * SDEI.
+	 */
+	if (is_hyp_mode_available() && !is_kernel_in_hyp_mode()) {
+		pr_err("Not supported on this hardware/boot configuration\n");
+		return 0;
+	}
+
+	sdei_exit_mode = (conduit == CONDUIT_HVC) ? SDEI_EXIT_HVC : SDEI_EXIT_SMC;
+	return (unsigned long)__sdei_asm_handler;
+}
+
+
+/*
+ * __sdei_handler() returns one of:
+ *  SDEI_EV_HANDLED -  success, return to the interrupted context.
+ *  SDEI_EV_FAILED  -  failure, return this error code to firmare.
+ *  virtual-address -  success, return to this address.
+ */
+static __kprobes unsigned long _sdei_handler(struct pt_regs *regs,
+					     struct sdei_registered_event *arg)
+{
+	u32 mode;
+	int i, err = 0;
+	int clobbered_registers = 4;
+	u32 kernel_mode = read_sysreg(CurrentEL) | 1;	/* +SPSel */
+	unsigned long vbar = read_sysreg(vbar_el1);
+
+	/* Retrieve the missing registers values */
+	for (i = 0; i < clobbered_registers; i++) {
+		/* from within the handler, this call always succeeds */
+		sdei_api_event_context(i, &regs->regs[i]);
+	}
+
+	err = sdei_event_handler(regs, arg);
+	if (err)
+		return SDEI_EV_FAILED;
+
+	mode = regs->pstate & (PSR_MODE32_BIT | PSR_MODE_MASK);
+
+	/*
+	 * If we interrupted the kernel with interrupts masked, we always go
+	 * back to wherever we came from.
+	 */
+	if (mode == kernel_mode && !interrupts_enabled(regs))
+		return SDEI_EV_HANDLED;
+
+	/*
+	 * Otherwise, we pretend this was an IRQ. This lets user space tasks
+	 * receive signals before we return to them, and KVM to invoke it's
+	 * world switch to do the same.
+	 *
+	 * See DDI0487B.a Table D1-7 'Vector offsets from vector table base
+	 * address'.
+	 */
+	if (mode == kernel_mode)
+		return vbar + 0x280;
+	else if (mode & PSR_MODE32_BIT)
+		return vbar + 0x680;
+
+	return vbar + 0x480;
+}
+
+
+asmlinkage __kprobes notrace unsigned long
+__sdei_handler(struct pt_regs *regs, struct sdei_registered_event *arg)
+{
+	unsigned long ret;
+	bool do_nmi_exit = false;
+
+	/*
+	 * nmi_enter() deals with printk() re-entrance and use of RCU when
+	 * RCU believed this CPU was idle. Because critical events can
+	 * interrupt normal events, we may already be in_nmi().
+	 */
+	if (!in_nmi()) {
+		nmi_enter();
+		do_nmi_exit = true;
+	}
+
+	ret = _sdei_handler(regs, arg);
+
+	if (do_nmi_exit)
+		nmi_exit();
+
+	return ret;
+}
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index dc66e6ec3a99..381b844aca6e 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -31,6 +31,7 @@
 #include <linux/mm.h>
 #include <linux/err.h>
 #include <linux/cpu.h>
+#include <linux/sdei.h>
 #include <linux/smp.h>
 #include <linux/seq_file.h>
 #include <linux/irq.h>
@@ -838,6 +839,7 @@ static void ipi_cpu_stop(unsigned int cpu)
 	set_cpu_online(cpu, false);
 
 	local_irq_disable();
+	sdei_mask_local_cpu();
 
 	while (1)
 		cpu_relax();
@@ -855,6 +857,7 @@ static void ipi_cpu_crash_stop(unsigned int cpu, struct pt_regs *regs)
 	atomic_dec(&waiting_for_crash_ipi);
 
 	local_irq_disable();
+	sdei_mask_local_cpu();
 
 #ifdef CONFIG_HOTPLUG_CPU
 	if (cpu_ops[cpu]->cpu_die)
@@ -974,6 +977,8 @@ void smp_send_stop(void)
 	if (num_online_cpus() > 1)
 		pr_warning("SMP: failed to stop secondary CPUs %*pbl\n",
 			   cpumask_pr_args(cpu_online_mask));
+
+	sdei_mask_local_cpu();
 }
 
 #ifdef CONFIG_KEXEC_CORE
@@ -1001,6 +1006,8 @@ void smp_send_crash_stop(void)
 	if (atomic_read(&waiting_for_crash_ipi) > 0)
 		pr_warning("SMP: failed to stop secondary CPUs %*pbl\n",
 			   cpumask_pr_args(&mask));
+
+	sdei_mask_local_cpu();
 }
 
 bool smp_crash_stop_failed(void)
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index d8a9859f6102..1f6633b337aa 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -50,6 +50,7 @@ config ARM_SCPI_POWER_DOMAIN
 
 config ARM_SDE_INTERFACE
 	bool "ARM Software Delegated Exception Interface (SDEI)"
+	depends on ARM64
 	help
 	  The Software Delegated Exception Interface (SDEI) is an ARM
 	  standard for registering callbacks from the platform firmware
diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index 6155032c4958..74e84de5bf0b 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -154,6 +154,7 @@ int sdei_api_event_context(u32 query, u64 *result)
 	return invoke_sdei_fn(SDEI_1_0_FN_SDEI_EVENT_CONTEXT, query, 0, 0, 0, 0,
 			      result);
 }
+NOKPROBE_SYMBOL(sdei_api_event_context);
 
 static int sdei_api_event_get_info(u32 event, u32 info, u64 *result)
 {
diff --git a/include/linux/sdei.h b/include/linux/sdei.h
index 5393b0eb1afd..d19dbf2f29ca 100644
--- a/include/linux/sdei.h
+++ b/include/linux/sdei.h
@@ -32,6 +32,8 @@ enum sdei_conduit_types {
 	CONDUIT_HVC,
 };
 
+#include <asm/sdei.h>
+
 /* Arch code should override this to set the entry point from firmware... */
 #ifndef sdei_arch_get_entry_point
 #define sdei_arch_get_entry_point(conduit)	(0)
-- 
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
