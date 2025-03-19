Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4086D1E2843;
	Wed, 19 Mar 2025 17:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742405613; cv=none; b=HIm25DmN9gs9Eh/FLFN7ryvJbWCXMWy4Snpvi3PqWYpqcoZ6x5ZHRx3bg7qb4nfiY1krk42FeBBFWqLj9ApN/bUTwjCbMmWWxNdZd2nlMmxGXN4GB3vr6KZHoxXI8ob4wrbdagf6yA/2vZ4KWiOW2IQfm9ZlvK1x6mrIM3G0E/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742405613; c=relaxed/simple;
	bh=l6ySbUYgPrssiksQ+srnwjLdqRgcLvohmfBc1g25Qmg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b74jZ1lXYx6vJNEynSHq1JDq8P417gSXbRfg8/EulyKEoJ7lWm3qcAGx26fHn66Gvo7X7CkH4U0rGAhRw9JsdRjtNtat6XvGMW/LmI0nCoU1qwAZKOCHC+o88UgyaatDtKzsz8yMKDiNWH5e+D7BOoERshNo0K92F2ctZDSch6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZHwhp0BxTz6K9Rq;
	Thu, 20 Mar 2025 01:30:34 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id A323914050C;
	Thu, 20 Mar 2025 01:33:29 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 19 Mar 2025 18:33:22 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>
CC: <linuxarm@huawei.com>, <kevin.tian@intel.com>, <jgg@ziepe.ca>,
	<alex.williamson@redhat.com>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<will@kernel.org>, <robin.murphy@arm.com>, <nicolinc@nvidia.com>,
	<jean-philippe@linaro.org>, <jonathan.cameron@huawei.com>
Subject: [RFC PATCH v3 5/5] iommu/arm-smmu-v3: Enable broadcast TLB maintenance
Date: Wed, 19 Mar 2025 17:32:02 +0000
Message-ID: <20250319173202.78988-6-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20250319173202.78988-1-shameerali.kolothum.thodi@huawei.com>
References: <20250319173202.78988-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 frapeml500008.china.huawei.com (7.182.85.71)

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

The SMMUv3 can handle invalidation targeted at TLB entries with shared
ASIDs. If the implementation supports broadcast TLB maintenance, enable it
and keep track of it in a feature bit. The SMMU will then be affected by
inner-shareable TLB invalidations from other agents.

In order to avoid over invalidation with stage-2 translation contexts,
enable BTM only when SMMUv3 supports eiher S1 or both S1 & S2 transaltion
contexts. In this way the default domain will use stage-1 and stage-2 will
be only used for NESTED Domain setup.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
[Shameer: Enable BTM only if S1 is supported]
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 24 +++++++++++++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 +
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index addc6308742b..06a13d78286a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -4119,11 +4119,14 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu)
 	writel_relaxed(reg, smmu->base + ARM_SMMU_CR1);
 
 	/* CR2 (random crap) */
-	reg = CR2_PTM | CR2_RECINVSID;
+	reg = CR2_RECINVSID;
 
 	if (smmu->features & ARM_SMMU_FEAT_E2H)
 		reg |= CR2_E2H;
 
+	if (!(smmu->features & ARM_SMMU_FEAT_BTM))
+		reg |= CR2_PTM;
+
 	writel_relaxed(reg, smmu->base + ARM_SMMU_CR2);
 
 	/* Stream table */
@@ -4289,6 +4292,7 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 {
 	u32 reg;
 	bool coherent = smmu->features & ARM_SMMU_FEAT_COHERENCY;
+	bool vhe = cpus_have_cap(ARM64_HAS_VIRT_HOST_EXTN);
 
 	/* IDR0 */
 	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR0);
@@ -4341,7 +4345,7 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 
 	if (reg & IDR0_HYP) {
 		smmu->features |= ARM_SMMU_FEAT_HYP;
-		if (cpus_have_cap(ARM64_HAS_VIRT_HOST_EXTN))
+		if (vhe)
 			smmu->features |= ARM_SMMU_FEAT_E2H;
 	}
 
@@ -4368,6 +4372,22 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 
 	if (reg & IDR0_S2P)
 		smmu->features |= ARM_SMMU_FEAT_TRANS_S2;
+	/*
+	 * If S1 is supported, verify that BTM can be enabled.  If S2 is available
+	 * and BTM is enabled, S2 will be used exclusively for nested domains,
+	 * ensuring a KVM VMID is obtained.
+	 * BTM is beneficial when the CPU shares page tables with SMMUv3 (e.g., vSVA).
+	 */
+	if (reg & IDR0_S1P) {
+		/*
+		 * If the CPU is using VHE, but the SMMU doesn't support it, the SMMU
+		 * will create TLB entries for NH-EL1 world and will miss the
+		 * broadcasted TLB invalidations that target EL2-E2H world. Don't enable
+		 * BTM in that case.
+		 */
+		if (reg & IDR0_BTM && (!vhe || reg & IDR0_HYP))
+			smmu->features |= ARM_SMMU_FEAT_BTM;
+	}
 
 	if (!(reg & (IDR0_S1P | IDR0_S2P))) {
 		dev_err(smmu->dev, "no translation support!\n");
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 5890c233f73b..f554b6aa52c9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -39,6 +39,7 @@ struct arm_smmu_device;
 #define IDR0_HTTU			GENMASK(7, 6)
 #define IDR0_HTTU_ACCESS		1
 #define IDR0_HTTU_ACCESS_DIRTY		2
+#define IDR0_BTM			(1 << 5)
 #define IDR0_COHACC			(1 << 4)
 #define IDR0_TTF			GENMASK(3, 2)
 #define IDR0_TTF_AARCH64		2
-- 
2.47.0

