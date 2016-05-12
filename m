From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 35/55] KVM: arm/arm64: vgic-new: Add GICv3 IDREGS
 register handler
Date: Thu, 12 May 2016 14:12:26 +0200
Message-ID: <20160512121226.GF27623@cbox>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-36-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462531568-9799-36-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 06, 2016 at 11:45:48AM +0100, Andre Przywara wrote:
> We implement the only one ID register that is required by the
> architecture, also this is the one that Linux actually checks.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Changelog v1 .. v2:
> - adapt to new MMIO framework
> 
>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index d137242..48fba9c 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -110,6 +110,22 @@ static unsigned long vgic_mmio_read_v3r_iidr(struct kvm_vcpu *vcpu,
>  	return extract_bytes(value, addr & 3, len);
>  }
>  
> +static unsigned long vgic_mmio_read_v3_idregs(struct kvm_vcpu *vcpu,
> +					      gpa_t addr, unsigned int len)
> +{
> +	u32 regnr = (addr & 0x3f) - (GICD_IDREGS & 0x3f);

this regnr thing is confusing, because it's not an index, it's an
address offset.

why can't you do:

	switch (addr & 0xffff) {
	case GICD_PIDR2:
	}


> +	u32 reg = 0;
> +
> +	switch (regnr + GICD_IDREGS) {
> +	case GICD_PIDR2:
> +		/* report a GICv3 compliant implementation */
> +		reg = 0x3b;
> +		break;
> +	}
> +
> +	return extract_bytes(reg, addr & 3, len);
> +}
> +
>  /*
>   * The GICv3 per-IRQ registers are split to control PPIs and SGIs in the
>   * redistributors, while SPIs are covered by registers in the distributor
> @@ -160,7 +176,7 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
>  	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IROUTER,
>  		vgic_mmio_read_raz, vgic_mmio_write_wi, 64),
>  	REGISTER_DESC_WITH_LENGTH(GICD_IDREGS,
> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 48),
> +		vgic_mmio_read_v3_idregs, vgic_mmio_write_wi, 48),
>  };
>  
>  static const struct vgic_register_region vgic_v3_rdbase_registers[] = {
> @@ -175,7 +191,7 @@ static const struct vgic_register_region vgic_v3_rdbase_registers[] = {
>  	REGISTER_DESC_WITH_LENGTH(GICR_PENDBASER,
>  		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
>  	REGISTER_DESC_WITH_LENGTH(GICR_IDREGS,
> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 48),
> +		vgic_mmio_read_v3_idregs, vgic_mmio_write_wi, 48),
>  };
>  
>  static const struct vgic_register_region vgic_v3_sgibase_registers[] = {
> -- 
> 2.7.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
