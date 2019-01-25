From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC v3 02/21] iommu: Introduce cache_invalidate API
Date: Fri, 25 Jan 2019 17:49:20 +0100
Message-ID: <66653430-514f-2b4b-3d93-348deb6cd490@redhat.com>
References: <20190108102633.17482-1-eric.auger@redhat.com>
 <20190108102633.17482-3-eric.auger@redhat.com>
 <20190111143042.183a27a7@x1.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190111143042.183a27a7@x1.home>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Williamson <alex.williamson@redhat.com>
Cc: eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com, kevin.tian@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex,

On 1/11/19 10:30 PM, Alex Williamson wrote:
> On Tue,  8 Jan 2019 11:26:14 +0100
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
>> model specific IOMMU drivers need to convert them into their own format.
>>
>> Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
>> Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
>> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
>> Signed-off-by: Ashok Raj <ashok.raj@intel.com>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> v1 -> v2:
>> - add arch_id field
>> - renamed tlb_invalidate into cache_invalidate as this API allows
>>   to invalidate context caches on top of IOTLBs
>>
>> v1:
>> renamed sva_invalidate into tlb_invalidate and add iommu_ prefix in
>> header. Commit message reworded.
>> ---
>>  drivers/iommu/iommu.c      | 14 ++++++
>>  include/linux/iommu.h      | 14 ++++++
>>  include/uapi/linux/iommu.h | 95 ++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 123 insertions(+)
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 0f2b7f1fc7c8..b2e248770508 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -1403,6 +1403,20 @@ int iommu_set_pasid_table(struct iommu_domain *domain,
>>  }
>>  EXPORT_SYMBOL_GPL(iommu_set_pasid_table);
>>  
>> +int iommu_cache_invalidate(struct iommu_domain *domain, struct device *dev,
>> +			   struct iommu_cache_invalidate_info *inv_info)
>> +{
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
>> index 1da2a2357ea4..96d59886f230 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -186,6 +186,7 @@ struct iommu_resv_region {
>>   * @of_xlate: add OF master IDs to iommu grouping
>>   * @pgsize_bitmap: bitmap of all possible supported page sizes
>>   * @set_pasid_table: set pasid table
>> + * @cache_invalidate: invalidate translation caches
>>   */
>>  struct iommu_ops {
>>  	bool (*capable)(enum iommu_cap);
>> @@ -231,6 +232,9 @@ struct iommu_ops {
>>  	int (*set_pasid_table)(struct iommu_domain *domain,
>>  			       struct iommu_pasid_table_config *cfg);
>>  
>> +	int (*cache_invalidate)(struct iommu_domain *domain, struct device *dev,
>> +				struct iommu_cache_invalidate_info *inv_info);
>> +
>>  	unsigned long pgsize_bitmap;
>>  };
>>  
>> @@ -294,6 +298,9 @@ extern void iommu_detach_device(struct iommu_domain *domain,
>>  				struct device *dev);
>>  extern int iommu_set_pasid_table(struct iommu_domain *domain,
>>  				 struct iommu_pasid_table_config *cfg);
>> +extern int iommu_cache_invalidate(struct iommu_domain *domain,
>> +				struct device *dev,
>> +				struct iommu_cache_invalidate_info *inv_info);
>>  extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
>>  extern struct iommu_domain *iommu_get_dma_domain(struct device *dev);
>>  extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
>> @@ -709,6 +716,13 @@ int iommu_set_pasid_table(struct iommu_domain *domain,
>>  {
>>  	return -ENODEV;
>>  }
>> +static inline int
>> +iommu_cache_invalidate(struct iommu_domain *domain,
>> +		       struct device *dev,
>> +		       struct iommu_cache_invalidate_info *inv_info)
>> +{
>> +	return -ENODEV;
>> +}
>>  
>>  #endif /* CONFIG_IOMMU_API */
>>  
>> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
>> index 7a7cf7a3de7c..4605f5cfac84 100644
>> --- a/include/uapi/linux/iommu.h
>> +++ b/include/uapi/linux/iommu.h
>> @@ -47,4 +47,99 @@ struct iommu_pasid_table_config {
>>  	};
>>  };
>>  
>> +/**
>> + * enum iommu_inv_granularity - Generic invalidation granularity
>> + * @IOMMU_INV_GRANU_DOMAIN_ALL_PASID:	TLB entries or PASID caches of all
>> + *					PASIDs associated with a domain ID
>> + * @IOMMU_INV_GRANU_PASID_SEL:		TLB entries or PASID cache associated
>> + *					with a PASID and a domain
>> + * @IOMMU_INV_GRANU_PAGE_PASID:		TLB entries of selected page range
>> + *					within a PASID
>> + *
>> + * When an invalidation request is passed down to IOMMU to flush translation
>> + * caches, it may carry different granularity levels, which can be specific
>> + * to certain types of translation caches.
>> + * This enum is a collection of granularities for all types of translation
>> + * caches. The idea is to make it easy for IOMMU model specific driver to
>> + * convert from generic to model specific value. Each IOMMU driver
>> + * can enforce check based on its own conversion table. The conversion is
>> + * based on 2D look-up with inputs as follows:
>> + * - translation cache types
>> + * - granularity
>> + *
>> + *             type |   DTLB    |    TLB    |   PASID   |
>> + *  granule         |           |           |   cache   |
>> + * -----------------+-----------+-----------+-----------+
>> + *  DN_ALL_PASID    |   Y       |   Y       |   Y       |
>> + *  PASID_SEL       |   Y       |   Y       |   Y       |
>> + *  PAGE_PASID      |   Y       |   Y       |   N/A     |
>> + *
>> + */
>> +enum iommu_inv_granularity {
>> +	IOMMU_INV_GRANU_DOMAIN_ALL_PASID,
>> +	IOMMU_INV_GRANU_PASID_SEL,
>> +	IOMMU_INV_GRANU_PAGE_PASID,
>> +	IOMMU_INV_NR_GRANU,
>> +};
>> +
>> +/**
>> + * enum iommu_inv_type - Generic translation cache types for invalidation
>> + *
>> + * @IOMMU_INV_TYPE_DTLB:	device IOTLB
>> + * @IOMMU_INV_TYPE_TLB:		IOMMU paging structure cache
>> + * @IOMMU_INV_TYPE_PASID:	PASID cache
>> + * Invalidation requests sent to IOMMU for a given device need to indicate
>> + * which type of translation cache to be operated on. Combined with enum
>> + * iommu_inv_granularity, model specific driver can do a simple lookup to
>> + * convert from generic to model specific value.
>> + */
>> +enum iommu_inv_type {
>> +	IOMMU_INV_TYPE_DTLB,
>> +	IOMMU_INV_TYPE_TLB,
>> +	IOMMU_INV_TYPE_PASID,
>> +	IOMMU_INV_NR_TYPE
>> +};
>> +
>> +/**
>> + * Translation cache invalidation header that contains mandatory meta data.
>> + * @version:	info format version, expecting future extesions
>> + * @type:	type of translation cache to be invalidated
>> + */
>> +struct iommu_cache_invalidate_hdr {
>> +	__u32 version;
>> +#define TLB_INV_HDR_VERSION_1 1
>> +	enum iommu_inv_type type;
>> +};
>> +
>> +/**
>> + * Translation cache invalidation information, contains generic IOMMU
>> + * data which can be parsed based on model ID by model specific drivers.
>> + * Since the invalidation of second level page tables are included in the
>> + * unmap operation, this info is only applicable to the first level
>> + * translation caches, i.e. DMA request with PASID.
>> + *
>> + * @granularity:	requested invalidation granularity, type dependent
>> + * @size:		2^size of 4K pages, 0 for 4k, 9 for 2MB, etc.
> 
> Why is this a 4K page centric interface?
This matches the vt-d Address Mask (AM) field of the IOTLB Invalidate
Descriptor. We can pass a log2size instead.
> 
>> + * @nr_pages:		number of pages to invalidate
>> + * @pasid:		processor address space ID value per PCI spec.
>> + * @arch_id:		architecture dependent id characterizing a context
>> + *			and tagging the caches, ie. domain Identfier on VTD,
>> + *			asid on ARM SMMU
>> + * @addr:		page address to be invalidated
>> + * @flags		IOMMU_INVALIDATE_ADDR_LEAF: leaf paging entries
>> + *			IOMMU_INVALIDATE_GLOBAL_PAGE: global pages
> 
> Shouldn't some of these be tied the the granularity of the
> invalidation?  It seems like this should be more similar to
> iommu_pasid_table_config where the granularity of the invalidation
> defines which entry within a union at the end of the structure is valid
> and populated.  Otherwise we have fields that don't make sense for
> certain invalidations.

I am a little bit embarrassed here as this API version is the outcome of
long discussions held by Jacob, jean-Philippe and many others. I don't
want to hijack that work as I am "simply" reusing this API. Nevertheless
I am willing to help on this. So following your recommendation above I
dare to propose an updated API:

struct iommu_device_iotlb_inv_info {
        __u32   version;
#define IOMMU_DEV_IOTLB_INV_GLOBAL   0
#define IOMMU_DEV_IOTLB_INV_SOURCEID (1 << 0)
#define IOMMU_DEV_IOTLB_INV_PASID    (1 << 1)
        __u8    granularity;
        __u64   addr;
        __u8    log2size;
        __u64   sourceid;
        __u64   pasid;
        __u8    padding[2];
};

struct iommu_iotlb_inv_info {
        __u32   version;
#define IOMMU_IOTLB_INV_GLOBAL  0
#define IOMMU_IOTLB_INV_ARCHID  (1 << 0)
#define IOMMU_IOTLB_INV_PASID   (1 << 1)
#define IOMMU_IOTLB_INV_PAGE    (1 << 2)
        __u8    granularity;
        __u64   archid;
        __u64   pasid;
        __u64   addr;
        __u8    log2size;
        __u8    padding[2];
};

struct iommu_pasid_inv_info {
        __u32   version;
#define IOMMU_PASID_INV_GLOBAL     0
#define IOMMU_PASID_INV_ARCHID     (1 << 0)
#define IOMMU_PASID_INV_PASID      (1 << 1)
#define IOMMU_PASID_INV_SOURCEID   (1 << 2)
        __u8    granularity;
        __u64   archid;
        __u64   pasid;
        __u64   sourceid;
        __u8    padding[3];
};
/**
 * Translation cache invalidation information, contains generic IOMMU
 * data which can be parsed based on model ID by model specific drivers.
 * Since the invalidation of second level page tables are included in
 * the unmap operation, this info is only applicable to the first level
 * translation caches, i.e. DMA request with PASID.
 *
 */
struct iommu_cache_invalidate_info {
#define IOMMU_CACHE_INVALIDATE_INFO_VERSION_1 1
        __u32 version;
#define IOMMU_INV_TYPE_IOTLB        1 /* IOMMU paging structure cache */
#define IOMMU_INV_TYPE_DEV_IOTLB    2 /* Device IOTLB */
#define IOMMU_INV_TYPE_PASID        3 /* PASID cache */
        __u8 type;
        union {
                struct iommu_iotlb_invalidate_info iotlb_inv_info;
                struct iommu_dev_iotlb_invalidate_info dev_iotlb_inv_info;
                struct iommu_pasid_inv_info pasid_inv_info;
        };
};

At the moment I ignore the leaf bool parameter used on ARM for PASID
invalidation and TLB invalidation. Maybe we can just invalidate more
that the leaf cache structures at the moment?

on ARM the PASID table can be invalidated per streamid. On vt-d, as far
as I understand the sourceid does not tag the entries.





> 
>> + *
>> + */
>> +struct iommu_cache_invalidate_info {
>> +	struct iommu_cache_invalidate_hdr	hdr;
>> +	enum iommu_inv_granularity	granularity;
> 
> A separate structure for hdr seems a little pointless.
removed
> 
>> +	__u32		flags;
>> +#define IOMMU_INVALIDATE_ADDR_LEAF	(1 << 0)
>> +#define IOMMU_INVALIDATE_GLOBAL_PAGE	(1 << 1)
>> +	__u8		size;
> 
> Really need some padding or packing here for any hope of having
> consistency with userspace.
> 
>> +	__u64		nr_pages;
>> +	__u32		pasid;
> 
> Sub-optimal ordering for packing/padding.  Thanks,
I introduced some padding above. Is that OK?

Again if this introduces more noise than it helps I will simply rely on
initial contributors for the respin of their series according to your
comments. Also we if can't define generic enough structures for ARM and x86

Thanks

Eric
> 
> Alex
> 
>> +	__u64		arch_id;
>> +	__u64		addr;
>> +};
>>  #endif /* _UAPI_IOMMU_H */
> 
