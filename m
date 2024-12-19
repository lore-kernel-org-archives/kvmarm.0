Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC8D62236FE;
	Thu, 19 Dec 2024 12:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734612515; cv=none; b=ldwYEVVpCOBBcNHzaW2kV2jWuPrvtJ0yLGCASQ0DIRt7YWidQofnNY+48pafx6lYuUm+SqBJNMACd++sUloiBs4ahQl4imxnONXnnwE0z5wOZYqqik5f92TA1L7dnHsHrHJcJYU2an6VUo1Ri429+tYEmHTWgGRPOo6DZ4FdrlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734612515; c=relaxed/simple;
	bh=gCsZc3+3i9WAzAGFo9/Bw8uxaMH+Adoexphuw71sK1k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MlBbUwM6VowaWyqFllzPQAxXMhzXBzgt7VK62JYchZFGA8SkNDWVg8YscBHvhCyTds+HHoZkajiv/h9hiCfQQg72tNdjtEW87Pl4dM9ubA0gsXHyRp2bZ8WcGt9MjGn75ZizwMB/kp8uFpviLv3dAw+mJubh9BCTmfWwNTxUMeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21DFC1477;
	Thu, 19 Dec 2024 04:49:00 -0800 (PST)
Received: from [10.57.1.39] (unknown [10.57.1.39])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D9E2C3F7B4;
	Thu, 19 Dec 2024 04:48:28 -0800 (PST)
Message-ID: <ce4c8db4-4895-426b-8d9d-97dc5d74fbc4@arm.com>
Date: Thu, 19 Dec 2024 12:48:27 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 55/58] drivers/iommu: Add deferred map_sg
 operations
To: Mostafa Saleh <smostafa@google.com>, iommu@lists.linux.dev,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org,
 jean-philippe@linaro.org, jgg@ziepe.ca, nicolinc@nvidia.com,
 vdonnefort@google.com, qperret@google.com, tabba@google.com,
 danielmentz@google.com, tzukui@google.com
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212180423.1578358-56-smostafa@google.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20241212180423.1578358-56-smostafa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024-12-12 6:04 pm, Mostafa Saleh wrote:
> With pKVM SMMUv3 driver which para-virtualizes the IOMMU in the
> hypervisor, has an extra overhead with map_sg, as it loops over
> iommu_map, and for each map requires context switching, disabling
> interrupts...
> 
> Instead, add an new domain operations:
> - alloc_cookie_sg: Allocate a new sg deferred cookie
> - add_deferred_map_sg: Add a mapping to the cookie
> - consume_deferred_map_sg: Consume and release the cookie
> 
> Alternativly, we can pass the sg list as is. However, this would
> duplicate some of the logic and it would make more sense to
> conolidate all the sg list parsing for IOMMU drivers in one place.

But why bother with fiddly overly-specific machinery at all when you can 
already make ->map_pages asynchronous and consolidate the expensive part 
into ->iotlb_sync_map in general, like s390 does?

Thanks,
Robin.

> virtio-iommu is another IOMMU that can benfit from this, but it
> would need to have a new operation that standerdize passing
> an sglist based on these ops.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>   drivers/iommu/iommu.c | 53 +++++++++++++++++++++++++++++++++++++++++--
>   include/linux/iommu.h | 19 ++++++++++++++++
>   2 files changed, 70 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 83c8e617a2c5..3a3c48631dd6 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2608,6 +2608,37 @@ size_t iommu_unmap_fast(struct iommu_domain *domain,
>   }
>   EXPORT_SYMBOL_GPL(iommu_unmap_fast);
>   
> +static int __iommu_add_sg(struct iommu_map_cookie_sg *cookie_sg,
> +			  unsigned long iova, phys_addr_t paddr, size_t size)
> +{
> +	struct iommu_domain *domain = cookie_sg->domain;
> +	const struct iommu_domain_ops *ops = domain->ops;
> +	unsigned int min_pagesz;
> +	size_t pgsize, count;
> +
> +	if (unlikely(!(domain->type & __IOMMU_DOMAIN_PAGING)))
> +		return -EINVAL;
> +
> +	if (WARN_ON(domain->pgsize_bitmap == 0UL))
> +		return -ENODEV;
> +
> +	/* find out the minimum page size supported */
> +	min_pagesz = 1 << __ffs(domain->pgsize_bitmap);
> +
> +	/*
> +	 * both the virtual address and the physical one, as well as
> +	 * the size of the mapping, must be aligned (at least) to the
> +	 * size of the smallest page supported by the hardware
> +	 */
> +	if (!IS_ALIGNED(iova | paddr | size, min_pagesz)) {
> +		pr_err("unaligned: iova 0x%lx pa %pa size 0x%zx min_pagesz 0x%x\n",
> +		       iova, &paddr, size, min_pagesz);
> +		return -EINVAL;
> +	}
> +	pgsize = iommu_pgsize(domain, iova, paddr, size, &count);
> +	return ops->add_deferred_map_sg(cookie_sg, paddr, pgsize, count);
> +}
> +
>   ssize_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
>   		     struct scatterlist *sg, unsigned int nents, int prot,
>   		     gfp_t gfp)
> @@ -2617,6 +2648,9 @@ ssize_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
>   	phys_addr_t start;
>   	unsigned int i = 0;
>   	int ret;
> +	bool deferred_sg = ops->alloc_cookie_sg && ops->add_deferred_map_sg &&
> +			   ops->consume_deferred_map_sg;
> +	struct iommu_map_cookie_sg *cookie_sg;
>   
>   	might_sleep_if(gfpflags_allow_blocking(gfp));
>   
> @@ -2625,12 +2659,24 @@ ssize_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
>   				__GFP_HIGHMEM)))
>   		return -EINVAL;
>   
> +	if (deferred_sg) {
> +		cookie_sg = ops->alloc_cookie_sg(iova, prot, nents, gfp);
> +		if (!cookie_sg) {
> +			pr_err("iommu: failed alloc cookie\n");
> +			return -ENOMEM;
> +		}
> +		cookie_sg->domain = domain;
> +	}
> +
>   	while (i <= nents) {
>   		phys_addr_t s_phys = sg_phys(sg);
>   
>   		if (len && s_phys != start + len) {
> -			ret = __iommu_map(domain, iova + mapped, start,
> -					len, prot, gfp);
> +			if (deferred_sg)
> +				ret = __iommu_add_sg(cookie_sg, iova + mapped, start, len);
> +			else
> +				ret = __iommu_map(domain, iova + mapped, start,
> +						  len, prot, gfp);
>   
>   			if (ret)
>   				goto out_err;
> @@ -2654,6 +2700,9 @@ ssize_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
>   			sg = sg_next(sg);
>   	}
>   
> +	if (deferred_sg)
> +		ops->consume_deferred_map_sg(cookie_sg);
> +
>   	if (ops->iotlb_sync_map) {
>   		ret = ops->iotlb_sync_map(domain, iova, mapped);
>   		if (ret)
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index c75877044185..5e60ac349228 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -601,6 +601,14 @@ struct iommu_ops {
>   	u8 user_pasid_table:1;
>   };
>   
> +/**
> + * struct iommu_map_cookie_sg - Cookie for a deferred map sg
> + * @domain: Domain for the sg lit
> + */
> +struct iommu_map_cookie_sg {
> +	struct iommu_domain *domain;
> +};
> +
>   /**
>    * struct iommu_domain_ops - domain specific operations
>    * @attach_dev: attach an iommu domain to a device
> @@ -638,6 +646,11 @@ struct iommu_ops {
>    * @enable_nesting: Enable nesting
>    * @set_pgtable_quirks: Set io page table quirks (IO_PGTABLE_QUIRK_*)
>    * @free: Release the domain after use.
> + * @alloc_cookie_sg: Allocate a cookie that would be used to create
> + *		     a sg list, filled from the next functions
> + * @add_deferred_map_sg: Add a mapping to a cookie of a sg list.
> + * @consume_deferred_map_sg: Consume the sg list as now all mappings are added,
> + *			     it should also release the cookie as it's not used.
>    */
>   struct iommu_domain_ops {
>   	int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
> @@ -668,6 +681,12 @@ struct iommu_domain_ops {
>   				  unsigned long quirks);
>   
>   	void (*free)(struct iommu_domain *domain);
> +
> +	struct iommu_map_cookie_sg *(*alloc_cookie_sg)(unsigned long iova, int prot,
> +						       unsigned int nents, gfp_t gfp);
> +	int (*add_deferred_map_sg)(struct iommu_map_cookie_sg *cookie,
> +				   phys_addr_t paddr, size_t pgsize, size_t pgcount);
> +	int (*consume_deferred_map_sg)(struct iommu_map_cookie_sg *cookie);
>   };
>   
>   /**

