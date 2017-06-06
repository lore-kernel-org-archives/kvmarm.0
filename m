From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 09/25] KVM: arm64: vgic-v3: Add ICV_AP1Rn_EL1 handler
Date: Tue, 6 Jun 2017 15:22:37 +0200
Message-ID: <20170606132237.GU9464@cbox>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-10-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170601102117.17750-10-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 01, 2017 at 11:21:01AM +0100, Marc Zyngier wrote:
> Add a handler for reading/writing the guest's view of the ICV_AP1Rn_EL1
> registers. We just map them to the corresponding ICH_AP1Rn_EL2 registers.
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <cdall@linaro.org>

> ---
>  arch/arm64/include/asm/sysreg.h |  1 +
>  virt/kvm/arm/hyp/vgic-v3-sr.c   | 94 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 95 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 15c142ce991c..aad46b8eea5e 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -180,6 +180,7 @@
>  
>  #define SYS_VBAR_EL1			sys_reg(3, 0, 12, 0, 0)
>  
> +#define SYS_ICC_AP1Rn_EL1(n)		sys_reg(3, 0, 12, 9, n)
>  #define SYS_ICC_DIR_EL1			sys_reg(3, 0, 12, 11, 1)
>  #define SYS_ICC_SGI1R_EL1		sys_reg(3, 0, 12, 11, 5)
>  #define SYS_ICC_IAR1_EL1		sys_reg(3, 0, 12, 12, 0)
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index 3f04122a5d4d..d4f07f84602d 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -702,6 +702,76 @@ static void __hyp_text __vgic_v3_write_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int
>  	__vgic_v3_write_vmcr(vmcr);
>  }
>  
> +static void __hyp_text __vgic_v3_read_apxrn(struct kvm_vcpu *vcpu, int rt, int n)
> +{
> +	u32 val;
> +
> +	if (!__vgic_v3_get_group(vcpu))
> +		val = __vgic_v3_read_ap0rn(n);
> +	else
> +		val = __vgic_v3_read_ap1rn(n);
> +
> +	vcpu_set_reg(vcpu, rt, val);
> +}
> +
> +static void __hyp_text __vgic_v3_write_apxrn(struct kvm_vcpu *vcpu, int rt, int n)
> +{
> +	u32 val = vcpu_get_reg(vcpu, rt);
> +
> +	if (!__vgic_v3_get_group(vcpu))
> +		__vgic_v3_write_ap0rn(val, n);
> +	else
> +		__vgic_v3_write_ap1rn(val, n);
> +}
> +
> +static void __hyp_text __vgic_v3_read_apxr0(struct kvm_vcpu *vcpu,
> +					    u32 vmcr, int rt)
> +{
> +	__vgic_v3_read_apxrn(vcpu, rt, 0);
> +}
> +
> +static void __hyp_text __vgic_v3_read_apxr1(struct kvm_vcpu *vcpu,
> +					    u32 vmcr, int rt)
> +{
> +	__vgic_v3_read_apxrn(vcpu, rt, 1);
> +}
> +
> +static void __hyp_text __vgic_v3_read_apxr2(struct kvm_vcpu *vcpu,
> +					    u32 vmcr, int rt)
> +{
> +	__vgic_v3_read_apxrn(vcpu, rt, 2);
> +}
> +
> +static void __hyp_text __vgic_v3_read_apxr3(struct kvm_vcpu *vcpu,
> +					    u32 vmcr, int rt)
> +{
> +	__vgic_v3_read_apxrn(vcpu, rt, 3);
> +}
> +
> +static void __hyp_text __vgic_v3_write_apxr0(struct kvm_vcpu *vcpu,
> +					     u32 vmcr, int rt)
> +{
> +	__vgic_v3_write_apxrn(vcpu, rt, 0);
> +}
> +
> +static void __hyp_text __vgic_v3_write_apxr1(struct kvm_vcpu *vcpu,
> +					     u32 vmcr, int rt)
> +{
> +	__vgic_v3_write_apxrn(vcpu, rt, 1);
> +}
> +
> +static void __hyp_text __vgic_v3_write_apxr2(struct kvm_vcpu *vcpu,
> +					     u32 vmcr, int rt)
> +{
> +	__vgic_v3_write_apxrn(vcpu, rt, 2);
> +}
> +
> +static void __hyp_text __vgic_v3_write_apxr3(struct kvm_vcpu *vcpu,
> +					     u32 vmcr, int rt)
> +{
> +	__vgic_v3_write_apxrn(vcpu, rt, 3);
> +}
> +
>  int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  {
>  	int rt;
> @@ -742,6 +812,30 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  		else
>  			fn = __vgic_v3_write_bpr1;
>  		break;
> +	case SYS_ICC_AP1Rn_EL1(0):
> +		if (is_read)
> +			fn = __vgic_v3_read_apxr0;
> +		else
> +			fn = __vgic_v3_write_apxr0;
> +		break;
> +	case SYS_ICC_AP1Rn_EL1(1):
> +		if (is_read)
> +			fn = __vgic_v3_read_apxr1;
> +		else
> +			fn = __vgic_v3_write_apxr1;
> +		break;
> +	case SYS_ICC_AP1Rn_EL1(2):
> +		if (is_read)
> +			fn = __vgic_v3_read_apxr2;
> +		else
> +			fn = __vgic_v3_write_apxr2;
> +		break;
> +	case SYS_ICC_AP1Rn_EL1(3):
> +		if (is_read)
> +			fn = __vgic_v3_read_apxr3;
> +		else
> +			fn = __vgic_v3_write_apxr3;
> +		break;
>  	default:
>  		return 0;
>  	}
> -- 
> 2.11.0
> 
