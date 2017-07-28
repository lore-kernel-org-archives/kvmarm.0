From: James Morse <james.morse@arm.com>
Subject: [PATCH v2 06/16] arm64: entry.S: convert elX_sync
Date: Fri, 28 Jul 2017 15:10:09 +0100
Message-ID: <20170728141019.9084-7-james.morse@arm.com>
References: <20170728141019.9084-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 150E049C33
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jul 2017 10:10:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XgWUr9JZJ06m for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Jul 2017 10:10:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FB1049C30
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jul 2017 10:10:43 -0400 (EDT)
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

el1_sync unmasks exceptions on a case-by-case basis, debug exceptions
are unmasked, unless this was a debug exception. IRQs are unmasked
for instruction and data aborts only if the interrupted context had
irqs unmasked.

Following our 'adi' order, el1_dbg should run with Debug and Interrupt
exceptions masked. For the other cases we can inherit whatever we
interrupted.

Add a macro inherit_daif to set daif based on the interrupted pstate.

el0_sync also unmasks exceptions on a case-by-case basis, debug exceptions
are unmasked, unless this was a debug exception. Irqs are unmasked for
some exception types but not for others.

el0_dbg should run with Debug and Interrupt exceptions masked, for the
other cases we can unmask everything. This changes the behaviour of
fpsimd_{acc,exc} and el0_inv, which previously ran with Interrupts masked.

All of these el0 exception types call ct_user_exit after unmasking IRQs.
Move this into the switch statement. el0_dbg needs to do this itself once
it has finished its work and el0_svc needs to pass a flag to restore the
syscall args.

This patch removed the last user of enable_dbg_and_irq, remove it.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/assembler.h | 19 +++++------
 arch/arm64/kernel/entry.S          | 66 +++++++++++++-------------------------
 2 files changed, 33 insertions(+), 52 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index f4dc435406ea..6a2512da468a 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -50,6 +50,12 @@
 	msr	daif, \flags
 	.endm
 
+	/* Only on aarch64 pstate, PSR_D_BIT is different for aarch32 */
+	.macro	inherit_daif, pstate:req, tmp:req
+	and	\tmp, \pstate, #(PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
+	msr	daif, \tmp
+	.endm
+
 /*
  * Enable and disable interrupts.
  */
@@ -70,6 +76,10 @@
 	msr	daif, \flags
 	.endm
 
+	.macro	enable_serror
+	msr	daifclr, #4
+	.endm
+
 	.macro	enable_dbg
 	msr	daifclr, #8
 	.endm
@@ -93,15 +103,6 @@
 	.endm
 
 /*
- * Enable both debug exceptions and interrupts. This is likely to be
- * faster than two daifclr operations, since writes to this register
- * are self-synchronising.
- */
-	.macro	enable_dbg_and_irq
-	msr	daifclr, #(8 | 2)
-	.endm
-
-/*
  * SMP data memory barrier
  */
 	.macro	smp_dmb, opt
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 0836b65d4c84..51e704e46c29 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -408,8 +408,13 @@ ENDPROC(el1_error_invalid)
 	.align	6
 el1_sync:
 	kernel_entry 1
+	mrs	x0, far_el1
 	mrs	x1, esr_el1			// read the syndrome register
 	lsr	x24, x1, #ESR_ELx_EC_SHIFT	// exception class
+	cmp	x24, #ESR_ELx_EC_BREAKPT_CUR	// debug exception in EL1
+	b.ge	el1_dbg
+
+	inherit_daif	pstate=x23, tmp=x2
 	cmp	x24, #ESR_ELx_EC_DABT_CUR	// data abort in EL1
 	b.eq	el1_da
 	cmp	x24, #ESR_ELx_EC_IABT_CUR	// instruction abort in EL1
@@ -422,8 +427,6 @@ el1_sync:
 	b.eq	el1_sp_pc
 	cmp	x24, #ESR_ELx_EC_UNKNOWN	// unknown exception in EL1
 	b.eq	el1_undef
-	cmp	x24, #ESR_ELx_EC_BREAKPT_CUR	// debug exception in EL1
-	b.ge	el1_dbg
 	b	el1_inv
 
 el1_ia:
@@ -434,12 +437,7 @@ el1_da:
 	/*
 	 * Data abort handling
 	 */
-	mrs	x3, far_el1
-	enable_dbg
-	// re-enable interrupts if they were enabled in the aborted context
-	tbnz	x23, #7, 1f			// PSR_I_BIT
-	enable_irq
-1:
+	mov	x3, x0
 	clear_address_tag x0, x3
 	mov	x2, sp				// struct pt_regs
 	bl	do_mem_abort
@@ -449,31 +447,27 @@ el1_sp_pc:
 	/*
 	 * Stack or PC alignment exception handling
 	 */
-	mrs	x0, far_el1
-	enable_dbg
 	mov	x2, sp
 	b	do_sp_pc_abort
 el1_undef:
 	/*
 	 * Undefined instruction
 	 */
-	enable_dbg
 	mov	x0, sp
 	b	do_undefinstr
 el1_dbg:
 	/*
 	 * Debug exception handling
 	 */
+	enable_serror
 	cmp	x24, #ESR_ELx_EC_BRK64		// if BRK64
 	cinc	x24, x24, eq			// set bit '0'
 	tbz	x24, #0, el1_inv		// EL1 only
-	mrs	x0, far_el1
 	mov	x2, sp				// struct pt_regs
 	bl	do_debug_exception
 	kernel_exit 1
 el1_inv:
 	// TODO: add support for undefined instructions in kernel mode
-	enable_dbg
 	mov	x0, sp
 	mov	x2, x1
 	mov	x1, #BAD_SYNC
@@ -520,9 +514,16 @@ el1_preempt:
 el0_sync:
 	kernel_entry 0
 	mrs	x25, esr_el1			// read the syndrome register
+	mrs	x26, far_el1
 	lsr	x24, x25, #ESR_ELx_EC_SHIFT	// exception class
+	cmp	x24, #ESR_ELx_EC_BREAKPT_LOW	// debug exception in EL0
+	b.ge	el0_dbg
+
+	enable_daif
 	cmp	x24, #ESR_ELx_EC_SVC64		// SVC in 64-bit state
 	b.eq	el0_svc
+
+	ct_user_exit
 	cmp	x24, #ESR_ELx_EC_DABT_LOW	// data abort in EL0
 	b.eq	el0_da
 	cmp	x24, #ESR_ELx_EC_IABT_LOW	// instruction abort in EL0
@@ -539,8 +540,6 @@ el0_sync:
 	b.eq	el0_sp_pc
 	cmp	x24, #ESR_ELx_EC_UNKNOWN	// unknown exception in EL0
 	b.eq	el0_undef
-	cmp	x24, #ESR_ELx_EC_BREAKPT_LOW	// debug exception in EL0
-	b.ge	el0_dbg
 	b	el0_inv
 
 #ifdef CONFIG_COMPAT
@@ -548,9 +547,16 @@ el0_sync:
 el0_sync_compat:
 	kernel_entry 0, 32
 	mrs	x25, esr_el1			// read the syndrome register
+	mrs	x26, far_el1
 	lsr	x24, x25, #ESR_ELx_EC_SHIFT	// exception class
+	cmp	x24, #ESR_ELx_EC_BREAKPT_LOW	// debug exception in EL0
+	b.ge	el0_dbg
+
+	enable_daif
 	cmp	x24, #ESR_ELx_EC_SVC32		// SVC in 32-bit state
 	b.eq	el0_svc_compat
+
+	ct_user_exit
 	cmp	x24, #ESR_ELx_EC_DABT_LOW	// data abort in EL0
 	b.eq	el0_da
 	cmp	x24, #ESR_ELx_EC_IABT_LOW	// instruction abort in EL0
@@ -573,8 +579,6 @@ el0_sync_compat:
 	b.eq	el0_undef
 	cmp	x24, #ESR_ELx_EC_CP14_64	// CP14 MRRC/MCRR trap
 	b.eq	el0_undef
-	cmp	x24, #ESR_ELx_EC_BREAKPT_LOW	// debug exception in EL0
-	b.ge	el0_dbg
 	b	el0_inv
 el0_svc_compat:
 	/*
@@ -595,10 +599,6 @@ el0_da:
 	/*
 	 * Data abort handling
 	 */
-	mrs	x26, far_el1
-	// enable interrupts before calling the main handler
-	enable_dbg_and_irq
-	ct_user_exit
 	clear_address_tag x0, x26
 	mov	x1, x25
 	mov	x2, sp
@@ -608,10 +608,6 @@ el0_ia:
 	/*
 	 * Instruction abort handling
 	 */
-	mrs	x26, far_el1
-	// enable interrupts before calling the main handler
-	enable_dbg_and_irq
-	ct_user_exit
 	mov	x0, x26
 	mov	x1, x25
 	mov	x2, sp
@@ -621,8 +617,6 @@ el0_fpsimd_acc:
 	/*
 	 * Floating Point or Advanced SIMD access
 	 */
-	enable_dbg
-	ct_user_exit
 	mov	x0, x25
 	mov	x1, sp
 	bl	do_fpsimd_acc
@@ -631,8 +625,6 @@ el0_fpsimd_exc:
 	/*
 	 * Floating Point or Advanced SIMD exception
 	 */
-	enable_dbg
-	ct_user_exit
 	mov	x0, x25
 	mov	x1, sp
 	bl	do_fpsimd_exc
@@ -641,10 +633,6 @@ el0_sp_pc:
 	/*
 	 * Stack or PC alignment exception handling
 	 */
-	mrs	x26, far_el1
-	// enable interrupts before calling the main handler
-	enable_dbg_and_irq
-	ct_user_exit
 	mov	x0, x26
 	mov	x1, x25
 	mov	x2, sp
@@ -654,9 +642,6 @@ el0_undef:
 	/*
 	 * Undefined instruction
 	 */
-	// enable interrupts before calling the main handler
-	enable_dbg_and_irq
-	ct_user_exit
 	mov	x0, sp
 	bl	do_undefinstr
 	b	ret_to_user
@@ -664,8 +649,6 @@ el0_sys:
 	/*
 	 * System instructions, for trapped cache maintenance instructions
 	 */
-	enable_dbg_and_irq
-	ct_user_exit
 	mov	x0, x25
 	mov	x1, sp
 	bl	do_sysinstr
@@ -675,16 +658,14 @@ el0_dbg:
 	 * Debug exception handling
 	 */
 	tbnz	x24, #0, el0_inv		// EL0 only
-	mrs	x0, far_el1
+	mov	x0, x26
 	mov	x1, x25
 	mov	x2, sp
 	bl	do_debug_exception
-	enable_dbg
+	enable_daif
 	ct_user_exit
 	b	ret_to_user
 el0_inv:
-	enable_dbg
-	ct_user_exit
 	mov	x0, sp
 	mov	x1, #BAD_SYNC
 	mov	x2, x25
@@ -803,7 +784,6 @@ el0_svc:
 	mov	sc_nr, #__NR_syscalls
 el0_svc_naked:					// compat entry point
 	stp	x0, scno, [sp, #S_ORIG_X0]	// save the original x0 and syscall number
-	enable_dbg_and_irq
 	ct_user_exit 1
 
 	ldr	x16, [tsk, #TSK_TI_FLAGS]	// check for syscall hooks
-- 
2.13.2
