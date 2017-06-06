From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 21/25] KVM: arm64: vgic-v3: Add ICV_RPR_EL1 handler
Date: Tue, 6 Jun 2017 15:23:00 +0200
Message-ID: <20170606132300.GZ9464@cbox>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-22-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170601102117.17750-22-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 01, 2017 at 11:21:13AM +0100, Marc Zyngier wrote:
> Add a handler for reading the guest's view of the ICV_RPR_EL1
> register, returning the highest active priority.
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <cdall@linaro.org>

> ---
>  arch/arm64/include/asm/sysreg.h |  1 +
>  virt/kvm/arm/hyp/vgic-v3-sr.c   | 10 ++++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 9971c5c435a7..c4d48e403629 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -187,6 +187,7 @@
>  #define SYS_ICC_AP0Rn_EL1(n)		sys_reg(3, 0, 12, 8, 4 | n)
>  #define SYS_ICC_AP1Rn_EL1(n)		sys_reg(3, 0, 12, 9, n)
>  #define SYS_ICC_DIR_EL1			sys_reg(3, 0, 12, 11, 1)
> +#define SYS_ICC_RPR_EL1			sys_reg(3, 0, 12, 11, 3)
>  #define SYS_ICC_SGI1R_EL1		sys_reg(3, 0, 12, 11, 5)
>  #define SYS_ICC_IAR1_EL1		sys_reg(3, 0, 12, 12, 0)
>  #define SYS_ICC_EOIR1_EL1		sys_reg(3, 0, 12, 12, 1)
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index b86a0776c407..cac9d563d97d 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -874,6 +874,13 @@ static void __hyp_text __vgic_v3_read_hppir(struct kvm_vcpu *vcpu,
>  	vcpu_set_reg(vcpu, rt, lr_val & ICH_LR_VIRTUAL_ID_MASK);
>  }
>  
> +static void __hyp_text __vgic_v3_read_rpr(struct kvm_vcpu *vcpu,
> +					  u32 vmcr, int rt)
> +{
> +	u32 val = __vgic_v3_get_highest_active_priority();
> +	vcpu_set_reg(vcpu, rt, val);
> +}
> +
>  int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  {
>  	int rt;
> @@ -963,6 +970,9 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  	case SYS_ICC_DIR_EL1:
>  		fn = __vgic_v3_write_dir;
>  		break;
> +	case SYS_ICC_RPR_EL1:
> +		fn = __vgic_v3_read_rpr;
> +		break;
>  	default:
>  		return 0;
>  	}
> -- 
> 2.11.0
> 
