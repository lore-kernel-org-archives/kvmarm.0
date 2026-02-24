Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 448EF3ACA48
	for <kvmarm@lists.linux.dev>; Tue, 24 Feb 2026 18:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771956049; cv=none; b=JtYOCb8exSspZuAFImgJrDLHe1lmYmhpe1xQgTSgTimPg5XtEA7GkyFoRDpASjEgcdo+PUKaJz9wjhlRcfmtLpFPSDvwAN2oHz7W4q4CC8gnwqjuqxgRHAvvYLgt6pz3OPbKHMRWleFueMo0AtLS6dMbQtU4cd+4x9GQWgHhL9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771956049; c=relaxed/simple;
	bh=xn0346vg9uyGTmbZNvp6vXNZpRPkOzvFvZndJbg4s5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btFNZfaRnjYjhGhEJaUSCZ9Zt/AUkSeA6S6b6u0t69ryCCpR5FkhXm45Q88gSCrKEpdbbkQtfimmc9ZxmWD6ZobNziiDhEawnl6gr0H37mLIPjXsWkYpRYBqnAIfsIMOpXEGOEfn4VeiOIxM5IhhPSPyiekNtU2PLCEkc3azoy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C2561595;
	Tue, 24 Feb 2026 10:00:41 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 22BFE3F59E;
	Tue, 24 Feb 2026 10:00:41 -0800 (PST)
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
Subject: [PATCH v5 35/41] arm_mpam: resctrl: Call resctrl_init() on platforms that can support resctrl
Date: Tue, 24 Feb 2026 17:57:14 +0000
Message-ID: <20260224175720.2663924-36-ben.horgan@arm.com>
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

Now that MPAM links against resctrl, call resctrl_init() to register the
filesystem and setup resctrl's structures.

Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Tested-by: Peter Newman <peternewman@google.com>
Tested-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since v2:
Use for_each_mpam...
error path tidying

Changes since v3:
Don't consider abmc in teardown
---
 drivers/resctrl/mpam_devices.c  | 32 ++++++++++++--
 drivers/resctrl/mpam_internal.h |  4 ++
 drivers/resctrl/mpam_resctrl.c  | 76 ++++++++++++++++++++++++++++++++-
 3 files changed, 107 insertions(+), 5 deletions(-)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index 90d69091e0b9..528936ececd9 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -73,6 +73,14 @@ static DECLARE_WORK(mpam_broken_work, &mpam_disable);
 /* When mpam is disabled, the printed reason to aid debugging */
 static char *mpam_disable_reason;
 
+/*
+ * Whether resctrl has been setup. Used by cpuhp in preference to
+ * mpam_is_enabled(). The disable call after an error interrupt makes
+ * mpam_is_enabled() false before the cpuhp callbacks are made.
+ * Reads/writes should hold mpam_cpuhp_state_lock, (or be cpuhp callbacks).
+ */
+static bool mpam_resctrl_enabled;
+
 /*
  * An MSC is a physical container for controls and monitors, each identified by
  * their RIS index. These share a base-address, interrupts and some MMIO
@@ -1635,7 +1643,7 @@ static int mpam_cpu_online(unsigned int cpu)
 			mpam_reprogram_msc(msc);
 	}
 
-	if (mpam_is_enabled())
+	if (mpam_resctrl_enabled)
 		return mpam_resctrl_online_cpu(cpu);
 
 	return 0;
@@ -1681,7 +1689,7 @@ static int mpam_cpu_offline(unsigned int cpu)
 {
 	struct mpam_msc *msc;
 
-	if (mpam_is_enabled())
+	if (mpam_resctrl_enabled)
 		mpam_resctrl_offline_cpu(cpu);
 
 	guard(srcu)(&mpam_srcu);
@@ -2542,6 +2550,7 @@ static void mpam_enable_once(void)
 	}
 
 	static_branch_enable(&mpam_enabled);
+	mpam_resctrl_enabled = true;
 	mpam_register_cpuhp_callbacks(mpam_cpu_online, mpam_cpu_offline,
 				      "mpam:online");
 
@@ -2601,24 +2610,39 @@ static void mpam_reset_class(struct mpam_class *class)
 void mpam_disable(struct work_struct *ignored)
 {
 	int idx;
+	bool do_resctrl_exit;
 	struct mpam_class *class;
 	struct mpam_msc *msc, *tmp;
 
+	if (mpam_is_enabled())
+		static_branch_disable(&mpam_enabled);
+
 	mutex_lock(&mpam_cpuhp_state_lock);
 	if (mpam_cpuhp_state) {
 		cpuhp_remove_state(mpam_cpuhp_state);
 		mpam_cpuhp_state = 0;
 	}
+
+	/*
+	 * Removing the cpuhp state called mpam_cpu_offline() and told resctrl
+	 * all the CPUs are offline.
+	 */
+	do_resctrl_exit = mpam_resctrl_enabled;
+	mpam_resctrl_enabled = false;
 	mutex_unlock(&mpam_cpuhp_state_lock);
 
-	static_branch_disable(&mpam_enabled);
+	if (do_resctrl_exit)
+		mpam_resctrl_exit();
 
 	mpam_unregister_irqs();
 
 	idx = srcu_read_lock(&mpam_srcu);
 	list_for_each_entry_srcu(class, &mpam_classes, classes_list,
-				 srcu_read_lock_held(&mpam_srcu))
+				 srcu_read_lock_held(&mpam_srcu)) {
 		mpam_reset_class(class);
+		if (do_resctrl_exit)
+			mpam_resctrl_teardown_class(class);
+	}
 	srcu_read_unlock(&mpam_srcu, idx);
 
 	mutex_lock(&mpam_list_lock);
diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index 5fac8fa115ff..a79c7670f7ae 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -436,12 +436,16 @@ int mpam_get_cpumask_from_cache_id(unsigned long cache_id, u32 cache_level,
 
 #ifdef CONFIG_RESCTRL_FS
 int mpam_resctrl_setup(void);
+void mpam_resctrl_exit(void);
 int mpam_resctrl_online_cpu(unsigned int cpu);
 void mpam_resctrl_offline_cpu(unsigned int cpu);
+void mpam_resctrl_teardown_class(struct mpam_class *class);
 #else
 static inline int mpam_resctrl_setup(void) { return 0; }
+static inline void mpam_resctrl_exit(void) { }
 static inline int mpam_resctrl_online_cpu(unsigned int cpu) { return 0; }
 static inline void mpam_resctrl_offline_cpu(unsigned int cpu) { }
+static inline void mpam_resctrl_teardown_class(struct mpam_class *class) { }
 #endif /* CONFIG_RESCTRL_FS */
 
 /*
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 490e49ab730c..694ea8548a05 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -69,6 +69,12 @@ static bool cdp_enabled;
 static bool cacheinfo_ready;
 static DECLARE_WAIT_QUEUE_HEAD(wait_cacheinfo_ready);
 
+/*
+ * If resctrl_init() succeeded, resctrl_exit() can be used to remove support
+ * for the filesystem in the event of an error.
+ */
+static bool resctrl_enabled;
+
 /* Whether this num_mbw_mon could result in a free_running system */
 static int __mpam_monitors_free_running(u16 num_mbwu_mon)
 {
@@ -341,6 +347,9 @@ static int resctrl_arch_mon_ctx_alloc_no_wait(enum resctrl_event_id evtid)
 {
 	struct mpam_resctrl_mon *mon = &mpam_resctrl_counters[evtid];
 
+	if (!mpam_is_enabled())
+		return -EINVAL;
+
 	if (!mon->class)
 		return -EINVAL;
 
@@ -383,6 +392,9 @@ static void resctrl_arch_mon_ctx_free_no_wait(enum resctrl_event_id evtid,
 {
 	struct mpam_resctrl_mon *mon = &mpam_resctrl_counters[evtid];
 
+	if (!mpam_is_enabled())
+		return;
+
 	if (!mon->class)
 		return;
 
@@ -477,6 +489,9 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 
 	resctrl_arch_rmid_read_context_check();
 
+	if (!mpam_is_enabled())
+		return -EINVAL;
+
 	if (eventid >= QOS_NUM_EVENTS || !mon->class)
 		return -EINVAL;
 
@@ -1322,6 +1337,9 @@ int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_ctrl_domain *d,
 	lockdep_assert_cpus_held();
 	lockdep_assert_irqs_enabled();
 
+	if (!mpam_is_enabled())
+		return -EINVAL;
+
 	/*
 	 * No need to check the CPU as mpam_apply_config() doesn't care, and
 	 * resctrl_arch_update_domains() relies on this.
@@ -1387,6 +1405,9 @@ int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid)
 	lockdep_assert_cpus_held();
 	lockdep_assert_irqs_enabled();
 
+	if (!mpam_is_enabled())
+		return -EINVAL;
+
 	list_for_each_entry_rcu(d, &r->ctrl_domains, hdr.list) {
 		for (enum resctrl_conf_type t = 0; t < CDP_NUM_TYPES; t++) {
 			struct resctrl_staged_config *cfg = &d->staged_config[t];
@@ -1777,7 +1798,11 @@ int mpam_resctrl_setup(void)
 		return -EOPNOTSUPP;
 	}
 
-	/* TODO: call resctrl_init() */
+	err = resctrl_init();
+	if (err)
+		return err;
+
+	WRITE_ONCE(resctrl_enabled, true);
 
 	return 0;
 
@@ -1787,6 +1812,55 @@ int mpam_resctrl_setup(void)
 	return err;
 }
 
+void mpam_resctrl_exit(void)
+{
+	if (!READ_ONCE(resctrl_enabled))
+		return;
+
+	WRITE_ONCE(resctrl_enabled, false);
+	resctrl_exit();
+}
+
+static void mpam_resctrl_teardown_mon(struct mpam_resctrl_mon *mon, struct mpam_class *class)
+{
+	u32 num_mbwu_mon = resctrl_arch_system_num_rmid_idx();
+
+	if (!mon->mbwu_idx_to_mon)
+		return;
+
+	__free_mbwu_mon(class, mon->mbwu_idx_to_mon, num_mbwu_mon);
+	mon->mbwu_idx_to_mon = NULL;
+}
+
+/*
+ * The driver is detaching an MSC from this class, if resctrl was using it,
+ * pull on resctrl_exit().
+ */
+void mpam_resctrl_teardown_class(struct mpam_class *class)
+{
+	struct mpam_resctrl_res *res;
+	enum resctrl_res_level rid;
+	struct mpam_resctrl_mon *mon;
+	enum resctrl_event_id eventid;
+
+	might_sleep();
+
+	for_each_mpam_resctrl_control(res, rid) {
+		if (res->class == class) {
+			res->class = NULL;
+			break;
+		}
+	}
+	for_each_mpam_resctrl_mon(mon, eventid) {
+		if (mon->class == class) {
+			mon->class = NULL;
+
+			mpam_resctrl_teardown_mon(mon, class);
+			break;
+		}
+	}
+}
+
 static int __init __cacheinfo_ready(void)
 {
 	cacheinfo_ready = true;
-- 
2.43.0

