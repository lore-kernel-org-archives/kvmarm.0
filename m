From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [RFC 02/13] iommu: Introduce tlb_invalidate API
Date: Fri, 31 Aug 2018 14:17:19 +0100
Message-ID: <11279859-08f8-6d9d-7aa7-7a5de4cfd3fb@arm.com>
References: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
 <1535026656-8450-3-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1535026656-8450-3-git-send-email-eric.auger@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>, "\"eric.auger.pro"@gmail.comeric.auger@redhat.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jean-philippe.brucker@arm.com, jacob.jun.pan@linux.intel.com, "yi.l.liu\""@linux.intel.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: marc.zyngier@arm.com, peter.maydell@linaro.org, christoffer.dall@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 23/08/18 13:17, Eric Auger wrote:
> +/**
> + * Translation cache invalidation information, contains generic IOMMU
> + * data which can be parsed based on model ID by model specific drivers.
> + * Since the invalidation of second level page tables are included in the
> + * unmap operation, this info is only applicable to the first level
> + * translation caches, i.e. DMA request with PASID.
> + *
> + * @granularity:	requested invalidation granularity, type dependent
> + * @size:		2^size of 4K pages, 0 for 4k, 9 for 2MB, etc.
> + * @nr_pages:		number of pages to invalidate
> + * @pasid:		processor address space ID value per PCI spec.
> + * @addr:		page address to be invalidated
> + * @flags		IOMMU_INVALIDATE_ADDR_LEAF: leaf paging entries
> + *			IOMMU_INVALIDATE_GLOBAL_PAGE: global pages
> + *
> + */
> +struct iommu_tlb_invalidate_info {
> +	struct iommu_tlb_invalidate_hdr	hdr;
> +	enum iommu_inv_granularity	granularity;
> +	__u32		flags;
> +#define IOMMU_INVALIDATE_ADDR_LEAF	(1 << 0)
> +#define IOMMU_INVALIDATE_GLOBAL_PAGE	(1 << 1)
> +	__u8		size;
> +	__u64		nr_pages;
> +	__u32		pasid;
> +	__u64		addr;
> +};
>  #endif /* _UAPI_IOMMU_H */

Since the ioctl will be used to combine invalidations (invalidate both
ATC and TLB with a single call), we need an additional ASID field for
the SMMU - ATC is invalidated by PASID, TLB by ASID. I used to call it
"tag", but I'm leaning towards "arch_id" now
(http://www.linux-arm.org/git?p=linux-jpb.git;a=commitdiff;h=40fdef74816dd8d8d113100b9e0162fab4cec28d)

Thanks,
Jean
