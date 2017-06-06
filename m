From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 23/25] KVM: arm64: vgic-v3: Add ICV_PMR_EL1 handler
Date: Tue, 6 Jun 2017 15:23:09 +0200
Message-ID: <20170606132309.GB9464@cbox>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-24-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170601102117.17750-24-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 01, 2017 at 11:21:15AM +0100, Marc Zyngier wrote:
> Add a handler for reading/writing the guest's view of the ICC_PMR_EL1
> register, which is located in the ICH_VMCR_EL2.VPMR field.
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <cdall@linaro.org>

> ---
>  virt/kvm/arm/hyp/vgic-v3-sr.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index 3a5749e6c797..3c6b7d46754a 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -874,6 +874,27 @@ static void __hyp_text __vgic_v3_read_hppir(struct kvm_vcpu *vcpu,
>  	vcpu_set_reg(vcpu, rt, lr_val & ICH_LR_VIRTUAL_ID_MASK);
>  }
>  
> +static void __hyp_text __vgic_v3_read_pmr(struct kvm_vcpu *vcpu,
> +					  u32 vmcr, int rt)
> +{
> +	vmcr &= ICH_VMCR_PMR_MASK;
> +	vmcr >>= ICH_VMCR_PMR_SHIFT;
> +	vcpu_set_reg(vcpu, rt, vmcr);
> +}
> +
> +static void __hyp_text __vgic_v3_write_pmr(struct kvm_vcpu *vcpu,
> +					   u32 vmcr, int rt)
> +{
> +	u32 val = vcpu_get_reg(vcpu, rt);
> +
> +	val <<= ICH_VMCR_PMR_SHIFT;
> +	val &= ICH_VMCR_PMR_MASK;
> +	vmcr &= ~ICH_VMCR_PMR_MASK;
> +	vmcr |= val;
> +
> +	write_gicreg(vmcr, ICH_VMCR_EL2);
> +}
> +
>  static void __hyp_text __vgic_v3_read_rpr(struct kvm_vcpu *vcpu,
>  					  u32 vmcr, int rt)
>  {
> @@ -1019,6 +1040,12 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  		else
>  			fn = __vgic_v3_write_ctlr;
>  		break;
> +	case SYS_ICC_PMR_EL1:
> +		if (is_read)
> +			fn = __vgic_v3_read_pmr;
> +		else
> +			fn = __vgic_v3_write_pmr;
> +		break;
>  	default:
>  		return 0;
>  	}
> -- 
> 2.11.0
> 
