Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00262236F0
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026692; cv=none; b=k4W9WG8if659mzwHIvgx9KoqyHfDqRGPVrTkDjxbNaGFWHglXTARNGyx69PFL3zbxAv9OZljqM4sI1m6G0XEl7mt3NDyrMJkFkAwaEmNSkCBio5fPMiBj6Or/T5YuhG+V01O6KS6BV+SMsXcMyrZHU9EMnQsEw6KCNmEN9lTUfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026692; c=relaxed/simple;
	bh=9ZFTcQsqDyTfTPLjTV5WSbeYTkq1aafa7zyvTsUILTc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rmaWen+eBCg0mLg23PZmLIj6OomURXjWgzJn0zF2TP5B9aiS4nZ15JfT/bLtLJdTtAj7DArPSa7/PkSKs3hseuTfwxFi2S56P477MXgREX7vDG5KdFJrhb9bXS9UjbgQWr3cyEgJjLlJC8uxIna6eez+50Cqd0Qcu3V+qraxUno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bvoiwa6Q; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bvoiwa6Q"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-434fe2b605eso5720415e9.2
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:04:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026688; x=1734631488; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mXyCI09ZhbjXuioTmiv59A6C3cN5WJchYUKT74jp+y4=;
        b=Bvoiwa6QCaSadTzWlOPjCqOU0YtT82QFP0Q0F8suXpymo4Ac23Mj/flRbZ2Pv5W336
         yqfboQrUNS1z7RqbZSHMYoj/qpjmpduNGrFUS25FOHb3DTq0iB1wakY9YSLmmioM0sJ+
         HCk4T/S8y9UDGGT5uaEfpliNchA9hucUubMLc2OrB0pKrcMJCPlpNoiMiVCYn0qtYj4z
         Sz6tMhe1WR9FfvW4hPshGrP+Z3UAq7f5qNHNGptjBRF9VKJ8A5nMeEcpxVFubyzVjUk7
         IX8gmAk8R8120EI0OmiY+bpIlGRkUsdR9PNUJlUDK2uaiJGOP+LXAW1I3wuB30QSe6S2
         Oqlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026688; x=1734631488;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mXyCI09ZhbjXuioTmiv59A6C3cN5WJchYUKT74jp+y4=;
        b=ByO5jjJ8gySGZ6lkRU8pNxNY5l9xaJMRkPS8TxOL4ThvqPtp3bD/vZrG5ddJFCxXnG
         yUeIw4LpKtgquobyBOhv21J3XaoF7P/YGM9NCxv5dNVEqyqExHOw/YkOTVfikGmMvn6j
         xXaV0oOPX0ygNyS2NlqBoVhJCnEFOf/lP+CxFI/GirE1Y2tKXkzRwRcKuJftJ/UNB+Qu
         uL8ZF/69ZXNhuLSdj65hGg2D7JYSg1ih6DNDrwDrAFIMhAe4CxAXtqmB3/pxIKQyf1Wl
         7Sc05+t6sIRXfetcAHGstMTHD/fcWgWFcZSNigOMr1iX1XqGezbt3vXmbvttsYTmPhlW
         DEvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBSSy/IywN9AAL655A3EdhqI1ux7axCFVEHwjpZUuRB8BTQ2GvogtvwRKzrSqiPlRLleJ6qm4=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywmda7KJF0dRpbEamQ1X+MWhi+KzFaxbcntrR1S2S/F8zwMZ5Ia
	3n7W6+38rpJonliOTj6QF5q0oZ8osigHNrF6ZpCnXIk7PNkVfxguqEUlEFdM2OIZ/NFgbTESdkr
	OKRGOzuaCDg==
X-Google-Smtp-Source: AGHT+IEk2aXuVPdW8p5vy/iG8MnfnqpK0HK6/sRZjiQb0zjhXoM+JzKpW5jH3xqld9fYqITutfI7YBgnBki8IA==
X-Received: from wmbd13.prod.google.com ([2002:a05:600c:58cd:b0:434:9dec:7cc5])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8507:b0:434:a29d:6c71 with SMTP id 5b1f17b1804b1-4361c411ab0mr60536895e9.27.1734026688254;
 Thu, 12 Dec 2024 10:04:48 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:26 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-3-smostafa@google.com>
Subject: [RFC PATCH v2 02/58] iommu/io-pgtable-arm: Split initialization
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

Extract the configuration part from io-pgtable-arm.c, move it to
io-pgtable-arm-common.c.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/io-pgtable-arm-common.c | 284 ++++++++++++++++++++++++--
 drivers/iommu/io-pgtable-arm.c        | 250 +----------------------
 include/linux/io-pgtable-arm.h        |  20 +-
 3 files changed, 286 insertions(+), 268 deletions(-)

diff --git a/drivers/iommu/io-pgtable-arm-common.c b/drivers/iommu/io-pgtable-arm-common.c
index ef14a1b50d32..21ee8ff7c881 100644
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
@@ -257,9 +260,9 @@ static arm_lpae_iopte arm_lpae_prot_to_pte(struct arm_lpae_io_pgtable *data,
 	return pte;
 }
 
-int arm_lpae_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
-		       phys_addr_t paddr, size_t pgsize, size_t pgcount,
-		       int iommu_prot, gfp_t gfp, size_t *mapped)
+static int arm_lpae_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
+			      phys_addr_t paddr, size_t pgsize, size_t pgcount,
+			      int iommu_prot, gfp_t gfp, size_t *mapped)
 {
 	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(ops);
 	struct io_pgtable_cfg *cfg = &data->iop.cfg;
@@ -444,9 +447,9 @@ static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
 	return __arm_lpae_unmap(data, gather, iova, size, pgcount, lvl + 1, ptep);
 }
 
-size_t arm_lpae_unmap_pages(struct io_pgtable_ops *ops, unsigned long iova,
-			    size_t pgsize, size_t pgcount,
-			    struct iommu_iotlb_gather *gather)
+static size_t arm_lpae_unmap_pages(struct io_pgtable_ops *ops, unsigned long iova,
+				   size_t pgsize, size_t pgcount,
+				   struct iommu_iotlb_gather *gather)
 {
 	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(ops);
 	struct io_pgtable_cfg *cfg = &data->iop.cfg;
@@ -484,8 +487,8 @@ static int visit_iova_to_phys(struct io_pgtable_walk_data *walk_data, int lvl,
 	return 0;
 }
 
-phys_addr_t arm_lpae_iova_to_phys(struct io_pgtable_ops *ops,
-				  unsigned long iova)
+static phys_addr_t arm_lpae_iova_to_phys(struct io_pgtable_ops *ops,
+					 unsigned long iova)
 {
 	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(ops);
 	struct iova_to_phys_data d;
@@ -513,7 +516,7 @@ static int visit_pgtable_walk(struct io_pgtable_walk_data *walk_data, int lvl,
 	return 0;
 }
 
-int arm_lpae_pgtable_walk(struct io_pgtable_ops *ops, unsigned long iova, void *wd)
+static int arm_lpae_pgtable_walk(struct io_pgtable_ops *ops, unsigned long iova, void *wd)
 {
 	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(ops);
 	struct io_pgtable_walk_data walk_data = {
@@ -596,10 +599,10 @@ static int visit_dirty(struct io_pgtable_walk_data *walk_data, int lvl,
 	return 0;
 }
 
-int arm_lpae_read_and_clear_dirty(struct io_pgtable_ops *ops,
-				  unsigned long iova, size_t size,
-				  unsigned long flags,
-				  struct iommu_dirty_bitmap *dirty)
+static int arm_lpae_read_and_clear_dirty(struct io_pgtable_ops *ops,
+					 unsigned long iova, size_t size,
+					 unsigned long flags,
+					 struct iommu_dirty_bitmap *dirty)
 {
 	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(ops);
 	struct io_pgtable_cfg *cfg = &data->iop.cfg;
@@ -623,3 +626,258 @@ int arm_lpae_read_and_clear_dirty(struct io_pgtable_ops *ops,
 
 	return __arm_lpae_iopte_walk(data, &walk_data, ptep, lvl);
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
+		.read_and_clear_dirty = arm_lpae_read_and_clear_dirty,
+		.pgtable_walk	= arm_lpae_pgtable_walk,
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
+			    IO_PGTABLE_QUIRK_ARM_OUTER_WBWA |
+			    IO_PGTABLE_QUIRK_ARM_HD))
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
index cb4eb513adbf..8d435a5bcd9a 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -19,12 +19,9 @@
 #include <linux/types.h>
 #include <linux/dma-mapping.h>
 
-#include <asm/barrier.h>
-
 #include "iommu-pages.h"
 
-#define ARM_LPAE_MAX_ADDR_BITS		52
-#define ARM_LPAE_S2_MAX_CONCAT_PAGES	16
+#include <asm/barrier.h>
 
 static bool selftest_running = false;
 
@@ -121,177 +118,17 @@ static void arm_lpae_free_pgtable(struct io_pgtable *iop)
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
-		.read_and_clear_dirty = arm_lpae_read_and_clear_dirty,
-		.pgtable_walk	= arm_lpae_pgtable_walk,
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
-			    IO_PGTABLE_QUIRK_ARM_OUTER_WBWA |
-			    IO_PGTABLE_QUIRK_ARM_HD))
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
@@ -314,86 +151,14 @@ arm_64_lpae_alloc_pgtable_s1(struct io_pgtable_cfg *cfg, void *cookie)
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
@@ -447,10 +212,13 @@ arm_mali_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 
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
diff --git a/include/linux/io-pgtable-arm.h b/include/linux/io-pgtable-arm.h
index 1f56dabca18c..337e9254fdbd 100644
--- a/include/linux/io-pgtable-arm.h
+++ b/include/linux/io-pgtable-arm.h
@@ -195,23 +195,15 @@ static inline bool iopte_table(arm_lpae_iopte pte, int lvl)
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
 
-int arm_lpae_read_and_clear_dirty(struct io_pgtable_ops *ops,
-				  unsigned long iova, size_t size,
-				  unsigned long flags,
-				  struct iommu_dirty_bitmap *dirty);
-
-int arm_lpae_pgtable_walk(struct io_pgtable_ops *ops, unsigned long iova, void *wd);
+int arm_lpae_init_pgtable(struct io_pgtable_cfg *cfg,
+			  struct arm_lpae_io_pgtable *data);
+int arm_lpae_init_pgtable_s1(struct io_pgtable_cfg *cfg,
+			     struct arm_lpae_io_pgtable *data);
+int arm_lpae_init_pgtable_s2(struct io_pgtable_cfg *cfg,
+			     struct arm_lpae_io_pgtable *data);
 
 /* Host/hyp-specific functions */
 void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp, struct io_pgtable_cfg *cfg, void *cookie);
-- 
2.47.0.338.g60cca15819-goog

