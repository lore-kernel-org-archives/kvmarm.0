From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 1/2] KVM: arm/arm64: vgic-v3: De-optimize VMCR
 save/restore when emulating a GICv2
Date: Wed, 19 Apr 2017 12:08:09 +0200
Message-ID: <20170419100809.GA4104@cbox>
References: <20170410091944.19963-1-marc.zyngier@arm.com>
 <20170410091944.19963-2-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170410091944.19963-2-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 10, 2017 at 10:19:43AM +0100, Marc Zyngier wrote:
> When emulating a GICv2-on-GICv3, special care must be taken to only
> save/restore VMCR_EL2 when ICC_SRE_EL1.SRE is cleared. Otherwise,
> all Group-0 interrupts end-up being delivered as FIQ, which is
> probably not what the guest expects, as demonstrated here with
> an unhappy EFI:
> 
> 	FIQ Exception at 0x000000013BD21CC4
> 
> This means that we cannot perform the load/put trick when dealing
> with VMCR_EL2 (because the host has SRE set), and we have to deal
> with it in the world-switch.
> 
> Fortunately, this is not the most common case (modern guests should
> be able to deal with GICv3 directly), and the performance is not worse
> than what it was before the VMCR optimization.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/hyp/vgic-v3-sr.c |  8 ++++++--
>  virt/kvm/arm/vgic/vgic.c      | 26 ++++++++++++++++++++------
>  2 files changed, 26 insertions(+), 8 deletions(-)
> 
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index 3d0b1ddb6929..91922c1eddc8 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -128,8 +128,10 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
>  	 * Make sure stores to the GIC via the memory mapped interface
>  	 * are now visible to the system register interface.
>  	 */
> -	if (!cpu_if->vgic_sre)
> +	if (!cpu_if->vgic_sre) {
>  		dsb(st);
> +		cpu_if->vgic_vmcr = read_gicreg(ICH_VMCR_EL2);
> +	}
>  
>  	if (used_lrs) {
>  		int i;
> @@ -205,11 +207,13 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
>  	 * delivered as a FIQ to the guest, with potentially fatal
>  	 * consequences. So we must make sure that ICC_SRE_EL1 has
>  	 * been actually programmed with the value we want before
> -	 * starting to mess with the rest of the GIC.
> +	 * starting to mess with the rest of the GIC, and VMCR_EL2 in
> +	 * particular.
>  	 */
>  	if (!cpu_if->vgic_sre) {
>  		write_gicreg(0, ICC_SRE_EL1);
>  		isb();
> +		write_gicreg(cpu_if->vgic_vmcr, ICH_VMCR_EL2);
>  	}
>  
>  	val = read_gicreg(ICH_VTR_EL2);
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 3d0979c30721..32205f2ba6ff 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -667,10 +667,20 @@ void kvm_vgic_load(struct kvm_vcpu *vcpu)
>  	if (unlikely(!vgic_initialized(vcpu->kvm)))
>  		return;
>  
> -	if (kvm_vgic_global_state.type == VGIC_V2)
> +	if (kvm_vgic_global_state.type == VGIC_V2) {
>  		vgic_v2_load(vcpu);
> -	else
> -		vgic_v3_load(vcpu);
> +	} else {
> +		struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
> +
> +		/*
> +		 * If dealing with a GICv2 emulation on GICv3,
> +		 * VMCR_EL2.VFIQen is dependent on ICC_SRE_EL1.SRE,
> +		 * and we have to perform the VMCR_EL2 save/restore in
> +		 * the world switch.
> +		 */
> +		if (likely(cpu_if->vgic_sre))
> +			vgic_v3_load(vcpu);

I wonder if this conditional should really be inside vgic_v3_load
instead?

> +	}
>  }
>  
>  void kvm_vgic_put(struct kvm_vcpu *vcpu)
> @@ -678,10 +688,14 @@ void kvm_vgic_put(struct kvm_vcpu *vcpu)
>  	if (unlikely(!vgic_initialized(vcpu->kvm)))
>  		return;
>  
> -	if (kvm_vgic_global_state.type == VGIC_V2)
> +	if (kvm_vgic_global_state.type == VGIC_V2) {
>  		vgic_v2_put(vcpu);
> -	else
> -		vgic_v3_put(vcpu);
> +	} else {
> +		struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
> +
> +		if (likely(cpu_if->vgic_sre))
> +			vgic_v3_put(vcpu);

And same here?

> +	}
>  }
>  
>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
> -- 
> 2.11.0
> 

Otherwise looks good.

Thanks,
-Christoffer
