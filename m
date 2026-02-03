Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C12F636D4FA
	for <kvmarm@lists.linux.dev>; Tue,  3 Feb 2026 21:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770155183; cv=none; b=DshNgYw0B5MqiVv4UbgfhqNwsUCgVrLa5PhNyenVTJ6qtiKu9+o6b5VgP4VuxGEeC8dw4irowd4YJ9J08IFdGh0oQ/e1nMzlzE5oU50VvBNgMR2kP59GvfOH3swp1O5YyG8GEdfUYOfPihcVuOkkjFApUlVuQLcs1f/yITuOu68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770155183; c=relaxed/simple;
	bh=6uQAX1scfqaZALJG2He4YZ4UaeKDouqy37AdCsGz4SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUlBP8+vbMX6ELlLP4HCOILJbnIII8NreZGxs4xUyNYihcf4psd3vfz8/a/MOztZDBtqFlUHygUhbCAMM4dTSctyAHCUadjktJHpjPckoG14nxn3bWirIx7ShNiR/fC/GYJKObkgR383hwl9FINqwaaPe86ZJv8aOzJySrMoe5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BCAA7339;
	Tue,  3 Feb 2026 13:46:14 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 943FF3F778;
	Tue,  3 Feb 2026 13:46:15 -0800 (PST)
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
Subject: [PATCH v4 24/41] arm_mpam: resctrl: Add kunit test for rmid idx conversions
Date: Tue,  3 Feb 2026 21:43:25 +0000
Message-ID: <20260203214342.584712-25-ben.horgan@arm.com>
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

As MPAM's pmg are scoped by partid and RDT's rmid are global the
rescrl mapping to an index needs to differ.

Add some tests for the MPAM rmid mapping.

Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Tested-by: Peter Newman <peternewman@google.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 drivers/resctrl/test_mpam_resctrl.c | 49 +++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/resctrl/test_mpam_resctrl.c b/drivers/resctrl/test_mpam_resctrl.c
index b93d6ad87e43..a20da161d965 100644
--- a/drivers/resctrl/test_mpam_resctrl.c
+++ b/drivers/resctrl/test_mpam_resctrl.c
@@ -296,6 +296,54 @@ static void test_percent_to_max_rounding(struct kunit *test)
 	KUNIT_EXPECT_LE(test, 4 * num_rounded_up, 3 * total);
 }
 
+struct rmid_idx_case {
+	u32 max_partid;
+	u32 max_pmg;
+};
+
+static const struct rmid_idx_case rmid_idx_cases[] = {
+	{0, 0}, {1, 4}, {3, 1}, {5, 9}, {4, 4}, {100, 11}, {0xFFFF, 0xFF},
+};
+
+static void test_rmid_idx_desc(const struct rmid_idx_case *param, char *desc)
+{
+	snprintf(desc, KUNIT_PARAM_DESC_SIZE, "max_partid=%d, max_pmg=%d\n",
+		 param->max_partid, param->max_pmg);
+}
+
+KUNIT_ARRAY_PARAM(test_rmid_idx, rmid_idx_cases, test_rmid_idx_desc);
+
+static void test_rmid_idx_encoding(struct kunit *test)
+{
+	u32 orig_mpam_partid_max = mpam_partid_max;
+	u32 orig_mpam_pmg_max = mpam_pmg_max;
+	const struct rmid_idx_case *param = test->param_value;
+	u32 idx, num_idx, count = 0;
+
+	mpam_partid_max = param->max_partid;
+	mpam_pmg_max = param->max_pmg;
+
+	for (u32 partid = 0; partid <= mpam_partid_max; partid++) {
+		for (u32 pmg = 0; pmg <= mpam_pmg_max; pmg++) {
+			u32 partid_out, pmg_out;
+
+			idx = resctrl_arch_rmid_idx_encode(partid, pmg);
+			/* Confirm there are no holes in the rmid idx range */
+			KUNIT_EXPECT_EQ(test, count, idx);
+			count++;
+			resctrl_arch_rmid_idx_decode(idx, &partid_out, &pmg_out);
+			KUNIT_EXPECT_EQ(test, pmg, pmg_out);
+			KUNIT_EXPECT_EQ(test, partid, partid_out);
+		}
+	}
+	num_idx = resctrl_arch_system_num_rmid_idx();
+	KUNIT_EXPECT_EQ(test, idx + 1, num_idx);
+
+	/* Restore global variables that were messed with */
+	mpam_partid_max = orig_mpam_partid_max;
+	mpam_pmg_max = orig_mpam_pmg_max;
+}
+
 static struct kunit_case mpam_resctrl_test_cases[] = {
 	KUNIT_CASE(test_get_mba_granularity),
 	KUNIT_CASE_PARAM(test_mbw_max_to_percent, test_percent_value_gen_params),
@@ -304,6 +352,7 @@ static struct kunit_case mpam_resctrl_test_cases[] = {
 	KUNIT_CASE(test_percent_to_max_rounding),
 	KUNIT_CASE_PARAM(test_percent_max_roundtrip_stability,
 			 test_all_bwa_wd_gen_params),
+	KUNIT_CASE_PARAM(test_rmid_idx_encoding, test_rmid_idx_gen_params),
 	{}
 };
 
-- 
2.43.0

