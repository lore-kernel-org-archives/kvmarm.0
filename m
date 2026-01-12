Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 849EA3793DB
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 17:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768237353; cv=none; b=iwonKa1vmdrNZKI8mHEgFjjCyqTNTuhvwQ+czPwplsgpI2lDDM/67weF/7ehCB0o9AFq/b101AtlVZoGPAWnjnwd/Vk+PTBdC1maY9NiF2Q3CDQBhipqnj8CUma0UHBwYsobG4KRzE2O53M2sn83BhW7nXMLatAFha33Ofp8ENg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768237353; c=relaxed/simple;
	bh=uQCU2G2fy7oXxzi+PsVHnPThoGtl+LGaEODMtXxdajA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEhe0eT9jtDq5p0ED2h3hvh7gPequwVQC7pribScQ3ACpjbt1yd9KLE1G/C+cQOxiSlkhcjmVoXiV7EeYs6jr0SYa1hmodpd3gQapKwkxcXzyQ8EMd+F7Iihk8fQJvDCnL64mH8Q4Ut/fDikh1hV7NduKQxqnI2snLB3xst5Ybg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D6F37153B;
	Mon, 12 Jan 2026 09:02:22 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7CA563F694;
	Mon, 12 Jan 2026 09:02:24 -0800 (PST)
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
Subject: [PATCH v3 29/47] arm_mpam: resctrl: Pick classes for use as mbm counters
Date: Mon, 12 Jan 2026 16:58:56 +0000
Message-ID: <20260112165914.4086692-30-ben.horgan@arm.com>
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

resctrl has two types of counters, NUMA-local and global. MPAM has only
bandwidth counters, but the position of the MSC may mean it counts
NUMA-local, or global traffic.

But the topology information is not available.

Apply a heuristic: the L2 or L3 supports bandwidth monitors, these are
probably NUMA-local. If the memory controller supports bandwidth monitors,
they are probably global.

This also allows us to assert that we don't have the same class backing two
different resctrl events.

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
---
 drivers/resctrl/mpam_internal.h |   8 ++
 drivers/resctrl/mpam_resctrl.c  | 133 +++++++++++++++++++++++++++++++-
 2 files changed, 139 insertions(+), 2 deletions(-)

diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index 21cc776e57aa..1c5492008fe8 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -340,6 +340,14 @@ struct mpam_msc_ris {
 
 struct mpam_resctrl_dom {
 	struct mpam_component	*ctrl_comp;
+
+	/*
+	 * There is no single mon_comp because different events may be backed
+	 * by different class/components. mon_comp is indexed by the event
+	 * number.
+	 */
+	struct mpam_component   *mon_comp[QOS_NUM_EVENTS];
+
 	struct rdt_ctrl_domain	resctrl_ctrl_dom;
 	struct rdt_mon_domain	resctrl_mon_dom;
 };
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 5020a5faed96..14a8dcaf1366 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -68,6 +68,14 @@ static bool cdp_enabled;
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
@@ -296,6 +304,26 @@ static bool cache_has_usable_csu(struct mpam_class *class)
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
@@ -599,7 +627,36 @@ static void mpam_resctrl_pick_counters(void)
 				break;
 			}
 		}
+
+		if (class_has_usable_mbwu(class) && topology_matches_l3(class)) {
+			pr_debug("class %u has usable MBWU, and matches L3 topology",
+				 class->level);
+
+			/*
+			 * MBWU counters may be 'local' or 'total' depending on
+			 * where they are in the topology. Counters on caches
+			 * are assumed to be local. If it's on the memory
+			 * controller, its assumed to be global.
+			 */
+			switch (class->type) {
+			case MPAM_CLASS_CACHE:
+				counter_update_class(QOS_L3_MBM_LOCAL_EVENT_ID,
+						     class);
+				break;
+			case MPAM_CLASS_MEMORY:
+				counter_update_class(QOS_L3_MBM_TOTAL_EVENT_ID,
+						     class);
+				break;
+			default:
+				break;
+			}
+		}
 	}
+
+	/* Allocation of MBWU monitors assumes that the class is unique... */
+	if (mpam_resctrl_counters[QOS_L3_MBM_LOCAL_EVENT_ID].class)
+		WARN_ON_ONCE(mpam_resctrl_counters[QOS_L3_MBM_LOCAL_EVENT_ID].class ==
+			     mpam_resctrl_counters[QOS_L3_MBM_TOTAL_EVENT_ID].class);
 }
 
 static int mpam_resctrl_control_init(struct mpam_resctrl_res *res)
@@ -942,6 +999,20 @@ static void mpam_resctrl_domain_insert(struct list_head *list,
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
@@ -990,8 +1061,33 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
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
+		WARN_ON_ONCE(!any_mon_comp);
+
 		mon_d = &dom->resctrl_mon_dom;
-		mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, &mon_d->hdr);
+		mpam_resctrl_domain_hdr_init(cpu, any_mon_comp, &mon_d->hdr);
 		mon_d->hdr.type = RESCTRL_MON_DOMAIN;
 		mpam_resctrl_domain_insert(&r->mon_domains, &mon_d->hdr);
 		err = resctrl_online_mon_domain(r, mon_d);
@@ -1013,6 +1109,35 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
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
+	u32 cache_id;
+	struct mpam_resctrl_dom *dom;
+	struct mpam_resctrl_res *l3 = &mpam_resctrl_controls[RDT_RESOURCE_L3];
+
+	lockdep_assert_cpus_held();
+
+	if (!l3->class)
+		return NULL;
+	cache_id = get_cpu_cacheinfo_id(cpu, 3);
+	if (cache_id == ~0)
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
@@ -1026,7 +1151,11 @@ mpam_resctrl_get_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
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

