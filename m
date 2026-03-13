Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92E8E3B0AD8
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 14:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773413289; cv=none; b=UrlzG+NqpB6RvieML4E0vqXe6NQJAhJXosXpq95yTilODmdDmxVmYT4ge9M6aeb1SgtMs4A4GtfG0bBLiwVlFdyosjxR4OA59zxU2TBls+DWp2eNIPEmajb1gQ+zf8+cKOU6XyF5kwRfqfJp7LM5MUjjpJzwQIQYpErDN/P2TS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773413289; c=relaxed/simple;
	bh=qFO3SEX9+/pa5NMlxT2jlw5aF6PjUoWP7/PiryOyjJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTLTxRFZ1+KWz374q6RqjgWszgEl7CFh28eAK7FxViwwoT7wyV4+GbFGB80EKLtABq1UGoB9ho78Juw8sufAzqPS5b0M66BOZM3fapFAu1R912AEloLbNHipehi8hdGI46kRJwEZwrq/Vq1YLbhOakNl07uljdr3WbUc53gSgYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A813B2308;
	Fri, 13 Mar 2026 07:47:58 -0700 (PDT)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C120B3F7BD;
	Fri, 13 Mar 2026 07:48:00 -0700 (PDT)
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
Subject: [PATCH v6 22/40] arm_mpam: resctrl: Convert to/from MPAMs fixed-point formats
Date: Fri, 13 Mar 2026 14:45:59 +0000
Message-ID: <20260313144617.3420416-23-ben.horgan@arm.com>
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

From: Dave Martin <Dave.Martin@arm.com>

MPAM uses a fixed-point formats for some hardware controls.  Resctrl
provides the bandwidth controls as a percentage. Add helpers to convert
between these.

Ensure bwa_wd is at most 16 to make it clear higher values have no meaning.

Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Tested-by: Peter Newman <peternewman@google.com>
Tested-by: Zeng Heng <zengheng4@huawei.com>
Tested-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
Reviewed-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since v2:
Ensure bwa_wd is at most 16 (moved from patch 40: arm_mpam: Generate a
configuration for min controls)
Expand comments
---
 drivers/resctrl/mpam_devices.c |  7 +++++
 drivers/resctrl/mpam_resctrl.c | 51 ++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index 0e5e24ef60fe..0c97f7708722 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -713,6 +713,13 @@ static void mpam_ris_hw_probe(struct mpam_msc_ris *ris)
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
 
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index cab3e9ccb5c7..adaec522c1a1 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -10,6 +10,7 @@
 #include <linux/errno.h>
 #include <linux/limits.h>
 #include <linux/list.h>
+#include <linux/math.h>
 #include <linux/printk.h>
 #include <linux/rculist.h>
 #include <linux/resctrl.h>
@@ -242,6 +243,56 @@ static bool cache_has_usable_cpor(struct mpam_class *class)
 	return class->props.cpbm_wd <= 32;
 }
 
+/*
+ * Each fixed-point hardware value architecturally represents a range
+ * of values: the full range 0% - 100% is split contiguously into
+ * (1 << cprops->bwa_wd) equal bands.
+ *
+ * Although the bwa_bwd fields have 6 bits the maximum valid value is 16
+ * as it reports the width of fields that are at most 16 bits. When
+ * fewer than 16 bits are valid the least significant bits are
+ * ignored. The implied binary point is kept between bits 15 and 16 and
+ * so the valid bits are leftmost.
+ *
+ * See ARM IHI0099B.a "MPAM system component specification", Section 9.3,
+ * "The fixed-point fractional format" for more information.
+ *
+ * Find the nearest percentage value to the upper bound of the selected band:
+ */
+static u32 mbw_max_to_percent(u16 mbw_max, struct mpam_props *cprops)
+{
+	u32 val = mbw_max;
+
+	val >>= 16 - cprops->bwa_wd;
+	val += 1;
+	val *= MAX_MBA_BW;
+	val = DIV_ROUND_CLOSEST(val, 1 << cprops->bwa_wd);
+
+	return val;
+}
+
+/*
+ * Find the band whose upper bound is closest to the specified percentage.
+ *
+ * A round-to-nearest policy is followed here as a balanced compromise
+ * between unexpected under-commit of the resource (where the total of
+ * a set of resource allocations after conversion is less than the
+ * expected total, due to rounding of the individual converted
+ * percentages) and over-commit (where the total of the converted
+ * allocations is greater than expected).
+ */
+static u16 percent_to_mbw_max(u8 pc, struct mpam_props *cprops)
+{
+	u32 val = pc;
+
+	val <<= cprops->bwa_wd;
+	val = DIV_ROUND_CLOSEST(val, MAX_MBA_BW);
+	val = max(val, 1) - 1;
+	val <<= 16 - cprops->bwa_wd;
+
+	return val;
+}
+
 /* Test whether we can export MPAM_CLASS_CACHE:{2,3}? */
 static void mpam_resctrl_pick_caches(void)
 {
-- 
2.43.0

