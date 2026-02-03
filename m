Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C15BF378806
	for <kvmarm@lists.linux.dev>; Tue,  3 Feb 2026 21:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770155171; cv=none; b=raGQfvKAG/pwg8n2TYoyg78q+7rWf4iS2ziFzh8dFKzGrozTJ6CSTrlDfl9POuJFjnzEYEGPe1mDVQIOXYrc5A05HJa7DY04vk3vPZM2B1SyRzFzUoXrgBsCuy5/DcQIoZPsyiOvvf0skVkUTbAIkBm+RaLLTeIfqbTIK/5PrrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770155171; c=relaxed/simple;
	bh=l307hJX9jaa0dpu2kl5zYueLCcnE+CkivZflPAC50gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6VVtn28cMUbcUxXH/gYVOUuDswyQyPw26Dk07DVwA5kq1euG+ynQVgm+3nAR2yo/cBWUN9YO20ms9VH4qKMx22fwkyr4rgHg+7v23hNrFjdsgnWWv+xw0qfwUr9K9L4hqP/4Jc7ekNE/Aj9KjMU+xMGXpRruqTtj4thl910R/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F3A99497;
	Tue,  3 Feb 2026 13:46:02 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A7CB03F778;
	Tue,  3 Feb 2026 13:46:03 -0800 (PST)
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
	Dave Martin <Dave.Martin@arm.com>,
	Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Subject: [PATCH v4 22/41] arm_mpam: resctrl: Add kunit test for control format conversions
Date: Tue,  3 Feb 2026 21:43:23 +0000
Message-ID: <20260203214342.584712-23-ben.horgan@arm.com>
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

From: Dave Martin <Dave.Martin@arm.com>

resctrl specifies the format of the control schemes, and these don't match
the hardware.

Some of the conversions are a bit hairy - add some kunit tests.

Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Tested-by: Peter Newman <peternewman@google.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
[morse: squashed enough of Dave's fixes in here that it's his patch now!]
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since v2:
Include additional values from the latest spec
---
 drivers/resctrl/mpam_resctrl.c      |   4 +
 drivers/resctrl/test_mpam_resctrl.c | 315 ++++++++++++++++++++++++++++
 2 files changed, 319 insertions(+)
 create mode 100644 drivers/resctrl/test_mpam_resctrl.c

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index ece46e0d2ab3..183428e2d38c 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -792,3 +792,7 @@ int mpam_resctrl_setup(void)
 
 	return 0;
 }
+
+#ifdef CONFIG_MPAM_KUNIT_TEST
+#include "test_mpam_resctrl.c"
+#endif
diff --git a/drivers/resctrl/test_mpam_resctrl.c b/drivers/resctrl/test_mpam_resctrl.c
new file mode 100644
index 000000000000..b93d6ad87e43
--- /dev/null
+++ b/drivers/resctrl/test_mpam_resctrl.c
@@ -0,0 +1,315 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2025 Arm Ltd.
+/* This file is intended to be included into mpam_resctrl.c */
+
+#include <kunit/test.h>
+#include <linux/array_size.h>
+#include <linux/bits.h>
+#include <linux/math.h>
+#include <linux/sprintf.h>
+
+struct percent_value_case {
+	u8	pc;
+	u8	width;
+	u16	value;
+};
+
+/*
+ * Mysterious inscriptions taken from the union of ARM DDI 0598D.b,
+ * "Arm Architecture Reference Manual Supplement - Memory System
+ * Resource Partitioning and Monitoring (MPAM), for A-profile
+ * architecture", Section 9.8, "About the fixed-point fractional
+ * format" (exact percentage entries only) and ARM IHI0099B.a
+ * "MPAM system component specification", Section 9.3,
+ * "The fixed-point fractional format":
+ */
+static const struct percent_value_case percent_value_cases[] = {
+	/* Architectural cases: */
+	{   1,  8,    1 },	{   1, 12,  0x27 },	{   1, 16,  0x28e },
+	{  25,  8, 0x3f },	{  25, 12, 0x3ff },	{  25, 16, 0x3fff },
+	{  33,  8, 0x53 },	{  33, 12, 0x546 },	{  33, 16, 0x5479 },
+	{  35,  8, 0x58 },	{  35, 12, 0x598 },	{  35, 16, 0x5998 },
+	{  45,  8, 0x72 },	{  45, 12, 0x732 },	{  45, 16, 0x7332 },
+	{  50,  8, 0x7f },	{  50, 12, 0x7ff },	{  50, 16, 0x7fff },
+	{  52,  8, 0x84 },	{  52, 12, 0x850 },	{  52, 16, 0x851d },
+	{  55,  8, 0x8b },	{  55, 12, 0x8cb },	{  55, 16, 0x8ccb },
+	{  58,  8, 0x93 },	{  58, 12, 0x946 },	{  58, 16, 0x9479 },
+	{  75,  8, 0xbf },	{  75, 12, 0xbff },	{  75, 16, 0xbfff },
+	{  80,  8, 0xcb },	{  80, 12, 0xccb },	{  80, 16, 0xcccb },
+	{  88,  8, 0xe0 },	{  88, 12, 0xe13 },	{  88, 16, 0xe146 },
+	{  95,  8, 0xf2 },	{  95, 12, 0xf32 },	{  95, 16, 0xf332 },
+	{ 100,  8, 0xff },	{ 100, 12, 0xfff },	{ 100, 16, 0xffff },
+};
+
+static void test_percent_value_desc(const struct percent_value_case *param,
+				    char *desc)
+{
+	snprintf(desc, KUNIT_PARAM_DESC_SIZE,
+		 "pc=%d, width=%d, value=0x%.*x\n",
+		 param->pc, param->width,
+		 DIV_ROUND_UP(param->width, 4), param->value);
+}
+
+KUNIT_ARRAY_PARAM(test_percent_value, percent_value_cases,
+		  test_percent_value_desc);
+
+struct percent_value_test_info {
+	u32 pc;			/* result of value-to-percent conversion */
+	u32 value;		/* result of percent-to-value conversion */
+	u32 max_value;		/* maximum raw value allowed by test params */
+	unsigned int shift;	/* promotes raw testcase value to 16 bits */
+};
+
+/*
+ * Convert a reference percentage to a fixed-point MAX value and
+ * vice-versa, based on param (not test->param_value!)
+ */
+static void __prepare_percent_value_test(struct kunit *test,
+					 struct percent_value_test_info *res,
+					 const struct percent_value_case *param)
+{
+	struct mpam_props fake_props = { };
+
+	/* Reject bogus test parameters that would break the tests: */
+	KUNIT_ASSERT_GE(test, param->width, 1);
+	KUNIT_ASSERT_LE(test, param->width, 16);
+	KUNIT_ASSERT_LT(test, param->value, 1 << param->width);
+
+	mpam_set_feature(mpam_feat_mbw_max, &fake_props);
+	fake_props.bwa_wd = param->width;
+
+	res->shift = 16 - param->width;
+	res->max_value = GENMASK_U32(param->width - 1, 0);
+	res->value = percent_to_mbw_max(param->pc, &fake_props);
+	res->pc = mbw_max_to_percent(param->value << res->shift, &fake_props);
+}
+
+static void test_get_mba_granularity(struct kunit *test)
+{
+	int ret;
+	struct mpam_props fake_props = { };
+
+	/* Use MBW_MAX */
+	mpam_set_feature(mpam_feat_mbw_max, &fake_props);
+
+	fake_props.bwa_wd = 0;
+	KUNIT_EXPECT_FALSE(test, mba_class_use_mbw_max(&fake_props));
+
+	fake_props.bwa_wd = 1;
+	KUNIT_EXPECT_TRUE(test, mba_class_use_mbw_max(&fake_props));
+
+	/* Architectural maximum: */
+	fake_props.bwa_wd = 16;
+	KUNIT_EXPECT_TRUE(test, mba_class_use_mbw_max(&fake_props));
+
+	/* No usable control... */
+	fake_props.bwa_wd = 0;
+	ret = get_mba_granularity(&fake_props);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+
+	fake_props.bwa_wd = 1;
+	ret = get_mba_granularity(&fake_props);
+	KUNIT_EXPECT_EQ(test, ret, 50);	/* DIV_ROUND_UP(100, 1 << 1)% = 50% */
+
+	fake_props.bwa_wd = 2;
+	ret = get_mba_granularity(&fake_props);
+	KUNIT_EXPECT_EQ(test, ret, 25);	/* DIV_ROUND_UP(100, 1 << 2)% = 25% */
+
+	fake_props.bwa_wd = 3;
+	ret = get_mba_granularity(&fake_props);
+	KUNIT_EXPECT_EQ(test, ret, 13);	/* DIV_ROUND_UP(100, 1 << 3)% = 13% */
+
+	fake_props.bwa_wd = 6;
+	ret = get_mba_granularity(&fake_props);
+	KUNIT_EXPECT_EQ(test, ret, 2);	/* DIV_ROUND_UP(100, 1 << 6)% = 2% */
+
+	fake_props.bwa_wd = 7;
+	ret = get_mba_granularity(&fake_props);
+	KUNIT_EXPECT_EQ(test, ret, 1);	/* DIV_ROUND_UP(100, 1 << 7)% = 1% */
+
+	/* Granularity saturates at 1% */
+	fake_props.bwa_wd = 16; /* architectural maximum */
+	ret = get_mba_granularity(&fake_props);
+	KUNIT_EXPECT_EQ(test, ret, 1);	/* DIV_ROUND_UP(100, 1 << 16)% = 1% */
+}
+
+static void test_mbw_max_to_percent(struct kunit *test)
+{
+	const struct percent_value_case *param = test->param_value;
+	struct percent_value_test_info res;
+
+	/*
+	 * Since the reference values in percent_value_cases[] all
+	 * correspond to exact percentages, round-to-nearest will
+	 * always give the exact percentage back when the MPAM max
+	 * value has precision of 0.5% or finer.  (Always true for the
+	 * reference data, since they all specify 8 bits or more of
+	 * precision.
+	 *
+	 * So, keep it simple and demand an exact match:
+	 */
+	__prepare_percent_value_test(test, &res, param);
+	KUNIT_EXPECT_EQ(test, res.pc, param->pc);
+}
+
+static void test_percent_to_mbw_max(struct kunit *test)
+{
+	const struct percent_value_case *param = test->param_value;
+	struct percent_value_test_info res;
+
+	__prepare_percent_value_test(test, &res, param);
+
+	KUNIT_EXPECT_GE(test, res.value, param->value << res.shift);
+	KUNIT_EXPECT_LE(test, res.value, (param->value + 1) << res.shift);
+	KUNIT_EXPECT_LE(test, res.value, res.max_value << res.shift);
+
+	/* No flexibility allowed for 0% and 100%! */
+
+	if (param->pc == 0)
+		KUNIT_EXPECT_EQ(test, res.value, 0);
+
+	if (param->pc == 100)
+		KUNIT_EXPECT_EQ(test, res.value, res.max_value << res.shift);
+}
+
+static const void *test_all_bwa_wd_gen_params(struct kunit *test, const void *prev,
+					      char *desc)
+{
+	uintptr_t param = (uintptr_t)prev;
+
+	if (param > 15)
+		return NULL;
+
+	param++;
+
+	snprintf(desc, KUNIT_PARAM_DESC_SIZE, "wd=%u\n", (unsigned int)param);
+
+	return (void *)param;
+}
+
+static unsigned int test_get_bwa_wd(struct kunit *test)
+{
+	uintptr_t param = (uintptr_t)test->param_value;
+
+	KUNIT_ASSERT_GE(test, param, 1);
+	KUNIT_ASSERT_LE(test, param, 16);
+
+	return param;
+}
+
+static void test_mbw_max_to_percent_limits(struct kunit *test)
+{
+	struct mpam_props fake_props = {0};
+	u32 max_value;
+
+	mpam_set_feature(mpam_feat_mbw_max, &fake_props);
+	fake_props.bwa_wd = test_get_bwa_wd(test);
+	max_value = GENMASK(15, 16 - fake_props.bwa_wd);
+
+	KUNIT_EXPECT_EQ(test, mbw_max_to_percent(max_value, &fake_props),
+			MAX_MBA_BW);
+	KUNIT_EXPECT_EQ(test, mbw_max_to_percent(0, &fake_props),
+			get_mba_min(&fake_props));
+
+	/*
+	 * Rounding policy dependent 0% sanity-check:
+	 * With round-to-nearest, the minimum mbw_max value really
+	 * should map to 0% if there are at least 200 steps.
+	 * (100 steps may be enough for some other rounding policies.)
+	 */
+	if (fake_props.bwa_wd >= 8)
+		KUNIT_EXPECT_EQ(test, mbw_max_to_percent(0, &fake_props), 0);
+
+	if (fake_props.bwa_wd < 8 &&
+	    mbw_max_to_percent(0, &fake_props) == 0)
+		kunit_warn(test, "wd=%d: Testsuite/driver Rounding policy mismatch?",
+			   fake_props.bwa_wd);
+}
+
+/*
+ * Check that converting a percentage to mbw_max and back again (or, as
+ * appropriate, vice-versa) always restores the original value:
+ */
+static void test_percent_max_roundtrip_stability(struct kunit *test)
+{
+	struct mpam_props fake_props = {0};
+	unsigned int shift;
+	u32 pc, max, pc2, max2;
+
+	mpam_set_feature(mpam_feat_mbw_max, &fake_props);
+	fake_props.bwa_wd = test_get_bwa_wd(test);
+	shift = 16 - fake_props.bwa_wd;
+
+	/*
+	 * Converting a valid value from the coarser scale to the finer
+	 * scale and back again must yield the original value:
+	 */
+	if (fake_props.bwa_wd >= 7) {
+		/* More than 100 steps: only test exact pc values: */
+		for (pc = get_mba_min(&fake_props); pc <= MAX_MBA_BW; pc++) {
+			max = percent_to_mbw_max(pc, &fake_props);
+			pc2 = mbw_max_to_percent(max, &fake_props);
+			KUNIT_EXPECT_EQ(test, pc2, pc);
+		}
+	} else {
+		/* Fewer than 100 steps: only test exact mbw_max values: */
+		for (max = 0; max < 1 << 16; max += 1 << shift) {
+			pc = mbw_max_to_percent(max, &fake_props);
+			max2 = percent_to_mbw_max(pc, &fake_props);
+			KUNIT_EXPECT_EQ(test, max2, max);
+		}
+	}
+}
+
+static void test_percent_to_max_rounding(struct kunit *test)
+{
+	const struct percent_value_case *param = test->param_value;
+	unsigned int num_rounded_up = 0, total = 0;
+	struct percent_value_test_info res;
+
+	for (param = percent_value_cases, total = 0;
+	     param < &percent_value_cases[ARRAY_SIZE(percent_value_cases)];
+	     param++, total++) {
+		__prepare_percent_value_test(test, &res, param);
+		if (res.value > param->value << res.shift)
+			num_rounded_up++;
+	}
+
+	/*
+	 * The MPAM driver applies a round-to-nearest policy, whereas a
+	 * round-down policy seems to have been applied in the
+	 * reference table from which the test vectors were selected.
+	 *
+	 * For a large and well-distributed suite of test vectors,
+	 * about half should be rounded up and half down compared with
+	 * the reference table.  The actual test vectors are few in
+	 * number and probably not very well distributed however, so
+	 * tolerate a round-up rate of between 1/4 and 3/4 before
+	 * crying foul:
+	 */
+
+	kunit_info(test, "Round-up rate: %u%% (%u/%u)\n",
+		   DIV_ROUND_CLOSEST(num_rounded_up * 100, total),
+		   num_rounded_up, total);
+
+	KUNIT_EXPECT_GE(test, 4 * num_rounded_up, 1 * total);
+	KUNIT_EXPECT_LE(test, 4 * num_rounded_up, 3 * total);
+}
+
+static struct kunit_case mpam_resctrl_test_cases[] = {
+	KUNIT_CASE(test_get_mba_granularity),
+	KUNIT_CASE_PARAM(test_mbw_max_to_percent, test_percent_value_gen_params),
+	KUNIT_CASE_PARAM(test_percent_to_mbw_max, test_percent_value_gen_params),
+	KUNIT_CASE_PARAM(test_mbw_max_to_percent_limits, test_all_bwa_wd_gen_params),
+	KUNIT_CASE(test_percent_to_max_rounding),
+	KUNIT_CASE_PARAM(test_percent_max_roundtrip_stability,
+			 test_all_bwa_wd_gen_params),
+	{}
+};
+
+static struct kunit_suite mpam_resctrl_test_suite = {
+	.name = "mpam_resctrl_test_suite",
+	.test_cases = mpam_resctrl_test_cases,
+};
+
+kunit_test_suites(&mpam_resctrl_test_suite);
-- 
2.43.0

