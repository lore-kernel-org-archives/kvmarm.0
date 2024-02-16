Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4DB59169
	for <kvmarm@lists.linux.dev>; Fri, 16 Feb 2024 11:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708084774; cv=none; b=spVLEV4HLqpzdzr+VN+FMIwTbSI29p299keLuBQwopzXVDyN88OqfLsThd77X2nY5oSI2TJ4AdrGLn3Eiw2DvIqIwRGwnqtSXyOecM8RrHEBaliCVXUGJjjSk1rxaKHGJUnW/nx92IWOdS3YyGdROxFybfmJtbFHEZ9U9E1hMvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708084774; c=relaxed/simple;
	bh=vy3Ay/hRFTHO6jpdstTwey1/G6/yEykDma54N0lCklE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sHp2hr+8Pq4aKSbj9ChykZqNJBEIbOjC9Jrpm4oXvEfVo0w8fjARkn0/U3WgmS4sxPq5Dr+sqr4C6sYDgqrLuJfkSSXU8XeKBECn8jewek3DVycFJ7iJ4dkO2LBvuH6Q1GKA7gFEY2Pmxxt+EQbBuWRcCcQyPNivKNl4eJWREgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yf5L4mb+; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yf5L4mb+"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-411d9e901dcso43015e9.1
        for <kvmarm@lists.linux.dev>; Fri, 16 Feb 2024 03:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708084771; x=1708689571; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JEgwa2CJZVWqfoiL61uxKFYfo6g3B6LbKWPFOUh15oQ=;
        b=Yf5L4mb+8fZGthIwoqSaFEosyyx1R2aBUZQr//YHoAKpsyCxv/ilGHr0cWmrzrGDKq
         pkb4LH0wbOM/faUcv2wApO+8QQdqhtN6OM0iOpECX2QteL7MtcfTCOXCyxMDmUkdKsWO
         BZ9yQuSZuoSQK7aZ05+BLcxEu2HVw5v4Twg7Jp87Xr21QjAe8B5VlzP7GC0l74x0OGLX
         P04fqqZ2TtBpfJoFN7ukkEBN9/lBM+HO7NjGapKihBA09GVgf33Rkl8s60Brs9N8RGv+
         sgbuTQwiwiWbJWiLELYuR1Kal/mjF4iqYwAuNHAl2YtpEzUvEzS+iIKxWDRCd9Hggdq5
         8Fyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708084771; x=1708689571;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JEgwa2CJZVWqfoiL61uxKFYfo6g3B6LbKWPFOUh15oQ=;
        b=d+Gi5hpFhKQbBex/Do03cHRRBuPselDoN3O/4lTkUl9r1cbbCmVjTo4A51HvGAJ28z
         qVfyNoWH6KOWjnAUr6hdCCAZegWt4PHYJHcpuIDrzzqEcx7bNT3or/GEDQtHheGzAu65
         r23KwASG/V/BF8iU90LZHvNsqjFrN3I6Z5tjQxEYLXl2M3gy/4TG21yej/mGGQ72jukw
         HMPczv9H+NIHrTOCC13THjqToBth78PYHQl3iWbWgHJ4P/76FL6+JKbhv65y42Gq8tc8
         5BeW2VZpPiYZEEI15CUgosfrxPUmBYVbd6VC84hFrMuxg3lrChQPeGPJigS9fcMyMLST
         vAmQ==
X-Forwarded-Encrypted: i=1; AJvYcCWOENqZmsi+gr8SAk4yhy0OteYWzfXxYmKtqe9gRStFbjUb2BkTM99hnEVVxZeOotD9nc71gYT9Rz1EF8hl3S9qiGqMgP92
X-Gm-Message-State: AOJu0YwLv+kkjK74I07Kb84bFvmT9y/JnTn6KNJS9JZMdsmfsu5mWS/Y
	hRnplfxEs5H1a6FG5YcKj3k3WFpdCUJBCECogo8+ZwR7IPlFZaZ4RpMxcBaXrw==
X-Google-Smtp-Source: AGHT+IFrWNU2tq/8dun0sOJnkeBiTgbSlXW5PpRtrfXDapNVydPJsEc6RWaIh0k6K7p2X6CTFXGqnA==
X-Received: by 2002:a05:600c:1e0f:b0:412:2c30:9a7 with SMTP id ay15-20020a05600c1e0f00b004122c3009a7mr175498wmb.2.1708084770674;
        Fri, 16 Feb 2024 03:59:30 -0800 (PST)
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id bx15-20020a5d5b0f000000b0033d202abf01sm1202622wrb.28.2024.02.16.03.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Feb 2024 03:59:30 -0800 (PST)
Date: Fri, 16 Feb 2024 11:59:26 +0000
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
Message-ID: <Zc9OHq2NO3X7DsSO@google.com>
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
Is there a reason IOMMU_PRIV is not allowed?
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
>
Thanks,
Mostafa
