From: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Subject: Re: [PATCH v8 08/17] KVM: arm64: handle ITS related GICv3
 redistributor registers
Date: Mon, 11 Jul 2016 08:45:27 +0100
Message-ID: <d3b2c781-a079-cde7-f833-fbdf0e0ffcb9@arm.com>
References: <20160705112309.28877-1-andre.przywara@arm.com>
 <20160705112309.28877-9-andre.przywara@arm.com> <20160708154023.GA1305@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160708154023.GA1305@lvm>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 08/07/16 16:40, Christoffer Dall wrote:

Hi Christoffer,

thanks very much for taking a look!

> On Tue, Jul 05, 2016 at 12:23:00PM +0100, Andre Przywara wrote:
>> In the GICv3 redistributor there are the PENDBASER and PROPBASER
>> registers which we did not emulate so far, as they only make sense
>> when having an ITS. In preparation for that emulate those MMIO
>> accesses by storing the 64-bit data written into it into a variable
>> which we later read in the ITS emulation.
>> We also sanitise the registers, making sure RES0 regions are respected
>> and checking for valid memory attributes.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  include/kvm/arm_vgic.h           |  13 ++++
>>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 143 ++++++++++++++++++++++++++++++++++++++-
>>  virt/kvm/arm/vgic/vgic-mmio.h    |   8 +++
>>  virt/kvm/arm/vgic/vgic-v3.c      |  11 ++-
>>  4 files changed, 171 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index 450b4da..f6f860d 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -146,6 +146,14 @@ struct vgic_dist {
>>  	struct vgic_irq		*spis;
>>  
>>  	struct vgic_io_device	dist_iodev;
>> +
>> +	/*
>> +	 * Contains the address of the LPI configuration table.
> 
> Is this field the address or the actual format of the GICR_PROPBASER ?
> 
> If the former, the type should potentially be gpa_t, if the latter, you
> shouldn't say that this is just the address :)

I think we had this discussion before, I am happy to use a wording that
makes everyone happy ;-)
I already changed it to "_Contains_ the address" to note that it's the
whole register, but that holding the _address_ is the actual purpose of
PROPBASER. A less unambiguous comment is warmly welcomed ...

>> +	 * Since we report GICR_TYPER.CommonLPIAff as 0b00, we can share
>> +	 * one address across all redistributors.
>> +	 * GICv3 spec: 6.1.2 "LPI Configuration tables"
>> +	 */
>> +	u64			propbaser;
>>  };
>>  
>>  struct vgic_v2_cpu_if {
>> @@ -200,6 +208,11 @@ struct vgic_cpu {
>>  	 */
>>  	struct vgic_io_device	rd_iodev;
>>  	struct vgic_io_device	sgi_iodev;
>> +
>> +	/* Points to the LPI pending tables for the redistributor */
>> +	u64 pendbaser;
> 
> ditto
> 
>> +
>> +	bool lpis_enabled;
>>  };
>>  
>>  int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> index bfcafbd..9dd8632 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> @@ -29,6 +29,19 @@ static unsigned long extract_bytes(unsigned long data, unsigned int offset,
>>  	return (data >> (offset * 8)) & GENMASK_ULL(num * 8 - 1, 0);
>>  }
>>  
>> +/* allows updates of any half of a 64-bit register (or the whole thing) */
> 
> when I see this function I have to read the bit fiddling to understand
> the parameters and semantics.
> 
> actually, I'm not sure I read this correctly, but could you mean:
> 
>   /*
>    * Update @len bytes at @offset bytes offset in @reg from the least
>    * significant bytes in @val?
>    */

Yes, that's what it does, though I am not sure that explanation is more
meaningful, as it describes the code, but not the intention of it.
The main purpose of that function is to allow updates of one half of a
register while keeping the other half intact.

> Also, I don't get why this would be limited to either halfs or the whole
> of a 64-bit register, but maybe I'm reading the code wrong.

Every GIC register that can be accessed as 64-bit can only be 32-bit as
well, so we don't need any byte or halfword handling.
Containing this function to these two cases made it simpler (though this
is admittedly not obvious ;-)

> Didn't we have a reviewed function for the vgic that was called
> update_bytes or inser_bytes before, that we could use or did we never
> actually review that?

I forgot, I think there was a function, but that had issues as well, IIRC.

> 
>> +static u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
>> +			    unsigned long val)
>> +{
>> +	int lower = (offset & 4) * 8;
>> +	int upper = lower + 8 * len - 1;
>> +
>> +	reg &= ~GENMASK_ULL(upper, lower);
>> +	val &= GENMASK_ULL(len * 8 - 1, 0);
>> +
>> +	return reg | ((u64)val << lower);
> 
> this casting is weird.  Why is val not either a u64 or a u32?  Or the
> whole lot could be unsigned long/unsigned int like extract_bytes.

The idea is to make val naturally the largest possible type that could
be subject to MMIO operations and also to let it match the type used in
the MMIO handlers.
This was with 32-bit support already in mind.

> 
>> +}
>> +
>>  static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
>>  					    gpa_t addr, unsigned int len)
>>  {
>> @@ -152,6 +165,132 @@ static unsigned long vgic_mmio_read_v3_idregs(struct kvm_vcpu *vcpu,
>>  	return 0;
>>  }
>>  
>> +/* We want to avoid outer shareable. */
>> +u64 vgic_sanitise_shareability(u64 reg)
>> +{
>> +	switch (reg & GIC_BASER_SHAREABILITY_MASK) {
>> +	case GIC_BASER_OuterShareable:
>> +		return GIC_BASER_InnerShareable;
>> +	default:
>> +		return reg;
>> +	}
>> +}
>> +
>> +/* Non-cacheable or same-as-inner are OK. */
>> +u64 vgic_sanitise_outer_cacheability(u64 reg)
>> +{
>> +	switch (reg & GIC_BASER_CACHE_MASK) {
>> +	case GIC_BASER_CACHE_SameAsInner:
>> +	case GIC_BASER_CACHE_nC:
>> +		return reg;
>> +	default:
>> +		return GIC_BASER_CACHE_nC;
>> +	}
>> +}
>> +
>> +/* Avoid any inner non-cacheable mapping. */
>> +u64 vgic_sanitise_inner_cacheability(u64 reg)
>> +{
>> +	switch (reg & GIC_BASER_CACHE_MASK) {
>> +	case GIC_BASER_CACHE_nCnB:
>> +	case GIC_BASER_CACHE_nC:
>> +		return GIC_BASER_CACHE_RaWb;
>> +	default:
>> +		return reg;
>> +	}
>> +}
> 
> nit: My OCD sets in here because the functions above are not ordered
> similarly to the calls below :)

Then let me fix this before you get into any trouble ...

> also, why do you need to apply the mask in the sanitize functions when
> you've just applied it in the callers?  It would make more sense to me
> if you didn't and named the parameters @field instead of @reg in the
> sanitize functions.

OK, can do.

>> +
>> +u64 vgic_sanitise_field(u64 reg, int field_shift, u64 field_mask,
>> +			u64 (*sanitise_fn)(u64))
>> +{
>> +	u64 field = (reg >> field_shift) & field_mask;
>> +
>> +	field = sanitise_fn(field) << field_shift;
>> +	return (reg & ~(field_mask << field_shift)) | field;
>> +}
>> +
>> +static u64 vgic_sanitise_pendbaser(u64 reg)
>> +{
>> +	reg = vgic_sanitise_field(reg, GICR_PENDBASER_SHAREABILITY_SHIFT,
>> +				  GIC_BASER_SHAREABILITY_MASK,
>> +				  vgic_sanitise_shareability);
>> +	reg = vgic_sanitise_field(reg, GICR_PENDBASER_INNER_CACHEABILITY_SHIFT,
>> +				  GIC_BASER_CACHE_MASK,
>> +				  vgic_sanitise_inner_cacheability);
>> +	reg = vgic_sanitise_field(reg, GICR_PENDBASER_OUTER_CACHEABILITY_SHIFT,
>> +				  GIC_BASER_CACHE_MASK,
>> +				  vgic_sanitise_outer_cacheability);
>> +	return reg;
>> +}
>> +
>> +static u64 vgic_sanitise_propbaser(u64 reg)
>> +{
>> +	reg = vgic_sanitise_field(reg, GICR_PROPBASER_SHAREABILITY_SHIFT,
>> +				  GIC_BASER_SHAREABILITY_MASK,
>> +				  vgic_sanitise_shareability);
>> +	reg = vgic_sanitise_field(reg, GICR_PROPBASER_INNER_CACHEABILITY_SHIFT,
>> +				  GIC_BASER_CACHE_MASK,
>> +				  vgic_sanitise_inner_cacheability);
>> +	reg = vgic_sanitise_field(reg, GICR_PROPBASER_OUTER_CACHEABILITY_SHIFT,
>> +				  GIC_BASER_CACHE_MASK,
>> +				  vgic_sanitise_outer_cacheability);
>> +	return reg;
>> +}
> 
> assuming the defines themselves are correct (I didn't check) this looks
> good otherwise.
> 
>> +
>> +#define PROPBASER_RES0_MASK						\
>> +	(GENMASK_ULL(63, 59) | GENMASK_ULL(55, 52) | GENMASK_ULL(6, 5))
> 
> Why is the middle one for bits 55:52?  is it not 55:48?  Perhaps larger
> physical addresses compared to the revision of the GICv3 spec I have at
> hand?

Possibly. The latest public version is issue B from December 2015, and
IIRC this was one of the changes.

> 
>> +#define PENDBASER_RES0_MASK						\
>> +	(BIT_ULL(63) | GENMASK_ULL(61, 59) | GENMASK_ULL(55, 52) |	\
>> +	 GENMASK_ULL(15, 12) | GENMASK_ULL(6, 0))
>> +
>> +static unsigned long vgic_mmio_read_propbase(struct kvm_vcpu *vcpu,
>> +					     gpa_t addr, unsigned int len)
>> +{
>> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>> +
>> +	return extract_bytes(dist->propbaser, addr & 7, len);
>> +}
>> +
>> +static void vgic_mmio_write_propbase(struct kvm_vcpu *vcpu,
>> +				     gpa_t addr, unsigned int len,
>> +				     unsigned long val)
>> +{
>> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>> +
>> +	/* Storing a value with LPIs already enabled is undefined */
>> +	if (vgic_cpu->lpis_enabled)
>> +		return;
>> +
>> +	dist->propbaser = update_64bit_reg(dist->propbaser, addr & 4, len, val);
>> +	dist->propbaser &= ~PROPBASER_RES0_MASK;
>> +	dist->propbaser = vgic_sanitise_propbaser(dist->propbaser);
> 
> what prevents multiple writers messing with dist->propbaser or the

Good point! A rather easy fix would be to use a local variable here and
do just one update at the end.  A more involved one to use per-VCPU
propbaser variables. But eventually we only need _one_ value and don't
have a VCPU pointer when we need to access the value.

> lips_enabled being set in the middle of us fiddling with dist_propbaser?
  ^^^^
I am biting my lips on that matter ;-)

More seriously, I don't think this is a problem, since this is specified
as "undefined". So if I am not mistaken we can happily go on with
changing the value anyway. Any illegal value should be caught by
kvm_read_guest().

>> +}
>> +
>> +static unsigned long vgic_mmio_read_pendbase(struct kvm_vcpu *vcpu,
>> +					     gpa_t addr, unsigned int len)
>> +{
>> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>> +
>> +	return extract_bytes(vgic_cpu->pendbaser, addr & 7, len);
>> +}
>> +
>> +static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
>> +				     gpa_t addr, unsigned int len,
>> +				     unsigned long val)
>> +{
>> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>> +
>> +	/* Storing a value with LPIs already enabled is undefined */
>> +	if (vgic_cpu->lpis_enabled)
>> +		return;
>> +
>> +	vgic_cpu->pendbaser = update_64bit_reg(vgic_cpu->pendbaser,
>> +					       addr & 4, len, val);
>> +	vgic_cpu->pendbaser &= ~PENDBASER_RES0_MASK;
>> +	vgic_cpu->pendbaser = vgic_sanitise_pendbaser(vgic_cpu->pendbaser);
>> +}
>> +
>>  /*
>>   * The GICv3 per-IRQ registers are split to control PPIs and SGIs in the
>>   * redistributors, while SPIs are covered by registers in the distributor
>> @@ -232,10 +371,10 @@ static const struct vgic_register_region vgic_v3_rdbase_registers[] = {
>>  		vgic_mmio_read_v3r_typer, vgic_mmio_write_wi, 8,
>>  		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>>  	REGISTER_DESC_WITH_LENGTH(GICR_PROPBASER,
>> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
>> +		vgic_mmio_read_propbase, vgic_mmio_write_propbase, 8,
>>  		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>>  	REGISTER_DESC_WITH_LENGTH(GICR_PENDBASER,
>> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
>> +		vgic_mmio_read_pendbase, vgic_mmio_write_pendbase, 8,
>>  		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>>  	REGISTER_DESC_WITH_LENGTH(GICR_IDREGS,
>>  		vgic_mmio_read_v3_idregs, vgic_mmio_write_wi, 48,
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
>> index 8509014..e863ccc 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio.h
>> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
>> @@ -147,4 +147,12 @@ unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
>>  
>>  unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev);
>>  
>> +#ifdef CONFIG_KVM_ARM_VGIC_V3
>> +u64 vgic_sanitise_outer_cacheability(u64 reg);
>> +u64 vgic_sanitise_inner_cacheability(u64 reg);
>> +u64 vgic_sanitise_shareability(u64 reg);
>> +u64 vgic_sanitise_field(u64 reg, int field_shift, u64 field_mask,
>> +			u64 (*sanitise_fn)(u64));
>> +#endif
>> +
>>  #endif
>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
>> index f0ac064..6f8f31f 100644
>> --- a/virt/kvm/arm/vgic/vgic-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
>> @@ -191,6 +191,11 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
>>  	vmcrp->pmr  = (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
>>  }
>>  
>> +#define INITIAL_PENDBASER_VALUE						  \
>> +	(GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, RaWb)		| \
>> +	GIC_BASER_CACHEABILITY(GICR_PENDBASER, OUTER, SameAsInner)	| \
>> +	GIC_BASER_SHAREABILITY(GICR_PENDBASER, InnerShareable))
>> +
>>  void vgic_v3_enable(struct kvm_vcpu *vcpu)
>>  {
>>  	struct vgic_v3_cpu_if *vgic_v3 = &vcpu->arch.vgic_cpu.vgic_v3;
>> @@ -208,10 +213,12 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
>>  	 * way, so we force SRE to 1 to demonstrate this to the guest.
>>  	 * This goes with the spec allowing the value to be RAO/WI.
>>  	 */
>> -	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
>> +	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
>>  		vgic_v3->vgic_sre = ICC_SRE_EL1_SRE;
>> -	else
>> +		vcpu->arch.vgic_cpu.pendbaser = INITIAL_PENDBASER_VALUE;
> 
> why is pendbaser initialized, but not propbaser?  Do I have an outdated
> spec?  Both seem to not have any predefined reset value.

pendbaser is per core, propbaser is one value per ITS eventually.
So the propbaser initialisation is in vgic_its_create() in patch 11/17.

Thanks again for the comments!

Cheers,
Andre.

> 
>> +	} else {
>>  		vgic_v3->vgic_sre = 0;
>> +	}
>>  
>>  	/* Get the show on the road... */
>>  	vgic_v3->vgic_hcr = ICH_HCR_EN;
>> -- 
>> 2.9.0
>>
> 
> Thanks,
> -Christoffer
> 

