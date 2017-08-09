From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 12/27] arm64/sve: Support vector length resetting for new
 processes
Date: Wed,  9 Aug 2017 13:05:18 +0100
Message-ID: <1502280338-23002-13-git-send-email-Dave.Martin@arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF1DC49C26
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Aug 2017 08:05:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ea3LCN+0Hl-0 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Aug 2017 08:05:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91B2040FA7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Aug 2017 08:05:39 -0400 (EDT)
In-Reply-To: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
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
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

It's desirable to be able to reset the vector length to some sane
default for new processes, since the new binary and its libraries
processes may or may not be SVE-aware.

This patch tracks the desired post-exec vector length (if any) in a
new thread member sve_vl_onexec, and adds a new thread flag
TIF_SVE_VL_INHERIT to control whether to inherit or reset the
vector length.  Currently these are inactive.  Subsequent patches
will provide the capability to configure them.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/include/asm/processor.h   |  1 +
 arch/arm64/include/asm/thread_info.h |  1 +
 arch/arm64/kernel/fpsimd.c           | 13 +++++++++++++
 3 files changed, 15 insertions(+)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 969feed..da8802a 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -87,6 +87,7 @@ struct thread_struct {
 	struct fpsimd_state	fpsimd_state;
 	void			*sve_state;	/* SVE registers, if any */
 	u16			sve_vl;		/* SVE vector length */
+	u16			sve_vl_onexec;	/* SVE vl after next exec */
 	unsigned long		fault_address;	/* fault info */
 	unsigned long		fault_code;	/* ESR_EL1 value */
 	struct debug_info	debug;		/* debugging */
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 1a4b30b..bf9c552 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -97,6 +97,7 @@ struct thread_info {
 #define TIF_SINGLESTEP		21
 #define TIF_32BIT		22	/* 32bit process */
 #define TIF_SVE			23	/* Scalable Vector Extension in use */
+#define TIF_SVE_VL_INHERIT	24	/* Inherit sve_vl_onexec across exec */
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 37dd1b2..80ecb2d 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -108,6 +108,9 @@ static void task_fpsimd_save(void);
  */
 static DEFINE_PER_CPU(struct fpsimd_state *, fpsimd_last_state);
 
+/* Default VL for tasks that don't set it explicitly: */
+static int sve_default_vl = -1;
+
 static void sve_free(struct task_struct *task)
 {
 	kfree(task->thread.sve_state);
@@ -392,6 +395,9 @@ void fpsimd_flush_thread(void)
 		clear_thread_flag(TIF_SVE);
 		sve_free(current);
 
+		current->thread.sve_vl = current->thread.sve_vl_onexec ?
+			current->thread.sve_vl_onexec : sve_default_vl;
+
 		/*
 		 * User tasks must have a valid vector length set, but tasks
 		 * forked early (e.g., init) may not initially have one.
@@ -401,6 +407,13 @@ void fpsimd_flush_thread(void)
 		 * If not, something went badly wrong.
 		 */
 		BUG_ON(!sve_vl_valid(current->thread.sve_vl));
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
