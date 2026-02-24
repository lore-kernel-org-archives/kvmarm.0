Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73F413AEF46
	for <kvmarm@lists.linux.dev>; Tue, 24 Feb 2026 18:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771956078; cv=none; b=SxZGwcqjGJFkmk+mdwx2o1g0JdsFlYhz/Kh19Mh2vB++1zLGBmiqKG3Kj2lM3dONicaX+p0j8gxIhwFBPeG1t9ZScconDrQEuOH0ClrDuc6HfwVe9fWlvo48eneKL7TFwn9VbnNoVLrA3CcsYxoele8ZiNdHUmNLXDBjjHNQKRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771956078; c=relaxed/simple;
	bh=iCpu2Fe6D3tpcIRBlgvnnxjatxoM7l5nMhmXIOjzXj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhsEJqMatYHCXPIk1wYmoUHiyyFClNep+GNhPQPP55I8GJgPzkmkqwI/cFXHN/mleAxmA/BCZEvdKmMwLBj9kBKfU0977gVKXIRvrxxXpwcxrZzJQ1XYkn3DwHAC7cH1JKiw9t7vKBQqHHAKcmSqvybp7X1OqwwTmsCAhdOBL5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BF164165C;
	Tue, 24 Feb 2026 10:01:10 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7FF2A3F59E;
	Tue, 24 Feb 2026 10:01:11 -0800 (PST)
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
	linux-doc@vger.kernel.org
Subject: [PATCH v5 40/41] arm_mpam: Quirk CMN-650's CSU NRDY behaviour
Date: Tue, 24 Feb 2026 17:57:19 +0000
Message-ID: <20260224175720.2663924-41-ben.horgan@arm.com>
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

From: James Morse <james.morse@arm.com>

CMN-650 is afflicted with an erratum where the CSU NRDY bit never clears.
This tells us the monitor never finishes scanning the cache. The erratum
document says to wait the maximum time, then ignore the field.

Add a flag to indicate whether this is the final attempt to read the
counter, and when this quirk is applied, ignore the NRDY field.

This means accesses to this counter will always retry, even if the counter
was previously programmed to the same values.

The counter value is not expected to be stable, it drifts up and down with
each allocation and eviction. The CSU register provides the value for a
point in time.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since v3:
parentheses in macro
---
 Documentation/arch/arm64/silicon-errata.rst |  3 +++
 drivers/resctrl/mpam_devices.c              | 12 ++++++++++++
 drivers/resctrl/mpam_internal.h             |  6 ++++++
 3 files changed, 21 insertions(+)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index 1aa3326bb320..65ed6ea33751 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -214,6 +214,9 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | SI L1           | #4311569        | ARM64_ERRATUM_4311569       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | CMN-650         | #3642720        | N/A                         |
++----------------+-----------------+-----------------+-----------------------------+
++----------------+-----------------+-----------------+-----------------------------+
 | Broadcom       | Brahma-B53      | N/A             | ARM64_ERRATUM_845719        |
 +----------------+-----------------+-----------------+-----------------------------+
 | Broadcom       | Brahma-B53      | N/A             | ARM64_ERRATUM_843419        |
diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index 48a233875a9a..9182c8fcf003 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -691,6 +691,12 @@ static const struct mpam_quirk mpam_quirks[] = {
 	.iidr_mask  = MPAM_IIDR_MATCH_ONE,
 	.workaround = T241_MBW_COUNTER_SCALE_64,
 	},
+	{
+	/* ARM CMN-650 CSU erratum 3642720 */
+	.iidr       = MPAM_IIDR_ARM_CMN_650,
+	.iidr_mask  = MPAM_IIDR_MATCH_ONE,
+	.workaround = IGNORE_CSU_NRDY,
+	},
 	{ NULL } /* Sentinel */
 };
 
@@ -1003,6 +1009,7 @@ struct mon_read {
 	enum mpam_device_features	type;
 	u64				*val;
 	int				err;
+	bool				waited_timeout;
 };
 
 static bool mpam_ris_has_mbwu_long_counter(struct mpam_msc_ris *ris)
@@ -1249,6 +1256,10 @@ static void __ris_msmon_read(void *arg)
 		if (mpam_has_feature(mpam_feat_msmon_csu_hw_nrdy, rprops))
 			nrdy = now & MSMON___NRDY;
 		now = FIELD_GET(MSMON___VALUE, now);
+
+		if (mpam_has_quirk(IGNORE_CSU_NRDY, msc) && m->waited_timeout)
+			nrdy = false;
+
 		break;
 	case mpam_feat_msmon_mbwu_31counter:
 	case mpam_feat_msmon_mbwu_44counter:
@@ -1386,6 +1397,7 @@ int mpam_msmon_read(struct mpam_component *comp, struct mon_cfg *ctx,
 			.ctx = ctx,
 			.type = type,
 			.val = val,
+			.waited_timeout = true,
 		};
 		*val = 0;
 
diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index 1443a1dd996e..195ab821cc52 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -226,6 +226,7 @@ enum mpam_device_quirks {
 	T241_SCRUB_SHADOW_REGS,
 	T241_FORCE_MBW_MIN_TO_ONE,
 	T241_MBW_COUNTER_SCALE_64,
+	IGNORE_CSU_NRDY,
 	MPAM_QUIRK_LAST
 };
 
@@ -251,6 +252,11 @@ struct mpam_quirk {
 				 FIELD_PREP_CONST(MPAMF_IIDR_REVISION,    0)	 | \
 				 FIELD_PREP_CONST(MPAMF_IIDR_IMPLEMENTER, 0x36b))
 
+#define MPAM_IIDR_ARM_CMN_650	(FIELD_PREP_CONST(MPAMF_IIDR_PRODUCTID,   0)	 | \
+				 FIELD_PREP_CONST(MPAMF_IIDR_VARIANT,     0)	 | \
+				 FIELD_PREP_CONST(MPAMF_IIDR_REVISION,    0)	 | \
+				 FIELD_PREP_CONST(MPAMF_IIDR_IMPLEMENTER, 0x43b))
+
 /* The values for MSMON_CFG_MBWU_FLT.RWBW */
 enum mon_filter_options {
 	COUNT_BOTH	= 0,
-- 
2.43.0

