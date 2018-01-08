From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v6 16/16] arm64: sdei: Add trampoline code for remapping the kernel
Date: Mon,  8 Jan 2018 15:38:18 +0000
Message-ID: <20180108153818.22743-17-james.morse@arm.com>
References: <20180108153818.22743-1-james.morse@arm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108153818.22743-1-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, Heyi Guo <guoheyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

When CONFIG_UNMAP_KERNEL_AT_EL0 is set the SDEI entry point and the rest
of the kernel may be unmapped when we take an event. If this may be the
case, use an entry trampoline that can switch to the kernel page tables.

We can't use the provided PSTATE to determine whether to switch page
tables as we may have interrupted the kernel's entry trampoline, (or a
normal-priority event that interrupted the kernel's entry trampoline).
Instead test for a user ASID in ttbr1_el1.

Save a value in regs->addr_limit to indicate whether we need to restore
the original ASID when returning from this event. This value is only used
by do_page_fault(), which we don't call with the SDEI regs.

Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
---
Changes since v5:
 * spelling mistake in subject

 arch/arm64/include/asm/mmu.h  |  3 +-
 arch/arm64/include/asm/sdei.h |  6 +++
 arch/arm64/kernel/entry.S     | 98 ++++++++++++++++++++++++++++++++++++++-----
 arch/arm64/kernel/sdei.c      | 20 ++++++++-
 4 files changed, 113 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 6dd83d75b82a..a050d4f3615d 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -17,7 +17,8 @@
 #define __ASM_MMU_H
 
 #define MMCF_AARCH32	0x1	/* mm context flag for AArch32 executables */
-#define USER_ASID_FLAG	(UL(1) << 48)
+#define USER_ASID_BIT	48
+#define USER_ASID_FLAG	(UL(1) << USER_ASID_BIT)
 #define TTBR_ASID_MASK	(UL(0xffff) << 48)
 
 #ifndef __ASSEMBLY__
diff --git a/arch/arm64/include/asm/sdei.h b/arch/arm64/include/asm/sdei.h
index d58a31ab525a..e073e6886685 100644
--- a/arch/arm64/include/asm/sdei.h
+++ b/arch/arm64/include/asm/sdei.h
@@ -23,6 +23,12 @@ extern unsigned long sdei_exit_mode;
 asmlinkage void __sdei_asm_handler(unsigned long event_num, unsigned long arg,
 				   unsigned long pc, unsigned long pstate);
 
+/* and its CONFIG_UNMAP_KERNEL_AT_EL0 trampoline */
+asmlinkage void __sdei_asm_entry_trampoline(unsigned long event_num,
+						   unsigned long arg,
+						   unsigned long pc,
+						   unsigned long pstate);
+
 /*
  * The above entry point does the minimum to call C code. This function does
  * anything else, before calling the driver.
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 3d26650ef1ef..84ef12b0defa 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -1156,6 +1156,78 @@ NOKPROBE(ret_from_fork)
 #include <asm/sdei.h>
 #include <uapi/linux/arm_sdei.h>
 
+.macro sdei_handler_exit exit_mode
+	/* On success, this call never returns... */
+	cmp	\exit_mode, #SDEI_EXIT_SMC
+	b.ne	99f
+	smc	#0
+	b	.
+99:	hvc	#0
+	b	.
+.endm
+
+#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
+/*
+ * The regular SDEI entry point may have been unmapped along with the rest of
+ * the kernel. This trampoline restores the kernel mapping to make the x1 memory
+ * argument accessible.
+ *
+ * This clobbers x4, __sdei_handler() will restore this from firmware's
+ * copy.
+ */
+.ltorg
+.pushsection ".entry.tramp.text", "ax"
+ENTRY(__sdei_asm_entry_trampoline)
+	mrs	x4, ttbr1_el1
+	tbz	x4, #USER_ASID_BIT, 1f
+
+	tramp_map_kernel tmp=x4
+	isb
+	mov	x4, xzr
+
+	/*
+	 * Use reg->interrupted_regs.addr_limit to remember whether to unmap
+	 * the kernel on exit.
+	 */
+1:	str	x4, [x1, #(SDEI_EVENT_INTREGS + S_ORIG_ADDR_LIMIT)]
+
+#ifdef CONFIG_RANDOMIZE_BASE
+	adr	x4, tramp_vectors + PAGE_SIZE
+	add	x4, x4, #:lo12:__sdei_asm_trampoline_next_handler
+	ldr	x4, [x4]
+#else
+	ldr	x4, =__sdei_asm_handler
+#endif
+	br	x4
+ENDPROC(__sdei_asm_entry_trampoline)
+NOKPROBE(__sdei_asm_entry_trampoline)
+
+/*
+ * Make the exit call and restore the original ttbr1_el1
+ *
+ * x0 & x1: setup for the exit API call
+ * x2: exit_mode
+ * x4: struct sdei_registered_event argument from registration time.
+ */
+ENTRY(__sdei_asm_exit_trampoline)
+	ldr	x4, [x4, #(SDEI_EVENT_INTREGS + S_ORIG_ADDR_LIMIT)]
+	cbnz	x4, 1f
+
+	tramp_unmap_kernel	tmp=x4
+
+1:	sdei_handler_exit exit_mode=x2
+ENDPROC(__sdei_asm_exit_trampoline)
+NOKPROBE(__sdei_asm_exit_trampoline)
+	.ltorg
+.popsection		// .entry.tramp.text
+#ifdef CONFIG_RANDOMIZE_BASE
+.pushsection ".rodata", "a"
+__sdei_asm_trampoline_next_handler:
+	.quad	__sdei_asm_handler
+.popsection		// .rodata
+#endif /* CONFIG_RANDOMIZE_BASE */
+#endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
+
 /*
  * Software Delegated Exception entry point.
  *
@@ -1163,6 +1235,7 @@ NOKPROBE(ret_from_fork)
  * x1: struct sdei_registered_event argument from registration time.
  * x2: interrupted PC
  * x3: interrupted PSTATE
+ * x4: maybe clobbered by the trampoline
  *
  * Firmware has preserved x0->x17 for us, we must save/restore the rest to
  * follow SMC-CC. We save (or retrieve) all the registers as the handler may
@@ -1228,10 +1301,11 @@ ENTRY(__sdei_asm_handler)
 
 	msr	sp_el0, x28
 	/* restore regs >x17 that we clobbered */
-	ldp     x28, x29, [x19, #SDEI_EVENT_INTREGS + 16 * 14]
-	ldp     lr, x4, [x19, #SDEI_EVENT_INTREGS + S_LR]
-	mov	sp, x4
-	ldp     x18, x19, [x19, #SDEI_EVENT_INTREGS + 16 * 9]
+	mov	x4, x19         // keep x4 for __sdei_asm_exit_trampoline
+	ldp	x28, x29, [x4, #SDEI_EVENT_INTREGS + 16 * 14]
+	ldp	x18, x19, [x4, #SDEI_EVENT_INTREGS + 16 * 9]
+	ldp	lr, x1, [x4, #SDEI_EVENT_INTREGS + S_LR]
+	mov	sp, x1
 
 	mov	x1, x0			// address to complete_and_resume
 	/* x0 = (x0 <= 1) ? EVENT_COMPLETE:EVENT_COMPLETE_AND_RESUME */
@@ -1240,14 +1314,16 @@ ENTRY(__sdei_asm_handler)
 	mov_q	x3, SDEI_1_0_FN_SDEI_EVENT_COMPLETE_AND_RESUME
 	csel	x0, x2, x3, ls
 
-	/* On success, this call never returns... */
 	ldr_l	x2, sdei_exit_mode
-	cmp	x2, #SDEI_EXIT_SMC
-	b.ne	1f
-	smc	#0
-	b	.
-1:	hvc	#0
-	b	.
+
+alternative_if_not ARM64_UNMAP_KERNEL_AT_EL0
+	sdei_handler_exit exit_mode=x2
+alternative_else_nop_endif
+
+#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
+	tramp_alias	dst=x5, sym=__sdei_asm_exit_trampoline
+	br	x5
+#endif
 ENDPROC(__sdei_asm_handler)
 NOKPROBE(__sdei_asm_handler)
 #endif /* CONFIG_ARM_SDE_INTERFACE */
diff --git a/arch/arm64/kernel/sdei.c b/arch/arm64/kernel/sdei.c
index f9dffacaa5d6..6b8d90d5ceae 100644
--- a/arch/arm64/kernel/sdei.c
+++ b/arch/arm64/kernel/sdei.c
@@ -10,7 +10,9 @@
 
 #include <asm/alternative.h>
 #include <asm/kprobes.h>
+#include <asm/mmu.h>
 #include <asm/ptrace.h>
+#include <asm/sections.h>
 #include <asm/sysreg.h>
 #include <asm/vmap_stack.h>
 
@@ -124,7 +126,18 @@ unsigned long sdei_arch_get_entry_point(int conduit)
 	}
 
 	sdei_exit_mode = (conduit == CONDUIT_HVC) ? SDEI_EXIT_HVC : SDEI_EXIT_SMC;
-	return (unsigned long)__sdei_asm_handler;
+
+#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
+	if (arm64_kernel_unmapped_at_el0()) {
+		unsigned long offset;
+
+		offset = (unsigned long)__sdei_asm_entry_trampoline -
+			 (unsigned long)__entry_tramp_text_start;
+		return TRAMP_VALIAS + offset;
+	} else
+#endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
+		return (unsigned long)__sdei_asm_handler;
+
 }
 
 /*
@@ -138,11 +151,14 @@ static __kprobes unsigned long _sdei_handler(struct pt_regs *regs,
 {
 	u32 mode;
 	int i, err = 0;
-	const int clobbered_registers = 4;
+	int clobbered_registers = 4;
 	u64 elr = read_sysreg(elr_el1);
 	u32 kernel_mode = read_sysreg(CurrentEL) | 1;	/* +SPSel */
 	unsigned long vbar = read_sysreg(vbar_el1);
 
+	if (arm64_kernel_unmapped_at_el0())
+		clobbered_registers++;
+
 	/* Retrieve the missing registers values */
 	for (i = 0; i < clobbered_registers; i++) {
 		/* from within the handler, this call always succeeds */
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
