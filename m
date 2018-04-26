From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v3 04/12] KVM: arm/arm64: Helper to locate free rdist
 index
Date: Thu, 26 Apr 2018 09:47:00 +0200
Message-ID: <40978427-0cf7-3a03-f12e-bde73548180e@redhat.com>
References: <1523607658-9166-1-git-send-email-eric.auger@redhat.com>
 <1523607658-9166-5-git-send-email-eric.auger@redhat.com>
 <20180424210704.GG4533@C02W217FHV2R.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180424210704.GG4533@C02W217FHV2R.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org, andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,
On 04/24/2018 11:07 PM, Christoffer Dall wrote:
> On Fri, Apr 13, 2018 at 10:20:50AM +0200, Eric Auger wrote:
>> We introduce vgic_v3_rdist_free_slot to help identifying
>> where we can place a new 2x64KB redistributor.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-mmio-v3.c |  3 +--
>>  virt/kvm/arm/vgic/vgic-v3.c      | 17 +++++++++++++++++
>>  virt/kvm/arm/vgic/vgic.h         | 11 +++++++++++
>>  3 files changed, 29 insertions(+), 2 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> index d1aab18..49ca176 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> @@ -593,8 +593,7 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
>>  	 * function for all VCPUs when the base address is set.  Just return
>>  	 * without doing any work for now.
>>  	 */
>> -	rdreg = list_first_entry(&vgic->rd_regions,
>> -				 struct vgic_redist_region, list);
>> +	rdreg = vgic_v3_rdist_free_slot(&vgic->rd_regions);
>>  	if (!rdreg)
>>  		return 0;
>>  
>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
>> index 94de6cd..820012a 100644
>> --- a/virt/kvm/arm/vgic/vgic-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
>> @@ -444,6 +444,23 @@ bool vgic_v3_check_base(struct kvm *kvm)
>>  	return false;
>>  }
>>  
>> +/**
>> + * vgic_v3_rdist_free_slot - Look up registered rdist regions and identify one
>> + * which has free space to put a new rdist regions
> 
> Can this structure ever be sparse or do we always find the first empty
> one, as we fill them consecutively ?
We always find the first empty 2x64kB slot within the region (stride
between redistributors = 0). Regions are filled in the index order. The
only hole that can exist is at the end of the region if its size is not
multiple of 2x64kB.
> 
> I assume there is some mapping between the regions and the VCPUs'
> redistributors, so perhaps the wording in this comment can be more
> precise.
changed into:
"
A redistributor regions maps n redistributors, n = region size / (2 x 64kB).
Stride between redistributors is 0 and regions are filled in the index
order.
"

> 
>> + *
>> + * If any, return this redist region handle, otherwise returns NULL.
>> + */
>> +struct vgic_redist_region *vgic_v3_rdist_free_slot(struct list_head *rd_regions)
>> +{
>> +	struct vgic_redist_region *rdreg;
>> +
>> +	list_for_each_entry(rdreg, rd_regions, list) {
>> +		if (!vgic_v3_redist_region_full(rdreg))
>> +			return rdreg;
>> +	}
>> +	return NULL;
>> +}
>> +
>>  int vgic_v3_map_resources(struct kvm *kvm)
>>  {
>>  	int ret = 0;
>> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
>> index 830e815..fea32cb 100644
>> --- a/virt/kvm/arm/vgic/vgic.h
>> +++ b/virt/kvm/arm/vgic/vgic.h
>> @@ -251,6 +251,17 @@ static inline int vgic_v3_max_apr_idx(struct kvm_vcpu *vcpu)
>>  	}
>>  }
>>  
>> +static inline bool
>> +vgic_v3_redist_region_full(struct vgic_redist_region *region)
>> +{
>> +	if (!region->count)
>> +		return false;
>> +
>> +	return (region->free_index >= region->count);
>> +}
>> +
>> +struct vgic_redist_region *vgic_v3_rdist_free_slot(struct list_head *rdregs);
>> +
>>  int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
>>  			 u32 devid, u32 eventid, struct vgic_irq **irq);
>>  struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
>> -- 
>> 2.5.5
>>
> 
> Asides from the above:
> 
> Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Thanks

Eric
> 
