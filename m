From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 14/41] KVM: arm64: Introduce VHE-specific kvm_vcpu_run
Date: Wed, 24 Jan 2018 16:13:26 +0000
Message-ID: <20180124161323.GE5862@e103592.cambridge.arm.com>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-15-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180112120747.27999-15-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 12, 2018 at 01:07:20PM +0100, Christoffer Dall wrote:
> So far this is just a copy of the legacy non-VHE switch function, but we
> will start reworking these functions in separate directions to work on
> VHE and non-VHE in the most optimal way in later patches.

I'd be concerned that now that these are separate, they will accumulate
pointless forkage over time and become hard to maintain.  Yet they are
supposed to do the same thing to within abstractable details.

To a first approximation, the _vhe() case is the same as _nhve() except
for the omission of those things that are deferred to load()/put().
Doubtless I'm glossing over some tricky details though.

Do you expect more fundamental divergence in the future?

Cheers
---Dave

> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm/include/asm/kvm_asm.h   |  5 +++-
>  arch/arm/kvm/hyp/switch.c        |  2 +-
>  arch/arm64/include/asm/kvm_asm.h |  4 ++-
>  arch/arm64/kvm/hyp/switch.c      | 58 +++++++++++++++++++++++++++++++++++++++-
>  virt/kvm/arm/arm.c               |  5 +++-
>  5 files changed, 69 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
> index 36dd2962a42d..4ac717276543 100644
> --- a/arch/arm/include/asm/kvm_asm.h
> +++ b/arch/arm/include/asm/kvm_asm.h
> @@ -70,7 +70,10 @@ extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
>  
>  extern void __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high);
>  
> -extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
> +/* no VHE on 32-bit :( */
> +static inline int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu) { return 0; }
> +
> +extern int __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu);
>  
>  extern void __init_stage2_translation(void);
>  
> diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
> index c3b9799e2e13..7b2bd25e3b10 100644
> --- a/arch/arm/kvm/hyp/switch.c
> +++ b/arch/arm/kvm/hyp/switch.c
> @@ -153,7 +153,7 @@ static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> -int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> +int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpu_context *host_ctxt;
>  	struct kvm_cpu_context *guest_ctxt;
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 6c7599b5cb40..fb91e728207b 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -58,7 +58,9 @@ extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
>  
>  extern void __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high);
>  
> -extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
> +extern int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu);
> +
> +extern int __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu);
>  
>  extern u64 __vgic_v3_get_ich_vtr_el2(void);
>  extern u64 __vgic_v3_read_vmcr(void);
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 55ca2e3d42eb..accfe9a016f9 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -338,7 +338,63 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	return false;
>  }
>  
> -int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> +/* Switch to the guest for VHE systems running in EL2 */
> +int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
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
> +	do {
> +		/* Jump in the fire! */
> +		exit_code = __guest_enter(vcpu, host_ctxt);
> +
> +		/* And we're baaack! */
> +	} while (fixup_guest_exit(vcpu, &exit_code));
> +
> +	__sysreg_save_guest_state(guest_ctxt);
> +	__sysreg32_save_state(vcpu);
> +	__timer_disable_traps(vcpu);
> +	__vgic_save_state(vcpu);
> +
> +	__deactivate_traps(vcpu);
> +	__deactivate_vm(vcpu);
> +
> +	__sysreg_restore_host_state(host_ctxt);
> +
> +	/*
> +	 * This must come after restoring the host sysregs, since a non-VHE
> +	 * system may enable SPE here and make use of the TTBRs.
> +	 */
> +	__debug_switch_to_host(vcpu);
> +
> +	return exit_code;
> +}
> +
> +/* Switch to the guest for legacy non-VHE systems */
> +int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpu_context *host_ctxt;
>  	struct kvm_cpu_context *guest_ctxt;
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 5b1487bd91e8..6bce8f9c55db 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -733,7 +733,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		trace_kvm_entry(*vcpu_pc(vcpu));
>  		guest_enter_irqoff();
>  
> -		ret = kvm_call_hyp(__kvm_vcpu_run, vcpu);
> +		if (has_vhe())
> +			ret = kvm_vcpu_run_vhe(vcpu);
> +		else
> +			ret = kvm_call_hyp(__kvm_vcpu_run_nvhe, vcpu);
>  
>  		vcpu->mode = OUTSIDE_GUEST_MODE;
>  		vcpu->stat.exits++;
> -- 
> 2.14.2
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
