From: James Morse <james.morse@arm.com>
Subject: [PATCH v4 09/13] arm64: kernel: Add arch-specific SDEI entry code and
 CPU masking
Date: Tue, 17 Oct 2017 18:44:28 +0100
Message-ID: <20171017174432.1684-10-james.morse@arm.com>
References: <20171017174432.1684-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15CFE41185
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 13:45:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PbZXciJUHbmu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Oct 2017 13:45:48 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 197ED49D24
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 13:45:47 -0400 (EDT)
In-Reply-To: <20171017174432.1684-1-james.morse@arm.com>
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
Cc: devicetree@vger.kernel.org, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>, Loc Ho <lho@apm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The Software Delegated Exception Interface (SDEI) is an ARM standard
for registering callbacks from the platform firmware into the OS.
This is typically used to implement RAS notifications.

Such notifications enter the kernel at the registered entry-point
with the register values of the interrupted CPU context. Because this
is not a CPU exception, it cannot reuse the existing entry code.
(crucially we don't implicitly know which exception level we interrupted),

Add an sdei-entry.S asm file to set us up for calling into C code. If
the event interrupted code that had interrupts masked, we always return
to that location. Otherwise we pretend this was an IRQ, and use SDEI's
complete_and_resume call to return to vbar_el1 + offset.

This allows the kernel to deliver signals to user space processes. For
KVM this triggers the world switch, a quick spin round vcpu_run, then
back into the guest, unless there are pending signals.

Add sdei_mask_local_cpu() calls to the smp_send_stop() code, this covers
the panic() code-path, which doesn't invoke cpuhotplug notifiers.

Because we can interrupt entry-from/exit-to another EL, we can't trust the
value in sp_el0 or x29, even if we interrupted the kernel, in this case
the code in entry.S will save/restore sp_el0 and use the value in
__entry_task.

When we have VMAP stacks we can interrupt the stack-overflow test, which
stirs x0 into sp, meaning we have to have our own VMAP stack.

Signed-off-by: James Morse <james.morse@arm.com>

---
Changes since v3:
 * Added const to clobbered_registers,
 * Removed extern from C function declarations.
 * Header file names changed

Changes since v2:
 * Added PAN-setting as we didn't take an exception to get here.
 * Added VMAP stack allocation and switching.
 * overwrite x29 on entry from not-the-kernel.
 * Added a pe-mask to crash_smp_send_stop()s 'no secondaries' path (oops).
 * Added ELR-hasn't-changed test. Any exception in the handler will panic KVM
   as its switched VBAR_EL1, but go silently undetected otherwise. Generate a
   warning.

 arch/arm64/Kconfig                  |   2 +-
 arch/arm64/include/asm/sdei.h       |  46 ++++++-
 arch/arm64/include/asm/stacktrace.h |   3 +
 arch/arm64/kernel/Makefile          |   1 +
 arch/arm64/kernel/asm-offsets.c     |   5 +
 arch/arm64/kernel/sdei-entry.S      | 122 +++++++++++++++++++
 arch/arm64/kernel/sdei.c            | 235 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/smp.c             |  11 +-
 8 files changed, 421 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm64/kernel/sdei-entry.S
 create mode 100644 arch/arm64/kernel/sdei.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 0df64a6a56d4..70dfe4e9ccc5 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -98,7 +98,7 @@ config ARM64
 	select HAVE_IRQ_TIME_ACCOUNTING
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP if NUMA
-	select HAVE_NMI if ACPI_APEI_SEA
+	select HAVE_NMI
 	select HAVE_PATA_PLATFORM
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_REGS
diff --git a/arch/arm64/include/asm/sdei.h b/arch/arm64/include/asm/sdei.h
index b60381a05787..bbebdbc0b754 100644
--- a/arch/arm64/include/asm/sdei.h
+++ b/arch/arm64/include/asm/sdei.h
@@ -16,6 +16,48 @@
 #ifndef __ASM_SDEI_H
 #define __ASM_SDEI_H
 
-/* Later patches add the arch specific bits */
+/* Values for sdei_exit_mode */
+#define SDEI_EXIT_HVC  0
+#define SDEI_EXIT_SMC  1
 
-#endif /* __ASM_SDEI_H */
+#define SDEI_STACK_SIZE		IRQ_STACK_SIZE
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
+ * The above entry point does the minimum to call C code. This function does
+ * anything else, before calling the driver.
+ */
+struct sdei_registered_event;
+asmlinkage unsigned long __sdei_handler(struct pt_regs *regs,
+					struct sdei_registered_event *arg);
+
+unsigned long sdei_arch_get_entry_point(int conduit);
+#define sdei_arch_get_entry_point(x)	sdei_arch_get_entry_point(x)
+
+bool _on_sdei_stack(unsigned long sp);
+static inline bool on_sdei_stack(unsigned long sp)
+{
+	if (!IS_ENABLED(CONFIG_VMAP_STACK))
+		return false;
+	if (!IS_ENABLED(CONFIG_ARM_SDE_INTERFACE))
+		return false;
+	if (in_nmi())
+		return _on_sdei_stack(sp);
+
+	return false;
+}
+
+#endif /* __ASSEMBLY__ */
+#endif	/* __ASM_SDEI_H */
diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index 6ad30776e984..472ef944e932 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -22,6 +22,7 @@
 
 #include <asm/memory.h>
 #include <asm/ptrace.h>
+#include <asm/sdei.h>
 
 struct stackframe {
 	unsigned long fp;
@@ -85,6 +86,8 @@ static inline bool on_accessible_stack(struct task_struct *tsk, unsigned long sp
 		return true;
 	if (on_overflow_stack(sp))
 		return true;
+	if (on_sdei_stack(sp))
+		return true;
 
 	return false;
 }
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
index 71bf088f1e4b..bd67a04d40f0 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -18,6 +18,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/arm_sdei.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/dma-mapping.h>
@@ -154,5 +155,9 @@ int main(void)
   DEFINE(HIBERN_PBE_ADDR,	offsetof(struct pbe, address));
   DEFINE(HIBERN_PBE_NEXT,	offsetof(struct pbe, next));
   DEFINE(ARM64_FTR_SYSVAL,	offsetof(struct arm64_ftr_reg, sys_val));
+#ifdef CONFIG_ARM_SDE_INTERFACE
+  DEFINE(SDEI_EVENT_INTREGS,	offsetof(struct sdei_registered_event, interrupted_regs));
+  DEFINE(SDEI_EVENT_PRIORITY,	offsetof(struct sdei_registered_event, priority));
+#endif
   return 0;
 }
diff --git a/arch/arm64/kernel/sdei-entry.S b/arch/arm64/kernel/sdei-entry.S
new file mode 100644
index 000000000000..047bfa566310
--- /dev/null
+++ b/arch/arm64/kernel/sdei-entry.S
@@ -0,0 +1,122 @@
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
+#include <asm/memory.h>
+#include <asm/ptrace.h>
+#include <asm/sdei.h>
+#include <uapi/linux/arm_sdei.h>
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
+	mov	x4, sp
+	stp     lr, x4, [x1, #SDEI_EVENT_INTREGS + S_LR]
+
+	mov	x19, x1
+
+#ifdef CONFIG_VMAP_STACK
+	/*
+	 * entry.S may have been using sp as a scratch register, find whether
+	 * this is a normal or critical event and switch to the appropriate
+	 * stack for this CPU.
+	 */
+	ldrb	w4, [x19, #SDEI_EVENT_PRIORITY]
+	cbnz	w4, 1f
+	ldr_this_cpu dst=x5, sym=sdei_stack_normal_ptr, tmp=x6
+	b	2f
+1:	ldr_this_cpu dst=x5, sym=sdei_stack_critical_ptr, tmp=x6
+2:	mov	x6, #SDEI_STACK_SIZE
+	add	x5, x5, x6
+	mov	sp, x5
+#endif
+
+	/*
+	 * We may have interrupted userspace, or a guest, or exit-from or
+	 * return-to either of these. We can't trust sp_el0, restore it.
+	 */
+	mrs	x28, sp_el0
+	ldr_this_cpu	dst=x0, sym=__entry_task, tmp=x1
+	msr	sp_el0, x0
+
+	/* If we interrupted the kernel point to the previous stack/frame. */
+	and     x0, x3, #0xc
+	mrs     x1, CurrentEL
+	cmp     x0, x1
+	csel	x29, x29, xzr, eq	// fp, or zero
+	csel	x4, x2, xzr, eq		// elr, or zero
+
+	stp	x29, x4, [sp, #-16]!
+	mov	x29, sp
+
+	add	x0, x19, #SDEI_EVENT_INTREGS
+	mov	x1, x19
+	bl	__sdei_handler
+
+	msr	sp_el0, x28
+	/* restore regs >x17 that we clobbered */
+	ldp     x28, x29, [x19, #SDEI_EVENT_INTREGS + 16 * 14]
+	ldp     lr, x4, [x19, #SDEI_EVENT_INTREGS + S_LR]
+	mov	sp, x4
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
+NOKPROBE(__sdei_asm_handler)
diff --git a/arch/arm64/kernel/sdei.c b/arch/arm64/kernel/sdei.c
new file mode 100644
index 000000000000..6ec098e17dab
--- /dev/null
+++ b/arch/arm64/kernel/sdei.c
@@ -0,0 +1,235 @@
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
+#define pr_fmt(fmt) "sdei: " fmt
+
+#include <linux/arm_sdei.h>
+#include <linux/sched/task_stack.h>
+#include <linux/irqflags.h>
+#include <linux/hardirq.h>
+
+#include <asm/alternative.h>
+#include <asm/kprobes.h>
+#include <asm/ptrace.h>
+#include <asm/sysreg.h>
+#include <asm/vmap_stack.h>
+
+unsigned long sdei_exit_mode;
+
+/*
+ * VMAP'd stacks checking for stack overflow on exception using sp as a scratch
+ * register, meaning SDEI has to switch to its own stack. We need two stacks as
+ * a critical event may interrupt a normal event that has just taken a
+ * synchronous exception, and is using sp as scratch register. For a critical
+ * event interrupting a normal event, we can't reliably tell if we were on the
+ * sdei stack.
+ * For private events we need per-cpu stacks, these can't be allocated lazily
+ * as THREADINFO_GFP is a subset of GFP_KERNEL which can't necessarily be used
+ * when the first private event is registered.
+ */
+DECLARE_PER_CPU(unsigned long *, sdei_stack_normal_ptr);
+DECLARE_PER_CPU(unsigned long *, sdei_stack_critical_ptr);
+
+#ifdef CONFIG_VMAP_STACK
+DEFINE_PER_CPU(unsigned long *, sdei_stack_normal_ptr);
+DEFINE_PER_CPU(unsigned long *, sdei_stack_critical_ptr);
+#endif
+
+static void _free_sdei_stack(unsigned long * __percpu *ptr, int cpu)
+{
+	unsigned long *p;
+
+	p = per_cpu(*ptr, cpu);
+	if (p) {
+		per_cpu(*ptr, cpu) = NULL;
+		vfree(p);
+	}
+}
+
+static void free_sdei_stacks(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		_free_sdei_stack(&sdei_stack_normal_ptr, cpu);
+		_free_sdei_stack(&sdei_stack_critical_ptr, cpu);
+	}
+}
+
+static int _init_sdei_stack(unsigned long * __percpu *ptr, int cpu)
+{
+	unsigned long *p;
+
+	p = arch_alloc_vmap_stack(SDEI_STACK_SIZE, cpu_to_node(cpu));
+	if (!p)
+		return -ENOMEM;
+	per_cpu(*ptr, cpu) = p;
+
+	return 0;
+}
+
+static int init_sdei_stacks(void)
+{
+	int cpu;
+	int err = 0;
+
+	for_each_possible_cpu(cpu) {
+		err = _init_sdei_stack(&sdei_stack_normal_ptr, cpu);
+		if (err)
+			break;
+		err = _init_sdei_stack(&sdei_stack_critical_ptr, cpu);
+		if (err)
+			break;
+	}
+
+	if (err)
+		free_sdei_stacks();
+
+	return err;
+}
+
+bool _on_sdei_stack(unsigned long sp)
+{
+	unsigned long low, high;
+
+	if (!IS_ENABLED(CONFIG_VMAP_STACK))
+		return false;
+
+	low = (unsigned long)raw_cpu_read(sdei_stack_critical_ptr);
+	high = low + SDEI_STACK_SIZE;
+
+	if (low <= sp && sp < high)
+		return true;
+
+	low = (unsigned long)raw_cpu_read(sdei_stack_normal_ptr);
+	high = low + SDEI_STACK_SIZE;
+
+	return (low <= sp && sp < high);
+}
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
+	if (IS_ENABLED(CONFIG_VMAP_STACK)) {
+		if (init_sdei_stacks())
+			return 0;
+	}
+
+	sdei_exit_mode = (conduit == CONDUIT_HVC) ? SDEI_EXIT_HVC : SDEI_EXIT_SMC;
+	return (unsigned long)__sdei_asm_handler;
+}
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
+	const int clobbered_registers = 4;
+	u64 elr = read_sysreg(elr_el1);
+	u32 kernel_mode = read_sysreg(CurrentEL) | 1;	/* +SPSel */
+	unsigned long vbar = read_sysreg(vbar_el1);
+
+	/* Retrieve the missing registers values */
+	for (i = 0; i < clobbered_registers; i++) {
+		/* from within the handler, this call always succeeds */
+		sdei_api_event_context(i, &regs->regs[i]);
+	}
+
+	/*
+	 * We didn't take an exception to get here, set PAN. UAO will be cleared
+	 * by sdei_event_handler()s set_fs(USER_DS) call.
+	 */
+	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN,
+			CONFIG_ARM64_PAN));
+
+	err = sdei_event_handler(regs, arg);
+	if (err)
+		return SDEI_EV_FAILED;
+
+	if (elr != read_sysreg(elr_el1)) {
+		/*
+		 * We took a synchronous exception from the SDEI handler.
+		 * This could deadlock, and if you interrupt KVM it will
+		 * hyp-panic instead.
+		 */
+		pr_warn("unsafe: exception during handler\n");
+	}
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
index 9f7195a5773e..ca972cf9bafb 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/acpi.h>
+#include <linux/arm_sdei.h>
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
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
@@ -992,8 +997,10 @@ void crash_smp_send_stop(void)
 
 	cpus_stopped = 1;
 
-	if (num_online_cpus() == 1)
+	if (num_online_cpus() == 1) {
+		sdei_mask_local_cpu();
 		return;
+	}
 
 	cpumask_copy(&mask, cpu_online_mask);
 	cpumask_clear_cpu(smp_processor_id(), &mask);
@@ -1011,6 +1018,8 @@ void crash_smp_send_stop(void)
 	if (atomic_read(&waiting_for_crash_ipi) > 0)
 		pr_warning("SMP: failed to stop secondary CPUs %*pbl\n",
 			   cpumask_pr_args(&mask));
+
+	sdei_mask_local_cpu();
 }
 
 bool smp_crash_stop_failed(void)
-- 
2.13.3
