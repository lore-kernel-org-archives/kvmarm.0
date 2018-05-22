From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 10/14] arm64: ssbd: Add prctl interface for per-thread mitigation
Date: Tue, 22 May 2018 16:06:44 +0100
Message-ID: <20180522150648.28297-11-marc.zyngier@arm.com>
References: <20180522150648.28297-1-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180522150648.28297-1-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

If running on a system that performs dynamic SSBD mitigation, allow
userspace to request the mitigation for itself. This is implemented
as a prctl call, allowing the mitigation to be enabled or disabled at
will for this particular thread.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kernel/Makefile |   1 +
 arch/arm64/kernel/ssbd.c   | 107 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+)
 create mode 100644 arch/arm64/kernel/ssbd.c

diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index bf825f38d206..0025f8691046 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -54,6 +54,7 @@ arm64-obj-$(CONFIG_ARM64_RELOC_TEST)	+= arm64-reloc-test.o
 arm64-reloc-test-y := reloc_test_core.o reloc_test_syms.o
 arm64-obj-$(CONFIG_CRASH_DUMP)		+= crash_dump.o
 arm64-obj-$(CONFIG_ARM_SDE_INTERFACE)	+= sdei.o
+arm64-obj-$(CONFIG_ARM64_SSBD)		+= ssbd.o
 
 obj-y					+= $(arm64-obj-y) vdso/ probes/
 obj-m					+= $(arm64-obj-m)
diff --git a/arch/arm64/kernel/ssbd.c b/arch/arm64/kernel/ssbd.c
new file mode 100644
index 000000000000..34e3c430176b
--- /dev/null
+++ b/arch/arm64/kernel/ssbd.c
@@ -0,0 +1,107 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2018 ARM Ltd, All Rights Reserved.
+ */
+
+#include <linux/sched.h>
+#include <linux/thread_info.h>
+
+#include <asm/cpufeature.h>
+
+/*
+ * prctl interface for SSBD
+ * FIXME: Drop the below ifdefery once the common interface has been merged.
+ */
+#ifdef PR_SPEC_STORE_BYPASS
+static int ssbd_prctl_set(struct task_struct *task, unsigned long ctrl)
+{
+	int state = arm64_get_ssbd_state();
+
+	/* Unsupported or already mitigated */
+	if (state == ARM64_SSBD_UNKNOWN)
+		return -EINVAL;
+	if (state == ARM64_SSBD_MITIGATED)
+		return -EPERM;
+
+	/*
+	 * Things are a bit backward here: the arm64 internal API
+	 * *enables the mitigation* when the userspace API *disables
+	 * speculation*. So much fun.
+	 */
+	switch (ctrl) {
+	case PR_SPEC_ENABLE:
+		/* If speculation is force disabled, enable is not allowed */
+		if (state == ARM64_SSBD_FORCE_ENABLE ||
+		    task_spec_ssb_force_disable(task))
+			return -EPERM;
+		task_clear_spec_ssb_disable(task);
+		clear_tsk_thread_flag(task, TIF_SSBD);
+		break;
+	case PR_SPEC_DISABLE:
+		if (state == ARM64_SSBD_FORCE_DISABLE)
+			return -EPERM;
+		task_set_spec_ssb_disable(task);
+		set_tsk_thread_flag(task, TIF_SSBD);
+		break;
+	case PR_SPEC_FORCE_DISABLE:
+		if (state == ARM64_SSBD_FORCE_DISABLE)
+			return -EPERM;
+		task_set_spec_ssb_disable(task);
+		task_set_spec_ssb_force_disable(task);
+		set_tsk_thread_flag(task, TIF_SSBD);
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	return 0;
+}
+
+int arch_prctl_spec_ctrl_set(struct task_struct *task, unsigned long which,
+			     unsigned long ctrl)
+{
+	switch (which) {
+	case PR_SPEC_STORE_BYPASS:
+		return ssbd_prctl_set(task, ctrl);
+	default:
+		return -ENODEV;
+	}
+}
+
+#ifdef CONFIG_SECCOMP
+void arch_seccomp_spec_mitigate(struct task_struct *task)
+{
+	ssbd_prctl_set(task, PR_SPEC_FORCE_DISABLE);
+}
+#endif
+
+static int ssbd_prctl_get(struct task_struct *task)
+{
+	switch (arm64_get_ssbd_state()) {
+	case ARM64_SSBD_UNKNOWN:
+		return -EINVAL;
+	case ARM64_SSBD_FORCE_ENABLE:
+		return PR_SPEC_DISABLE;
+	case ARM64_SSBD_EL1_ENTRY:
+		if (task_spec_ssb_force_disable(task))
+			return PR_SPEC_PRCTL | PR_SPEC_FORCE_DISABLE;
+		if (task_spec_ssb_disable(task))
+			return PR_SPEC_PRCTL | PR_SPEC_DISABLE;
+		return PR_SPEC_PRCTL | PR_SPEC_ENABLE;
+	case ARM64_SSBD_FORCE_DISABLE:
+		return PR_SPEC_ENABLE;
+	default:
+		return PR_SPEC_NOT_AFFECTED;
+	}
+}
+
+int arch_prctl_spec_ctrl_get(struct task_struct *task, unsigned long which)
+{
+	switch (which) {
+	case PR_SPEC_STORE_BYPASS:
+		return ssbd_prctl_get(task);
+	default:
+		return -ENODEV;
+	}
+}
+#endif	/* PR_SPEC_STORE_BYPASS */
-- 
2.14.2
