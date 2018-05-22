From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v10 06/18] arm64: fpsimd: Generalise context saving for
 non-task contexts
Date: Tue, 22 May 2018 17:05:07 +0100
Message-ID: <1527005119-6842-7-git-send-email-Dave.Martin@arm.com>
References: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 912D24A107
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 May 2018 11:56:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cVN6WZBgglRc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 May 2018 11:56:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BB784A109
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 May 2018 11:55:41 -0400 (EDT)
In-Reply-To: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

In preparation for allowing non-task (i.e., KVM vcpu) FPSIMD
contexts to be handled by the fpsimd common code, this patch adapts
task_fpsimd_save() to save back the currently loaded context,
removing the explicit dependency on current.

The relevant storage to write back to in memory is now found by
examining the fpsimd_last_state percpu struct.

fpsimd_save() does nothing unless TIF_FOREIGN_FPSTATE is clear, and
fpsimd_last_state is updated under local_bh_disable() or
local_irq_disable() everywhere that TIF_FOREIGN_FPSTATE is cleared:
thus, fpsimd_save() will write back to the correct storage for the
loaded context.

No functional change.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/kernel/fpsimd.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 9d85373..3aa100a 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -270,13 +270,15 @@ static void task_fpsimd_load(void)
 }
 
 /*
- * Ensure current's FPSIMD/SVE storage in thread_struct is up to date
- * with respect to the CPU registers.
+ * Ensure FPSIMD/SVE storage in memory for the loaded context is up to
+ * date with respect to the CPU registers.
  *
  * Softirqs (and preemption) must be disabled.
  */
-static void task_fpsimd_save(void)
+static void fpsimd_save(void)
 {
+	struct user_fpsimd_state *st = __this_cpu_read(fpsimd_last_state.st);
+
 	WARN_ON(!in_softirq() && !irqs_disabled());
 
 	if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
@@ -291,10 +293,9 @@ static void task_fpsimd_save(void)
 				return;
 			}
 
-			sve_save_state(sve_pffr(current),
-				       &current->thread.uw.fpsimd_state.fpsr);
+			sve_save_state(sve_pffr(current), &st->fpsr);
 		} else
-			fpsimd_save_state(&current->thread.uw.fpsimd_state);
+			fpsimd_save_state(st);
 	}
 }
 
@@ -598,7 +599,7 @@ int sve_set_vector_length(struct task_struct *task,
 	if (task == current) {
 		local_bh_disable();
 
-		task_fpsimd_save();
+		fpsimd_save();
 		set_thread_flag(TIF_FOREIGN_FPSTATE);
 	}
 
@@ -837,7 +838,7 @@ asmlinkage void do_sve_acc(unsigned int esr, struct pt_regs *regs)
 
 	local_bh_disable();
 
-	task_fpsimd_save();
+	fpsimd_save();
 	fpsimd_to_sve(current);
 
 	/* Force ret_to_user to reload the registers: */
@@ -898,7 +899,7 @@ void fpsimd_thread_switch(struct task_struct *next)
 	 * 'current'.
 	 */
 	if (current->mm)
-		task_fpsimd_save();
+		fpsimd_save();
 
 	if (next->mm) {
 		/*
@@ -980,7 +981,7 @@ void fpsimd_preserve_current_state(void)
 		return;
 
 	local_bh_disable();
-	task_fpsimd_save();
+	fpsimd_save();
 	local_bh_enable();
 }
 
@@ -1121,7 +1122,7 @@ void kernel_neon_begin(void)
 
 	/* Save unsaved task fpsimd state, if any: */
 	if (current->mm)
-		task_fpsimd_save();
+		fpsimd_save();
 
 	/* Invalidate any task state remaining in the fpsimd regs: */
 	fpsimd_flush_cpu_state();
@@ -1244,7 +1245,7 @@ static int fpsimd_cpu_pm_notifier(struct notifier_block *self,
 	switch (cmd) {
 	case CPU_PM_ENTER:
 		if (current->mm)
-			task_fpsimd_save();
+			fpsimd_save();
 		fpsimd_flush_cpu_state();
 		break;
 	case CPU_PM_EXIT:
-- 
2.1.4
