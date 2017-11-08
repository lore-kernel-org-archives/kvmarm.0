From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 19/37] KVM: arm64: Introduce separate VHE/non-VHE sysreg
 save/restore functions
Date: Wed, 8 Nov 2017 11:31:56 +0100
Message-ID: <20171108103156.72gynfsuylk65s5a@kamzik.brq.redhat.com>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-20-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171012104141.26902-20-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 12, 2017 at 12:41:23PM +0200, Christoffer Dall wrote:
> As we are about to handle system registers quite differently between VHE
> and non-VHE systems.  In preparation for that, we need to split some of
> the handling functions between VHE and non-VHE functionality.
> 
> For now, we simply copy the non-VHE functions, but we do change the use
> of static keys for VHE and non-VHE functionality now that we have
> separate functions.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm64/include/asm/kvm_hyp.h | 12 ++++++++----
>  arch/arm64/kvm/hyp/switch.c      | 20 ++++++++++----------
>  arch/arm64/kvm/hyp/sysreg-sr.c   | 40 ++++++++++++++++++++++++++++++++--------
>  3 files changed, 50 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index a0e5a70..998152d 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -132,10 +132,14 @@ int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
>  void __timer_enable_traps(struct kvm_vcpu *vcpu);
>  void __timer_disable_traps(struct kvm_vcpu *vcpu);
>  
> -void __sysreg_save_host_state(struct kvm_cpu_context *ctxt);
> -void __sysreg_restore_host_state(struct kvm_cpu_context *ctxt);
> -void __sysreg_save_guest_state(struct kvm_cpu_context *ctxt);
> -void __sysreg_restore_guest_state(struct kvm_cpu_context *ctxt);
> +void __sysreg_save_host_state_nvhe(struct kvm_cpu_context *ctxt);
> +void __sysreg_restore_host_state_nvhe(struct kvm_cpu_context *ctxt);
> +void __sysreg_save_guest_state_nvhe(struct kvm_cpu_context *ctxt);
> +void __sysreg_restore_guest_state_nvhe(struct kvm_cpu_context *ctxt);
> +void sysreg_save_host_state_vhe(struct kvm_cpu_context *ctxt);
> +void sysreg_restore_host_state_vhe(struct kvm_cpu_context *ctxt);
> +void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt);
> +void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt);
>  void __sysreg32_save_state(struct kvm_vcpu *vcpu);
>  void __sysreg32_restore_state(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index b98b73b..7c4d430 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -330,7 +330,7 @@ int kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	host_ctxt->__hyp_running_vcpu = vcpu;
>  	guest_ctxt = &vcpu->arch.ctxt;
>  
> -	__sysreg_save_host_state(host_ctxt);
> +	sysreg_save_host_state_vhe(host_ctxt);
>  
>  	__activate_traps(vcpu);
>  	__activate_vm(vcpu);
> @@ -342,7 +342,7 @@ int kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
>  	 */
>  	__sysreg32_restore_state(vcpu);
> -	__sysreg_restore_guest_state(guest_ctxt);
> +	sysreg_restore_guest_state_vhe(guest_ctxt);
>  	__debug_switch_to_guest(vcpu);
>  
>  	/* Jump in the fire! */
> @@ -353,13 +353,13 @@ int kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	if (fixup_guest_exit(vcpu, &exit_code))
>  		goto again;
>  
> -	__sysreg_save_guest_state(guest_ctxt);
> +	sysreg_save_guest_state_vhe(guest_ctxt);
>  	__sysreg32_save_state(vcpu);
>  	__vgic_save_state(vcpu);
>  
>  	__deactivate_traps(vcpu);
>  
> -	__sysreg_restore_host_state(host_ctxt);
> +	sysreg_restore_host_state_vhe(host_ctxt);
>  
>  	/*
>  	 * This must come after restoring the host sysregs, since a non-VHE

This comment is a carry over from the non-VHE function. It's a bit
confusing in a VHE-only function, so it should probably be removed,
perhaps with its own patch though.


> @@ -383,7 +383,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	host_ctxt->__hyp_running_vcpu = vcpu;
>  	guest_ctxt = &vcpu->arch.ctxt;
>  
> -	__sysreg_save_host_state(host_ctxt);
> +	__sysreg_save_host_state_nvhe(host_ctxt);
>  
>  	__activate_traps(vcpu);
>  	__activate_vm(vcpu);
> @@ -396,7 +396,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
>  	 */
>  	__sysreg32_restore_state(vcpu);
> -	__sysreg_restore_guest_state(guest_ctxt);
> +	__sysreg_restore_guest_state_nvhe(guest_ctxt);
>  	__debug_switch_to_guest(vcpu);
>  
>  	/* Jump in the fire! */
> @@ -407,7 +407,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	if (fixup_guest_exit(vcpu, &exit_code))
>  		goto again;
>  
> -	__sysreg_save_guest_state(guest_ctxt);
> +	__sysreg_save_guest_state_nvhe(guest_ctxt);
>  	__sysreg32_save_state(vcpu);
>  	__timer_disable_traps(vcpu);
>  	__vgic_save_state(vcpu);
> @@ -415,7 +415,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	__deactivate_traps(vcpu);
>  	__deactivate_vm(vcpu);
>  
> -	__sysreg_restore_host_state(host_ctxt);
> +	__sysreg_restore_host_state_nvhe(host_ctxt);
>  
>  	/*
>  	 * This must come after restoring the host sysregs, since a non-VHE
> @@ -440,7 +440,7 @@ static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
>  		__timer_disable_traps(vcpu);
>  		__deactivate_traps(vcpu);
>  		__deactivate_vm(vcpu);
> -		__sysreg_restore_host_state(__host_ctxt);
> +		__sysreg_restore_host_state_nvhe(__host_ctxt);
>  	}
>  
>  	/*
> @@ -463,7 +463,7 @@ static void __hyp_call_panic_vhe(u64 spsr, u64 elr, u64 par,
>  	vcpu = host_ctxt->__hyp_running_vcpu;
>  
>  	__deactivate_traps_vhe();
> -	__sysreg_restore_host_state(host_ctxt);
> +	sysreg_restore_host_state_vhe(host_ctxt);
>  
>  	panic(__hyp_panic_string,
>  	      spsr,  elr,
> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index b55c4ad..d8c42de 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> @@ -70,15 +70,27 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>  	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(spsr);
>  }
>  
> -void __hyp_text __sysreg_save_host_state(struct kvm_cpu_context *ctxt)
> +void __hyp_text __sysreg_save_host_state_nvhe(struct kvm_cpu_context *ctxt)
> +{
> +	__sysreg_save_el1_state(ctxt);
> +	__sysreg_save_common_state(ctxt);
> +	__sysreg_save_user_state(ctxt);
> +}
> +
> +void __hyp_text __sysreg_save_guest_state_nvhe(struct kvm_cpu_context *ctxt)
> +{
> +	__sysreg_save_el1_state(ctxt);
> +	__sysreg_save_common_state(ctxt);
> +	__sysreg_save_user_state(ctxt);
> +}
> +
> +void sysreg_save_host_state_vhe(struct kvm_cpu_context *ctxt)
>  {
> -	if (!has_vhe())
> -		__sysreg_save_el1_state(ctxt);
>  	__sysreg_save_common_state(ctxt);
>  	__sysreg_save_user_state(ctxt);
>  }
>  
> -void __hyp_text __sysreg_save_guest_state(struct kvm_cpu_context *ctxt)
> +void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt)
>  {
>  	__sysreg_save_el1_state(ctxt);
>  	__sysreg_save_common_state(ctxt);
> @@ -126,15 +138,27 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
>  	write_sysreg_el2(ctxt->gp_regs.regs.pstate,	spsr);
>  }
>  
> -void __hyp_text __sysreg_restore_host_state(struct kvm_cpu_context *ctxt)
> +void __hyp_text __sysreg_restore_host_state_nvhe(struct kvm_cpu_context *ctxt)
> +{
> +	__sysreg_restore_el1_state(ctxt);
> +	__sysreg_restore_common_state(ctxt);
> +	__sysreg_restore_user_state(ctxt);
> +}
> +
> +void __hyp_text __sysreg_restore_guest_state_nvhe(struct kvm_cpu_context *ctxt)
> +{
> +	__sysreg_restore_el1_state(ctxt);
> +	__sysreg_restore_common_state(ctxt);
> +	__sysreg_restore_user_state(ctxt);
> +}
> +
> +void sysreg_restore_host_state_vhe(struct kvm_cpu_context *ctxt)
>  {
> -	if (!has_vhe())
> -		__sysreg_restore_el1_state(ctxt);
>  	__sysreg_restore_common_state(ctxt);
>  	__sysreg_restore_user_state(ctxt);
>  }
>  
> -void __hyp_text __sysreg_restore_guest_state(struct kvm_cpu_context *ctxt)
> +void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt)
>  {
>  	__sysreg_restore_el1_state(ctxt);
>  	__sysreg_restore_common_state(ctxt);
> -- 
> 2.9.0
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
