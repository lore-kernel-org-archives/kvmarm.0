From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v6 14/24] KVM: arm64: vgic-v3:
 vgic_v3_lpi_sync_pending_status
Date: Fri, 5 May 2017 11:45:49 +0200
Message-ID: <2a1f0e35-5a2a-bb60-1e8f-5b7a13bae58c@redhat.com>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
 <1493898284-29504-15-git-send-email-eric.auger@redhat.com>
 <20170505081113.GA1419@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170505081113.GA1419@lvm>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com, bjsprakash.linux@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 05/05/2017 10:11, Christoffer Dall wrote:
> On Thu, May 04, 2017 at 01:44:34PM +0200, Eric Auger wrote:
>> this new helper synchronizes the irq pending_latch
>> with the LPI pending bit status found in rdist pending table.
>> As the status is consumed, we reset the bit in pending table.
>>
>> As we need the PENDBASER_ADDRESS() in vgic-v3, let's move its
>> definition in the irqchip header. We restore the full length
>> of the field, ie [51:16]. Same for PROPBASER_ADDRESS with full
>> field length of [51:12].
> 
> why into irqchip and not just the vgic header file?
Well most register field shift/masks are located there. This may be
useful as well for the ITS driver if power management gets implemented
> 
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v6: new
>> ---
>>  include/linux/irqchip/arm-gic-v3.h |  2 ++
>>  virt/kvm/arm/vgic/vgic-its.c       |  6 ++----
>>  virt/kvm/arm/vgic/vgic-v3.c        | 44 ++++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic.h           |  1 +
>>  4 files changed, 49 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
>> index 9519c7b..e09e5d7 100644
>> --- a/include/linux/irqchip/arm-gic-v3.h
>> +++ b/include/linux/irqchip/arm-gic-v3.h
>> @@ -159,6 +159,8 @@
>>  #define GICR_PROPBASER_RaWaWb	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, RaWaWb)
>>  
>>  #define GICR_PROPBASER_IDBITS_MASK			(0x1f)
>> +#define GICR_PROPBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 12))
>> +#define GICR_PENDBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 16))
>>  
>>  #define GICR_PENDBASER_SHAREABILITY_SHIFT		(10)
>>  #define GICR_PENDBASER_INNER_CACHEABILITY_SHIFT		(7)
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index e7bb86a..f43ea30c 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -198,8 +198,6 @@ static struct its_ite *find_ite(struct vgic_its *its, u32 device_id,
>>   */
>>  #define BASER_ADDRESS(x)	((x) & GENMASK_ULL(47, 16))
>>  #define CBASER_ADDRESS(x)	((x) & GENMASK_ULL(47, 12))
>> -#define PENDBASER_ADDRESS(x)	((x) & GENMASK_ULL(47, 16))
>> -#define PROPBASER_ADDRESS(x)	((x) & GENMASK_ULL(47, 12))
>>  
>>  #define GIC_LPI_OFFSET 8192
>>  
>> @@ -234,7 +232,7 @@ static struct its_collection *find_collection(struct vgic_its *its, int coll_id)
>>  static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
>>  			     struct kvm_vcpu *filter_vcpu)
>>  {
>> -	u64 propbase = PROPBASER_ADDRESS(kvm->arch.vgic.propbaser);
>> +	u64 propbase = GICR_PROPBASER_ADDRESS(kvm->arch.vgic.propbaser);
>>  	u8 prop;
>>  	int ret;
>>  
>> @@ -346,7 +344,7 @@ static u32 max_lpis_propbaser(u64 propbaser)
>>   */
>>  static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
>>  {
>> -	gpa_t pendbase = PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
>> +	gpa_t pendbase = GICR_PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
>>  	struct vgic_irq *irq;
>>  	int last_byte_offset = -1;
>>  	int ret = 0;
>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
>> index be0f4c3..0d753ae 100644
>> --- a/virt/kvm/arm/vgic/vgic-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
>> @@ -252,6 +252,50 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
>>  	vgic_v3->vgic_hcr = ICH_HCR_EN;
>>  }
>>  
>> +int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
>> +{
>> +	struct kvm_vcpu *vcpu;
>> +	int byte_offset, bit_nr;
>> +	gpa_t pendbase, ptr;
>> +	bool status;
>> +	u8 val;
>> +	int ret;
>> +
>> +retry:
>> +	vcpu = irq->target_vcpu;
>> +	if (!vcpu)
>> +		return 0;
>> +
>> +	pendbase = GICR_PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
>> +
>> +	byte_offset = irq->intid / BITS_PER_BYTE;
>> +	bit_nr = irq->intid % BITS_PER_BYTE;
>> +	ptr = pendbase + byte_offset;
>> +
>> +	ret = kvm_read_guest(kvm, ptr, &val, 1);
>> +	if (ret)
>> +		return ret;
>> +
>> +	status = val & (1 << bit_nr);
>> +
>> +	spin_lock(&irq->irq_lock);
>> +	if (irq->target_vcpu != vcpu) {
>> +		spin_unlock(&irq->irq_lock);
>> +		goto retry;
> 
> Can the guest be continuously changing the configuration of the LPI and
> cause this function to be called, which will efficiently hog this CPU
> from the system, or am I being overly cautious here?
Yes but on the other hand, there is a risk the target_vcpu has changed,
isn't it? So the alternative you be to return -EBUSY. and caller, ie.
its_add_lpi would return that error?
> 
>> +	}
>> +	irq->pending_latch = status;
>> +	vgic_queue_irq_unlock(vcpu->kvm, irq);
>> +
>> +	if (status) {
>> +		/* clear consumed data */
>> +		val &= ~(1 << bit_nr);
>> +		ret = kvm_write_guest(kvm, ptr, &val, 1);
>> +		if (ret)
>> +			return ret;
> 
> Do we have a problem that if this is done twice within the same byte (on
> different LPIs) then the data could be strangely out of sync?
Not sure I get what you mean here? I reset a single bit within the byte.
Do you mean there could be a concurrency issue?

In principle we are not obliged to reset the bit, right? Why do we care?
The table will be updated on next pending table save.

Thanks

Eric

> 
> Do we care?
> 
> 
> Thanks,
> -Christoffer
> 
>> +	}
>> +	return 0;
>> +}
>> +
>>  /* check for overlapping regions and for regions crossing the end of memory */
>>  static bool vgic_v3_check_base(struct kvm *kvm)
>>  {
>> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
>> index b87f1c6..309ab64 100644
>> --- a/virt/kvm/arm/vgic/vgic.h
>> +++ b/virt/kvm/arm/vgic/vgic.h
>> @@ -157,6 +157,7 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>>  void vgic_v3_enable(struct kvm_vcpu *vcpu);
>>  int vgic_v3_probe(const struct gic_kvm_info *info);
>>  int vgic_v3_map_resources(struct kvm *kvm);
>> +int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq);
>>  int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
>>  
>>  int vgic_register_its_iodevs(struct kvm *kvm);
>> -- 
>> 2.5.5
>>
