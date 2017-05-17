From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 12/31] KVM: arm64: vgic-v3: Add ICV_IGRPEN1_EL1 handler
Date: Wed, 17 May 2017 17:39:17 +0200
Message-ID: <cf890c5c-2c16-c5ef-cedf-b10616d7ef8c@redhat.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
 <20170503104606.19342-13-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170503104606.19342-13-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 03/05/2017 12:45, Marc Zyngier wrote:
> Add a handler for reading/writing the guest's view of the ICC_IGRPEN1_EL1
> register, which is located in the ICH_VMCR_EL2.VENG1 field.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  virt/kvm/arm/hyp/vgic-v3-sr.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index f0f038c490a5..473ef22508e6 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -395,6 +395,23 @@ static unsigned int __hyp_text __vgic_v3_get_bpr1(u32 vmcr)
>  	return bpr;
>  }
>  
> +static void __hyp_text __vgic_v3_read_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
> +{
> +	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG1_MASK));
> +}
> +
> +static void __hyp_text __vgic_v3_write_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
> +{
> +	u64 val = vcpu_get_reg(vcpu, rt);
> +
> +	if (val & 1)
> +		vmcr |= ICH_VMCR_ENG1_MASK;
> +	else
> +		vmcr &= ~ICH_VMCR_ENG1_MASK;
> +
> +	__vgic_v3_write_vmcr(vmcr);
> +}
> +
>  static void __hyp_text __vgic_v3_read_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
>  {
>  	vcpu_set_reg(vcpu, rt, __vgic_v3_get_bpr1(vmcr));
> @@ -440,6 +457,12 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  	is_read = (esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_READ;
>  
>  	switch (sysreg) {
> +	case SYS_ICC_GRPEN1_EL1:
> +		if (is_read)
> +			fn = __vgic_v3_read_igrpen1;
> +		else
> +			fn = __vgic_v3_write_igrpen1;
> +		break;
>  	case SYS_ICC_BPR1_EL1:
>  		if (is_read)
>  			fn = __vgic_v3_read_bpr1;
> 
