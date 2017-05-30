From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 28/31] KVM: arm64: vgic-v3: Add ICV_CTLR_EL1 handler
Date: Tue, 30 May 2017 12:27:30 +0200
Message-ID: <d08e9041-4033-d70a-495b-0773ec5d0687@redhat.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
 <20170503104606.19342-29-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170503104606.19342-29-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 03/05/2017 12:46, Marc Zyngier wrote:
> Add a handler for reading/writing the guest's view of the ICV_CTLR_EL1
> register. only EOIMode and CBPR are of interest here, as all the other
> bits directly come from ICH_VTR_EL2 and are Read-Only.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  virt/kvm/arm/hyp/vgic-v3-sr.c | 46 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index 3a5f54f445b9..981201bf7a5e 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -855,6 +855,46 @@ static void __hyp_text __vgic_v3_read_rpr(struct kvm_vcpu *vcpu,
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
>  	int rt = kvm_vcpu_sys_get_rt(vcpu);
> @@ -945,6 +985,12 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
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
> 
