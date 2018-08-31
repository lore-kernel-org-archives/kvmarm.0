From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [RFC 01/13] iommu: Introduce bind_guest_stage API
Date: Fri, 31 Aug 2018 14:11:14 +0100
Message-ID: <b7909f1b-57ce-f4db-d916-140a63283232@arm.com>
References: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
 <1535026656-8450-2-git-send-email-eric.auger@redhat.com>
 <22c01a4d-c74a-7279-d4ae-39e29a3bc942@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <22c01a4d-c74a-7279-d4ae-39e29a3bc942@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>, eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: marc.zyngier@arm.com, peter.maydell@linaro.org, christoffer.dall@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On 23/08/18 16:25, Auger Eric wrote:
>> +int iommu_bind_guest_stage(struct iommu_domain *domain, struct device *dev,
>> +			   struct iommu_guest_stage_config *cfg)

About the name change from iommu_bind_pasid_table: is the intent to
reuse this API for SMMUv2, which supports nested but not PASID? Seems
like a good idea but "iommu_bind_table" may be better since "stage" is
only used by Arm.

>> +/**
>> + * PASID table data used to bind guest PASID table to the host IOMMU. This will
>> + * enable guest managed first level page tables.
>> + * @version: for future extensions and identification of the data format
>> + * @bytes: size of this structure
>> + * @base_ptr:	PASID table pointer
>> + * @pasid_bits:	number of bits supported in the guest PASID table, must be less
>> + *		or equal than the host supported PASID size.
>> + */
>> +struct iommu_pasid_table_config {
>> +	__u32 version;
>> +#define PASID_TABLE_CFG_VERSION_1 1
>> +	__u32 bytes;
>> +	__u64 base_ptr;
>> +	__u8 pasid_bits;
>> +};
>> +
>> +/**
>> + * Stream Table Entry S1 info
>> + * @disabled: the smmu is disabled
>> + * @bypassed: stage 1 is bypassed
>> + * @aborted: aborted
>> + * @cdptr_dma: GPA of the Context Descriptor
>> + * @asid: address space identified associated to the CD
>> + */
>> +struct iommu_smmu_s1_config {
>> +	__u8 disabled;
>> +	__u8 bypassed;
>> +	__u8 aborted;
>> +	__u64 cdptr_dma;
>> +	__u16 asid;
> This asid field is a leftover. asid is part of the CD (owned by the
> guest) and cannot be conveyed through this API. What is relevant is to
> pass is the guest asid_bits (vSMMU IDR1 info), to be compared with the
> host one. So we end up having something similar to the base_ptr and
> pasid_bits of iommu_pasid_table_config.

That part seems strange. Userspace wouldn't try arbitrary ASID sizes
until one fits, especially since ASID size isn't the only parameter:
there will be SSID, IOVA, IPA sizes, HTTU features and I guess any other
SMMU_IDRx bit that corresponds to a field in the CD or STE. Doesn't
vSMMU need to tailor its IDR registers to whatever is supported by the
host SMMU, in order to use nested translation?

Before creating the virtual ID registers, userspace will likely want to
know more about the physical IOMMU, by querying the kernel. I wrote
something about that interface recently:
https://www.spinics.net/lists/iommu/msg28039.html

And if you provide this interface, checking the parameters again in
BIND_GUEST_STAGE isn't very useful, it only tells you that userspace
read your values. Once the guest writes the CD, it could still use the
wrong ASID size or some other invalid config. That would be caught by
the SMMU walker and cause a C_BAD_CD error report.

> Otherwise, the other fields (disable, bypassed, aborted) can be packed
> as masks in a _u8 flag.

What's the difference between aborted and disabled? I'm also not sure we
should give such fine tweaks to userspace, since the STE code is already
pretty complicated and has to deal with several state transitions.
Existing behavior (1) (2) (5) probably needs to be preserved:

(1) Initially no container is set, s1-translate s2-bypass with the
default domain (non-VFIO)
(2) A VFIO_TYPE1_NESTING_IOMMU container is set, s1-bypass s2-translate
(3) BIND_GUEST_STAGE, s1-translate s2-translate
(4) UNBIND_GUEST_STAGE, s1-bypass s2-translate
(5) Remove container, s1-translate s2-bypass with the default domain

That said, when instantiating a vSMMU, QEMU may want to switch from (2)
to an intermediate "s1-abort s2-translate" state. At the moment with
virtio-iommu I only create the stage-2 mappings at (3). This ensures
that transactions abort until the guest configures the vIOMMU and it
keeps the host driver simple, but it has the downside of pinning guest
memory lazily (necessary with virtio-iommu since the guest falls back to
the map/unmap interface, which doesn't pin all memory upfront, if it
can't support nested).

> Anyway this API still is at the stage of proof of concept. At least it
> shows the similarities between that use case and the PASID one and
> should encourage to discuss about the relevance to have a unified API to
> pass the guest stage info.
Other required fields in the BIND_GUEST_STAGE ioctl are at least s1dss,
s1cdmax and s1fmt. It's not for sanity-check, they describe the guest
configuration. The guest selects a PASID table format (1-level, 2-level
4k/64k) which is written into STE.s1fmt. It also selects the behavior of
requests-without-pasid, which is written into STE.s1dss. s1cdmax
corresponds to pasid_bits.

Thanks,
Jean
