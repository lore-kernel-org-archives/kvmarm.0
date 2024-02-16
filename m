Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1559877F32
	for <kvmarm@lists.linux.dev>; Fri, 16 Feb 2024 11:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708084531; cv=none; b=bLIq1JEV+vc5oS0H3CPzcIi076Yb5pwCeTDyA4UL8sXoi8sWS3tEhk8XyD8uMChy9FhrWM4HFJeOtGUegxK1rKb3XF0siu9xHWjeAL0cuHWw20RXo1e2FwUg7JH7hQoOLtBS7pUWBdqkWpzhJ4DGxsP5VCgGxbhrK4GCTGIJd/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708084531; c=relaxed/simple;
	bh=T4D6/Piyu6IikGZoL+b3jOd61/0gMzSt0UhKn/vxbMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FL7xs1Pht/Z4hxKReRPw9X2rpjP7G5EKcrAO5VLgq+kSuTzYKe8npNXuT4KNPX+cdXuOAV+eE1lSFl66fJKaB7Njo0O0cgXrA3NukN0GFZE4kjxDQ6u9EvTre6UesM9BHz5TqFAbu3g4bUDf6pmttJtTqfDHQsuC7jdlgE4MpzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IpvbCafi; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IpvbCafi"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-561f0f116ecso6847a12.0
        for <kvmarm@lists.linux.dev>; Fri, 16 Feb 2024 03:55:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708084526; x=1708689326; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Axw59d2IDSLC+kV1vwOEGMpOKoShadCkXfjBVzqolmc=;
        b=IpvbCafi+jrYAoGLQKCrzFjMGjv0SlThIkAzcyijWZSzM1yVr1sK4Kpm6+jVYEcbcK
         tFONOTmX2yXWMKARQXRXbv0dmemSCRv0Npe/4blFyxHQq7n47AtJI5wgPiAB67DlHmKy
         cWJue+ke3EPXzU1N7WCyUDyLW4WinErMNQdKusM62KVvSAgzC3zvyloRpxc7mB0VkgLV
         p4fMWM/9Sw3NwuBZ9/p7weD0nAc/rT5DocFo9hNz9BUGN9VZgG2vyGsqxJIODifZAfOL
         a0umPWtAeteB3iKbNGySHiChD/LKhswlstHVOb0ozRKkyLjLGlwigipu787X6/+TP3CW
         yynQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708084526; x=1708689326;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Axw59d2IDSLC+kV1vwOEGMpOKoShadCkXfjBVzqolmc=;
        b=pZ9XhbCzxmStVqdOtZczXGS1ZRoX2BfX9MrcjI0yPheE4/zwgKMQt7vYmhtyxeuX17
         KBaONP5vyYUJ36P47tX6DwAyPo1XgapzP08dgYUC7e2F8/KfKO3KB/VAUWf65I2czV6l
         hAXo4IR4RDbRDjAk+gjL2ewdg44cFanxpBU4xf7QrBDPc3CHVSBFFfBs6aNNYq3JH/Re
         wa16RI9bk7y6Hn8P21YNQ8t8NKy6Pr+/KOqVU4gKIhxzTyStuRXSuOLRkmVaX1x9Ux1G
         kqxYwjaNDw9NR8hehLu52N7TohjiDXAUWAfz4rBcnlx4SnSEc1U9GdEfGW0q7LJUeSli
         zS1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXAt2A/zgR//ASYnjYpNJ5HJ4Tjrii7kSdTKFGjEv3rHhrrDCSAS8p4UOSqmLrUzmP0Rh7EcMzjlTzC7Zd3k7ut2QUPu87S
X-Gm-Message-State: AOJu0YyLOSzKJ+hjWvbMC8J3d2RKg6d5oYO63jKj1iDZ5qek+QNgCNtZ
	e5SjAm0+rWFIf2MscGNy8k9I6iw4jDSd8iCSI70xD+izONaSIBEskl6MO6V0hg==
X-Google-Smtp-Source: AGHT+IGFsinfgdhdXWDWfmRdFKozcZs9X9ozkR7Mm/lekagrUm1i81Tl1NTQONdQgOpEiQ9FXbweSQ==
X-Received: by 2002:a50:aadb:0:b0:563:c0e0:667c with SMTP id r27-20020a50aadb000000b00563c0e0667cmr154846edc.0.1708084525910;
        Fri, 16 Feb 2024 03:55:25 -0800 (PST)
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id u19-20020a7bc053000000b00411e75eb83fsm2065620wmc.18.2024.02.16.03.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Feb 2024 03:55:25 -0800 (PST)
Date: Fri, 16 Feb 2024 11:55:21 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 03/45] iommu/io-pgtable: Move fmt into io_pgtable_cfg
Message-ID: <Zc9NKU18_uF4XHWY@google.com>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-4-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201125328.2186498-4-jean-philippe@linaro.org>

Hi Jean,

On Wed, Feb 01, 2023 at 12:52:47PM +0000, Jean-Philippe Brucker wrote:
> When passing the I/O pagetable configuration around and adding new
> operations, it will be slightly more convenient to have fmt be part of
> the config structure rather than a separate parameter.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  include/linux/io-pgtable.h                  |  8 +++----
>  drivers/gpu/drm/msm/msm_iommu.c             |  3 +--
>  drivers/gpu/drm/panfrost/panfrost_mmu.c     |  4 ++--
>  drivers/iommu/amd/iommu.c                   |  3 ++-
>  drivers/iommu/apple-dart.c                  |  4 ++--
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  3 ++-
>  drivers/iommu/arm/arm-smmu/arm-smmu.c       |  3 ++-
>  drivers/iommu/arm/arm-smmu/qcom_iommu.c     |  3 ++-
>  drivers/iommu/io-pgtable-arm-common.c       | 26 ++++++++++-----------
>  drivers/iommu/io-pgtable-arm-v7s.c          |  3 ++-
>  drivers/iommu/io-pgtable-arm.c              |  3 ++-
>  drivers/iommu/io-pgtable-dart.c             |  8 +++----
>  drivers/iommu/io-pgtable.c                  | 10 ++++----
>  drivers/iommu/ipmmu-vmsa.c                  |  4 ++--
>  drivers/iommu/msm_iommu.c                   |  3 ++-
>  drivers/iommu/mtk_iommu.c                   |  3 ++-
>  16 files changed, 47 insertions(+), 44 deletions(-)
> 
> diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
> index 1b7a44b35616..1b0c26241a78 100644
> --- a/include/linux/io-pgtable.h
> +++ b/include/linux/io-pgtable.h
> @@ -49,6 +49,7 @@ struct iommu_flush_ops {
>  /**
>   * struct io_pgtable_cfg - Configuration data for a set of page tables.
>   *
> + * @fmt	           Format used for these page tables
>   * @quirks:        A bitmap of hardware quirks that require some special
>   *                 action by the low-level page table allocator.
>   * @pgsize_bitmap: A bitmap of page sizes supported by this set of page
> @@ -62,6 +63,7 @@ struct iommu_flush_ops {
>   *                 page table walker.
>   */
>  struct io_pgtable_cfg {
> +	enum io_pgtable_fmt		fmt;
>  	/*
>  	 * IO_PGTABLE_QUIRK_ARM_NS: (ARM formats) Set NS and NSTABLE bits in
>  	 *	stage 1 PTEs, for hardware which insists on validating them
> @@ -171,15 +173,13 @@ struct io_pgtable_ops {
>  /**
>   * alloc_io_pgtable_ops() - Allocate a page table allocator for use by an IOMMU.
>   *
> - * @fmt:    The page table format.
>   * @cfg:    The page table configuration. This will be modified to represent
>   *          the configuration actually provided by the allocator (e.g. the
>   *          pgsize_bitmap may be restricted).
>   * @cookie: An opaque token provided by the IOMMU driver and passed back to
>   *          the callback routines in cfg->tlb.
>   */
> -struct io_pgtable_ops *alloc_io_pgtable_ops(enum io_pgtable_fmt fmt,
> -					    struct io_pgtable_cfg *cfg,
> +struct io_pgtable_ops *alloc_io_pgtable_ops(struct io_pgtable_cfg *cfg,
>  					    void *cookie);
>  
>  /**
> @@ -199,14 +199,12 @@ void free_io_pgtable_ops(struct io_pgtable_ops *ops);
>  /**
>   * struct io_pgtable - Internal structure describing a set of page tables.
>   *
> - * @fmt:    The page table format.
>   * @cookie: An opaque token provided by the IOMMU driver and passed back to
>   *          any callback routines.
>   * @cfg:    A copy of the page table configuration.
>   * @ops:    The page table operations in use for this set of page tables.
>   */
>  struct io_pgtable {
> -	enum io_pgtable_fmt	fmt;
>  	void			*cookie;
>  	struct io_pgtable_cfg	cfg;
>  	struct io_pgtable_ops	ops;
> diff --git a/drivers/gpu/drm/msm/msm_iommu.c b/drivers/gpu/drm/msm/msm_iommu.c
> index c2507582ecf3..e9c6f281e3dd 100644
> --- a/drivers/gpu/drm/msm/msm_iommu.c
> +++ b/drivers/gpu/drm/msm/msm_iommu.c
> @@ -258,8 +258,7 @@ struct msm_mmu *msm_iommu_pagetable_create(struct msm_mmu *parent)
>  	ttbr0_cfg.quirks &= ~IO_PGTABLE_QUIRK_ARM_TTBR1;
>  	ttbr0_cfg.tlb = &null_tlb_ops;
>  
> -	pagetable->pgtbl_ops = alloc_io_pgtable_ops(ARM_64_LPAE_S1,
> -		&ttbr0_cfg, iommu->domain);
This seems to miss:
+	ttbr0_cfg.fmt = ARM_64_LPAE_S1;
> +	pagetable->pgtbl_ops = alloc_io_pgtable_ops(&ttbr0_cfg, iommu->domain);
>  
>  	if (!pagetable->pgtbl_ops) {
>  		kfree(pagetable);
> diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
> index 4e83a1891f3e..31bdb5d46244 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
> @@ -622,6 +622,7 @@ struct panfrost_mmu *panfrost_mmu_ctx_create(struct panfrost_device *pfdev)
>  	mmu->as = -1;
>  
>  	mmu->pgtbl_cfg = (struct io_pgtable_cfg) {
> +		.fmt		= ARM_MALI_LPAE,
>  		.pgsize_bitmap	= SZ_4K | SZ_2M,
>  		.ias		= FIELD_GET(0xff, pfdev->features.mmu_features),
>  		.oas		= FIELD_GET(0xff00, pfdev->features.mmu_features),
> @@ -630,8 +631,7 @@ struct panfrost_mmu *panfrost_mmu_ctx_create(struct panfrost_device *pfdev)
>  		.iommu_dev	= pfdev->dev,
>  	};
>  
> -	mmu->pgtbl_ops = alloc_io_pgtable_ops(ARM_MALI_LPAE, &mmu->pgtbl_cfg,
> -					      mmu);
> +	mmu->pgtbl_ops = alloc_io_pgtable_ops(&mmu->pgtbl_cfg, mmu);
>  	if (!mmu->pgtbl_ops) {
>  		kfree(mmu);
>  		return ERR_PTR(-EINVAL);
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index cbeaab55c0db..7efb6b467041 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -2072,7 +2072,8 @@ static struct protection_domain *protection_domain_alloc(unsigned int type)
>  	if (ret)
>  		goto out_err;
>  
> -	pgtbl_ops = alloc_io_pgtable_ops(pgtable, &domain->iop.pgtbl_cfg, domain);
> +	domain->iop.pgtbl_cfg.fmt = pgtable;
> +	pgtbl_ops = alloc_io_pgtable_ops(&domain->iop.pgtbl_cfg, domain);
>  	if (!pgtbl_ops) {
>  		domain_id_free(domain->id);
>  		goto out_err;
> diff --git a/drivers/iommu/apple-dart.c b/drivers/iommu/apple-dart.c
> index 4f4a323be0d0..571f948add7c 100644
> --- a/drivers/iommu/apple-dart.c
> +++ b/drivers/iommu/apple-dart.c
> @@ -427,6 +427,7 @@ static int apple_dart_finalize_domain(struct iommu_domain *domain,
>  	}
>  
>  	pgtbl_cfg = (struct io_pgtable_cfg){
> +		.fmt = dart->hw->fmt,
>  		.pgsize_bitmap = dart->pgsize,
>  		.ias = 32,
>  		.oas = dart->hw->oas,
> @@ -434,8 +435,7 @@ static int apple_dart_finalize_domain(struct iommu_domain *domain,
>  		.iommu_dev = dart->dev,
>  	};
>  
> -	dart_domain->pgtbl_ops =
> -		alloc_io_pgtable_ops(dart->hw->fmt, &pgtbl_cfg, domain);
> +	dart_domain->pgtbl_ops = alloc_io_pgtable_ops(&pgtbl_cfg, domain);
>  	if (!dart_domain->pgtbl_ops) {
>  		ret = -ENOMEM;
>  		goto done;
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index ab160198edd6..c033b23ca4b2 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2209,6 +2209,7 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain,
>  	}
>  
>  	pgtbl_cfg = (struct io_pgtable_cfg) {
> +		.fmt		= fmt,
>  		.pgsize_bitmap	= smmu->pgsize_bitmap,
>  		.ias		= ias,
>  		.oas		= oas,
> @@ -2217,7 +2218,7 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain,
>  		.iommu_dev	= smmu->dev,
>  	};
>  
> -	pgtbl_ops = alloc_io_pgtable_ops(fmt, &pgtbl_cfg, smmu_domain);
> +	pgtbl_ops = alloc_io_pgtable_ops(&pgtbl_cfg, smmu_domain);
>  	if (!pgtbl_ops)
>  		return -ENOMEM;
>  
> diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
> index 719fbca1fe52..f230d2ce977a 100644
> --- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
> +++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
> @@ -747,6 +747,7 @@ static int arm_smmu_init_domain_context(struct iommu_domain *domain,
>  		cfg->asid = cfg->cbndx;
>  
>  	pgtbl_cfg = (struct io_pgtable_cfg) {
> +		.fmt		= fmt,
>  		.pgsize_bitmap	= smmu->pgsize_bitmap,
>  		.ias		= ias,
>  		.oas		= oas,
> @@ -764,7 +765,7 @@ static int arm_smmu_init_domain_context(struct iommu_domain *domain,
>  	if (smmu_domain->pgtbl_quirks)
>  		pgtbl_cfg.quirks |= smmu_domain->pgtbl_quirks;
>  
> -	pgtbl_ops = alloc_io_pgtable_ops(fmt, &pgtbl_cfg, smmu_domain);
> +	pgtbl_ops = alloc_io_pgtable_ops(&pgtbl_cfg, smmu_domain);
>  	if (!pgtbl_ops) {
>  		ret = -ENOMEM;
>  		goto out_clear_smmu;
> diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
> index 270c3d9128ba..65eb8bdcbe50 100644
> --- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
> +++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
> @@ -239,6 +239,7 @@ static int qcom_iommu_init_domain(struct iommu_domain *domain,
>  		goto out_unlock;
>  
>  	pgtbl_cfg = (struct io_pgtable_cfg) {
> +		.fmt		= ARM_32_LPAE_S1,
>  		.pgsize_bitmap	= qcom_iommu_ops.pgsize_bitmap,
>  		.ias		= 32,
>  		.oas		= 40,
> @@ -249,7 +250,7 @@ static int qcom_iommu_init_domain(struct iommu_domain *domain,
>  	qcom_domain->iommu = qcom_iommu;
>  	qcom_domain->fwspec = fwspec;
>  
> -	pgtbl_ops = alloc_io_pgtable_ops(ARM_32_LPAE_S1, &pgtbl_cfg, qcom_domain);
> +	pgtbl_ops = alloc_io_pgtable_ops(&pgtbl_cfg, qcom_domain);
>  	if (!pgtbl_ops) {
>  		dev_err(qcom_iommu->dev, "failed to allocate pagetable ops\n");
>  		ret = -ENOMEM;
> diff --git a/drivers/iommu/io-pgtable-arm-common.c b/drivers/iommu/io-pgtable-arm-common.c
> index 7340b5096499..4b3a9ce806ea 100644
> --- a/drivers/iommu/io-pgtable-arm-common.c
> +++ b/drivers/iommu/io-pgtable-arm-common.c
> @@ -62,7 +62,7 @@ static void __arm_lpae_init_pte(struct arm_lpae_io_pgtable *data,
>  	size_t sz = ARM_LPAE_BLOCK_SIZE(lvl, data);
>  	int i;
>  
> -	if (data->iop.fmt != ARM_MALI_LPAE && lvl == ARM_LPAE_MAX_LEVELS - 1)
> +	if (data->iop.cfg.fmt != ARM_MALI_LPAE && lvl == ARM_LPAE_MAX_LEVELS - 1)
>  		pte |= ARM_LPAE_PTE_TYPE_PAGE;
>  	else
>  		pte |= ARM_LPAE_PTE_TYPE_BLOCK;
> @@ -82,7 +82,7 @@ static int arm_lpae_init_pte(struct arm_lpae_io_pgtable *data,
>  	int i;
>  
>  	for (i = 0; i < num_entries; i++)
> -		if (iopte_leaf(ptep[i], lvl, data->iop.fmt)) {
> +		if (iopte_leaf(ptep[i], lvl, data->iop.cfg.fmt)) {
>  			/* We require an unmap first */
>  			WARN_ON(!selftest_running);
>  			return -EEXIST;
> @@ -183,7 +183,7 @@ int __arm_lpae_map(struct arm_lpae_io_pgtable *data, unsigned long iova,
>  		__arm_lpae_sync_pte(ptep, 1, cfg);
>  	}
>  
> -	if (pte && !iopte_leaf(pte, lvl, data->iop.fmt)) {
> +	if (pte && !iopte_leaf(pte, lvl, data->iop.cfg.fmt)) {
>  		cptep = iopte_deref(pte, data);
>  	} else if (pte) {
>  		/* We require an unmap first */
> @@ -201,8 +201,8 @@ static arm_lpae_iopte arm_lpae_prot_to_pte(struct arm_lpae_io_pgtable *data,
>  {
>  	arm_lpae_iopte pte;
>  
> -	if (data->iop.fmt == ARM_64_LPAE_S1 ||
> -	    data->iop.fmt == ARM_32_LPAE_S1) {
> +	if (data->iop.cfg.fmt == ARM_64_LPAE_S1 ||
> +	    data->iop.cfg.fmt == ARM_32_LPAE_S1) {
>  		pte = ARM_LPAE_PTE_nG;
>  		if (!(prot & IOMMU_WRITE) && (prot & IOMMU_READ))
>  			pte |= ARM_LPAE_PTE_AP_RDONLY;
> @@ -220,8 +220,8 @@ static arm_lpae_iopte arm_lpae_prot_to_pte(struct arm_lpae_io_pgtable *data,
>  	 * Note that this logic is structured to accommodate Mali LPAE
>  	 * having stage-1-like attributes but stage-2-like permissions.
>  	 */
> -	if (data->iop.fmt == ARM_64_LPAE_S2 ||
> -	    data->iop.fmt == ARM_32_LPAE_S2) {
> +	if (data->iop.cfg.fmt == ARM_64_LPAE_S2 ||
> +	    data->iop.cfg.fmt == ARM_32_LPAE_S2) {
>  		if (prot & IOMMU_MMIO)
>  			pte |= ARM_LPAE_PTE_MEMATTR_DEV;
>  		else if (prot & IOMMU_CACHE)
> @@ -243,7 +243,7 @@ static arm_lpae_iopte arm_lpae_prot_to_pte(struct arm_lpae_io_pgtable *data,
>  	 * "outside the GPU" (i.e. either the Inner or System domain in CPU
>  	 * terms, depending on coherency).
>  	 */
> -	if (prot & IOMMU_CACHE && data->iop.fmt != ARM_MALI_LPAE)
> +	if (prot & IOMMU_CACHE && data->iop.cfg.fmt != ARM_MALI_LPAE)
>  		pte |= ARM_LPAE_PTE_SH_IS;
>  	else
>  		pte |= ARM_LPAE_PTE_SH_OS;
> @@ -254,7 +254,7 @@ static arm_lpae_iopte arm_lpae_prot_to_pte(struct arm_lpae_io_pgtable *data,
>  	if (data->iop.cfg.quirks & IO_PGTABLE_QUIRK_ARM_NS)
>  		pte |= ARM_LPAE_PTE_NS;
>  
> -	if (data->iop.fmt != ARM_MALI_LPAE)
> +	if (data->iop.cfg.fmt != ARM_MALI_LPAE)
>  		pte |= ARM_LPAE_PTE_AF;
>  
>  	return pte;
> @@ -317,7 +317,7 @@ void __arm_lpae_free_pgtable(struct arm_lpae_io_pgtable *data, int lvl,
>  	while (ptep != end) {
>  		arm_lpae_iopte pte = *ptep++;
>  
> -		if (!pte || iopte_leaf(pte, lvl, data->iop.fmt))
> +		if (!pte || iopte_leaf(pte, lvl, data->iop.cfg.fmt))
>  			continue;
>  
>  		__arm_lpae_free_pgtable(data, lvl + 1, iopte_deref(pte, data));
> @@ -417,7 +417,7 @@ static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
>  
>  			__arm_lpae_clear_pte(ptep, &iop->cfg);
>  
> -			if (!iopte_leaf(pte, lvl, iop->fmt)) {
> +			if (!iopte_leaf(pte, lvl, iop->cfg.fmt)) {
>  				/* Also flush any partial walks */
>  				io_pgtable_tlb_flush_walk(iop, iova + i * size, size,
>  							  ARM_LPAE_GRANULE(data));
> @@ -431,7 +431,7 @@ static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
>  		}
>  
>  		return i * size;
> -	} else if (iopte_leaf(pte, lvl, iop->fmt)) {
> +	} else if (iopte_leaf(pte, lvl, iop->cfg.fmt)) {
>  		/*
>  		 * Insert a table at the next level to map the old region,
>  		 * minus the part we want to unmap
> @@ -487,7 +487,7 @@ phys_addr_t arm_lpae_iova_to_phys(struct io_pgtable_ops *ops,
>  			return 0;
>  
>  		/* Leaf entry? */
> -		if (iopte_leaf(pte, lvl, data->iop.fmt))
> +		if (iopte_leaf(pte, lvl, data->iop.cfg.fmt))
>  			goto found_translation;
>  
>  		/* Take it to the next level */
> diff --git a/drivers/iommu/io-pgtable-arm-v7s.c b/drivers/iommu/io-pgtable-arm-v7s.c
> index 75f244a3e12d..278b4299d757 100644
> --- a/drivers/iommu/io-pgtable-arm-v7s.c
> +++ b/drivers/iommu/io-pgtable-arm-v7s.c
> @@ -930,6 +930,7 @@ static int __init arm_v7s_do_selftests(void)
>  {
>  	struct io_pgtable_ops *ops;
>  	struct io_pgtable_cfg cfg = {
> +		.fmt = ARM_V7S,
>  		.tlb = &dummy_tlb_ops,
>  		.oas = 32,
>  		.ias = 32,
> @@ -945,7 +946,7 @@ static int __init arm_v7s_do_selftests(void)
>  
>  	cfg_cookie = &cfg;
>  
> -	ops = alloc_io_pgtable_ops(ARM_V7S, &cfg, &cfg);
> +	ops = alloc_io_pgtable_ops(&cfg, &cfg);
>  	if (!ops) {
>  		pr_err("selftest: failed to allocate io pgtable ops\n");
>  		return -EINVAL;
> diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
> index b2b188bb86b3..b76b903400de 100644
> --- a/drivers/iommu/io-pgtable-arm.c
> +++ b/drivers/iommu/io-pgtable-arm.c
> @@ -319,7 +319,8 @@ static int __init arm_lpae_run_tests(struct io_pgtable_cfg *cfg)
>  
>  	for (i = 0; i < ARRAY_SIZE(fmts); ++i) {
>  		cfg_cookie = cfg;
> -		ops = alloc_io_pgtable_ops(fmts[i], cfg, cfg);
> +		cfg->fmt = fmts[i];
> +		ops = alloc_io_pgtable_ops(cfg, cfg);
>  		if (!ops) {
>  			pr_err("selftest: failed to allocate io pgtable ops\n");
>  			return -ENOMEM;
> diff --git a/drivers/iommu/io-pgtable-dart.c b/drivers/iommu/io-pgtable-dart.c
> index 74b1ef2b96be..f981b25d8c98 100644
> --- a/drivers/iommu/io-pgtable-dart.c
> +++ b/drivers/iommu/io-pgtable-dart.c
> @@ -81,7 +81,7 @@ static dart_iopte paddr_to_iopte(phys_addr_t paddr,
>  {
>  	dart_iopte pte;
>  
> -	if (data->iop.fmt == APPLE_DART)
> +	if (data->iop.cfg.fmt == APPLE_DART)
>  		return paddr & APPLE_DART1_PADDR_MASK;
>  
>  	/* format is APPLE_DART2 */
> @@ -96,7 +96,7 @@ static phys_addr_t iopte_to_paddr(dart_iopte pte,
>  {
>  	u64 paddr;
>  
> -	if (data->iop.fmt == APPLE_DART)
> +	if (data->iop.cfg.fmt == APPLE_DART)
>  		return pte & APPLE_DART1_PADDR_MASK;
>  
>  	/* format is APPLE_DART2 */
> @@ -215,13 +215,13 @@ static dart_iopte dart_prot_to_pte(struct dart_io_pgtable *data,
>  {
>  	dart_iopte pte = 0;
>  
> -	if (data->iop.fmt == APPLE_DART) {
> +	if (data->iop.cfg.fmt == APPLE_DART) {
>  		if (!(prot & IOMMU_WRITE))
>  			pte |= APPLE_DART1_PTE_PROT_NO_WRITE;
>  		if (!(prot & IOMMU_READ))
>  			pte |= APPLE_DART1_PTE_PROT_NO_READ;
>  	}
> -	if (data->iop.fmt == APPLE_DART2) {
> +	if (data->iop.cfg.fmt == APPLE_DART2) {
>  		if (!(prot & IOMMU_WRITE))
>  			pte |= APPLE_DART2_PTE_PROT_NO_WRITE;
>  		if (!(prot & IOMMU_READ))
> diff --git a/drivers/iommu/io-pgtable.c b/drivers/iommu/io-pgtable.c
> index b843fcd365d2..79e459f95012 100644
> --- a/drivers/iommu/io-pgtable.c
> +++ b/drivers/iommu/io-pgtable.c
> @@ -34,17 +34,16 @@ io_pgtable_init_table[IO_PGTABLE_NUM_FMTS] = {
>  #endif
>  };
>  
> -struct io_pgtable_ops *alloc_io_pgtable_ops(enum io_pgtable_fmt fmt,
> -					    struct io_pgtable_cfg *cfg,
> +struct io_pgtable_ops *alloc_io_pgtable_ops(struct io_pgtable_cfg *cfg,
>  					    void *cookie)
>  {
>  	struct io_pgtable *iop;
>  	const struct io_pgtable_init_fns *fns;
>  
> -	if (fmt >= IO_PGTABLE_NUM_FMTS)
> +	if (cfg->fmt >= IO_PGTABLE_NUM_FMTS)
>  		return NULL;
>  
> -	fns = io_pgtable_init_table[fmt];
> +	fns = io_pgtable_init_table[cfg->fmt];
>  	if (!fns)
>  		return NULL;
>  
> @@ -52,7 +51,6 @@ struct io_pgtable_ops *alloc_io_pgtable_ops(enum io_pgtable_fmt fmt,
>  	if (!iop)
>  		return NULL;
>  
> -	iop->fmt	= fmt;
>  	iop->cookie	= cookie;
>  	iop->cfg	= *cfg;
>  
> @@ -73,6 +71,6 @@ void free_io_pgtable_ops(struct io_pgtable_ops *ops)
>  
>  	iop = io_pgtable_ops_to_pgtable(ops);
>  	io_pgtable_tlb_flush_all(iop);
> -	io_pgtable_init_table[iop->fmt]->free(iop);
> +	io_pgtable_init_table[iop->cfg.fmt]->free(iop);
>  }
>  EXPORT_SYMBOL_GPL(free_io_pgtable_ops);
> diff --git a/drivers/iommu/ipmmu-vmsa.c b/drivers/iommu/ipmmu-vmsa.c
> index a003bd5fc65c..4a1927489635 100644
> --- a/drivers/iommu/ipmmu-vmsa.c
> +++ b/drivers/iommu/ipmmu-vmsa.c
> @@ -447,6 +447,7 @@ static int ipmmu_domain_init_context(struct ipmmu_vmsa_domain *domain)
>  	 */
>  	domain->cfg.coherent_walk = false;
>  	domain->cfg.iommu_dev = domain->mmu->root->dev;
> +	domain->cfg.fmt = ARM_32_LPAE_S1;
>  
>  	/*
>  	 * Find an unused context.
> @@ -457,8 +458,7 @@ static int ipmmu_domain_init_context(struct ipmmu_vmsa_domain *domain)
>  
>  	domain->context_id = ret;
>  
> -	domain->iop = alloc_io_pgtable_ops(ARM_32_LPAE_S1, &domain->cfg,
> -					   domain);
> +	domain->iop = alloc_io_pgtable_ops(&domain->cfg, domain);
>  	if (!domain->iop) {
>  		ipmmu_domain_free_context(domain->mmu->root,
>  					  domain->context_id);
> diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
> index c60624910872..2c05a84ec1bf 100644
> --- a/drivers/iommu/msm_iommu.c
> +++ b/drivers/iommu/msm_iommu.c
> @@ -342,6 +342,7 @@ static int msm_iommu_domain_config(struct msm_priv *priv)
>  	spin_lock_init(&priv->pgtlock);
>  
>  	priv->cfg = (struct io_pgtable_cfg) {
> +		.fmt = ARM_V7S,
>  		.pgsize_bitmap = msm_iommu_ops.pgsize_bitmap,
>  		.ias = 32,
>  		.oas = 32,
> @@ -349,7 +350,7 @@ static int msm_iommu_domain_config(struct msm_priv *priv)
>  		.iommu_dev = priv->dev,
>  	};
>  
> -	priv->iop = alloc_io_pgtable_ops(ARM_V7S, &priv->cfg, priv);
> +	priv->iop = alloc_io_pgtable_ops(&priv->cfg, priv);
>  	if (!priv->iop) {
>  		dev_err(priv->dev, "Failed to allocate pgtable\n");
>  		return -EINVAL;
> diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
> index 2badd6acfb23..0d754d94ae52 100644
> --- a/drivers/iommu/mtk_iommu.c
> +++ b/drivers/iommu/mtk_iommu.c
> @@ -598,6 +598,7 @@ static int mtk_iommu_domain_finalise(struct mtk_iommu_domain *dom,
>  	}
>  
>  	dom->cfg = (struct io_pgtable_cfg) {
> +		.fmt = ARM_V7S,
>  		.quirks = IO_PGTABLE_QUIRK_ARM_NS |
>  			IO_PGTABLE_QUIRK_NO_PERMS |
>  			IO_PGTABLE_QUIRK_ARM_MTK_EXT,
> @@ -614,7 +615,7 @@ static int mtk_iommu_domain_finalise(struct mtk_iommu_domain *dom,
>  	else
>  		dom->cfg.oas = 35;
>  
> -	dom->iop = alloc_io_pgtable_ops(ARM_V7S, &dom->cfg, data);
> +	dom->iop = alloc_io_pgtable_ops(&dom->cfg, data);
>  	if (!dom->iop) {
>  		dev_err(data->dev, "Failed to alloc io pgtable\n");
>  		return -ENOMEM;
> -- 
> 2.39.0
> 
Thanks,
Mostafa
