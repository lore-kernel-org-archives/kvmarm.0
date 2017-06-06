From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 22/25] KVM: arm64: vgic-v3: Add ICV_CTLR_EL1 handler
Date: Tue, 6 Jun 2017 15:23:05 +0200
Message-ID: <20170606132305.GA9464@cbox>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-23-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170601102117.17750-23-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 01, 2017 at 11:21:14AM +0100, Marc Zyngier wrote:
> Add a handler for reading/writing the guest's view of the ICV_CTLR_EL1
> register. only EOIMode and CBPR are of interest here, as all the other
> bits directly come from ICH_VTR_EL2 and are Read-Only.
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <cdall@linaro.org>

> ---
>  virt/kvm/arm/hyp/vgic-v3-sr.c | 46 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index cac9d563d97d..3a5749e6c797 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -881,6 +881,46 @@ static void __hyp_text __vgic_v3_read_rpr(struct kvm_vcpu *vcpu,
>  	vcpu_set_reg(vcpu, rt, val);
>  }
>  
> +static void __hyp_text __vgic_v3_read_ctlr(struct kvm_vcpu *vcpu,
> +					   u32 vmcr, int rt)
> +{
> +	u32 vtr, val;
> +
> +	vtr = read_gicreg(ICH_VTR_EL2);
> +	/* PRIbits */
> +	val = ((vtr >> 29) & 7) << ICC_CTLR_EL1_PRI_BITS_SHIFT;
> +	/* IDbits */
> +	val |= ((vtr >> 23) & 7) << ICC_CTLR_EL1_ID_BITS_SHIFT;
> +	/* SEIS */
> +	val |= ((vtr >> 22) & 1) << ICC_CTLR_EL1_SEIS_SHIFT;
> +	/* A3V */
> +	val |= ((vtr >> 21) & 1) << ICC_CTLR_EL1_A3V_SHIFT;
> +	/* EOImode */
> +	val |= ((vmcr & ICH_VMCR_EOIM_MASK) >> ICH_VMCR_EOIM_SHIFT) << ICC_CTLR_EL1_EOImode_SHIFT;
> +	/* CBPR */
> +	val |= (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
> +
> +	vcpu_set_reg(vcpu, rt, val);
> +}
> +
> +static void __hyp_text __vgic_v3_write_ctlr(struct kvm_vcpu *vcpu,
> +					    u32 vmcr, int rt)
> +{
> +	u32 val = vcpu_get_reg(vcpu, rt);
> +
> +	if (val & ICC_CTLR_EL1_CBPR_MASK)
> +		vmcr |= ICH_VMCR_CBPR_MASK;
> +	else
> +		vmcr &= ~ICH_VMCR_CBPR_MASK;
> +
> +	if (val & ICC_CTLR_EL1_EOImode_MASK)
> +		vmcr |= ICH_VMCR_EOIM_MASK;
> +	else
> +		vmcr &= ~ICH_VMCR_EOIM_MASK;
> +
> +	write_gicreg(vmcr, ICH_VMCR_EL2);
> +}
> +
>  int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  {
>  	int rt;
> @@ -973,6 +1013,12 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  	case SYS_ICC_RPR_EL1:
>  		fn = __vgic_v3_read_rpr;
>  		break;
> +	case SYS_ICC_CTLR_EL1:
> +		if (is_read)
> +			fn = __vgic_v3_read_ctlr;
> +		else
> +			fn = __vgic_v3_write_ctlr;
> +		break;
>  	default:
>  		return 0;
>  	}
> -- 
> 2.11.0
> 
