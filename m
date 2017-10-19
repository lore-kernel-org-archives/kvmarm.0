From: James Morse <james.morse@arm.com>
Subject: [PATCH v4 07/21] arm64: entry.S convert el0_sync
Date: Thu, 19 Oct 2017 15:57:53 +0100
Message-ID: <20171019145807.23251-8-james.morse@arm.com>
References: <20171019145807.23251-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 653A749D21
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Oct 2017 10:59:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Py3HP+xh6EF1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Oct 2017 10:59:09 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22B8C49D1A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Oct 2017 10:59:08 -0400 (EDT)
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

el0_sync also unmasks exceptions on a case-by-case basis, debug exceptions
are enabled, unless this was a debug exception. Irqs are unmasked for
some exception types but not for others.

el0_dbg should run with everything masked to prevent us taking a debug
exception from do_debug_exception. For the other cases we can unmask
everything. This changes the behaviour of fpsimd_{acc,exc} and el0_inv
which previously ran with irqs masked.

This patch removed the last user of enable_dbg_and_irq, remove it.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/assembler.h |  9 ---------
 arch/arm64/kernel/entry.S          | 24 ++++++++++--------------
 2 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index abb5abd61ddb..c2a37e2f733c 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -97,15 +97,6 @@
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
index bd54115972a4..f7dfe5d2b1fb 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -670,8 +670,7 @@ el0_da:
 	 * Data abort handling
 	 */
 	mrs	x26, far_el1
-	// enable interrupts before calling the main handler
-	enable_dbg_and_irq
+	enable_daif
 	ct_user_exit
 	clear_address_tag x0, x26
 	mov	x1, x25
@@ -683,8 +682,7 @@ el0_ia:
 	 * Instruction abort handling
 	 */
 	mrs	x26, far_el1
-	// enable interrupts before calling the main handler
-	enable_dbg_and_irq
+	enable_daif
 	ct_user_exit
 	mov	x0, x26
 	mov	x1, x25
@@ -695,7 +693,7 @@ el0_fpsimd_acc:
 	/*
 	 * Floating Point or Advanced SIMD access
 	 */
-	enable_dbg
+	enable_daif
 	ct_user_exit
 	mov	x0, x25
 	mov	x1, sp
@@ -705,7 +703,7 @@ el0_fpsimd_exc:
 	/*
 	 * Floating Point or Advanced SIMD exception
 	 */
-	enable_dbg
+	enable_daif
 	ct_user_exit
 	mov	x0, x25
 	mov	x1, sp
@@ -716,8 +714,7 @@ el0_sp_pc:
 	 * Stack or PC alignment exception handling
 	 */
 	mrs	x26, far_el1
-	// enable interrupts before calling the main handler
-	enable_dbg_and_irq
+	enable_daif
 	ct_user_exit
 	mov	x0, x26
 	mov	x1, x25
@@ -728,8 +725,7 @@ el0_undef:
 	/*
 	 * Undefined instruction
 	 */
-	// enable interrupts before calling the main handler
-	enable_dbg_and_irq
+	enable_daif
 	ct_user_exit
 	mov	x0, sp
 	bl	do_undefinstr
@@ -738,7 +734,7 @@ el0_sys:
 	/*
 	 * System instructions, for trapped cache maintenance instructions
 	 */
-	enable_dbg_and_irq
+	enable_daif
 	ct_user_exit
 	mov	x0, x25
 	mov	x1, sp
@@ -753,11 +749,11 @@ el0_dbg:
 	mov	x1, x25
 	mov	x2, sp
 	bl	do_debug_exception
-	enable_dbg
+	enable_daif
 	ct_user_exit
 	b	ret_to_user
 el0_inv:
-	enable_dbg
+	enable_daif
 	ct_user_exit
 	mov	x0, sp
 	mov	x1, #BAD_SYNC
@@ -836,7 +832,7 @@ el0_svc:
 	mov	wsc_nr, #__NR_syscalls
 el0_svc_naked:					// compat entry point
 	stp	x0, xscno, [sp, #S_ORIG_X0]	// save the original x0 and syscall number
-	enable_dbg_and_irq
+	enable_daif
 	ct_user_exit 1
 
 	ldr	x16, [tsk, #TSK_TI_FLAGS]	// check for syscall hooks
-- 
2.13.3
