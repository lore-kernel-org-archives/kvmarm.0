Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC7337C11C
	for <kvmarm@lists.linux.dev>; Tue,  3 Feb 2026 21:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770155265; cv=none; b=CU0WOLBehASnQuaMgfeCrpgi3rfwjttxy3VcU+WO3kZqYUOBdjyP/mUrGaaXh0qJFNE2po/0kc88Ud6Iq1Bo1NdLTS3mLGccJMi6dD3BMsx/ZHZE91b9MXyTrOSNtYPuG2BUsH66TMbXowI98S9qA3bE1DmgJgi2GX0Swo5gwmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770155265; c=relaxed/simple;
	bh=ytLBL/bX4+EEVoFkP03q7Po+YRiigtVjlrbELzcDdvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3ZV0++WTH8cTAutFKUBr5RRo6HwDVhb2jJejGEvzlRYgscaKZmqY//qgHURhhuJHe6vkZNpFaB4UAS7hcLfAfllh0mKWaGDnI7gMFvcdaQaher1PQu7F0YvlQTz/FpaevvhKrNYAjIQQTVMRZ8rGYOuu0ph/43UXIFc6OHUraM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C05091063;
	Tue,  3 Feb 2026 13:47:36 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9BAD43F778;
	Tue,  3 Feb 2026 13:47:37 -0800 (PST)
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
Subject: [PATCH v4 38/41] arm_mpam: Add workaround for T241-MPAM-4
Date: Tue,  3 Feb 2026 21:43:39 +0000
Message-ID: <20260203214342.584712-39-ben.horgan@arm.com>
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

From: Shanker Donthineni <sdonthineni@nvidia.com>

In the T241 implementation of memory-bandwidth partitioning, in the absence
of contention for bandwidth, the minimum bandwidth setting can affect the
amount of achieved bandwidth. Specifically, the achieved bandwidth in the
absence of contention can settle to any value between the values of
MPAMCFG_MBW_MIN and MPAMCFG_MBW_MAX.  Also, if MPAMCFG_MBW_MIN is set
zero (below 0.78125%), once a core enters a throttled state, it will never
leave that state.

The first issue is not a concern if the MPAM software allows to program
MPAMCFG_MBW_MIN through the sysfs interface. This patch ensures program
MBW_MIN=1 (0.78125%) whenever MPAMCFG_MBW_MIN=0 is programmed.

In the scenario where the resctrl doesn't support the MBW_MIN interface via
sysfs, to achieve bandwidth closer to MBW_MAX in the absence of contention,
software should configure a relatively narrow gap between MBW_MIN and
MBW_MAX. The recommendation is to use a 5% gap to mitigate the problem.

Clear the feature MBW_MIN feature from the class to ensure we don't
accidentally change behaviour when resctrl adds support for a MBW_MIN
interface.

Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
[ morse: Added as second quirk, adapted to use the new intermediate values
in mpam_extend_config() ]

Changes since rfc:
MPAM_IIDR_NVIDIA_T421 -> MPAM_IIDR_NVIDIA_T241
Handling when reset_mbw_min is set

Changes since v3:
Move the 5% gap policy back here
Clear mbw_min feature in class
---
 Documentation/arch/arm64/silicon-errata.rst |  2 +
 drivers/resctrl/mpam_devices.c              | 50 +++++++++++++++++++--
 drivers/resctrl/mpam_internal.h             |  1 +
 3 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index 4e86b85fe3d6..b18bc704d4a1 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -248,6 +248,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | NVIDIA         | T241 MPAM       | T241-MPAM-1     | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
+| NVIDIA         | T241 MPAM       | T241-MPAM-4     | N/A                         |
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | Freescale/NXP  | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585         |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index 76c8cfcef3c0..37a105d95d66 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -679,6 +679,12 @@ static const struct mpam_quirk mpam_quirks[] = {
 	.iidr_mask  = MPAM_IIDR_MATCH_ONE,
 	.workaround = T241_SCRUB_SHADOW_REGS,
 	},
+	{
+	/* NVIDIA t241 erratum T241-MPAM-4 */
+	.iidr       = MPAM_IIDR_NVIDIA_T241,
+	.iidr_mask  = MPAM_IIDR_MATCH_ONE,
+	.workaround = T241_FORCE_MBW_MIN_TO_ONE,
+	},
 	{ NULL } /* Sentinel */
 };
 
@@ -1464,6 +1470,31 @@ static void mpam_quirk_post_config_change(struct mpam_msc_ris *ris, u16 partid,
 		mpam_apply_t241_erratum(ris, partid);
 }
 
+static u16 mpam_wa_t241_force_mbw_min_to_one(struct mpam_props *props)
+{
+	u16 max_hw_value, min_hw_granule, res0_bits;
+
+	res0_bits = 16 - props->bwa_wd;
+	max_hw_value = ((1 << props->bwa_wd) - 1) << res0_bits;
+	min_hw_granule = ~max_hw_value;
+
+	return min_hw_granule + 1;
+}
+
+static u16 mpam_wa_t241_calc_min_from_max(struct mpam_config *cfg)
+{
+	u16 val = 0;
+
+	if (mpam_has_feature(mpam_feat_mbw_max, cfg)) {
+		u16 delta = ((5 * MPAMCFG_MBW_MAX_MAX) / 100) - 1;
+
+		if (cfg->mbw_max > delta)
+			val = cfg->mbw_max - delta;
+	}
+
+	return val;
+}
+
 /* Called via IPI. Call while holding an SRCU reference */
 static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
 				      struct mpam_config *cfg)
@@ -1506,9 +1537,19 @@ static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
 			mpam_write_partsel_reg(msc, MBW_PBM, cfg->mbw_pbm);
 	}
 
-	if (mpam_has_feature(mpam_feat_mbw_min, rprops) &&
-	    mpam_has_feature(mpam_feat_mbw_min, cfg))
-		mpam_write_partsel_reg(msc, MBW_MIN, 0);
+	if (mpam_has_feature(mpam_feat_mbw_min, rprops)) {
+		u16 val = 0;
+
+		if (mpam_has_quirk(T241_FORCE_MBW_MIN_TO_ONE, msc)) {
+			u16 min = mpam_wa_t241_force_mbw_min_to_one(rprops);
+
+			val = mpam_wa_t241_calc_min_from_max(cfg);
+			if (val < min)
+				val = min;
+		}
+
+		mpam_write_partsel_reg(msc, MBW_MIN, val);
+	}
 
 	if (mpam_has_feature(mpam_feat_mbw_max, rprops) &&
 	    mpam_has_feature(mpam_feat_mbw_max, cfg)) {
@@ -2304,6 +2345,9 @@ static void mpam_enable_merge_class_features(struct mpam_component *comp)
 
 	list_for_each_entry(vmsc, &comp->vmsc, comp_list)
 		__class_props_mismatch(class, vmsc);
+
+	if (mpam_has_quirk(T241_FORCE_MBW_MIN_TO_ONE, class))
+		mpam_clear_feature(mpam_feat_mbw_min, &class->props);
 }
 
 /*
diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index 6b832f2100d9..f6bf462058d9 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -220,6 +220,7 @@ struct mpam_props {
 /* Workaround bits for msc->quirks */
 enum mpam_device_quirks {
 	T241_SCRUB_SHADOW_REGS,
+	T241_FORCE_MBW_MIN_TO_ONE,
 	MPAM_QUIRK_LAST
 };
 
-- 
2.43.0

