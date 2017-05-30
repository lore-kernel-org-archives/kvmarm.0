From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 27/31] KVM: arm64: vgic-v3: Add ICV_RPR_EL1 handler
Date: Tue, 30 May 2017 12:16:57 +0200
Message-ID: <f6beb628-b277-2551-d6b4-2b0539fbbf24@redhat.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
 <20170503104606.19342-28-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170503104606.19342-28-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 03/05/2017 12:46, Marc Zyngier wrote:
> Add a handler for reading the guest's view of the ICV_RPR_EL1
> register, returning the highest active priority.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
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
> index 563dd2d16c59..3a5f54f445b9 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -848,6 +848,13 @@ static void __hyp_text __vgic_v3_read_hppir(struct kvm_vcpu *vcpu,
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
>  	int rt = kvm_vcpu_sys_get_rt(vcpu);
> @@ -935,6 +942,9 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  	case SYS_ICC_DIR_EL1:
>  		fn = __vgic_v3_write_dir;
>  		break;
> +	case SYS_ICC_RPR_EL1:
> +		fn = __vgic_v3_read_rpr;
> +		break;
>  	default:
>  		return 0;
>  	}
> 
