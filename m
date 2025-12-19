Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEF0F35C1B7
	for <kvmarm@lists.linux.dev>; Fri, 19 Dec 2025 18:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766168119; cv=none; b=tMiObkTInLXqJhwXxRp0QH5Ly2BwrOp1QG9nv4gCCZo1khRJ/hvzlLddC/mDPMYFHunlvwGeuupzRybrRzj3mn6HlbhHjY6TpGvUTr7abjjKBK0dIM+/HzrG7QpVc82rsWI5rlDc6Ba/JRn8B+kKNmng294CYMQc23x/4cCkAyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766168119; c=relaxed/simple;
	bh=AsJVU1jLqI1DcpGngLH/kUoiYSB0mbkj6EYzwJNjpYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZS83V7nHkdjuGdcdD2Cxmd20qhwYrmOk08tFIWZ1YEBHylrpG7XOIZqVd1byvllNHsmz2y/9ehyznIAZzTWSPehrYOF3JrLbysicmPa7RlTOF0cLKPQnlK75mwEH54Q5Bk6IOvfL4WFw/Vk47HIlOMnMueLx4FH8/0SumSFta0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 31F7116A3;
	Fri, 19 Dec 2025 10:15:06 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BCD9D3F5CA;
	Fri, 19 Dec 2025 10:15:08 -0800 (PST)
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
	Zeng Heng <zengheng4@huawei.com>
Subject: [PATCH v2 40/45] arm_mpam: Generate a configuration for min controls
Date: Fri, 19 Dec 2025 18:11:42 +0000
Message-ID: <20251219181147.3404071-41-ben.horgan@arm.com>
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

MPAM supports a minimum and maximum control for memory bandwidth. The
purpose of the minimum control is to give priority to tasks that are below
their minimum value. Resctrl only provides one value for the bandwidth
configuration, which is used for the maximum.

The minimum control is always programmed to zero on hardware that supports
it.

Generate a minimum bandwidth value that is 5% lower than the value provided
by resctrl. This means tasks that are not receiving their target bandwidth
can be prioritised by the hardware.

For component reset reuse the same calculation so that the default is a
value resctrl can set.

CC: Zeng Heng <zengheng4@huawei.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Add reset_mbw_min
Clear min cfg when setting max
use mpam_extend_config on component reset
---
 drivers/resctrl/mpam_devices.c      | 76 +++++++++++++++++++++++++++--
 drivers/resctrl/mpam_internal.h     |  3 ++
 drivers/resctrl/mpam_resctrl.c      |  2 +
 drivers/resctrl/test_mpam_devices.c | 66 +++++++++++++++++++++++++
 4 files changed, 142 insertions(+), 5 deletions(-)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index c20b2757b86b..deea46c2a6c3 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -721,6 +721,13 @@ static void mpam_ris_hw_probe(struct mpam_msc_ris *ris)
 			mpam_set_feature(mpam_feat_mbw_part, props);
 
 		props->bwa_wd = FIELD_GET(MPAMF_MBW_IDR_BWA_WD, mbw_features);
+
+		/*
+		 * The BWA_WD field can represent 0-63, but the control fields it
+		 * describes have a maximum of 16 bits.
+		 */
+		props->bwa_wd = min(props->bwa_wd, 16);
+
 		if (props->bwa_wd && FIELD_GET(MPAMF_MBW_IDR_HAS_MAX, mbw_features))
 			mpam_set_feature(mpam_feat_mbw_max, props);
 
@@ -1387,8 +1394,12 @@ static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
 	}
 
 	if (mpam_has_feature(mpam_feat_mbw_min, rprops) &&
-	    mpam_has_feature(mpam_feat_mbw_min, cfg))
-		mpam_write_partsel_reg(msc, MBW_MIN, 0);
+	    mpam_has_feature(mpam_feat_mbw_min, cfg)) {
+		if (cfg->reset_mbw_min)
+			mpam_write_partsel_reg(msc, MBW_MIN, 0);
+		else
+			mpam_write_partsel_reg(msc, MBW_MIN, cfg->mbw_min);
+	}
 
 	if (mpam_has_feature(mpam_feat_mbw_max, rprops) &&
 	    mpam_has_feature(mpam_feat_mbw_max, cfg)) {
@@ -1503,6 +1514,7 @@ static void mpam_init_reset_cfg(struct mpam_config *reset_cfg)
 		.reset_cpbm = true,
 		.reset_mbw_pbm = true,
 		.reset_mbw_max = true,
+		.reset_mbw_min = true,
 	};
 	bitmap_fill(reset_cfg->features, MPAM_FEATURE_LAST);
 }
@@ -2401,6 +2413,45 @@ static void __destroy_component_cfg(struct mpam_component *comp)
 	}
 }
 
+static void mpam_extend_config(struct mpam_class *class, struct mpam_config *cfg)
+{
+	struct mpam_props *cprops = &class->props;
+	u16 min, min_hw_granule, delta;
+	u16 max_hw_value, res0_bits;
+
+	/*
+	 * MAX and MIN should be set together. If only one is provided,
+	 * generate a configuration for the other. If only one control
+	 * type is supported, the other value will be ignored.
+	 *
+	 * Resctrl can only configure the MAX.
+	 */
+	if (mpam_has_feature(mpam_feat_mbw_max, cfg) &&
+	    !mpam_has_feature(mpam_feat_mbw_min, cfg)) {
+		/*
+		 * Calculate the values the 'min' control can hold.
+		 * e.g. on a platform with bwa_wd = 8, min_hw_granule is 0x00ff
+		 * because those bits are RES0. Configurations of this value
+		 * are effectively zero. But configurations need to saturate
+		 * at min_hw_granule on systems with mismatched bwa_wd, where
+		 * the 'less than 0' values are implemented on some MSC, but
+		 * not others.
+		 */
+		res0_bits = 16 - cprops->bwa_wd;
+		max_hw_value = ((1 << cprops->bwa_wd) - 1) << res0_bits;
+		min_hw_granule = ~max_hw_value;
+
+		delta = ((5 * MPAMCFG_MBW_MAX_MAX) / 100) - 1;
+		if (cfg->mbw_max > delta)
+			min = cfg->mbw_max - delta;
+		else
+			min = 0;
+
+		cfg->mbw_min = max(min, min_hw_granule);
+		mpam_set_feature(mpam_feat_mbw_min, cfg);
+	}
+}
+
 static void mpam_reset_component_cfg(struct mpam_component *comp)
 {
 	int i;
@@ -2419,6 +2470,8 @@ static void mpam_reset_component_cfg(struct mpam_component *comp)
 			comp->cfg[i].mbw_pbm = GENMASK(cprops->mbw_pbm_bits - 1, 0);
 		if (cprops->bwa_wd)
 			comp->cfg[i].mbw_max = GENMASK(15, 16 - cprops->bwa_wd);
+
+		mpam_extend_config(comp->class, &comp->cfg[i]);
 	}
 }
 
@@ -2694,24 +2747,37 @@ static bool mpam_update_config(struct mpam_config *cfg,
 	maybe_update_config(cfg, mpam_feat_cpor_part, newcfg, cpbm, has_changes);
 	maybe_update_config(cfg, mpam_feat_mbw_part, newcfg, mbw_pbm, has_changes);
 	maybe_update_config(cfg, mpam_feat_mbw_max, newcfg, mbw_max, has_changes);
+	maybe_update_config(cfg, mpam_feat_mbw_min, newcfg, mbw_min, has_changes);
 
 	return has_changes;
 }
 
 int mpam_apply_config(struct mpam_component *comp, u16 partid,
-		      struct mpam_config *cfg)
+		      struct mpam_config *user_cfg)
 {
 	struct mpam_write_config_arg arg;
 	struct mpam_msc_ris *ris;
+	struct mpam_config cfg;
 	struct mpam_vmsc *vmsc;
 	struct mpam_msc *msc;
 
 	lockdep_assert_cpus_held();
 
 	/* Don't pass in the current config! */
-	WARN_ON_ONCE(&comp->cfg[partid] == cfg);
+	WARN_ON_ONCE(&comp->cfg[partid] == user_cfg);
+
+	/*
+	 * Copy the config to avoid writing back the 'extended' version to
+	 * the caller.
+	 * This avoids mpam_devices.c setting a mbm_min that mpam_resctrl.c
+	 * is unaware of ... when it then changes mbm_max to be lower than
+	 * mbm_min.
+	 */
+	cfg = *user_cfg;
+
+	mpam_extend_config(comp->class, &cfg);
 
-	if (!mpam_update_config(&comp->cfg[partid], cfg))
+	if (!mpam_update_config(&comp->cfg[partid], &cfg))
 		return 0;
 
 	arg.comp = comp;
diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index 9a3996decda5..cc580dea9430 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -274,10 +274,12 @@ struct mpam_config {
 	u32	cpbm;
 	u32	mbw_pbm;
 	u16	mbw_max;
+	u16	mbw_min;
 
 	bool	reset_cpbm;
 	bool	reset_mbw_pbm;
 	bool	reset_mbw_max;
+	bool	reset_mbw_min;
 
 	struct mpam_garbage	garbage;
 };
@@ -615,6 +617,7 @@ static inline void mpam_resctrl_teardown_class(struct mpam_class *class) { }
  * MPAMCFG_MBW_MAX - MPAM memory maximum bandwidth partitioning configuration
  *                   register
  */
+#define MPAMCFG_MBW_MAX_MAX_NR_BITS	16
 #define MPAMCFG_MBW_MAX_MAX		GENMASK(15, 0)
 #define MPAMCFG_MBW_MAX_HARDLIM		BIT(31)
 
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index bbb12b5dfd8c..b24ae75ec6f0 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -1447,6 +1447,8 @@ int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_ctrl_domain *d,
 		if (mpam_has_feature(mpam_feat_mbw_max, cprops)) {
 			cfg.mbw_max = percent_to_mbw_max(cfg_val, cprops);
 			mpam_set_feature(mpam_feat_mbw_max, &cfg);
+			/* Allow the min to be calculated from the max */
+			mpam_clear_feature(mpam_feat_mbw_min, &cfg);
 			break;
 		}
 		fallthrough;
diff --git a/drivers/resctrl/test_mpam_devices.c b/drivers/resctrl/test_mpam_devices.c
index 3e8d564a0c64..2f802fd9f249 100644
--- a/drivers/resctrl/test_mpam_devices.c
+++ b/drivers/resctrl/test_mpam_devices.c
@@ -322,6 +322,71 @@ static void test_mpam_enable_merge_features(struct kunit *test)
 	mutex_unlock(&mpam_list_lock);
 }
 
+static void test_mpam_extend_config(struct kunit *test)
+{
+	struct mpam_config fake_cfg = { };
+	struct mpam_class fake_class = { };
+
+	/* Configurations with both are not modified */
+	fake_class.props.bwa_wd = 16;
+	fake_cfg.mbw_max = 0xfeef;
+	fake_cfg.mbw_min = 0xfeef;
+	bitmap_zero(fake_cfg.features, MPAM_FEATURE_LAST);
+	mpam_set_feature(mpam_feat_mbw_max, &fake_cfg);
+	mpam_set_feature(mpam_feat_mbw_min, &fake_cfg);
+	mpam_extend_config(&fake_class, &fake_cfg);
+	KUNIT_EXPECT_TRUE(test, mpam_has_feature(mpam_feat_mbw_max, &fake_cfg));
+	KUNIT_EXPECT_TRUE(test, mpam_has_feature(mpam_feat_mbw_min, &fake_cfg));
+	KUNIT_EXPECT_EQ(test, fake_cfg.mbw_max, 0xfeef);
+	KUNIT_EXPECT_EQ(test, fake_cfg.mbw_min, 0xfeef);
+
+	/* When a min is missing, it is generated */
+	fake_class.props.bwa_wd = 16;
+	fake_cfg.mbw_max = 0xfeef;
+	fake_cfg.mbw_min = 0;
+	bitmap_zero(fake_cfg.features, MPAM_FEATURE_LAST);
+	mpam_set_feature(mpam_feat_mbw_max, &fake_cfg);
+	mpam_extend_config(&fake_class, &fake_cfg);
+	KUNIT_EXPECT_TRUE(test, mpam_has_feature(mpam_feat_mbw_max, &fake_cfg));
+	KUNIT_EXPECT_TRUE(test, mpam_has_feature(mpam_feat_mbw_min, &fake_cfg));
+	KUNIT_EXPECT_EQ(test, fake_cfg.mbw_max, 0xfeef);
+	KUNIT_EXPECT_EQ(test, fake_cfg.mbw_min, 0xf224);
+
+	fake_class.props.bwa_wd = 8;
+	fake_cfg.mbw_max = 0xfeef;
+	fake_cfg.mbw_min = 0;
+	bitmap_zero(fake_cfg.features, MPAM_FEATURE_LAST);
+	mpam_set_feature(mpam_feat_mbw_max, &fake_cfg);
+	mpam_extend_config(&fake_class, &fake_cfg);
+	KUNIT_EXPECT_TRUE(test, mpam_has_feature(mpam_feat_mbw_max, &fake_cfg));
+	KUNIT_EXPECT_TRUE(test, mpam_has_feature(mpam_feat_mbw_min, &fake_cfg));
+	KUNIT_EXPECT_EQ(test, fake_cfg.mbw_max, 0xfeef);
+	KUNIT_EXPECT_EQ(test, fake_cfg.mbw_min, 0xf224);
+
+	/* 5% below the minimum granule, is still the minimum granule */
+	fake_class.props.bwa_wd = 12;
+	fake_cfg.mbw_max = 0xf;
+	fake_cfg.mbw_min = 0;
+	bitmap_zero(fake_cfg.features, MPAM_FEATURE_LAST);
+	mpam_set_feature(mpam_feat_mbw_max, &fake_cfg);
+	mpam_extend_config(&fake_class, &fake_cfg);
+	KUNIT_EXPECT_TRUE(test, mpam_has_feature(mpam_feat_mbw_max, &fake_cfg));
+	KUNIT_EXPECT_TRUE(test, mpam_has_feature(mpam_feat_mbw_min, &fake_cfg));
+	KUNIT_EXPECT_EQ(test, fake_cfg.mbw_max, 0xf);
+	KUNIT_EXPECT_EQ(test, fake_cfg.mbw_min, 0xf);
+
+	fake_class.props.bwa_wd = 16;
+	fake_cfg.mbw_max = 0x4;
+	fake_cfg.mbw_min = 0;
+	bitmap_zero(fake_cfg.features, MPAM_FEATURE_LAST);
+	mpam_set_feature(mpam_feat_mbw_max, &fake_cfg);
+	mpam_extend_config(&fake_class, &fake_cfg);
+	KUNIT_EXPECT_TRUE(test, mpam_has_feature(mpam_feat_mbw_max, &fake_cfg));
+	KUNIT_EXPECT_TRUE(test, mpam_has_feature(mpam_feat_mbw_min, &fake_cfg));
+	KUNIT_EXPECT_EQ(test, fake_cfg.mbw_max, 0x4);
+	KUNIT_EXPECT_EQ(test, fake_cfg.mbw_min, 0x0);
+}
+
 static void test_mpam_reset_msc_bitmap(struct kunit *test)
 {
 	char __iomem *buf = kunit_kzalloc(test, SZ_16K, GFP_KERNEL);
@@ -378,6 +443,7 @@ static struct kunit_case mpam_devices_test_cases[] = {
 	KUNIT_CASE(test_mpam_reset_msc_bitmap),
 	KUNIT_CASE(test_mpam_enable_merge_features),
 	KUNIT_CASE(test__props_mismatch),
+	KUNIT_CASE(test_mpam_extend_config),
 	{}
 };
 
-- 
2.43.0

