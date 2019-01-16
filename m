From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [RFC v3 14/21] iommu: introduce device fault data
Date: Wed, 16 Jan 2019 16:54:33 +0000
Message-ID: <99e03a7e-2a5c-5f8f-5a16-e01088c59fff@arm.com>
References: <20190108102633.17482-1-eric.auger@redhat.com>
 <20190108102633.17482-15-eric.auger@redhat.com>
 <20190110104544.26f3bcb1@jacob-builder>
 <63a19100-c3dd-9dbd-b37a-9dfbe254459e@arm.com>
 <07fc2059-3a4e-6b36-262b-779eb98b2334@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F22F24A3B5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jan 2019 11:54:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sc-wvOQ9y4gx for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Jan 2019 11:54:52 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92A484A3A8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jan 2019 11:54:52 -0500 (EST)
In-Reply-To: <07fc2059-3a4e-6b36-262b-779eb98b2334@redhat.com>
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
To: Auger Eric <eric.auger@redhat.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: "kevin.tian@intel.com" <kevin.tian@intel.com>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "ashok.raj@intel.com" <ashok.raj@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>, Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, Robin Murphy <Robin.Murphy@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 15/01/2019 21:27, Auger Eric wrote:
[...]
>>>>  /* iommu fault flags */
>>>> -#define IOMMU_FAULT_READ	0x0
>>>> -#define IOMMU_FAULT_WRITE	0x1
>>>> +#define IOMMU_FAULT_READ		(1 << 0)
>>>> +#define IOMMU_FAULT_WRITE		(1 << 1)
>>>> +#define IOMMU_FAULT_EXEC		(1 << 2)
>>>> +#define IOMMU_FAULT_PRIV		(1 << 3)
>>>>  
>>>>  typedef int (*iommu_fault_handler_t)(struct iommu_domain *,
>>>>  			struct device *, unsigned long, int, void *);
>>>> +typedef int (*iommu_dev_fault_handler_t)(struct iommu_fault_event *,
>>>> void *); 
>>>>  struct iommu_domain_geometry {
>>>>  	dma_addr_t aperture_start; /* First address that can be
>>>> mapped    */ @@ -255,6 +259,52 @@ struct iommu_device {
>>>>  	struct device *dev;
>>>>  };
>>>>  
>>>> +/**
>>>> + * struct iommu_fault_event - Generic per device fault data
>>>> + *
>>>> + * - PCI and non-PCI devices
>>>> + * - Recoverable faults (e.g. page request), information based on
>>>> PCI ATS
>>>> + * and PASID spec.
>>>> + * - Un-recoverable faults of device interest
>>>> + * - DMA remapping and IRQ remapping faults
>>>> + *
>>>> + * @fault: fault descriptor
>>>> + * @device_private: if present, uniquely identify device-specific
>>>> + *                  private data for an individual page request.
>>>> + * @iommu_private: used by the IOMMU driver for storing
>>>> fault-specific
>>>> + *                 data. Users should not modify this field before
>>>> + *                 sending the fault response.
>>>> + */
>>>> +struct iommu_fault_event {
>>>> +	struct iommu_fault fault;
>>>> +	u64 device_private;
>>> I think we want to move device_private to uapi since it gets injected
>>> into the guest, then returned by guest in case of page response. For
>>> VT-d we also need 128 bits of private data. VT-d spec. 7.7.1
>>
>> Ah, I didn't notice the format changed in VT-d rev3. On that topic, how
>> do we manage future extensions to the iommu_fault struct? Should we add
>> ~48 bytes of padding after device_private, along with some flags telling
>> which field is valid, or deal with it using a structure version like we
>> do for the invalidate and bind structs? In the first case, iommu_fault
>> wouldn't fit in a 64-byte cacheline anymore, but I'm not sure we care.
>>
>>> For exception tracking (e.g. unanswered page request), I can add timer
>>> and list info later when I include PRQ. sounds ok?
>>>> +	u64 iommu_private;
>> [...]
>>>> +/**
>>>> + * struct iommu_fault - Generic fault data
>>>> + *
>>>> + * @type contains fault type
>>>> + * @reason fault reasons if relevant outside IOMMU driver.
>>>> + * IOMMU driver internal faults are not reported.
>>>> + * @addr: tells the offending page address
>>>> + * @fetch_addr: tells the address that caused an abort, if any
>>>> + * @pasid: contains process address space ID, used in shared virtual
>>>> memory
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
> it was related to F_ACCESS event record and was a placeholder for
> reporting access attributes of the input transaction (Rnw, InD, PnU
> fields). But I wonder whether this is needed to implement such fine
> level fault reporting. Do we really care?

I think we do, to properly inject PRI/Stall later. But RnW, InD and PnU
can already be described with the IOMMU_FAULT_* flags defined above.
We're missing CLASS and S2, which could also be useful for debugging.
CLASS is specific to SMMUv3 but could probably be represented with
@reason. For S2, we could keep printing stage-2 faults in the driver,
and not report them to userspace.

Thanks,
Jean
