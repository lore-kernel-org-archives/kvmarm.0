From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v6 05/15] arm64: fpsimd: Generalise context saving for
 non-task contexts
Date: Tue,  8 May 2018 17:44:50 +0100
Message-ID: <1525797900-5548-6-git-send-email-Dave.Martin@arm.com>
References: <1525797900-5548-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1525797900-5548-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@kernel.org>, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
---
 arch/arm64/kernel/fpsimd.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 0c4e7e0..5fc0595 100644
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
 
 	if (next->mm)
 		/*
@@ -977,7 +978,7 @@ void fpsimd_preserve_current_state(void)
 		return;
 
 	local_bh_disable();
-	task_fpsimd_save();
+	fpsimd_save();
 	local_bh_enable();
 }
 
@@ -1117,7 +1118,7 @@ void kernel_neon_begin(void)
 
 	/* Save unsaved task fpsimd state, if any: */
 	if (current->mm) {
-		task_fpsimd_save();
+		fpsimd_save();
 		set_thread_flag(TIF_FOREIGN_FPSTATE);
 	}
 
@@ -1242,7 +1243,7 @@ static int fpsimd_cpu_pm_notifier(struct notifier_block *self,
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
