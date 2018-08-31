From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC 02/13] iommu: Introduce tlb_invalidate API
Date: Fri, 31 Aug 2018 16:07:32 +0200
Message-ID: <95e423a6-3f67-d101-a391-369a1493dff9@redhat.com>
References: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
 <1535026656-8450-3-git-send-email-eric.auger@redhat.com>
 <11279859-08f8-6d9d-7aa7-7a5de4cfd3fb@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <11279859-08f8-6d9d-7aa7-7a5de4cfd3fb@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, "yi.l.liu\""@linux.intel.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: marc.zyngier@arm.com, peter.maydell@linaro.org, christoffer.dall@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jean-Philippe,

On 08/31/2018 03:17 PM, Jean-Philippe Brucker wrote:
> On 23/08/18 13:17, Eric Auger wrote:
>> +/**
>> + * Translation cache invalidation information, contains generic IOMMU
>> + * data which can be parsed based on model ID by model specific drivers.
>> + * Since the invalidation of second level page tables are included in the
>> + * unmap operation, this info is only applicable to the first level
>> + * translation caches, i.e. DMA request with PASID.
>> + *
>> + * @granularity:	requested invalidation granularity, type dependent
>> + * @size:		2^size of 4K pages, 0 for 4k, 9 for 2MB, etc.
>> + * @nr_pages:		number of pages to invalidate
>> + * @pasid:		processor address space ID value per PCI spec.
>> + * @addr:		page address to be invalidated
>> + * @flags		IOMMU_INVALIDATE_ADDR_LEAF: leaf paging entries
>> + *			IOMMU_INVALIDATE_GLOBAL_PAGE: global pages
>> + *
>> + */
>> +struct iommu_tlb_invalidate_info {
>> +	struct iommu_tlb_invalidate_hdr	hdr;
>> +	enum iommu_inv_granularity	granularity;
>> +	__u32		flags;
>> +#define IOMMU_INVALIDATE_ADDR_LEAF	(1 << 0)
>> +#define IOMMU_INVALIDATE_GLOBAL_PAGE	(1 << 1)
>> +	__u8		size;
>> +	__u64		nr_pages;
>> +	__u32		pasid;
>> +	__u64		addr;
>> +};
>>  #endif /* _UAPI_IOMMU_H */
> 
> Since the ioctl will be used to combine invalidations (invalidate both
> ATC and TLB with a single call), we need an additional ASID field for
> the SMMU - ATC is invalidated by PASID, TLB by ASID. I used to call it
> "tag", but I'm leaning towards "arch_id" now
> (http://www.linux-arm.org/git?p=linux-jpb.git;a=commitdiff;h=40fdef74816dd8d8d113100b9e0162fab4cec28d)

I aknowledge I am not crystal clear about that. for a given iommu_domain
don't you have a single asid. Can't you retrieve the asid from the
iommu_domain/arm_smmu_domain/arm_smmu_s1_cfg/arm_smmu_ctx_desc.asid?
Here again I am confused bout the dual iommu_domain/struct device
parameters.

I have another trouble while doing the QEMU integration.
When the guests does an NH_ALL, this propagates an invalidation on the
whole IPA range and we must discriminate that from regular NH_VA calls.
How would you encode the NH_ALL with this API?

Besides I discover you work on virtio-iommu/stage2 enablement ;-)

Thanks

Eric
> 
> Thanks,
> Jean
> 
