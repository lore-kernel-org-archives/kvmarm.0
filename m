From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 06/25] KVM: arm64: vgic-v3: Add ICV_IGRPEN1_EL1 handler
Date: Tue, 6 Jun 2017 15:22:33 +0200
Message-ID: <20170606132233.GT9464@cbox>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-7-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170601102117.17750-7-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 01, 2017 at 11:20:58AM +0100, Marc Zyngier wrote:
> Add a handler for reading/writing the guest's view of the ICC_IGRPEN1_EL1
> register, which is located in the ICH_VMCR_EL2.VENG1 field.
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <cdall@linaro.org>

> ---
>  virt/kvm/arm/hyp/vgic-v3-sr.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index 6254eaf72a77..168539dfd0b9 100644
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
> @@ -442,6 +459,12 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
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
> -- 
> 2.11.0
> 
