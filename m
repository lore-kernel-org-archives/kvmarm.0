Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBAC7B3C8;
	Thu,  8 Feb 2024 15:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707405706; cv=none; b=QsDnMDMvfAtw9eUgWwt1yzVnowuk4Sniw0cpIIBX/V3M5JxmAiwwc1Gzgt6NYUOrY24qtV0t4WjGW4vzvEEwNdQuxXNlg2KwpiUpIr/A2UjAh5OeWstj6Fq1aB08zAJ+r3veyBxTgiR61Wpoub3wgnQpKDYPOF0JmYcQFJSUFQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707405706; c=relaxed/simple;
	bh=c9cOy1QOCcN4WkA5yoE803R26vumPvxH5RTGvesQXOM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yt1Hcbg5TjO02Wl2A9HZehmo+yHlJclrrTCOidpdKKWmYXyj+CqpM1SAIYwMg9taVuhgOWXBw8oKUPme7P/dTkHy5bB+ZFRPbvf8rMrdE2BTFo2GRiS/zCovKdmy1m2KH/93jhxyaWyCEJPYQHR8r0tTsipG5Xqka2qHUqQLJ74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TW0wm2BnTz687wh;
	Thu,  8 Feb 2024 23:18:00 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 25543140B73;
	Thu,  8 Feb 2024 23:21:43 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.202.227.28) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 8 Feb 2024 15:21:36 +0000
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
CC: <kevin.tian@intel.com>, <jgg@ziepe.ca>, <alex.williamson@redhat.com>,
	<maz@kernel.org>, <oliver.upton@linux.dev>, <will@kernel.org>,
	<robin.murphy@arm.com>, <jean-philippe@linaro.org>,
	<jonathan.cameron@huawei.com>
Subject: [RFC PATCH v2 7/7] iommu/arm-smmu-v3: Enable broadcast TLB maintenance
Date: Thu, 8 Feb 2024 15:18:37 +0000
Message-ID: <20240208151837.35068-8-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

The SMMUv3 can handle invalidation targeted at TLB entries with shared
ASIDs. If the implementation supports broadcast TLB maintenance, enable it
and keep track of it in a feature bit. The SMMU will then be affected by
inner-shareable TLB invalidations from other agents.

In order to avoid over invalidation with stage-2 translation contexts,
enable BTM only when SMMUv3 supports eiher S1 or both S1 & S2 transaltion
contexts. In this way the default domain will use stage-1 and stage 2 will
be only used for NESTED Domain setup.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
[Shameer: Enable BTM only if S1 is supported]
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 23 +++++++++++++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 +
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 18e3e04b50f4..f40912de9e9f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -4060,11 +4060,14 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu, bool bypass)
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
@@ -4209,6 +4212,7 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 {
 	u32 reg;
 	bool coherent = smmu->features & ARM_SMMU_FEAT_COHERENCY;
+	bool vhe = cpus_have_cap(ARM64_HAS_VIRT_HOST_EXTN);
 
 	/* IDR0 */
 	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR0);
@@ -4261,7 +4265,7 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 
 	if (reg & IDR0_HYP) {
 		smmu->features |= ARM_SMMU_FEAT_HYP;
-		if (cpus_have_cap(ARM64_HAS_VIRT_HOST_EXTN))
+		if (vhe)
 			smmu->features |= ARM_SMMU_FEAT_E2H;
 	}
 
@@ -4286,6 +4290,21 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 
 	if (reg & IDR0_S2P)
 		smmu->features |= ARM_SMMU_FEAT_TRANS_S2;
+	/*
+	 * If S1 is supported, check we can enable BTM. This means if S2 is available,
+	 * we will use S2 for nested domain only with a KVM VMID. BTM is useful when
+	 * CPU shares the page tables with SMMUv3(eg: vSVA)
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
index 7d732ea2a6ee..ff3de784d1be 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -33,6 +33,7 @@
 #define IDR0_ASID16			(1 << 12)
 #define IDR0_ATS			(1 << 10)
 #define IDR0_HYP			(1 << 9)
+#define IDR0_BTM			(1 << 5)
 #define IDR0_COHACC			(1 << 4)
 #define IDR0_TTF			GENMASK(3, 2)
 #define IDR0_TTF_AARCH64		2
-- 
2.34.1

