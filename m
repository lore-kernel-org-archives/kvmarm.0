From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 10/27] KVM: arm64: vgic-v3: Add ICV_HPPIR1_EL1 handler
Date: Fri, 9 Jun 2017 17:28:33 +0200
Message-ID: <20170609152833.GD11099@cbox>
References: <20170609114956.25963-1-marc.zyngier@arm.com>
 <20170609114956.25963-11-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170609114956.25963-11-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, Alexander Graf <agraf@suse.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jun 09, 2017 at 12:49:39PM +0100, Marc Zyngier wrote:
> Add a handler for reading the guest's view of the ICV_HPPIR1_EL1
> register. This is a simple parsing of the available LRs, extracting the
> highest available interrupt.
> 
> Tested-by: Alexander Graf <agraf@suse.de>
> Acked-by: David Daney <david.daney@cavium.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <cdall@linaro.org>

> ---
>  arch/arm64/include/asm/sysreg.h |  1 +
>  virt/kvm/arm/hyp/vgic-v3-sr.c   | 23 +++++++++++++++++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index aad46b8eea5e..bd000686194a 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -185,6 +185,7 @@
>  #define SYS_ICC_SGI1R_EL1		sys_reg(3, 0, 12, 11, 5)
>  #define SYS_ICC_IAR1_EL1		sys_reg(3, 0, 12, 12, 0)
>  #define SYS_ICC_EOIR1_EL1		sys_reg(3, 0, 12, 12, 1)
> +#define SYS_ICC_HPPIR1_EL1		sys_reg(3, 0, 12, 12, 2)
>  #define SYS_ICC_BPR1_EL1		sys_reg(3, 0, 12, 12, 3)
>  #define SYS_ICC_CTLR_EL1		sys_reg(3, 0, 12, 12, 4)
>  #define SYS_ICC_SRE_EL1			sys_reg(3, 0, 12, 12, 5)
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index 1c85a6df22d9..f031e8f088ae 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -790,6 +790,26 @@ static void __hyp_text __vgic_v3_write_apxr3(struct kvm_vcpu *vcpu,
>  	__vgic_v3_write_apxrn(vcpu, rt, 3);
>  }
>  
> +static void __hyp_text __vgic_v3_read_hppir(struct kvm_vcpu *vcpu,
> +					    u32 vmcr, int rt)
> +{
> +	u64 lr_val;
> +	int lr, lr_grp, grp;
> +
> +	grp = __vgic_v3_get_group(vcpu);
> +
> +	lr = __vgic_v3_highest_priority_lr(vcpu, vmcr, &lr_val);
> +	if (lr == -1)
> +		goto spurious;
> +
> +	lr_grp = !!(lr_val & ICH_LR_GROUP);
> +	if (lr_grp != grp)
> +		lr_val = ICC_IAR1_EL1_SPURIOUS;
> +
> +spurious:
> +	vcpu_set_reg(vcpu, rt, lr_val & ICH_LR_VIRTUAL_ID_MASK);
> +}
> +
>  int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  {
>  	int rt;
> @@ -854,6 +874,9 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  		else
>  			fn = __vgic_v3_write_apxr3;
>  		break;
> +	case SYS_ICC_HPPIR1_EL1:
> +		fn = __vgic_v3_read_hppir;
> +		break;
>  	default:
>  		return 0;
>  	}
> -- 
> 2.11.0
> 
