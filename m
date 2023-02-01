Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B2A29B2
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:21 +0000 (UTC)
Received: by mail-wr1-f49.google.com with SMTP id m7so17221992wru.8
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ziphhZcJPXJLC+5r9d0l9f2mVBvLXVVKVfJ7Fj2IsgE=;
        b=k8mo9d1Qi6hHRkH5orJsmAv6IfDHKIWlBl94/SUu6jGGDAGcQxqxEOc0QHjQsoUzk1
         iEN9dRic5h79s9FfRaM8xgguH5bf+Ao53VfPb56TR27Lt505QImnErcWRM7ZHn79qmof
         F6rXcSfeMOp66lGADyZP69TnStr4hXdPRVdbst7cYjkw1ezAMne05FTQ8u/2ua9OUuDg
         2VMLiAGNg3iqoMRuyqqTREQ4eQ7RF+V+p9DvA+Yp8UarFNFhxeEdBqV/Gc4lZotD5oj3
         SG4lCtJiUziUp2uLZjv7gfFgV4PqAJ6U0kzGAlZoZIv5/Dr58/+NTw4f7xhwzmsEb4oM
         ZpQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ziphhZcJPXJLC+5r9d0l9f2mVBvLXVVKVfJ7Fj2IsgE=;
        b=mCz31goYGAbqqVqLGjFBL5LR5bg6FbiIVi7JOQ4EXOghSO19Y1T9/EpQYl0+nD6PQR
         JAUZ67Np89Wc3UGiplN0BKjYCgB8dmnShSqox3jxeFggctXYgkA679H/ciYXGnlY7Dna
         Qk82dlTG18s8NOnjtSWiTK1/NT3svQ8wyPyL0AZPNgQAJR0SiOvZ7+QzNonoQiuuTQwa
         HYc0hNSK2HPzyoKQ7BnL+0JWfEm/Td0pwMBqa4k+84Ival/bFyk/ZKS5e3UKNsqancB+
         S4vgJkZeYN09GymJ+AoNNMNChPMKidqFCSWtHSTCfNRiaqlLXSutd8gMmxqXIb77Xbe+
         lKbg==
X-Gm-Message-State: AO0yUKXp2WbOFmbej1F2uKXqNWCQyYwfk2n2pViW1ml/FB/Dfv8XpduH
	oX4VbPB95tBBUfH8EylM9gx4Dg==
X-Google-Smtp-Source: AK7set/3uCsXVIhxNwxZFCKcMQw1Q27U2Ycj8zW5qSODTxIAbq/oiQ9HDm+qezJoKiQ5iAd9qQe8MA==
X-Received: by 2002:a05:6000:1085:b0:2bf:f7c9:327c with SMTP id y5-20020a056000108500b002bff7c9327cmr2191461wrw.27.1675256359902;
        Wed, 01 Feb 2023 04:59:19 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:19 -0800 (PST)
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
Subject: [RFC PATCH 02/45] iommu/io-pgtable-arm: Split initialization
Date: Wed,  1 Feb 2023 12:52:46 +0000
Message-Id: <20230201125328.2186498-3-jean-philippe@linaro.org>
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

Extract the configuration part from io-pgtable-arm.c, move it to
io-pgtable-arm-common.c.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 include/linux/io-pgtable-arm.h        |  15 +-
 drivers/iommu/io-pgtable-arm-common.c | 255 ++++++++++++++++++++++++++
 drivers/iommu/io-pgtable-arm.c        | 245 +------------------------
 3 files changed, 270 insertions(+), 245 deletions(-)

diff --git a/include/linux/io-pgtable-arm.h b/include/linux/io-pgtable-arm.h
index 594b5030b450..42202bc0ffa2 100644
--- a/include/linux/io-pgtable-arm.h
+++ b/include/linux/io-pgtable-arm.h
@@ -167,17 +167,16 @@ static inline bool iopte_leaf(arm_lpae_iopte pte, int lvl,
 #define __arm_lpae_phys_to_virt	__va
 
 /* Generic functions */
-int arm_lpae_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
-		       phys_addr_t paddr, size_t pgsize, size_t pgcount,
-		       int iommu_prot, gfp_t gfp, size_t *mapped);
-size_t arm_lpae_unmap_pages(struct io_pgtable_ops *ops, unsigned long iova,
-			    size_t pgsize, size_t pgcount,
-			    struct iommu_iotlb_gather *gather);
-phys_addr_t arm_lpae_iova_to_phys(struct io_pgtable_ops *ops,
-				  unsigned long iova);
 void __arm_lpae_free_pgtable(struct arm_lpae_io_pgtable *data, int lvl,
 			     arm_lpae_iopte *ptep);
 
+int arm_lpae_init_pgtable(struct io_pgtable_cfg *cfg,
+			  struct arm_lpae_io_pgtable *data);
+int arm_lpae_init_pgtable_s1(struct io_pgtable_cfg *cfg,
+			     struct arm_lpae_io_pgtable *data);
+int arm_lpae_init_pgtable_s2(struct io_pgtable_cfg *cfg,
+			     struct arm_lpae_io_pgtable *data);
+
 /* Host/hyp-specific functions */
 void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp, struct io_pgtable_cfg *cfg);
 void __arm_lpae_free_pages(void *pages, size_t size, struct io_pgtable_cfg *cfg);
diff --git a/drivers/iommu/io-pgtable-arm-common.c b/drivers/iommu/io-pgtable-arm-common.c
index 74d962712d15..7340b5096499 100644
--- a/drivers/iommu/io-pgtable-arm-common.c
+++ b/drivers/iommu/io-pgtable-arm-common.c
@@ -15,6 +15,9 @@
 
 #define iopte_deref(pte, d) __arm_lpae_phys_to_virt(iopte_to_paddr(pte, d))
 
+#define ARM_LPAE_MAX_ADDR_BITS		52
+#define ARM_LPAE_S2_MAX_CONCAT_PAGES	16
+
 static arm_lpae_iopte paddr_to_iopte(phys_addr_t paddr,
 				     struct arm_lpae_io_pgtable *data)
 {
@@ -498,3 +501,255 @@ phys_addr_t arm_lpae_iova_to_phys(struct io_pgtable_ops *ops,
 	iova &= (ARM_LPAE_BLOCK_SIZE(lvl, data) - 1);
 	return iopte_to_paddr(pte, data) | iova;
 }
+
+static void arm_lpae_restrict_pgsizes(struct io_pgtable_cfg *cfg)
+{
+	unsigned long granule, page_sizes;
+	unsigned int max_addr_bits = 48;
+
+	/*
+	 * We need to restrict the supported page sizes to match the
+	 * translation regime for a particular granule. Aim to match
+	 * the CPU page size if possible, otherwise prefer smaller sizes.
+	 * While we're at it, restrict the block sizes to match the
+	 * chosen granule.
+	 */
+	if (cfg->pgsize_bitmap & PAGE_SIZE)
+		granule = PAGE_SIZE;
+	else if (cfg->pgsize_bitmap & ~PAGE_MASK)
+		granule = 1UL << __fls(cfg->pgsize_bitmap & ~PAGE_MASK);
+	else if (cfg->pgsize_bitmap & PAGE_MASK)
+		granule = 1UL << __ffs(cfg->pgsize_bitmap & PAGE_MASK);
+	else
+		granule = 0;
+
+	switch (granule) {
+	case SZ_4K:
+		page_sizes = (SZ_4K | SZ_2M | SZ_1G);
+		break;
+	case SZ_16K:
+		page_sizes = (SZ_16K | SZ_32M);
+		break;
+	case SZ_64K:
+		max_addr_bits = 52;
+		page_sizes = (SZ_64K | SZ_512M);
+		if (cfg->oas > 48)
+			page_sizes |= 1ULL << 42; /* 4TB */
+		break;
+	default:
+		page_sizes = 0;
+	}
+
+	cfg->pgsize_bitmap &= page_sizes;
+	cfg->ias = min(cfg->ias, max_addr_bits);
+	cfg->oas = min(cfg->oas, max_addr_bits);
+}
+
+int arm_lpae_init_pgtable(struct io_pgtable_cfg *cfg,
+			  struct arm_lpae_io_pgtable *data)
+{
+	int levels, va_bits, pg_shift;
+
+	arm_lpae_restrict_pgsizes(cfg);
+
+	if (!(cfg->pgsize_bitmap & (SZ_4K | SZ_16K | SZ_64K)))
+		return -EINVAL;
+
+	if (cfg->ias > ARM_LPAE_MAX_ADDR_BITS)
+		return -E2BIG;
+
+	if (cfg->oas > ARM_LPAE_MAX_ADDR_BITS)
+		return -E2BIG;
+
+	pg_shift = __ffs(cfg->pgsize_bitmap);
+	data->bits_per_level = pg_shift - ilog2(sizeof(arm_lpae_iopte));
+
+	va_bits = cfg->ias - pg_shift;
+	levels = DIV_ROUND_UP(va_bits, data->bits_per_level);
+	data->start_level = ARM_LPAE_MAX_LEVELS - levels;
+
+	/* Calculate the actual size of our pgd (without concatenation) */
+	data->pgd_bits = va_bits - (data->bits_per_level * (levels - 1));
+
+	data->iop.ops = (struct io_pgtable_ops) {
+		.map_pages	= arm_lpae_map_pages,
+		.unmap_pages	= arm_lpae_unmap_pages,
+		.iova_to_phys	= arm_lpae_iova_to_phys,
+	};
+
+	return 0;
+}
+
+int arm_lpae_init_pgtable_s1(struct io_pgtable_cfg *cfg,
+			     struct arm_lpae_io_pgtable *data)
+{
+	u64 reg;
+	int ret;
+	typeof(&cfg->arm_lpae_s1_cfg.tcr) tcr = &cfg->arm_lpae_s1_cfg.tcr;
+	bool tg1;
+
+	if (cfg->quirks & ~(IO_PGTABLE_QUIRK_ARM_NS |
+			    IO_PGTABLE_QUIRK_ARM_TTBR1 |
+			    IO_PGTABLE_QUIRK_ARM_OUTER_WBWA))
+		return -EINVAL;
+
+	ret = arm_lpae_init_pgtable(cfg, data);
+	if (ret)
+		return ret;
+
+	/* TCR */
+	if (cfg->coherent_walk) {
+		tcr->sh = ARM_LPAE_TCR_SH_IS;
+		tcr->irgn = ARM_LPAE_TCR_RGN_WBWA;
+		tcr->orgn = ARM_LPAE_TCR_RGN_WBWA;
+		if (cfg->quirks & IO_PGTABLE_QUIRK_ARM_OUTER_WBWA)
+			return -EINVAL;
+	} else {
+		tcr->sh = ARM_LPAE_TCR_SH_OS;
+		tcr->irgn = ARM_LPAE_TCR_RGN_NC;
+		if (!(cfg->quirks & IO_PGTABLE_QUIRK_ARM_OUTER_WBWA))
+			tcr->orgn = ARM_LPAE_TCR_RGN_NC;
+		else
+			tcr->orgn = ARM_LPAE_TCR_RGN_WBWA;
+	}
+
+	tg1 = cfg->quirks & IO_PGTABLE_QUIRK_ARM_TTBR1;
+	switch (ARM_LPAE_GRANULE(data)) {
+	case SZ_4K:
+		tcr->tg = tg1 ? ARM_LPAE_TCR_TG1_4K : ARM_LPAE_TCR_TG0_4K;
+		break;
+	case SZ_16K:
+		tcr->tg = tg1 ? ARM_LPAE_TCR_TG1_16K : ARM_LPAE_TCR_TG0_16K;
+		break;
+	case SZ_64K:
+		tcr->tg = tg1 ? ARM_LPAE_TCR_TG1_64K : ARM_LPAE_TCR_TG0_64K;
+		break;
+	}
+
+	switch (cfg->oas) {
+	case 32:
+		tcr->ips = ARM_LPAE_TCR_PS_32_BIT;
+		break;
+	case 36:
+		tcr->ips = ARM_LPAE_TCR_PS_36_BIT;
+		break;
+	case 40:
+		tcr->ips = ARM_LPAE_TCR_PS_40_BIT;
+		break;
+	case 42:
+		tcr->ips = ARM_LPAE_TCR_PS_42_BIT;
+		break;
+	case 44:
+		tcr->ips = ARM_LPAE_TCR_PS_44_BIT;
+		break;
+	case 48:
+		tcr->ips = ARM_LPAE_TCR_PS_48_BIT;
+		break;
+	case 52:
+		tcr->ips = ARM_LPAE_TCR_PS_52_BIT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	tcr->tsz = 64ULL - cfg->ias;
+
+	/* MAIRs */
+	reg = (ARM_LPAE_MAIR_ATTR_NC
+	       << ARM_LPAE_MAIR_ATTR_SHIFT(ARM_LPAE_MAIR_ATTR_IDX_NC)) |
+	      (ARM_LPAE_MAIR_ATTR_WBRWA
+	       << ARM_LPAE_MAIR_ATTR_SHIFT(ARM_LPAE_MAIR_ATTR_IDX_CACHE)) |
+	      (ARM_LPAE_MAIR_ATTR_DEVICE
+	       << ARM_LPAE_MAIR_ATTR_SHIFT(ARM_LPAE_MAIR_ATTR_IDX_DEV)) |
+	      (ARM_LPAE_MAIR_ATTR_INC_OWBRWA
+	       << ARM_LPAE_MAIR_ATTR_SHIFT(ARM_LPAE_MAIR_ATTR_IDX_INC_OCACHE));
+
+	cfg->arm_lpae_s1_cfg.mair = reg;
+	return 0;
+}
+
+int arm_lpae_init_pgtable_s2(struct io_pgtable_cfg *cfg,
+			     struct arm_lpae_io_pgtable *data)
+{
+	u64 sl;
+	int ret;
+	typeof(&cfg->arm_lpae_s2_cfg.vtcr) vtcr = &cfg->arm_lpae_s2_cfg.vtcr;
+
+	/* The NS quirk doesn't apply at stage 2 */
+	if (cfg->quirks)
+		return -EINVAL;
+
+	ret = arm_lpae_init_pgtable(cfg, data);
+	if (ret)
+		return ret;
+
+	/*
+	 * Concatenate PGDs at level 1 if possible in order to reduce
+	 * the depth of the stage-2 walk.
+	 */
+	if (data->start_level == 0) {
+		unsigned long pgd_pages;
+
+		pgd_pages = ARM_LPAE_PGD_SIZE(data) / sizeof(arm_lpae_iopte);
+		if (pgd_pages <= ARM_LPAE_S2_MAX_CONCAT_PAGES) {
+			data->pgd_bits += data->bits_per_level;
+			data->start_level++;
+		}
+	}
+
+	/* VTCR */
+	if (cfg->coherent_walk) {
+		vtcr->sh = ARM_LPAE_TCR_SH_IS;
+		vtcr->irgn = ARM_LPAE_TCR_RGN_WBWA;
+		vtcr->orgn = ARM_LPAE_TCR_RGN_WBWA;
+	} else {
+		vtcr->sh = ARM_LPAE_TCR_SH_OS;
+		vtcr->irgn = ARM_LPAE_TCR_RGN_NC;
+		vtcr->orgn = ARM_LPAE_TCR_RGN_NC;
+	}
+
+	sl = data->start_level;
+
+	switch (ARM_LPAE_GRANULE(data)) {
+	case SZ_4K:
+		vtcr->tg = ARM_LPAE_TCR_TG0_4K;
+		sl++; /* SL0 format is different for 4K granule size */
+		break;
+	case SZ_16K:
+		vtcr->tg = ARM_LPAE_TCR_TG0_16K;
+		break;
+	case SZ_64K:
+		vtcr->tg = ARM_LPAE_TCR_TG0_64K;
+		break;
+	}
+
+	switch (cfg->oas) {
+	case 32:
+		vtcr->ps = ARM_LPAE_TCR_PS_32_BIT;
+		break;
+	case 36:
+		vtcr->ps = ARM_LPAE_TCR_PS_36_BIT;
+		break;
+	case 40:
+		vtcr->ps = ARM_LPAE_TCR_PS_40_BIT;
+		break;
+	case 42:
+		vtcr->ps = ARM_LPAE_TCR_PS_42_BIT;
+		break;
+	case 44:
+		vtcr->ps = ARM_LPAE_TCR_PS_44_BIT;
+		break;
+	case 48:
+		vtcr->ps = ARM_LPAE_TCR_PS_48_BIT;
+		break;
+	case 52:
+		vtcr->ps = ARM_LPAE_TCR_PS_52_BIT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	vtcr->tsz = 64ULL - cfg->ias;
+	vtcr->sl = ~sl & ARM_LPAE_VTCR_SL0_MASK;
+	return 0;
+}
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index db42aed6ad7b..b2b188bb86b3 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -21,9 +21,6 @@
 
 #include <asm/barrier.h>
 
-#define ARM_LPAE_MAX_ADDR_BITS		52
-#define ARM_LPAE_S2_MAX_CONCAT_PAGES	16
-
 bool selftest_running = false;
 
 static dma_addr_t __arm_lpae_dma_addr(void *pages)
@@ -91,174 +88,17 @@ static void arm_lpae_free_pgtable(struct io_pgtable *iop)
 	kfree(data);
 }
 
-static void arm_lpae_restrict_pgsizes(struct io_pgtable_cfg *cfg)
-{
-	unsigned long granule, page_sizes;
-	unsigned int max_addr_bits = 48;
-
-	/*
-	 * We need to restrict the supported page sizes to match the
-	 * translation regime for a particular granule. Aim to match
-	 * the CPU page size if possible, otherwise prefer smaller sizes.
-	 * While we're at it, restrict the block sizes to match the
-	 * chosen granule.
-	 */
-	if (cfg->pgsize_bitmap & PAGE_SIZE)
-		granule = PAGE_SIZE;
-	else if (cfg->pgsize_bitmap & ~PAGE_MASK)
-		granule = 1UL << __fls(cfg->pgsize_bitmap & ~PAGE_MASK);
-	else if (cfg->pgsize_bitmap & PAGE_MASK)
-		granule = 1UL << __ffs(cfg->pgsize_bitmap & PAGE_MASK);
-	else
-		granule = 0;
-
-	switch (granule) {
-	case SZ_4K:
-		page_sizes = (SZ_4K | SZ_2M | SZ_1G);
-		break;
-	case SZ_16K:
-		page_sizes = (SZ_16K | SZ_32M);
-		break;
-	case SZ_64K:
-		max_addr_bits = 52;
-		page_sizes = (SZ_64K | SZ_512M);
-		if (cfg->oas > 48)
-			page_sizes |= 1ULL << 42; /* 4TB */
-		break;
-	default:
-		page_sizes = 0;
-	}
-
-	cfg->pgsize_bitmap &= page_sizes;
-	cfg->ias = min(cfg->ias, max_addr_bits);
-	cfg->oas = min(cfg->oas, max_addr_bits);
-}
-
-static struct arm_lpae_io_pgtable *
-arm_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg)
-{
-	struct arm_lpae_io_pgtable *data;
-	int levels, va_bits, pg_shift;
-
-	arm_lpae_restrict_pgsizes(cfg);
-
-	if (!(cfg->pgsize_bitmap & (SZ_4K | SZ_16K | SZ_64K)))
-		return NULL;
-
-	if (cfg->ias > ARM_LPAE_MAX_ADDR_BITS)
-		return NULL;
-
-	if (cfg->oas > ARM_LPAE_MAX_ADDR_BITS)
-		return NULL;
-
-	data = kmalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return NULL;
-
-	pg_shift = __ffs(cfg->pgsize_bitmap);
-	data->bits_per_level = pg_shift - ilog2(sizeof(arm_lpae_iopte));
-
-	va_bits = cfg->ias - pg_shift;
-	levels = DIV_ROUND_UP(va_bits, data->bits_per_level);
-	data->start_level = ARM_LPAE_MAX_LEVELS - levels;
-
-	/* Calculate the actual size of our pgd (without concatenation) */
-	data->pgd_bits = va_bits - (data->bits_per_level * (levels - 1));
-
-	data->iop.ops = (struct io_pgtable_ops) {
-		.map_pages	= arm_lpae_map_pages,
-		.unmap_pages	= arm_lpae_unmap_pages,
-		.iova_to_phys	= arm_lpae_iova_to_phys,
-	};
-
-	return data;
-}
-
 static struct io_pgtable *
 arm_64_lpae_alloc_pgtable_s1(struct io_pgtable_cfg *cfg, void *cookie)
 {
-	u64 reg;
 	struct arm_lpae_io_pgtable *data;
-	typeof(&cfg->arm_lpae_s1_cfg.tcr) tcr = &cfg->arm_lpae_s1_cfg.tcr;
-	bool tg1;
-
-	if (cfg->quirks & ~(IO_PGTABLE_QUIRK_ARM_NS |
-			    IO_PGTABLE_QUIRK_ARM_TTBR1 |
-			    IO_PGTABLE_QUIRK_ARM_OUTER_WBWA))
-		return NULL;
 
-	data = arm_lpae_alloc_pgtable(cfg);
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return NULL;
 
-	/* TCR */
-	if (cfg->coherent_walk) {
-		tcr->sh = ARM_LPAE_TCR_SH_IS;
-		tcr->irgn = ARM_LPAE_TCR_RGN_WBWA;
-		tcr->orgn = ARM_LPAE_TCR_RGN_WBWA;
-		if (cfg->quirks & IO_PGTABLE_QUIRK_ARM_OUTER_WBWA)
-			goto out_free_data;
-	} else {
-		tcr->sh = ARM_LPAE_TCR_SH_OS;
-		tcr->irgn = ARM_LPAE_TCR_RGN_NC;
-		if (!(cfg->quirks & IO_PGTABLE_QUIRK_ARM_OUTER_WBWA))
-			tcr->orgn = ARM_LPAE_TCR_RGN_NC;
-		else
-			tcr->orgn = ARM_LPAE_TCR_RGN_WBWA;
-	}
-
-	tg1 = cfg->quirks & IO_PGTABLE_QUIRK_ARM_TTBR1;
-	switch (ARM_LPAE_GRANULE(data)) {
-	case SZ_4K:
-		tcr->tg = tg1 ? ARM_LPAE_TCR_TG1_4K : ARM_LPAE_TCR_TG0_4K;
-		break;
-	case SZ_16K:
-		tcr->tg = tg1 ? ARM_LPAE_TCR_TG1_16K : ARM_LPAE_TCR_TG0_16K;
-		break;
-	case SZ_64K:
-		tcr->tg = tg1 ? ARM_LPAE_TCR_TG1_64K : ARM_LPAE_TCR_TG0_64K;
-		break;
-	}
-
-	switch (cfg->oas) {
-	case 32:
-		tcr->ips = ARM_LPAE_TCR_PS_32_BIT;
-		break;
-	case 36:
-		tcr->ips = ARM_LPAE_TCR_PS_36_BIT;
-		break;
-	case 40:
-		tcr->ips = ARM_LPAE_TCR_PS_40_BIT;
-		break;
-	case 42:
-		tcr->ips = ARM_LPAE_TCR_PS_42_BIT;
-		break;
-	case 44:
-		tcr->ips = ARM_LPAE_TCR_PS_44_BIT;
-		break;
-	case 48:
-		tcr->ips = ARM_LPAE_TCR_PS_48_BIT;
-		break;
-	case 52:
-		tcr->ips = ARM_LPAE_TCR_PS_52_BIT;
-		break;
-	default:
+	if (arm_lpae_init_pgtable_s1(cfg, data))
 		goto out_free_data;
-	}
-
-	tcr->tsz = 64ULL - cfg->ias;
-
-	/* MAIRs */
-	reg = (ARM_LPAE_MAIR_ATTR_NC
-	       << ARM_LPAE_MAIR_ATTR_SHIFT(ARM_LPAE_MAIR_ATTR_IDX_NC)) |
-	      (ARM_LPAE_MAIR_ATTR_WBRWA
-	       << ARM_LPAE_MAIR_ATTR_SHIFT(ARM_LPAE_MAIR_ATTR_IDX_CACHE)) |
-	      (ARM_LPAE_MAIR_ATTR_DEVICE
-	       << ARM_LPAE_MAIR_ATTR_SHIFT(ARM_LPAE_MAIR_ATTR_IDX_DEV)) |
-	      (ARM_LPAE_MAIR_ATTR_INC_OWBRWA
-	       << ARM_LPAE_MAIR_ATTR_SHIFT(ARM_LPAE_MAIR_ATTR_IDX_INC_OCACHE));
-
-	cfg->arm_lpae_s1_cfg.mair = reg;
 
 	/* Looking good; allocate a pgd */
 	data->pgd = __arm_lpae_alloc_pages(ARM_LPAE_PGD_SIZE(data),
@@ -281,86 +121,14 @@ arm_64_lpae_alloc_pgtable_s1(struct io_pgtable_cfg *cfg, void *cookie)
 static struct io_pgtable *
 arm_64_lpae_alloc_pgtable_s2(struct io_pgtable_cfg *cfg, void *cookie)
 {
-	u64 sl;
 	struct arm_lpae_io_pgtable *data;
-	typeof(&cfg->arm_lpae_s2_cfg.vtcr) vtcr = &cfg->arm_lpae_s2_cfg.vtcr;
-
-	/* The NS quirk doesn't apply at stage 2 */
-	if (cfg->quirks)
-		return NULL;
 
-	data = arm_lpae_alloc_pgtable(cfg);
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return NULL;
 
-	/*
-	 * Concatenate PGDs at level 1 if possible in order to reduce
-	 * the depth of the stage-2 walk.
-	 */
-	if (data->start_level == 0) {
-		unsigned long pgd_pages;
-
-		pgd_pages = ARM_LPAE_PGD_SIZE(data) / sizeof(arm_lpae_iopte);
-		if (pgd_pages <= ARM_LPAE_S2_MAX_CONCAT_PAGES) {
-			data->pgd_bits += data->bits_per_level;
-			data->start_level++;
-		}
-	}
-
-	/* VTCR */
-	if (cfg->coherent_walk) {
-		vtcr->sh = ARM_LPAE_TCR_SH_IS;
-		vtcr->irgn = ARM_LPAE_TCR_RGN_WBWA;
-		vtcr->orgn = ARM_LPAE_TCR_RGN_WBWA;
-	} else {
-		vtcr->sh = ARM_LPAE_TCR_SH_OS;
-		vtcr->irgn = ARM_LPAE_TCR_RGN_NC;
-		vtcr->orgn = ARM_LPAE_TCR_RGN_NC;
-	}
-
-	sl = data->start_level;
-
-	switch (ARM_LPAE_GRANULE(data)) {
-	case SZ_4K:
-		vtcr->tg = ARM_LPAE_TCR_TG0_4K;
-		sl++; /* SL0 format is different for 4K granule size */
-		break;
-	case SZ_16K:
-		vtcr->tg = ARM_LPAE_TCR_TG0_16K;
-		break;
-	case SZ_64K:
-		vtcr->tg = ARM_LPAE_TCR_TG0_64K;
-		break;
-	}
-
-	switch (cfg->oas) {
-	case 32:
-		vtcr->ps = ARM_LPAE_TCR_PS_32_BIT;
-		break;
-	case 36:
-		vtcr->ps = ARM_LPAE_TCR_PS_36_BIT;
-		break;
-	case 40:
-		vtcr->ps = ARM_LPAE_TCR_PS_40_BIT;
-		break;
-	case 42:
-		vtcr->ps = ARM_LPAE_TCR_PS_42_BIT;
-		break;
-	case 44:
-		vtcr->ps = ARM_LPAE_TCR_PS_44_BIT;
-		break;
-	case 48:
-		vtcr->ps = ARM_LPAE_TCR_PS_48_BIT;
-		break;
-	case 52:
-		vtcr->ps = ARM_LPAE_TCR_PS_52_BIT;
-		break;
-	default:
+	if (arm_lpae_init_pgtable_s2(cfg, data))
 		goto out_free_data;
-	}
-
-	vtcr->tsz = 64ULL - cfg->ias;
-	vtcr->sl = ~sl & ARM_LPAE_VTCR_SL0_MASK;
 
 	/* Allocate pgd pages */
 	data->pgd = __arm_lpae_alloc_pages(ARM_LPAE_PGD_SIZE(data),
@@ -414,10 +182,13 @@ arm_mali_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 
 	cfg->pgsize_bitmap &= (SZ_4K | SZ_2M | SZ_1G);
 
-	data = arm_lpae_alloc_pgtable(cfg);
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return NULL;
 
+	if (arm_lpae_init_pgtable(cfg, data))
+		return NULL;
+
 	/* Mali seems to need a full 4-level table regardless of IAS */
 	if (data->start_level > 0) {
 		data->start_level = 0;
-- 
2.39.0

