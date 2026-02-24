Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 602653ACEF3
	for <kvmarm@lists.linux.dev>; Tue, 24 Feb 2026 17:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771955996; cv=none; b=adY//kOxyHpoRrEQBJqy75JN0HcTEOyUdNfxz03Cf/25SAqp7u9ocXK+IwDh5LsALFBQAI87bgSWEm12vRSJrcZwSb8NKOMwA86nWmYXmt9JtzGlTCILgmGYF+N8DlxOMiCCOY/f9LkuL4Cdjop0hWEudpSvs7MCQKjYcRrIF5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771955996; c=relaxed/simple;
	bh=QCFmq+r/JI7wlJRn5Cp0w90W+b/FbOSXlGXSn5xZ2lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g75y1/9Mf9UfUsQbeq73U9gbf9oYNC06nWMPlitc5Zvli1MRay3NRRyGCCjmce4f6JKUACIpqV8ZVBs3pHq+xBrgSUTr1D4a8IBIgYkJxOFMgejtlfeZoQqEQ+6kXvuXZwV0I94oKbXcs3WM3OH37yen0fLKiopSsaqo/EcNvZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA97F1595;
	Tue, 24 Feb 2026 09:59:48 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 400603F59E;
	Tue, 24 Feb 2026 09:59:44 -0800 (PST)
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
Subject: [PATCH v5 26/41] arm_mpam: resctrl: Add monitor initialisation and domain boilerplate
Date: Tue, 24 Feb 2026 17:57:05 +0000
Message-ID: <20260224175720.2663924-27-ben.horgan@arm.com>
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

Add the boilerplate that tells resctrl about the mpam monitors that are
available. resctrl expects all (non-telemetry) monitors to be on the L3 and
so advertise them there and invent an L3 resctrl resource if required. The
L3 cache itself has to exist as the cache ids are used as the domain
ids.

Bring the resctrl monitor domains online and offline based on the cpus
they contain.

Support for specific monitor types is left to later.

Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
New patch but mostly moved from the existing patches to
separate the monitors from the controls and the boilerplate
from the specific counters.
Use l3->mon_capable in resctrl_arch_mon_capable() as
resctrl_enable_mon_event() now returns a bool.
---
 drivers/resctrl/mpam_internal.h |   7 ++
 drivers/resctrl/mpam_resctrl.c  | 142 +++++++++++++++++++++++++++++---
 2 files changed, 139 insertions(+), 10 deletions(-)

diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index 57c3d9b962b9..472bd5d27baa 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -341,6 +341,7 @@ struct mpam_msc_ris {
 struct mpam_resctrl_dom {
 	struct mpam_component		*ctrl_comp;
 	struct rdt_ctrl_domain		resctrl_ctrl_dom;
+	struct rdt_l3_mon_domain	resctrl_mon_dom;
 };
 
 struct mpam_resctrl_res {
@@ -349,6 +350,12 @@ struct mpam_resctrl_res {
 	bool			cdp_enabled;
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
index 29efcad163e6..c14e59e8586d 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -34,6 +34,23 @@ static struct mpam_resctrl_res mpam_resctrl_controls[RDT_NUM_RESOURCES];
 	     rid < RDT_NUM_RESOURCES;						\
 	     rid++, res = &mpam_resctrl_controls[rid])
 
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
 /* The lock for modifying resctrl's domain lists from cpuhp callbacks. */
 static DEFINE_MUTEX(domain_list_lock);
 
@@ -63,6 +80,15 @@ bool resctrl_arch_alloc_capable(void)
 	return false;
 }
 
+bool resctrl_arch_mon_capable(void)
+{
+	struct mpam_resctrl_res *res = &mpam_resctrl_controls[RDT_RESOURCE_L3];
+	struct rdt_resource *l3 = &res->resctrl_res;
+
+	/* All monitors are presented as being on the L3 cache */
+	return l3->mon_capable;
+}
+
 bool resctrl_arch_get_cdp_enabled(enum resctrl_res_level rid)
 {
 	return mpam_resctrl_controls[rid].cdp_enabled;
@@ -651,6 +677,57 @@ static int mpam_resctrl_pick_domain_id(int cpu, struct mpam_component *comp)
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
+	/*
+	 * Called multiple times!, once per event type that has a
+	 * monitoring class.
+	 * Setting name is necessary on monitor only platforms.
+	 */
+	l3->name = "L3";
+	l3->mon_scope = RESCTRL_L3_CACHE;
+
+	/*
+	 * num-rmid is the upper bound for the number of monitoring
+	 * groups that can exist simultaneously, including the
+	 * default monitoring group for each control group. Hence,
+	 * advertise the whole rmid_idx space even though each
+	 * control group has its own pmg/rmid space. Unfortunately,
+	 * this does mean userspace needs to know the architecture
+	 * to correctly interpret this value.
+	 */
+	l3->mon.num_rmid = resctrl_arch_system_num_rmid_idx();
+
+	if (resctrl_enable_mon_event(type, false, 0, NULL))
+		l3->mon_capable = true;
+
+	return 0;
+}
+
 u32 resctrl_arch_get_config(struct rdt_resource *r, struct rdt_ctrl_domain *d,
 			    u32 closid, enum resctrl_conf_type type)
 {
@@ -883,6 +960,7 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 {
 	int err;
 	struct mpam_resctrl_dom *dom;
+	struct rdt_l3_mon_domain *mon_d;
 	struct rdt_ctrl_domain *ctrl_d;
 	struct mpam_class *class = res->class;
 	struct mpam_component *comp_iter, *ctrl_comp;
@@ -922,6 +1000,20 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 	} else {
 		pr_debug("Skipped control domain online - no controls\n");
 	}
+
+	if (resctrl_arch_mon_capable()) {
+		mon_d = &dom->resctrl_mon_dom;
+		mpam_resctrl_domain_hdr_init(cpu, any_mon_comp, r->rid, &mon_d->hdr);
+		mon_d->hdr.type = RESCTRL_MON_DOMAIN;
+		err = resctrl_online_mon_domain(r, &mon_d->hdr);
+		if (err)
+			goto offline_ctrl_domain;
+
+		mpam_resctrl_domain_insert(&r->mon_domains, &mon_d->hdr);
+	} else {
+		pr_debug("Skipped monitor domain online - no monitors\n");
+	}
+
 	return dom;
 
 offline_ctrl_domain:
@@ -973,6 +1065,11 @@ int mpam_resctrl_online_cpu(unsigned int cpu)
 
 				mpam_resctrl_online_domain_hdr(cpu, &ctrl_d->hdr);
 			}
+			if (resctrl_arch_mon_capable()) {
+				struct rdt_l3_mon_domain *mon_d = &dom->resctrl_mon_dom;
+
+				mpam_resctrl_online_domain_hdr(cpu, &mon_d->hdr);
+			}
 		}
 		if (IS_ERR(dom))
 			return PTR_ERR(dom);
@@ -993,8 +1090,9 @@ void mpam_resctrl_offline_cpu(unsigned int cpu)
 	guard(mutex)(&domain_list_lock);
 	for_each_mpam_resctrl_control(res, rid) {
 		struct mpam_resctrl_dom *dom;
+		struct rdt_l3_mon_domain *mon_d;
 		struct rdt_ctrl_domain *ctrl_d;
-		bool ctrl_dom_empty;
+		bool ctrl_dom_empty, mon_dom_empty;
 
 		if (!res->class)
 			continue;	// dummy resource
@@ -1012,7 +1110,16 @@ void mpam_resctrl_offline_cpu(unsigned int cpu)
 			ctrl_dom_empty = true;
 		}
 
-		if (ctrl_dom_empty)
+		if (resctrl_arch_mon_capable()) {
+			mon_d = &dom->resctrl_mon_dom;
+			mon_dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &mon_d->hdr);
+			if (mon_dom_empty)
+				resctrl_offline_mon_domain(&res->resctrl_res, &mon_d->hdr);
+		} else {
+			mon_dom_empty = true;
+		}
+
+		if (ctrl_dom_empty && mon_dom_empty)
 			kfree(dom);
 	}
 }
@@ -1022,12 +1129,15 @@ int mpam_resctrl_setup(void)
 	int err = 0;
 	struct mpam_resctrl_res *res;
 	enum resctrl_res_level rid;
+	struct mpam_resctrl_mon *mon;
+	enum resctrl_event_id eventid;
 
 	wait_event(wait_cacheinfo_ready, cacheinfo_ready);
 
 	cpus_read_lock();
 	for_each_mpam_resctrl_control(res, rid) {
 		INIT_LIST_HEAD_RCU(&res->resctrl_res.ctrl_domains);
+		INIT_LIST_HEAD_RCU(&res->resctrl_res.mon_domains);
 		res->resctrl_res.rid = rid;
 	}
 
@@ -1043,25 +1153,37 @@ int mpam_resctrl_setup(void)
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
 
-	if (!resctrl_arch_alloc_capable()) {
-		pr_debug("No alloc(%u) found - resctrl not supported\n",
-			 resctrl_arch_alloc_capable());
+	cpus_read_unlock();
+
+	if (!resctrl_arch_alloc_capable() && !resctrl_arch_mon_capable()) {
+		pr_debug("No alloc(%u) or monitor(%u) found - resctrl not supported\n",
+			 resctrl_arch_alloc_capable(), resctrl_arch_mon_capable());
 		return -EOPNOTSUPP;
 	}
 
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

