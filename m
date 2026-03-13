Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D3303A7F74
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 14:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773413324; cv=none; b=s8vo8Xx6CF+zEmVlANArT6nUU3Ptt+lZ+wvy5bH52b0NEOSJvU6T8BgAnJWRaTqbzzSuUuWJhvHuxUrPFHYI4eoS/tRLu2li4cw1PWD+cqJrcp5lP7T4s24EAbutYsbQkVzw3IC6jBMdoKVXpb8QSpFs64YsXIcSN/smMR9Yvhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773413324; c=relaxed/simple;
	bh=DQWiqXmvHCyZytT+Myk6lqO8u9lOnLILZTNCmyVo670=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9iIK8sMliOG3cjnGtif9Vd2Qy/4oE0DKokFt6Tv+L497jTENwibmTwa1iJQECv1BkCdYy/w7ntsw/EHvnSB6YBugRcoQzWuV0AKgUVGwqCjZB7DSAr20UwmTq3nfOE5I9kw/ZMISJJuu9AVgbxFtf1JkGRtKWeJq+nXW0tD27k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9BD872454;
	Fri, 13 Mar 2026 07:48:36 -0700 (PDT)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CFFA43F7BD;
	Fri, 13 Mar 2026 07:48:38 -0700 (PDT)
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
Subject: [PATCH v6 31/40] arm_mpam: resctrl: Update the rmid reallocation limit
Date: Fri, 13 Mar 2026 14:46:08 +0000
Message-ID: <20260313144617.3420416-32-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260313144617.3420416-1-ben.horgan@arm.com>
References: <20260313144617.3420416-1-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: James Morse <james.morse@arm.com>

resctrl's limbo code needs to be told when the data left in a cache is
small enough for the partid+pmg value to be re-allocated.

x86 uses the cache size divided by the number of rmid users the cache may
have. Do the same, but for the smallest cache, and with the number of
partid-and-pmg users.

Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Tested-by: Peter Newman <peternewman@google.com>
Tested-by: Zeng Heng <zengheng4@huawei.com>
Tested-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
Reviewed-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since v2:
Move waiting for cache info into it's own patch

Changes since v3:
Move check class is csu higher (just kept to document intent)
continue -> break

to squash update rmid limits
use raw_smp_processor_id()
---
 drivers/resctrl/mpam_resctrl.c | 39 ++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 4f6a53d1bd4f..3979808f7253 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -438,6 +438,42 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 				 closid, rmid, val);
 }
 
+/*
+ * The rmid realloc threshold should be for the smallest cache exposed to
+ * resctrl.
+ */
+static int update_rmid_limits(struct mpam_class *class)
+{
+	u32 num_unique_pmg = resctrl_arch_system_num_rmid_idx();
+	struct mpam_props *cprops = &class->props;
+	struct cacheinfo *ci;
+
+	lockdep_assert_cpus_held();
+
+	if (!mpam_has_feature(mpam_feat_msmon_csu, cprops))
+		return 0;
+
+	/*
+	 * Assume cache levels are the same size for all CPUs...
+	 * The check just requires any online CPU and it can't go offline as we
+	 * hold the cpu lock.
+	 */
+	ci = get_cpu_cacheinfo_level(raw_smp_processor_id(), class->level);
+	if (!ci || ci->size == 0) {
+		pr_debug("Could not read cache size for class %u\n",
+			 class->level);
+		return -EINVAL;
+	}
+
+	if (!resctrl_rmid_realloc_limit ||
+	    ci->size < resctrl_rmid_realloc_limit) {
+		resctrl_rmid_realloc_limit = ci->size;
+		resctrl_rmid_realloc_threshold = ci->size / num_unique_pmg;
+	}
+
+	return 0;
+}
+
 static bool cache_has_usable_cpor(struct mpam_class *class)
 {
 	struct mpam_props *cprops = &class->props;
@@ -856,6 +892,9 @@ static void mpam_resctrl_pick_counters(void)
 			/* CSU counters only make sense on a cache. */
 			switch (class->type) {
 			case MPAM_CLASS_CACHE:
+				if (update_rmid_limits(class))
+					break;
+
 				counter_update_class(QOS_L3_OCCUP_EVENT_ID, class);
 				break;
 			default:
-- 
2.43.0

