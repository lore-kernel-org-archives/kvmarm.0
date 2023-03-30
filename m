Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6388C09
	for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 18:14:11 +0000 (UTC)
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-3ee6c339cceso132125e9.0
        for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 11:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680200049;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rGdF3JRnHGbDQc345mQenBOBG4qzOhE/u5QBXOUj5ig=;
        b=GsAYwQKWXUBM7ONZAMjigQwgFkfLmvkWhlArLy3zsccR9nm1dirhrdhrU7jNm5oba4
         1P4ZUrZxMe+/YHIi43OgFPlYkUUQOlJEkFlEFTeuFcE3QQ0Lc8L6Ya3RQm8BSNSSiafp
         YgWcm7O3IkURKjSAalDJV9wH+g4z7slrOPA9fyOsYGqe3LYxPwNZu3MaJCUN4hEg0iA9
         S/2uoDX/zPsQInisy+7emtLRGr8Ws+HU0lWt3VzEkHQzkexk+TVLTwohklptoRaJRv+x
         mwwCwXYXlNkGx7lDMqd/CcMKTRxtHosL5C3940VivnYTHKVDMkuSfCBSi5z+ou8lGIyU
         1WlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680200049;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rGdF3JRnHGbDQc345mQenBOBG4qzOhE/u5QBXOUj5ig=;
        b=tXOZVQwRbPL59yQz9HMNDUePkLfhGbqS0ltfDYUZ0gN8+h5LwVQFk6A1zhPjTGZaEj
         oNQg0lpxEvp6AS1hJppOKOg7B8pEQzlGErAQZdUn5UowyaLdUW5z4NPV3U8SzWW4fU+y
         EIHhiTe36HTI2hSSfdEHMDl+ExbUZDf6V3jgZ/w1toFo6u3s6keWGZWpAH4UezUpcgGp
         MYF+cL33mcLP6fAsQsit9xLI4ipX7e94kdYdzb7oEX2yl5vO4U+zPwLmHxQMgzwE7ObM
         cRwzsM4qLp/oxfMtW6L19k8ox4nFBd4Y9n4ZHCix5kJ4iRz3BadMiyR+jBiw72R8JHOS
         zEWA==
X-Gm-Message-State: AAQBX9f+2uMOIF3bpFCtyUoxHuus/vgQEdLim2wpN7CWUxEYWZfFaWYH
	FFFxOOHsbYXbvN6OASnQkZIoCA==
X-Google-Smtp-Source: AKy350YBB9EBZyyusB1KlCOpD0hE4u7DO745J0Db6gb3oPKdmYCEE0hMkOZRupaFkgYZqkjpEa5vTw==
X-Received: by 2002:a05:600c:3b83:b0:3ed:e6da:ffcd with SMTP id n3-20020a05600c3b8300b003ede6daffcdmr10317wms.7.1680200049482;
        Thu, 30 Mar 2023 11:14:09 -0700 (PDT)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id p2-20020a05600c204200b003ed2c0a0f37sm6586732wmg.35.2023.03.30.11.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 11:14:08 -0700 (PDT)
Date: Thu, 30 Mar 2023 18:14:04 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 20/45] KVM: arm64: iommu: Add map() and unmap()
 operations
Message-ID: <ZCXRbF0dP7oHT+hl@google.com>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-21-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201125328.2186498-21-jean-philippe@linaro.org>

Hi Jean,

On Wed, Feb 01, 2023 at 12:53:04PM +0000, Jean-Philippe Brucker wrote:
> Handle map() and unmap() hypercalls by calling the io-pgtable library.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/iommu/iommu.c | 144 ++++++++++++++++++++++++++
>  1 file changed, 144 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
> index 7404ea77ed9f..0550e7bdf179 100644
> --- a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
> +++ b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
> @@ -183,6 +183,150 @@ int kvm_iommu_detach_dev(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
>  	return ret;
>  }
>  
> +static int __kvm_iommu_unmap_pages(struct io_pgtable *iopt, unsigned long iova,
> +				   size_t pgsize, size_t pgcount)
> +{
> +	int ret;
> +	size_t unmapped;
> +	phys_addr_t paddr;
> +	size_t total_unmapped = 0;
> +	size_t size = pgsize * pgcount;
> +
> +	while (total_unmapped < size) {
> +		paddr = iopt_iova_to_phys(iopt, iova);
> +		if (paddr == 0)
> +			return -EINVAL;
> +
> +		/*
> +		 * One page/block at a time, because the range provided may not
> +		 * be physically contiguous, and we need to unshare all physical
> +		 * pages.
> +		 */
> +		unmapped = iopt_unmap_pages(iopt, iova, pgsize, 1, NULL);
> +		if (!unmapped)
> +			return -EINVAL;
> +
> +		ret = __pkvm_host_unshare_dma(paddr, pgsize);
> +		if (ret)
> +			return ret;
> +
> +		iova += unmapped;
> +		pgcount -= unmapped / pgsize;
> +		total_unmapped += unmapped;
> +	}
> +
> +	return 0;
> +}
> +
> +#define IOMMU_PROT_MASK (IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE |\
> +			 IOMMU_NOEXEC | IOMMU_MMIO)
> +
> +int kvm_iommu_map_pages(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
> +			unsigned long iova, phys_addr_t paddr, size_t pgsize,
> +			size_t pgcount, int prot)
> +{
> +	size_t size;
> +	size_t granule;
> +	int ret = -EINVAL;
> +	size_t mapped = 0;
> +	struct io_pgtable iopt;
> +	struct kvm_hyp_iommu *iommu;
> +	size_t pgcount_orig = pgcount;
> +	unsigned long iova_orig = iova;
> +	struct kvm_hyp_iommu_domain *domain;
> +
> +	if (prot & ~IOMMU_PROT_MASK)
> +		return -EINVAL;
> +
> +	if (__builtin_mul_overflow(pgsize, pgcount, &size) ||
> +	    iova + size < iova || paddr + size < paddr)
> +		return -EOVERFLOW;
> +
> +	hyp_spin_lock(&iommu_lock);
> +
> +	domain = handle_to_domain(iommu_id, domain_id, &iommu);
> +	if (!domain)
> +		goto err_unlock;
> +
> +	granule = 1 << __ffs(iommu->pgtable->cfg.pgsize_bitmap);
> +	if (!IS_ALIGNED(iova | paddr | pgsize, granule))
> +		goto err_unlock;
> +
> +	ret = __pkvm_host_share_dma(paddr, size, !(prot & IOMMU_MMIO));
> +	if (ret)
> +		goto err_unlock;
> +
> +	iopt = domain_to_iopt(iommu, domain, domain_id);
> +	while (pgcount) {
> +		ret = iopt_map_pages(&iopt, iova, paddr, pgsize, pgcount, prot,
> +				     0, &mapped);
> +		WARN_ON(!IS_ALIGNED(mapped, pgsize));
> +		pgcount -= mapped / pgsize;
> +		if (ret)
> +			goto err_unmap;
> +		iova += mapped;
> +		paddr += mapped;
> +	}
> +
> +	hyp_spin_unlock(&iommu_lock);
> +	return 0;
> +
> +err_unmap:
> +	__kvm_iommu_unmap_pages(&iopt, iova_orig, pgsize, pgcount_orig - pgcount);
On error here, this unmaps (and unshares) only pages that has been
mapped.
But all pages where shared with IOMMU before (via
__pkvm_host_share_dma) and this corrupts the other pages state as
they are marked as shared while they are not.

I see we can add a "bool unshare" arg to __kvm_iommu_unmap_pages which
will be called with false on error from here after calling
__pkvm_host_unshare_dma for the whole range.

And set to true from kvm_iommu_unmap_pages.

> +err_unlock:
> +	hyp_spin_unlock(&iommu_lock);
> +	return ret;
> +}
> +
> +int kvm_iommu_unmap_pages(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
> +			  unsigned long iova, size_t pgsize, size_t pgcount)
> +{
> +	size_t size;
> +	size_t granule;
> +	int ret = -EINVAL;
> +	struct io_pgtable iopt;
> +	struct kvm_hyp_iommu *iommu;
> +	struct kvm_hyp_iommu_domain *domain;
> +
> +	if (__builtin_mul_overflow(pgsize, pgcount, &size) ||
> +	    iova + size < iova)
> +		return -EOVERFLOW;
> +
> +	hyp_spin_lock(&iommu_lock);
> +	domain = handle_to_domain(iommu_id, domain_id, &iommu);
> +	if (!domain)
> +		goto out_unlock;
> +
> +	granule = 1 << __ffs(iommu->pgtable->cfg.pgsize_bitmap);
> +	if (!IS_ALIGNED(iova | pgsize, granule))
> +		goto out_unlock;
> +
> +	iopt = domain_to_iopt(iommu, domain, domain_id);
> +	ret = __kvm_iommu_unmap_pages(&iopt, iova, pgsize, pgcount);
> +out_unlock:
> +	hyp_spin_unlock(&iommu_lock);
> +	return ret;
> +}
> +
> +phys_addr_t kvm_iommu_iova_to_phys(pkvm_handle_t iommu_id,
> +				   pkvm_handle_t domain_id, unsigned long iova)
> +{
> +	phys_addr_t phys = 0;
> +	struct io_pgtable iopt;
> +	struct kvm_hyp_iommu *iommu;
> +	struct kvm_hyp_iommu_domain *domain;
> +
> +	hyp_spin_lock(&iommu_lock);
> +	domain = handle_to_domain(iommu_id, domain_id, &iommu);
> +	if (domain) {
> +		iopt = domain_to_iopt(iommu, domain, domain_id);
> +
> +		phys = iopt_iova_to_phys(&iopt, iova);
> +	}
> +	hyp_spin_unlock(&iommu_lock);
> +	return phys;
> +}
> +
>  int kvm_iommu_init_device(struct kvm_hyp_iommu *iommu)
>  {
>  	void *domains;
> -- 
> 2.39.0

Thanks,
Mostafa
