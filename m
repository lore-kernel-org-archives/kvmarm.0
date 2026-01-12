Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E37037B41A
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 17:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768237292; cv=none; b=LaGndfJN1N/sXbxZoeInEmhAhGrz8oF6qsT4eym05nh6wIbZMeQmUiClX+uJN8PlDaltSVHrDNfiGtY+tbnxgGd/bhYpCNGVXpRXXpgdOXZAhwUHYvY3q+SSXLp/Azf+i2mIbF6X2CksX5rOgXgMMlZvthwb0v1tYAxI8fH7ATk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768237292; c=relaxed/simple;
	bh=9gR+VKFUXhQzjgYjirNNbQKYbPY4tZqy7G+q9GqF6Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kojj88ukL7KaQAApQsJK1zyuipMRHhLQVv61g5CyeoDjO0vi8WvYQkKUgi+fOPOhLLsyvkTWj6mamte8XyccqLVNVpomcORbZjqEGr4FtXWOMNMAClpigq0WxvHQrSNYNoWkCnRB9p3qTkmojrkcZ+zIf50/YdpHN7aLk3ttkG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3314E1596;
	Mon, 12 Jan 2026 09:01:22 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CC1CA3F694;
	Mon, 12 Jan 2026 09:01:23 -0800 (PST)
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
Subject: [PATCH v3 18/47] arm_mpam: resctrl: Add resctrl_arch_get_config()
Date: Mon, 12 Jan 2026 16:58:45 +0000
Message-ID: <20260112165914.4086692-19-ben.horgan@arm.com>
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

Implement resctrl_arch_get_config() by testing the live configuration for a
CPOR bitmap. For any other configuration type return the default.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 drivers/resctrl/mpam_resctrl.c | 43 ++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 683bdd6989d4..25012e779509 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -169,6 +169,49 @@ static int mpam_resctrl_pick_domain_id(int cpu, struct mpam_component *comp)
 	return comp->comp_id;
 }
 
+u32 resctrl_arch_get_config(struct rdt_resource *r, struct rdt_ctrl_domain *d,
+			    u32 closid, enum resctrl_conf_type type)
+{
+	u32 partid;
+	struct mpam_config *cfg;
+	struct mpam_props *cprops;
+	struct mpam_resctrl_res *res;
+	struct mpam_resctrl_dom *dom;
+	enum mpam_device_features configured_by;
+
+	lockdep_assert_cpus_held();
+
+	if (!mpam_is_enabled())
+		return resctrl_get_default_ctrl(r);
+
+	res = container_of(r, struct mpam_resctrl_res, resctrl_res);
+	dom = container_of(d, struct mpam_resctrl_dom, resctrl_ctrl_dom);
+	cprops = &res->class->props;
+
+	partid = resctrl_get_config_index(closid, type);
+	cfg = &dom->ctrl_comp->cfg[partid];
+
+	switch (r->rid) {
+	case RDT_RESOURCE_L2:
+	case RDT_RESOURCE_L3:
+		configured_by = mpam_feat_cpor_part;
+		break;
+	default:
+		return resctrl_get_default_ctrl(r);
+	}
+
+	if (!r->alloc_capable || partid >= resctrl_arch_get_num_closid(r) ||
+	    !mpam_has_feature(configured_by, cfg))
+		return resctrl_get_default_ctrl(r);
+
+	switch (configured_by) {
+	case mpam_feat_cpor_part:
+		return cfg->cpbm;
+	default:
+		return resctrl_get_default_ctrl(r);
+	}
+}
+
 void resctrl_arch_reset_all_ctrls(struct rdt_resource *r)
 {
 	struct mpam_resctrl_res *res;
-- 
2.43.0

