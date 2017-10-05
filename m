From: James Morse <james.morse@arm.com>
Subject: [PATCH v3 04/20] arm64: Mask all exceptions during kernel_exit
Date: Thu,  5 Oct 2017 20:17:56 +0100
Message-ID: <20171005191812.5678-5-james.morse@arm.com>
References: <20171005191812.5678-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3ED949D12
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Oct 2017 15:19:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DQUySd1OOPZ4 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Oct 2017 15:19:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA3A649D0E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Oct 2017 15:19:37 -0400 (EDT)
In-Reply-To: <20171005191812.5678-1-james.morse@arm.com>
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
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

To take RAS Exceptions as quickly as possible we need to keep SError
unmasked as much as possible. We need to mask it during kernel_exit
as taking an error from this code will overwrite the exception-registers.

Adding a naked 'disable_daif' to kernel_exit causes a performance problem
for micro-benchmarks that do no real work, (e.g. calling getpid() in a
loop). This is because the ret_to_user loop has already masked IRQs so
that the TIF_WORK_MASK thread flags can't change underneath it, adding
disable_daif is an additional self-synchronising operation.

In the future, the RAS APEI code may need to modify the TIF_WORK_MASK
flags from an SError, in which case the ret_to_user loop must mask SError
while it examines the flags.

Disable all exceptions for return to EL1. For return to EL0 get the
ret_to_user loop to leave all exceptions masked once it has done its
work, this avoids an extra pstate-write.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kernel/entry.S  | 10 +++++-----
 arch/arm64/kernel/signal.c |  8 ++++++--
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index e1c59d4008a8..f7d7bf9d76e7 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -221,6 +221,8 @@ alternative_else_nop_endif
 
 	.macro	kernel_exit, el
 	.if	\el != 0
+	disable_daif
+
 	/* Restore the task's original addr_limit. */
 	ldr	x20, [sp, #S_ORIG_ADDR_LIMIT]
 	str	x20, [tsk, #TSK_TI_ADDR_LIMIT]
@@ -517,8 +519,6 @@ el1_da:
 	mov	x2, sp				// struct pt_regs
 	bl	do_mem_abort
 
-	// disable interrupts before pulling preserved data off the stack
-	disable_irq
 	kernel_exit 1
 el1_sp_pc:
 	/*
@@ -793,7 +793,7 @@ ENDPROC(el0_irq)
  * and this includes saving x0 back into the kernel stack.
  */
 ret_fast_syscall:
-	disable_irq				// disable interrupts
+	disable_daif
 	str	x0, [sp, #S_X0]			// returned x0
 	ldr	x1, [tsk, #TSK_TI_FLAGS]	// re-check for syscall tracing
 	and	x2, x1, #_TIF_SYSCALL_WORK
@@ -803,7 +803,7 @@ ret_fast_syscall:
 	enable_step_tsk x1, x2
 	kernel_exit 0
 ret_fast_syscall_trace:
-	enable_irq				// enable interrupts
+	enable_daif
 	b	__sys_trace_return_skipped	// we already saved x0
 
 /*
@@ -821,7 +821,7 @@ work_pending:
  * "slow" syscall return path.
  */
 ret_to_user:
-	disable_irq				// disable interrupts
+	disable_daif
 	ldr	x1, [tsk, #TSK_TI_FLAGS]
 	and	x2, x1, #_TIF_WORK_MASK
 	cbnz	x2, work_pending
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 0bdc96c61bc0..b1fd14beb044 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -31,6 +31,7 @@
 #include <linux/ratelimit.h>
 #include <linux/syscalls.h>
 
+#include <asm/daifflags.h>
 #include <asm/debug-monitors.h>
 #include <asm/elf.h>
 #include <asm/cacheflush.h>
@@ -756,9 +757,12 @@ asmlinkage void do_notify_resume(struct pt_regs *regs,
 		addr_limit_user_check();
 
 		if (thread_flags & _TIF_NEED_RESCHED) {
+			/* Unmask Debug and SError for the next task */
+			local_restore_daif(DAIF_PROCCTX_NOIRQ);
+
 			schedule();
 		} else {
-			local_irq_enable();
+			local_restore_daif(DAIF_PROCCTX);
 
 			if (thread_flags & _TIF_UPROBE)
 				uprobe_notify_resume(regs);
@@ -775,7 +779,7 @@ asmlinkage void do_notify_resume(struct pt_regs *regs,
 				fpsimd_restore_current_state();
 		}
 
-		local_irq_disable();
+		local_mask_daif();
 		thread_flags = READ_ONCE(current_thread_info()->flags);
 	} while (thread_flags & _TIF_WORK_MASK);
 }
-- 
2.13.3
