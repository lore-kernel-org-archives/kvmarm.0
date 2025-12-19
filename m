Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC59357726
	for <kvmarm@lists.linux.dev>; Fri, 19 Dec 2025 18:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766168073; cv=none; b=SayKwKHLgTiAuToS1U0+4l38rNO6O4Vp7J32NbIWciP3fM+5tQ4XqiPKBug79zG4+I6xq+OugFbBvzvco1vXgNDEObPQJjGGhyXjY5dRFe7z76w9trPUPYnAxm0vGLgHoQwOKATqrwhTJsoLseEfoTrBCb24+1YFZ6Ps6vtb+bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766168073; c=relaxed/simple;
	bh=cfmsuiVq+53M8wWNtwpm8Z+XCn05XP1PZuwdAJt4PF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwGh0FryhH2Cbb9oBsNBxR/WJapjauAbptfAmemdL5/0dM24ZNXiIB8e9kYjPWzutP6hVXbv0iQ/pprM5GnxnW9XxirvA7IrIJeDbUcJtU6oaTHrqYP7frdYI0nf2WXMCnKN8oLrGbQ1GPKr9MHISbzUUY20JWcYNu8IwyLUgkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B0D061684;
	Fri, 19 Dec 2025 10:14:23 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 601D73F5CA;
	Fri, 19 Dec 2025 10:14:26 -0800 (PST)
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
Subject: [PATCH v2 31/45] arm_mpam: resctrl: Add kunit test for ABMC/CDP interactions
Date: Fri, 19 Dec 2025 18:11:33 +0000
Message-ID: <20251219181147.3404071-32-ben.horgan@arm.com>
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

ABMC exposes a fun corner case where a platform with one monitor can use
ABMC for assignable counters - but not when CDP is enabled.

Add some tests.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 drivers/resctrl/test_mpam_resctrl.c | 62 +++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/drivers/resctrl/test_mpam_resctrl.c b/drivers/resctrl/test_mpam_resctrl.c
index d0615aa7671c..c83d54f21fa0 100644
--- a/drivers/resctrl/test_mpam_resctrl.c
+++ b/drivers/resctrl/test_mpam_resctrl.c
@@ -293,6 +293,67 @@ static void test_percent_to_max_rounding(struct kunit *test)
 	KUNIT_EXPECT_LE(test, 4 * num_rounded_up, 3 * total);
 }
 
+static void test_num_assignable_counters(struct kunit *test)
+{
+	unsigned int orig_l3_num_allocated_mbwu = l3_num_allocated_mbwu;
+	u32 orig_mpam_partid_max = mpam_partid_max;
+	u32 orig_mpam_pmg_max = mpam_pmg_max;
+	bool orig_cdp_enabled = cdp_enabled;
+	struct rdt_resource fake_l3;
+
+	/* Force there to be some PARTID/PMG */
+	mpam_partid_max = 3;
+	mpam_pmg_max = 1;
+
+	cdp_enabled = false;
+
+	/* ABMC off, CDP off */
+	l3_num_allocated_mbwu = resctrl_arch_system_num_rmid_idx();
+	mpam_resctrl_monitor_sync_abmc_vals(&fake_l3);
+	KUNIT_EXPECT_EQ(test, fake_l3.mon.num_mbm_cntrs, resctrl_arch_system_num_rmid_idx());
+	KUNIT_EXPECT_FALSE(test, fake_l3.mon.mbm_cntr_assignable);
+	KUNIT_EXPECT_FALSE(test, fake_l3.mon.mbm_assign_on_mkdir);
+
+	/* ABMC on, CDP off */
+	l3_num_allocated_mbwu = 4;
+	mpam_resctrl_monitor_sync_abmc_vals(&fake_l3);
+	KUNIT_EXPECT_EQ(test, fake_l3.mon.num_mbm_cntrs, 4);
+	KUNIT_EXPECT_TRUE(test, fake_l3.mon.mbm_cntr_assignable);
+	KUNIT_EXPECT_TRUE(test, fake_l3.mon.mbm_assign_on_mkdir);
+
+	cdp_enabled = true;
+
+	/* ABMC off, CDP on */
+	l3_num_allocated_mbwu = resctrl_arch_system_num_rmid_idx();
+	mpam_resctrl_monitor_sync_abmc_vals(&fake_l3);
+
+	/* (value not consumed by resctrl) */
+	KUNIT_EXPECT_EQ(test, fake_l3.mon.num_mbm_cntrs, resctrl_arch_system_num_rmid_idx() / 2);
+
+	KUNIT_EXPECT_FALSE(test, fake_l3.mon.mbm_cntr_assignable);
+	KUNIT_EXPECT_FALSE(test, fake_l3.mon.mbm_assign_on_mkdir);
+
+	/* ABMC on, CDP on */
+	l3_num_allocated_mbwu = 4;
+	mpam_resctrl_monitor_sync_abmc_vals(&fake_l3);
+	KUNIT_EXPECT_EQ(test, fake_l3.mon.num_mbm_cntrs, 2);
+	KUNIT_EXPECT_TRUE(test, fake_l3.mon.mbm_cntr_assignable);
+	KUNIT_EXPECT_TRUE(test, fake_l3.mon.mbm_assign_on_mkdir);
+
+	/* ABMC 'on', CDP on - but not enough counters */
+	l3_num_allocated_mbwu = 1;
+	mpam_resctrl_monitor_sync_abmc_vals(&fake_l3);
+	KUNIT_EXPECT_EQ(test, fake_l3.mon.num_mbm_cntrs, 0);
+	KUNIT_EXPECT_FALSE(test, fake_l3.mon.mbm_cntr_assignable);
+	KUNIT_EXPECT_FALSE(test, fake_l3.mon.mbm_assign_on_mkdir);
+
+	/* Restore global variables that were messed with */
+	l3_num_allocated_mbwu = orig_l3_num_allocated_mbwu;
+	mpam_partid_max = orig_mpam_partid_max;
+	mpam_pmg_max = orig_mpam_pmg_max;
+	cdp_enabled = orig_cdp_enabled;
+}
+
 static struct kunit_case mpam_resctrl_test_cases[] = {
 	KUNIT_CASE(test_get_mba_granularity),
 	KUNIT_CASE_PARAM(test_mbw_max_to_percent, test_percent_value_gen_params),
@@ -301,6 +362,7 @@ static struct kunit_case mpam_resctrl_test_cases[] = {
 	KUNIT_CASE(test_percent_to_max_rounding),
 	KUNIT_CASE_PARAM(test_percent_max_roundtrip_stability,
 			 test_all_bwa_wd_gen_params),
+	KUNIT_CASE(test_num_assignable_counters),
 	{}
 };
 
-- 
2.43.0

