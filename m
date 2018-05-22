From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v10 03/18] arm64: Use update{,_tsk}_thread_flag()
Date: Tue, 22 May 2018 17:05:04 +0100
Message-ID: <1527005119-6842-4-git-send-email-Dave.Martin@arm.com>
References: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch uses the new update_thread_flag() helpers to simplify a
couple of if () set; else clear; constructs.

No functional change.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/kernel/fpsimd.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 12e1c96..9d85373 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -618,10 +618,8 @@ int sve_set_vector_length(struct task_struct *task,
 	task->thread.sve_vl = vl;
 
 out:
-	if (flags & PR_SVE_VL_INHERIT)
-		set_tsk_thread_flag(task, TIF_SVE_VL_INHERIT);
-	else
-		clear_tsk_thread_flag(task, TIF_SVE_VL_INHERIT);
+	update_tsk_thread_flag(task, TIF_SVE_VL_INHERIT,
+			       flags & PR_SVE_VL_INHERIT);
 
 	return 0;
 }
@@ -910,12 +908,12 @@ void fpsimd_thread_switch(struct task_struct *next)
 		 * the TIF_FOREIGN_FPSTATE flag so the state will be loaded
 		 * upon the next return to userland.
 		 */
-		if (__this_cpu_read(fpsimd_last_state.st) ==
-			&next->thread.uw.fpsimd_state
-		    && next->thread.fpsimd_cpu == smp_processor_id())
-			clear_tsk_thread_flag(next, TIF_FOREIGN_FPSTATE);
-		else
-			set_tsk_thread_flag(next, TIF_FOREIGN_FPSTATE);
+		bool wrong_task = __this_cpu_read(fpsimd_last_state.st) !=
+					&next->thread.uw.fpsimd_state;
+		bool wrong_cpu = next->thread.fpsimd_cpu != smp_processor_id();
+
+		update_tsk_thread_flag(next, TIF_FOREIGN_FPSTATE,
+				       wrong_task || wrong_cpu);
 	}
 }
 
-- 
2.1.4
