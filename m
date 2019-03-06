From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v4 02/22] iommu: introduce device fault data
Date: Wed, 6 Mar 2019 18:32:54 +0100
Message-ID: <0268700f-4b9e-0804-870b-37eb1818ab64@redhat.com>
References: <20190218135504.25048-1-eric.auger@redhat.com>
 <20190218135504.25048-3-eric.auger@redhat.com>
 <c9adfbda-b78a-405a-a691-9f99d7dc2a26@arm.com>
 <742a6ce1-0182-ad56-fccf-65967d9bf280@redhat.com>
 <4d9b1f13-4fa4-c209-0645-71c1b4b2f646@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4d9b1f13-4fa4-c209-0645-71c1b4b2f646@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: marc.zyngier@arm.com, peter.maydell@linaro.org, kevin.tian@intel.com, ashok.raj@intel.com, christoffer.dall@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jean,
On 3/6/19 5:07 PM, Jean-Philippe Brucker wrote:
> On 06/03/2019 14:30, Auger Eric wrote:
>>>> +#define IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE	(1 << 1)
>>>> +#define IOMMU_FAULT_PAGE_REQUEST_PRIV_DATA	(1 << 2)
>>>> +	__u32   flags;
>>>> +	__u32	pasid;
>>>> +	__u32	grpid;
>>>> +	__u32	perm;
>>>> +	__u64	addr;
>>>
>>> Given that we'll be reporting stall faults using this struct, it would
>>> be good to have the fetch_addr field and flag here as well.
>> As the stall model looks really ARM specific shouldn't we introduce a
>> dedicated struct and iommu_fault_type enum value?
> 
> There is no reason for the generic page fault handler to differentiate
> between stall and PRI, they are page requests. For a stall we write STAG
> into grpid and set LAST_PAGE=1. Then the SMMU driver writes the page
> response either as a PRI_RESP or a RESUME depending on the device type.

OK. After reading the spec I thought STALL faults could have a larger
scope than just PRI.
> 
>> Also for stall faults don't we need to expose the stall tag (STAG) that,
>> as far as I understand is going to be used by the guest we it wants to
>> retry or terminate the faulted transaction. In practice doesn't the
>> stall fault have the same fields of the unrecoverable fault + STAG? I am
>> afraid adding the fetch_addr in the page request struct may "pollute"
>> the PRI struct that can be understood by both aarch64 and x86 parties atm.
> 
> Let's leave out the fetch_addr field then, I was suggesting it for
> completeness but I don't need it immediately, at least not for host SVA.
> For dual-stage SVA (where both stage-1 and stage-2 are shared with the
> CPU) we'll need the IPA field, but that's still a long way away.
OK So I don't add fetch_addr at the moment.
> 
>> Also couldn't we envision to put this STALL struct in a new revision of
>> the fault ABI.
> As said above, generic code doesn't have to know the difference until we
> start implementing nested SVA. Also, we need stall support in the fault
> handler soon, since there is hardware supporting it.

OK so we will use page request structs.

Thanks

Eric
> 
> Thanks,
> Jean
> 
