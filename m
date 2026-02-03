Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C72137419F
	for <kvmarm@lists.linux.dev>; Tue,  3 Feb 2026 21:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770155200; cv=none; b=U2Z86Me2V+8XJXMwmmimuPHR2k+CKTP0YLc7uCab7dvRBIZ3SZNfFBtG7/pijeG7a9Oq/rqF6flI/q/xstknA8/EYOoe3tVLDwmRTHaYi52tHDCZIcR06vgygUTdsw8lWVRR/amNvU1a4eUgPTqlcgHOFJ5x0rPN97RKido9kQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770155200; c=relaxed/simple;
	bh=G0jSNWIktJ9uRVxlsGupKNPOIkcQB8V45/HejItPtl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTtpjPgyLOFgf3ukGdm5R8cLie1qAX4DVOTIgCXbeG4ooJpGDii0Dm6nWzagV7uIJkJ9oRm8U6MnIRxMNof6ZA1oI7Hia1yyb9jPJJdpQBV02UlbZGHaSGi+JZN12po7B/cVYgmrq9v7NOXvsnDDastcqboMnAKNuYoOHRpmGSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44604497;
	Tue,  3 Feb 2026 13:46:32 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3CFFB3F778;
	Tue,  3 Feb 2026 13:46:33 -0800 (PST)
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
	linux-doc@vger.kernel.org
Subject: [PATCH v4 27/41] arm_mpam: resctrl: Add support for csu counters
Date: Tue,  3 Feb 2026 21:43:28 +0000
Message-ID: <20260203214342.584712-28-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260203214342.584712-1-ben.horgan@arm.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
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

Add some picking code which will only find an L3. The resctrl counter
file is called llc_occupancy but we don't check it is the last one as
it is already identified as L3.

Signed-off-by: James Morse <james.morse@arm.com>
Co-developed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since rfc:
Allow csu counters however many partid or pmg there are
else if -> if
reduce scope of local variables
drop has_csu

Changes since v2:
return -> break so works for mbwu in later patch
add for_each_mpam_resctrl_mon
return error from mpam_resctrl_monitor_init(). It may fail when is abmc
allocation introduced in a later patch.
Squashed in patch from Dave Martin:
https://lore.kernel.org/lkml/20250820131621.54983-1-Dave.Martin@arm.com/

Changes since v3:
resctrl_enable_mon_event() signature update
Restrict the events considered
num-rmid update
Use raw_smp_processor_id()
Tighten heuristics:
 Make sure it is the L3
 Please shout if this means the counters aren't exposed on any platforms
Drop tags due to change in policy/rework

Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 drivers/resctrl/mpam_internal.h |   6 ++
 drivers/resctrl/mpam_resctrl.c  | 176 +++++++++++++++++++++++++++++++-
 2 files changed, 177 insertions(+), 5 deletions(-)

diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index 21ade1620147..58b883fe9d30 100644
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
index 4cca3694978d..638fdca7caea 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -37,6 +37,23 @@ static struct mpam_resctrl_res mpam_resctrl_controls[RDT_NUM_RESOURCES];
 /* The lock for modifying resctrl's domain lists from cpuhp callbacks. */
 static DEFINE_MUTEX(domain_list_lock);
 
+/*
+ * The classes we've picked to map to resctrl events.
+ * Resctrl believes all the worlds a Xeon, and these are all on the L3. This
+ * array lets us find the actual class backing the event counters. e.g.
+ * the only memory bandwidth counters may be on the memory controller, but to
+ * make use of them, we pretend they are on L3. Restrict the events considered
+ * to those supported by MPAM.
+ * Class pointer may be NULL.
+ */
+#define MPAM_MAX_EVENT QOS_L3_MBM_TOTAL_EVENT_ID
+static struct mpam_resctrl_mon mpam_resctrl_counters[MPAM_MAX_EVENT + 1];
+
+#define for_each_mpam_resctrl_mon(mon, eventid)					\
+	for (eventid = QOS_FIRST_EVENT, mon = &mpam_resctrl_counters[eventid];	\
+	     eventid <= MPAM_MAX_EVENT;						\
+	     eventid++, mon = &mpam_resctrl_counters[eventid])
+
 static bool exposed_alloc_capable;
 static bool exposed_mon_capable;
 
@@ -264,6 +281,28 @@ static bool class_has_usable_mba(struct mpam_props *cprops)
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
@@ -578,6 +617,65 @@ static void mpam_resctrl_pick_mba(void)
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
+		/* The name of the resource is L3... */
+		if (class->type == MPAM_CLASS_CACHE && class->level != 3) {
+			pr_debug("class %u is a cache but not the L3", class->level);
+			continue;
+		}
+
+		if (!cpumask_equal(&class->affinity, cpu_possible_mask)) {
+			pr_debug("class %u does not cover all CPUs",
+				 class->level);
+			continue;
+		}
+
+		if (cache_has_usable_csu(class)) {
+			pr_debug("class %u has usable CSU",
+				 class->level);
+
+			/* CSU counters only make sense on a cache. */
+			switch (class->type) {
+			case MPAM_CLASS_CACHE:
+				counter_update_class(QOS_L3_OCCUP_EVENT_ID, class);
+				break;
+			default:
+				break;
+			}
+		}
+	}
+}
+
 static int mpam_resctrl_control_init(struct mpam_resctrl_res *res)
 {
 	struct mpam_class *class = res->class;
@@ -653,6 +751,57 @@ static int mpam_resctrl_pick_domain_id(int cpu, struct mpam_component *comp)
 	return comp->comp_id;
 }
 
+static int mpam_resctrl_monitor_init(struct mpam_resctrl_mon *mon,
+				     enum resctrl_event_id type)
+{
+	struct mpam_resctrl_res *res = &mpam_resctrl_controls[RDT_RESOURCE_L3];
+	struct rdt_resource *l3 = &res->resctrl_res;
+
+	lockdep_assert_cpus_held();
+
+	/*
+	 * There also needs to be an L3 cache present.
+	 * The check just requires any online CPU and it can't go offline as we
+	 * hold the cpu lock.
+	 */
+	if (get_cpu_cacheinfo_id(raw_smp_processor_id(), 3) == -1)
+		return 0;
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
+		resctrl_enable_mon_event(type, false, 0, NULL);
+
+		/*
+		 * num-rmid is the upper bound for the number of monitoring
+		 * groups that can exist simultaneously, including the
+		 * default monitoring group for each control group. Hence,
+		 * advertise the whole rmid_idx space even though each
+		 * control group has its own pmg/rmid space. Unfortunately,
+		 * this does mean userspace needs to know the architecture
+		 * to correctly interpret this value.
+		 */
+		l3->mon.num_rmid = resctrl_arch_system_num_rmid_idx();
+	}
+
+	return 0;
+}
+
 u32 resctrl_arch_get_config(struct rdt_resource *r, struct rdt_ctrl_domain *d,
 			    u32 closid, enum resctrl_conf_type type)
 {
@@ -1049,6 +1198,8 @@ int mpam_resctrl_setup(void)
 	int err = 0;
 	struct mpam_resctrl_res *res;
 	enum resctrl_res_level rid;
+	struct mpam_resctrl_mon *mon;
+	enum resctrl_event_id eventid;
 
 	wait_event(wait_cacheinfo_ready, cacheinfo_ready);
 
@@ -1071,16 +1222,26 @@ int mpam_resctrl_setup(void)
 		err = mpam_resctrl_control_init(res);
 		if (err) {
 			pr_debug("Failed to initialise rid %u\n", rid);
-			break;
+			goto internal_error;
 		}
 	}
-	cpus_read_unlock();
 
-	if (err) {
-		pr_debug("Internal error %d - resctrl not supported\n", err);
-		return err;
+	/* Find some classes to use for monitors */
+	mpam_resctrl_pick_counters();
+
+	for_each_mpam_resctrl_mon(mon, eventid) {
+		if (!mon->class)
+			continue;	// dummy resource
+
+		err = mpam_resctrl_monitor_init(mon, eventid);
+		if (err) {
+			pr_debug("Failed to initialise event %u\n", eventid);
+			goto internal_error;
+		}
 	}
 
+	cpus_read_unlock();
+
 	if (!exposed_alloc_capable && !exposed_mon_capable) {
 		pr_debug("No alloc(%u) or monitor(%u) found - resctrl not supported\n",
 			 exposed_alloc_capable, exposed_mon_capable);
@@ -1090,6 +1251,11 @@ int mpam_resctrl_setup(void)
 	/* TODO: call resctrl_init() */
 
 	return 0;
+
+internal_error:
+	cpus_read_unlock();
+	pr_debug("Internal error %d - resctrl not supported\n", err);
+	return err;
 }
 
 static int __init __cacheinfo_ready(void)
-- 
2.43.0

