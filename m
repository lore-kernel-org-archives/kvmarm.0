From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 13/25] KVM: arm64: vgic-v3: Add ICV_BPR0_EL1 handler
Date: Tue, 6 Jun 2017 14:11:50 +0200
Message-ID: <20170606121150.GO9464@cbox>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-14-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170601102117.17750-14-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 01, 2017 at 11:21:05AM +0100, Marc Zyngier wrote:
> Add a handler for reading/writing the guest's view of the ICC_BPR0_EL1
> register, which is located in the ICH_VMCR_EL2.BPR0 field.
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/sysreg.h |  1 +
>  virt/kvm/arm/hyp/vgic-v3-sr.c   | 36 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 37 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index bd000686194a..d20be0b28ca4 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -180,6 +180,7 @@
>  
>  #define SYS_VBAR_EL1			sys_reg(3, 0, 12, 0, 0)
>  
> +#define SYS_ICC_BPR0_EL1		sys_reg(3, 0, 12, 8, 3)
>  #define SYS_ICC_AP1Rn_EL1(n)		sys_reg(3, 0, 12, 9, n)
>  #define SYS_ICC_DIR_EL1			sys_reg(3, 0, 12, 11, 1)
>  #define SYS_ICC_SGI1R_EL1		sys_reg(3, 0, 12, 11, 5)
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index 42ac9ee7650a..54a8e828c85b 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -688,11 +688,41 @@ static void __hyp_text __vgic_v3_write_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr,
>  	__vgic_v3_write_vmcr(vmcr);
>  }
>  
> +static void __hyp_text __vgic_v3_read_bpr0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
> +{
> +	vcpu_set_reg(vcpu, rt, __vgic_v3_get_bpr0(vmcr));
> +}
> +
>  static void __hyp_text __vgic_v3_read_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
>  {
>  	vcpu_set_reg(vcpu, rt, __vgic_v3_get_bpr1(vmcr));
>  }
>  
> +static void __hyp_text __vgic_v3_write_bpr0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
> +{
> +	u64 val = vcpu_get_reg(vcpu, rt);
> +	u8 bpr_min = 7 - vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));
> +
> +	/* Enforce BPR limiting */
> +	if (val < bpr_min)
> +		val = bpr_min;
> +
> +	val <<= ICH_VMCR_BPR0_SHIFT;
> +	val &= ICH_VMCR_BPR0_MASK;
> +	vmcr &= ~ICH_VMCR_BPR0_MASK;
> +	vmcr |= val;
> +
> +	if (vmcr & ICH_VMCR_CBPR_MASK) {
> +		val = __vgic_v3_get_bpr1(vmcr);
> +		val <<= ICH_VMCR_BPR1_SHIFT;
> +		val &= ICH_VMCR_BPR1_MASK;
> +		vmcr &= ~ICH_VMCR_BPR1_MASK;
> +		vmcr |= val;
> +	}

I don't understand why this block is needed?

Thanks,
-Christoffer

> +
> +	__vgic_v3_write_vmcr(vmcr);
> +}
> +
>  static void __hyp_text __vgic_v3_write_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
>  {
>  	u64 val = vcpu_get_reg(vcpu, rt);
> @@ -870,6 +900,12 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  	case SYS_ICC_HPPIR1_EL1:
>  		fn = __vgic_v3_read_hppir;
>  		break;
> +	case SYS_ICC_BPR0_EL1:
> +		if (is_read)
> +			fn = __vgic_v3_read_bpr0;
> +		else
> +			fn = __vgic_v3_write_bpr0;
> +		break;
>  	default:
>  		return 0;
>  	}
> -- 
> 2.11.0
> 
