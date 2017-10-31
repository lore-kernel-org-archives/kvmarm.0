From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v5 14/30] arm64/sve: Support vector length resetting for new processes
Date: Tue, 31 Oct 2017 15:51:06 +0000
Message-ID: <1509465082-30427-15-git-send-email-Dave.Martin@arm.com>
References: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

It's desirable to be able to reset the vector length to some sane
default for new processes, since the new binary and its libraries
may or may not be SVE-aware.

This patch tracks the desired post-exec vector length (if any) in a
new thread member sve_vl_onexec, and adds a new thread flag
TIF_SVE_VL_INHERIT to control whether to inherit or reset the
vector length.  Currently these are inactive.  Subsequent patches
will provide the capability to configure them.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/processor.h   |  1 +
 arch/arm64/include/asm/thread_info.h |  1 +
 arch/arm64/kernel/fpsimd.c           | 16 ++++++++++++----
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index e2f575d..c6fddb0 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -107,6 +107,7 @@ struct thread_struct {
 	struct fpsimd_state	fpsimd_state;
 	void			*sve_state;	/* SVE registers, if any */
 	unsigned int		sve_vl;		/* SVE vector length */
+	unsigned int		sve_vl_onexec;	/* SVE vl after next exec */
 	unsigned long		fault_address;	/* fault info */
 	unsigned long		fault_code;	/* ESR_EL1 value */
 	struct debug_info	debug;		/* debugging */
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 92b7b48..eb43128 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -95,6 +95,7 @@ void arch_release_task_struct(struct task_struct *tsk);
 #define TIF_SINGLESTEP		21
 #define TIF_32BIT		22	/* 32bit process */
 #define TIF_SVE			23	/* Scalable Vector Extension in use */
+#define TIF_SVE_VL_INHERIT	24	/* Inherit sve_vl_onexec across exec */
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 787f5d3..c91be8e 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -110,6 +110,9 @@
  */
 static DEFINE_PER_CPU(struct fpsimd_state *, fpsimd_last_state);
 
+/* Default VL for tasks that don't set it explicitly: */
+static int sve_default_vl = SVE_VL_MIN;
+
 /*
  * Call __sve_free() directly only if you know task can't be scheduled
  * or preempted.
@@ -473,15 +476,20 @@ void fpsimd_flush_thread(void)
 		 * If a bug causes this to go wrong, we make some noise and
 		 * try to fudge thread.sve_vl to a safe value here.
 		 */
-		vl = current->thread.sve_vl;
-
-		if (vl == 0)
-			vl = SVE_VL_MIN;
+		vl = current->thread.sve_vl_onexec ?
+			current->thread.sve_vl_onexec : sve_default_vl;
 
 		if (WARN_ON(!sve_vl_valid(vl)))
 			vl = SVE_VL_MIN;
 
 		current->thread.sve_vl = vl;
+
+		/*
+		 * If the task is not set to inherit, ensure that the vector
+		 * length will be reset by a subsequent exec:
+		 */
+		if (!test_thread_flag(TIF_SVE_VL_INHERIT))
+			current->thread.sve_vl_onexec = 0;
 	}
 
 	set_thread_flag(TIF_FOREIGN_FPSTATE);
-- 
2.1.4
