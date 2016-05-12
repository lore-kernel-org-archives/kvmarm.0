From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 52/55] KVM: arm/arm64: vgic-new: Add vgic_v2/v3_enable
Date: Thu, 12 May 2016 21:30:07 +0200
Message-ID: <20160512193007.GS27623@cbox>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-53-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462531568-9799-53-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 06, 2016 at 11:46:05AM +0100, Andre Przywara wrote:
> From: Eric Auger <eric.auger@linaro.org>
> 
> Enable the VGIC operation by properly initialising the registers
> in the hypervisor GIC interface.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-v2.c | 11 ++++++++++-
>  virt/kvm/arm/vgic/vgic-v3.c | 23 ++++++++++++++++++++++-
>  2 files changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index 1e411f5..4493593 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -211,9 +211,18 @@ void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
>  			GICH_VMCR_PRIMASK_SHIFT;
>  }
>  
> -/* not yet implemented */
>  void vgic_v2_enable(struct kvm_vcpu *vcpu)
>  {
> +	/*
> +	 * By forcing VMCR to zero, the GIC will restore the binary
> +	 * points to their reset values. Anything else resets to zero
> +	 * anyway.
> +	 */
> +	vcpu->arch.vgic_cpu.vgic_v2.vgic_vmcr = 0;
> +	vcpu->arch.vgic_cpu.vgic_v2.vgic_elrsr = ~0;
> +
> +	/* Get the show on the road... */
> +	vcpu->arch.vgic_cpu.vgic_v2.vgic_hcr = GICH_HCR_EN;
>  }
>  
>  int vgic_v2_map_resources(struct kvm *kvm)
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 4bfd42a..6d7422f 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -195,9 +195,30 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
>  	vmcrp->pmr  = (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
>  }
>  
> -/* not yet implemented */
>  void vgic_v3_enable(struct kvm_vcpu *vcpu)
>  {
> +	struct vgic_v3_cpu_if *vgic_v3 = &vcpu->arch.vgic_cpu.vgic_v3;
> +
> +	/*
> +	 * By forcing VMCR to zero, the GIC will restore the binary
> +	 * points to their reset values. Anything else resets to zero
> +	 * anyway.
> +	 */
> +	vgic_v3->vgic_vmcr = 0;
> +	vgic_v3->vgic_elrsr = ~0;
> +
> +	/*
> +	 * If we are emulating a GICv3, we do it in an non-GICv2-compatible
> +	 * way, so we force SRE to 1 to demonstrate this to the guest.
> +	 * This goes with the spec allowing the value to be RAO/WI.
> +	 */
> +	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
> +		vgic_v3->vgic_sre = ICC_SRE_EL1_SRE;
> +	else
> +		vgic_v3->vgic_sre = 0;
> +
> +	/* Get the show on the road... */
> +	vgic_v3->vgic_hcr = ICH_HCR_EN;
>  }
>  
>  int vgic_v3_map_resources(struct kvm *kvm)
> -- 
> 2.7.3
> 

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
