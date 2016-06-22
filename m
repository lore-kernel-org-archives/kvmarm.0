From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 06/15] KVM: arm64: handle ITS related GICv3
 redistributor registers
Date: Wed, 22 Jun 2016 15:59:05 +0100
Message-ID: <576AA7B9.2020005@arm.com>
References: <1466165327-32060-1-git-send-email-andre.przywara@arm.com>
 <1466165327-32060-7-git-send-email-andre.przywara@arm.com>
 <576A9BB4.3000800@arm.com> <16599085-afb1-cf45-fb08-1f3843e73283@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FADF49B1A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2016 10:54:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D9DrLlMEikAF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jun 2016 10:54:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C187F499A1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2016 10:54:14 -0400 (EDT)
In-Reply-To: <16599085-afb1-cf45-fb08-1f3843e73283@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 22/06/16 15:39, Andre Przywara wrote:
> Hi Marc,
> 
> On 22/06/16 15:07, Marc Zyngier wrote:
>> On 17/06/16 13:08, Andre Przywara wrote:
>>> In the GICv3 redistributor there are the PENDBASER and PROPBASER
>>> registers which we did not emulate so far, as they only make sense
>>> when having an ITS. In preparation for that emulate those MMIO
>>> accesses by storing the 64-bit data written into it into a variable
>>> which we later read in the ITS emulation.
>>> We also sanitise the registers, making sure RES0 regions are respected
>>> and checking for valid memory attributes.
>>>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>> ---
>>>  include/kvm/vgic/vgic.h            |  13 +++++
>>>  include/linux/irqchip/arm-gic-v3.h |   1 +
>>>  virt/kvm/arm/vgic/vgic-mmio-v3.c   | 112 ++++++++++++++++++++++++++++++++++++-
>>>  3 files changed, 124 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
>>> index e488a369..dc7f2fd 100644
>>> --- a/include/kvm/vgic/vgic.h
>>> +++ b/include/kvm/vgic/vgic.h
>>> @@ -146,6 +146,14 @@ struct vgic_dist {
>>>  	struct vgic_irq		*spis;
>>>  
>>>  	struct vgic_io_device	dist_iodev;
>>> +
>>> +	/*
>>> +	 * Contains the address of the LPI configuration table.
>>> +	 * Since we report GICR_TYPER.CommonLPIAff as 0b00, we can share
>>> +	 * one address across all redistributors.
>>> +	 * GICv3 spec: 6.1.2 "LPI Configuration tables"
>>> +	 */
>>> +	u64			propbaser;
>>>  };
>>>  
>>>  struct vgic_v2_cpu_if {
>>> @@ -200,6 +208,11 @@ struct vgic_cpu {
>>>  	 */
>>>  	struct vgic_io_device	rd_iodev;
>>>  	struct vgic_io_device	sgi_iodev;
>>> +
>>> +	/* Points to the LPI pending tables for the redistributor */
>>> +	u64 pendbaser;
>>> +
>>> +	bool lpis_enabled;
>>>  };
>>>  
>>>  int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
>>> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
>>> index bfbd707..64e8c70 100644
>>> --- a/include/linux/irqchip/arm-gic-v3.h
>>> +++ b/include/linux/irqchip/arm-gic-v3.h
>>> @@ -124,6 +124,7 @@
>>>  #define GICR_PROPBASER_WaWb		(5U << 7)
>>>  #define GICR_PROPBASER_RaWaWt		(6U << 7)
>>>  #define GICR_PROPBASER_RaWaWb		(7U << 7)
>>> +#define GICR_PROPBASER_CACHEABILITY_SHIFT (7)
>>>  #define GICR_PROPBASER_CACHEABILITY_MASK (7U << 7)
>>>  #define GICR_PROPBASER_IDBITS_MASK	(0x1f)
>>>  
>>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> index c38302d..8cd7190 100644
>>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> @@ -29,6 +29,19 @@ static unsigned long extract_bytes(unsigned long data, unsigned int offset,
>>>  	return (data >> (offset * 8)) & GENMASK_ULL(num * 8 - 1, 0);
>>>  }
>>>  
>>> +/* allows updates of any half of a 64-bit register (or the whole thing) */
>>> +static u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
>>> +			    unsigned long val)
>>> +{
>>> +	int lower = (offset & 4) * 8;
>>> +	int upper = lower + 8 * len - 1;
>>> +
>>> +	reg &= ~GENMASK_ULL(upper, lower);
>>> +	val &= GENMASK_ULL(len * 8 - 1, 0);
>>> +
>>> +	return reg | ((u64)val << lower);
>>> +}
>>> +
>>>  static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
>>>  					    gpa_t addr, unsigned int len)
>>>  {
>>> @@ -146,6 +159,101 @@ static unsigned long vgic_mmio_read_v3_idregs(struct kvm_vcpu *vcpu,
>>>  	return 0;
>>>  }
>>>  
>>> +/* We don't have any constraints about the shareability attributes. */
>>> +static void vgic_sanitise_shareability(u64 *reg)
>>
>> Which register is that for?
> 
> I was under the assumption that any shareability constraints would apply
> to _all_ registers that use that mechanism:
> PENDBASER, PROPBASER, BASER(device), BASER(collection), CBASER.
> That's why this common function.
> 
>>> +{
>>> +}
>>
>> We may not have constraints, but we don't want to let the luser go wild
>> either... ;-) The notion of outer sharable is pretty useless on ARMv8,
>> and I'd rather not pretend it is supported in any way. Can you please
>> make this support all values but OS?
> 
> Sure, actually I was hoping for your guidance here, since I couldn't
> really wrap my mind around shareability in this virtualisation context.
> 
>>> +
>>> +#define GIC_CACHE_PROP_ATTR(x) ((x) >> GICR_PROPBASER_CACHEABILITY_SHIFT)
>>> +#define GIC_CACHE_PROP_MASK \
>>> +	((u64)(GIC_CACHE_PROP_ATTR(GICR_PROPBASER_CACHEABILITY_MASK)))
>>> +
>>> +static void vgic_sanitise_outer_cacheability(u64 *reg, int reg_shift)
>>
>> I assume this is for GICR_PROPBASER?
> 
> Again this is for all registers as listed above. Do we need separate
> constraints for different registers?

I'd rather have something that is per register (after all, there is only
a handful). It will make the code readable (and it is so trivial that
the compiler will inline it anyway).

> 
>>> +{
>>> +	switch (*reg >> reg_shift) {
>>
>> What about the upper bits?
> 
> Pah ;-)
> Will fix it ...
> 
>>> +	case GIC_CACHE_PROP_ATTR(GICR_PROPBASER_nC):
>>> +		*reg &= ~(GIC_CACHE_PROP_MASK << reg_shift);
>>> +		*reg |= GIC_CACHE_PROP_ATTR(GICR_PROPBASER_WaWb) << reg_shift;
>>> +		break;
>>
>> Why would you force things to be cacheable? Specially outer cacheable?
> 
> To be honest, I couldn't really make out what "outer cacheability"
> actually means in the context of a guest having user space memory mapped.
> 
>>
>> Frankly, I'd rather stick to either 000 (same as inner cacheability) and
>> 001 (outer non-cacheable).
> 
> Sure.
> 
>>
>>> +	default:
>>> +		/* We are fine with the other attributes. */
>>> +		break;
>>> +	}
>>> +}
>>> +
>>> +static void vgic_sanitise_inner_cacheability(u64 *reg, int reg_shift)
>>> +{
>>> +	switch (*reg >> reg_shift) {
>>> +	case GIC_CACHE_PROP_ATTR(GICR_PROPBASER_nCnB):
>>> +	case GIC_CACHE_PROP_ATTR(GICR_PROPBASER_nC):
>>> +		*reg &= ~(GIC_CACHE_PROP_MASK << reg_shift);
>>> +		*reg |= GIC_CACHE_PROP_ATTR(GICR_PROPBASER_WaWb) << reg_shift;
>>> +		break;
>>> +	default:
>>> +		/* We are fine with the other attributes. */
>>> +		break;
>>> +	}
>>
>> I fail to see the difference with the previous function, 
> 
> The meaning of 000 is different: for inner cacheability it means Device,
> for outer it means "same as inner". So we need two functions here to
> differentiate, don't we? Unless our constraints happen to be the same
> for the two (by coincidence)?
> Also I think you just requested different constraints for outer and
> inner cacheability? Or did I miss something?

Yeah, I missed the first line. Your GIC_CACHE_PROP_ATTR() macros are
really getting in the way here. I'd prefer to see each register accessor
doing its own "sanitisation" in situ, without some fake sharing of code.

>> and it has the
>> same bugs. As for the cacheability, we definitely want to enforce it, so
>> you should make both Device-nGnRnE and Normal-nC unsupported.
> 
> Isn't that what the function does? If the value is 000 or 001, it
> changes it to WaWb, otherwise it keeps the value. At least that was what
> I had in mind. WaWb is what the Linux ITS driver prefers, so this serves

Careful, that's about to change. And don't mind reporting *any* value,
as long as it is cacheable.

> as some sensible value here (I hope). It's a bit weird that these bits
> are not a bitfield, so the ITS cannot report back a set of supported
> attributes easily at once.
> 
>>> +}
>>> +
>>> +static void vgic_sanitise_redist_baser(u64 *reg)
>>
>> Which base register? Please name them entierely (gicr_propbaser) so that
>> we know what you are messing with.
> 
> This is for BASER (both for collections and devices). It's a bit
> unfortunate that this one just consists of the stem which the other
> registers also share, so it's a bit hard to differentiate without
> inventing a new name. I can add a comment, though.

Well, you say "redist_baser". To me, that's a redistributor, not an ITS
register. just drop these functions, and do it in each accessor.
Everything will become much more readable.

> 
>>> +{
>>> +	vgic_sanitise_shareability(reg);
>>> +	vgic_sanitise_inner_cacheability(reg,
>>> +					 GICR_PROPBASER_CACHEABILITY_SHIFT);
>>> +	vgic_sanitise_outer_cacheability(reg, 56);
>>
>> Care to define this bit field?
> 
> Sure.
> 
>>
>>> +}
>>> +
>>> +#define PROPBASER_RES0_MASK 0xf8f0000000000060
>>> +#define PENDBASER_RES0_MASK 0xb8f000000000f07f
>>
>> Please build those using GENMASK_ULL. I can't process long hex values,
>> but I can read something that matches the spec.
> 
> OK.
> 
> Thanks for having a look!

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
