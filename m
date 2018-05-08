From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v6 02/15] arm64: Use update{,_tsk}_thread_flag()
Date: Tue,  8 May 2018 17:44:47 +0100
Message-ID: <1525797900-5548-3-git-send-email-Dave.Martin@arm.com>
References: <1525797900-5548-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB8014A0D4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 May 2018 12:36:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 68CAFNsf-dY5 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 May 2018 12:35:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F25504A0D3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 May 2018 12:35:50 -0400 (EDT)
In-Reply-To: <1525797900-5548-1-git-send-email-Dave.Martin@arm.com>
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

This patch uses the new update_thread_flag() helpers to simplify a
couple of if () set; else clear; constructs.

No functional change.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/kernel/fpsimd.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 87a3536..0c4e7e0 100644
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
@@ -902,7 +900,7 @@ void fpsimd_thread_switch(struct task_struct *next)
 	if (current->mm)
 		task_fpsimd_save();
 
-	if (next->mm) {
+	if (next->mm)
 		/*
 		 * If we are switching to a task whose most recent userland
 		 * FPSIMD state is already in the registers of *this* cpu,
@@ -910,13 +908,10 @@ void fpsimd_thread_switch(struct task_struct *next)
 		 * the TIF_FOREIGN_FPSTATE flag so the state will be loaded
 		 * upon the next return to userland.
 		 */
-		if (__this_cpu_read(fpsimd_last_state.st) ==
-			&next->thread.uw.fpsimd_state
-		    && next->thread.fpsimd_cpu == smp_processor_id())
-			clear_tsk_thread_flag(next, TIF_FOREIGN_FPSTATE);
-		else
-			set_tsk_thread_flag(next, TIF_FOREIGN_FPSTATE);
-	}
+		update_tsk_thread_flag(next, TIF_FOREIGN_FPSTATE,
+			__this_cpu_read(fpsimd_last_state.st) !=
+				&next->thread.uw.fpsimd_state ||
+			next->thread.fpsimd_cpu != smp_processor_id());
 }
 
 void fpsimd_flush_thread(void)
-- 
2.1.4
