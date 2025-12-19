Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B80C9358D12
	for <kvmarm@lists.linux.dev>; Fri, 19 Dec 2025 18:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766168082; cv=none; b=J6Eob1agB833P8RYk0I3AMsEarC0qloQKOgnQnPKIcuK+gFBAVVB2KE1jy+Pwye08XRsqp3bsOxZD8VjOxF0dQ9SsUDMp0N5DGm0FIe85SocIMH8T0YYhv9lNap38fo41T9qhoIuZFAFULNDq3y9jrjUnkeSm1eCnUbft+FTsh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766168082; c=relaxed/simple;
	bh=zohRa+PFsPggOCh8S2raDS228fD5+PR0jRjJCZLCRTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWhv52mHbgls640eRgrbr7NVQmuPBHe2CtCHpf1iEkBuUiTUSOSSsJERr5Y6rx0SaX/EDGNecKSv5iQCVn6UBSvk08HuC8DgIXtsrdUp0mGot8j2QxX8tiCU7+UqhIEE59QKTlCzNQ2EzrkifTsAYiJz7ifFQstZEtYQVynmIM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22C861684;
	Fri, 19 Dec 2025 10:14:33 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C8AD23F5CA;
	Fri, 19 Dec 2025 10:14:35 -0800 (PST)
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
	kvmarm@lists.linux.dev
Subject: [PATCH v2 33/45] arm_mpam: resctrl: Allow resctrl to allocate monitors
Date: Fri, 19 Dec 2025 18:11:35 +0000
Message-ID: <20251219181147.3404071-34-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251219181147.3404071-1-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
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

MBM monitors are much more complicated, if there are enough monitors, they
will be pre-allocated and free-running. If ABMC is in use instead then
'some' are pre-allocated in a different way, and need assigning.

Add helpers to allocate a CSU monitor. These helper return an out of range
value for MBM counters.

Allocating a montitor context is expected to block until hardware resources
become available. This only makes sense for QOS_L3_OCCUP as unallocated MBM
counters are losing data.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since rfc:
USE_RMID_IDX -> USE_PRE_ALLOCATED in comment
Remove unnecessary arch_mon_ctx = NULL
---
 drivers/resctrl/mpam_internal.h | 14 ++++++-
 drivers/resctrl/mpam_resctrl.c  | 67 +++++++++++++++++++++++++++++++++
 include/linux/arm_mpam.h        |  4 ++
 3 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index a2f6956d9236..b907bec96ba5 100644
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
@@ -212,7 +220,11 @@ enum mon_filter_options {
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
index 328a81ab68b4..638c84cdcfb6 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -21,6 +21,8 @@
 
 #include "mpam_internal.h"
 
+DECLARE_WAIT_QUEUE_HEAD(resctrl_mon_ctx_waiters);
+
 /*
  * The classes we've picked to map to resctrl resources, wrapped
  * in with their resctrl structure.
@@ -287,6 +289,71 @@ struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
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
+	ret = kmalloc(sizeof(*ret), GFP_KERNEL);
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
index 385554ceb452..e1461e32af75 100644
--- a/include/linux/arm_mpam.h
+++ b/include/linux/arm_mpam.h
@@ -63,6 +63,10 @@ u32 resctrl_arch_rmid_idx_encode(u32 closid, u32 rmid);
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

