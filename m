Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 355903AE716
	for <kvmarm@lists.linux.dev>; Tue, 24 Feb 2026 17:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771955960; cv=none; b=XJgEELAunBBBV5oO7bvKEZaofE6eNj/qsCO5Q+tvO2YkQuLw0waN1oS/qzk3yvFp6WChw/pvLhi/ZfeWn4TTIHrkkqM6GNLrJ4TGLSXdPr4FGBfBPlru1W86CfuNn3yzMa0hgeT0bwlYUXU+AtbpGS+taQ9kYNOmvd0/u//Y9ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771955960; c=relaxed/simple;
	bh=x+zzgKCqpfOz6R6pyJnRVmlLRYFp+wDcLpabZCPlaq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYxT+dkLzbhqYZaxbDUgxLwkNrUSfnH6AcciCqafSak8+JVbLSRzkW0u0fdNjFKWOE8C2ephuEARLWmu0ipVW9ZOj9Kl/oNBXmsZj+dm9qHG5NJOLjAsoltgKCJ2jK+Zlt1bJH8rNIk+bpo7LHstOKKxlgrqjNIJ9uUgy37VAD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 68CA2339;
	Tue, 24 Feb 2026 09:59:12 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E8DF33F59E;
	Tue, 24 Feb 2026 09:59:10 -0800 (PST)
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
Subject: [PATCH v5 20/41] arm_mpam: resctrl: Convert to/from MPAMs fixed-point formats
Date: Tue, 24 Feb 2026 17:56:59 +0000
Message-ID: <20260224175720.2663924-21-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260224175720.2663924-1-ben.horgan@arm.com>
References: <20260224175720.2663924-1-ben.horgan@arm.com>
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
index e4a302a53991..90d69091e0b9 100644
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
index fa818ee5db18..38d1b7f48ecf 100644
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
@@ -227,6 +228,56 @@ static bool cache_has_usable_cpor(struct mpam_class *class)
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

