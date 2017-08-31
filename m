From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v2 14/28] arm64/sve: Backend logic for setting the vector length
Date: Thu, 31 Aug 2017 18:00:46 +0100
Message-ID: <1504198860-12951-15-git-send-email-Dave.Martin@arm.com>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org, gdb@sourceware.org, Alan Hayward <alan.hayward@arm.com>, Yao Qi <Yao.Qi@arm.com>
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
Cc: Alex Bennée <alex.bennee@linaro.org>

---

Changes since v1
----------------

Requested by Alex Bennée:

* Comment the definition of SVE_VL_ARCH_MAX.

* Thin out BUG_ON()s:
Redundant BUG_ON()s and ones that just check invariants are removed.
Important sanity-checks are migrated to WARN_ON()s, with some
minimal best-effort patch-up code.

Other changes related Alex Bennée's comments:

* sve_max_vl is definitely not supposed to be changed after boot.
Make it official by marking it __ro_after_init.

* Migrate away from magic number for SVE_VQ_BYTES.
---
 arch/arm64/include/asm/fpsimd.h |   8 +++
 arch/arm64/kernel/fpsimd.c      | 128 +++++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/prctl.h      |   5 ++
 3 files changed, 140 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 7efd04e..32c8e19 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -20,6 +20,7 @@
 
 #ifndef __ASSEMBLY__
 
+#include <linux/cache.h>
 #include <linux/stddef.h>
 
 /*
@@ -70,11 +71,16 @@ extern void fpsimd_update_current_state(struct fpsimd_state *state);
 
 extern void fpsimd_flush_task_state(struct task_struct *target);
 
+/* Maximum VL that SVE VL-agnostic software can transparently support */
+#define SVE_VL_ARCH_MAX 0x100
+
 extern void sve_save_state(void *state, u32 *pfpsr);
 extern void sve_load_state(void const *state, u32 const *pfpsr,
 			   unsigned long vq_minus_1);
 extern unsigned int sve_get_vl(void);
 
+extern int __ro_after_init sve_max_vl;
+
 #ifdef CONFIG_ARM64_SVE
 
 extern size_t sve_state_size(struct task_struct const *task);
@@ -83,6 +89,8 @@ extern void sve_alloc(struct task_struct *task);
 extern void fpsimd_release_thread(struct task_struct *task);
 extern void fpsimd_dup_sve(struct task_struct *dst,
 			   struct task_struct const *src);
+extern int sve_set_vector_length(struct task_struct *task,
+				 unsigned long vl, unsigned long flags);
 
 #else /* ! CONFIG_ARM64_SVE */
 
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index f82cde8..713476e 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -17,8 +17,10 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/bitmap.h>
 #include <linux/bottom_half.h>
 #include <linux/bug.h>
+#include <linux/cache.h>
 #include <linux/compat.h>
 #include <linux/cpu.h>
 #include <linux/cpu_pm.h>
@@ -26,6 +28,7 @@
 #include <linux/init.h>
 #include <linux/percpu.h>
 #include <linux/preempt.h>
+#include <linux/prctl.h>
 #include <linux/ptrace.h>
 #include <linux/sched/signal.h>
 #include <linux/signal.h>
@@ -109,6 +112,20 @@ static DEFINE_PER_CPU(struct fpsimd_state *, fpsimd_last_state);
 /* Default VL for tasks that don't set it explicitly: */
 static int sve_default_vl = SVE_VL_MIN;
 
+#ifdef CONFIG_ARM64_SVE
+
+/* Maximum supported vector length across all CPUs (initially poisoned) */
+int __ro_after_init sve_max_vl = -1;
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
@@ -186,6 +203,44 @@ static void task_fpsimd_save(void)
 	}
 }
 
+static unsigned int vq_to_bit(unsigned int vq)
+{
+	return SVE_VQ_MAX - vq;
+}
+
+static unsigned int bit_to_vq(unsigned int bit)
+{
+	if (WARN_ON(bit >= SVE_VQ_MAX))
+		bit = SVE_VQ_MAX - 1;
+
+	return SVE_VQ_MAX - bit;
+}
+
+/*
+ * All vector length selection from userspace comes through here.
+ * We're on a slow path, so some sanity-checks are included.
+ * If things go wrong there's a bug somewhere, but try to fall back to a
+ * safe choice.
+ */
+static unsigned int find_supported_vector_length(unsigned int vl)
+{
+	int bit;
+	int max_vl = sve_max_vl;
+
+	if (WARN_ON(!sve_vl_valid(vl)))
+		vl = SVE_VL_MIN;
+
+	if (WARN_ON(!sve_vl_valid(max_vl)))
+		max_vl = SVE_VL_MIN;
+
+	if (vl > max_vl)
+		vl = max_vl;
+
+	bit = find_next_bit(sve_vq_map, SVE_VQ_MAX,
+			    vq_to_bit(sve_vq_from_vl(vl)));
+	return sve_vl_from_vq(bit_to_vq(bit));
+}
+
 #define ZREG(sve_state, vq, n) ((char *)(sve_state) +		\
 	(SVE_SIG_ZREG_OFFSET(vq, n) - SVE_SIG_REGS_OFFSET))
 
@@ -265,6 +320,73 @@ void fpsimd_dup_sve(struct task_struct *dst, struct task_struct const *src)
 	dst->thread.sve_state = NULL;
 }
 
+int sve_set_vector_length(struct task_struct *task,
+			  unsigned long vl, unsigned long flags)
+{
+	WARN_ON(task == current && preemptible());
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
@@ -361,7 +483,7 @@ void fpsimd_thread_switch(struct task_struct *next)
 
 void fpsimd_flush_thread(void)
 {
-	int vl;
+	int vl, supported_vl;
 
 	if (!system_supports_fpsimd())
 		return;
@@ -389,6 +511,10 @@ void fpsimd_flush_thread(void)
 		if (WARN_ON(!sve_vl_valid(vl)))
 			vl = SVE_VL_MIN;
 
+		supported_vl = find_supported_vector_length(vl);
+		if (WARN_ON(supported_vl != vl))
+			vl = supported_vl;
+
 		current->thread.sve_vl = vl;
 
 		/*
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
