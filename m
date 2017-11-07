From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 12/37] KVM: arm64: Factor out fault info population and
 gic workarounds
Date: Tue, 7 Nov 2017 16:12:09 +0100
Message-ID: <20171107151209.zee3ww7mq3xl6f3n@kamzik.brq.redhat.com>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-13-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171012104141.26902-13-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 12, 2017 at 12:41:16PM +0200, Christoffer Dall wrote:
> The current world-switch function has functionality to detect a number
> of cases where we need to fixup some part of the exit condition and
> possibly run the guest again, before having restored the host state.
> 
> This includes populating missing fault info, emulating GICv2 CPU
> interface accesses when mapped at unaligned addresses, and emulating
> the GICv3 CPU interfaceon systems that need that.

interface on
need it.

> 
> As we are about to have an alternative switch function for VHE systems,
> but VHE systems still need the same early fixup logic, factor out this
> logic into a separate function that can be shared by both switch
> functions.
> 
> No functional change.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm64/kvm/hyp/switch.c | 91 ++++++++++++++++++++++++++-------------------
>  1 file changed, 52 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index e270cba..ed30af5 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -258,50 +258,24 @@ static void __hyp_text __skip_instr(struct kvm_vcpu *vcpu)
>  	write_sysreg_el2(*vcpu_pc(vcpu), elr);
>  }
>  
> -int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> +/*
> + * Return true when we were able to fixup the guest exit and should return to
> + * the guest, false when we should restore the host state and return to the
> + * main run loop.
> + */
> +static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
> -	struct kvm_cpu_context *host_ctxt;
> -	struct kvm_cpu_context *guest_ctxt;
> -	u64 exit_code;
> -
> -	vcpu = kern_hyp_va(vcpu);
> -
> -	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> -	host_ctxt->__hyp_running_vcpu = vcpu;
> -	guest_ctxt = &vcpu->arch.ctxt;
> -
> -	__sysreg_save_host_state(host_ctxt);
> -
> -	__activate_traps(vcpu);
> -	__activate_vm(vcpu);
> -
> -	__vgic_restore_state(vcpu);
> -	__timer_enable_traps(vcpu);
> -
> -	/*
> -	 * We must restore the 32-bit state before the sysregs, thanks
> -	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
> -	 */
> -	__sysreg32_restore_state(vcpu);
> -	__sysreg_restore_guest_state(guest_ctxt);
> -	__debug_switch_to_guest(vcpu);
> -
> -	/* Jump in the fire! */
> -again:
> -	exit_code = __guest_enter(vcpu, host_ctxt);
> -	/* And we're baaack! */
> -
>  	/*
>  	 * We're using the raw exception code in order to only process
>  	 * the trap if no SError is pending. We will come back to the
>  	 * same PC once the SError has been injected, and replay the
>  	 * trapping instruction.
>  	 */
> -	if (exit_code == ARM_EXCEPTION_TRAP && !__populate_fault_info(vcpu))
> -		goto again;
> +	if (*exit_code == ARM_EXCEPTION_TRAP && !__populate_fault_info(vcpu))
> +		return true;
>  
>  	if (static_branch_unlikely(&vgic_v2_cpuif_trap) &&
> -	    exit_code == ARM_EXCEPTION_TRAP) {
> +	    *exit_code == ARM_EXCEPTION_TRAP) {
>  		bool valid;
>  
>  		valid = kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_DABT_LOW &&
> @@ -315,13 +289,13 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  
>  			if (ret == 1) {
>  				__skip_instr(vcpu);
> -				goto again;
> +				return true;
>  			}
>  
>  			if (ret == -1) {
>  				/* Promote an illegal access to an SError */
>  				__skip_instr(vcpu);
> -				exit_code = ARM_EXCEPTION_EL1_SERROR;
> +				*exit_code = ARM_EXCEPTION_EL1_SERROR;
>  			}
>  
>  			/* 0 falls through to be handler out of EL2 */
> @@ -329,19 +303,58 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	}
>  
>  	if (static_branch_unlikely(&vgic_v3_cpuif_trap) &&
> -	    exit_code == ARM_EXCEPTION_TRAP &&
> +	    *exit_code == ARM_EXCEPTION_TRAP &&
>  	    (kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_SYS64 ||
>  	     kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_CP15_32)) {
>  		int ret = __vgic_v3_perform_cpuif_access(vcpu);
>  
>  		if (ret == 1) {
>  			__skip_instr(vcpu);
> -			goto again;
> +			return true;
>  		}
>  
>  		/* 0 falls through to be handled out of EL2 */

I'm not sure the "0 falls through..." comments are as easy to understand
now that we only fall through to a 'return false'. Maybe they should be
modified?

>  	}
>  
> +	return false;
> +}
> +
> +int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_cpu_context *host_ctxt;
> +	struct kvm_cpu_context *guest_ctxt;
> +	u64 exit_code;
> +
> +	vcpu = kern_hyp_va(vcpu);
> +
> +	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> +	host_ctxt->__hyp_running_vcpu = vcpu;
> +	guest_ctxt = &vcpu->arch.ctxt;
> +
> +	__sysreg_save_host_state(host_ctxt);
> +
> +	__activate_traps(vcpu);
> +	__activate_vm(vcpu);
> +
> +	__vgic_restore_state(vcpu);
> +	__timer_enable_traps(vcpu);
> +
> +	/*
> +	 * We must restore the 32-bit state before the sysregs, thanks
> +	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
> +	 */
> +	__sysreg32_restore_state(vcpu);
> +	__sysreg_restore_guest_state(guest_ctxt);
> +	__debug_switch_to_guest(vcpu);
> +
> +	/* Jump in the fire! */
> +again:
> +	exit_code = __guest_enter(vcpu, host_ctxt);
> +	/* And we're baaack! */
> +
> +	if (fixup_guest_exit(vcpu, &exit_code))
> +		goto again;

We can change this goto to a do-while now.

> +
>  	__sysreg_save_guest_state(guest_ctxt);
>  	__sysreg32_save_state(vcpu);
>  	__timer_disable_traps(vcpu);
> -- 
> 2.9.0
>

Thanks,
drew
