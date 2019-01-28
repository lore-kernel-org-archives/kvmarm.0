From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [RFC v3 02/21] iommu: Introduce cache_invalidate API
Date: Mon, 28 Jan 2019 17:32:42 +0000
Message-ID: <a69ab354-1742-d962-7f2a-f1266d79d060@arm.com>
References: <20190108102633.17482-1-eric.auger@redhat.com>
 <20190108102633.17482-3-eric.auger@redhat.com>
 <20190111143042.183a27a7@x1.home>
 <66653430-514f-2b4b-3d93-348deb6cd490@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A63594A2F8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Jan 2019 12:33:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l-uJ53C1P-Zg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Jan 2019 12:33:00 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC6894A2BE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Jan 2019 12:32:59 -0500 (EST)
In-Reply-To: <66653430-514f-2b4b-3d93-348deb6cd490@redhat.com>
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
To: Auger Eric <eric.auger@redhat.com>, Alex Williamson <alex.williamson@redhat.com>
Cc: yi.l.liu@linux.intel.com, kevin.tian@intel.com, ashok.raj@intel.com, kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On 25/01/2019 16:49, Auger Eric wrote:
[...]
>>> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
>>> index 7a7cf7a3de7c..4605f5cfac84 100644
>>> --- a/include/uapi/linux/iommu.h
>>> +++ b/include/uapi/linux/iommu.h
>>> @@ -47,4 +47,99 @@ struct iommu_pasid_table_config {
>>>  	};
>>>  };
>>>  
>>> +/**
>>> + * enum iommu_inv_granularity - Generic invalidation granularity
>>> + * @IOMMU_INV_GRANU_DOMAIN_ALL_PASID:	TLB entries or PASID caches of all
>>> + *					PASIDs associated with a domain ID
>>> + * @IOMMU_INV_GRANU_PASID_SEL:		TLB entries or PASID cache associated
>>> + *					with a PASID and a domain
>>> + * @IOMMU_INV_GRANU_PAGE_PASID:		TLB entries of selected page range
>>> + *					within a PASID
>>> + *
>>> + * When an invalidation request is passed down to IOMMU to flush translation
>>> + * caches, it may carry different granularity levels, which can be specific
>>> + * to certain types of translation caches.
>>> + * This enum is a collection of granularities for all types of translation
>>> + * caches. The idea is to make it easy for IOMMU model specific driver to
>>> + * convert from generic to model specific value. Each IOMMU driver
>>> + * can enforce check based on its own conversion table. The conversion is
>>> + * based on 2D look-up with inputs as follows:
>>> + * - translation cache types
>>> + * - granularity
>>> + *
>>> + *             type |   DTLB    |    TLB    |   PASID   |
>>> + *  granule         |           |           |   cache   |
>>> + * -----------------+-----------+-----------+-----------+
>>> + *  DN_ALL_PASID    |   Y       |   Y       |   Y       |
>>> + *  PASID_SEL       |   Y       |   Y       |   Y       |
>>> + *  PAGE_PASID      |   Y       |   Y       |   N/A     |
>>> + *
>>> + */
>>> +enum iommu_inv_granularity {
>>> +	IOMMU_INV_GRANU_DOMAIN_ALL_PASID,
>>> +	IOMMU_INV_GRANU_PASID_SEL,
>>> +	IOMMU_INV_GRANU_PAGE_PASID,
>>> +	IOMMU_INV_NR_GRANU,
>>> +};
>>> +
>>> +/**
>>> + * enum iommu_inv_type - Generic translation cache types for invalidation
>>> + *
>>> + * @IOMMU_INV_TYPE_DTLB:	device IOTLB
>>> + * @IOMMU_INV_TYPE_TLB:		IOMMU paging structure cache
>>> + * @IOMMU_INV_TYPE_PASID:	PASID cache
>>> + * Invalidation requests sent to IOMMU for a given device need to indicate
>>> + * which type of translation cache to be operated on. Combined with enum
>>> + * iommu_inv_granularity, model specific driver can do a simple lookup to
>>> + * convert from generic to model specific value.
>>> + */
>>> +enum iommu_inv_type {
>>> +	IOMMU_INV_TYPE_DTLB,
>>> +	IOMMU_INV_TYPE_TLB,
>>> +	IOMMU_INV_TYPE_PASID,
>>> +	IOMMU_INV_NR_TYPE
>>> +};
>>> +
>>> +/**
>>> + * Translation cache invalidation header that contains mandatory meta data.
>>> + * @version:	info format version, expecting future extesions
>>> + * @type:	type of translation cache to be invalidated
>>> + */
>>> +struct iommu_cache_invalidate_hdr {
>>> +	__u32 version;
>>> +#define TLB_INV_HDR_VERSION_1 1
>>> +	enum iommu_inv_type type;
>>> +};
>>> +
>>> +/**
>>> + * Translation cache invalidation information, contains generic IOMMU
>>> + * data which can be parsed based on model ID by model specific drivers.
>>> + * Since the invalidation of second level page tables are included in the
>>> + * unmap operation, this info is only applicable to the first level
>>> + * translation caches, i.e. DMA request with PASID.
>>> + *
>>> + * @granularity:	requested invalidation granularity, type dependent
>>> + * @size:		2^size of 4K pages, 0 for 4k, 9 for 2MB, etc.
>>
>> Why is this a 4K page centric interface?
> This matches the vt-d Address Mask (AM) field of the IOTLB Invalidate
> Descriptor. We can pass a log2size instead.
>>
>>> + * @nr_pages:		number of pages to invalidate
>>> + * @pasid:		processor address space ID value per PCI spec.
>>> + * @arch_id:		architecture dependent id characterizing a context
>>> + *			and tagging the caches, ie. domain Identfier on VTD,
>>> + *			asid on ARM SMMU
>>> + * @addr:		page address to be invalidated
>>> + * @flags		IOMMU_INVALIDATE_ADDR_LEAF: leaf paging entries
>>> + *			IOMMU_INVALIDATE_GLOBAL_PAGE: global pages
>>
>> Shouldn't some of these be tied the the granularity of the
>> invalidation?  It seems like this should be more similar to
>> iommu_pasid_table_config where the granularity of the invalidation
>> defines which entry within a union at the end of the structure is valid
>> and populated.  Otherwise we have fields that don't make sense for
>> certain invalidations.
> 
> I am a little bit embarrassed here as this API version is the outcome of
> long discussions held by Jacob, jean-Philippe and many others. I don't
> want to hijack that work as I am "simply" reusing this API. Nevertheless
> I am willing to help on this. So following your recommendation above I
> dare to propose an updated API:

Discussing this again is completely fine by me. I have some concerns
with this proposal though, some of which apply to our previous versions
as well.

> struct iommu_device_iotlb_inv_info {
>         __u32   version;
> #define IOMMU_DEV_IOTLB_INV_GLOBAL   0
> #define IOMMU_DEV_IOTLB_INV_SOURCEID (1 << 0)
> #define IOMMU_DEV_IOTLB_INV_PASID    (1 << 1)
>         __u8    granularity;
>         __u64   addr;
>         __u8    log2size;
>         __u64   sourceid;
>         __u64   pasid;
>         __u8    padding[2];
> };
> 
> struct iommu_iotlb_inv_info {
>         __u32   version;
> #define IOMMU_IOTLB_INV_GLOBAL  0

Using "global" for granularity=0 will be confusing, let's call this
"domain" instead. In the SMMU and ATS specifications (and I think VT-d
as well), the global flag is used to invalidate VA ranges that are
cached for all PASIDs. In the Arm architecture these TLB entries are
created from PTE entries without the "nG" bit. So "global" usually means
granularity=IOMMU_IOTLB_INV_PAGE.

> #define IOMMU_IOTLB_INV_ARCHID  (1 << 0)
> #define IOMMU_IOTLB_INV_PASID   (1 << 1)
> #define IOMMU_IOTLB_INV_PAGE    (1 << 2)

We might as well call this bit "INV_ADDR" to make it clear that it
describes the validity of field @addr.

>         __u8    granularity;
>         __u64   archid;
>         __u64   pasid;
>         __u64   addr;
>         __u8    log2size;
>         __u8    padding[2];
> };
> 
> struct iommu_pasid_inv_info {
>         __u32   version;
> #define IOMMU_PASID_INV_GLOBAL     0
> #define IOMMU_PASID_INV_ARCHID     (1 << 0)
> #define IOMMU_PASID_INV_PASID      (1 << 1)
> #define IOMMU_PASID_INV_SOURCEID   (1 << 2)
>         __u8    granularity;
>         __u64   archid;
>         __u64   pasid;
>         __u64   sourceid;
>         __u8    padding[3];
> };
> /**
>  * Translation cache invalidation information, contains generic IOMMU
>  * data which can be parsed based on model ID by model specific drivers.
>  * Since the invalidation of second level page tables are included in
>  * the unmap operation, this info is only applicable to the first level
>  * translation caches, i.e. DMA request with PASID.
>  *
>  */
> struct iommu_cache_invalidate_info {
> #define IOMMU_CACHE_INVALIDATE_INFO_VERSION_1 1
>         __u32 version;
> #define IOMMU_INV_TYPE_IOTLB        1 /* IOMMU paging structure cache */
> #define IOMMU_INV_TYPE_DEV_IOTLB    2 /* Device IOTLB */
> #define IOMMU_INV_TYPE_PASID        3 /* PASID cache */
>         __u8 type;
>         union {
>                 struct iommu_iotlb_invalidate_info iotlb_inv_info;
>                 struct iommu_dev_iotlb_invalidate_info dev_iotlb_inv_info;
>                 struct iommu_pasid_inv_info pasid_inv_info;
>         };
> };

Although I find the new structure and field names clearer in general, I
believe we're losing something by splitting structures this way.

The one concept I'd like to keep is the possibility to multiplex ATC and
IOTLB invalidation. That is, when unmapping a range, the guest (using a
pvIOMMU) shouldn't need to send both iotlb_inv and device_iotlb_inv to
the host - it's completely redundant. Instead the host IOMMU driver
should receive a single invalidation packet, and send both TLB and ATC
invalidation to the hardware.

So in my opinion the invalidation type needs to be a bitfield: userspace
can select either TYPE_IOTLB, TYPE_DEV_IOTLB, or both. And if type is a
bitfield, the content that follows has to be a single structure.

Same for the PASID cache: when the guest changes the config for a PASID,
it shouldn't have to also send TLB and ATC invalidations. A single
packet should be enough. However config changes won't be a fast path, so
optimizing the API is less important here.

We could say that IOMMU_INV_TYPE_IOTLB implies IOMMU_INV_TYPE_DEV_IOTLB,
and that IOMMU_INV_TYPE_PASID implies the others. In fact I think we do,
in this patch. But that in turn would be suboptimal with vSMMU and other
emulated solutions, which will receive both TLB and ATC invalidation
from the guest, and have to signal both separately to the kernel. So for
@type, a bitfield would be best.

If we want to split the structure, I think splitting by @granularity
might make more sense. It might require at least 4 structures:
* domain invalidation:		granule = 0
* pasid invalidation:		granule = pasid|archid
* global va invalidation:	granule = addr
* va invalidation		granule = pasid|archid|addr

> At the moment I ignore the leaf bool parameter used on ARM for PASID
> invalidation and TLB invalidation. Maybe we can just invalidate more
> that the leaf cache structures at the moment?

Sure, though we could add a flags field and leave it unused for now,
which is easier to extend than introducing a new version. I wonder if
Intel's Invalidation Hint (IH) does the same as Arm's leaf flag?

> on ARM the PASID table can be invalidated per streamid. On vt-d, as far
> as I understand the sourceid does not tag the entries.

I don't think sourceid is the right thing to use in this interface. The
device ID (streamid or sourceid) that the IOMMU sees in DMA transactions
isn't really made visible to userspace. And for mdev it doesn't really
exist, VFIO will have to pass the parent device's handle to IOMMU.

To userspace a device is identified by the fd provided by VFIO. So if we
do want to have device-scope in the invalidation (as opposed to
the current domain-scope) I think userspace needs to provide a device fd
to VFIO (outside the structures defined here), and then VFIO would pass
a struct device to iommu_cache_inval().

Thanks,
Jean

>>
>>> + *
>>> + */
>>> +struct iommu_cache_invalidate_info {
>>> +	struct iommu_cache_invalidate_hdr	hdr;
>>> +	enum iommu_inv_granularity	granularity;
>>
>> A separate structure for hdr seems a little pointless.
> removed
>>
>>> +	__u32		flags;
>>> +#define IOMMU_INVALIDATE_ADDR_LEAF	(1 << 0)
>>> +#define IOMMU_INVALIDATE_GLOBAL_PAGE	(1 << 1)
>>> +	__u8		size;
>>
>> Really need some padding or packing here for any hope of having
>> consistency with userspace.
>>
>>> +	__u64		nr_pages;
>>> +	__u32		pasid;
>>
>> Sub-optimal ordering for packing/padding.  Thanks,
> I introduced some padding above. Is that OK?
> 
> Again if this introduces more noise than it helps I will simply rely on
> initial contributors for the respin of their series according to your
> comments. Also we if can't define generic enough structures for ARM and x86
> 
> Thanks
> 
> Eric
>>
>> Alex
>>
>>> +	__u64		arch_id;
>>> +	__u64		addr;
>>> +};
>>>  #endif /* _UAPI_IOMMU_H */
>>
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
> 
