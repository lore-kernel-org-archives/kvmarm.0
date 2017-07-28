From: James Morse <james.morse@arm.com>
Subject: [PATCH v2 05/16] arm64: entry.S: move enable_step_tsk into kernel_exit
Date: Fri, 28 Jul 2017 15:10:08 +0100
Message-ID: <20170728141019.9084-6-james.morse@arm.com>
References: <20170728141019.9084-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FCC849C30
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jul 2017 10:10:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AlSi5T5ckIT5 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Jul 2017 10:10:42 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B7C749C29
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jul 2017 10:10:41 -0400 (EDT)
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

enable_step_tsk may enable single-step, so needs to mask debug
exceptions to prevent us from single-stepping kernel_exit. This
should be the callers problem.

Earlier cleanup (2a2830703a23) moved disable_step_tsk into kernel_entry.
enable_step_tsk has two callers, both immediately before kernel_exit 0.
Move the macro call into kernel_exit after local_mask_daif.

enable_step_tsk is now only called with debug exceptions masked.
This was the last user of disable_dbg, remove it.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/assembler.h | 9 +--------
 arch/arm64/kernel/entry.S          | 7 ++++---
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 896ddd9b21a6..f4dc435406ea 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -70,13 +70,6 @@
 	msr	daif, \flags
 	.endm
 
-/*
- * Enable and disable debug exceptions.
- */
-	.macro	disable_dbg
-	msr	daifset, #8
-	.endm
-
 	.macro	enable_dbg
 	msr	daifclr, #8
 	.endm
@@ -90,9 +83,9 @@
 9990:
 	.endm
 
+	/* call with debug exceptions masked */
 	.macro	enable_step_tsk, flgs, tmp
 	tbz	\flgs, #TIF_SINGLESTEP, 9990f
-	disable_dbg
 	mrs	\tmp, mdscr_el1
 	orr	\tmp, \tmp, #1
 	msr	mdscr_el1, \tmp
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 491182f0abb5..0836b65d4c84 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -212,6 +212,10 @@ alternative_else_nop_endif
 	.if	\el == 0
 	ldr	x23, [sp, #S_SP]		// load return stack pointer
 	msr	sp_el0, x23
+
+	ldr	x1, [tsk, #TSK_TI_FLAGS]
+	enable_step_tsk flgs=x1, tmp=x2
+
 #ifdef CONFIG_ARM64_ERRATUM_845719
 alternative_if ARM64_WORKAROUND_845719
 	tbz	x22, #4, 1f
@@ -750,7 +754,6 @@ ret_fast_syscall:
 	cbnz	x2, ret_fast_syscall_trace
 	and	x2, x1, #_TIF_WORK_MASK
 	cbnz	x2, work_pending
-	enable_step_tsk x1, x2
 	kernel_exit 0
 ret_fast_syscall_trace:
 	enable_irq				// enable interrupts
@@ -765,7 +768,6 @@ work_pending:
 #ifdef CONFIG_TRACE_IRQFLAGS
 	bl	trace_hardirqs_on		// enabled while in userspace
 #endif
-	ldr	x1, [tsk, #TSK_TI_FLAGS]	// re-check for single-step
 	b	finish_ret_to_user
 /*
  * "slow" syscall return path.
@@ -776,7 +778,6 @@ ret_to_user:
 	and	x2, x1, #_TIF_WORK_MASK
 	cbnz	x2, work_pending
 finish_ret_to_user:
-	enable_step_tsk x1, x2
 	kernel_exit 0
 ENDPROC(ret_to_user)
 
-- 
2.13.2
