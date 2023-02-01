Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C89663CF
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:47 +0000 (UTC)
Received: by mail-wr1-f43.google.com with SMTP id h16so17197406wrz.12
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=clv1kjQYMOIGmkc19gGiQtQwx+05Y1V1yDDCTEN3thM=;
        b=CLUeoMhy8Ff6Zb3QVKckxMkU4tp+gjgH9dIriSPCjWx7b8/HC6texM6L85NpkwmD+3
         COxwiCwLz6Gjhfmt8p7Wl0vIm2fBDmSi7Xq1WqKOg4AmaJZjYCyY1Sp3be1PdWGjCfiW
         a6FaclkZvroZYhtj1e9XY1x0QgAE5qUvj5prV66bNQ5yq+3ost4pCO9BRm3iPQvteIkE
         isUcCqbrUJJl49Ea9ULETFKjLJs10f79Fi/i3W38C3aIJt71PYter0eM/6C9btCcxLxB
         HDbm3UcTQdnGyMu0ZzsV2MY9l9y2+dbFApMFpBBwaeX35qsANMEkkG4vD3YgPBAyVEog
         NK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=clv1kjQYMOIGmkc19gGiQtQwx+05Y1V1yDDCTEN3thM=;
        b=KZmsV/eD56X1FBLVBQ9FR1dsTEKn1+RPJUSkW7jglIFp5WIYjq8MNqoMk0CiFX0YQ5
         uXKSwdFeVe1z/eo73SpLRS1Xuda8XNiZy66qmIlqCE9Af+SnWScPB7DA8T8UG3QnfgEu
         oge1u7p9zitBjlVt4hUCSOxRS8pWx01m6XBkHkODPogSgaUixInFM31di8o7y68dKHY/
         P3BCyYoqrZwB/oii1YnOn/lYUQm/FLGBr7BSQ7qloRY+kkhQUiwCNf4j+5YAmEXBxdSp
         IsqaPiuqwnCnzqLToLJf3SOZXZ1z+cjym/3SdYk5ZkdxUmdx2u3ZhsqBNCp8aq2whpcp
         Wueg==
X-Gm-Message-State: AO0yUKXZN3m3aeDiNSphqWf0cjd3xRedlAWHrcVm3ALBnMNHquMt4KFl
	czdsAzH19z2bFohanTSF3eMj+Q==
X-Google-Smtp-Source: AK7set+U4b2LSdOZp2cey8ccJysEutazWdwuk3lUKTcC6aTJz06Hy8o5MzyXgXc7Yv1TSJPtIZmrwg==
X-Received: by 2002:a05:6000:1c12:b0:2bf:b710:c0b with SMTP id ba18-20020a0560001c1200b002bfb7100c0bmr3023896wrb.1.1675256385508;
        Wed, 01 Feb 2023 04:59:45 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:45 -0800 (PST)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	joro@8bytes.org
Cc: robin.murphy@arm.com,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	smostafa@google.com,
	dbrazdil@google.com,
	ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [RFC PATCH 33/45] iommu/arm-smmu-v3: Use single pages for level-2 stream tables
Date: Wed,  1 Feb 2023 12:53:17 +0000
Message-Id: <20230201125328.2186498-34-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230201125328.2186498-1-jean-philippe@linaro.org>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than using a fixed split point for the stream tables, base it on
the page size. It's easier for the KVM driver to pass single pages to
the hypervisor when lazily allocating stream tables.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/include/asm/arm-smmu-v3-regs.h     |  1 -
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  1 +
 .../arm/arm-smmu-v3/arm-smmu-v3-common.c      | 21 ++++++++++++-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 10 ++++-----
 4 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/arm-smmu-v3-regs.h b/arch/arm64/include/asm/arm-smmu-v3-regs.h
index 646a734f2554..357e52f4038f 100644
--- a/arch/arm64/include/asm/arm-smmu-v3-regs.h
+++ b/arch/arm64/include/asm/arm-smmu-v3-regs.h
@@ -168,7 +168,6 @@
  *       256 lazy entries per table (each table covers a PCI bus)
  */
 #define STRTAB_L1_SZ_SHIFT		20
-#define STRTAB_SPLIT			8
 
 #define STRTAB_L1_DESC_DWORDS		1
 #define STRTAB_L1_DESC_SPAN		GENMASK_ULL(4, 0)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 87034da361ca..3a4649f43839 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -163,6 +163,7 @@ struct arm_smmu_strtab_cfg {
 
 	u64				strtab_base;
 	u32				strtab_base_cfg;
+	u8				split;
 };
 
 /* An SMMUv3 instance */
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
index 7faf28c5a8b4..c44075015979 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
@@ -254,11 +254,14 @@ int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 	smmu->sid_bits = FIELD_GET(IDR1_SIDSIZE, reg);
 	smmu->iommu.max_pasids = 1UL << smmu->ssid_bits;
 
+	/* Use one page per level-2 table */
+	smmu->strtab_cfg.split = PAGE_SHIFT - (ilog2(STRTAB_STE_DWORDS) + 3);
+
 	/*
 	 * If the SMMU supports fewer bits than would fill a single L2 stream
 	 * table, use a linear table instead.
 	 */
-	if (smmu->sid_bits <= STRTAB_SPLIT)
+	if (smmu->sid_bits <= smmu->strtab_cfg.split)
 		smmu->features &= ~ARM_SMMU_FEAT_2_LVL_STRTAB;
 
 	/* IDR3 */
@@ -470,15 +473,17 @@ int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 	size_t size;
 	void *strtab;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
-	struct arm_smmu_strtab_l1_desc *desc = &cfg->l1_desc[sid >> STRTAB_SPLIT];
+	struct arm_smmu_strtab_l1_desc *desc =
+		&cfg->l1_desc[sid >> smmu->strtab_cfg.split];
 
 	if (desc->l2ptr)
 		return 0;
 
-	size = 1 << (STRTAB_SPLIT + ilog2(STRTAB_STE_DWORDS) + 3);
-	strtab = &cfg->strtab[(sid >> STRTAB_SPLIT) * STRTAB_L1_DESC_DWORDS];
+	size = 1 << (smmu->strtab_cfg.split + ilog2(STRTAB_STE_DWORDS) + 3);
+	strtab = &cfg->strtab[(sid >> smmu->strtab_cfg.split) *
+		 STRTAB_L1_DESC_DWORDS];
 
-	desc->span = STRTAB_SPLIT + 1;
+	desc->span = smmu->strtab_cfg.split + 1;
 	desc->l2ptr = dmam_alloc_coherent(smmu->dev, size, &desc->l2ptr_dma,
 					  GFP_KERNEL);
 	if (!desc->l2ptr) {
@@ -520,10 +525,10 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 
 	/* Calculate the L1 size, capped to the SIDSIZE. */
 	size = STRTAB_L1_SZ_SHIFT - (ilog2(STRTAB_L1_DESC_DWORDS) + 3);
-	size = min(size, smmu->sid_bits - STRTAB_SPLIT);
+	size = min(size, smmu->sid_bits - smmu->strtab_cfg.split);
 	cfg->num_l1_ents = 1 << size;
 
-	size += STRTAB_SPLIT;
+	size += smmu->strtab_cfg.split;
 	if (size < smmu->sid_bits)
 		dev_warn(smmu->dev,
 			 "2-level strtab only covers %u/%u bits of SID\n",
@@ -543,7 +548,7 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 	/* Configure strtab_base_cfg for 2 levels */
 	reg  = FIELD_PREP(STRTAB_BASE_CFG_FMT, STRTAB_BASE_CFG_FMT_2LVL);
 	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE, size);
-	reg |= FIELD_PREP(STRTAB_BASE_CFG_SPLIT, STRTAB_SPLIT);
+	reg |= FIELD_PREP(STRTAB_BASE_CFG_SPLIT, smmu->strtab_cfg.split);
 	cfg->strtab_base_cfg = reg;
 
 	return arm_smmu_init_l1_strtab(smmu);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a972c00700cc..19f170088268 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2156,9 +2156,9 @@ static __le64 *arm_smmu_get_step_for_sid(struct arm_smmu_device *smmu, u32 sid)
 		int idx;
 
 		/* Two-level walk */
-		idx = (sid >> STRTAB_SPLIT) * STRTAB_L1_DESC_DWORDS;
+		idx = (sid >> smmu->strtab_cfg.split) * STRTAB_L1_DESC_DWORDS;
 		l1_desc = &cfg->l1_desc[idx];
-		idx = (sid & ((1 << STRTAB_SPLIT) - 1)) * STRTAB_STE_DWORDS;
+		idx = (sid & ((1 << smmu->strtab_cfg.split) - 1)) * STRTAB_STE_DWORDS;
 		step = &l1_desc->l2ptr[idx];
 	} else {
 		/* Simple linear lookup */
@@ -2439,7 +2439,7 @@ static bool arm_smmu_sid_in_range(struct arm_smmu_device *smmu, u32 sid)
 	unsigned long limit = smmu->strtab_cfg.num_l1_ents;
 
 	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB)
-		limit *= 1UL << STRTAB_SPLIT;
+		limit *= 1UL << smmu->strtab_cfg.split;
 
 	return sid < limit;
 }
@@ -2460,8 +2460,8 @@ static int arm_smmu_init_sid_strtab(struct arm_smmu_device *smmu, u32 sid)
 		if (ret)
 			return ret;
 
-		desc = &smmu->strtab_cfg.l1_desc[sid >> STRTAB_SPLIT];
-		arm_smmu_init_bypass_stes(desc->l2ptr, 1 << STRTAB_SPLIT,
+		desc = &smmu->strtab_cfg.l1_desc[sid >> smmu->strtab_cfg.split];
+		arm_smmu_init_bypass_stes(desc->l2ptr, 1 << smmu->strtab_cfg.split,
 					  false);
 	}
 
-- 
2.39.0

