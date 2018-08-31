From: Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC 01/13] iommu: Introduce bind_guest_stage API
Date: Fri, 31 Aug 2018 15:52:27 +0200
Message-ID: <4309832b-27ed-597a-b5a1-f439fbea9843@redhat.com>
References: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
	<1535026656-8450-2-git-send-email-eric.auger@redhat.com>
	<22c01a4d-c74a-7279-d4ae-39e29a3bc942@redhat.com>
	<b7909f1b-57ce-f4db-d916-140a63283232@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <b7909f1b-57ce-f4db-d916-140a63283232-5wv7dgnIgG8@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>, eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yi.l.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, robin.murphy-5wv7dgnIgG8@public.gmane.org
Cc: marc.zyngier-5wv7dgnIgG8@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, christoffer.dall-5wv7dgnIgG8@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jean-Philippe,

On 08/31/2018 03:11 PM, Jean-Philippe Brucker wrote:
> Hi Eric,
> 
> On 23/08/18 16:25, Auger Eric wrote:
>>> +int iommu_bind_guest_stage(struct iommu_domain *domain, struct device *dev,
>>> +			   struct iommu_guest_stage_config *cfg)
> 
> About the name change from iommu_bind_pasid_table: is the intent to
> reuse this API for SMMUv2, which supports nested but not PASID? Seems
> like a good idea but "iommu_bind_table" may be better since "stage" is
> only used by Arm.

At the moment I don't target SMUv2 but just SMMUv3. My focus was on
nested stage enablement without enabling the multi-CD feature (PASID),
whish is not supported by the QEMU vSMMUv3. Afterwards I realized that
basically we are pointing to a CD or PASID table and that's about the
same. I don't have a strong opinion on the name, iommu_bind_guest_table
or iommu_bind_pasid_table would be fine with me. Indeed "stage" is ARM
vocable (level for Intel?)
> 
>>> +/**
>>> + * PASID table data used to bind guest PASID table to the host IOMMU. This will
>>> + * enable guest managed first level page tables.
>>> + * @version: for future extensions and identification of the data format
>>> + * @bytes: size of this structure
>>> + * @base_ptr:	PASID table pointer
>>> + * @pasid_bits:	number of bits supported in the guest PASID table, must be less
>>> + *		or equal than the host supported PASID size.
>>> + */
>>> +struct iommu_pasid_table_config {
>>> +	__u32 version;
>>> +#define PASID_TABLE_CFG_VERSION_1 1
>>> +	__u32 bytes;
>>> +	__u64 base_ptr;
>>> +	__u8 pasid_bits;
>>> +};
>>> +
>>> +/**
>>> + * Stream Table Entry S1 info
>>> + * @disabled: the smmu is disabled
>>> + * @bypassed: stage 1 is bypassed
>>> + * @aborted: aborted
>>> + * @cdptr_dma: GPA of the Context Descriptor
>>> + * @asid: address space identified associated to the CD
>>> + */
>>> +struct iommu_smmu_s1_config {
>>> +	__u8 disabled;
>>> +	__u8 bypassed;
>>> +	__u8 aborted;
>>> +	__u64 cdptr_dma;
>>> +	__u16 asid;
>> This asid field is a leftover. asid is part of the CD (owned by the
>> guest) and cannot be conveyed through this API. What is relevant is to
>> pass is the guest asid_bits (vSMMU IDR1 info), to be compared with the
>> host one. So we end up having something similar to the base_ptr and
>> pasid_bits of iommu_pasid_table_config.
> 
> That part seems strange. Userspace wouldn't try arbitrary ASID sizes
> until one fits, especially since ASID size isn't the only parameter:
> there will be SSID, IOVA, IPA sizes, HTTU features and I guess any other
> SMMU_IDRx bit that corresponds to a field in the CD or STE. Doesn't
> vSMMU need to tailor its IDR registers to whatever is supported by the
> host SMMU, in order to use nested translation?
Yes I agree this is needed anyway.
> 
> Before creating the virtual ID registers, userspace will likely want to
> know more about the physical IOMMU, by querying the kernel. I wrote
> something about that interface recently:
> https://www.spinics.net/lists/iommu/msg28039.html

Ah OK I missed that part of the discussion. About the sysfs API, we
devised one in the past for reserved_regions. I thought it would be
useful for QEMU to identify them but eventually Alex pushed to create a
VFIO API instead to make things more self-contained. We would need to
double check with him.
> 
> And if you provide this interface, checking the parameters again in
> BIND_GUEST_STAGE isn't very useful, it only tells you that userspace
> read your values. Once the guest writes the CD, it could still use the
> wrong ASID size or some other invalid config. That would be caught by
> the SMMU walker and cause a C_BAD_CD error report.

Yes actually if there is some mismatch we might get BAD_STE/BAD_CD
events. This might be another way to handle things. I did not integrate
the fault API yet. This exercise is need to understand how we can catch
things at QEMU level.
> 
>> Otherwise, the other fields (disable, bypassed, aborted) can be packed
>> as masks in a _u8 flag.
> 
> What's the difference between aborted and disabled? I'm also not sure we
> should give such fine tweaks to userspace, since the STE code is already
> pretty complicated and has to deal with several state transitions.
> Existing behavior (1) (2) (5) probably needs to be preserved:
> 
> (1) Initially no container is set, s1-translate s2-bypass with the
> default domain (non-VFIO)
> (2) A VFIO_TYPE1_NESTING_IOMMU container is set, s1-bypass s2-translate
> (3) BIND_GUEST_STAGE, s1-translate s2-translate
> (4) UNBIND_GUEST_STAGE, s1-bypass s2-translate
> (5) Remove container, s1-translate s2-bypass with the default domain
> 
> That said, when instantiating a vSMMU, QEMU may want to switch from (2)
> to an intermediate "s1-abort s2-translate" state. At the moment with
> virtio-iommu I only create the stage-2 mappings at (3). This ensures
> that transactions abort until the guest configures the vIOMMU and it
> keeps the host driver simple, but it has the downside of pinning guest
> memory lazily (necessary with virtio-iommu since the guest falls back to
> the map/unmap interface, which doesn't pin all memory upfront, if it
> can't support nested).

For now, I have not made any assumptions here and just made sure I was
passing the S1 Config part. I would be tempted to think that only bypass
is requested and abort/disabled could be implemented by the user by
tearing the binding down, as suggested by Jacob.
> 
>> Anyway this API still is at the stage of proof of concept. At least it
>> shows the similarities between that use case and the PASID one and
>> should encourage to discuss about the relevance to have a unified API to
>> pass the guest stage info.
> Other required fields in the BIND_GUEST_STAGE ioctl are at least s1dss,
> s1cdmax and s1fmt. It's not for sanity-check, they describe the guest
> configuration. The guest selects a PASID table format (1-level, 2-level
> 4k/64k) which is written into STE.s1fmt. It also selects the behavior of
> requests-without-pasid, which is written into STE.s1dss. s1cdmax
> corresponds to pasid_bits.
Agreed. in vSMMU I only support S1CDMax =0 so I did not get into those
troubles.

Do we agree here we can get rid of the struct device * parameter?

Thanks

Eric

> 
> Thanks,
> Jean
> 
