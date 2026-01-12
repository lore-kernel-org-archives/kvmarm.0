Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 502A137BE8B
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 17:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768237425; cv=none; b=SyLCX8qjcUfRwveT3j2FC/SjEnHokicWfi+KZaGS06GcuD+ET6tSds4o3P5Gp6LyoSlU8BySaD6ScRd5QjZbWQ0Zrq9zt9TJLlBaKzWqluCbV7WaXZqflEoSInf32s7sxufXaBZHhLPOb8PFIeArcSBfEKgwMjhOfCZD9NV6cNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768237425; c=relaxed/simple;
	bh=aQEZNS6Ke/1cRKqe7iknWKNUt2hUd5L2CJM0NZ6uu3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8E7EfR6MrncqRu5In+GuDW5nq7nR+UCdWeCwswygv9u/YvIFbE/P7ry3LiuA7j2K43KKhknmeDXhegTocaNXrduS0vI/OJrghpDXOMARUHi0NUbZ+1KwgWnEG2vI/WRpIzZk2or+S7111hxHLwM1O6UUjzuEpyp7Kj5ViFa8h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DEFA6153B;
	Mon, 12 Jan 2026 09:03:33 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7F3613F694;
	Mon, 12 Jan 2026 09:03:35 -0800 (PST)
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
Subject: [PATCH v3 42/47] arm_mpam: resctrl: Add kunit test for mbw min control generation
Date: Mon, 12 Jan 2026 16:59:09 +0000
Message-ID: <20260112165914.4086692-43-ben.horgan@arm.com>
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

By default we generate a minimum bandwidth value that is 5% lower
than the maximum bandwidth value given by resctrl.

Add a test for this.

Signed-off-by: James Morse <james.morse@arm.com>
[horgan: Split test into separate patch]
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 drivers/resctrl/test_mpam_devices.c | 66 +++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

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

