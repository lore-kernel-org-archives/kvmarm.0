Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7356A378D71
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 17:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768237365; cv=none; b=pgtF8snQXPaPRqIxWcAAPwogNZxCHTkK2QtTfRFXByDoV3YU1qgyYMyS0xsdjQa8PaV1j70XefHNHSulUDKfvXyv92dawuwnSq5ZG8mC6WlXVFKWso2XHVG3Ck/KPG/4IUnIsjWmwmme6ywPu6BjppvdeXw3jN/LLmAPhyvxM1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768237365; c=relaxed/simple;
	bh=IKrIu+UF+70lehCv5x60kVjftUlaoXS3qVPQgkvovPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHupDMwgB6POJdRO6ylsmO0lnz2Ou+OMjBJOuTsClEA8FT5Uow8WqpsSB2k6afylE4Z+LItpowJQO2VJsUFfOu3SLkCq7Y/zh6T5NGqU63v8nLBWKomH2YzZJE4lRMOvDc/nwpqwqPcHqGINHeO5N0Q6d86bpbp9If3M0ZKJyQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BFAA9153B;
	Mon, 12 Jan 2026 09:02:33 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 60DC03F694;
	Mon, 12 Jan 2026 09:02:35 -0800 (PST)
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
Subject: [PATCH v3 31/47] arm_mpam: resctrl: Pre-allocate assignable monitors
Date: Mon, 12 Jan 2026 16:58:58 +0000
Message-ID: <20260112165914.4086692-32-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260112165914.4086692-1-ben.horgan@arm.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
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

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since rfc:
Move __free
kmalloc -> kcalloc

Changes since v2:
kcalloc -> kmalloc_array
sizeof(*rmid_array)
Return error from resctrl_arch_mbm_cntr_assign_set()
---
 drivers/resctrl/mpam_internal.h |  7 +++
 drivers/resctrl/mpam_resctrl.c  | 97 +++++++++++++++++++++++++++++++++
 2 files changed, 104 insertions(+)

diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index 89f9d374ded0..58076abd5de3 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -367,6 +367,13 @@ struct mpam_resctrl_mon {
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
index 3af12ad77fba..2a9efc6c6fae 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -68,6 +68,12 @@ static bool cdp_enabled;
 static bool cacheinfo_ready;
 static DECLARE_WAIT_QUEUE_HEAD(wait_cacheinfo_ready);
 
+/*
+ * L3 local/total may come from different classes - what is the number of MBWU
+ * 'on L3'?
+ */
+static unsigned int l3_num_allocated_mbwu = ~0;
+
 /* Whether this num_mbw_mon could result in a free_running system */
 static int __mpam_monitors_free_running(u16 num_mbwu_mon)
 {
@@ -76,6 +82,15 @@ static int __mpam_monitors_free_running(u16 num_mbwu_mon)
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
@@ -120,9 +135,26 @@ static void resctrl_reset_task_closids(void)
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
 
@@ -138,6 +170,7 @@ int resctrl_arch_set_cdp_enabled(enum resctrl_res_level ignored, bool enable)
 	WRITE_ONCE(arm64_mpam_global_default, mpam_get_regval(current));
 
 	resctrl_reset_task_closids();
+	mpam_resctrl_monitor_sync_abmc_vals(l3);
 
 	return 0;
 }
@@ -321,6 +354,11 @@ static bool class_has_usable_mbwu(struct mpam_class *class)
 		return true;
 	}
 
+	if (cprops->num_mbwu_mon) {
+		pr_debug("monitors usable via ABMC assignment\n");
+		return true;
+	}
+
 	return false;
 }
 
@@ -597,6 +635,8 @@ static int __alloc_mbwu_mon(struct mpam_class *class, int *array,
 		array[i] = mbwu_mon;
 	}
 
+	l3_num_allocated_mbwu = min(l3_num_allocated_mbwu, num_mbwu_mon);
+
 	return 0;
 }
 
@@ -736,6 +776,19 @@ static void mpam_resctrl_pick_counters(void)
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
+	return -EINVAL;
+}
+
 static int mpam_resctrl_control_init(struct mpam_resctrl_res *res)
 {
 	struct mpam_class *class = res->class;
@@ -811,6 +864,42 @@ static int mpam_resctrl_pick_domain_id(int cpu, struct mpam_component *comp)
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
+		kmalloc_array(resctrl_arch_system_num_rmid_idx(), sizeof(*rmid_array), GFP_KERNEL);
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
 static int mpam_resctrl_monitor_init(struct mpam_resctrl_mon *mon,
 				     enum resctrl_event_id type)
 {
@@ -857,6 +946,14 @@ static int mpam_resctrl_monitor_init(struct mpam_resctrl_mon *mon,
 		 * group can be allocated freely:
 		 */
 		l3->mon.num_rmid = mpam_pmg_max + 1;
+
+		switch (type) {
+		case QOS_L3_MBM_LOCAL_EVENT_ID:
+		case QOS_L3_MBM_TOTAL_EVENT_ID:
+			return mpam_resctrl_monitor_init_abmc(mon);
+		default:
+			return 0;
+		}
 	}
 
 	return 0;
-- 
2.43.0

