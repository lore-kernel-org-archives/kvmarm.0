Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 008B137FF74
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 17:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768237451; cv=none; b=DNl98sBogtiGRUJPAs2cSr0T8/EmxsP9OHHG4/xIC0C/z3Rtr27nrSD6XSG/laubDlf7JflvHeC7r8qGiiZh5v2nvtPBzCIGf5kIaJJc7qfn1NK0ZpkBSB2oMDXJq9IKEaIXWg0eQuaFMu4mSWsrXrk0la4lWzhmAggxwZGmcrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768237451; c=relaxed/simple;
	bh=niCY8UqUPvCP4ZW0Td5Kbxz205BplHVuF0Sdaz46nKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHIppMsr6qLuGtVcCRi2sRLiLUnH4VOeT92mexgEMnZ0EA01tsohPXpl7BBYuvhLQ0taURAlSw0I0XZFm3Wl/hcYNs9GaWtrzWEBnENXNdLe5vVx1mbi/dkqpVot3mxd0qLHWleJhx+hTUO41u7PhIZb4ZqCrtBS9gEjrwC2qdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2726D153B;
	Mon, 12 Jan 2026 09:04:01 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BCCB53F694;
	Mon, 12 Jan 2026 09:04:02 -0800 (PST)
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
Subject: [PATCH v3 47/47] arm_mpam: Quirk CMN-650's CSU NRDY behaviour
Date: Mon, 12 Jan 2026 16:59:14 +0000
Message-ID: <20260112165914.4086692-48-ben.horgan@arm.com>
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
 Documentation/arch/arm64/silicon-errata.rst |  3 +++
 drivers/resctrl/mpam_devices.c              | 12 ++++++++++++
 drivers/resctrl/mpam_internal.h             |  6 ++++++
 3 files changed, 21 insertions(+)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index e810b2a8f40e..3667650036fb 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -213,6 +213,9 @@ stable kernels.
 | ARM            | GIC-700         | #2941627        | ARM64_ERRATUM_2941627       |
 +----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | CMN-650         | #3642720        | N/A                         |
++----------------+-----------------+-----------------+-----------------------------+
++----------------+-----------------+-----------------+-----------------------------+
 | Broadcom       | Brahma-B53      | N/A             | ARM64_ERRATUM_845719        |
 +----------------+-----------------+-----------------+-----------------------------+
 | Broadcom       | Brahma-B53      | N/A             | ARM64_ERRATUM_843419        |
diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index 7409cb7edab4..e6c9ddaa60e2 100644
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
index 1680d1036472..0bd323728b53 100644
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
 				FIELD_PREP_CONST(MPAMF_IIDR_REVISION,    0)	| \
 				FIELD_PREP_CONST(MPAMF_IIDR_IMPLEMENTER, 0x36b)
 
+#define MPAM_IIDR_ARM_CMN_650	FIELD_PREP_CONST(MPAMF_IIDR_PRODUCTID,   0)	| \
+				FIELD_PREP_CONST(MPAMF_IIDR_VARIANT,     0)	| \
+				FIELD_PREP_CONST(MPAMF_IIDR_REVISION,    0)	| \
+				FIELD_PREP_CONST(MPAMF_IIDR_IMPLEMENTER, 0x43b)
+
 /* The values for MSMON_CFG_MBWU_FLT.RWBW */
 enum mon_filter_options {
 	COUNT_BOTH	= 0,
-- 
2.43.0

