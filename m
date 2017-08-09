From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 14/27] arm64/sve: Backend logic for setting the vector length
Date: Wed,  9 Aug 2017 13:05:20 +0100
Message-ID: <1502280338-23002-15-git-send-email-Dave.Martin@arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org, gdb@sourceware.org, Alan Hayward <alan.hayward@arm.com>, Yao Qi <Yao.Qi@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

This patch implements the core logic for changing a task's vector
length on request from userspace.  This will be used by the ptrace
and prctl frontends that are implemented in later patches.

The SVE architecture permits, but does not require, implementations
to support vector lengths that are not a power of two.  To handle
this, logic is added to check a requested vector length against a
possibly sparse bitmap of available vector lengths at runtime, so
that the best supported value can be chosen.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/include/asm/fpsimd.h |   6 +++
 arch/arm64/kernel/fpsimd.c      | 116 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/prctl.h      |   5 ++
 3 files changed, 127 insertions(+)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 7efd04e..39b26d2 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -70,11 +70,15 @@ extern void fpsimd_update_current_state(struct fpsimd_state *state);
 
 extern void fpsimd_flush_task_state(struct task_struct *target);
 
+#define SVE_VL_ARCH_MAX 0x100
+
 extern void sve_save_state(void *state, u32 *pfpsr);
 extern void sve_load_state(void const *state, u32 const *pfpsr,
 			   unsigned long vq_minus_1);
 extern unsigned int sve_get_vl(void);
 
+extern int sve_max_vl;
+
 #ifdef CONFIG_ARM64_SVE
 
 extern size_t sve_state_size(struct task_struct const *task);
@@ -83,6 +87,8 @@ extern void sve_alloc(struct task_struct *task);
 extern void fpsimd_release_thread(struct task_struct *task);
 extern void fpsimd_dup_sve(struct task_struct *dst,
 			   struct task_struct const *src);
+extern int sve_set_vector_length(struct task_struct *task,
+				 unsigned long vl, unsigned long flags);
 
 #else /* ! CONFIG_ARM64_SVE */
 
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index e8674f6..bce95de 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -18,12 +18,14 @@
  */
 
 #include <linux/bottom_half.h>
+#include <linux/bitmap.h>
 #include <linux/cpu.h>
 #include <linux/cpu_pm.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/percpu.h>
 #include <linux/preempt.h>
+#include <linux/prctl.h>
 #include <linux/ptrace.h>
 #include <linux/sched/signal.h>
 #include <linux/signal.h>
@@ -111,6 +113,20 @@ static DEFINE_PER_CPU(struct fpsimd_state *, fpsimd_last_state);
 /* Default VL for tasks that don't set it explicitly: */
 static int sve_default_vl = -1;
 
+#ifdef CONFIG_ARM64_SVE
+
+/* Maximum supported vector length across all CPUs (initially poisoned) */
+int sve_max_vl = -1;
+/* Set of available vector lengths, as vq_to_bit(vq): */
+static DECLARE_BITMAP(sve_vq_map, SVE_VQ_MAX);
+
+#else /* ! CONFIG_ARM64_SVE */
+
+/* Dummy declaration for code that will be optimised out: */
+extern DECLARE_BITMAP(sve_vq_map, SVE_VQ_MAX);
+
+#endif /* ! CONFIG_ARM64_SVE */
+
 static void sve_free(struct task_struct *task)
 {
 	kfree(task->thread.sve_state);
@@ -148,6 +164,37 @@ static void change_cpacr(u64 old, u64 new)
 		write_sysreg(new, CPACR_EL1);
 }
 
+static unsigned int vq_to_bit(unsigned int vq)
+{
+	BUILD_BUG_ON(vq < 1 || vq > SVE_VQ_MAX);
+
+	return SVE_VQ_MAX - vq;
+}
+
+static unsigned int bit_to_vq(unsigned int bit)
+{
+	BUILD_BUG_ON(bit >= SVE_VQ_MAX);
+
+	return SVE_VQ_MAX - bit;
+}
+
+static unsigned int find_supported_vector_length(unsigned int vl)
+{
+	int bit;
+
+	BUG_ON(!sve_vl_valid(vl));
+
+	BUG_ON(!sve_vl_valid(sve_max_vl));
+	if (vl > sve_max_vl)
+		vl = sve_max_vl;
+
+	bit = find_next_bit(sve_vq_map, SVE_VQ_MAX,
+			    vq_to_bit(sve_vq_from_vl(vl)));
+	BUG_ON(bit < 0 || bit >= SVE_VQ_MAX);
+
+	return 16 * bit_to_vq(bit);
+}
+
 #define ZREG(sve_state, vq, n) ((char *)(sve_state) +		\
 	(SVE_SIG_ZREG_OFFSET(vq, n) - SVE_SIG_REGS_OFFSET))
 
@@ -235,6 +282,73 @@ void fpsimd_dup_sve(struct task_struct *dst, struct task_struct const *src)
 	}
 }
 
+int sve_set_vector_length(struct task_struct *task,
+			  unsigned long vl, unsigned long flags)
+{
+	BUG_ON(task == current && preemptible());
+
+	if (flags & ~(unsigned long)(PR_SVE_VL_INHERIT |
+				     PR_SVE_SET_VL_ONEXEC))
+		return -EINVAL;
+
+	if (!sve_vl_valid(vl))
+		return -EINVAL;
+
+	/*
+	 * Clamp to the maximum vector length that VL-agnostic SVE code can
+	 * work with.  A flag may be assigned in the future to allow setting
+	 * of larger vector lengths without confusing older software.
+	 */
+	if (vl > SVE_VL_ARCH_MAX)
+		vl = SVE_VL_ARCH_MAX;
+
+	vl = find_supported_vector_length(vl);
+
+	if (flags & (PR_SVE_VL_INHERIT |
+		     PR_SVE_SET_VL_ONEXEC))
+		task->thread.sve_vl_onexec = vl;
+	else
+		/* Reset VL to system default on next exec: */
+		task->thread.sve_vl_onexec = 0;
+
+	/* Only actually set the VL if not deferred: */
+	if (flags & PR_SVE_SET_VL_ONEXEC)
+		goto out;
+
+	/*
+	 * To ensure the FPSIMD bits of the SVE vector registers are preserved,
+	 * write any live register state back to task_struct, and convert to a
+	 * non-SVE thread.
+	 */
+	if (vl != task->thread.sve_vl) {
+		if (task == current) {
+			task_fpsimd_save();
+			set_thread_flag(TIF_FOREIGN_FPSTATE);
+		}
+
+		if (test_and_clear_tsk_thread_flag(task, TIF_SVE))
+			sve_to_fpsimd(task);
+
+		/*
+		 * Force reallocation of task SVE state to the correct size
+		 * on next use:
+		 */
+		sve_free(task);
+	}
+
+	task->thread.sve_vl = vl;
+
+	fpsimd_flush_task_state(task);
+
+out:
+	if (flags & PR_SVE_VL_INHERIT)
+		set_thread_flag(TIF_SVE_VL_INHERIT);
+	else
+		clear_thread_flag(TIF_SVE_VL_INHERIT);
+
+	return 0;
+}
+
 void fpsimd_release_thread(struct task_struct *dead_task)
 {
 	sve_free(dead_task);
@@ -407,6 +521,8 @@ void fpsimd_flush_thread(void)
 		 * If not, something went badly wrong.
 		 */
 		BUG_ON(!sve_vl_valid(current->thread.sve_vl));
+		BUG_ON(find_supported_vector_length(current->thread.sve_vl) !=
+		       current->thread.sve_vl);
 
 		/*
 		 * If the task is not set to inherit, ensure that the vector
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index a8d0759..1b64901 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -197,4 +197,9 @@ struct prctl_mm_map {
 # define PR_CAP_AMBIENT_LOWER		3
 # define PR_CAP_AMBIENT_CLEAR_ALL	4
 
+/* arm64 Scalable Vector Extension controls */
+# define PR_SVE_SET_VL_ONEXEC		(1 << 18) /* defer effect until exec */
+# define PR_SVE_VL_LEN_MASK		0xffff
+# define PR_SVE_VL_INHERIT		(1 << 17) /* inherit across exec */
+
 #endif /* _LINUX_PRCTL_H */
-- 
2.1.4
