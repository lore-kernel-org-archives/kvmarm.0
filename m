Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91F7D3ACA62
	for <kvmarm@lists.linux.dev>; Tue, 24 Feb 2026 17:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771955877; cv=none; b=p31FIgXxB3i8Yemd4tXo2H5gGGmQaOnt5a/lkZenHkuTwFkifP7Gu0aYYgO4tG8J28dplVewAlXKFydCUslh90Th957+smKUvBxhE6ANZtcQzcANi5qOb3t2Il0uXNWJDsOjdDRjK+zqqDfrJGWQhNYMt6HiUUnoHBHjTKdTH28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771955877; c=relaxed/simple;
	bh=vACVbqsWfl2y1ySKMmeUCL0fRGw0f5h0/YHfF0ZvF6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YiPIyOmAH8QMEsrjMJeLIE8JMMMoP41Gb9BXsQefqm/02MtkB9l1ti4hkkXHeSUQpSEOHzV7arRlnsO5w0diZdqHtKLVwyI3hL/6sChzxFJGznFL/TII9MAC8XhqsN7I/QvVD3isVLLEWwjsjoUe4tnrZnuQ9stpa3oE+5TD8FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B7607339;
	Tue, 24 Feb 2026 09:57:48 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 23D5D3F59E;
	Tue, 24 Feb 2026 09:57:50 -0800 (PST)
From: Ben Horgan <ben.horgan@arm.com>
To: ben.horgan@arm.com
Cc: amitsinght@marvell.com,
	baisheng.gao@unisoc.com,
	baolin.wang@linux.alibaba.com,
	carl@os.amperecomputing.com,
	dave.martin@arm.com,
	david@kernel.org,
	dfustini@baylibre.com,
	fenghuay@nvidia.com,
	gshan@redhat.com,
	james.morse@arm.com,
	jonathan.cameron@huawei.com,
	kobak@nvidia.com,
	lcherian@marvell.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	peternewman@google.com,
	punit.agrawal@oss.qualcomm.com,
	quic_jiles@quicinc.com,
	reinette.chatre@intel.com,
	rohit.mathew@arm.com,
	scott@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	tan.shaopeng@fujitsu.com,
	xhao@linux.alibaba.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	corbet@lwn.net,
	maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	kvmarm@lists.linux.dev,
	zengheng4@huawei.com,
	linux-doc@vger.kernel.org,
	Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Subject: [PATCH v5 04/41] arm64: mpam: Context switch the MPAM registers
Date: Tue, 24 Feb 2026 17:56:43 +0000
Message-ID: <20260224175720.2663924-5-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260224175720.2663924-1-ben.horgan@arm.com>
References: <20260224175720.2663924-1-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: James Morse <james.morse@arm.com>

MPAM allows traffic in the SoC to be labeled by the OS, these labels are
used to apply policy in caches and bandwidth regulators, and to monitor
traffic in the SoC. The label is made up of a PARTID and PMG value. The x86
equivalent calls these CLOSID and RMID, but they don't map precisely.

MPAM has two CPU system registers that is used to hold the PARTID and PMG
values that traffic generated at each exception level will use. These can
be set per-task by the resctrl file system. (resctrl is the defacto
interface for controlling this stuff).

Add a helper to switch this.

struct task_struct's separate CLOSID and RMID fields are insufficient to
implement resctrl using MPAM, as resctrl can change the PARTID (CLOSID) and
PMG (sort of like the RMID) separately. On x86, the rmid is an independent
number, so a race that writes a mismatched closid and rmid into hardware is
benign. On arm64, the pmg bits extend the partid.
(i.e. partid-5 has a pmg-0 that is not the same as partid-6's pmg-0).  In
this case, mismatching the values will 'dirty' a pmg value that resctrl
believes is clean, and is not tracking with its 'limbo' code.

To avoid this, the partid and pmg are always read and written as a
pair. This requires a new u64 field. In struct task_struct there are two
u32, rmid and closid for the x86 case, but as we can't use them here do
something else. Add this new field, mpam_partid_pmg, to struct thread_info
to avoid adding more architecture specific code to struct task_struct.
Always use READ_ONCE()/WRITE_ONCE() when accessing this field.

Resctrl allows a per-cpu 'default' value to be set, this overrides the
values when scheduling a task in the default control-group, which has
PARTID 0. The way 'code data prioritisation' gets emulated means the
register value for the default group needs to be a variable.

The current system register value is kept in a per-cpu variable to avoid
writing to the system register if the value isn't going to change.  Writes
to this register may reset the hardware state for regulating bandwidth.

Finally, there is no reason to context switch these registers unless there
is a driver changing the values in struct task_struct. Hide the whole thing
behind a static key. This also allows the driver to disable MPAM in
response to errors reported by hardware. Move the existing static key to
belong to the arch code, as in the future the MPAM driver may become a
loadable module.

All this should depend on whether there is an MPAM driver, hide it behind
CONFIG_ARM64_MPAM.

Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Tested-by: Peter Newman <peternewman@google.com>
Tested-by: Zeng Heng <zengheng4@huawei.com>
CC: Amit Singh Tomar <amitsinght@marvell.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since rfc:
CONFIG_MPAM -> CONFIG_ARM64_MPAM in commit message
Remove extra DECLARE_STATIC_KEY_FALSE
Function name in comment, __mpam_sched_in() -> mpam_thread_switch()
Remove unused headers
Expand comment (Jonathan)

Changes since v2:
Tidy up ifdefs

Changes since v3:
Always set MPAMEN for MPAM1_EL1 rather than relying on it being read only.
---
 arch/arm64/Kconfig                   |  2 +
 arch/arm64/include/asm/mpam.h        | 67 ++++++++++++++++++++++++++++
 arch/arm64/include/asm/thread_info.h |  3 ++
 arch/arm64/kernel/Makefile           |  1 +
 arch/arm64/kernel/mpam.c             | 13 ++++++
 arch/arm64/kernel/process.c          |  7 +++
 drivers/resctrl/mpam_devices.c       |  2 -
 drivers/resctrl/mpam_internal.h      |  4 +-
 8 files changed, 95 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm64/include/asm/mpam.h
 create mode 100644 arch/arm64/kernel/mpam.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 38dba5f7e4d2..ecaaca13a969 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2039,6 +2039,8 @@ config ARM64_MPAM
 
 	  MPAM is exposed to user-space via the resctrl pseudo filesystem.
 
+	  This option enables the extra context switch code.
+
 endmenu # "ARMv8.4 architectural features"
 
 menu "ARMv8.5 architectural features"
diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/mpam.h
new file mode 100644
index 000000000000..0747e0526927
--- /dev/null
+++ b/arch/arm64/include/asm/mpam.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2025 Arm Ltd. */
+
+#ifndef __ASM__MPAM_H
+#define __ASM__MPAM_H
+
+#include <linux/jump_label.h>
+#include <linux/percpu.h>
+#include <linux/sched.h>
+
+#include <asm/sysreg.h>
+
+DECLARE_STATIC_KEY_FALSE(mpam_enabled);
+DECLARE_PER_CPU(u64, arm64_mpam_default);
+DECLARE_PER_CPU(u64, arm64_mpam_current);
+
+/*
+ * The value of the MPAM0_EL1 sysreg when a task is in resctrl's default group.
+ * This is used by the context switch code to use the resctrl CPU property
+ * instead. The value is modified when CDP is enabled/disabled by mounting
+ * the resctrl filesystem.
+ */
+extern u64 arm64_mpam_global_default;
+
+/*
+ * The resctrl filesystem writes to the partid/pmg values for threads and CPUs,
+ * which may race with reads in mpam_thread_switch(). Ensure only one of the old
+ * or new values are used. Particular care should be taken with the pmg field as
+ * mpam_thread_switch() may read a partid and pmg that don't match, causing this
+ * value to be stored with cache allocations, despite being considered 'free' by
+ * resctrl.
+ */
+#ifdef CONFIG_ARM64_MPAM
+static inline u64 mpam_get_regval(struct task_struct *tsk)
+{
+	return READ_ONCE(task_thread_info(tsk)->mpam_partid_pmg);
+}
+
+static inline void mpam_thread_switch(struct task_struct *tsk)
+{
+	u64 oldregval;
+	int cpu = smp_processor_id();
+	u64 regval = mpam_get_regval(tsk);
+
+	if (!static_branch_likely(&mpam_enabled))
+		return;
+
+	if (regval == READ_ONCE(arm64_mpam_global_default))
+		regval = READ_ONCE(per_cpu(arm64_mpam_default, cpu));
+
+	oldregval = READ_ONCE(per_cpu(arm64_mpam_current, cpu));
+	if (oldregval == regval)
+		return;
+
+	write_sysreg_s(regval | MPAM1_EL1_MPAMEN, SYS_MPAM1_EL1);
+	isb();
+
+	/* Synchronising the EL0 write is left until the ERET to EL0 */
+	write_sysreg_s(regval, SYS_MPAM0_EL1);
+
+	WRITE_ONCE(per_cpu(arm64_mpam_current, cpu), regval);
+}
+#else
+static inline void mpam_thread_switch(struct task_struct *tsk) {}
+#endif /* CONFIG_ARM64_MPAM */
+
+#endif /* __ASM__MPAM_H */
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 7942478e4065..5d7fe3e153c8 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -41,6 +41,9 @@ struct thread_info {
 #ifdef CONFIG_SHADOW_CALL_STACK
 	void			*scs_base;
 	void			*scs_sp;
+#endif
+#ifdef CONFIG_ARM64_MPAM
+	u64			mpam_partid_pmg;
 #endif
 	u32			cpu;
 };
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 76f32e424065..15979f366519 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -67,6 +67,7 @@ obj-$(CONFIG_CRASH_DUMP)		+= crash_dump.o
 obj-$(CONFIG_VMCORE_INFO)		+= vmcore_info.o
 obj-$(CONFIG_ARM_SDE_INTERFACE)		+= sdei.o
 obj-$(CONFIG_ARM64_PTR_AUTH)		+= pointer_auth.o
+obj-$(CONFIG_ARM64_MPAM)		+= mpam.o
 obj-$(CONFIG_ARM64_MTE)			+= mte.o
 obj-y					+= vdso-wrap.o
 obj-$(CONFIG_COMPAT_VDSO)		+= vdso32-wrap.o
diff --git a/arch/arm64/kernel/mpam.c b/arch/arm64/kernel/mpam.c
new file mode 100644
index 000000000000..9866d2ca0faa
--- /dev/null
+++ b/arch/arm64/kernel/mpam.c
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2025 Arm Ltd. */
+
+#include <asm/mpam.h>
+
+#include <linux/jump_label.h>
+#include <linux/percpu.h>
+
+DEFINE_STATIC_KEY_FALSE(mpam_enabled);
+DEFINE_PER_CPU(u64, arm64_mpam_default);
+DEFINE_PER_CPU(u64, arm64_mpam_current);
+
+u64 arm64_mpam_global_default;
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 489554931231..47698955fa1e 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -51,6 +51,7 @@
 #include <asm/fpsimd.h>
 #include <asm/gcs.h>
 #include <asm/mmu_context.h>
+#include <asm/mpam.h>
 #include <asm/mte.h>
 #include <asm/processor.h>
 #include <asm/pointer_auth.h>
@@ -738,6 +739,12 @@ struct task_struct *__switch_to(struct task_struct *prev,
 	if (prev->thread.sctlr_user != next->thread.sctlr_user)
 		update_sctlr_el1(next->thread.sctlr_user);
 
+	/*
+	 * MPAM thread switch happens after the DSB to ensure prev's accesses
+	 * use prev's MPAM settings.
+	 */
+	mpam_thread_switch(next);
+
 	/* the actual thread switch */
 	last = cpu_switch_to(prev, next);
 
diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index 1eebc2602187..b400a7381d9a 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -29,8 +29,6 @@
 
 #include "mpam_internal.h"
 
-DEFINE_STATIC_KEY_FALSE(mpam_enabled); /* This moves to arch code */
-
 /*
  * mpam_list_lock protects the SRCU lists when writing. Once the
  * mpam_enabled key is enabled these lists are read-only,
diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index e8971842b124..4632985bcca6 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -16,12 +16,12 @@
 #include <linux/srcu.h>
 #include <linux/types.h>
 
+#include <asm/mpam.h>
+
 #define MPAM_MSC_MAX_NUM_RIS	16
 
 struct platform_device;
 
-DECLARE_STATIC_KEY_FALSE(mpam_enabled);
-
 #ifdef CONFIG_MPAM_KUNIT_TEST
 #define PACKED_FOR_KUNIT __packed
 #else
-- 
2.43.0

