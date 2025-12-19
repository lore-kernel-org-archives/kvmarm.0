Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3F903570CA
	for <kvmarm@lists.linux.dev>; Fri, 19 Dec 2025 18:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766168072; cv=none; b=TFNKKFxu4xoUMpl92GD+Lk91kdNlYABph26fQj/zPa9dbNJ7QGojlcpZiWN2GUNhO7kjnK3OQ1CjId70V8ejhws4PX2/EQF7TTkTqBOD90Z+etw/HRc1y02bKTnvplNPH+L4oYx+Of+tR9ma3BEmESos7tFaTj1FA+B9mqwVTuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766168072; c=relaxed/simple;
	bh=N4OtzmXjYGwZQqAqIO0Ntmm7Gv+6kD0FJGGGOjzaNXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ew3tQLNLAsM5nNUPr6HiB0w/542lPNcHwqFcmxI60hOlIhKhUkpQItj45OS6Dip61A8Qdpl7yTsVWGXgXWfEVLi1u6PcVSYCEdGNPbPz/RqEVkTDWE5FLe7CfqCyMWnwdzeUnr+1jIoYJS1SoluwFQsMY2b/Q8CsDqlbctRrPAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F26771650;
	Fri, 19 Dec 2025 10:14:18 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A623F3F5CA;
	Fri, 19 Dec 2025 10:14:21 -0800 (PST)
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
Subject: [PATCH v2 30/45] arm_mpam: resctrl: Pre-allocate assignable monitors
Date: Fri, 19 Dec 2025 18:11:32 +0000
Message-ID: <20251219181147.3404071-31-ben.horgan@arm.com>
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

When there are not enough monitors, MPAM is able to emulate ABMC by making
a smaller number of monitors assignable. These monitors still need to be
allocated from the driver, and mapped to whichever control/monitor group
resctrl wants to use them with.

Add a second array to hold the monitor values indexed by resctrl's cntr_id.

When CDP is in use, two monitors are needed so the available number of
counters halves. Platforms with one monitor will have zero monitors when
CDP is in use.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since rfc:
Move __free
kmalloc -> kcalloc
---
 drivers/resctrl/mpam_internal.h |   7 +++
 drivers/resctrl/mpam_resctrl.c  | 103 ++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+)

diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index c25524f75c2e..a2f6956d9236 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -363,6 +363,13 @@ struct mpam_resctrl_mon {
 	 * un-assigned (closid, rmid) are -1.
 	 */
 	int			*mbwu_idx_to_mon;
+
+	/*
+	 * Array of assigned MBWU monitors, indexed by idx argument.
+	 * When ABMC is not in use, this array can be NULL. Otherwise
+	 * it maps idx to the allocated monitor.
+	 */
+	int			*assigned_counters;
 };
 
 static inline int mpam_alloc_csu_mon(struct mpam_class *class)
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index bea16bc096f7..e96d320c219c 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -50,6 +50,12 @@ static bool exposed_mon_capable;
  */
 static bool cdp_enabled;
 
+/*
+ * L3 local/total may come from different classes - what is the number of MBWU
+ * 'on L3'?
+ */
+static unsigned int l3_num_allocated_mbwu = ~0;
+
 /* Whether this num_mbw_mon could result in a free_running system */
 static int __mpam_monitors_free_running(u16 num_mbwu_mon)
 {
@@ -58,6 +64,15 @@ static int __mpam_monitors_free_running(u16 num_mbwu_mon)
 	return 0;
 }
 
+/*
+ * If l3_num_allocated_mbwu is forced below PARTID * PMG, then the counters
+ * are not free running, and ABMC's user-interface must be used to assign them.
+ */
+static bool mpam_resctrl_abmc_enabled(void)
+{
+	return l3_num_allocated_mbwu < resctrl_arch_system_num_rmid_idx();
+}
+
 bool resctrl_arch_alloc_capable(void)
 {
 	return exposed_alloc_capable;
@@ -102,9 +117,26 @@ static void resctrl_reset_task_closids(void)
 	read_unlock(&tasklist_lock);
 }
 
+static void mpam_resctrl_monitor_sync_abmc_vals(struct rdt_resource *l3)
+{
+	l3->mon.num_mbm_cntrs = l3_num_allocated_mbwu;
+	if (cdp_enabled)
+		l3->mon.num_mbm_cntrs /= 2;
+
+	if (l3->mon.num_mbm_cntrs) {
+		l3->mon.mbm_cntr_assignable = mpam_resctrl_abmc_enabled();
+		l3->mon.mbm_assign_on_mkdir = mpam_resctrl_abmc_enabled();
+	} else {
+		l3->mon.mbm_cntr_assignable = false;
+		l3->mon.mbm_assign_on_mkdir = false;
+	}
+}
+
 int resctrl_arch_set_cdp_enabled(enum resctrl_res_level ignored, bool enable)
 {
 	u32 partid_i = RESCTRL_RESERVED_CLOSID, partid_d = RESCTRL_RESERVED_CLOSID;
+	struct mpam_resctrl_res *res = &mpam_resctrl_controls[RDT_RESOURCE_L3];
+	struct rdt_resource *l3 = &res->resctrl_res;
 
 	cdp_enabled = enable;
 
@@ -120,6 +152,7 @@ int resctrl_arch_set_cdp_enabled(enum resctrl_res_level ignored, bool enable)
 	WRITE_ONCE(arm64_mpam_global_default, mpam_get_regval(current));
 
 	resctrl_reset_task_closids();
+	mpam_resctrl_monitor_sync_abmc_vals(l3);
 
 	return 0;
 }
@@ -315,6 +348,11 @@ static bool class_has_usable_mbwu(struct mpam_class *class)
 		return true;
 	}
 
+	if (cprops->num_mbwu_mon) {
+		pr_debug("monitors usable via ABMC assignment\n");
+		return true;
+	}
+
 	return false;
 }
 
@@ -583,6 +621,8 @@ static int __alloc_mbwu_mon(struct mpam_class *class, int *array,
 		array[i] = mbwu_mon;
 	}
 
+	l3_num_allocated_mbwu = min(l3_num_allocated_mbwu, num_mbwu_mon);
+
 	return 0;
 }
 
@@ -725,6 +765,23 @@ static void mpam_resctrl_pick_counters(void)
 			     mpam_resctrl_counters[QOS_L3_MBM_TOTAL_EVENT_ID].class);
 }
 
+bool resctrl_arch_mbm_cntr_assign_enabled(struct rdt_resource *r)
+{
+	if (r != &mpam_resctrl_controls[RDT_RESOURCE_L3].resctrl_res)
+		return false;
+
+	return mpam_resctrl_abmc_enabled();
+}
+
+int resctrl_arch_mbm_cntr_assign_set(struct rdt_resource *r, bool enable)
+{
+	lockdep_assert_cpus_held();
+
+	WARN_ON_ONCE(1);
+
+	return 0;
+}
+
 static int mpam_resctrl_control_init(struct mpam_resctrl_res *res,
 				     enum resctrl_res_level type)
 {
@@ -804,6 +861,42 @@ static int mpam_resctrl_pick_domain_id(int cpu, struct mpam_component *comp)
 	return comp->comp_id;
 }
 
+/*
+ * This must run after all event counters have been picked so that any free
+ * running counters have already been allocated.
+ */
+static int mpam_resctrl_monitor_init_abmc(struct mpam_resctrl_mon *mon)
+{
+	struct mpam_resctrl_res *res = &mpam_resctrl_controls[RDT_RESOURCE_L3];
+	struct rdt_resource *l3 = &res->resctrl_res;
+	struct mpam_class *class = mon->class;
+	u16 num_mbwu_mon;
+
+	if (mon->mbwu_idx_to_mon) {
+		pr_debug("monitors free running\n");
+		return 0;
+	}
+
+	int *rmid_array __free(kfree) =
+		kcalloc(resctrl_arch_system_num_rmid_idx(), sizeof(int), GFP_KERNEL);
+
+	if (!rmid_array) {
+		pr_debug("Failed to allocate RMID array\n");
+		return -ENOMEM;
+	}
+	memset(rmid_array, -1, resctrl_arch_system_num_rmid_idx() * sizeof(int));
+
+	num_mbwu_mon = class->props.num_mbwu_mon;
+	mon->assigned_counters = __alloc_mbwu_array(mon->class, num_mbwu_mon);
+	if (IS_ERR(mon->assigned_counters))
+		return PTR_ERR(mon->assigned_counters);
+	mon->mbwu_idx_to_mon = no_free_ptr(rmid_array);
+
+	mpam_resctrl_monitor_sync_abmc_vals(l3);
+
+	return 0;
+}
+
 static void mpam_resctrl_monitor_init(struct mpam_resctrl_mon *mon,
 				      enum resctrl_event_id type)
 {
@@ -845,6 +938,16 @@ static void mpam_resctrl_monitor_init(struct mpam_resctrl_mon *mon,
 		 * space.
 		 */
 		l3->mon.num_rmid = 1;
+
+		switch (type) {
+		case QOS_L3_MBM_LOCAL_EVENT_ID:
+		case QOS_L3_MBM_TOTAL_EVENT_ID:
+			mpam_resctrl_monitor_init_abmc(mon);
+
+			return;
+		default:
+			return;
+		}
 	}
 }
 
-- 
2.43.0

