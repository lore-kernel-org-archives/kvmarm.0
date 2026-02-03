Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 656F637418B
	for <kvmarm@lists.linux.dev>; Tue,  3 Feb 2026 21:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770155195; cv=none; b=TQO+t1zq+77GIb47V4yKXWxeivkYaDsF08L5qZirBxyT70UcQF47gkphARbnv0YVW98JUIXWIhG6O/WkZ0xbVx/llZm6SvcPyVPlnVyhWuYuP/iidVVA6o4iy2g7IUZjwVIK+4fIzi8f1bD0F231C9exfCyRdBu5bjDBYRabdvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770155195; c=relaxed/simple;
	bh=efJU3r8zsXAavDAAc7d25hWiWPMU6jDMeTZ2Jpdrd9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cq+N6FCI60Xc5rKRf0U0KDZRBg9VK1JOFBTTnohD+h1huXxhCGSI4JPXQunSXn7kkIQnEqgDnv/F3P0MLJKkrMyUWCjUqXANjZB+RPhv3xi0+sHBYkHXID0aMTmHP7Yyk8+w91QijQNLZvF6aCqnYs9QsSO5GoTedSOSvl3l874=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83EDB497;
	Tue,  3 Feb 2026 13:46:26 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5AC1E3F778;
	Tue,  3 Feb 2026 13:46:27 -0800 (PST)
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
	Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v4 26/41] arm_mpam: resctrl: Add support for 'MB' resource
Date: Tue,  3 Feb 2026 21:43:27 +0000
Message-ID: <20260203214342.584712-27-ben.horgan@arm.com>
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

resctrl supports 'MB', as a percentage throttling of traffic from the
L3. This is the control that mba_sc uses, so ideally the class chosen
should be as close as possible to the counters used for mbm_total. If
there is a single L3 and the topology of the memory matches then the
traffic at the memory controller will be equivalent to that at egress of
the L3. If these conditions are met allow the memory class to back MB.

MB's percentage control should be backed either with the fixed point
fraction MBW_MAX or bandwidth portion bitmaps. The bandwidth portion
bitmaps is not used as its tricky to pick which bits to use to avoid
contention, and may be possible to expose this as something other than a
percentage in the future.

CC: Zeng Heng <zengheng4@huawei.com>
Co-developed-by: Dave Martin <Dave.Martin@arm.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since v2:
Code flow change
Commit message 'or'

Changes since v3:
initialise tmp_cpumask
update commit message
check the traffic matches l3
update comment on candidate_class update, only mbm_total
drop tags due to rework
---
 drivers/resctrl/mpam_resctrl.c | 275 ++++++++++++++++++++++++++++++++-
 1 file changed, 274 insertions(+), 1 deletion(-)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 25950e667077..4cca3694978d 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -253,6 +253,33 @@ static bool cache_has_usable_cpor(struct mpam_class *class)
 	return class->props.cpbm_wd <= 32;
 }
 
+static bool mba_class_use_mbw_max(struct mpam_props *cprops)
+{
+	return (mpam_has_feature(mpam_feat_mbw_max, cprops) &&
+		cprops->bwa_wd);
+}
+
+static bool class_has_usable_mba(struct mpam_props *cprops)
+{
+	return mba_class_use_mbw_max(cprops);
+}
+
+/*
+ * Calculate the worst-case percentage change from each implemented step
+ * in the control.
+ */
+static u32 get_mba_granularity(struct mpam_props *cprops)
+{
+	if (!mba_class_use_mbw_max(cprops))
+		return 0;
+
+	/*
+	 * bwa_wd is the number of bits implemented in the 0.xxx
+	 * fixed point fraction. 1 bit is 50%, 2 is 25% etc.
+	 */
+	return DIV_ROUND_UP(MAX_MBA_BW, 1 << cprops->bwa_wd);
+}
+
 /*
  * Each fixed-point hardware value architecturally represents a range
  * of values: the full range 0% - 100% is split contiguously into
@@ -303,6 +330,153 @@ static u16 percent_to_mbw_max(u8 pc, struct mpam_props *cprops)
 	return val;
 }
 
+static u32 get_mba_min(struct mpam_props *cprops)
+{
+	if (!mba_class_use_mbw_max(cprops)) {
+		WARN_ON_ONCE(1);
+		return 0;
+	}
+
+	return mbw_max_to_percent(0, cprops);
+}
+
+/* Find the L3 cache that has affinity with this CPU */
+static int find_l3_equivalent_bitmask(int cpu, cpumask_var_t tmp_cpumask)
+{
+	u32 cache_id = get_cpu_cacheinfo_id(cpu, 3);
+
+	lockdep_assert_cpus_held();
+
+	return mpam_get_cpumask_from_cache_id(cache_id, 3, tmp_cpumask);
+}
+
+/*
+ * topology_matches_l3() - Is the provided class the same shape as L3
+ * @victim:		The class we'd like to pretend is L3.
+ *
+ * resctrl expects all the world's a Xeon, and all counters are on the
+ * L3. We allow some mapping counters on other classes. This requires
+ * that the CPU->domain mapping is the same kind of shape.
+ *
+ * Using cacheinfo directly would make this work even if resctrl can't
+ * use the L3 - but cacheinfo can't tell us anything about offline CPUs.
+ * Using the L3 resctrl domain list also depends on CPUs being online.
+ * Using the mpam_class we picked for L3 so we can use its domain list
+ * assumes that there are MPAM controls on the L3.
+ * Instead, this path eventually uses the mpam_get_cpumask_from_cache_id()
+ * helper which can tell us about offline CPUs ... but getting the cache_id
+ * to start with relies on at least one CPU per L3 cache being online at
+ * boot.
+ *
+ * Walk the victim component list and compare the affinity mask with the
+ * corresponding L3. The topology matches if each victim:component's affinity
+ * mask is the same as the CPU's corresponding L3's. These lists/masks are
+ * computed from firmware tables so don't change at runtime.
+ */
+static bool topology_matches_l3(struct mpam_class *victim)
+{
+	int cpu, err;
+	struct mpam_component *victim_iter;
+	cpumask_var_t __free(free_cpumask_var) tmp_cpumask = CPUMASK_VAR_NULL;
+
+	lockdep_assert_cpus_held();
+
+	if (!alloc_cpumask_var(&tmp_cpumask, GFP_KERNEL))
+		return false;
+
+	guard(srcu)(&mpam_srcu);
+	list_for_each_entry_srcu(victim_iter, &victim->components, class_list,
+				 srcu_read_lock_held(&mpam_srcu)) {
+		if (cpumask_empty(&victim_iter->affinity)) {
+			pr_debug("class %u has CPU-less component %u - can't match L3!\n",
+				 victim->level, victim_iter->comp_id);
+			return false;
+		}
+
+		cpu = cpumask_any_and(&victim_iter->affinity, cpu_online_mask);
+		if (WARN_ON_ONCE(cpu >= nr_cpu_ids))
+			return false;
+
+		cpumask_clear(tmp_cpumask);
+		err = find_l3_equivalent_bitmask(cpu, tmp_cpumask);
+		if (err) {
+			pr_debug("Failed to find L3's equivalent component to class %u component %u\n",
+				 victim->level, victim_iter->comp_id);
+			return false;
+		}
+
+		/* Any differing bits in the affinity mask? */
+		if (!cpumask_equal(tmp_cpumask, &victim_iter->affinity)) {
+			pr_debug("class %u component %u has Mismatched CPU mask with L3 equivalent\n"
+				 "L3:%*pbl != victim:%*pbl\n",
+				 victim->level, victim_iter->comp_id,
+				 cpumask_pr_args(tmp_cpumask),
+				 cpumask_pr_args(&victim_iter->affinity));
+
+			return false;
+		}
+	}
+
+	return true;
+}
+
+/*
+ * Test if the traffic for a class matches that at egress from the L3. For
+ * MSC at memory controllers this is only possible if there is a single L3
+ * as otherwise the counters at the memory can include bandwidth from the
+ * non-local L3.
+ */
+static bool traffic_matches_l3(struct mpam_class *class) {
+	int err, cpu;
+	cpumask_var_t __free(free_cpumask_var) tmp_cpumask = CPUMASK_VAR_NULL;
+
+	lockdep_assert_cpus_held();
+
+	if (class->type == MPAM_CLASS_CACHE && class->level == 3)
+		return true;
+
+	if (class->type == MPAM_CLASS_CACHE && class->level != 3) {
+		pr_debug("class %u is a different cache from L3\n", class->level);
+		return false;
+	}
+
+	if (class->type != MPAM_CLASS_MEMORY) {
+		pr_debug("class %u is neither of type cache or memory\n", class->level);
+		return false;
+	}
+
+	if (!alloc_cpumask_var(&tmp_cpumask, GFP_KERNEL)) {
+		pr_debug("cpumask allocation failed\n");
+		return false;
+	}
+
+	if (class->type != MPAM_CLASS_MEMORY) {
+		pr_debug("class %u is neither of type cache or memory\n",
+			 class->level);
+		return false;
+	}
+
+	cpu = cpumask_any_and(&class->affinity, cpu_online_mask);
+	err = find_l3_equivalent_bitmask(cpu, tmp_cpumask);
+	if (err) {
+		pr_debug("Failed to find L3 downstream to cpu %d\n", cpu);
+		return false;
+	}
+
+	if (!cpumask_equal(tmp_cpumask, cpu_possible_mask)) {
+		pr_debug("There is more than one L3\n");
+		return false;
+	}
+
+	/* Be strict; the traffic might stop in the intermediate cache. */
+	if (get_cpu_cacheinfo_id(cpu, 4) != -1) {
+		pr_debug("L3 isn't the last level of cache\n");
+		return false;
+	}
+
+	return true;
+}
+
 /* Test whether we can export MPAM_CLASS_CACHE:{2,3}? */
 static void mpam_resctrl_pick_caches(void)
 {
@@ -345,9 +519,69 @@ static void mpam_resctrl_pick_caches(void)
 	}
 }
 
+static void mpam_resctrl_pick_mba(void)
+{
+	struct mpam_class *class, *candidate_class = NULL;
+	struct mpam_resctrl_res *res;
+
+	lockdep_assert_cpus_held();
+
+	guard(srcu)(&mpam_srcu);
+	list_for_each_entry_srcu(class, &mpam_classes, classes_list,
+				 srcu_read_lock_held(&mpam_srcu)) {
+		struct mpam_props *cprops = &class->props;
+
+		if (class->level != 3 && class->type == MPAM_CLASS_CACHE) {
+			pr_debug("class %u is a cache but not the L3\n", class->level);
+			continue;
+		}
+
+		if (!class_has_usable_mba(cprops)) {
+			pr_debug("class %u has no bandwidth control\n",
+				 class->level);
+			continue;
+		}
+
+		if (!cpumask_equal(&class->affinity, cpu_possible_mask)) {
+			pr_debug("class %u has missing CPUs\n", class->level);
+			continue;
+		}
+
+		if (!topology_matches_l3(class)) {
+			pr_debug("class %u topology doesn't match L3\n",
+				 class->level);
+			continue;
+		}
+
+		if (!traffic_matches_l3(class)) {
+			pr_debug("class %u traffic doesn't match L3 egress\n",
+				 class->level);
+			continue;
+		}
+
+		/*
+		 * Pick a resource to be MBA that as close as possible to
+		 * the L3. mbm_total counts the bandwidth leaving the L3
+		 * cache and MBA should correspond as closely as possible
+		 * for proper operation of mba_sc.
+		 */
+		if (!candidate_class || class->level < candidate_class->level)
+			candidate_class = class;
+	}
+
+	if (candidate_class) {
+		pr_debug("selected class %u to back MBA\n",
+			 candidate_class->level);
+		res = &mpam_resctrl_controls[RDT_RESOURCE_MBA];
+		res->class = candidate_class;
+		exposed_alloc_capable = true;
+	}
+}
+
 static int mpam_resctrl_control_init(struct mpam_resctrl_res *res)
 {
 	struct mpam_class *class = res->class;
+	struct mpam_props *cprops = &class->props;
 	struct rdt_resource *r = &res->resctrl_res;
 
 	switch (r->rid) {
@@ -377,6 +611,19 @@ static int mpam_resctrl_control_init(struct mpam_resctrl_res *res)
 		 */
 		r->cache.shareable_bits = resctrl_get_default_ctrl(r);
 		break;
+	case RDT_RESOURCE_MBA:
+		r->alloc_capable = true;
+		r->schema_fmt = RESCTRL_SCHEMA_RANGE;
+		r->ctrl_scope = RESCTRL_L3_CACHE;
+
+		r->membw.delay_linear = true;
+		r->membw.throttle_mode = THREAD_THROTTLE_UNDEFINED;
+		r->membw.min_bw = get_mba_min(cprops);
+		r->membw.max_bw = MAX_MBA_BW;
+		r->membw.bw_gran = get_mba_granularity(cprops);
+
+		r->name = "MB";
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -391,7 +638,17 @@ static int mpam_resctrl_pick_domain_id(int cpu, struct mpam_component *comp)
 	if (class->type == MPAM_CLASS_CACHE)
 		return comp->comp_id;
 
-	/* TODO: repaint domain ids to match the L3 domain ids */
+	if (topology_matches_l3(class)) {
+		/* Use the corresponding L3 component ID as the domain ID */
+		int id = get_cpu_cacheinfo_id(cpu, 3);
+
+		/* Implies topology_matches_l3() made a mistake */
+		if (WARN_ON_ONCE(id == -1))
+			return comp->comp_id;
+
+		return id;
+	}
+
 	/* Otherwise, expose the ID used by the firmware table code. */
 	return comp->comp_id;
 }
@@ -431,6 +688,12 @@ u32 resctrl_arch_get_config(struct rdt_resource *r, struct rdt_ctrl_domain *d,
 	case RDT_RESOURCE_L3:
 		configured_by = mpam_feat_cpor_part;
 		break;
+	case RDT_RESOURCE_MBA:
+		if (mpam_has_feature(mpam_feat_mbw_max, cprops)) {
+			configured_by = mpam_feat_mbw_max;
+			break;
+		}
+		fallthrough;
 	default:
 		return resctrl_get_default_ctrl(r);
 	}
@@ -442,6 +705,8 @@ u32 resctrl_arch_get_config(struct rdt_resource *r, struct rdt_ctrl_domain *d,
 	switch (configured_by) {
 	case mpam_feat_cpor_part:
 		return cfg->cpbm;
+	case mpam_feat_mbw_max:
+		return mbw_max_to_percent(cfg->mbw_max, cprops);
 	default:
 		return resctrl_get_default_ctrl(r);
 	}
@@ -486,6 +751,13 @@ int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_ctrl_domain *d,
 		cfg.cpbm = cfg_val;
 		mpam_set_feature(mpam_feat_cpor_part, &cfg);
 		break;
+	case RDT_RESOURCE_MBA:
+		if (mpam_has_feature(mpam_feat_mbw_max, cprops)) {
+			cfg.mbw_max = percent_to_mbw_max(cfg_val, cprops);
+			mpam_set_feature(mpam_feat_mbw_max, &cfg);
+			break;
+		}
+		fallthrough;
 	default:
 		return -EINVAL;
 	}
@@ -789,6 +1061,7 @@ int mpam_resctrl_setup(void)
 
 	/* Find some classes to use for controls */
 	mpam_resctrl_pick_caches();
+	mpam_resctrl_pick_mba();
 
 	/* Initialise the resctrl structures from the classes */
 	for_each_mpam_resctrl_control(res, rid) {
-- 
2.43.0

