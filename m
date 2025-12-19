Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2417035C1AB
	for <kvmarm@lists.linux.dev>; Fri, 19 Dec 2025 18:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766168132; cv=none; b=h2hcwpde/s/IE9J1+Xzohcod+dfPSZXBpouq4IqjgyvULHQXGfclGEJc851UPeKkRPN/brloe/yeJvpPtzf1teaBfmcEzMs1kzVYs1aICjUMN3iaDlC9y9gRj3zPYctNSKFGzZF8JvDV/Gvs2nn5e330FJnK0HHhyyKSCtkwSGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766168132; c=relaxed/simple;
	bh=cX1nG+kDNM1UH82tsUyLLNzEaNg+8nWV0fcf6sPFuac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giR6XBNjRoIR3Q3gXx0BhUhgyc0clKvHvmYcuaN1fLjHvcNZC8I6Oq4wzoTQDxylJHePRdB5QQANYrIjknHXffivhzSDIjDoHw5YiVsjDf0Y+klu8JMp79MUb5CEHx/RoUMT9+qyNZftFvUQWGWRHFysjxm0B3WCuMFD5eARILc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 54E2016F8;
	Fri, 19 Dec 2025 10:15:20 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 075EE3F5CA;
	Fri, 19 Dec 2025 10:15:22 -0800 (PST)
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
Subject: [PATCH v2 43/45] arm_mpam: Add workaround for T241-MPAM-4
Date: Fri, 19 Dec 2025 18:11:45 +0000
Message-ID: <20251219181147.3404071-44-ben.horgan@arm.com>
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

From: Shanker Donthineni <sdonthineni@nvidia.com>

In the T241 implementation of memory-bandwidth partitioning, in the absence
of contention for bandwidth, the minimum bandwidth setting can affect the
amount of achieved bandwidth. Specifically, the achieved bandwidth in the
absence of contention can settle to any value between the values of
MPAMCFG_MBW_MIN and MPAMCFG_MBW_MAX.  Also, if MPAMCFG_MBW_MIN is set
zero (below 0.78125%), once a core enters a throttled state, it will never
leave that state.

The first issue is not a cocern if the MPAM software allows to program
MPAMCFG_MBW_MIN through the sysfs interface. This patch ensures program
MBW_MIN=1 (0.78125%) whenever MPAMCFG_MBW_MIN=0 is programmed.

In the scenario where the resctrl doesn't support the MBW_MIN interface via
sysfs, to achieve bandwidth closer to MW_MAX in the absence of contention,
software should configure a relatively narrow gap between MBW_MIN and
MBW_MAX. The recommendation is to use a 5% gap to mitigate the problem.

[ morse: Added as second quirk, adapted to use the new intermediate values
in mpam_extend_config() ]

Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since rfc:
MPAM_IIDR_NVIDIA_T421 -> MPAM_IIDR_NVIDIA_T241
Handling when reset_mbw_min is set
---
 Documentation/arch/arm64/silicon-errata.rst |  2 +
 drivers/resctrl/mpam_devices.c              | 59 +++++++++++++++------
 drivers/resctrl/mpam_internal.h             |  1 +
 3 files changed, 46 insertions(+), 16 deletions(-)

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
index 1b923a44f304..76aa8654fc74 100644
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
 
@@ -1464,6 +1470,17 @@ static void mpam_quirk_post_config_change(struct mpam_msc_ris *ris, u16 partid,
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
 /* Called via IPI. Call while holding an SRCU reference */
 static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
 				      struct mpam_config *cfg)
@@ -1508,10 +1525,15 @@ static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
 
 	if (mpam_has_feature(mpam_feat_mbw_min, rprops) &&
 	    mpam_has_feature(mpam_feat_mbw_min, cfg)) {
-		if (cfg->reset_mbw_min)
-			mpam_write_partsel_reg(msc, MBW_MIN, 0);
-		else
+		if (cfg->reset_mbw_min) {
+			u16 reset = 0;
+
+			if (mpam_has_quirk(T241_FORCE_MBW_MIN_TO_ONE, msc))
+				reset = mpam_wa_t241_force_mbw_min_to_one(rprops);
+			mpam_write_partsel_reg(msc, MBW_MIN, reset);
+		} else {
 			mpam_write_partsel_reg(msc, MBW_MIN, cfg->mbw_min);
+		}
 	}
 
 	if (mpam_has_feature(mpam_feat_mbw_max, rprops) &&
@@ -2539,6 +2561,18 @@ static void mpam_extend_config(struct mpam_class *class, struct mpam_config *cfg
 	u16 min, min_hw_granule, delta;
 	u16 max_hw_value, res0_bits;
 
+	/*
+	 * Calculate the values the 'min' control can hold.
+	 * e.g. on a platform with bwa_wd = 8, min_hw_granule is 0x00ff because
+	 * those bits are RES0. Configurations of this value are effectively
+	 * zero. But configurations need to saturate at min_hw_granule on
+	 * systems with mismatched bwa_wd, where the 'less than 0' values are
+	 * implemented on some MSC, but not others.
+	 */
+	res0_bits = 16 - cprops->bwa_wd;
+	max_hw_value = ((1 << cprops->bwa_wd) - 1) << res0_bits;
+	min_hw_granule = ~max_hw_value;
+
 	/*
 	 * MAX and MIN should be set together. If only one is provided,
 	 * generate a configuration for the other. If only one control
@@ -2548,19 +2582,6 @@ static void mpam_extend_config(struct mpam_class *class, struct mpam_config *cfg
 	 */
 	if (mpam_has_feature(mpam_feat_mbw_max, cfg) &&
 	    !mpam_has_feature(mpam_feat_mbw_min, cfg)) {
-		/*
-		 * Calculate the values the 'min' control can hold.
-		 * e.g. on a platform with bwa_wd = 8, min_hw_granule is 0x00ff
-		 * because those bits are RES0. Configurations of this value
-		 * are effectively zero. But configurations need to saturate
-		 * at min_hw_granule on systems with mismatched bwa_wd, where
-		 * the 'less than 0' values are implemented on some MSC, but
-		 * not others.
-		 */
-		res0_bits = 16 - cprops->bwa_wd;
-		max_hw_value = ((1 << cprops->bwa_wd) - 1) << res0_bits;
-		min_hw_granule = ~max_hw_value;
-
 		delta = ((5 * MPAMCFG_MBW_MAX_MAX) / 100) - 1;
 		if (cfg->mbw_max > delta)
 			min = cfg->mbw_max - delta;
@@ -2570,6 +2591,12 @@ static void mpam_extend_config(struct mpam_class *class, struct mpam_config *cfg
 		cfg->mbw_min = max(min, min_hw_granule);
 		mpam_set_feature(mpam_feat_mbw_min, cfg);
 	}
+
+	if (mpam_has_quirk(T241_FORCE_MBW_MIN_TO_ONE, class) &&
+	    cfg->mbw_min <= min_hw_granule) {
+		cfg->mbw_min = min_hw_granule + 1;
+		mpam_set_feature(mpam_feat_mbw_min, cfg);
+	}
 }
 
 static void mpam_reset_component_cfg(struct mpam_component *comp)
diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index 871ca2169173..b4f2505519b2 100644
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

