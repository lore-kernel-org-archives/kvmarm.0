From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 10/25] KVM: arm64: vgic-v3: Add ICV_HPPIR1_EL1 handler
Date: Tue, 6 Jun 2017 13:51:30 +0200
Message-ID: <20170606115130.GM9464@cbox>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-11-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170601102117.17750-11-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 01, 2017 at 11:21:02AM +0100, Marc Zyngier wrote:
> Add a handler for reading the guest's view of the ICV_HPPIR1_EL1
> register. This is a simple parsing of the available LRs, extracting the
> highest available interrupt.
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
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
> index d4f07f84602d..f0bc711db258 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -772,6 +772,26 @@ static void __hyp_text __vgic_v3_write_apxr3(struct kvm_vcpu *vcpu,
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

I don't get this.  The spec says that the special INTID 1023
  "...is returned in response to an interrupt acknowledge, if there is
   no pending interrupt with sufficient priority for it to be signaled to
   the PE, or if the highest priority pending interrupt is not
   appropriate for the:
    * Current Security state.  Interrupt group that is associated with
    * the System register."

So do we just take this to imply that it also covers the HPPIRx_EL1
registers (despite them being mentioned explicitly for the other special
INTIDs) or is there some other piece of spec I'm missing here?

Thanks,
-Christoffer

> +
> +spurious:
> +	vcpu_set_reg(vcpu, rt, lr_val & ICH_LR_VIRTUAL_ID_MASK);
> +}
> +
>  int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  {
>  	int rt;
> @@ -836,6 +856,9 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
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
