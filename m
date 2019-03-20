From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH v6 05/22] iommu: Introduce cache_invalidate API
Date: Wed, 20 Mar 2019 16:50:07 +0000
Message-ID: <7ae1df77-18d0-0993-8dab-6af3a4474b42@arm.com>
References: <20190317172232.1068-1-eric.auger@redhat.com>
 <20190317172232.1068-6-eric.auger@redhat.com>
 <20190320093727.45a86866@jacob-builder>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190320093727.45a86866@jacob-builder>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jacob Pan <jacob.jun.pan@linux.intel.com>, Eric Auger <eric.auger@redhat.com>
Cc: yi.l.liu@linux.intel.com, kevin.tian@intel.com, vincent.stehle@arm.com, alex.williamson@redhat.com, ashok.raj@intel.com, kvm@vger.kernel.org, peter.maydell@linaro.org, will.deacon@arm.com, linux-kernel@vger.kernel.org, christoffer.dall@arm.com, marc.zyngier@arm.com, iommu@lists.linux-foundation.org, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On 20/03/2019 16:37, Jacob Pan wrote:
[...]
>> +struct iommu_inv_addr_info {
>> +#define IOMMU_INV_ADDR_FLAGS_PASID	(1 << 0)
>> +#define IOMMU_INV_ADDR_FLAGS_ARCHID	(1 << 1)
>> +#define IOMMU_INV_ADDR_FLAGS_LEAF	(1 << 2)
>> +	__u32	flags;
>> +	__u32	archid;
>> +	__u64	pasid;
>> +	__u64	addr;
>> +	__u64	granule_size;
>> +	__u64	nb_granules;
>> +};
>> +
>> +/**
>> + * First level/stage invalidation information
>> + * @cache: bitfield that allows to select which caches to invalidate
>> + * @granularity: defines the lowest granularity used for the
>> invalidation:
>> + *     domain > pasid > addr
>> + *
>> + * Not all the combinations of cache/granularity make sense:
>> + *
>> + *         type |   DEV_IOTLB   |     IOTLB     |      PASID    |
>> + * granularity	|		|		|
>> cache	|
>> + * -------------+---------------+---------------+---------------+
>> + * DOMAIN	|	N/A	|       Y	|
>> Y	|
>> + * PASID	|	Y	|       Y	|
>> Y	|
>> + * ADDR		|       Y	|       Y	|
>> N/A	|
>> + */
>> +struct iommu_cache_invalidate_info {
>> +#define IOMMU_CACHE_INVALIDATE_INFO_VERSION_1 1
>> +	__u32	version;
>> +/* IOMMU paging structure cache */
>> +#define IOMMU_CACHE_INV_TYPE_IOTLB	(1 << 0) /* IOMMU IOTLB */
>> +#define IOMMU_CACHE_INV_TYPE_DEV_IOTLB	(1 << 1) /* Device
>> IOTLB */ +#define IOMMU_CACHE_INV_TYPE_PASID	(1 << 2) /* PASID
>> cache */
> Just a clarification, this used to be an enum. You do intend to issue a
> single invalidation request on multiple cache types? Perhaps for
> virtio-IOMMU? I only see a single cache type in your patch #14. For VT-d
> we plan to issue one cache type at a time for now. So this format works
> for us.

Yes for virtio-iommu I'd like as little overhead as possible, which
means a single invalidation message to hit both IOTLB and ATC at once,
and the ability to specify multiple pages with @nb_granules.

> However, if multiple cache types are issued in a single invalidation.
> They must share a single granularity, not all combinations are valid.
> e.g. dev IOTLB does not support domain granularity. Just a reminder,
> not an issue. Driver could filter out invalid combinations.

Agreed. Even the core could filter out invalid combinations based on the
table above: IOTLB and domain granularity are N/A.

Thanks,
Jean

> 
>> +	__u8	cache;
>> +	__u8	granularity;
>> +	__u8	padding[2];
>> +	union {
>> +		__u64	pasid;
>> +		struct iommu_inv_addr_info addr_info;
>> +	};
>> +};
>> +
>> +
>>  #endif /* _UAPI_IOMMU_H */
> 
> [Jacob Pan]
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
> 
