Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF04723AD
	for <kvmarm@lists.linux.dev>; Wed, 22 Mar 2023 10:23:56 +0000 (UTC)
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-3ec1e8c4cacso10275e9.1
        for <kvmarm@lists.linux.dev>; Wed, 22 Mar 2023 03:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679480635;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mcDRlGqb6Azx/x9zIxUH1xj8S/fV5DxJOLYKrwe15TU=;
        b=b9wczk/RvzcvFUi12dsmCX/dOp168FNB/SofHTHB0xagYDW5bzYNCsxLv8oNlbpPrK
         ZjD9DO5iSb2Vm2D/61rXC644sDbVjg56fHs/fY+0K8FEb2LHGQGJZH71ZLYSdF4K05a9
         4cJVG7d4bcGG8TWLurN45B+JegyERpBhQP5uoNdcwXGJoAaE1ipCg+CE2HstLhaBcLoU
         98rMKepuI+GZLDwDZSHRISsqO2IbuMWWiWyRhbSHS0+b1fQGgVC8Q4+FjaLviFbbA+uA
         46S8lM2iCvIAQhazV4ySTlQcjLZ2x4XLbLG7zp9qFH3OUFyN9pd8Xq9taLn40wgOvBJh
         ACNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679480635;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mcDRlGqb6Azx/x9zIxUH1xj8S/fV5DxJOLYKrwe15TU=;
        b=Hc9tDLFUNKcjfxLK3GKCaAXNzflhum09HbLyzEh66Lb931bb0vz3ejpAJw9pL1aFic
         3sJuGpgLyrYEkleA5I3RryI5MRUoHmpDoeacdgezIwD7pBeTIKaxFGQEEz/J4yN58B0h
         26VdG9In9c/Sigtwdz7gytWGRTFGqT8HCP+b3zNdgDtgKmFQBgA0PYLHgeGJz8ufXLxa
         CGmFiGtpg+iYdIdIeb1omZCqyDOy16QSJUIqjULum2OC0il8FT5VHRAw6+BgdjOdSuye
         nH/4+PkF1HPm3cI6KtgVB4F+uYHo+J8CNxYrrwQ0UeujueA6pZx16xtrg1B/ApxvEsRe
         H3ZA==
X-Gm-Message-State: AO0yUKXtQpWl3IiOqexcRjPZvXL8Vidbhpp+qdowixQclJjpQmSFz9cW
	8oIZR7/vBOv8+NC19TXqCDAfsA==
X-Google-Smtp-Source: AK7set/RxnGBHvENZoN3y84D3iy9ZfTLiNg7s6OFbvMVV5PfOCNdV5jQnhbS+sVxArHm8nYHBg02hg==
X-Received: by 2002:a05:600c:3d0c:b0:3df:f3cb:e8ce with SMTP id bh12-20020a05600c3d0c00b003dff3cbe8cemr108656wmb.7.1679480635095;
        Wed, 22 Mar 2023 03:23:55 -0700 (PDT)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id y16-20020a056000109000b002c56013c07fsm13394867wrw.109.2023.03.22.03.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 03:23:54 -0700 (PDT)
Date: Wed, 22 Mar 2023 10:23:50 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 39/45] iommu/arm-smmu-v3-kvm: Initialize page table
 configuration
Message-ID: <ZBrXNjOiqHJAxLzw@google.com>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-40-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201125328.2186498-40-jean-philippe@linaro.org>

Hi Jean,

On Wed, Feb 01, 2023 at 12:53:23PM +0000, Jean-Philippe Brucker wrote:
> Prepare the stage-2 I/O page table configuration that will be used by
> the hypervisor driver.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 29 +++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
> index 755c77bc0417..55489d56fb5b 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
> @@ -16,6 +16,7 @@ struct host_arm_smmu_device {
>  	struct arm_smmu_device		smmu;
>  	pkvm_handle_t			id;
>  	u32				boot_gbpa;
> +	unsigned int			pgd_order;
>  };
>  
>  #define smmu_to_host(_smmu) \
> @@ -192,6 +193,7 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
>  	size_t size;
>  	phys_addr_t ioaddr;
>  	struct resource *res;
> +	struct io_pgtable_cfg cfg;
>  	struct arm_smmu_device *smmu;
>  	struct device *dev = &pdev->dev;
>  	struct host_arm_smmu_device *host_smmu;
> @@ -233,6 +235,31 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
>  	if (!kvm_arm_smmu_validate_features(smmu))
>  		return -ENODEV;
>  
> +	/*
> +	 * Stage-1 should be easy to support, though we do need to allocate a
> +	 * context descriptor table.
> +	 */
> +	cfg = (struct io_pgtable_cfg) {
> +		.fmt = ARM_64_LPAE_S2,
> +		.pgsize_bitmap = smmu->pgsize_bitmap,
> +		.ias = smmu->ias,
> +		.oas = smmu->oas,
> +		.coherent_walk = smmu->features & ARM_SMMU_FEAT_COHERENCY,
> +	};
> +
> +	/*
> +	 * Choose the page and address size. Compute the PGD size and number of
> +	 * levels as well, so we know how much memory to pre-allocate.
> +	 */
> +	ret = io_pgtable_configure(&cfg, &size);
size variable is overwritten here with pgd size, while used later on
the assumption it still contains the SMMU MMIO size.
This looks like it is not intended?


> +	if (ret)
> +		return ret;
> +
> +	host_smmu->pgd_order = get_order(size);
> +	smmu->pgsize_bitmap = cfg.pgsize_bitmap;
> +	smmu->ias = cfg.ias;
> +	smmu->oas = cfg.oas;
> +
>  	ret = arm_smmu_init_one_queue(smmu, &smmu->cmdq.q, smmu->base,
>  				      ARM_SMMU_CMDQ_PROD, ARM_SMMU_CMDQ_CONS,
>  				      CMDQ_ENT_DWORDS, "cmdq");
> @@ -253,6 +280,8 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
>  	hyp_smmu->mmio_addr = ioaddr;
>  	hyp_smmu->mmio_size = size;
>  	hyp_smmu->features = smmu->features;
> +	hyp_smmu->iommu.pgtable_cfg = cfg;
> +
>  	kvm_arm_smmu_cur++;
>  
>  	return 0;
> -- 
> 2.39.0
> 
Thanks,
Mostafa
