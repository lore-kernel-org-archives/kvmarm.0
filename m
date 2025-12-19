Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8E2435BDC5
	for <kvmarm@lists.linux.dev>; Fri, 19 Dec 2025 18:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766168112; cv=none; b=ubAKHuZ3ZBCwm/F0DGnQ+UQllsEYf1PCTwChQmO2mYKS0fs/GckJiTC9QbXShi5l62/7ZBuZrRcaVs76pKIWYBOdkZ9NiKvlKpeaaK1OsGwGCPHt2mo/kFmmIz0rZeCufC7gZMWtjf6r7nDUwcoYQuuBXDlvuGPfJdDNnGbZEcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766168112; c=relaxed/simple;
	bh=6BrV2KWiwVGN20d9R1GSMshR7BF700y4UntRTdnDkzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhYPX+EBvsdk+TkVAkDsG4LCYEfocT/iNmjVz6Pj4RhLwLKWhsQSBxUkXEATRqEp8dERd6jtR/xyaMOhV7frxA/adWKuYWJroBbZYRUnt9yZogG2ep2VpGuod1LiJgaa3u6mqaxDol99sOv5YGYcH2u+XztXQ6fW6vKwpjXO1vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FFF8169E;
	Fri, 19 Dec 2025 10:15:01 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 113123F5CA;
	Fri, 19 Dec 2025 10:15:03 -0800 (PST)
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
Subject: [PATCH v2 39/45] arm_mpam: resctrl: Call resctrl_init() on platforms that can support resctrl
Date: Fri, 19 Dec 2025 18:11:41 +0000
Message-ID: <20251219181147.3404071-40-ben.horgan@arm.com>
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

Now that MPAM links against resctrl, call resctrl_init() to register the
filesystem and setup resctrl's structures.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 drivers/resctrl/mpam_devices.c  | 32 +++++++++++--
 drivers/resctrl/mpam_internal.h |  4 ++
 drivers/resctrl/mpam_resctrl.c  | 82 ++++++++++++++++++++++++++++++++-
 3 files changed, 113 insertions(+), 5 deletions(-)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index 4f5d908d02a9..c20b2757b86b 100644
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
@@ -1628,7 +1636,7 @@ static int mpam_cpu_online(unsigned int cpu)
 			mpam_reprogram_msc(msc);
 	}
 
-	if (mpam_is_enabled())
+	if (mpam_resctrl_enabled)
 		mpam_resctrl_online_cpu(cpu);
 
 	return 0;
@@ -1674,7 +1682,7 @@ static int mpam_cpu_offline(unsigned int cpu)
 {
 	struct mpam_msc *msc;
 
-	if (mpam_is_enabled())
+	if (mpam_resctrl_enabled)
 		mpam_resctrl_offline_cpu(cpu);
 
 	guard(srcu)(&mpam_srcu);
@@ -2536,6 +2544,7 @@ static void mpam_enable_once(void)
 	}
 
 	static_branch_enable(&mpam_enabled);
+	mpam_resctrl_enabled = true;
 	mpam_register_cpuhp_callbacks(mpam_cpu_online, mpam_cpu_offline,
 				      "mpam:online");
 
@@ -2595,24 +2604,39 @@ void mpam_reset_class(struct mpam_class *class)
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
index b907bec96ba5..9a3996decda5 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -447,12 +447,16 @@ int mpam_get_cpumask_from_cache_id(unsigned long cache_id, u32 cache_level,
 
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
index 059148c38a38..bbb12b5dfd8c 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -53,6 +53,12 @@ static bool exposed_mon_capable;
  */
 static bool cdp_enabled;
 
+/*
+ * If resctrl_init() succeeded, resctrl_exit() can be used to remove support
+ * for the filesystem in the event of an error.
+ */
+static bool resctrl_enabled;
+
 /*
  * mpam_resctrl_pick_caches() needs to know the size of the caches. cacheinfo
  * populates this from a device_initcall(). mpam_resctrl_setup() must wait.
@@ -318,6 +324,9 @@ static int resctrl_arch_mon_ctx_alloc_no_wait(enum resctrl_event_id evtid)
 {
 	struct mpam_resctrl_mon *mon = &mpam_resctrl_counters[evtid];
 
+	if (!mpam_is_enabled())
+		return -EINVAL;
+
 	if (!mon->class)
 		return -EINVAL;
 
@@ -360,6 +369,9 @@ static void resctrl_arch_mon_ctx_free_no_wait(enum resctrl_event_id evtid,
 {
 	struct mpam_resctrl_mon *mon = &mpam_resctrl_counters[evtid];
 
+	if (!mpam_is_enabled())
+		return;
+
 	if (!mon->class)
 		return;
 
@@ -461,6 +473,9 @@ int resctrl_arch_rmid_read(struct rdt_resource	*r, struct rdt_mon_domain *d,
 
 	resctrl_arch_rmid_read_context_check();
 
+	if (!mpam_is_enabled())
+		return -EINVAL;
+
 	if (eventid >= QOS_NUM_EVENTS || !mon->class)
 		return -EINVAL;
 
@@ -1399,6 +1414,9 @@ int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_ctrl_domain *d,
 	lockdep_assert_cpus_held();
 	lockdep_assert_irqs_enabled();
 
+	if (!mpam_is_enabled())
+		return -EINVAL;
+
 	/*
 	 * No need to check the CPU as mpam_apply_config() doesn't care, and
 	 * resctrl_arch_update_domains() relies on this.
@@ -1461,6 +1479,9 @@ int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid)
 	lockdep_assert_cpus_held();
 	lockdep_assert_irqs_enabled();
 
+	if (!mpam_is_enabled())
+		return -EINVAL;
+
 	list_for_each_entry_rcu(d, &r->ctrl_domains, hdr.list) {
 		for (enum resctrl_conf_type t = 0; t < CDP_NUM_TYPES; t++) {
 			struct resctrl_staged_config *cfg = &d->staged_config[t];
@@ -1840,11 +1861,70 @@ int mpam_resctrl_setup(void)
 		pr_warn("Number of PMG is not a power of 2! resctrl may misbehave");
 	}
 
-	/* TODO: call resctrl_init() */
+	err = resctrl_init();
+	if (!err)
+		WRITE_ONCE(resctrl_enabled, true);
 
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
+	u32 num_mbwu_mon = l3_num_allocated_mbwu;
+
+	if (!mon->mbwu_idx_to_mon)
+		return;
+
+	if (mon->assigned_counters) {
+		__free_mbwu_mon(class, mon->assigned_counters, num_mbwu_mon);
+		mon->assigned_counters = NULL;
+		kfree(mon->mbwu_idx_to_mon);
+	} else {
+		__free_mbwu_mon(class, mon->mbwu_idx_to_mon, num_mbwu_mon);
+	}
+	mon->mbwu_idx_to_mon = NULL;
+}
+
+/*
+ * The driver is detaching an MSC from this class, if resctrl was using it,
+ * pull on resctrl_exit().
+ */
+void mpam_resctrl_teardown_class(struct mpam_class *class)
+{
+	int i;
+	struct mpam_resctrl_res *res;
+	struct mpam_resctrl_mon *mon;
+
+	might_sleep();
+
+	for (i = 0; i < RDT_NUM_RESOURCES; i++) {
+		res = &mpam_resctrl_controls[i];
+		if (res->class == class) {
+			res->class = NULL;
+			break;
+		}
+	}
+	for (i = 0; i < QOS_NUM_EVENTS; i++) {
+		mon = &mpam_resctrl_counters[i];
+		if (mon->class == class) {
+			mon->class = NULL;
+
+			mpam_resctrl_teardown_mon(mon, class);
+
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

