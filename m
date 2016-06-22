From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 06/15] KVM: arm64: handle ITS related GICv3
 redistributor registers
Date: Wed, 22 Jun 2016 15:07:48 +0100
Message-ID: <576A9BB4.3000800@arm.com>
References: <1466165327-32060-1-git-send-email-andre.przywara@arm.com>
 <1466165327-32060-7-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4441549B30
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2016 10:03:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wVY4bf6Q8ID3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jun 2016 10:02:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2D6549B2E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2016 10:02:58 -0400 (EDT)
In-Reply-To: <1466165327-32060-7-git-send-email-andre.przywara@arm.com>
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

On 17/06/16 13:08, Andre Przywara wrote:
> In the GICv3 redistributor there are the PENDBASER and PROPBASER
> registers which we did not emulate so far, as they only make sense
> when having an ITS. In preparation for that emulate those MMIO
> accesses by storing the 64-bit data written into it into a variable
> which we later read in the ITS emulation.
> We also sanitise the registers, making sure RES0 regions are respected
> and checking for valid memory attributes.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/vgic/vgic.h            |  13 +++++
>  include/linux/irqchip/arm-gic-v3.h |   1 +
>  virt/kvm/arm/vgic/vgic-mmio-v3.c   | 112 ++++++++++++++++++++++++++++++++++++-
>  3 files changed, 124 insertions(+), 2 deletions(-)
> 
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> index e488a369..dc7f2fd 100644
> --- a/include/kvm/vgic/vgic.h
> +++ b/include/kvm/vgic/vgic.h
> @@ -146,6 +146,14 @@ struct vgic_dist {
>  	struct vgic_irq		*spis;
>  
>  	struct vgic_io_device	dist_iodev;
> +
> +	/*
> +	 * Contains the address of the LPI configuration table.
> +	 * Since we report GICR_TYPER.CommonLPIAff as 0b00, we can share
> +	 * one address across all redistributors.
> +	 * GICv3 spec: 6.1.2 "LPI Configuration tables"
> +	 */
> +	u64			propbaser;
>  };
>  
>  struct vgic_v2_cpu_if {
> @@ -200,6 +208,11 @@ struct vgic_cpu {
>  	 */
>  	struct vgic_io_device	rd_iodev;
>  	struct vgic_io_device	sgi_iodev;
> +
> +	/* Points to the LPI pending tables for the redistributor */
> +	u64 pendbaser;
> +
> +	bool lpis_enabled;
>  };
>  
>  int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index bfbd707..64e8c70 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -124,6 +124,7 @@
>  #define GICR_PROPBASER_WaWb		(5U << 7)
>  #define GICR_PROPBASER_RaWaWt		(6U << 7)
>  #define GICR_PROPBASER_RaWaWb		(7U << 7)
> +#define GICR_PROPBASER_CACHEABILITY_SHIFT (7)
>  #define GICR_PROPBASER_CACHEABILITY_MASK (7U << 7)
>  #define GICR_PROPBASER_IDBITS_MASK	(0x1f)
>  
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index c38302d..8cd7190 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -29,6 +29,19 @@ static unsigned long extract_bytes(unsigned long data, unsigned int offset,
>  	return (data >> (offset * 8)) & GENMASK_ULL(num * 8 - 1, 0);
>  }
>  
> +/* allows updates of any half of a 64-bit register (or the whole thing) */
> +static u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
> +			    unsigned long val)
> +{
> +	int lower = (offset & 4) * 8;
> +	int upper = lower + 8 * len - 1;
> +
> +	reg &= ~GENMASK_ULL(upper, lower);
> +	val &= GENMASK_ULL(len * 8 - 1, 0);
> +
> +	return reg | ((u64)val << lower);
> +}
> +
>  static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
>  					    gpa_t addr, unsigned int len)
>  {
> @@ -146,6 +159,101 @@ static unsigned long vgic_mmio_read_v3_idregs(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +/* We don't have any constraints about the shareability attributes. */
> +static void vgic_sanitise_shareability(u64 *reg)

Which register is that for?

> +{
> +}

We may not have constraints, but we don't want to let the luser go wild
either... ;-) The notion of outer sharable is pretty useless on ARMv8,
and I'd rather not pretend it is supported in any way. Can you please
make this support all values but OS?

> +
> +#define GIC_CACHE_PROP_ATTR(x) ((x) >> GICR_PROPBASER_CACHEABILITY_SHIFT)
> +#define GIC_CACHE_PROP_MASK \
> +	((u64)(GIC_CACHE_PROP_ATTR(GICR_PROPBASER_CACHEABILITY_MASK)))
> +
> +static void vgic_sanitise_outer_cacheability(u64 *reg, int reg_shift)

I assume this is for GICR_PROPBASER?

> +{
> +	switch (*reg >> reg_shift) {

What about the upper bits?

> +	case GIC_CACHE_PROP_ATTR(GICR_PROPBASER_nC):
> +		*reg &= ~(GIC_CACHE_PROP_MASK << reg_shift);
> +		*reg |= GIC_CACHE_PROP_ATTR(GICR_PROPBASER_WaWb) << reg_shift;
> +		break;

Why would you force things to be cacheable? Specially outer cacheable?

Frankly, I'd rather stick to either 000 (same as inner cacheability) and
001 (outer non-cacheable).

> +	default:
> +		/* We are fine with the other attributes. */
> +		break;
> +	}
> +}
> +
> +static void vgic_sanitise_inner_cacheability(u64 *reg, int reg_shift)
> +{
> +	switch (*reg >> reg_shift) {
> +	case GIC_CACHE_PROP_ATTR(GICR_PROPBASER_nCnB):
> +	case GIC_CACHE_PROP_ATTR(GICR_PROPBASER_nC):
> +		*reg &= ~(GIC_CACHE_PROP_MASK << reg_shift);
> +		*reg |= GIC_CACHE_PROP_ATTR(GICR_PROPBASER_WaWb) << reg_shift;
> +		break;
> +	default:
> +		/* We are fine with the other attributes. */
> +		break;
> +	}

I fail to see the difference with the previous function, and it has the
same bugs. As for the cacheability, we definitely want to enforce it, so
you should make both Device-nGnRnE and Normal-nC unsupported.

> +}
> +
> +static void vgic_sanitise_redist_baser(u64 *reg)

Which base register? Please name them entierely (gicr_propbaser) so that
we know what you are messing with.

> +{
> +	vgic_sanitise_shareability(reg);
> +	vgic_sanitise_inner_cacheability(reg,
> +					 GICR_PROPBASER_CACHEABILITY_SHIFT);
> +	vgic_sanitise_outer_cacheability(reg, 56);

Care to define this bit field?

> +}
> +
> +#define PROPBASER_RES0_MASK 0xf8f0000000000060
> +#define PENDBASER_RES0_MASK 0xb8f000000000f07f

Please build those using GENMASK_ULL. I can't process long hex values,
but I can read something that matches the spec.

> +
> +static unsigned long vgic_mmio_read_propbase(struct kvm_vcpu *vcpu,
> +					     gpa_t addr, unsigned int len)
> +{
> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> +
> +	return extract_bytes(dist->propbaser, addr & 7, len);
> +}
> +
> +static void vgic_mmio_write_propbase(struct kvm_vcpu *vcpu,
> +				     gpa_t addr, unsigned int len,
> +				     unsigned long val)
> +{
> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +
> +	/* Storing a value with LPIs already enabled is undefined */
> +	if (vgic_cpu->lpis_enabled)
> +		return;
> +
> +	dist->propbaser = update_64bit_reg(dist->propbaser, addr & 4, len, val);
> +	dist->propbaser &= ~PROPBASER_RES0_MASK;
> +	vgic_sanitise_redist_baser(&dist->propbaser);
> +}
> +
> +static unsigned long vgic_mmio_read_pendbase(struct kvm_vcpu *vcpu,
> +					     gpa_t addr, unsigned int len)
> +{
> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +
> +	return extract_bytes(vgic_cpu->pendbaser, addr & 7, len);
> +}
> +
> +static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
> +				     gpa_t addr, unsigned int len,
> +				     unsigned long val)
> +{
> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +
> +	/* Storing a value with LPIs already enabled is undefined */
> +	if (vgic_cpu->lpis_enabled)
> +		return;
> +
> +	vgic_cpu->pendbaser = update_64bit_reg(vgic_cpu->pendbaser,
> +					       addr & 4, len, val);
> +	vgic_cpu->pendbaser &= ~PENDBASER_RES0_MASK;
> +	vgic_sanitise_redist_baser(&vgic_cpu->pendbaser);
> +}
> +
>  /*
>   * The GICv3 per-IRQ registers are split to control PPIs and SGIs in the
>   * redistributors, while SPIs are covered by registers in the distributor
> @@ -226,10 +334,10 @@ static const struct vgic_register_region vgic_v3_rdbase_registers[] = {
>  		vgic_mmio_read_v3r_typer, vgic_mmio_write_wi, 8,
>  		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_LENGTH(GICR_PROPBASER,
> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
> +		vgic_mmio_read_propbase, vgic_mmio_write_propbase, 8,
>  		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_LENGTH(GICR_PENDBASER,
> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
> +		vgic_mmio_read_pendbase, vgic_mmio_write_pendbase, 8,
>  		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_LENGTH(GICR_IDREGS,
>  		vgic_mmio_read_v3_idregs, vgic_mmio_write_wi, 48,
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
