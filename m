From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v3 06/12] KVM: arm/arm64: Helper to register a new
 redistributor region
Date: Thu, 26 Apr 2018 09:32:49 +0200
Message-ID: <8ad17ccb-9880-ca67-8ed8-25fb9557942c@redhat.com>
References: <1523607658-9166-1-git-send-email-eric.auger@redhat.com>
 <1523607658-9166-7-git-send-email-eric.auger@redhat.com>
 <20180424164712.GB4533@C02W217FHV2R.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180424164712.GB4533@C02W217FHV2R.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org, andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 04/24/2018 06:47 PM, Christoffer Dall wrote:
> On Fri, Apr 13, 2018 at 10:20:52AM +0200, Eric Auger wrote:
>> We introduce a new helper that creates and inserts a new redistributor
>> region into the rdist region list. This helper both handles the case
>> where the redistributor region size is known at registration time
>> and the legacy case where it is not (eventually depending on the number
>> of online vcpus). Depending on pfns, we perform all the possible checks
>> that we can do:
>>
>> - end of memory crossing
>> - incorrect alignment of the base address
>> - collision with distributor region if already defined
>> - collision with already registered rdist regions
>> - check of the new index
>>
>> Rdist regions must be inserted by increasing order of indices. Indices
>> must be contiguous.
>>
>> We also introduce vgic_v3_rdist_region_from_index() which will be used
>> from the vgic kvm-device, later on.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  | 95 +++++++++++++++++++++++++++++++++-------
>>  virt/kvm/arm/vgic/vgic-v3.c      | 29 ++++++++++++
>>  virt/kvm/arm/vgic/vgic.h         | 14 ++++++
>>  3 files changed, 122 insertions(+), 16 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> index ce5c927..5273fb8 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> @@ -680,14 +680,66 @@ static int vgic_register_all_redist_iodevs(struct kvm *kvm)
>>  	return ret;
>>  }
>>  
>> -int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr)
>> +/**
>> + * vgic_v3_insert_redist_region - Insert a new redistributor region
>> + *
>> + * Performs various checks before inserting the rdist region in the list.
>> + * Those tests depend on whether the size of the rdist region is known
>> + * (ie. count != 0). The list is sorted by rdist region index.
>> + *
>> + * @kvm: kvm handle
>> + * @index: redist region index
>> + * @base: base of the new rdist region
>> + * @count: number of redistributors the region is made of (of 0 in the old style
>> + * single region, whose size is induced from the number of vcpus)
>> + *
>> + * Return 0 on success, < 0 otherwise
>> + */
>> +static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
>> +					gpa_t base, uint32_t count)
>>  {
>> -	struct vgic_dist *vgic = &kvm->arch.vgic;
>> +	struct vgic_dist *d = &kvm->arch.vgic;
>>  	struct vgic_redist_region *rdreg;
>> +	struct list_head *rd_regions = &d->rd_regions;
>> +	struct list_head *last = rd_regions->prev;
>> +
> 
> nit: extra blank line?
> 
>> +	gpa_t new_start, new_end;
>> +	size_t size = count * KVM_VGIC_V3_REDIST_SIZE;
>>  	int ret;
>>  
>> -	/* vgic_check_ioaddr makes sure we don't do this twice */
>> -	if (!list_empty(&vgic->rd_regions))
>> +	/* single rdist region already set ?*/
>> +	if (!count && !list_empty(rd_regions))
>> +		return -EINVAL;
>> +
>> +	/* cross the end of memory ? */
>> +	if (base + size < base)
>> +		return -EINVAL;
> 
> what is the size of memory?  This seems to check for a gpa_t overflow,
> but not againt the IPA space of the VM...
Yes it checks for a gpa_t overflow. This check is currently done in
vgic_v3_check_base() for dist and redist region and I replicated it.
> 
>> +
>> +	if (list_empty(rd_regions)) {
>> +		if (index != 0)
>> +			return -EINVAL;
> 
> note, I think this can be simplified if we can rid of the index.
So I eventually keep the index.
> 
>> +	} else {
>> +		rdreg = list_entry(last, struct vgic_redist_region, list);
> 
> you can use list_last_entry here and get rid of the 'last' temporary
> variable above.
definitively, thank you for the nit.
> 
>> +		if (index != rdreg->index + 1)
>> +			return -EINVAL;
>> +
>> +		/* Cannot add an explicitly sized regions after legacy region */
>> +		if (!rdreg->count)
>> +			return -EINVAL;
>> +	}
>> +
>> +	/*
>> +	 * collision with already set dist region ?
>> +	 * this assumes we know the size of the new rdist region (pfns != 0)
>> +	 * otherwise we can only test this when all vcpus are registered
>> +	 */
> 
> I don't really understand this commentary... :(
I meant we cannot perform the check below if we are inserting a unique
legacy rdist region (old API), whose size is not explicitly set but
induced from the number of online vcpus.

> 
>> +	if (!count && !IS_VGIC_ADDR_UNDEF(d->vgic_dist_base) &&
>> +		(!(d->vgic_dist_base + KVM_VGIC_V3_DIST_SIZE <= base)) &&
>> +		(!(base + size <= d->vgic_dist_base)))
>> +		return -EINVAL;
> 
> Can't you call vgic_v3_check_base() here instead?
no I can't because vgic_v3_check_base() currently only works with the
unique legacy rdist region. There, redist_size  is
atomic_read(&kvm->online_vcpus) * KVM_VGIC_V3_REDIST_SIZE.
> 
>> +
>> +	/* collision with any other rdist region? */
>> +	if (vgic_v3_rdist_overlap(kvm, base, size))
>>  		return -EINVAL;
>>  
>>  	rdreg = kzalloc(sizeof(*rdreg), GFP_KERNEL);
>> @@ -696,17 +748,32 @@ int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr)
>>  
>>  	rdreg->base = VGIC_ADDR_UNDEF;
>>  
>> -	ret = vgic_check_ioaddr(kvm, &rdreg->base, addr, SZ_64K);
>> +	ret = vgic_check_ioaddr(kvm, &rdreg->base, base, SZ_64K);
>>  	if (ret)
>> -		goto out;
>> +		goto free;
>>  
>> -	rdreg->base = addr;
>> -	if (!vgic_v3_check_base(kvm)) {
>> -		ret = -EINVAL;
>> -		goto out;
>> -	}
>> +	rdreg->base = base;
>> +	rdreg->count = count;
>> +	rdreg->free_index = 0;
>> +	rdreg->index = index;
>>  
>> -	list_add(&rdreg->list, &vgic->rd_regions);
>> +	new_start = base;
>> +	new_end = base + size - 1;
> 
> What are these variables used for?
Hum reminder from an old version :-(
> 
>> +
>> +	list_add_tail(&rdreg->list, rd_regions);
>> +	return 0;
>> +free:
>> +	kfree(rdreg);
>> +	return ret;
>> +}
>> +
>> +int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr)
>> +{
>> +	int ret;
>> +
>> +	ret = vgic_v3_insert_redist_region(kvm, 0, addr, 0);
>> +	if (ret)
>> +		return ret;
>>  
>>  	/*
>>  	 * Register iodevs for each existing VCPU.  Adding more VCPUs
>> @@ -717,10 +784,6 @@ int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr)
>>  		return ret;
>>  
>>  	return 0;
>> -
>> -out:
>> -	kfree(rdreg);
>> -	return ret;
>>  }
>>  
>>  int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
>> index 820012a..dbcba5f 100644
>> --- a/virt/kvm/arm/vgic/vgic-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
>> @@ -410,6 +410,21 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
>>  	return 0;
>>  }
>>  
>> +/* return true if there is an overlap between any rdist */
> 
> Checks if base+size overlaps with any existing redistributor.
> 
>> +bool vgic_v3_rdist_overlap(struct kvm *kvm, gpa_t base, size_t size)
>> +{
>> +	struct vgic_dist *d = &kvm->arch.vgic;
>> +	struct vgic_redist_region *rdreg;
>> +
>> +	list_for_each_entry(rdreg, &d->rd_regions, list) {
>> +		if ((base + size <= rdreg->base) ||
>> +			(rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <= base))
>> +			continue;
>> +		return true;
> 
> can you invert the check above and return false instead of the continue?
> 
> (DeMorgan's law should be handy here.)
sure
> 
>> +	}
>> +	return false;
>> +}
>> +
>>  /*
>>   * Check for overlapping regions and for regions crossing the end of memory
>>   * for base addresses which have already been set.
>> @@ -461,6 +476,20 @@ struct vgic_redist_region *vgic_v3_rdist_free_slot(struct list_head *rd_regions)
>>  	return NULL;
>>  }
>>  
>> +struct vgic_redist_region *vgic_v3_rdist_region_from_index(struct kvm *kvm,
>> +							   uint32_t index)
>> +{
>> +	struct list_head *rd_regions = &kvm->arch.vgic.rd_regions;
>> +	struct vgic_redist_region *rdreg;
>> +
>> +	list_for_each_entry(rdreg, rd_regions, list) {
>> +		if (rdreg->index == index)
>> +			return rdreg;
>> +	}
> 
> if this ends up being a common operation, we could allocate an array of
> pointers for constant-time lookup instead.  Let's hope it's not too
> common.
This is only used when reading the characteristics of a redist region
from userspace so I don't think we care.

Thanks

Eric
> 
>> +	return NULL;
>> +}
>> +
>> +
>>  int vgic_v3_map_resources(struct kvm *kvm)
>>  {
>>  	int ret = 0;
>> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
>> index fea32cb..95b8345 100644
>> --- a/virt/kvm/arm/vgic/vgic.h
>> +++ b/virt/kvm/arm/vgic/vgic.h
>> @@ -262,6 +262,20 @@ vgic_v3_redist_region_full(struct vgic_redist_region *region)
>>  
>>  struct vgic_redist_region *vgic_v3_rdist_free_slot(struct list_head *rdregs);
>>  
>> +static inline size_t
>> +vgic_v3_rd_region_size(struct kvm *kvm, struct vgic_redist_region *rdreg)
>> +{
>> +	if (!rdreg->count)
>> +		return atomic_read(&kvm->online_vcpus) * KVM_VGIC_V3_REDIST_SIZE;
>> +	else
>> +		return rdreg->count * KVM_VGIC_V3_REDIST_SIZE;
>> +}
>> +
>> +struct vgic_redist_region *vgic_v3_rdist_region_from_index(struct kvm *kvm,
>> +							   uint32_t index);
>> +
>> +bool vgic_v3_rdist_overlap(struct kvm *kvm, gpa_t base, size_t size);
>> +
>>  int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
>>  			 u32 devid, u32 eventid, struct vgic_irq **irq);
>>  struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
>> -- 
>> 2.5.5
>>
> 
> Thanks,
> -Christoffer
> 
