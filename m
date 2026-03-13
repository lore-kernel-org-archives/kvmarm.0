Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FBC9346765
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 14:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773413272; cv=none; b=TgwvjjdYiV6HIt2cwbpRXXVTUaTXfRFXSdEfSaIvK/TNC+QbnCboynOL/ez0994RORdG/pI8ftIYDqeS0Y1KG4yiCJGI+12qvLh8C3hTsm8qikhF4J3J/oenzTQgUrEab2aJPkyekP4idV80dEBNzN+KX1+FNuNJ14Di/TNoNQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773413272; c=relaxed/simple;
	bh=VvH0Yh3gr+miPg8zIlAvhiUQLMRqtL38IjZexfzsACQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3l/EsWrzcuEDBOBDJx4HFbOVqKN0bnGT2qhh4vIvhIMqvWpoTmcCnAkHN2W5/yeO+MCAclR6pJujwaTRZhc6WRJAmqgwa7YZb5RzKX+mBCfWbOqN5fTvvGT5zFogboHReIOJ3B9+juoWxGfFWNcniuv4IsBufP9nIhxACv+rbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B9FC11E7D;
	Fri, 13 Mar 2026 07:47:41 -0700 (PDT)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EDE533F7BD;
	Fri, 13 Mar 2026 07:47:43 -0700 (PDT)
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
Subject: [PATCH v6 18/40] arm_mpam: resctrl: Implement helpers to update configuration
Date: Fri, 13 Mar 2026 14:45:55 +0000
Message-ID: <20260313144617.3420416-19-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260313144617.3420416-1-ben.horgan@arm.com>
References: <20260313144617.3420416-1-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: James Morse <james.morse@arm.com>

resctrl has two helpers for updating the configuration.
resctrl_arch_update_one() updates a single value, and is used by the
software-controller to apply feedback to the bandwidth controls, it has to
be called on one of the CPUs in the resctrl:domain.

resctrl_arch_update_domains() copies multiple staged configurations, it can
be called from anywhere.

Both helpers should update any changes to the underlying hardware.

Implement resctrl_arch_update_domains() to use
resctrl_arch_update_one(). Neither need to be called on a specific CPU as
the mpam driver will send IPIs as needed.

Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Tested-by: Peter Newman <peternewman@google.com>
Tested-by: Zeng Heng <zengheng4@huawei.com>
Tested-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
Reviewed-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since rfc:
list_for_each_entry -> list_for_each_entry_rcu
return 0
Restrict scope of local variables

Changes since v2:
whitespace fix
---
 drivers/resctrl/mpam_resctrl.c | 70 ++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 1d9004179374..827e777a67a5 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -213,6 +213,76 @@ u32 resctrl_arch_get_config(struct rdt_resource *r, struct rdt_ctrl_domain *d,
 	}
 }
 
+int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_ctrl_domain *d,
+			    u32 closid, enum resctrl_conf_type t, u32 cfg_val)
+{
+	u32 partid;
+	struct mpam_config cfg;
+	struct mpam_props *cprops;
+	struct mpam_resctrl_res *res;
+	struct mpam_resctrl_dom *dom;
+
+	lockdep_assert_cpus_held();
+	lockdep_assert_irqs_enabled();
+
+	/*
+	 * No need to check the CPU as mpam_apply_config() doesn't care, and
+	 * resctrl_arch_update_domains() relies on this.
+	 */
+	res = container_of(r, struct mpam_resctrl_res, resctrl_res);
+	dom = container_of(d, struct mpam_resctrl_dom, resctrl_ctrl_dom);
+	cprops = &res->class->props;
+
+	partid = resctrl_get_config_index(closid, t);
+	if (!r->alloc_capable || partid >= resctrl_arch_get_num_closid(r)) {
+		pr_debug("Not alloc capable or computed PARTID out of range\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Copy the current config to avoid clearing other resources when the
+	 * same component is exposed multiple times through resctrl.
+	 */
+	cfg = dom->ctrl_comp->cfg[partid];
+
+	switch (r->rid) {
+	case RDT_RESOURCE_L2:
+	case RDT_RESOURCE_L3:
+		cfg.cpbm = cfg_val;
+		mpam_set_feature(mpam_feat_cpor_part, &cfg);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return mpam_apply_config(dom->ctrl_comp, partid, &cfg);
+}
+
+int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid)
+{
+	int err;
+	struct rdt_ctrl_domain *d;
+
+	lockdep_assert_cpus_held();
+	lockdep_assert_irqs_enabled();
+
+	list_for_each_entry_rcu(d, &r->ctrl_domains, hdr.list) {
+		for (enum resctrl_conf_type t = 0; t < CDP_NUM_TYPES; t++) {
+			struct resctrl_staged_config *cfg = &d->staged_config[t];
+
+			if (!cfg->have_new_ctrl)
+				continue;
+
+			err = resctrl_arch_update_one(r, d, closid, t,
+						      cfg->new_ctrl);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
+
 void resctrl_arch_reset_all_ctrls(struct rdt_resource *r)
 {
 	struct mpam_resctrl_res *res;
-- 
2.43.0

