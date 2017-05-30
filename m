From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 19/31] KVM: arm64: vgic-v3: Add ICV_BPR0_EL1 handler
Date: Tue, 30 May 2017 11:48:05 +0200
Message-ID: <14b35f0c-f730-e4b6-5a0f-c5388bc32b35@redhat.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
 <20170503104606.19342-20-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170503104606.19342-20-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,
On 03/05/2017 12:45, Marc Zyngier wrote:
> Add a handler for reading/writing the guest's view of the ICC_BPR0_EL1
> register, which is located in the ICH_VMCR_EL2.BPR0 field.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
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
> index a27671b1e9af..b21bb0c77ec2 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -666,11 +666,41 @@ static void __hyp_text __vgic_v3_write_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr,
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
> +
> +	__vgic_v3_write_vmcr(vmcr);
> +}
> +
>  static void __hyp_text __vgic_v3_write_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
>  {
>  	u64 val = vcpu_get_reg(vcpu, rt);
> @@ -846,6 +876,12 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
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
> 
