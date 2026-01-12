Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16A1637A4AA
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 17:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768237370; cv=none; b=bJEsywwREBW8DMR09lGvuK2IZTO7CF21XNBXBrgbqnEsGQuvyItrNnoJk/3rcIc8C0MVTlWwrQ8kg3QG1GgNINDrvPPM25lRkv0EiVO4XLaB6mMDY7tzlPGtMy5Wt1NTs06dG3rrBpALm/E7HpGvh0BxegtDNPfzMaCB3BRCum8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768237370; c=relaxed/simple;
	bh=zhMZZs1i94LApS14sfoltW2wqXmvqCFPStaTi5GmC+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHseya+CE2XRWeZItVKzbPit28ALBjKCUyOlYriIY988xjlXZVwGiyFrUdb2icS/yb+DNfmXsL3EHMDkUMWzmPkpS9aUqaqqF62P/SjaxK97kkWqGa6zj6YxfJOIpO3itkSQJOU+ntf+tUcjoprf8g1O4Hy+M3YqJ95SBOsWgUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B811153B;
	Mon, 12 Jan 2026 09:02:39 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CE8AF3F694;
	Mon, 12 Jan 2026 09:02:40 -0800 (PST)
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
Subject: [PATCH v3 32/47] arm_mpam: resctrl: Add kunit test for ABMC/CDP interactions
Date: Mon, 12 Jan 2026 16:58:59 +0000
Message-ID: <20260112165914.4086692-33-ben.horgan@arm.com>
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

ABMC exposes a fun corner case where a platform with one monitor can use
ABMC for assignable counters - but not when CDP is enabled.

Add some tests.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 drivers/resctrl/test_mpam_resctrl.c | 62 +++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/drivers/resctrl/test_mpam_resctrl.c b/drivers/resctrl/test_mpam_resctrl.c
index a20da161d965..fd63f7bbb147 100644
--- a/drivers/resctrl/test_mpam_resctrl.c
+++ b/drivers/resctrl/test_mpam_resctrl.c
@@ -344,6 +344,67 @@ static void test_rmid_idx_encoding(struct kunit *test)
 	mpam_pmg_max = orig_mpam_pmg_max;
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
@@ -353,6 +414,7 @@ static struct kunit_case mpam_resctrl_test_cases[] = {
 	KUNIT_CASE_PARAM(test_percent_max_roundtrip_stability,
 			 test_all_bwa_wd_gen_params),
 	KUNIT_CASE_PARAM(test_rmid_idx_encoding, test_rmid_idx_gen_params),
+	KUNIT_CASE(test_num_assignable_counters),
 	{}
 };
 
-- 
2.43.0

