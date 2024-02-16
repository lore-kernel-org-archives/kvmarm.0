Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B8559169
	for <kvmarm@lists.linux.dev>; Fri, 16 Feb 2024 12:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708085030; cv=none; b=BzFkLwUxkvrKuXvoGxOtVGyKXS8ntdFatH3dUACYOog5xwmC/tiT5nJhIulZdzrMkw39YsIZE84ZsOJJ93yCR4HoMJWQdHA9j2kXjjHtEHXC1U9sqLvl72m7c5y8HTRgOoSr9DYXWOvA3ZI9iXOha+Fga/rL7PL71W4/HWltxeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708085030; c=relaxed/simple;
	bh=YM+SY/DOWMMm8ASTzrJG2DOcQdXs25POCgE1JZP9d4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=og8Mby6/M8wrSNkRzCrTpK/tgEJpRiRGOtdy/7Gq0z4WgpAF1d5LqRM7chhkazWmIqQTAAlsONjId5yzFxf3N+Hf5yFcIIFY+DJfxe0JPA1m0SK1erH29COZx94KNjmklzOXv1IB2gq5pzhHrdsj3IsDGx2R8HWnOD3cHuUMCx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lJCERWb6; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lJCERWb6"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-410acf9e776so42905e9.1
        for <kvmarm@lists.linux.dev>; Fri, 16 Feb 2024 04:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708085026; x=1708689826; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bQomNEuN4zLjd9Rj3427jBPqEPKhQEI4ZTR/hOCcWaQ=;
        b=lJCERWb6X1x4Sy5JXnD83IbLV4XUjXvM4KU5UcVk8/V9MF49ec15icQ//An6R/N0cD
         iaL49P1VCXrNdQDYUJRP++nPUx6qSAdi7AFMufAr2WSG7+wuREFMsuoi3u0XwFa86cKh
         6AKdRp2s2PBDGBDirnG5wecf80qnPCEvcYf/XevKtnMOfT5uUSbb+m5SpTfP0fyJbYjV
         BYDvp/j1YaBYpS5cblUfwNP/oLJV5I8dqhFXN3g9J130QycF+9yIU0hSkGmb06YSO95a
         GjH7zEHjF5PK0hYDv2ZSQ0qSMhenLacFdxthQTPKK+iVF68gZmcdqZy7zcEKxKLjqRhJ
         vPng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708085026; x=1708689826;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bQomNEuN4zLjd9Rj3427jBPqEPKhQEI4ZTR/hOCcWaQ=;
        b=FvHE0/gplwZeqHMnaEViXQFUtlOX/kUYx6hgm7neA9SbiSnXPGa4ml9xCCu/CXqITi
         gyb36uWh/KOgHVi/NTcQIkJvWX4m0BR/je/Z9oB1Uwm/268CGeJxc++7PWlIkaDQs+IP
         EFkciwoktlE5ZVYjVhkTeLSK8dojl2E3gEptpoiigQQAXpAcly2CQDAG8qCyjblQHbBc
         cMr8ZyB4ef7k87R2pat/X5jFE8DsZiSeJJBgqEfaJNTvRe5KSXctG/8AXYMEMNkA57YJ
         +J9uzve3cdsgdoLyCoZuZa1qjuDIqvrxipGZQ4JciMg84N7HRIXi+uU+kT5xD9Vi63UA
         Txow==
X-Forwarded-Encrypted: i=1; AJvYcCXh65QF001wPggigpOcOoptf9c42XFnuu0i4Q/ZSOdlIlV8PDiffQ/i1EdWM/vTPmB4QFxZOIAixeo+YJ0vHfsMhWApZANp
X-Gm-Message-State: AOJu0YzWOxyzoKgeFj3vMjZeWwh59MwnW2azaD86Jzd1U08/CfROri0p
	I3HIeAJUSTAJktt91t1W6wragy7a76/YRZQ+0rdldAaJmAXtrIPoCob1cY8NnQ==
X-Google-Smtp-Source: AGHT+IEzH68PTROVHndr4EeW7Q0iWB3XYl0sF0hgYB9Hzlk98IP/HD8DEvazyFP3u6PyeIwuB/kh5A==
X-Received: by 2002:a05:600c:a39e:b0:411:f6b6:faf5 with SMTP id hn30-20020a05600ca39e00b00411f6b6faf5mr169401wmb.3.1708085026031;
        Fri, 16 Feb 2024 04:03:46 -0800 (PST)
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id q4-20020a5d5744000000b0033b47ee01f1sm2011937wrw.49.2024.02.16.04.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Feb 2024 04:03:45 -0800 (PST)
Date: Fri, 16 Feb 2024 12:03:41 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 30/45] iommu/arm-smmu-v3: Move queue and table
 allocation to arm-smmu-v3-common.c
Message-ID: <Zc9PHXEn3IKFlzXZ@google.com>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-31-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201125328.2186498-31-jean-philippe@linaro.org>

Hi Jean,

On Wed, Feb 01, 2023 at 12:53:14PM +0000, Jean-Philippe Brucker wrote:
> Move more code to arm-smmu-v3-common.c, so that the KVM driver can reuse
> it.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   8 +
>  .../arm/arm-smmu-v3/arm-smmu-v3-common.c      | 190 ++++++++++++++++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 215 ++----------------
>  3 files changed, 219 insertions(+), 194 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 59e8101d4ff5..8ab84282f62a 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -277,6 +277,14 @@ bool arm_smmu_capable(struct device *dev, enum iommu_cap cap);
>  struct iommu_group *arm_smmu_device_group(struct device *dev);
>  int arm_smmu_of_xlate(struct device *dev, struct of_phandle_args *args);
>  int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu);
> +int arm_smmu_init_one_queue(struct arm_smmu_device *smmu,
> +			    struct arm_smmu_queue *q,
> +			    void __iomem *page,
> +			    unsigned long prod_off,
> +			    unsigned long cons_off,
> +			    size_t dwords, const char *name);
> +int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid);
I see this is not used by the KVM driver, so it is not needed in the
common file?

> +int arm_smmu_init_strtab(struct arm_smmu_device *smmu);
>  
>  int arm_smmu_write_ctx_desc(struct arm_smmu_domain *smmu_domain, int ssid,
>  			    struct arm_smmu_ctx_desc *cd);
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
> index 5e43329c0826..9226971b6e53 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
> @@ -294,3 +294,193 @@ int arm_smmu_of_xlate(struct device *dev, struct of_phandle_args *args)
>  {
>  	return iommu_fwspec_add_ids(dev, args->args, 1);
>  }
> +
> +int arm_smmu_init_one_queue(struct arm_smmu_device *smmu,
> +			    struct arm_smmu_queue *q,
> +			    void __iomem *page,
> +			    unsigned long prod_off,
> +			    unsigned long cons_off,
> +			    size_t dwords, const char *name)
> +{
> +	size_t qsz;
> +
> +	do {
> +		qsz = ((1 << q->llq.max_n_shift) * dwords) << 3;
> +		q->base = dmam_alloc_coherent(smmu->dev, qsz, &q->base_dma,
> +					      GFP_KERNEL);
> +		if (q->base || qsz < PAGE_SIZE)
> +			break;
> +
> +		q->llq.max_n_shift--;
> +	} while (1);
> +
> +	if (!q->base) {
> +		dev_err(smmu->dev,
> +			"failed to allocate queue (0x%zx bytes) for %s\n",
> +			qsz, name);
> +		return -ENOMEM;
> +	}
> +
> +	if (!WARN_ON(q->base_dma & (qsz - 1))) {
> +		dev_info(smmu->dev, "allocated %u entries for %s\n",
> +			 1 << q->llq.max_n_shift, name);
> +	}
> +
> +	q->prod_reg	= page + prod_off;
> +	q->cons_reg	= page + cons_off;
> +	q->ent_dwords	= dwords;
> +
> +	q->q_base  = Q_BASE_RWA;
> +	q->q_base |= q->base_dma & Q_BASE_ADDR_MASK;
> +	q->q_base |= FIELD_PREP(Q_BASE_LOG2SIZE, q->llq.max_n_shift);
> +
> +	q->llq.prod = q->llq.cons = 0;
> +	return 0;
> +}
> +
> +/* Stream table initialization functions */
> +static void
> +arm_smmu_write_strtab_l1_desc(__le64 *dst, struct arm_smmu_strtab_l1_desc *desc)
> +{
> +	u64 val = 0;
> +
> +	val |= FIELD_PREP(STRTAB_L1_DESC_SPAN, desc->span);
> +	val |= desc->l2ptr_dma & STRTAB_L1_DESC_L2PTR_MASK;
> +
> +	/* Ensure the SMMU sees a zeroed table after reading this pointer */
> +	WRITE_ONCE(*dst, cpu_to_le64(val));
> +}
> +
> +int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
> +{
> +	size_t size;
> +	void *strtab;
> +	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
> +	struct arm_smmu_strtab_l1_desc *desc = &cfg->l1_desc[sid >> STRTAB_SPLIT];
> +
> +	if (desc->l2ptr)
> +		return 0;
> +
> +	size = 1 << (STRTAB_SPLIT + ilog2(STRTAB_STE_DWORDS) + 3);
> +	strtab = &cfg->strtab[(sid >> STRTAB_SPLIT) * STRTAB_L1_DESC_DWORDS];
> +
> +	desc->span = STRTAB_SPLIT + 1;
> +	desc->l2ptr = dmam_alloc_coherent(smmu->dev, size, &desc->l2ptr_dma,
> +					  GFP_KERNEL);
> +	if (!desc->l2ptr) {
> +		dev_err(smmu->dev,
> +			"failed to allocate l2 stream table for SID %u\n",
> +			sid);
> +		return -ENOMEM;
> +	}
> +
> +	arm_smmu_write_strtab_l1_desc(strtab, desc);
> +	return 0;
> +}
> +
> +static int arm_smmu_init_l1_strtab(struct arm_smmu_device *smmu)
> +{
> +	unsigned int i;
> +	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
> +	void *strtab = smmu->strtab_cfg.strtab;
> +
> +	cfg->l1_desc = devm_kcalloc(smmu->dev, cfg->num_l1_ents,
> +				    sizeof(*cfg->l1_desc), GFP_KERNEL);
> +	if (!cfg->l1_desc)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < cfg->num_l1_ents; ++i) {
> +		arm_smmu_write_strtab_l1_desc(strtab, &cfg->l1_desc[i]);
> +		strtab += STRTAB_L1_DESC_DWORDS << 3;
> +	}
> +
> +	return 0;
> +}
> +
> +static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
> +{
> +	void *strtab;
> +	u64 reg;
> +	u32 size, l1size;
> +	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
> +
> +	/* Calculate the L1 size, capped to the SIDSIZE. */
> +	size = STRTAB_L1_SZ_SHIFT - (ilog2(STRTAB_L1_DESC_DWORDS) + 3);
> +	size = min(size, smmu->sid_bits - STRTAB_SPLIT);
> +	cfg->num_l1_ents = 1 << size;
> +
> +	size += STRTAB_SPLIT;
> +	if (size < smmu->sid_bits)
> +		dev_warn(smmu->dev,
> +			 "2-level strtab only covers %u/%u bits of SID\n",
> +			 size, smmu->sid_bits);
> +
> +	l1size = cfg->num_l1_ents * (STRTAB_L1_DESC_DWORDS << 3);
> +	strtab = dmam_alloc_coherent(smmu->dev, l1size, &cfg->strtab_dma,
> +				     GFP_KERNEL);
> +	if (!strtab) {
> +		dev_err(smmu->dev,
> +			"failed to allocate l1 stream table (%u bytes)\n",
> +			l1size);
> +		return -ENOMEM;
> +	}
> +	cfg->strtab = strtab;
> +
> +	/* Configure strtab_base_cfg for 2 levels */
> +	reg  = FIELD_PREP(STRTAB_BASE_CFG_FMT, STRTAB_BASE_CFG_FMT_2LVL);
> +	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE, size);
> +	reg |= FIELD_PREP(STRTAB_BASE_CFG_SPLIT, STRTAB_SPLIT);
> +	cfg->strtab_base_cfg = reg;
> +
> +	return arm_smmu_init_l1_strtab(smmu);
> +}
> +
> +static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
> +{
> +	void *strtab;
> +	u64 reg;
> +	u32 size;
> +	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
> +
> +	size = (1 << smmu->sid_bits) * (STRTAB_STE_DWORDS << 3);
> +	strtab = dmam_alloc_coherent(smmu->dev, size, &cfg->strtab_dma,
> +				     GFP_KERNEL);
> +	if (!strtab) {
> +		dev_err(smmu->dev,
> +			"failed to allocate linear stream table (%u bytes)\n",
> +			size);
> +		return -ENOMEM;
> +	}
> +	cfg->strtab = strtab;
> +	cfg->num_l1_ents = 1 << smmu->sid_bits;
> +
> +	/* Configure strtab_base_cfg for a linear table covering all SIDs */
> +	reg  = FIELD_PREP(STRTAB_BASE_CFG_FMT, STRTAB_BASE_CFG_FMT_LINEAR);
> +	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE, smmu->sid_bits);
> +	cfg->strtab_base_cfg = reg;
> +
> +	return 0;
> +}
> +
> +int arm_smmu_init_strtab(struct arm_smmu_device *smmu)
> +{
> +	u64 reg;
> +	int ret;
> +
> +	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB)
> +		ret = arm_smmu_init_strtab_2lvl(smmu);
> +	else
> +		ret = arm_smmu_init_strtab_linear(smmu);
> +
> +	if (ret)
> +		return ret;
> +
> +	/* Set the strtab base address */
> +	reg  = smmu->strtab_cfg.strtab_dma & STRTAB_BASE_ADDR_MASK;
> +	reg |= STRTAB_BASE_RA;
> +	smmu->strtab_cfg.strtab_base = reg;
> +
> +	/* Allocate the first VMID for stage-2 bypass STEs */
> +	set_bit(0, smmu->vmid_map);
> +	return 0;
> +}
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 08fd79f66d29..2baaf064a324 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1209,18 +1209,6 @@ bool arm_smmu_free_asid(struct arm_smmu_ctx_desc *cd)
>  }
>  
>  /* Stream table manipulation functions */
> -static void
> -arm_smmu_write_strtab_l1_desc(__le64 *dst, struct arm_smmu_strtab_l1_desc *desc)
> -{
> -	u64 val = 0;
> -
> -	val |= FIELD_PREP(STRTAB_L1_DESC_SPAN, desc->span);
> -	val |= desc->l2ptr_dma & STRTAB_L1_DESC_L2PTR_MASK;
> -
> -	/* See comment in arm_smmu_write_ctx_desc() */
> -	WRITE_ONCE(*dst, cpu_to_le64(val));
> -}
> -
>  static void arm_smmu_sync_ste_for_sid(struct arm_smmu_device *smmu, u32 sid)
>  {
>  	struct arm_smmu_cmdq_ent cmd = {
> @@ -1395,34 +1383,6 @@ static void arm_smmu_init_bypass_stes(__le64 *strtab, unsigned int nent, bool fo
>  	}
>  }
>  
> -static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
> -{
> -	size_t size;
> -	void *strtab;
> -	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
> -	struct arm_smmu_strtab_l1_desc *desc = &cfg->l1_desc[sid >> STRTAB_SPLIT];
> -
> -	if (desc->l2ptr)
> -		return 0;
> -
> -	size = 1 << (STRTAB_SPLIT + ilog2(STRTAB_STE_DWORDS) + 3);
> -	strtab = &cfg->strtab[(sid >> STRTAB_SPLIT) * STRTAB_L1_DESC_DWORDS];
> -
> -	desc->span = STRTAB_SPLIT + 1;
> -	desc->l2ptr = dmam_alloc_coherent(smmu->dev, size, &desc->l2ptr_dma,
> -					  GFP_KERNEL);
> -	if (!desc->l2ptr) {
> -		dev_err(smmu->dev,
> -			"failed to allocate l2 stream table for SID %u\n",
> -			sid);
> -		return -ENOMEM;
> -	}
> -
> -	arm_smmu_init_bypass_stes(desc->l2ptr, 1 << STRTAB_SPLIT, false);
> -	arm_smmu_write_strtab_l1_desc(strtab, desc);
> -	return 0;
> -}
> -
>  static struct arm_smmu_master *
>  arm_smmu_find_master(struct arm_smmu_device *smmu, u32 sid)
>  {
> @@ -2515,13 +2475,24 @@ static bool arm_smmu_sid_in_range(struct arm_smmu_device *smmu, u32 sid)
>  
>  static int arm_smmu_init_sid_strtab(struct arm_smmu_device *smmu, u32 sid)
>  {
> +	int ret;
> +
>  	/* Check the SIDs are in range of the SMMU and our stream table */
>  	if (!arm_smmu_sid_in_range(smmu, sid))
>  		return -ERANGE;
>  
>  	/* Ensure l2 strtab is initialised */
> -	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB)
> -		return arm_smmu_init_l2_strtab(smmu, sid);
> +	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
> +		struct arm_smmu_strtab_l1_desc *desc;
> +
> +		ret = arm_smmu_init_l2_strtab(smmu, sid);
> +		if (ret)
> +			return ret;
> +
> +		desc = &smmu->strtab_cfg.l1_desc[sid >> STRTAB_SPLIT];
> +		arm_smmu_init_bypass_stes(desc->l2ptr, 1 << STRTAB_SPLIT,
> +					  false);
> +	}
>  
>  	return 0;
>  }
> @@ -2821,49 +2792,6 @@ static struct iommu_ops arm_smmu_ops = {
>  };
>  
>  /* Probing and initialisation functions */
> -static int arm_smmu_init_one_queue(struct arm_smmu_device *smmu,
> -				   struct arm_smmu_queue *q,
> -				   void __iomem *page,
> -				   unsigned long prod_off,
> -				   unsigned long cons_off,
> -				   size_t dwords, const char *name)
> -{
> -	size_t qsz;
> -
> -	do {
> -		qsz = ((1 << q->llq.max_n_shift) * dwords) << 3;
> -		q->base = dmam_alloc_coherent(smmu->dev, qsz, &q->base_dma,
> -					      GFP_KERNEL);
> -		if (q->base || qsz < PAGE_SIZE)
> -			break;
> -
> -		q->llq.max_n_shift--;
> -	} while (1);
> -
> -	if (!q->base) {
> -		dev_err(smmu->dev,
> -			"failed to allocate queue (0x%zx bytes) for %s\n",
> -			qsz, name);
> -		return -ENOMEM;
> -	}
> -
> -	if (!WARN_ON(q->base_dma & (qsz - 1))) {
> -		dev_info(smmu->dev, "allocated %u entries for %s\n",
> -			 1 << q->llq.max_n_shift, name);
> -	}
> -
> -	q->prod_reg	= page + prod_off;
> -	q->cons_reg	= page + cons_off;
> -	q->ent_dwords	= dwords;
> -
> -	q->q_base  = Q_BASE_RWA;
> -	q->q_base |= q->base_dma & Q_BASE_ADDR_MASK;
> -	q->q_base |= FIELD_PREP(Q_BASE_LOG2SIZE, q->llq.max_n_shift);
> -
> -	q->llq.prod = q->llq.cons = 0;
> -	return 0;
> -}
> -
>  static int arm_smmu_cmdq_init(struct arm_smmu_device *smmu)
>  {
>  	struct arm_smmu_cmdq *cmdq = &smmu->cmdq;
> @@ -2918,114 +2846,6 @@ static int arm_smmu_init_queues(struct arm_smmu_device *smmu)
>  				       PRIQ_ENT_DWORDS, "priq");
>  }
>  
> -static int arm_smmu_init_l1_strtab(struct arm_smmu_device *smmu)
> -{
> -	unsigned int i;
> -	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
> -	void *strtab = smmu->strtab_cfg.strtab;
> -
> -	cfg->l1_desc = devm_kcalloc(smmu->dev, cfg->num_l1_ents,
> -				    sizeof(*cfg->l1_desc), GFP_KERNEL);
> -	if (!cfg->l1_desc)
> -		return -ENOMEM;
> -
> -	for (i = 0; i < cfg->num_l1_ents; ++i) {
> -		arm_smmu_write_strtab_l1_desc(strtab, &cfg->l1_desc[i]);
> -		strtab += STRTAB_L1_DESC_DWORDS << 3;
> -	}
> -
> -	return 0;
> -}
> -
> -static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
> -{
> -	void *strtab;
> -	u64 reg;
> -	u32 size, l1size;
> -	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
> -
> -	/* Calculate the L1 size, capped to the SIDSIZE. */
> -	size = STRTAB_L1_SZ_SHIFT - (ilog2(STRTAB_L1_DESC_DWORDS) + 3);
> -	size = min(size, smmu->sid_bits - STRTAB_SPLIT);
> -	cfg->num_l1_ents = 1 << size;
> -
> -	size += STRTAB_SPLIT;
> -	if (size < smmu->sid_bits)
> -		dev_warn(smmu->dev,
> -			 "2-level strtab only covers %u/%u bits of SID\n",
> -			 size, smmu->sid_bits);
> -
> -	l1size = cfg->num_l1_ents * (STRTAB_L1_DESC_DWORDS << 3);
> -	strtab = dmam_alloc_coherent(smmu->dev, l1size, &cfg->strtab_dma,
> -				     GFP_KERNEL);
> -	if (!strtab) {
> -		dev_err(smmu->dev,
> -			"failed to allocate l1 stream table (%u bytes)\n",
> -			l1size);
> -		return -ENOMEM;
> -	}
> -	cfg->strtab = strtab;
> -
> -	/* Configure strtab_base_cfg for 2 levels */
> -	reg  = FIELD_PREP(STRTAB_BASE_CFG_FMT, STRTAB_BASE_CFG_FMT_2LVL);
> -	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE, size);
> -	reg |= FIELD_PREP(STRTAB_BASE_CFG_SPLIT, STRTAB_SPLIT);
> -	cfg->strtab_base_cfg = reg;
> -
> -	return arm_smmu_init_l1_strtab(smmu);
> -}
> -
> -static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
> -{
> -	void *strtab;
> -	u64 reg;
> -	u32 size;
> -	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
> -
> -	size = (1 << smmu->sid_bits) * (STRTAB_STE_DWORDS << 3);
> -	strtab = dmam_alloc_coherent(smmu->dev, size, &cfg->strtab_dma,
> -				     GFP_KERNEL);
> -	if (!strtab) {
> -		dev_err(smmu->dev,
> -			"failed to allocate linear stream table (%u bytes)\n",
> -			size);
> -		return -ENOMEM;
> -	}
> -	cfg->strtab = strtab;
> -	cfg->num_l1_ents = 1 << smmu->sid_bits;
> -
> -	/* Configure strtab_base_cfg for a linear table covering all SIDs */
> -	reg  = FIELD_PREP(STRTAB_BASE_CFG_FMT, STRTAB_BASE_CFG_FMT_LINEAR);
> -	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE, smmu->sid_bits);
> -	cfg->strtab_base_cfg = reg;
> -
> -	arm_smmu_init_bypass_stes(strtab, cfg->num_l1_ents, false);
> -	return 0;
> -}
> -
> -static int arm_smmu_init_strtab(struct arm_smmu_device *smmu)
> -{
> -	u64 reg;
> -	int ret;
> -
> -	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB)
> -		ret = arm_smmu_init_strtab_2lvl(smmu);
> -	else
> -		ret = arm_smmu_init_strtab_linear(smmu);
> -
> -	if (ret)
> -		return ret;
> -
> -	/* Set the strtab base address */
> -	reg  = smmu->strtab_cfg.strtab_dma & STRTAB_BASE_ADDR_MASK;
> -	reg |= STRTAB_BASE_RA;
> -	smmu->strtab_cfg.strtab_base = reg;
> -
> -	/* Allocate the first VMID for stage-2 bypass STEs */
> -	set_bit(0, smmu->vmid_map);
> -	return 0;
> -}
> -
>  static int arm_smmu_init_structures(struct arm_smmu_device *smmu)
>  {
>  	int ret;
> @@ -3037,7 +2857,14 @@ static int arm_smmu_init_structures(struct arm_smmu_device *smmu)
>  	if (ret)
>  		return ret;
>  
> -	return arm_smmu_init_strtab(smmu);
> +	ret = arm_smmu_init_strtab(smmu);
> +	if (ret)
> +		return ret;
> +
> +	if (!(smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB))
> +		arm_smmu_init_bypass_stes(smmu->strtab_cfg.strtab,
> +					  smmu->strtab_cfg.num_l1_ents, false);
> +	return 0;
>  }
>  
>  static void arm_smmu_free_msis(void *data)
> -- 
> 2.39.0
>
Thanks,
Mostafa
