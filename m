From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 05/22] iommu: Introduce cache_invalidate API
Date: Mon, 18 Mar 2019 13:44:08 +0100
Message-ID: <e0247f45-dbb7-9be6-90a6-d71475d6e9a3@redhat.com>
References: <20190315160906.12900-1-eric.auger@redhat.com>
 <20190315160906.12900-6-eric.auger@redhat.com>
 <20190315113702.1184d162@jacob-builder>
 <281167f1-c046-3077-e954-d1f510c27d61@redhat.com>
 <71bec2ed-97ed-d543-7ebd-9fb03c093e77@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <71bec2ed-97ed-d543-7ebd-9fb03c093e77@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "joro@8bytes.org" <joro@8bytes.org>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>, Will Deacon <Will.Deacon@arm.com>, Robin Murphy <Robin.Murphy@arm.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>, "ashok.raj@intel.com" <ashok.raj@intel.com>, Marc Zyngier <Marc.Zyngier@arm.com>, Christoffer Dall <Christoffer.Dall@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>, Vincent Stehle <Vincent.Ste>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jean,

On 3/18/19 12:01 PM, Jean-Philippe Brucker wrote:
> On 17/03/2019 16:43, Auger Eric wrote:
>>>> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
>>>> index 532a64075f23..e4c6a447e85a 100644
>>>> --- a/include/uapi/linux/iommu.h
>>>> +++ b/include/uapi/linux/iommu.h
>>>> @@ -159,4 +159,75 @@ struct iommu_pasid_table_config {
>>>>  	};
>>>>  };
>>>>  
>>>> +/* defines the granularity of the invalidation */
>>>> +enum iommu_inv_granularity {
>>>> +	IOMMU_INV_GRANU_DOMAIN,	/* domain-selective
>>>> invalidation */
>>>> +	IOMMU_INV_GRANU_PASID,	/* pasid-selective
>>>> invalidation */
>>>> +	IOMMU_INV_GRANU_ADDR,	/* page-selective invalidation
>>>> */ +};
>>>> +
>>>> +/**
>>>> + * Address Selective Invalidation Structure
>>>> + *
>>>> + * @flags indicates the granularity of the address-selective
>>>> invalidation
>>>> + * - if PASID bit is set, @pasid field is populated and the
>>>> invalidation
>>>> + *   relates to cache entries tagged with this PASID and matching the
>>>> + *   address range.
>>>> + * - if ARCHID bit is set, @archid is populated and the invalidation
>>>> relates
>>>> + *   to cache entries tagged with this architecture specific id and
>>>> matching
>>>> + *   the address range.
>>>> + * - Both PASID and ARCHID can be set as they may tag different
>>>> caches.
>>>> + * - if neither PASID or ARCHID is set, global addr invalidation
>>>> applies
>>>> + * - LEAF flag indicates whether only the leaf PTE caching needs to
>>>> be
>>>> + *   invalidated and other paging structure caches can be preserved.
>>>> + * @pasid: process address space id
>>>> + * @archid: architecture-specific id
>>>> + * @addr: first stage/level input address
>>>> + * @granule_size: page/block size of the mapping in bytes
>>>> + * @nb_granules: number of contiguous granules to be invalidated
>>>> + */
>>>> +struct iommu_inv_addr_info {
>>>> +#define IOMMU_INV_ADDR_FLAGS_PASID	(1 << 0)
>>>> +#define IOMMU_INV_ADDR_FLAGS_ARCHID	(1 << 1)
>>>> +#define IOMMU_INV_ADDR_FLAGS_LEAF	(1 << 2)
>>>> +	__u32	flags;
>>>> +	__u32	archid;
>>>> +	__u64	pasid;
>>>> +	__u64	addr;
>>>> +	__u64	granule_size;
>>>> +	__u64	nb_granules;
>>>> +};
>>>> +
>>>> +/**
>>>> + * First level/stage invalidation information
>>>> + * @cache: bitfield that allows to select which caches to invalidate
>>>> + * @granularity: defines the lowest granularity used for the
>>>> invalidation:
>>>> + *     domain > pasid > addr
>>>> + *
>>>> + * Not all the combinations of cache/granularity make sense:
>>>> + *
>>>> + *         type |   DEV_IOTLB   |     IOTLB     |      PASID    |
>>>> + * granularity	|		|		|
>>>> cache	|
>>>> + * -------------+---------------+---------------+---------------+
>>>> + * DOMAIN	|	N/A	|       Y	|
>>>> Y	|
>>>> + * PASID	|	Y	|       Y	|
>>>> Y	|
>>>> + * ADDR		|       Y	|       Y	|
>>>> N/A	|
>>>> + */
>>>> +struct iommu_cache_invalidate_info {
>>>> +#define IOMMU_CACHE_INVALIDATE_INFO_VERSION_1 1
>>>> +	__u32	version;
>>>> +/* IOMMU paging structure cache */
>>>> +#define IOMMU_CACHE_INV_TYPE_IOTLB	(1 << 0) /* IOMMU IOTLB */
>>>> +#define IOMMU_CACHE_INV_TYPE_DEV_IOTLB	(1 << 1) /* Device
>>>> IOTLB */ +#define IOMMU_CACHE_INV_TYPE_PASID	(1 << 2) /* PASID
>>>> cache */
>>>> +	__u8	cache;
>>>> +	__u8	granularity;
>>>> +	__u8	padding[2];
>>>> +	union {
>>>> +		__u64	pasid;
>>> just realized there is already a pasid field in the addr_info, do we
>>> still need this?
>> I think so. Either you do a PASID based invalidation and you directly
>> use the pasid field or you do an address based invalidation and you use
>> the addr_info where the pasid may or not be passed.
> 
> I guess a comment would be useful?
> 
>     - Invalidations by %IOMMU_INV_GRANU_ADDR use field @addr_info.
>     - Invalidations by %IOMMU_INV_GRANU_PASID use field @pasid.
>     - Invalidations by %IOMMU_INV_GRANU_DOMAIN don't take an argument.

OK. I will add those comments in v7.

Thanks

Eric
> 
> Thanks,
> Jean
> 
>>
>> Thanks
>>
>> Eric
>>>> +		struct iommu_inv_addr_info addr_info;
>>>> +	};
>>>> +};
>>>> +
>>>> +
>>>>  #endif /* _UAPI_IOMMU_H */
>>>
>>> [Jacob Pan]
>>>
> 
