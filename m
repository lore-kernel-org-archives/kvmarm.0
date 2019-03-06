From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH v4 02/22] iommu: introduce device fault data
Date: Wed, 6 Mar 2019 12:08:03 +0000
Message-ID: <27abc9b6-f914-8f69-a232-c3345563277c@arm.com>
References: <20190218135504.25048-1-eric.auger@redhat.com>
 <20190218135504.25048-3-eric.auger@redhat.com>
 <c9adfbda-b78a-405a-a691-9f99d7dc2a26@arm.com>
 <43c5c3be-a609-62e1-efaa-c5571bb762c6@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <43c5c3be-a609-62e1-efaa-c5571bb762c6@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>, "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "joro@8bytes.org" <joro@8bytes.org>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>, "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>, Will Deacon <Will.Deacon@arm.com>, Robin Murphy <Robin.Murphy@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>, "kevin.tian@intel.com" <kevin.tian@intel.com>, "ashok.raj@intel.com" <ashok.raj@intel.com>, Christoffer Dall <Christoffer.Dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/03/2019 09:38, Auger Eric wrote:
>>> +struct iommu_fault_unrecoverable {
>>> +    __u32   reason; /* enum iommu_fault_reason */
>>> +#define IOMMU_FAULT_UNRECOV_PASID_VALID             (1 << 0)
>>> +#define IOMMU_FAULT_UNRECOV_PERM_VALID              (1 << 1)
>> 
>> Not needed, since @perm is already a bitfield
> not exactly, READ is encoded as 0. We need to differentiate read fault
> from no perm provided. However if I follow your recommendation below and
> transform the READ FAULT into a set bit this makes sense.

Ah yes, seeing four defines I assumed read was in there. No need for
INST I think, it's already described by EXEC

>>> +#define IOMMU_FAULT_UNRECOV_ADDR_VALID              (1 << 2)
>>> +#define IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID        (1 << 3)
>>> +    __u32   flags;
>>> +    __u32   pasid;
>>> +#define IOMMU_FAULT_PERM_WRITE      (1 << 0) /* write */
>>> +#define IOMMU_FAULT_PERM_EXEC       (1 << 1) /* exec */
>>> +#define IOMMU_FAULT_PERM_PRIV       (1 << 2) /* priviledged */
>> 
>> typo "privileged"
> OK
>> 
>>> +#define IOMMU_FAULT_PERM_INST       (1 << 3) /* instruction */
>> 
>> Could you move these outside the struct definition? They are shared with
>> the other struct. And it would be less confusing, from the device driver
>> point of view, to merge those with the existing IOMMU_FAULT_* defines
>> (but moving them to UAPI and making them bits)
> ok I will look at this. Need to check if the read fault value is not
> hardcoded anywhere.

Oh right, looks like a couple of IOMMU drivers do. Hard to say if they
mean READ or just "don't care", at first glance. I guess we can keep the
FAULT_PERM variant until we actually unify the fault reporting API (not
overly complicated since there are three users. I have patches for that
buried somewhere)

>> 
>>> +    __u32   perm;
>>> +    __u64   addr;
>>> +    __u64   fetch_addr;
>>> +};
>>> +
>>> +/*
>>> + * Page Request data (aka. recoverable fault data)
>>> + * @flags : encodes whether the pasid is valid and whether this
>>> + * is the last page in group
>>> + * @pasid: pasid
>>> + * @grpid: page request group index
>>> + * @perm: requested page permissions
>>> + * @addr: page address
>>> + */
>>> +struct iommu_fault_page_request {
>>> +#define IOMMU_FAULT_PAGE_REQUEST_PASID_PRESENT      (1 << 0)
>> 
>> PASID_VALID, to be consistent with the other set of flags?
> OK
>> 
>>> +#define IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE  (1 << 1)
>>> +#define IOMMU_FAULT_PAGE_REQUEST_PRIV_DATA  (1 << 2)
>>> +    __u32   flags;
>>> +    __u32   pasid;
>>> +    __u32   grpid;
>>> +    __u32   perm;
>>> +    __u64   addr;
>> 
>> Given that we'll be reporting stall faults using this struct, it would
>> be good to have the fetch_addr field and flag here as well.
> OK
>> 
>>> +    __u64   private_data[2];
>>> +};
>>> +
>>> +/**
>>> + * struct iommu_fault - Generic fault data
>>> + *
>>> + * @type contains fault type
>>> + */
>>> +
>>> +struct iommu_fault {
>>> +    __u32   type;   /* enum iommu_fault_type */
>>> +    __u32   reserved;
>>> +    union {
>>> +            struct iommu_fault_unrecoverable event;
>>> +            struct iommu_fault_page_request prm;
>> 
>> What's the 'm' in "prm"? Maybe just "pr"?
> This stands for page request message, I think this is the Intel's naming?

Looks like it's the PCI naming, let's stick with it then

Thanks,
Jean
