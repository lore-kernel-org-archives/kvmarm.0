Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2ECE379966
	for <kvmarm@lists.linux.dev>; Tue,  3 Feb 2026 21:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770155206; cv=none; b=Qx6oYfU9PtLltWEF2hgKN7XyEiBAzQjkTwWi/l0atFNFNjRb/QPhUXjgIqF/gdIZm8n/2qMDOKlWnseKxDeFCkx2b1l73muLqNPbb3jiYxD4cmCWe7GqfsAIJYqL0L6kg3iCe8tXT9y/U1PafOS6z3QiOtOu+OZ00cBl00EZr1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770155206; c=relaxed/simple;
	bh=dyQwDENQQyPXBc6QRfbvExcUHWlHSl+kE8GLSxMNjtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/AA4yP9UIZBBfAhPTsmy19S2ZP+vOHn/TGgFSf1TyZGYqzjfhGVpR9N2lC7CFWj15YY+lfiPuggNbwp6qrTFL1h4TCCtFCdpHOuPEtN9mJXp5ZLl1XrlYZ+9Vmhj6c9ru/oyLh+a3BdBImFetven36L4yTgXEXevjLDegYyy3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 03293497;
	Tue,  3 Feb 2026 13:46:38 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F14073F778;
	Tue,  3 Feb 2026 13:46:38 -0800 (PST)
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
Subject: [PATCH v4 28/41] arm_mpam: resctrl: Pick classes for use as mbm counters
Date: Tue,  3 Feb 2026 21:43:29 +0000
Message-ID: <20260203214342.584712-29-ben.horgan@arm.com>
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

resctrl has two types of counters, NUMA-local and global. MPAM can only
count global either using MSC at the L3 cache or in the memory controllers.
When global and local equate to the same thing continue just to call it
global.

Because the class or component backing the event may not be 'the L3', it is
necessary for mpam_resctrl_get_domain_from_cpu() to search the monitor
domains too. This matters the most for 'monitor only' systems, where 'the
L3' control domains may be empty, and the ctrl_comp pointer NULL.

resctrl expects there to be enough monitors for every possible control and
monitor group to have one. Such a system gets called 'free running' as the
monitors can be programmed once and left running.  Any other platform will
need to emulate ABMC.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since rfc:
drop has_mbwu

Changes since v2:
Iterate over mpam_resctrl_dom directly (Jonathan)
Use for_each_mpam_resctrl_mon

Changes since v3:
Don't continue if mon not found to avoid NULL pointer deref
use int for cache_id in mpam_resctrl_alloc_domain()
Update commit message
Take traffic into account
Only use mbm_total.

Drop tags due to rework

Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 drivers/resctrl/mpam_internal.h |   8 +++
 drivers/resctrl/mpam_resctrl.c  | 122 +++++++++++++++++++++++++++++++-
 2 files changed, 129 insertions(+), 1 deletion(-)

diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index 58b883fe9d30..bab6eea60dae 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -336,6 +336,14 @@ struct mpam_msc_ris {
 
 struct mpam_resctrl_dom {
 	struct mpam_component		*ctrl_comp;
+
+	/*
+	 * There is no single mon_comp because different events may be backed
+	 * by different class/components. mon_comp is indexed by the event
+	 * number.
+	 */
+	struct mpam_component		*mon_comp[QOS_NUM_EVENTS];
+
 	struct rdt_ctrl_domain		resctrl_ctrl_dom;
 	struct rdt_l3_mon_domain	resctrl_mon_dom;
 };
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 638fdca7caea..c96c434c9454 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -70,6 +70,14 @@ static bool cdp_enabled;
 static bool cacheinfo_ready;
 static DECLARE_WAIT_QUEUE_HEAD(wait_cacheinfo_ready);
 
+/* Whether this num_mbw_mon could result in a free_running system */
+static int __mpam_monitors_free_running(u16 num_mbwu_mon)
+{
+	if (num_mbwu_mon >= resctrl_arch_system_num_rmid_idx())
+		return resctrl_arch_system_num_rmid_idx();
+	return 0;
+}
+
 bool resctrl_arch_alloc_capable(void)
 {
 	return exposed_alloc_capable;
@@ -303,6 +311,26 @@ static bool cache_has_usable_csu(struct mpam_class *class)
 	return true;
 }
 
+static bool class_has_usable_mbwu(struct mpam_class *class)
+{
+	struct mpam_props *cprops = &class->props;
+
+	if (!mpam_has_feature(mpam_feat_msmon_mbwu, cprops))
+		return false;
+
+	/*
+	 * resctrl expects the bandwidth counters to be free running,
+	 * which means we need as many monitors as resctrl has
+	 * control/monitor groups.
+	 */
+	if (__mpam_monitors_free_running(cprops->num_mbwu_mon)) {
+		pr_debug("monitors usable in free-running mode\n");
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * Calculate the worst-case percentage change from each implemented step
  * in the control.
@@ -673,6 +701,22 @@ static void mpam_resctrl_pick_counters(void)
 				break;
 			}
 		}
+
+		if (class_has_usable_mbwu(class) &&
+		    topology_matches_l3(class) &&
+		    traffic_matches_l3(class)) {
+			pr_debug("class %u has usable MBWU, and matches L3 topology and traffic\n",
+				 class->level);
+
+			/*
+			 * We can't distinguish traffic by destination so
+			 * we don't know if it's staying on the same NUMA
+			 * node. Hence, we can't calculate mbm_local except
+			 * when we only have one L3 and it's equivalent to
+			 * mbm_total and so always use mbm_total.
+			 */
+			counter_update_class(QOS_L3_MBM_TOTAL_EVENT_ID, class);
+		}
 	}
 }
 
@@ -1024,6 +1068,20 @@ static void mpam_resctrl_domain_insert(struct list_head *list,
 	list_add_tail_rcu(&new->list, pos);
 }
 
+static struct mpam_component *find_component(struct mpam_class *class, int cpu)
+{
+	struct mpam_component *comp;
+
+	guard(srcu)(&mpam_srcu);
+	list_for_each_entry_srcu(comp, &class->components, class_list,
+				 srcu_read_lock_held(&mpam_srcu)) {
+		if (cpumask_test_cpu(cpu, &comp->affinity))
+			return comp;
+	}
+
+	return NULL;
+}
+
 static struct mpam_resctrl_dom *
 mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 {
@@ -1071,6 +1129,35 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 	}
 
 	if (exposed_mon_capable) {
+		struct mpam_component *any_mon_comp;
+		struct mpam_resctrl_mon *mon;
+		enum resctrl_event_id eventid;
+
+		/*
+		 * Even if the monitor domain is backed by a different
+		 * component, the L3 component IDs need to be used... only
+		 * there may be no ctrl_comp for the L3.
+		 * Search each event's class list for a component with
+		 * overlapping CPUs and set up the dom->mon_comp array.
+		 */
+
+		for_each_mpam_resctrl_mon(mon, eventid) {
+			struct mpam_component *mon_comp;
+
+			if (!mon->class)
+				continue;       // dummy resource
+
+			mon_comp = find_component(mon->class, cpu);
+			dom->mon_comp[eventid] = mon_comp;
+			if (mon_comp)
+				any_mon_comp = mon_comp;
+		}
+		if (!any_mon_comp) {
+			WARN_ON_ONCE(0);
+			err = -EFAULT;
+			goto offline_ctrl_domain;
+		}
+
 		mon_d = &dom->resctrl_mon_dom;
 		mpam_resctrl_domain_hdr_init(cpu, any_mon_comp, &mon_d->hdr);
 		mon_d->hdr.type = RESCTRL_MON_DOMAIN;
@@ -1097,6 +1184,35 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 	return dom;
 }
 
+/*
+ * We know all the monitors are associated with the L3, even if there are no
+ * controls and therefore no control component. Find the cache-id for the CPU
+ * and use that to search for existing resctrl domains.
+ * This relies on mpam_resctrl_pick_domain_id() using the L3 cache-id
+ * for anything that is not a cache.
+ */
+static struct mpam_resctrl_dom *mpam_resctrl_get_mon_domain_from_cpu(int cpu)
+{
+	int cache_id;
+	struct mpam_resctrl_dom *dom;
+	struct mpam_resctrl_res *l3 = &mpam_resctrl_controls[RDT_RESOURCE_L3];
+
+	lockdep_assert_cpus_held();
+
+	if (!l3->class)
+		return NULL;
+	cache_id = get_cpu_cacheinfo_id(cpu, 3);
+	if (cache_id < 0)
+		return NULL;
+
+	list_for_each_entry_rcu(dom, &l3->resctrl_res.mon_domains, resctrl_mon_dom.hdr.list) {
+		if (dom->resctrl_mon_dom.hdr.id == cache_id)
+			return dom;
+	}
+
+	return NULL;
+}
+
 static struct mpam_resctrl_dom *
 mpam_resctrl_get_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
 {
@@ -1110,7 +1226,11 @@ mpam_resctrl_get_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
 			return dom;
 	}
 
-	return NULL;
+	if (r->rid != RDT_RESOURCE_L3)
+		return NULL;
+
+	/* Search the mon domain list too - needed on monitor only platforms. */
+	return mpam_resctrl_get_mon_domain_from_cpu(cpu);
 }
 
 int mpam_resctrl_online_cpu(unsigned int cpu)
-- 
2.43.0

