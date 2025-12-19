Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5F5F34CFC3
	for <kvmarm@lists.linux.dev>; Fri, 19 Dec 2025 18:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766168008; cv=none; b=LMuXIIY39DgQ1bHE1kE0bR6bdC0G0wQ8eUyNc06LMCphfA7R1m6CRq4u8pX5qcNPJlIKmr/U8fM0lT5+jtOqvOacyj0MtnPls1VwegR7mmy5YcFVuPV3NoYbZnpoXKaAVDq9LpC9tg44sBT2yQUBt1lz328EhJOYbK2E5bPkKRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766168008; c=relaxed/simple;
	bh=LAjbtKBuFpoez1/+upGrfgyCqNdQ1Hzdm+0aBps3/sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXaxAluMv9uaRDlIhkyU9IM7nrXaCJaegzk5G4N1com39GcML/VacYpVVptJlJxjhxB+0iZZrK1vKRrIYCFAHtzMus1zDGFIwCsTTYi9HqqdKNOt9FDoPRMcgMjXzjPVqno32qw2C3NRKZoveVWXPLplEBomyuBjLZaTinx1yBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 50097106F;
	Fri, 19 Dec 2025 10:13:16 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 032BC3F5CA;
	Fri, 19 Dec 2025 10:13:18 -0800 (PST)
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
Subject: [PATCH v2 17/45] arm_mpam: resctrl: Pick the caches we will use as resctrl resources
Date: Fri, 19 Dec 2025 18:11:19 +0000
Message-ID: <20251219181147.3404071-18-ben.horgan@arm.com>
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

Systems with MPAM support may have a variety of control types at any point
of their system layout. We can only expose certain types of control, and
only if they exist at particular locations.

Start with the well-known caches. These have to be depth 2 or 3 and support
MPAM's cache portion bitmap controls, with a number of portions fewer than
resctrl's limit.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since rfc:
Jonathan:
Remove brackets
Compress debug message
Use temp var, r
---
 drivers/resctrl/mpam_resctrl.c | 90 +++++++++++++++++++++++++++++++++-
 1 file changed, 88 insertions(+), 2 deletions(-)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 5481d9cc69d9..bc4f1c80eab5 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -60,10 +60,95 @@ struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
 	return &mpam_resctrl_controls[l].resctrl_res;
 }
 
+static bool cache_has_usable_cpor(struct mpam_class *class)
+{
+	struct mpam_props *cprops = &class->props;
+
+	if (!mpam_has_feature(mpam_feat_cpor_part, cprops))
+		return false;
+
+	/* resctrl uses u32 for all bitmap configurations */
+	return class->props.cpbm_wd <= 32;
+}
+
+/* Test whether we can export MPAM_CLASS_CACHE:{2,3}? */
+static void mpam_resctrl_pick_caches(void)
+{
+	struct mpam_class *class;
+	struct mpam_resctrl_res *res;
+
+	lockdep_assert_cpus_held();
+
+	guard(srcu)(&mpam_srcu);
+	list_for_each_entry_srcu(class, &mpam_classes, classes_list,
+				 srcu_read_lock_held(&mpam_srcu)) {
+		if (class->type != MPAM_CLASS_CACHE) {
+			pr_debug("class %u is not a cache\n", class->level);
+			continue;
+		}
+
+		if (class->level != 2 && class->level != 3) {
+			pr_debug("class %u is not L2 or L3\n", class->level);
+			continue;
+		}
+
+		if (!cache_has_usable_cpor(class)) {
+			pr_debug("class %u cache misses CPOR\n", class->level);
+			continue;
+		}
+
+		if (!cpumask_equal(&class->affinity, cpu_possible_mask)) {
+			pr_debug("class %u has missing CPUs, mask %*pb != %*pb\n", class->level,
+				 cpumask_pr_args(&class->affinity),
+				 cpumask_pr_args(cpu_possible_mask));
+			continue;
+		}
+
+		if (class->level == 2)
+			res = &mpam_resctrl_controls[RDT_RESOURCE_L2];
+		else
+			res = &mpam_resctrl_controls[RDT_RESOURCE_L3];
+		res->class = class;
+		exposed_alloc_capable = true;
+	}
+}
+
 static int mpam_resctrl_control_init(struct mpam_resctrl_res *res,
 				     enum resctrl_res_level type)
 {
-	/* TODO: initialise the resctrl resources */
+	struct mpam_class *class = res->class;
+	struct rdt_resource *r = &res->resctrl_res;
+
+	switch (r->rid) {
+	case RDT_RESOURCE_L2:
+	case RDT_RESOURCE_L3:
+		r->alloc_capable = true;
+		r->schema_fmt = RESCTRL_SCHEMA_BITMAP;
+		r->cache.arch_has_sparse_bitmasks = true;
+
+		r->cache.cbm_len = class->props.cpbm_wd;
+		/* mpam_devices will reject empty bitmaps */
+		r->cache.min_cbm_bits = 1;
+
+		if (r->rid == RDT_RESOURCE_L2) {
+			r->name = "L2";
+			r->ctrl_scope = RESCTRL_L2_CACHE;
+		} else {
+			r->name = "L3";
+			r->ctrl_scope = RESCTRL_L3_CACHE;
+		}
+
+		/*
+		 * Which bits are shared with other ...things...
+		 * Unknown devices use partid-0 which uses all the bitmap
+		 * fields. Until we configured the SMMU and GIC not to do this
+		 * 'all the bits' is the correct answer here.
+		 */
+		r->cache.shareable_bits = resctrl_get_default_ctrl(r);
+		break;
+	default:
+		break;
+	}
 
 	return 0;
 }
@@ -300,7 +385,8 @@ int mpam_resctrl_setup(void)
 		res->resctrl_res.rid = i;
 	}
 
-	/* TODO: pick MPAM classes to map to resctrl resources */
+	/* Find some classes to use for controls */
+	mpam_resctrl_pick_caches();
 
 	/* Initialise the resctrl structures from the classes */
 	for (enum resctrl_res_level i = 0; i < RDT_NUM_RESOURCES; i++) {
-- 
2.43.0

