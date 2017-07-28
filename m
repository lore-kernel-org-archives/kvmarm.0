From: James Morse <james.morse@arm.com>
Subject: [PATCH v2 12/16] arm64: entry.S: Make eret restartable
Date: Fri, 28 Jul 2017 15:10:15 +0100
Message-ID: <20170728141019.9084-13-james.morse@arm.com>
References: <20170728141019.9084-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7857940D1D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jul 2017 10:11:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7oys8Fz0dOMJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Jul 2017 10:11:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCDEC49C2F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jul 2017 10:10:58 -0400 (EDT)
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

To gain any benefit from IESB on exception return we must unmask SError
over ERET instructions so that the SError is taken to EL1, instead of
deferred. SErrors deferred like this would only be processed once we take
another exception, at which point they may be overwritten by a new (less
severe) deferred SError.

The 'IESB' bit in the ESR isn't enough for us to fixup this error, as
we may take a pending SError the moment we unmask it, instead of being
synchronized by IESB when we ERET.

Instead we move exception return out of the kernel_exit macro so that its
PC range is well-known, and stash the SPSR and ELR which would be lost if
we take an SError from this code.

_do_serror() is extended to match the interrupted PC against the well known
do_kernel_exit range and restore the stashed values.

Now if we take a survivable SError from EL1 to EL1, we must check if
kernel_exit had restored the EL0 state, if so we must call 'kernel_enter 0'
from el1_serror. _do_serror() restores the clobbered SPSR value, and we
then return to EL0 from el1_serror. This keeps the enter/exit calls
balanced.

None of this code is specific to IESB, enable it for all platforms. On
systems without the IESB feature we may take a pending SError earlier.

Signed-off-by: James Morse <james.morse@arm.com>
---
Known issue: If _do_serror() takes a synchronous exception the per-cpu SPSR
and ELR will be overwritten. A WARN_ON() firing is the most likely way of
doing this. Fixing it requires the asm to do the restore, which makes it
three times as complicated. This shouldn't be a problem for _do_serror()
as it is today.

 arch/arm64/include/asm/exception.h | 20 +++++++++++++++
 arch/arm64/kernel/entry.S          | 51 +++++++++++++++++++++++++++++++++++++-
 arch/arm64/kernel/traps.c          | 23 ++++++++++++++---
 3 files changed, 90 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/exception.h b/arch/arm64/include/asm/exception.h
index bc30429d8e91..a0ef187127ea 100644
--- a/arch/arm64/include/asm/exception.h
+++ b/arch/arm64/include/asm/exception.h
@@ -18,7 +18,10 @@
 #ifndef __ASM_EXCEPTION_H
 #define __ASM_EXCEPTION_H
 
+#ifndef __ASSEMBLY__
+
 #include <asm/esr.h>
+#include <asm/ptrace.h>
 
 #include <linux/interrupt.h>
 
@@ -41,4 +44,21 @@ static inline u32 disr_to_esr(u64 disr)
 	return esr;
 }
 
+extern char __do_kernel_exit_start;
+extern char __do_kernel_exit_end;
+
+static inline bool __is_kernel_exit(unsigned long pc)
+{
+	return ((unsigned long)&__do_kernel_exit_start <= pc &&
+		pc < (unsigned long)&__do_kernel_exit_end);
+}
+#else
+/* result returned in flags, 'lo' true, 'hs' false */
+.macro	is_kernel_exit, reg, tmp
+	adr	\tmp, __do_kernel_exit_start
+	cmp	\reg, \tmp
+	adr	\tmp, __do_kernel_exit_end
+	ccmp	\reg, \tmp, #2, hs
+.endm
+#endif /* __ASSEMBLY__*/
 #endif	/* __ASM_EXCEPTION_H */
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 8cdfca4060e3..173b86fac066 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -26,6 +26,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/cpufeature.h>
 #include <asm/errno.h>
+#include <asm/exception.h>
 #include <asm/esr.h>
 #include <asm/irq.h>
 #include <asm/memory.h>
@@ -239,6 +240,10 @@ alternative_else_nop_endif
 #endif
 	.endif
 
+	/* Stash elr and spsr so we can restart this eret */
+	adr_this_cpu x15, __exit_exception_regs, tmp=x16
+	stp	x21, x22, [x15]
+
 	msr	elr_el1, x21			// set up the return data
 	msr	spsr_el1, x22
 	ldp	x0, x1, [sp, #16 * 0]
@@ -258,7 +263,7 @@ alternative_else_nop_endif
 	ldp	x28, x29, [sp, #16 * 14]
 	ldr	lr, [sp, #S_LR]
 	add	sp, sp, #S_FRAME_SIZE		// restore sp
-	eret					// return to kernel
+	b	do_kernel_exit
 	.endm
 
 	.macro	irq_stack_entry
@@ -432,6 +437,17 @@ el1_error_invalid:
 	inv_entry 1, BAD_ERROR
 ENDPROC(el1_error_invalid)
 
+.global __do_kernel_exit_start
+.global __do_kernel_exit_end
+ENTRY(do_kernel_exit)
+__do_kernel_exit_start:
+	enable_serror
+	esb
+
+	eret
+__do_kernel_exit_end:
+ENDPROC(do_kernel_exit)
+
 /*
  * EL1 mode handlers.
  */
@@ -737,13 +753,46 @@ el0_irq_naked:
 ENDPROC(el0_irq)
 
 el1_serror:
+	/*
+	 * If this SError was taken due to an SError while returning from EL1
+	 * to EL0, then sp_el0 is a user space address, even though we took the
+	 * exception from EL1.
+	 * Did we interrupt __do_kernel_exit()?
+	 */
+	stp	x0, x1, [sp, #-16]!
+	mrs	x0, elr_el1
+	is_kernel_exit x0, x1
+	b.hs	1f
+
+	/*
+	 * Retrieve the per-cpu stashed SPSR to check if the interrupted
+	 * kernel_exit was heading for EL0.
+	 */
+	adr_this_cpu x0, __exit_exception_regs, tmp=x1
+	ldr	x1, [x0, #8]
+	and	x1, x1, #PSR_MODE_MASK
+	cmp	x1, #PSR_MODE_EL0t
+	b.ne	1f
+
+	ldp	x0, x1, [sp], #16
+	kernel_entry 0
+	mov	x24, #0		// do EL0 exit
+	b	2f
+
+1:	ldp	x0, x1, [sp], #16
 	kernel_entry 1
+	mov	x24, #1		// do EL1 exit
+2:
 	mov	x20, x15
 	mrs	x1, esr_el1
 	mov	x0, sp
 	bl	do_serror
 
 	disr_check	reg=x20
+
+	cbnz	x24, 9f
+	kernel_exit 0		// do_serror() restored the clobbered ELR, SPSR
+9:
 	kernel_exit 1
 ENDPROC(el1_serror)
 
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 27ebcaa2f0b6..18f53e3afd06 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -29,6 +29,7 @@
 #include <linux/kexec.h>
 #include <linux/delay.h>
 #include <linux/init.h>
+#include <linux/percpu.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/debug.h>
 #include <linux/sched/task_stack.h>
@@ -40,6 +41,7 @@
 #include <asm/debug-monitors.h>
 #include <asm/esr.h>
 #include <asm/insn.h>
+#include <asm/kprobes.h>
 #include <asm/traps.h>
 #include <asm/stack_pointer.h>
 #include <asm/stacktrace.h>
@@ -56,6 +58,9 @@ static const char *handler[]= {
 
 int show_unhandled_signals = 1;
 
+/* Stashed ELR/SPSR pair for restoring after taking an SError during eret */
+DEFINE_PER_CPU(u64 [2], __exit_exception_regs);
+
 /*
  * Dump out the contents of some kernel memory nicely...
  */
@@ -696,7 +701,7 @@ static void do_serror_panic(struct pt_regs *regs, unsigned int esr)
 	nmi_panic(regs, "Asynchronous SError Interrupt");
 }
 
-static void _do_serror(struct pt_regs *regs, unsigned int esr)
+static void __kprobes _do_serror(struct pt_regs *regs, unsigned int esr)
 {
 	bool impdef_syndrome = esr & ESR_ELx_ISV;	/* aka IDS */
 	unsigned int aet = esr & ESR_ELx_AET;
@@ -718,9 +723,21 @@ static void _do_serror(struct pt_regs *regs, unsigned int esr)
 	default:
 		return do_serror_panic(regs, esr);
 	}
+
+	/*
+	 * If we took this SError during kernel_exit restore the ELR and SPSR.
+	 * We can only do this if the interrupted PC points into do_kernel_exit.
+	 * We can't return into do_kernel_exit code and restore the ELR and
+	 * SPSR, so instead we skip the rest of do_kernel_exit and unmask SError
+	 * and eret with the stashed values on our own return path.
+	 */
+	if (__is_kernel_exit(regs->pc)) {
+		regs->pc = this_cpu_read(__exit_exception_regs[0]);
+		regs->pstate = this_cpu_read(__exit_exception_regs[1]);
+	}
 }
 
-asmlinkage void do_serror(struct pt_regs *regs, unsigned int esr)
+asmlinkage void __kprobes do_serror(struct pt_regs *regs, unsigned int esr)
 {
 	nmi_enter();
 
@@ -729,7 +746,7 @@ asmlinkage void do_serror(struct pt_regs *regs, unsigned int esr)
 	nmi_exit();
 }
 
-asmlinkage void do_deferred_serror(struct pt_regs *regs, u64 disr)
+asmlinkage void __kprobes do_deferred_serror(struct pt_regs *regs, u64 disr)
 {
 	return do_serror(regs, disr_to_esr(disr));
 }
-- 
2.13.2
