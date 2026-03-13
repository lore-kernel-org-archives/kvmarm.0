Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC0BD3B5853
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 14:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773413316; cv=none; b=V/kdsc0Bbjaw7jXwD2KnYt6Q7PLP820jg0MsText4tRsLJaUE9d94iJ9q0Cir2O+zzm+glVaLFs7XvcDQfrE4+cZbu98s3un3q5Wejdyfd7JCjsXsQL3ACF5TlRV+9LrkxiPtIaNUNlqmEK+gTDf0NMxPZDwRhw0dJUtIrkyZNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773413316; c=relaxed/simple;
	bh=L712D+Wn8V5C27/oXxaNGMJfwFd0DKaErmgopUQJpMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQjqG629DWb6j5w9MWCTmcUPKgJPb0BRQdGYErqSZTLAAiiZYBoQNRJ2w7kduy5Ru5VKqSm7d5p9yw++s1vF9bQ8RJqwrEq3mfAZ7kOn+ZsBv3U+w8Ud6VkaClNiDEFsESPVswKPNz3PazlGIBTDolNFcmKSx6bKIn83oCkC13o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3839B22C7;
	Fri, 13 Mar 2026 07:48:28 -0700 (PDT)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6BA713F7BD;
	Fri, 13 Mar 2026 07:48:30 -0700 (PDT)
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
Subject: [PATCH v6 29/40] arm_mpam: resctrl: Allow resctrl to allocate monitors
Date: Fri, 13 Mar 2026 14:46:06 +0000
Message-ID: <20260313144617.3420416-30-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260313144617.3420416-1-ben.horgan@arm.com>
References: <20260313144617.3420416-1-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: James Morse <james.morse@arm.com>

When resctrl wants to read a domain's 'QOS_L3_OCCUP', it needs to allocate
a monitor on the corresponding resource. Monitors are allocated by class
instead of component.

Add helpers to allocate a CSU monitor. These helper return an out of range
value for MBM counters.

Allocating a montitor context is expected to block until hardware resources
become available. This only makes sense for QOS_L3_OCCUP as unallocated MBM
counters are losing data.

Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Tested-by: Peter Newman <peternewman@google.com>
Tested-by: Zeng Heng <zengheng4@huawei.com>
Tested-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
Reviewed-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since rfc:
USE_RMID_IDX -> USE_PRE_ALLOCATED in comment
Remove unnecessary arch_mon_ctx = NULL

Changes since v2:
Add include of resctrl_types.h as dropped from earlier patch

Changes since v3:
Don't mention ABMC in commit message

Changes since v5:
Remove MBM free running sentence from commit message
kmalloc -> kmalloc_obj
---
 drivers/resctrl/mpam_internal.h | 14 ++++++-
 drivers/resctrl/mpam_resctrl.c  | 67 +++++++++++++++++++++++++++++++++
 include/linux/arm_mpam.h        |  5 +++
 3 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index d58428ba2005..5ebbd6322597 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -29,6 +29,14 @@ struct platform_device;
 #define PACKED_FOR_KUNIT
 #endif
 
+/*
+ * This 'mon' values must not alias an actual monitor, so must be larger than
+ * U16_MAX, but not be confused with an errno value, so smaller than
+ * (u32)-SZ_4K.
+ * USE_PRE_ALLOCATED is used to avoid confusion with an actual monitor.
+ */
+#define USE_PRE_ALLOCATED	(U16_MAX + 1)
+
 static inline bool mpam_is_enabled(void)
 {
 	return static_branch_likely(&mpam_enabled);
@@ -216,7 +224,11 @@ enum mon_filter_options {
 };
 
 struct mon_cfg {
-	u16			mon;
+	/*
+	 * mon must be large enough to hold out of range values like
+	 * USE_PRE_ALLOCATED
+	 */
+	u32			mon;
 	u8			pmg;
 	bool			match_pmg;
 	bool			csu_exclude_clean;
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 00f3ad23a335..383f67948a82 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -22,6 +22,8 @@
 
 #include "mpam_internal.h"
 
+DECLARE_WAIT_QUEUE_HEAD(resctrl_mon_ctx_waiters);
+
 /*
  * The classes we've picked to map to resctrl resources, wrapped
  * in with their resctrl structure.
@@ -289,6 +291,71 @@ struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
 	return &mpam_resctrl_controls[l].resctrl_res;
 }
 
+static int resctrl_arch_mon_ctx_alloc_no_wait(enum resctrl_event_id evtid)
+{
+	struct mpam_resctrl_mon *mon = &mpam_resctrl_counters[evtid];
+
+	if (!mon->class)
+		return -EINVAL;
+
+	switch (evtid) {
+	case QOS_L3_OCCUP_EVENT_ID:
+		/* With CDP, one monitor gets used for both code/data reads */
+		return mpam_alloc_csu_mon(mon->class);
+	case QOS_L3_MBM_LOCAL_EVENT_ID:
+	case QOS_L3_MBM_TOTAL_EVENT_ID:
+		return USE_PRE_ALLOCATED;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+void *resctrl_arch_mon_ctx_alloc(struct rdt_resource *r,
+				 enum resctrl_event_id evtid)
+{
+	DEFINE_WAIT(wait);
+	int *ret;
+
+	ret = kmalloc_obj(*ret);
+	if (!ret)
+		return ERR_PTR(-ENOMEM);
+
+	do {
+		prepare_to_wait(&resctrl_mon_ctx_waiters, &wait,
+				TASK_INTERRUPTIBLE);
+		*ret = resctrl_arch_mon_ctx_alloc_no_wait(evtid);
+		if (*ret == -ENOSPC)
+			schedule();
+	} while (*ret == -ENOSPC && !signal_pending(current));
+	finish_wait(&resctrl_mon_ctx_waiters, &wait);
+
+	return ret;
+}
+
+static void resctrl_arch_mon_ctx_free_no_wait(enum resctrl_event_id evtid,
+					      u32 mon_idx)
+{
+	struct mpam_resctrl_mon *mon = &mpam_resctrl_counters[evtid];
+
+	if (!mon->class)
+		return;
+
+	if (evtid == QOS_L3_OCCUP_EVENT_ID)
+		mpam_free_csu_mon(mon->class, mon_idx);
+
+	wake_up(&resctrl_mon_ctx_waiters);
+}
+
+void resctrl_arch_mon_ctx_free(struct rdt_resource *r,
+			       enum resctrl_event_id evtid, void *arch_mon_ctx)
+{
+	u32 mon_idx = *(u32 *)arch_mon_ctx;
+
+	kfree(arch_mon_ctx);
+
+	resctrl_arch_mon_ctx_free_no_wait(evtid, mon_idx);
+}
+
 static bool cache_has_usable_cpor(struct mpam_class *class)
 {
 	struct mpam_props *cprops = &class->props;
diff --git a/include/linux/arm_mpam.h b/include/linux/arm_mpam.h
index 7d23c90f077d..e1461e32af75 100644
--- a/include/linux/arm_mpam.h
+++ b/include/linux/arm_mpam.h
@@ -5,6 +5,7 @@
 #define __LINUX_ARM_MPAM_H
 
 #include <linux/acpi.h>
+#include <linux/resctrl_types.h>
 #include <linux/types.h>
 
 struct mpam_msc;
@@ -62,6 +63,10 @@ u32 resctrl_arch_rmid_idx_encode(u32 closid, u32 rmid);
 void resctrl_arch_rmid_idx_decode(u32 idx, u32 *closid, u32 *rmid);
 u32 resctrl_arch_system_num_rmid_idx(void);
 
+struct rdt_resource;
+void *resctrl_arch_mon_ctx_alloc(struct rdt_resource *r, enum resctrl_event_id evtid);
+void resctrl_arch_mon_ctx_free(struct rdt_resource *r, enum resctrl_event_id evtid, void *ctx);
+
 /**
  * mpam_register_requestor() - Register a requestor with the MPAM driver
  * @partid_max:		The maximum PARTID value the requestor can generate.
-- 
2.43.0

