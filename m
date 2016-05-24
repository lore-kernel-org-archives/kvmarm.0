From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 7/7] arm64: KVM: vgic-v3: Relax synchronization when
 SRE==1
Date: Tue, 24 May 2016 14:52:33 +0200
Message-ID: <20160524125233.GG3582@cbox>
References: <1464007023-11736-1-git-send-email-marc.zyngier@arm.com>
 <1464007023-11736-8-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1464007023-11736-8-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 23, 2016 at 01:37:03PM +0100, Marc Zyngier wrote:
> The GICv3 backend of the vgic is quite barrier heavy, in order
> to ensure synchronization of the system registers and the
> memory mapped view for a potential GICv2 guest.
> 
> But when the guest is using a GICv3 model, there is absolutely
> no need to execute all these heavy barriers, and it is actually
> beneficial to avoid them altogether.
> 
> This patch makes the synchonization conditional, and ensures
> that we do not change the EL1 SRE settings if we do not need to.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> index 40c3b4c..5f8f80b 100644
> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -169,7 +169,8 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
>  	 * Make sure stores to the GIC via the memory mapped interface
>  	 * are now visible to the system register interface.
>  	 */
> -	dsb(st);
> +	if (!cpu_if->vgic_sre)
> +		dsb(st);
>  
>  	cpu_if->vgic_vmcr  = read_gicreg(ICH_VMCR_EL2);
>  
> @@ -235,8 +236,12 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
>  
>  	val = read_gicreg(ICC_SRE_EL2);
>  	write_gicreg(val | ICC_SRE_EL2_ENABLE, ICC_SRE_EL2);
> -	isb(); /* Make sure ENABLE is set at EL2 before setting SRE at EL1 */
> -	write_gicreg(1, ICC_SRE_EL1);
> +
> +	if (!cpu_if->vgic_sre) {
> +		/* Make sure ENABLE is set at EL2 before setting SRE at EL1 */
> +		isb();
> +		write_gicreg(1, ICC_SRE_EL1);

why the change in behavior to only write 1 to the register when
(!cpu_if->vgic_sre) ?

> +	}
>  }
>  
>  void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
> @@ -255,8 +260,10 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
>  	 * been actually programmed with the value we want before
>  	 * starting to mess with the rest of the GIC.
>  	 */
> -	write_gicreg(cpu_if->vgic_sre, ICC_SRE_EL1);
> -	isb();
> +	if (!cpu_if->vgic_sre) {
> +		write_gicreg(0, ICC_SRE_EL1);
> +		isb();
> +	}
>  
>  	val = read_gicreg(ICH_VTR_EL2);
>  	max_lr_idx = vtr_to_max_lr_idx(val);
> @@ -305,8 +312,10 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
>  	 * (re)distributors. This ensure the guest will read the
>  	 * correct values from the memory-mapped interface.
>  	 */
> -	isb();
> -	dsb(sy);
> +	if (!cpu_if->vgic_sre) {
> +		isb();
> +		dsb(sy);
> +	}
>  	vcpu->arch.vgic_cpu.live_lrs = live_lrs;
>  
>  	/*
> -- 
> 2.1.4
> 
