From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 05/27] KVM: arm64: vgic-v3: Add ICV_BPR1_EL1 handler
Date: Fri, 9 Jun 2017 17:23:10 +0200
Message-ID: <20170609152310.GA11099@cbox>
References: <20170609114956.25963-1-marc.zyngier@arm.com>
 <20170609114956.25963-6-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170609114956.25963-6-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, Alexander Graf <agraf@suse.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jun 09, 2017 at 12:49:34PM +0100, Marc Zyngier wrote:
> Add a handler for reading/writing the guest's view of the ICC_BPR1_EL1
> register, which is located in the ICH_VMCR_EL2.BPR1 field.
> 
> Tested-by: Alexander Graf <agraf@suse.de>
> Acked-by: David Daney <david.daney@cavium.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <cdall@linaro.org>

> ---
>  virt/kvm/arm/hyp/vgic-v3-sr.c | 57 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 57 insertions(+)
> 
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index e6c05b95a1b1..fe021abc8b51 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -375,6 +375,57 @@ void __hyp_text __vgic_v3_write_vmcr(u32 vmcr)
>  
>  #ifdef CONFIG_ARM64
>  
> +static int __hyp_text __vgic_v3_bpr_min(void)
> +{
> +	/* See Pseudocode for VPriorityGroup */
> +	return 8 - vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));
> +}
> +
> +static unsigned int __hyp_text __vgic_v3_get_bpr0(u32 vmcr)
> +{
> +	return (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
> +}
> +
> +static unsigned int __hyp_text __vgic_v3_get_bpr1(u32 vmcr)
> +{
> +	unsigned int bpr;
> +
> +	if (vmcr & ICH_VMCR_CBPR_MASK) {
> +		bpr = __vgic_v3_get_bpr0(vmcr);
> +		if (bpr < 7)
> +			bpr++;
> +	} else {
> +		bpr = (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
> +	}
> +
> +	return bpr;
> +}
> +
> +static void __hyp_text __vgic_v3_read_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
> +{
> +	vcpu_set_reg(vcpu, rt, __vgic_v3_get_bpr1(vmcr));
> +}
> +
> +static void __hyp_text __vgic_v3_write_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
> +{
> +	u64 val = vcpu_get_reg(vcpu, rt);
> +	u8 bpr_min = __vgic_v3_bpr_min();
> +
> +	if (vmcr & ICH_VMCR_CBPR_MASK)
> +		return;
> +
> +	/* Enforce BPR limiting */
> +	if (val < bpr_min)
> +		val = bpr_min;
> +
> +	val <<= ICH_VMCR_BPR1_SHIFT;
> +	val &= ICH_VMCR_BPR1_MASK;
> +	vmcr &= ~ICH_VMCR_BPR1_MASK;
> +	vmcr |= val;
> +
> +	__vgic_v3_write_vmcr(vmcr);
> +}
> +
>  int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  {
>  	int rt;
> @@ -397,6 +448,12 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  	is_read = (esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_READ;
>  
>  	switch (sysreg) {
> +	case SYS_ICC_BPR1_EL1:
> +		if (is_read)
> +			fn = __vgic_v3_read_bpr1;
> +		else
> +			fn = __vgic_v3_write_bpr1;
> +		break;
>  	default:
>  		return 0;
>  	}
> -- 
> 2.11.0
> 
