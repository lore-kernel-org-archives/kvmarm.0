Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2213E34D4E3
	for <kvmarm@lists.linux.dev>; Fri, 19 Dec 2025 18:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766168023; cv=none; b=AFCwEpPOVMVEbdigvBSU76JicPK63CTy7VFYRtrlnjkFEjCA3K3Dn9RZl0itLCHF2LTNPza/svenYjyCjnTnY54w1Ur2fCsQa+Ys4pCVF9UP4OuEJlRRa+F7+gtw3CK8xZUTKwXtgDWdt98KfHKLnjslM0hqbP5kTzl9iip7328=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766168023; c=relaxed/simple;
	bh=IrgvWIr42EZAFa46xanZvk4vgNSzWIjocYWiWiG9eWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snPYrtYHd8DTrzU1KPgp/HTs0mLx1uYSV6bN7pA1rDtPu+6oaPzM+8heNWTEL42HoWOfh1TtQnEzE42uZJdzMQRMZllz34Hsn+NuTGtKh88KRO0luS1xQwRfMaUzjmFsENZoOCq81D1zrq5aGRtupYy2eENpvqV4ooSq5oVd99E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C7E74FEC;
	Fri, 19 Dec 2025 10:13:30 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7B8E23F5CA;
	Fri, 19 Dec 2025 10:13:33 -0800 (PST)
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
Subject: [PATCH v2 20/45] arm_mpam: resctrl: Implement helpers to update configuration
Date: Fri, 19 Dec 2025 18:11:22 +0000
Message-ID: <20251219181147.3404071-21-ben.horgan@arm.com>
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

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
list_for_each_entry -> list_for_each_entry_rcu
return 0
Restrict scope of local variables
---
 drivers/resctrl/mpam_resctrl.c | 70 ++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 607e5f41f9e7..e5ec5438eca8 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -210,6 +210,76 @@ u32 resctrl_arch_get_config(struct rdt_resource *r, struct rdt_ctrl_domain *d,
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
+       /*
+	* Copy the current config to avoid clearing other resources when the
+	* same component is exposed multiple times through resctrl.
+	*/
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

