From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 33/55] KVM: arm64: vgic: Handle ITS related GICv3
 redistributor registers
Date: Tue, 2 Aug 2016 16:01:30 +0100
Message-ID: <57A0B5CA.8000101@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
 <1469208552-4155-34-git-send-email-marc.zyngier@arm.com>
 <20160801182052.GC32244@cbox> <a4caed21-f9fc-9851-3cb6-75ed1088bc28@arm.com>
 <57A0721E.7010905@arm.com> <20160802143345.GN32244@cbox>
 <57A0B259.60408@arm.com> <20160802145510.GR32244@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C94C411E3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Aug 2016 10:54:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zuFfHQbdx5xw for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Aug 2016 10:54:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 615084113E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Aug 2016 10:54:47 -0400 (EDT)
In-Reply-To: <20160802145510.GR32244@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 02/08/16 15:55, Christoffer Dall wrote:
> On Tue, Aug 02, 2016 at 03:46:49PM +0100, Marc Zyngier wrote:
>> On 02/08/16 15:33, Christoffer Dall wrote:
>>> On Tue, Aug 02, 2016 at 11:12:46AM +0100, Marc Zyngier wrote:
>>>> On 02/08/16 10:40, Andre Przywara wrote:
>>>>> Hi,
>>>>>
>>>>> On 01/08/16 19:20, Christoffer Dall wrote:
>>>>>> On Fri, Jul 22, 2016 at 06:28:50PM +0100, Marc Zyngier wrote:
>>>>>>> From: Andre Przywara <andre.przywara@arm.com>
>>>>>>>
>>>>>>> In the GICv3 redistributor there are the PENDBASER and PROPBASER
>>>>>>> registers which we did not emulate so far, as they only make sense
>>>>>>> when having an ITS. In preparation for that emulate those MMIO
>>>>>>> accesses by storing the 64-bit data written into it into a variable
>>>>>>> which we later read in the ITS emulation.
>>>>>>> We also sanitise the registers, making sure RES0 regions are respected
>>>>>>> and checking for valid memory attributes.
>>>>>>>
>>>>>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>>>>>> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
>>>>>>> Tested-by: Eric Auger <eric.auger@redhat.com>
>>>>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>>>>> ---
>>>>>>>  include/kvm/arm_vgic.h           |  13 ++++
>>>>>>>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 153 ++++++++++++++++++++++++++++++++++++++-
>>>>>>>  virt/kvm/arm/vgic/vgic-mmio.h    |   8 ++
>>>>>>>  virt/kvm/arm/vgic/vgic-v3.c      |  11 ++-
>>>>>>>  4 files changed, 181 insertions(+), 4 deletions(-)
>>>>>>>
>>>>>>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>>>>>>> index 450b4da..df2dec5 100644
>>>>>>> --- a/include/kvm/arm_vgic.h
>>>>>>> +++ b/include/kvm/arm_vgic.h
>>>>>>> @@ -146,6 +146,14 @@ struct vgic_dist {
>>>>>>>  	struct vgic_irq		*spis;
>>>>>>>  
>>>>>>>  	struct vgic_io_device	dist_iodev;
>>>>>>> +
>>>>>>> +	/*
>>>>>>> +	 * Contains the attributes and gpa of the LPI configuration table.
>>>>>>> +	 * Since we report GICR_TYPER.CommonLPIAff as 0b00, we can share
>>>>>>> +	 * one address across all redistributors.
>>>>>>> +	 * GICv3 spec: 6.1.2 "LPI Configuration tables"
>>>>>>> +	 */
>>>>>>> +	u64			propbaser;
>>>>>>>  };
>>>>>>>  
>>>>>>>  struct vgic_v2_cpu_if {
>>>>>>> @@ -200,6 +208,11 @@ struct vgic_cpu {
>>>>>>>  	 */
>>>>>>>  	struct vgic_io_device	rd_iodev;
>>>>>>>  	struct vgic_io_device	sgi_iodev;
>>>>>>> +
>>>>>>> +	/* Contains the attributes and gpa of the LPI pending tables. */
>>>>>>> +	u64 pendbaser;
>>>>>>> +
>>>>>>> +	bool lpis_enabled;
>>>>>>>  };
>>>>>>>  
>>>>>>>  int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
>>>>>>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>>>>>> index bfcafbd..278bfbb 100644
>>>>>>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>>>>>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>>>>>> @@ -29,6 +29,19 @@ static unsigned long extract_bytes(unsigned long data, unsigned int offset,
>>>>>>>  	return (data >> (offset * 8)) & GENMASK_ULL(num * 8 - 1, 0);
>>>>>>>  }
>>>>>>>  
>>>>>>> +/* allows updates of any half of a 64-bit register (or the whole thing) */
>>>>>>> +static u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
>>>>>>> +			    unsigned long val)
>>>>>>> +{
>>>>>>> +	int lower = (offset & 4) * 8;
>>>>>>> +	int upper = lower + 8 * len - 1;
>>>>>>> +
>>>>>>> +	reg &= ~GENMASK_ULL(upper, lower);
>>>>>>> +	val &= GENMASK_ULL(len * 8 - 1, 0);
>>>>>>> +
>>>>>>> +	return reg | ((u64)val << lower);
>>>>>>> +}
>>>>>>> +
>>>>>>>  static unsined long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
>>>>>>>  					    gpa_t addr, unsigned int len)
>>>>>>>  {
>>>>>>> @@ -152,6 +165,142 @@ static unsigned long vgic_mmio_read_v3_idregs(struct kvm_vcpu *vcpu,
>>>>>>>  	return 0;
>>>>>>>  }
>>>>>>>  
>>>>>>> +/* We want to avoid outer shareable. */
>>>>>>> +u64 vgic_sanitise_shareability(u64 field)
>>>>>>> +{
>>>>>>> +	switch (field) {
>>>>>>> +	case GIC_BASER_OuterShareable:
>>>>>>> +		return GIC_BASER_InnerShareable;
>>>>>>> +	default:
>>>>>>> +		return field;
>>>>>>> +	}
>>>>>>> +}
>>>>>>> +
>>>>>>> +/* Avoid any inner non-cacheable mapping. */
>>>>>>> +u64 vgic_sanitise_inner_cacheability(u64 field)
>>>>>>> +{
>>>>>>> +	switch (field) {
>>>>>>> +	case GIC_BASER_CACHE_nCnB:
>>>>>>> +	case GIC_BASER_CACHE_nC:
>>>>>>> +		return GIC_BASER_CACHE_RaWb;
>>>>>>> +	default:
>>>>>>> +		return field;
>>>>>>> +	}
>>>>>>> +}
>>>>>>> +
>>>>>>> +/* Non-cacheable or same-as-inner are OK. */
>>>>>>> +u64 vgic_sanitise_outer_cacheability(u64 field)
>>>>>>> +{
>>>>>>> +	switch (field) {
>>>>>>> +	case GIC_BASER_CACHE_SameAsInner:
>>>>>>> +	case GIC_BASER_CACHE_nC:
>>>>>>> +		return field;
>>>>>>> +	default:
>>>>>>> +		return GIC_BASER_CACHE_nC;
>>>>>>> +	}
>>>>>>> +}
>>>>>>> +
>>>>>>> +u64 vgic_sanitise_field(u64 reg, u64 field_mask, int field_shift,
>>>>>>> +			u64 (*sanitise_fn)(u64))
>>>>>>> +{
>>>>>>> +	u64 field = (reg & field_mask) >> field_shift;
>>>>>>> +
>>>>>>> +	field = sanitise_fn(field) << field_shift;
>>>>>>> +	return (reg & ~field_mask) | field;
>>>>>>> +}
>>>>>>> +
>>>>>>> +#define PROPBASER_RES0_MASK						\
>>>>>>> +	(GENMASK_ULL(63, 59) | GENMASK_ULL(55, 52) | GENMASK_ULL(6, 5))
>>>>>>> +#define PENDBASER_RES0_MASK						\
>>>>>>> +	(BIT_ULL(63) | GENMASK_ULL(61, 59) | GENMASK_ULL(55, 52) |	\
>>>>>>> +	 GENMASK_ULL(15, 12) | GENMASK_ULL(6, 0))
>>>>>>> +
>>>>>>> +static u64 vgic_sanitise_pendbaser(u64 reg)
>>>>>>> +{
>>>>>>> +	reg = vgic_sanitise_field(reg, GICR_PENDBASER_SHAREABILITY_MASK,
>>>>>>> +				  GICR_PENDBASER_SHAREABILITY_SHIFT,
>>>>>>> +				  vgic_sanitise_shareability);
>>>>>>> +	reg = vgic_sanitise_field(reg, GICR_PENDBASER_INNER_CACHEABILITY_MASK,
>>>>>>> +				  GICR_PENDBASER_INNER_CACHEABILITY_SHIFT,
>>>>>>> +				  vgic_sanitise_inner_cacheability);
>>>>>>> +	reg = vgic_sanitise_field(reg, GICR_PENDBASER_OUTER_CACHEABILITY_MASK,
>>>>>>> +				  GICR_PENDBASER_OUTER_CACHEABILITY_SHIFT,
>>>>>>> +				  vgic_sanitise_outer_cacheability);
>>>>>>> +
>>>>>>> +	reg &= ~PENDBASER_RES0_MASK;
>>>>>>> +	reg &= ~GENMASK_ULL(51, 48);
>>>>>>> +
>>>>>>> +	return reg;
>>>>>>> +}
>>>>>>> +
>>>>>>> +static u64 vgic_sanitise_propbaser(u64 reg)
>>>>>>> +{
>>>>>>> +	reg = vgic_sanitise_field(reg, GICR_PROPBASER_SHAREABILITY_MASK,
>>>>>>> +				  GICR_PROPBASER_SHAREABILITY_SHIFT,
>>>>>>> +				  vgic_sanitise_shareability);
>>>>>>> +	reg = vgic_sanitise_field(reg, GICR_PROPBASER_INNER_CACHEABILITY_MASK,
>>>>>>> +				  GICR_PROPBASER_INNER_CACHEABILITY_SHIFT,
>>>>>>> +				  vgic_sanitise_inner_cacheability);
>>>>>>> +	reg = vgic_sanitise_field(reg, GICR_PROPBASER_OUTER_CACHEABILITY_MASK,
>>>>>>> +				  GICR_PROPBASER_OUTER_CACHEABILITY_SHIFT,
>>>>>>> +				  vgic_sanitise_outer_cacheability);
>>>>>>> +
>>>>>>> +	reg &= ~PROPBASER_RES0_MASK;
>>>>>>> +	reg &= ~GENMASK_ULL(51, 48);
>>>>>>> +	return reg;
>>>>>>> +}
>>>>>>> +
>>>>>>> +static unsigned long vgic_mmio_read_propbase(struct kvm_vcpu *vcpu,
>>>>>>> +					     gpa_t addr, unsigned int len)
>>>>>>> +{
>>>>>>> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>>>>>>> +
>>>>>>> +	return extract_bytes(dist->propbaser, addr & 7, len);
>>>>>>> +}
>>>>>>> +
>>>>>>> +static void vgic_mmio_write_propbase(struct kvm_vcpu *vcpu,
>>>>>>> +				     gpa_t addr, unsigned int len,
>>>>>>> +				     unsigned long val)
>>>>>>> +{
>>>>>>> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>>>>>>> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>>>>>>> +	u64 propbaser = dist->propbaser;
>>>>>>> +
>>>>>>> +	/* Storing a value with LPIs already enabled is undefined */
>>>>>>> +	if (vgic_cpu->lpis_enabled)
>>>>>>> +		return;
>>>>>>> +
>>>>>>> +	propbaser = update_64bit_reg(propbaser, addr & 4, len, val);
>>>>>>> +	propbaser = vgic_sanitise_propbaser(propbaser);
>>>>>>> +
>>>>>>> +	dist->propbaser = propbaser;
>>>>>>
>>>>>> Which guarantees do we have that this will always be a single atomic
>>>>>> write?
>>>>>
>>>>> At least on arm64 - which is the only architecture this code is
>>>>> compiling for at the moment - I don't see why this shouldn't be a single
>>>>> write:
>>>>> 	str     x19, [x22,#3544]
>>>>> is what my setup here creates.
>>>>>
>>>>> Do we need something stronger? Do we want to postpone this to the point
>>>>> when we get arm(32) support?
>>>>
>>>> This is a *device*. It shouldn't be affected by whatever drives it.
>>>>
>>>> Now, and more to the point: the write shouldn't have to be atomic. All
>>>> 64bit registers should be able to cope with 32bit writes to it, as
>>>> described in the architecture spec (IHI0069C 8.1.3).
>>>
>>> That's not my concern.  My concern is that you have two CPUs updating
>>> the propbaser, once after the other, and you end up with a mix of the
>>> two updates.  If this C-code can ever become two 32-bit writes, for
>>> example, and these can happen in parallel you can end up with something
>>> like that.
>>>
>>> If there is not valid expectation from guest software that a real device
>>> stores either one or the other value, then it's fine to leave it as is.
>>>
>>> Thinking about it, any sane guest would probably synchronize multiple
>>> writes to this register itself?
>>
>> Ah, I finally clocked what you mean. Yes, we need to guarantee that the
>> update to the register itself is atomic (architectural requirement).
>> Which means we need to turn this in to an atomic access (atomic64_set).
> 
> Doesn't atomic64_set only work on an atomic size?

That would of course imply defining propbaser as an atomic64_t.

> Really, I think we should just take a lock around both the read and the
> write of dist->propbaser.  It's not like this is going to be frequent or
> in a critical path anywhere, right?

That'd work as well for the MMIO side, though we shouldn't have to
evaluate it anywhere else as long as LPI are not enabled (and at which
point it is not able to change anymore).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
