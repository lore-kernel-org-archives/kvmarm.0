From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 2/3] arm64: fpsimd: Abstract out binding of task's fpsimd
 context to the cpu.
Date: Wed,  6 Dec 2017 16:45:46 +0000
Message-ID: <1512578747-4554-3-git-send-email-Dave.Martin@arm.com>
References: <1512578747-4554-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 004F040651
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Dec 2017 11:42:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kxT4giu5qje3 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Dec 2017 11:42:42 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A46649D7F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Dec 2017 11:42:42 -0500 (EST)
In-Reply-To: <1512578747-4554-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

There is currently some duplicate logic to associate current's
FPSIMD context with the cpu when loading FPSIMD state into the cpu
regs.

Subsequent patches will update that logic, so in order to ensure it
only needs to be done in one place, this patch factors the relevant
code out into a new function fpsimd_bind_to_cpu().

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/fpsimd.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 143b3e7..007140b 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -992,6 +992,18 @@ void fpsimd_signal_preserve_current_state(void)
 }
 
 /*
+ * Associate current's FPSIMD context with this cpu
+ * Preemption must be disabled when calling this function.
+ */
+static void fpsimd_bind_to_cpu(void)
+{
+	struct fpsimd_state *st = &current->thread.fpsimd_state;
+
+	__this_cpu_write(fpsimd_last_state, st);
+	st->cpu = smp_processor_id();
+}
+
+/*
  * Load the userland FPSIMD state of 'current' from memory, but only if the
  * FPSIMD state already held in the registers is /not/ the most recent FPSIMD
  * state of 'current'
@@ -1004,11 +1016,8 @@ void fpsimd_restore_current_state(void)
 	local_bh_disable();
 
 	if (test_and_clear_thread_flag(TIF_FOREIGN_FPSTATE)) {
-		struct fpsimd_state *st = &current->thread.fpsimd_state;
-
 		task_fpsimd_load();
-		__this_cpu_write(fpsimd_last_state, st);
-		st->cpu = smp_processor_id();
+		fpsimd_bind_to_cpu();
 	}
 
 	local_bh_enable();
@@ -1032,12 +1041,8 @@ void fpsimd_update_current_state(struct fpsimd_state *state)
 	}
 	task_fpsimd_load();
 
-	if (test_and_clear_thread_flag(TIF_FOREIGN_FPSTATE)) {
-		struct fpsimd_state *st = &current->thread.fpsimd_state;
-
-		__this_cpu_write(fpsimd_last_state, st);
-		st->cpu = smp_processor_id();
-	}
+	if (test_and_clear_thread_flag(TIF_FOREIGN_FPSTATE))
+		fpsimd_bind_to_cpu();
 
 	local_bh_enable();
 }
-- 
2.1.4
