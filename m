From: James Morse <james.morse@arm.com>
Subject: [PATCH v2 11/16] arm64: kernel: Handle deferred SError on kernel entry
Date: Fri, 28 Jul 2017 15:10:14 +0100
Message-ID: <20170728141019.9084-12-james.morse@arm.com>
References: <20170728141019.9084-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE47D40CE9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jul 2017 10:10:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HAMAVNG00zpZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Jul 2017 10:10:56 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 575B949C25
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jul 2017 10:10:56 -0400 (EDT)
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

Before we can enable Implicit ESB on exception level change, we need to
handle deferred SErrors that may appear on exception entry.

Add code to kernel_entry to synchronize errors then read and clear
DISR_EL1. Call do_deferred_serror() if it had a non-zero value.
(The IESB feature will allow this explicit ESB to be removed)

These checks are needed in the SError vector too, as we may take a pending
SError that was signalled by a device, and on entry to EL1 synchronize
then defer a RAS SError that hadn't yet been made pending. We process the
'taken' SError first as it is more likely to be fatal.

Clear DISR_EL1 from the RAS cpufeature enable call. This means any value
we find in DISR_EL1 was triggered and deferred by our actions. We have
executed ESB prior to this point, but these occur with SError unmasked so
will not have been deferred.

Signed-off-by: James Morse <james.morse@arm.com>
---
Remove the 'x21  aborted SP' line from entry.S - its not true.

 arch/arm64/include/asm/assembler.h | 23 ++++++++++++
 arch/arm64/include/asm/esr.h       |  7 ++++
 arch/arm64/include/asm/exception.h | 14 ++++++++
 arch/arm64/include/asm/processor.h |  1 +
 arch/arm64/include/asm/sysreg.h    |  1 +
 arch/arm64/kernel/cpufeature.c     |  9 +++++
 arch/arm64/kernel/entry.S          | 73 ++++++++++++++++++++++++++++++++------
 arch/arm64/kernel/traps.c          |  5 +++
 8 files changed, 122 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index a013ab05210d..e2bb551f59f7 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -110,6 +110,13 @@
 	.endm
 
 /*
+ * RAS Error Synchronization barrier
+ */
+	.macro	esb
+	hint	#16
+	.endm
+
+/*
  * NOP sequence
  */
 	.macro	nops, num
@@ -455,6 +462,22 @@ alternative_endif
 	.endm
 
 /*
+ * Read and clear DISR if supported
+ */
+	.macro disr_read, reg
+	alternative_if ARM64_HAS_RAS_EXTN
+	mrs_s	\reg, SYS_DISR_EL1
+	cbz	\reg, 99f
+	msr_s	SYS_DISR_EL1, xzr
+99:
+	alternative_else
+	mov	\reg,	xzr
+	nop
+	nop
+	alternative_endif
+	.endm
+
+/*
  * Errata workaround prior to TTBR0_EL1 update
  *
  * 	val:	TTBR value with new BADDR, preserved
diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 77d5b1baf1a4..41a0767e2600 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -124,6 +124,13 @@
 #define ESR_ELx_WFx_ISS_WFE	(UL(1) << 0)
 #define ESR_ELx_xVC_IMM_MASK	((1UL << 16) - 1)
 
+#define DISR_EL1_IDS		 (UL(1) << 24)
+/*
+ * DISR_EL1 and ESR_ELx share the bottom 13 bits, but the RES0 bits may mean
+ * different things in the future...
+ */
+#define DISR_EL1_ESR_MASK	(ESR_ELx_AET | ESR_ELx_EA | ESR_ELx_FSC)
+
 /* ESR value templates for specific events */
 
 /* BRK instruction trap from AArch64 state */
diff --git a/arch/arm64/include/asm/exception.h b/arch/arm64/include/asm/exception.h
index 0c2eec490abf..bc30429d8e91 100644
--- a/arch/arm64/include/asm/exception.h
+++ b/arch/arm64/include/asm/exception.h
@@ -18,6 +18,8 @@
 #ifndef __ASM_EXCEPTION_H
 #define __ASM_EXCEPTION_H
 
+#include <asm/esr.h>
+
 #include <linux/interrupt.h>
 
 #define __exception	__attribute__((section(".exception.text")))
@@ -27,4 +29,16 @@
 #define __exception_irq_entry	__exception
 #endif
 
+static inline u32 disr_to_esr(u64 disr)
+{
+	unsigned int esr = ESR_ELx_EC_SERROR << ESR_ELx_EC_SHIFT;
+
+	if ((disr & DISR_EL1_IDS) == 0)
+		esr |= (disr & DISR_EL1_ESR_MASK);
+	else
+		esr |= (disr & ESR_ELx_ISS_MASK);
+
+	return esr;
+}
+
 #endif	/* __ASM_EXCEPTION_H */
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 64c9e78f9882..82e8ff01153d 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -193,5 +193,6 @@ static inline void spin_lock_prefetch(const void *ptr)
 
 int cpu_enable_pan(void *__unused);
 int cpu_enable_cache_maint_trap(void *__unused);
+int cpu_clear_disr(void *__unused);
 
 #endif /* __ASM_PROCESSOR_H */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 58358acf7c9b..18cabd92af22 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -179,6 +179,7 @@
 #define SYS_AMAIR_EL1			sys_reg(3, 0, 10, 3, 0)
 
 #define SYS_VBAR_EL1			sys_reg(3, 0, 12, 0, 0)
+#define SYS_DISR_EL1			sys_reg(3, 0, 12, 1,  1)
 
 #define SYS_ICC_IAR0_EL1		sys_reg(3, 0, 12, 8, 0)
 #define SYS_ICC_EOIR0_EL1		sys_reg(3, 0, 12, 8, 1)
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index a807ab55ee10..6dbefe401dc4 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -899,6 +899,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.sign = FTR_UNSIGNED,
 		.field_pos = ID_AA64PFR0_RAS_SHIFT,
 		.min_field_value = ID_AA64PFR0_RAS_V1,
+		.enable = cpu_clear_disr,
 	},
 #endif /* CONFIG_ARM64_RAS_EXTN */
 	{},
@@ -1308,3 +1309,11 @@ static int __init enable_mrs_emulation(void)
 }
 
 late_initcall(enable_mrs_emulation);
+
+int cpu_clear_disr(void *__unused)
+{
+	/* Firmware may have left a deferred SError in this register. */
+	write_sysreg_s(0, SYS_DISR_EL1);
+
+	return 0;
+}
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 9e63f69e1366..8cdfca4060e3 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -34,6 +34,18 @@
 #include <asm/asm-uaccess.h>
 #include <asm/unistd.h>
 
+
+	/*
+	 * Restore syscall arguments from the values already saved on stack
+	 * during kernel_entry.
+	 */
+	.macro restore_syscall_args
+	ldp	x0, x1, [sp]
+	ldp	x2, x3, [sp, #S_X2]
+	ldp	x4, x5, [sp, #S_X4]
+	ldp	x6, x7, [sp, #S_X6]
+	.endm
+
 /*
  * Context tracking subsystem.  Used to instrument transitions
  * between user and kernel mode.
@@ -42,14 +54,8 @@
 #ifdef CONFIG_CONTEXT_TRACKING
 	bl	context_tracking_user_exit
 	.if \syscall == 1
-	/*
-	 * Save/restore needed during syscalls.  Restore syscall arguments from
-	 * the values already saved on stack during kernel_entry.
-	 */
-	ldp	x0, x1, [sp]
-	ldp	x2, x3, [sp, #S_X2]
-	ldp	x4, x5, [sp, #S_X4]
-	ldp	x6, x7, [sp, #S_X6]
+	/* Save/restore needed during syscalls. */
+	restore_syscall_args
 	.endif
 #endif
 	.endm
@@ -153,10 +159,13 @@ alternative_else_nop_endif
 	msr	sp_el0, tsk
 	.endif
 
+	esb
+	disr_read reg=x15
+
 	/*
 	 * Registers that may be useful after this macro is invoked:
 	 *
-	 * x21 - aborted SP
+	 * x15 - Deferred Interrupt Status value
 	 * x22 - aborted PC
 	 * x23 - aborted PSTATE
 	*/
@@ -312,6 +321,31 @@ tsk	.req	x28		// current thread_info
 	irq_stack_exit
 	.endm
 
+/* Handle any non-zero DISR value if supported.
+ *
+ * @reg     the register holding DISR
+ * @syscall whether the syscall args should be restored if we call
+ *          do_deferred_serror (default: no)
+ */
+	.macro disr_check	reg, syscall = 0
+#ifdef CONFIG_ARM64_RAS_EXTN
+alternative_if_not ARM64_HAS_RAS_EXTN
+	b	9998f
+alternative_else_nop_endif
+	cbz	\reg, 9998f
+
+	mov	x1, \reg
+	mov	x0, sp
+	bl	do_deferred_serror
+
+	.if \syscall == 1
+	restore_syscall_args
+	.endif
+9998:
+#endif /* CONFIG_ARM64_RAS_EXTN */
+	.endm
+
+
 	.text
 
 /*
@@ -404,8 +438,12 @@ ENDPROC(el1_error_invalid)
 	.align	6
 el1_sync:
 	kernel_entry 1
-	mrs	x0, far_el1
-	mrs	x1, esr_el1			// read the syndrome register
+	mrs	x26, far_el1
+	mrs	x25, esr_el1			// read the syndrome register
+	disr_check	reg=x15
+	mov	x0, x26
+	mov	x1, x25
+
 	lsr	x24, x1, #ESR_ELx_EC_SHIFT	// exception class
 	cmp	x24, #ESR_ELx_EC_BREAKPT_CUR	// debug exception in EL1
 	b.ge	el1_dbg
@@ -461,6 +499,7 @@ el1_dbg:
 	tbz	x24, #0, el1_inv		// EL1 only
 	mov	x2, sp				// struct pt_regs
 	bl	do_debug_exception
+
 	kernel_exit 1
 el1_inv:
 	// TODO: add support for undefined instructions in kernel mode
@@ -473,6 +512,7 @@ ENDPROC(el1_sync)
 	.align	6
 el1_irq:
 	kernel_entry 1
+	disr_check	reg=x15
 	enable_da_f
 #ifdef CONFIG_TRACE_IRQFLAGS
 	bl	trace_hardirqs_off
@@ -511,6 +551,8 @@ el0_sync:
 	kernel_entry 0
 	mrs	x25, esr_el1			// read the syndrome register
 	mrs	x26, far_el1
+	disr_check	reg=x15, syscall=1
+
 	lsr	x24, x25, #ESR_ELx_EC_SHIFT	// exception class
 	cmp	x24, #ESR_ELx_EC_BREAKPT_LOW	// debug exception in EL0
 	b.ge	el0_dbg
@@ -544,6 +586,8 @@ el0_sync_compat:
 	kernel_entry 0, 32
 	mrs	x25, esr_el1			// read the syndrome register
 	mrs	x26, far_el1
+	disr_check	reg=x15, syscall=1
+
 	lsr	x24, x25, #ESR_ELx_EC_SHIFT	// exception class
 	cmp	x24, #ESR_ELx_EC_BREAKPT_LOW	// debug exception in EL0
 	b.ge	el0_dbg
@@ -677,6 +721,7 @@ ENDPROC(el0_sync)
 el0_irq:
 	kernel_entry 0
 el0_irq_naked:
+	disr_check	reg=x15
 	enable_da_f
 #ifdef CONFIG_TRACE_IRQFLAGS
 	bl	trace_hardirqs_off
@@ -693,18 +738,24 @@ ENDPROC(el0_irq)
 
 el1_serror:
 	kernel_entry 1
+	mov	x20, x15
 	mrs	x1, esr_el1
 	mov	x0, sp
 	bl	do_serror
+
+	disr_check	reg=x20
 	kernel_exit 1
 ENDPROC(el1_serror)
 
 el0_serror:
 	kernel_entry 0
 el0_serror_naked:
+	mov	x20, x15
 	mrs	x1, esr_el1
 	mov	x0, sp
 	bl	do_serror
+
+	disr_check	reg=x20
 	enable_daif
 	ct_user_exit
 	b	ret_to_user
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index e1eaccc66548..27ebcaa2f0b6 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -729,6 +729,11 @@ asmlinkage void do_serror(struct pt_regs *regs, unsigned int esr)
 	nmi_exit();
 }
 
+asmlinkage void do_deferred_serror(struct pt_regs *regs, u64 disr)
+{
+	return do_serror(regs, disr_to_esr(disr));
+}
+
 void __pte_error(const char *file, int line, unsigned long val)
 {
 	pr_err("%s:%d: bad pte %016lx.\n", file, line, val);
-- 
2.13.2
