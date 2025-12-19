Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97BDC34FF45
	for <kvmarm@lists.linux.dev>; Fri, 19 Dec 2025 18:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766168057; cv=none; b=cw8r4hUyz2frVgWC1LT0L4KZnyd5+b5zD/nhKrQMY2Bbo88A6NIkHPCpj6wlGEyVoNg40kiWispugQ4BQnLHwGPDclsytwwsrCHUZHp8ySdvmKt0QrwJnDKE83H9JF0+1crD2jAfzRcM+8ljNYtqD8HUEgph0M/UrxDg+iEzNMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766168057; c=relaxed/simple;
	bh=hrefOMOKjcYEZ9lKwY9ncSPZiBYdg/Hq5od0M2NEaxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RctI44e5UyRDLKmVjEn1URZDUmVnzgKtJiUlQW1TYNUZhxy4ynAvNnM4tx4D11gyUM3GkeYZFYSjhRNZ/Lq2Y5ynrs/sS/Zjyw9D1ESSYz7LwOFD4JBCzFKLBBDVmEWat4rUrnNznghAjyPZsFcAY451UMjp6lAK6NaHgEePetI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD63E106F;
	Fri, 19 Dec 2025 10:14:04 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7D85D3F5CA;
	Fri, 19 Dec 2025 10:14:07 -0800 (PST)
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
Subject: [PATCH v2 27/45] arm_mpam: resctrl: Add support for csu counters
Date: Fri, 19 Dec 2025 18:11:29 +0000
Message-ID: <20251219181147.3404071-28-ben.horgan@arm.com>
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

resctrl exposes a counter via a file named llc_occupancy. This isn't really
a counter as its value goes up and down, this is a snapshot of the cache
storage usage monitor.

Add some picking code to find a cache as close as possible to the L3 that
supports the CSU monitor.

If there is an L3, but it doesn't have any controls, force the L3 resource
to exist. The existing topology_matches_l3() and
mpam_resctrl_domain_hdr_init() code will ensure this looks like the L3,
even if the class belongs to a later cache.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since rfc:
Allow csu counters however many partid or pmg there are
else if -> if
reduce scope of local variables
drop has_csu
---
 drivers/resctrl/mpam_internal.h |   6 ++
 drivers/resctrl/mpam_resctrl.c  | 148 ++++++++++++++++++++++++++++++++
 2 files changed, 154 insertions(+)

diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index b9a739abb101..9cb9eb97893b 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -345,6 +345,12 @@ struct mpam_resctrl_res {
 	struct rdt_resource	resctrl_res;
 };
 
+struct mpam_resctrl_mon {
+	struct mpam_class	*class;
+
+	/* per-class data that resctrl needs will live here */
+};
+
 static inline int mpam_alloc_csu_mon(struct mpam_class *class)
 {
 	struct mpam_props *cprops = &class->props;
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index f8d8c241797a..5fde610cc9d7 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -31,6 +31,16 @@ static struct mpam_resctrl_res mpam_resctrl_controls[RDT_NUM_RESOURCES];
 /* The lock for modifying resctrl's domain lists from cpuhp callbacks. */
 static DEFINE_MUTEX(domain_list_lock);
 
+/*
+ * The classes we've picked to map to resctrl events.
+ * Resctrl believes all the worlds a Xeon, and these are all on the L3. This
+ * array lets us find the actual class backing the event counters. e.g.
+ * the only memory bandwidth counters may be on the memory controller, but to
+ * make use of them, we pretend they are on L3.
+ * Class pointer may be NULL.
+ */
+static struct mpam_resctrl_mon mpam_resctrl_counters[QOS_NUM_EVENTS];
+
 static bool exposed_alloc_capable;
 static bool exposed_mon_capable;
 
@@ -258,6 +268,28 @@ static bool class_has_usable_mba(struct mpam_props *cprops)
 	return mba_class_use_mbw_max(cprops);
 }
 
+static bool cache_has_usable_csu(struct mpam_class *class)
+{
+	struct mpam_props *cprops;
+
+	if (!class)
+		return false;
+
+	cprops = &class->props;
+
+	if (!mpam_has_feature(mpam_feat_msmon_csu, cprops))
+		return false;
+
+	/*
+	 * CSU counters settle on the value, so we can get away with
+	 * having only one.
+	 */
+	if (!cprops->num_csu_mon)
+		return false;
+
+	return true;
+}
+
 /*
  * Calculate the worst-case percentage change from each implemented step
  * in the control.
@@ -498,6 +530,64 @@ static void mpam_resctrl_pick_mba(void)
 	}
 }
 
+static void counter_update_class(enum resctrl_event_id evt_id,
+				 struct mpam_class *class)
+{
+	struct mpam_class *existing_class = mpam_resctrl_counters[evt_id].class;
+
+	if (existing_class) {
+		if (class->level == 3) {
+			pr_debug("Existing class is L3 - L3 wins\n");
+			return;
+		}
+
+		if (existing_class->level < class->level) {
+			pr_debug("Existing class is closer to L3, %u versus %u - closer is better\n",
+				 existing_class->level, class->level);
+			return;
+		}
+	}
+
+	mpam_resctrl_counters[evt_id].class = class;
+	exposed_mon_capable = true;
+}
+
+static void mpam_resctrl_pick_counters(void)
+{
+	struct mpam_class *class;
+
+	lockdep_assert_cpus_held();
+
+	guard(srcu)(&mpam_srcu);
+	list_for_each_entry_srcu(class, &mpam_classes, classes_list,
+				 srcu_read_lock_held(&mpam_srcu)) {
+		if (class->level < 3) {
+			pr_debug("class %u is before L3", class->level);
+			continue;
+		}
+
+		if (!cpumask_equal(&class->affinity, cpu_possible_mask)) {
+			pr_debug("class %u does not cover all CPUs",
+				 class->level);
+			continue;
+		}
+
+		if (cache_has_usable_csu(class) && topology_matches_l3(class)) {
+			pr_debug("class %u has usable CSU, and matches L3 topology",
+				 class->level);
+
+			/* CSU counters only make sense on a cache. */
+			switch (class->type) {
+			case MPAM_CLASS_CACHE:
+				counter_update_class(QOS_L3_OCCUP_EVENT_ID, class);
+				return;
+			default:
+				return;
+			}
+		}
+	}
+}
+
 static int mpam_resctrl_control_init(struct mpam_resctrl_res *res,
 				     enum resctrl_res_level type)
 {
@@ -577,6 +667,50 @@ static int mpam_resctrl_pick_domain_id(int cpu, struct mpam_component *comp)
 	return comp->comp_id;
 }
 
+static void mpam_resctrl_monitor_init(struct mpam_resctrl_mon *mon,
+				      enum resctrl_event_id type)
+{
+	struct mpam_resctrl_res *res = &mpam_resctrl_controls[RDT_RESOURCE_L3];
+	struct rdt_resource *l3 = &res->resctrl_res;
+
+	lockdep_assert_cpus_held();
+
+	/* There also needs to be an L3 cache present */
+	if (get_cpu_cacheinfo_id(smp_processor_id(), 3) == -1)
+		return;
+
+	/*
+	 * If there are no MPAM resources on L3, force it into existence.
+	 * topology_matches_l3() already ensures this looks like the L3.
+	 * The domain-ids will be fixed up by mpam_resctrl_domain_hdr_init().
+	 */
+	if (!res->class) {
+		pr_warn_once("Faking L3 MSC to enable counters.\n");
+		res->class = mpam_resctrl_counters[type].class;
+	}
+
+	/* Called multiple times!, once per event type */
+	if (exposed_mon_capable) {
+		l3->mon_capable = true;
+
+		/* Setting name is necessary on monitor only platforms */
+		l3->name = "L3";
+		l3->mon_scope = RESCTRL_L3_CACHE;
+
+		resctrl_enable_mon_event(type);
+
+		/*
+		 * Unfortunately, num_rmid doesn't mean anything for
+		 * mpam, and its exposed to user-space!
+		 * num-rmid is supposed to mean the number of groups
+		 * that can be created, both control or monitor groups.
+		 * For mpam, each control group has its own pmg/rmid
+		 * space.
+		 */
+		l3->mon.num_rmid = 1;
+	}
+}
+
 u32 resctrl_arch_get_config(struct rdt_resource *r, struct rdt_ctrl_domain *d,
 			    u32 closid, enum resctrl_conf_type type)
 {
@@ -977,6 +1111,20 @@ int mpam_resctrl_setup(void)
 			break;
 		}
 	}
+
+	/* Find some classes to use for monitors */
+	mpam_resctrl_pick_counters();
+
+	for (enum resctrl_event_id j = 0; j < QOS_NUM_EVENTS; j++) {
+		struct mpam_resctrl_mon *mon;
+
+		mon = &mpam_resctrl_counters[j];
+		if (!mon->class)
+			continue;	// dummy resource
+
+		mpam_resctrl_monitor_init(mon, j);
+	}
+
 	cpus_read_unlock();
 
 	if (err) {
-- 
2.43.0

