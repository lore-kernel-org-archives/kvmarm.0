Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4179226547
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026702; cv=none; b=OOmAsoESjJjA1VVzQ8MkBbMzPvM9pM3Cj6tK6PcxFlaZqGgvkz1EsyBqZLZ0jMFwsn+AoRzTUKH3zvw/ToKP60m5xoKUXoQRpdZMe956sTvMMZdvJ83B7e7YbNHbJLne8zv59wY6wMv64R9VyuieAoGaddEGw1dm6/xV+mIxLGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026702; c=relaxed/simple;
	bh=le7i/soK4DQQ5NkX9KBnGksEHZPwTBz9+TNbPWtJ+9s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=vE6UkQiLZewIcLfhTDL6apdQaMuM+Alhw7DjHOTVQduBek+VhBuZAcbjXmrUNyQTs1GoKSg/Cqpt1NPHHs3AdNYTPzD9LWYcDaTwpHq+ty6Efu40qcGTleyk7mBloiu/HlEvZWPxAU+dFVFAMPtd5OqYRkhztCp56rLX3oxRfUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nhUW44xj; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nhUW44xj"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4359206e1e4so9228555e9.2
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026698; x=1734631498; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ye5CEuq9/eypErcJdDhnDz6lI+zHnp9kWjOABwgLrkM=;
        b=nhUW44xjjzNFAoBkJtzy2KNUBheP5Iu92MS16hMYVu0kc1h0wI7OgCsa2bdOcv0opY
         CMGzDIThF3URzhpNWkw86Z6tnh7T9gRVVQxxClgHBShbWlFwx37ZoqgOTu6AookhZG1y
         W4FA/1n3ofctBc/YBHM+mDxcEvjo5BJReG6nabxbeR0oONs5D4M4ZvFQa2OludUC1UUn
         fmgGywp/6CHuwOpUUmRyZOzecJZA6lrt9wsF0Ly6Yc//k2WbKKTdK652GOjc41kmpexa
         nvJqhHwvEM1ZWMmjlNq4/0qMKey70K8rGydwktXQRKDTjmcITrqSWmik8wgNpBzPYhdc
         aIcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026698; x=1734631498;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ye5CEuq9/eypErcJdDhnDz6lI+zHnp9kWjOABwgLrkM=;
        b=hQEY4y0YXG6DRgUab0Ee9RUbXE/rrVeMP13s70jyRnyJPTK1zRK2bq2M9jdWckepmx
         0tnWSa6pGpD33IxHCTh89w+I1L/ohpyE6/Z+AOJiJVC20LMPCc1BPS3j16/HvOA55Jve
         Y4jAu7YczGt6vTbv2xmrug6bFKj4re6o+rsepY39jxmiYr45tqftVDEuWSZ7J+BElaG6
         FRVhA1reNrbVc/iii8mbGrioHCKsZ4ZD9M9wVjs0OSlWQNwuypirHawzhPeg/3GziT4d
         K1dg13X3YHf4Jn6CV+M9QLZ70s2klD7zfqzkLtX9L46tT/kFxSwMejAdg/PPlt8KXap3
         suYg==
X-Forwarded-Encrypted: i=1; AJvYcCVhp61bVHiOfE5/Lz278TT+WQkBQrBc0jg/To5sbSienIbsH6JqXFPC3kCpoT7w/3tXm9/mfGk=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywz4FELLk0y58BGIUmQa98z8G8Tvciz4vTyj34e6XEqoIeVDSaZ
	3iCL2cL+7keFs48VWgAmeWlYU0I25jfjAH/+Apd/lPD7VIVJ0cEaHJaHV46/I9BI1JC5QLziSLs
	YG+JMSpKBTg==
X-Google-Smtp-Source: AGHT+IFrguWHfxaIWvgSDnKr1rrer8q0SLDpAYq1h124COJGgdteOxwFwyjctHkLBQwo0g3Wxv5rMcZMm3pJsA==
X-Received: from wmnm21.prod.google.com ([2002:a05:600c:1615:b0:436:1923:6cf5])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a55:b0:431:4f29:9539 with SMTP id 5b1f17b1804b1-4361c43dbefmr64106285e9.32.1734026698221;
 Thu, 12 Dec 2024 10:04:58 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:31 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-8-smostafa@google.com>
Subject: [RFC PATCH v2 07/58] iommu/arm-smmu-v3: Move queue and table
 allocation to arm-smmu-v3-common.c
From: Mostafa Saleh <smostafa@google.com>
To: iommu@lists.linux.dev, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org, 
	robin.murphy@arm.com, jean-philippe@linaro.org, jgg@ziepe.ca, 
	nicolinc@nvidia.com, vdonnefort@google.com, qperret@google.com, 
	tabba@google.com, danielmentz@google.com, tzukui@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

Move more code to arm-smmu-v3-common.c, so that the KVM driver can reuse
it.

Also, make sure that that allocated memory is aligned as it its going
to protected by the hypervisor stage-2.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/include/asm/arm-smmu-v3-common.h   |  29 ++++
 .../arm/arm-smmu-v3/arm-smmu-v3-common.c      | 136 ++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 151 +-----------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  26 ++-
 4 files changed, 179 insertions(+), 163 deletions(-)

diff --git a/arch/arm64/include/asm/arm-smmu-v3-common.h b/arch/arm64/include/asm/arm-smmu-v3-common.h
index e6e339248816..f2fbd286f674 100644
--- a/arch/arm64/include/asm/arm-smmu-v3-common.h
+++ b/arch/arm64/include/asm/arm-smmu-v3-common.h
@@ -3,6 +3,7 @@
 #define _ARM_SMMU_V3_COMMON_H
 
 #include <linux/bitfield.h>
+#include <linux/bits.h>
 
 /* MMIO registers */
 #define ARM_SMMU_IDR0			0x0
@@ -198,6 +199,22 @@ struct arm_smmu_strtab_l1 {
 };
 #define STRTAB_MAX_L1_ENTRIES		(1 << 17)
 
+struct arm_smmu_strtab_cfg {
+	union {
+		struct {
+			struct arm_smmu_ste *table;
+			dma_addr_t ste_dma;
+			unsigned int num_ents;
+		} linear;
+		struct {
+			struct arm_smmu_strtab_l1 *l1tab;
+			struct arm_smmu_strtab_l2 **l2ptrs;
+			dma_addr_t l1_dma;
+			unsigned int num_l1_ents;
+		} l2;
+	};
+};
+
 static inline u32 arm_smmu_strtab_l1_idx(u32 sid)
 {
 	return sid / STRTAB_NUM_L2_STES;
@@ -208,6 +225,18 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
 	return sid % STRTAB_NUM_L2_STES;
 }
 
+static inline void arm_smmu_write_strtab_l1_desc(struct arm_smmu_strtab_l1 *dst,
+						 dma_addr_t l2ptr_dma)
+{
+	u64 val = 0;
+
+	val |= FIELD_PREP(STRTAB_L1_DESC_SPAN, STRTAB_SPLIT + 1);
+	val |= l2ptr_dma & STRTAB_L1_DESC_L2PTR_MASK;
+
+	/* The HW has 64 bit atomicity with stores to the L2 STE table */
+	WRITE_ONCE(dst->l2ptr, cpu_to_le64(val));
+}
+
 #define STRTAB_STE_0_V			(1UL << 0)
 #define STRTAB_STE_0_CFG		GENMASK_ULL(3, 1)
 #define STRTAB_STE_0_CFG_ABORT		0
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
index cfd5ba69e67e..80ac13b0dc06 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
@@ -348,6 +348,7 @@ int arm_smmu_of_xlate(struct device *dev, const struct of_phandle_args *args)
 	return iommu_fwspec_add_ids(dev, args->args, 1);
 }
 
+
 void arm_smmu_get_resv_regions(struct device *dev,
 			       struct list_head *head)
 {
@@ -363,3 +364,138 @@ void arm_smmu_get_resv_regions(struct device *dev,
 
 	iommu_dma_get_resv_regions(dev, head);
 }
+
+int arm_smmu_init_one_queue(struct arm_smmu_device *smmu,
+			    struct arm_smmu_queue *q, void __iomem *page,
+			    unsigned long prod_off, unsigned long cons_off,
+			    size_t dwords, const char *name)
+{
+	size_t qsz;
+
+	do {
+		qsz = ((1 << q->llq.max_n_shift) * dwords) << 3;
+		q->base = dmam_alloc_coherent(smmu->dev, PAGE_ALIGN(qsz), &q->base_dma,
+					      GFP_KERNEL);
+		if (q->base || qsz < PAGE_SIZE)
+			break;
+
+		q->llq.max_n_shift--;
+	} while (1);
+
+	if (!q->base) {
+		dev_err(smmu->dev,
+			"failed to allocate queue (0x%zx bytes) for %s\n",
+			qsz, name);
+		return -ENOMEM;
+	}
+
+	if (!WARN_ON(q->base_dma & (qsz - 1))) {
+		dev_info(smmu->dev, "allocated %u entries for %s\n",
+			 1 << q->llq.max_n_shift, name);
+	}
+
+	q->prod_reg	= page + prod_off;
+	q->cons_reg	= page + cons_off;
+	q->ent_dwords	= dwords;
+
+	q->q_base  = Q_BASE_RWA;
+	q->q_base |= q->base_dma & Q_BASE_ADDR_MASK;
+	q->q_base |= FIELD_PREP(Q_BASE_LOG2SIZE, q->llq.max_n_shift);
+
+	q->llq.prod = q->llq.cons = 0;
+	return 0;
+}
+
+/* Stream table initialization functions */
+static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
+{
+	u32 l1size;
+	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
+	unsigned int last_sid_idx =
+		arm_smmu_strtab_l1_idx((1 << smmu->sid_bits) - 1);
+
+	/* Calculate the L1 size, capped to the SIDSIZE. */
+	cfg->l2.num_l1_ents = min(last_sid_idx + 1, STRTAB_MAX_L1_ENTRIES);
+	if (cfg->l2.num_l1_ents <= last_sid_idx)
+		dev_warn(smmu->dev,
+			 "2-level strtab only covers %u/%u bits of SID\n",
+			 ilog2(cfg->l2.num_l1_ents * STRTAB_NUM_L2_STES),
+			 smmu->sid_bits);
+
+	l1size = cfg->l2.num_l1_ents * sizeof(struct arm_smmu_strtab_l1);
+	cfg->l2.l1tab = dmam_alloc_coherent(smmu->dev, PAGE_ALIGN(l1size), &cfg->l2.l1_dma,
+					    GFP_KERNEL);
+	if (!cfg->l2.l1tab) {
+		dev_err(smmu->dev,
+			"failed to allocate l1 stream table (%u bytes)\n",
+			l1size);
+		return -ENOMEM;
+	}
+
+	cfg->l2.l2ptrs = devm_kcalloc(smmu->dev, cfg->l2.num_l1_ents,
+				      sizeof(*cfg->l2.l2ptrs), GFP_KERNEL);
+	if (!cfg->l2.l2ptrs)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
+{
+	u32 size;
+	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
+
+	size = (1 << smmu->sid_bits) * sizeof(struct arm_smmu_ste);
+	cfg->linear.table = dmam_alloc_coherent(smmu->dev, PAGE_ALIGN(size),
+						&cfg->linear.ste_dma,
+						GFP_KERNEL);
+	if (!cfg->linear.table) {
+		dev_err(smmu->dev,
+			"failed to allocate linear stream table (%u bytes)\n",
+			size);
+		return -ENOMEM;
+	}
+	cfg->linear.num_ents = 1 << smmu->sid_bits;
+
+	return 0;
+}
+
+int arm_smmu_init_strtab(struct arm_smmu_device *smmu)
+{
+	int ret;
+
+	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB)
+		ret = arm_smmu_init_strtab_2lvl(smmu);
+	else
+		ret = arm_smmu_init_strtab_linear(smmu);
+	if (ret)
+		return ret;
+
+	ida_init(&smmu->vmid_map);
+
+	return 0;
+}
+
+void arm_smmu_write_strtab(struct arm_smmu_device *smmu)
+{
+	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
+	dma_addr_t dma;
+	u32 reg;
+
+	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
+		reg = FIELD_PREP(STRTAB_BASE_CFG_FMT,
+				 STRTAB_BASE_CFG_FMT_2LVL) |
+		      FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE,
+				 ilog2(cfg->l2.num_l1_ents) + STRTAB_SPLIT) |
+		      FIELD_PREP(STRTAB_BASE_CFG_SPLIT, STRTAB_SPLIT);
+		dma = cfg->l2.l1_dma;
+	} else {
+		reg = FIELD_PREP(STRTAB_BASE_CFG_FMT,
+				 STRTAB_BASE_CFG_FMT_LINEAR) |
+		      FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE, smmu->sid_bits);
+		dma = cfg->linear.ste_dma;
+	}
+	writeq_relaxed((dma & STRTAB_BASE_ADDR_MASK) | STRTAB_BASE_RA,
+		       smmu->base + ARM_SMMU_STRTAB_BASE);
+	writel_relaxed(reg, smmu->base + ARM_SMMU_STRTAB_BASE_CFG);
+}
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 8741b8f57a8d..cfee7f9b5afc 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1483,18 +1483,6 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
 }
 
 /* Stream table manipulation functions */
-static void arm_smmu_write_strtab_l1_desc(struct arm_smmu_strtab_l1 *dst,
-					  dma_addr_t l2ptr_dma)
-{
-	u64 val = 0;
-
-	val |= FIELD_PREP(STRTAB_L1_DESC_SPAN, STRTAB_SPLIT + 1);
-	val |= l2ptr_dma & STRTAB_L1_DESC_L2PTR_MASK;
-
-	/* The HW has 64 bit atomicity with stores to the L2 STE table */
-	WRITE_ONCE(dst->l2ptr, cpu_to_le64(val));
-}
-
 struct arm_smmu_ste_writer {
 	struct arm_smmu_entry_writer writer;
 	u32 sid;
@@ -3482,47 +3470,6 @@ static struct iommu_dirty_ops arm_smmu_dirty_ops = {
 };
 
 /* Probing and initialisation functions */
-int arm_smmu_init_one_queue(struct arm_smmu_device *smmu,
-			    struct arm_smmu_queue *q, void __iomem *page,
-			    unsigned long prod_off, unsigned long cons_off,
-			    size_t dwords, const char *name)
-{
-	size_t qsz;
-
-	do {
-		qsz = ((1 << q->llq.max_n_shift) * dwords) << 3;
-		q->base = dmam_alloc_coherent(smmu->dev, qsz, &q->base_dma,
-					      GFP_KERNEL);
-		if (q->base || qsz < PAGE_SIZE)
-			break;
-
-		q->llq.max_n_shift--;
-	} while (1);
-
-	if (!q->base) {
-		dev_err(smmu->dev,
-			"failed to allocate queue (0x%zx bytes) for %s\n",
-			qsz, name);
-		return -ENOMEM;
-	}
-
-	if (!WARN_ON(q->base_dma & (qsz - 1))) {
-		dev_info(smmu->dev, "allocated %u entries for %s\n",
-			 1 << q->llq.max_n_shift, name);
-	}
-
-	q->prod_reg	= page + prod_off;
-	q->cons_reg	= page + cons_off;
-	q->ent_dwords	= dwords;
-
-	q->q_base  = Q_BASE_RWA;
-	q->q_base |= q->base_dma & Q_BASE_ADDR_MASK;
-	q->q_base |= FIELD_PREP(Q_BASE_LOG2SIZE, q->llq.max_n_shift);
-
-	q->llq.prod = q->llq.cons = 0;
-	return 0;
-}
-
 int arm_smmu_cmdq_init(struct arm_smmu_device *smmu,
 		       struct arm_smmu_cmdq *cmdq)
 {
@@ -3577,76 +3524,6 @@ static int arm_smmu_init_queues(struct arm_smmu_device *smmu)
 				       PRIQ_ENT_DWORDS, "priq");
 }
 
-static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
-{
-	u32 l1size;
-	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
-	unsigned int last_sid_idx =
-		arm_smmu_strtab_l1_idx((1 << smmu->sid_bits) - 1);
-
-	/* Calculate the L1 size, capped to the SIDSIZE. */
-	cfg->l2.num_l1_ents = min(last_sid_idx + 1, STRTAB_MAX_L1_ENTRIES);
-	if (cfg->l2.num_l1_ents <= last_sid_idx)
-		dev_warn(smmu->dev,
-			 "2-level strtab only covers %u/%u bits of SID\n",
-			 ilog2(cfg->l2.num_l1_ents * STRTAB_NUM_L2_STES),
-			 smmu->sid_bits);
-
-	l1size = cfg->l2.num_l1_ents * sizeof(struct arm_smmu_strtab_l1);
-	cfg->l2.l1tab = dmam_alloc_coherent(smmu->dev, l1size, &cfg->l2.l1_dma,
-					    GFP_KERNEL);
-	if (!cfg->l2.l1tab) {
-		dev_err(smmu->dev,
-			"failed to allocate l1 stream table (%u bytes)\n",
-			l1size);
-		return -ENOMEM;
-	}
-
-	cfg->l2.l2ptrs = devm_kcalloc(smmu->dev, cfg->l2.num_l1_ents,
-				      sizeof(*cfg->l2.l2ptrs), GFP_KERNEL);
-	if (!cfg->l2.l2ptrs)
-		return -ENOMEM;
-
-	return 0;
-}
-
-static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
-{
-	u32 size;
-	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
-
-	size = (1 << smmu->sid_bits) * sizeof(struct arm_smmu_ste);
-	cfg->linear.table = dmam_alloc_coherent(smmu->dev, size,
-						&cfg->linear.ste_dma,
-						GFP_KERNEL);
-	if (!cfg->linear.table) {
-		dev_err(smmu->dev,
-			"failed to allocate linear stream table (%u bytes)\n",
-			size);
-		return -ENOMEM;
-	}
-	cfg->linear.num_ents = 1 << smmu->sid_bits;
-
-	arm_smmu_init_initial_stes(cfg->linear.table, cfg->linear.num_ents);
-	return 0;
-}
-
-static int arm_smmu_init_strtab(struct arm_smmu_device *smmu)
-{
-	int ret;
-
-	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB)
-		ret = arm_smmu_init_strtab_2lvl(smmu);
-	else
-		ret = arm_smmu_init_strtab_linear(smmu);
-	if (ret)
-		return ret;
-
-	ida_init(&smmu->vmid_map);
-
-	return 0;
-}
-
 static int arm_smmu_init_structures(struct arm_smmu_device *smmu)
 {
 	int ret;
@@ -3662,6 +3539,10 @@ static int arm_smmu_init_structures(struct arm_smmu_device *smmu)
 	if (ret)
 		return ret;
 
+	if (!(smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB))
+		arm_smmu_init_initial_stes(smmu->strtab_cfg.linear.table,
+					   smmu->strtab_cfg.linear.num_ents);
+
 	if (smmu->impl_ops && smmu->impl_ops->init_structures)
 		return smmu->impl_ops->init_structures(smmu);
 
@@ -3814,30 +3695,6 @@ static int arm_smmu_setup_irqs(struct arm_smmu_device *smmu)
 	return 0;
 }
 
-static void arm_smmu_write_strtab(struct arm_smmu_device *smmu)
-{
-	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
-	dma_addr_t dma;
-	u32 reg;
-
-	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
-		reg = FIELD_PREP(STRTAB_BASE_CFG_FMT,
-				 STRTAB_BASE_CFG_FMT_2LVL) |
-		      FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE,
-				 ilog2(cfg->l2.num_l1_ents) + STRTAB_SPLIT) |
-		      FIELD_PREP(STRTAB_BASE_CFG_SPLIT, STRTAB_SPLIT);
-		dma = cfg->l2.l1_dma;
-	} else {
-		reg = FIELD_PREP(STRTAB_BASE_CFG_FMT,
-				 STRTAB_BASE_CFG_FMT_LINEAR) |
-		      FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE, smmu->sid_bits);
-		dma = cfg->linear.ste_dma;
-	}
-	writeq_relaxed((dma & STRTAB_BASE_ADDR_MASK) | STRTAB_BASE_RA,
-		       smmu->base + ARM_SMMU_STRTAB_BASE);
-	writel_relaxed(reg, smmu->base + ARM_SMMU_STRTAB_BASE_CFG);
-}
-
 static int arm_smmu_device_reset(struct arm_smmu_device *smmu)
 {
 	int ret;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 1ffc8320b846..1a3452554ca8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -156,22 +156,6 @@ struct arm_smmu_s2_cfg {
 	u16				vmid;
 };
 
-struct arm_smmu_strtab_cfg {
-	union {
-		struct {
-			struct arm_smmu_ste *table;
-			dma_addr_t ste_dma;
-			unsigned int num_ents;
-		} linear;
-		struct {
-			struct arm_smmu_strtab_l1 *l1tab;
-			struct arm_smmu_strtab_l2 **l2ptrs;
-			dma_addr_t l1_dma;
-			unsigned int num_l1_ents;
-		} l2;
-	};
-};
-
 struct arm_smmu_impl_ops {
 	int (*device_reset)(struct arm_smmu_device *smmu);
 	void (*device_remove)(struct arm_smmu_device *smmu);
@@ -351,6 +335,16 @@ void arm_smmu_get_resv_regions(struct device *dev,
 			       struct list_head *head);
 
 int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu);
+int arm_smmu_init_one_queue(struct arm_smmu_device *smmu,
+			    struct arm_smmu_queue *q,
+			    void __iomem *page,
+			    unsigned long prod_off,
+			    unsigned long cons_off,
+			    size_t dwords, const char *name);
+int arm_smmu_init_strtab(struct arm_smmu_device *smmu);
+void arm_smmu_write_strtab_l1_desc(struct arm_smmu_strtab_l1 *dst,
+				   dma_addr_t l2ptr_dma);
+void arm_smmu_write_strtab(struct arm_smmu_device *smmu);
 
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
-- 
2.47.0.338.g60cca15819-goog

