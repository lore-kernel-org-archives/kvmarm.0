Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76BDD37998D
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 17:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768237279; cv=none; b=V2DUOpflza9E0yc0BQeIywhqWqD49j7LdRf+HqCDYIcNQrnTU6KAuFp43E7TU/fti5cpO0pQ6DEsRKUEkxrrp76tD2Hm8k+Hjo+9V8kkG9EwDs8s1cVgPMx9w9fohB8rhoTxh7paMtQumw1TTrJcoiFgz4wRTMlfnhfnjzrc3Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768237279; c=relaxed/simple;
	bh=Yv6a469eHxtF+nsY/gf0/FjeU2RBV5U9ilftexhtp+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RA28J4LPzXfNryh3yGcdP9+4orS0lLfYst/i30jh/mQsgMLSk/r8J2iz2RJai6OFxLEexr4Yt2UqafacuNNmD1hm3DMWgA6lh+Zsjmi0164IH9TjYjxGutTPu4YI9DG7jtbd82uQf+JeJNB42ECgMzsGjWOEIKAEMwc/VxVxUmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4E0D315A1;
	Mon, 12 Jan 2026 09:01:11 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E53913F694;
	Mon, 12 Jan 2026 09:01:12 -0800 (PST)
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
Subject: [PATCH v3 16/47] arm_mpam: resctrl: Pick the caches we will use as resctrl resources
Date: Mon, 12 Jan 2026 16:58:43 +0000
Message-ID: <20260112165914.4086692-17-ben.horgan@arm.com>
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

Systems with MPAM support may have a variety of control types at any point
of their system layout. We can only expose certain types of control, and
only if they exist at particular locations.

Start with the well-known caches. These have to be depth 2 or 3 and support
MPAM's cache portion bitmap controls, with a number of portions fewer than
resctrl's limit.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since rfc:
Jonathan:
Remove brackets
Compress debug message
Use temp var, r

Changes since v2:
Return -EINVAL in mpam_resctrl_control_init() for unknown rid
---
 drivers/resctrl/mpam_resctrl.c | 90 +++++++++++++++++++++++++++++++++-
 1 file changed, 88 insertions(+), 2 deletions(-)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 4dba6f58f79c..1566d0c686e6 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -65,9 +65,94 @@ struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
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
 static int mpam_resctrl_control_init(struct mpam_resctrl_res *res)
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
+		return -EINVAL;
+	}
 
 	return 0;
 }
@@ -302,7 +387,8 @@ int mpam_resctrl_setup(void)
 		res->resctrl_res.rid = rid;
 	}
 
-	/* TODO: pick MPAM classes to map to resctrl resources */
+	/* Find some classes to use for controls */
+	mpam_resctrl_pick_caches();
 
 	/* Initialise the resctrl structures from the classes */
 	for_each_mpam_resctrl_control(res, rid) {
-- 
2.43.0

