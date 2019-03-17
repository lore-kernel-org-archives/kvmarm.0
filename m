From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 05/22] iommu: Introduce cache_invalidate API
Date: Sun, 17 Mar 2019 17:43:12 +0100
Message-ID: <281167f1-c046-3077-e954-d1f510c27d61@redhat.com>
References: <20190315160906.12900-1-eric.auger@redhat.com>
 <20190315160906.12900-6-eric.auger@redhat.com>
 <20190315113702.1184d162@jacob-builder>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BE4B4A3B3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Mar 2019 12:43:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UwzyqS4CBTqk for <kvmarm@lists.cs.columbia.edu>;
 Sun, 17 Mar 2019 12:43:23 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E8DB840A52
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Mar 2019 12:43:22 -0400 (EDT)
In-Reply-To: <20190315113702.1184d162@jacob-builder>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: yi.l.liu@linux.intel.com, kevin.tian@intel.com, vincent.stehle@arm.com, alex.williamson@redhat.com, ashok.raj@intel.com, kvm@vger.kernel.org, joro@8bytes.org, will.deacon@arm.com, linux-kernel@vger.kernel.org, marc.zyngier@arm.com, iommu@lists.linux-foundation.org, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jacob,

On 3/15/19 7:37 PM, Jacob Pan wrote:
> On Fri, 15 Mar 2019 17:08:49 +0100
> Eric Auger <eric.auger@redhat.com> wrote:
> 
>> From: "Liu, Yi L" <yi.l.liu@linux.intel.com>
>>
>> In any virtualization use case, when the first translation stage
>> is "owned" by the guest OS, the host IOMMU driver has no knowledge
>> of caching structure updates unless the guest invalidation activities
>> are trapped by the virtualizer and passed down to the host.
>>
>> Since the invalidation data are obtained from user space and will be
>> written into physical IOMMU, we must allow security check at various
>> layers. Therefore, generic invalidation data format are proposed here,
>> model specific IOMMU drivers need to convert them into their own
>> format.
>>
>> Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
>> Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
>> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
>> Signed-off-by: Ashok Raj <ashok.raj@intel.com>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> v3 -> v4:
>> - full reshape of the API following Alex' comments
>>
>> v1 -> v2:
>> - add arch_id field
>> - renamed tlb_invalidate into cache_invalidate as this API allows
>>   to invalidate context caches on top of IOTLBs
>>
>> v1:
>> renamed sva_invalidate into tlb_invalidate and add iommu_ prefix in
>> header. Commit message reworded.
>> ---
>>  drivers/iommu/iommu.c      | 14 ++++++++
>>  include/linux/iommu.h      | 21 +++++++++++
>>  include/uapi/linux/iommu.h | 71
>> ++++++++++++++++++++++++++++++++++++++ 3 files changed, 106
>> insertions(+)
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 7d9285cea100..b72e326ddd41 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -1544,6 +1544,20 @@ void iommu_detach_pasid_table(struct
>> iommu_domain *domain) }
>>  EXPORT_SYMBOL_GPL(iommu_detach_pasid_table);
>>  
>> +int iommu_cache_invalidate(struct iommu_domain *domain, struct
>> device *dev,
>> +			   struct iommu_cache_invalidate_info
>> *inv_info) +{
>> +	int ret = 0;
>> +
>> +	if (unlikely(!domain->ops->cache_invalidate))
>> +		return -ENODEV;
>> +
>> +	ret = domain->ops->cache_invalidate(domain, dev, inv_info);
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(iommu_cache_invalidate);
>> +
>>  static void __iommu_detach_device(struct iommu_domain *domain,
>>  				  struct device *dev)
>>  {
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index fb9b7a8de25f..3d8e48876162 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -191,6 +191,7 @@ struct iommu_resv_region {
>>   *                      driver init to device driver init (default
>> no)
>>   * @attach_pasid_table: attach a pasid table
>>   * @detach_pasid_table: detach the pasid table
>> + * @cache_invalidate: invalidate translation caches
>>   * @pgsize_bitmap: bitmap of all possible supported page sizes
>>   */
>>  struct iommu_ops {
>> @@ -239,6 +240,9 @@ struct iommu_ops {
>>  				  struct iommu_pasid_table_config
>> *cfg); void (*detach_pasid_table)(struct iommu_domain *domain);
>>  
>> +	int (*cache_invalidate)(struct iommu_domain *domain, struct
>> device *dev,
>> +				struct iommu_cache_invalidate_info
>> *inv_info); +
>>  	unsigned long pgsize_bitmap;
>>  };
>>  
>> @@ -349,6 +353,9 @@ extern void iommu_detach_device(struct
>> iommu_domain *domain, extern int iommu_attach_pasid_table(struct
>> iommu_domain *domain, struct iommu_pasid_table_config *cfg);
>>  extern void iommu_detach_pasid_table(struct iommu_domain *domain);
>> +extern int iommu_cache_invalidate(struct iommu_domain *domain,
>> +				  struct device *dev,
>> +				  struct iommu_cache_invalidate_info
>> *inv_info); extern struct iommu_domain
>> *iommu_get_domain_for_dev(struct device *dev); extern struct
>> iommu_domain *iommu_get_dma_domain(struct device *dev); extern int
>> iommu_map(struct iommu_domain *domain, unsigned long iova, @@ -795,7
>> +802,21 @@ int iommu_attach_pasid_table(struct iommu_domain *domain, }
>>  
>>  static inline
>> +<<<<<<< HEAD
>>  void iommu_detach_pasid_table(struct iommu_domain *domain) {}
>> +=======
>> +void iommu_detach_pasid_table(struct iommu_domain *domain)
>> +{
>> +	return -ENODEV;
>> +}
>> +static inline int
>> +iommu_cache_invalidate(struct iommu_domain *domain,
>> +		       struct device *dev,
>> +		       struct iommu_cache_invalidate_info *inv_info)
>> +{
>> +	return -ENODEV;
>> +}
>> +>>>>>>> 56df871916e5... iommu: Introduce cache_invalidate API 
ouch :-(

> forgot to merge :)
>>  
>>  #endif /* CONFIG_IOMMU_API */
>>  
>> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
>> index 532a64075f23..e4c6a447e85a 100644
>> --- a/include/uapi/linux/iommu.h
>> +++ b/include/uapi/linux/iommu.h
>> @@ -159,4 +159,75 @@ struct iommu_pasid_table_config {
>>  	};
>>  };
>>  
>> +/* defines the granularity of the invalidation */
>> +enum iommu_inv_granularity {
>> +	IOMMU_INV_GRANU_DOMAIN,	/* domain-selective
>> invalidation */
>> +	IOMMU_INV_GRANU_PASID,	/* pasid-selective
>> invalidation */
>> +	IOMMU_INV_GRANU_ADDR,	/* page-selective invalidation
>> */ +};
>> +
>> +/**
>> + * Address Selective Invalidation Structure
>> + *
>> + * @flags indicates the granularity of the address-selective
>> invalidation
>> + * - if PASID bit is set, @pasid field is populated and the
>> invalidation
>> + *   relates to cache entries tagged with this PASID and matching the
>> + *   address range.
>> + * - if ARCHID bit is set, @archid is populated and the invalidation
>> relates
>> + *   to cache entries tagged with this architecture specific id and
>> matching
>> + *   the address range.
>> + * - Both PASID and ARCHID can be set as they may tag different
>> caches.
>> + * - if neither PASID or ARCHID is set, global addr invalidation
>> applies
>> + * - LEAF flag indicates whether only the leaf PTE caching needs to
>> be
>> + *   invalidated and other paging structure caches can be preserved.
>> + * @pasid: process address space id
>> + * @archid: architecture-specific id
>> + * @addr: first stage/level input address
>> + * @granule_size: page/block size of the mapping in bytes
>> + * @nb_granules: number of contiguous granules to be invalidated
>> + */
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
>> +	__u8	cache;
>> +	__u8	granularity;
>> +	__u8	padding[2];
>> +	union {
>> +		__u64	pasid;
> just realized there is already a pasid field in the addr_info, do we
> still need this?
I think so. Either you do a PASID based invalidation and you directly
use the pasid field or you do an address based invalidation and you use
the addr_info where the pasid may or not be passed.

Thanks

Eric
>> +		struct iommu_inv_addr_info addr_info;
>> +	};
>> +};
>> +
>> +
>>  #endif /* _UAPI_IOMMU_H */
> 
> [Jacob Pan]
> 
