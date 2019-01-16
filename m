From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [RFC v3 14/21] iommu: introduce device fault data
Date: Wed, 16 Jan 2019 15:52:20 +0000
Message-ID: <519a1669-1343-1296-8f04-6ba63085d9a5@arm.com>
References: <20190108102633.17482-1-eric.auger@redhat.com>
 <20190108102633.17482-15-eric.auger@redhat.com>
 <20190110104544.26f3bcb1@jacob-builder>
 <63a19100-c3dd-9dbd-b37a-9dfbe254459e@arm.com>
 <20190114143208.66eac25a@jacob-builder>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190114143208.66eac25a@jacob-builder>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>, "ashok.raj@intel.com" <ashok.raj@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, Christoffer Dall <Christoffer.Dall@arm.com>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, Robin Murphy <Robin.Murphy@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 14/01/2019 22:32, Jacob Pan wrote:
>> [...]
>>>> +/**
>>>> + * struct iommu_fault - Generic fault data
>>>> + *
>>>> + * @type contains fault type
>>>> + * @reason fault reasons if relevant outside IOMMU driver.
>>>> + * IOMMU driver internal faults are not reported.
>>>> + * @addr: tells the offending page address
>>>> + * @fetch_addr: tells the address that caused an abort, if any
>>>> + * @pasid: contains process address space ID, used in shared
>>>> virtual memory
>>>> + * @page_req_group_id: page request group index
>>>> + * @last_req: last request in a page request group
>>>> + * @pasid_valid: indicates if the PRQ has a valid PASID
>>>> + * @prot: page access protection flag:
>>>> + *	IOMMU_FAULT_READ, IOMMU_FAULT_WRITE
>>>> + */
>>>> +
>>>> +struct iommu_fault {
>>>> +	__u32	type;   /* enum iommu_fault_type */
>>>> +	__u32	reason; /* enum iommu_fault_reason */
>>>> +	__u64	addr;
>>>> +	__u64	fetch_addr;
>>>> +	__u32	pasid;
>>>> +	__u32	page_req_group_id;
>>>> +	__u32	last_req;
>>>> +	__u32	pasid_valid;
>>>> +	__u32	prot;
>>>> +	__u32	access;  
>>
>> What does @access contain? Can it be squashed into @prot?
>>
> I agreed.
> 
> how about this?
> #define IOMMU_FAULT_VERSION_V1 0x1
> struct iommu_fault {
> 	__u16 version;

Right, but the version field becomes redundant when we present a batch
of these to userspace, in patch 18 (assuming we don't want to mix fault
structure versions within a batch... I certainly don't).

When introducing IOMMU_FAULT_VERSION_V2, in a distant future, I think we
still need to support a userspace that uses IOMMU_FAULT_VERSION_V1. One
strategy for this:

* We define structs iommu_fault_v1 (the current iommu_fault) and
  iommu_fault_v2.
* Userspace selects IOMMU_FAULT_VERSION_V1 when registering the fault
  queue
* The IOMMU driver fills iommu_fault_v2 and passes it to VFIO
* VFIO does its best to translate this into a iommu_fault_v1 struct

So what we need now, is a way for userspace to tell the kernel which
structure version it expects. I'm not sure we even need to pass the
actual version number we're using back to userspace. Agreeing on one
version at registration should be sufficient.

> 	__u16 type;
> 	__u32 reason;
> 	__u64 addr;

I'm in favor of keeping @fetch_addr as well, it can contain useful
information. For example, while attempting to translate an IOVA
0xfffff000, the IOMMU can't find the PASID table that we installed with
address 0xdead - the guest passed an invalid address to
bind_pasid_table(). We can then report 0xfffff000 in @addr, and 0xdead
in @fetch_addr.

> 	__u32 pasid;
> 	__u32 page_req_group_id;
> 	__u32 last_req : 1;
> 	__u32 pasid_valid : 1;

Agreed, with some explicit padding or combined as a @flag field. In fact
if we do add the @fetch_addr field, I think we need a bit that indicates
its validity as well.

Thanks,
Jean

> 	__u32 prot;
> 	__u64 device_private[2];
> 	__u8 padding[48];
> };
> 
> 
>> Thanks,
>> Jean
>>
>>> relocated to uapi, Yi can you confirm?
>>> 	__u64 device_private[2];
>>>   
>>>> +};
>>>>  #endif /* _UAPI_IOMMU_H */  
>>>
>>> _______________________________________________
>>> iommu mailing list
>>> iommu@lists.linux-foundation.org
>>> https://lists.linuxfoundation.org/mailman/listinfo/iommu
>>>   
>>
> 
> [Jacob Pan]
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
> 
