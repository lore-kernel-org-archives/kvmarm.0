Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60FF83B8955
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 14:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773413345; cv=none; b=cIj2bUutItdghnYGN+BKXPd+XExNcqKhJYpvuSz7PLB0X22qxa4CfTR6FF03o4KuVWJWmNZ9HDodt24A/oQR1G2eDcGYK5soTF0BwOAux0JkAqIqkTFAQnXXhQICxeFy+AD5EUt4EtJURkythhNuCMyMArQ/FgluRKvy/W7KWYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773413345; c=relaxed/simple;
	bh=NT+5KqoZ6q1XWC8P/kZeuPsxsgNBzX6bXqhrvHA1JqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNjJ1xI0WTWz7bZU60hRuc9QHvGI0LUfRYVYB0fO7qiv/JfdT4MOQtxEq4NQDz1Lw8J6jKJLZGsRrQdXh2TN2kE6DGKK2qnUW5S8DVbC8ThJWXG2I/oRyVG0fh5fMYaapFnYvGyr0aAvAOD1gM8uZXi6EFK/ffAlNPPUabaQW1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A1AE42574;
	Fri, 13 Mar 2026 07:48:57 -0700 (PDT)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D54163F7BD;
	Fri, 13 Mar 2026 07:48:59 -0700 (PDT)
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
Subject: [PATCH v6 36/40] arm_mpam: Add workaround for T241-MPAM-1
Date: Fri, 13 Mar 2026 14:46:13 +0000
Message-ID: <20260313144617.3420416-37-ben.horgan@arm.com>
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

From: Shanker Donthineni <sdonthineni@nvidia.com>

The MPAM bandwidth partitioning controls will not be correctly configured,
and hardware will retain default configuration register values, meaning
generally that bandwidth will remain unprovisioned.

To address the issue, follow the below steps after updating the MBW_MIN
and/or MBW_MAX registers.

 - Perform 64b reads from all 12 bridge MPAM shadow registers at offsets
   (0x360048 + slice*0x10000 + partid*8). These registers are read-only.
 - Continue iterating until all 12 shadow register values match in a loop.
   pr_warn_once if the values fail to match within the loop count 1000.
 - Perform 64b writes with the value 0x0 to the two spare registers at
   offsets 0x1b0000 and 0x1c0000.

In the hardware, writes to the MPAMCFG_MBW_MAX MPAMCFG_MBW_MIN registers
are transformed into broadcast writes to the 12 shadow registers. The
final two writes to the spare registers cause a final rank of downstream
micro-architectural MPAM registers to be updated from the shadow copies.
The intervening loop to read the 12 shadow registers helps avoid a race
condition where writes to the spare registers occur before all shadow
registers have been updated.

Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---

Changes from James:
  Merged the min/max update into a single
  mpam_quirk_post_config_change() helper. Stashed the t241_id in the msc
  instead of carrying the physical address around. Test the msc quirk bit
  instead of a static key.

Changes since rfc:
MPAM_IIDR_NVIDIA_T421 -> MPAM_IIDR_NVIDIA_T241
return err from init
Be specific about the errata in the init name,
  mpam_enable_quirk_nvidia_t241 -> mpam_enable_quirk_nvidia_t241_1

Changes since v3:
parentheses
---
 Documentation/arch/arm64/silicon-errata.rst |  2 +
 drivers/resctrl/mpam_devices.c              | 88 +++++++++++++++++++++
 drivers/resctrl/mpam_internal.h             |  9 +++
 3 files changed, 99 insertions(+)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index 4c300caad901..a65620f98e3a 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -247,6 +247,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | NVIDIA         | T241 GICv3/4.x  | T241-FABRIC-4   | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
+| NVIDIA         | T241 MPAM       | T241-MPAM-1     | N/A                         |
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | Freescale/NXP  | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585         |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index e66631f3f732..b1753498f07f 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -29,6 +29,16 @@
 
 #include "mpam_internal.h"
 
+/* Values for the T241 errata workaround */
+#define T241_CHIPS_MAX			4
+#define T241_CHIP_NSLICES		12
+#define T241_SPARE_REG0_OFF		0x1b0000
+#define T241_SPARE_REG1_OFF		0x1c0000
+#define T241_CHIP_ID(phys)		FIELD_GET(GENMASK_ULL(44, 43), phys)
+#define T241_SHADOW_REG_OFF(sidx, pid)	(0x360048 + (sidx) * 0x10000 + (pid) * 8)
+#define SMCCC_SOC_ID_T241		0x036b0241
+static void __iomem *t241_scratch_regs[T241_CHIPS_MAX];
+
 /*
  * mpam_list_lock protects the SRCU lists when writing. Once the
  * mpam_enabled key is enabled these lists are read-only,
@@ -630,7 +640,45 @@ static struct mpam_msc_ris *mpam_get_or_create_ris(struct mpam_msc *msc,
 	return ERR_PTR(-ENOENT);
 }
 
+static int mpam_enable_quirk_nvidia_t241_1(struct mpam_msc *msc,
+					   const struct mpam_quirk *quirk)
+{
+	s32 soc_id = arm_smccc_get_soc_id_version();
+	struct resource *r;
+	phys_addr_t phys;
+
+	/*
+	 * A mapping to a device other than the MSC is needed, check
+	 * SOC_ID is  NVIDIA T241 chip (036b:0241)
+	 */
+	if (soc_id < 0 || soc_id != SMCCC_SOC_ID_T241)
+		return -EINVAL;
+
+	r = platform_get_resource(msc->pdev, IORESOURCE_MEM, 0);
+	if (!r)
+		return -EINVAL;
+
+	/* Find the internal registers base addr from the CHIP ID */
+	msc->t241_id = T241_CHIP_ID(r->start);
+	phys = FIELD_PREP(GENMASK_ULL(45, 44), msc->t241_id) | 0x19000000ULL;
+
+	t241_scratch_regs[msc->t241_id] = ioremap(phys, SZ_8M);
+	if (WARN_ON_ONCE(!t241_scratch_regs[msc->t241_id]))
+		return -EINVAL;
+
+	pr_info_once("Enabled workaround for NVIDIA T241 erratum T241-MPAM-1\n");
+
+	return 0;
+}
+
 static const struct mpam_quirk mpam_quirks[] = {
+	{
+	/* NVIDIA t241 erratum T241-MPAM-1 */
+	.init       = mpam_enable_quirk_nvidia_t241_1,
+	.iidr       = MPAM_IIDR_NVIDIA_T241,
+	.iidr_mask  = MPAM_IIDR_MATCH_ONE,
+	.workaround = T241_SCRUB_SHADOW_REGS,
+	},
 	{ NULL } /* Sentinel */
 };
 
@@ -1378,6 +1426,44 @@ static void mpam_reset_msc_bitmap(struct mpam_msc *msc, u16 reg, u16 wd)
 	__mpam_write_reg(msc, reg, bm);
 }
 
+static void mpam_apply_t241_erratum(struct mpam_msc_ris *ris, u16 partid)
+{
+	int sidx, i, lcount = 1000;
+	void __iomem *regs;
+	u64 val0, val;
+
+	regs = t241_scratch_regs[ris->vmsc->msc->t241_id];
+
+	for (i = 0; i < lcount; i++) {
+		/* Read the shadow register at index 0 */
+		val0 = readq_relaxed(regs + T241_SHADOW_REG_OFF(0, partid));
+
+		/* Check if all the shadow registers have the same value */
+		for (sidx = 1; sidx < T241_CHIP_NSLICES; sidx++) {
+			val = readq_relaxed(regs +
+					    T241_SHADOW_REG_OFF(sidx, partid));
+			if (val != val0)
+				break;
+		}
+		if (sidx == T241_CHIP_NSLICES)
+			break;
+	}
+
+	if (i == lcount)
+		pr_warn_once("t241: inconsistent values in shadow regs");
+
+	/* Write a value zero to spare registers to take effect of MBW conf */
+	writeq_relaxed(0, regs + T241_SPARE_REG0_OFF);
+	writeq_relaxed(0, regs + T241_SPARE_REG1_OFF);
+}
+
+static void mpam_quirk_post_config_change(struct mpam_msc_ris *ris, u16 partid,
+					  struct mpam_config *cfg)
+{
+	if (mpam_has_quirk(T241_SCRUB_SHADOW_REGS, ris->vmsc->msc))
+		mpam_apply_t241_erratum(ris, partid);
+}
+
 /* Called via IPI. Call while holding an SRCU reference */
 static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
 				      struct mpam_config *cfg)
@@ -1457,6 +1543,8 @@ static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
 		mpam_write_partsel_reg(msc, PRI, pri_val);
 	}
 
+	mpam_quirk_post_config_change(ris, partid, cfg);
+
 	mutex_unlock(&msc->part_sel_lock);
 }
 
diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index e28a168419d4..e38954a735d8 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -130,6 +130,9 @@ struct mpam_msc {
 	void __iomem		*mapped_hwpage;
 	size_t			mapped_hwpage_sz;
 
+	/* Values only used on some platforms for quirks */
+	u32			t241_id;
+
 	struct mpam_garbage	garbage;
 };
 
@@ -220,6 +223,7 @@ struct mpam_props {
 
 /* Workaround bits for msc->quirks */
 enum mpam_device_quirks {
+	T241_SCRUB_SHADOW_REGS,
 	MPAM_QUIRK_LAST
 };
 
@@ -240,6 +244,11 @@ struct mpam_quirk {
 				 FIELD_PREP_CONST(MPAMF_IIDR_REVISION,    0xf)	 | \
 				 FIELD_PREP_CONST(MPAMF_IIDR_IMPLEMENTER, 0xfff))
 
+#define MPAM_IIDR_NVIDIA_T241	(FIELD_PREP_CONST(MPAMF_IIDR_PRODUCTID,   0x241) | \
+				 FIELD_PREP_CONST(MPAMF_IIDR_VARIANT,     0)	 | \
+				 FIELD_PREP_CONST(MPAMF_IIDR_REVISION,    0)	 | \
+				 FIELD_PREP_CONST(MPAMF_IIDR_IMPLEMENTER, 0x36b))
+
 /* The values for MSMON_CFG_MBWU_FLT.RWBW */
 enum mon_filter_options {
 	COUNT_BOTH	= 0,
-- 
2.43.0

