From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 19/27] arm64/sve: Add prctl controls for userspace vector length management
Date: Wed,  9 Aug 2017 13:05:25 +0100
Message-ID: <1502280338-23002-20-git-send-email-Dave.Martin@arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-Id: kvmarm@lists.cs.columbia.edu

This patch adds two arm64-specific prctls, to permit userspace to
control its vector length:

 * PR_SVE_SET_VL: set the thread's SVE vector length and vector
   length inheritance mode.

 * PR_SVE_GET_VL: get the same information.

Although these calls shadow instruction set features in the SVE
architecture, these prctls provide additional control: the vector
length inheritance mode is Linux-specific and nothing to do with
the architecture, and the architecture does not permit EL0 to set
its own vector length directly.  Both can be used in portable tools
without requiring the use of SVE instructions.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/include/asm/fpsimd.h    | 14 ++++++++++++
 arch/arm64/include/asm/processor.h |  4 ++++
 arch/arm64/kernel/fpsimd.c         | 46 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/prctl.h         |  4 ++++
 kernel/sys.c                       | 12 ++++++++++
 5 files changed, 80 insertions(+)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index ffb8a50..b58aa45 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -17,6 +17,7 @@
 #define __ASM_FP_H
 
 #include <asm/ptrace.h>
+#include <asm/errno.h>
 
 #ifndef __ASSEMBLY__
 
@@ -97,6 +98,9 @@ extern void sve_sync_from_fpsimd_zeropad(struct task_struct *task);
 extern int sve_set_vector_length(struct task_struct *task,
 				 unsigned long vl, unsigned long flags);
 
+extern int sve_set_current_vl(unsigned long arg);
+extern int sve_get_current_vl(void);
+
 extern void __init sve_init_vq_map(void);
 extern void sve_update_vq_map(void);
 extern int sve_verify_vq_map(void);
@@ -112,6 +116,16 @@ static void __maybe_unused sve_sync_to_fpsimd(struct task_struct *task) { }
 static void __maybe_unused sve_sync_from_fpsimd_zeropad(
 	struct task_struct *task) { }
 
+static int __maybe_unused sve_set_current_vl(unsigned long arg)
+{
+	return -EINVAL;
+}
+
+static int __maybe_unused sve_get_current_vl(void)
+{
+	return -EINVAL;
+}
+
 static void __maybe_unused sve_init_vq_map(void) { }
 static void __maybe_unused sve_update_vq_map(void) { }
 static int __maybe_unused sve_verify_vq_map(void) { return 0; }
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index da8802a..70b03b4 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -197,4 +197,8 @@ static inline void spin_lock_prefetch(const void *ptr)
 int cpu_enable_pan(void *__unused);
 int cpu_enable_cache_maint_trap(void *__unused);
 
+/* Userspace interface for PR_SVE_{SET,GET}_VL prctl()s: */
+#define SVE_SET_VL(arg)	sve_set_current_vl(arg)
+#define SVE_GET_VL()	sve_get_current_vl()
+
 #endif /* __ASM_PROCESSOR_H */
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 5a7c870..4fe1675 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -24,6 +24,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/percpu.h>
+#include <linux/prctl.h>
 #include <linux/preempt.h>
 #include <linux/prctl.h>
 #include <linux/ptrace.h>
@@ -387,6 +388,51 @@ int sve_set_vector_length(struct task_struct *task,
 	return 0;
 }
 
+/*
+ * Encode the current vector length and flags for return.
+ * This is only required for prctl(): ptrace has separate fields
+ */
+static int sve_prctl_status(void)
+{
+	int ret = current->thread.sve_vl;
+
+	if (test_thread_flag(TIF_SVE_VL_INHERIT))
+		ret |= PR_SVE_VL_INHERIT;
+
+	return ret;
+}
+
+/* PR_SVE_SET_VL */
+int sve_set_current_vl(unsigned long arg)
+{
+	unsigned long vl, flags;
+	int ret;
+
+	vl = arg & PR_SVE_VL_LEN_MASK;
+	flags = arg & ~vl;
+
+	if (!system_supports_sve())
+		return -EINVAL;
+
+	preempt_disable();
+	ret = sve_set_vector_length(current, vl, flags);
+	preempt_enable();
+
+	if (ret)
+		return ret;
+
+	return sve_prctl_status();
+}
+
+/* PR_SVE_GET_VL */
+int sve_get_current_vl(void)
+{
+	if (!system_supports_sve())
+		return -EINVAL;
+
+	return sve_prctl_status();
+}
+
 static unsigned long *sve_alloc_vq_map(void)
 {
 	return kzalloc(BITS_TO_LONGS(SVE_VQ_MAX) * sizeof(unsigned long),
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 1b64901..1ef9370 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -198,7 +198,11 @@ struct prctl_mm_map {
 # define PR_CAP_AMBIENT_CLEAR_ALL	4
 
 /* arm64 Scalable Vector Extension controls */
+/* Flag values must be kept in sync with ptrace NT_ARM_SVE interface */
+#define PR_SVE_SET_VL			48	/* set task vector length */
 # define PR_SVE_SET_VL_ONEXEC		(1 << 18) /* defer effect until exec */
+#define PR_SVE_GET_VL			49	/* get task vector length */
+/* Bits common to PR_SVE_SET_VL and PR_SVE_GET_VL */
 # define PR_SVE_VL_LEN_MASK		0xffff
 # define PR_SVE_VL_INHERIT		(1 << 17) /* inherit across exec */
 
diff --git a/kernel/sys.c b/kernel/sys.c
index 2855ee7..f8215a6 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -110,6 +110,12 @@
 #ifndef SET_FP_MODE
 # define SET_FP_MODE(a,b)	(-EINVAL)
 #endif
+#ifndef SVE_SET_VL
+# define SVE_SET_VL(a)		(-EINVAL)
+#endif
+#ifndef SVE_GET_VL
+# define SVE_GET_VL()		(-EINVAL)
+#endif
 
 /*
  * this is where the system-wide overflow UID and GID are defined, for
@@ -2389,6 +2395,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 	case PR_GET_FP_MODE:
 		error = GET_FP_MODE(me);
 		break;
+	case PR_SVE_SET_VL:
+		error = SVE_SET_VL(arg2);
+		break;
+	case PR_SVE_GET_VL:
+		error = SVE_GET_VL();
+		break;
 	default:
 		error = -EINVAL;
 		break;
-- 
2.1.4
