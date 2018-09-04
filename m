From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC 01/13] iommu: Introduce bind_guest_stage API
Date: Tue, 4 Sep 2018 10:10:56 +0200
Message-ID: <220e4c2a-d31c-d8fb-2d77-d902d2f13bb2@redhat.com>
References: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
 <1535026656-8450-2-git-send-email-eric.auger@redhat.com>
 <22c01a4d-c74a-7279-d4ae-39e29a3bc942@redhat.com>
 <b7909f1b-57ce-f4db-d916-140a63283232@arm.com>
 <4309832b-27ed-597a-b5a1-f439fbea9843@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D1912EFB76@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D1912EFB76@SHSMSX101.ccr.corp.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Tian, Kevin" <kevin.tian@intel.com>, Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "joro@8bytes.org" <joro@8bytes.org>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>, "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "robin.murphy@arm.com" <robin.murphy@arm.com>
Cc: "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>, "christoffer.dall@arm.com" <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Kevin,
On 09/04/2018 09:57 AM, Tian, Kevin wrote:
>> From: Auger Eric
>> Sent: Friday, August 31, 2018 9:52 PM
>>
>> Hi Jean-Philippe,
>>
>> On 08/31/2018 03:11 PM, Jean-Philippe Brucker wrote:
>>> Hi Eric,
>>>
>>> On 23/08/18 16:25, Auger Eric wrote:
>>>>> +int iommu_bind_guest_stage(struct iommu_domain *domain, struct
>> device *dev,
>>>>> +			   struct iommu_guest_stage_config *cfg)
>>>
>>> About the name change from iommu_bind_pasid_table: is the intent to
>>> reuse this API for SMMUv2, which supports nested but not PASID? Seems
>>> like a good idea but "iommu_bind_table" may be better since "stage" is
>>> only used by Arm.
>>
>> At the moment I don't target SMUv2 but just SMMUv3. My focus was on
>> nested stage enablement without enabling the multi-CD feature (PASID),
>> whish is not supported by the QEMU vSMMUv3. Afterwards I realized that
>> basically we are pointing to a CD or PASID table and that's about the
>> same. I don't have a strong opinion on the name, iommu_bind_guest_table
>> or iommu_bind_pasid_table would be fine with me. Indeed "stage" is ARM
>> vocable (level for Intel?)
> 
> Intel uses first level/second level. 
> 
> iommu_bind_table is a bit confusing. what should people take table as?
> there is PASID table. there is also page table linked in each stage/level. and
> maybe other tables in vendor-specific definition.
> 
> to me iommu_bind_pasid_table is still clearer. anyway in other places
> we've used pasid explicitly in vfio/iommu APIs, then it should be general
> enough to represent various implementations.

Fine for me.

However I I would suggest to rename the original iommu_sva_invalidate
into something that is SVA unrelated. iommu_tlb_invalidate is not OK as
this API also is used to invalidate context caches - which are not
iotlbs -. What about iommu_cache_invalidate?

At least we must clarify that this API can be used for something else
than SVA enablement.

Thanks

Eric
> 
> Thanks
> Kevin
> 
> 
> 
