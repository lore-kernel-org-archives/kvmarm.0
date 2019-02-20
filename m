From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v5 14/26] KVM: arm64/sve: Context switch the SVE registers
Date: Wed, 20 Feb 2019 16:46:57 +0000
Message-ID: <83fa5587-24a0-5bbb-c113-cddc74571ea2@arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-15-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77CBF4A2F8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Feb 2019 11:47:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WIhNmgVlU3x5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Feb 2019 11:47:05 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D70B34A2AC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Feb 2019 11:47:04 -0500 (EST)
In-Reply-To: <1550519559-15915-15-git-send-email-Dave.Martin@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 18/02/2019 19:52, Dave Martin wrote:
> In order to give each vcpu its own view of the SVE registers, this
> patch adds context storage via a new sve_state pointer in struct
> vcpu_arch.  An additional member sve_max_vl is also added for each
> vcpu, to determine the maximum vector length visible to the guest
> and thus the value to be configured in ZCR_EL2.LEN while the is

"While the <guest> is active"?

> active.  This also determines the layout and size of the storage in
> sve_state, which is read and written by the same backend functions
> that are used for context-switching the SVE state for host tasks.
> 
> On SVE-enabled vcpus, SVE access traps are now handled by switching
> in the vcpu's SVE context and disabling the trap before returning
> to the guest.  On other vcpus, the trap is not handled and an exit
> back to the host occurs, where the handle_sve() fallback path
> reflects an undefined instruction exception back to the guest,
> consistently with the behaviour of non-SVE-capable hardware (as was
> done unconditionally prior to this patch).
> 
> No SVE handling is added on non-VHE-only paths, since VHE is an
> architectural and Kconfig prerequisite of SVE.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> 

Otherwise:

Reviewed-by: Julien Thierry <julien.thierry@arm.com>

> ---
> 
> Changes since v4:
> 
>  * Remove if_sve() helper in favour of open-coded static key checks.
> 
>  * Explicitly merge static key checks and other condition checks to
>    reduce overhead and maximise const-folding and specialisation
>    opportunities in the compiler.
> ---
>  arch/arm64/include/asm/kvm_host.h |  6 ++++
>  arch/arm64/kvm/fpsimd.c           |  5 +--
>  arch/arm64/kvm/hyp/switch.c       | 70 +++++++++++++++++++++++++++++----------
>  3 files changed, 61 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index c32f195..77b6f3e 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -212,6 +212,8 @@ typedef struct kvm_cpu_context kvm_cpu_context_t;
>  
>  struct kvm_vcpu_arch {
>  	struct kvm_cpu_context ctxt;
> +	void *sve_state;
> +	unsigned int sve_max_vl;
>  
>  	/* HYP configuration */
>  	u64 hcr_el2;
> @@ -304,6 +306,10 @@ struct kvm_vcpu_arch {
>  	bool sysregs_loaded_on_cpu;
>  };
>  
> +/* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> +#define vcpu_sve_pffr(vcpu) ((void *)((char *)((vcpu)->arch.sve_state) + \
> +				      sve_ffr_offset((vcpu)->arch.sve_max_vl)))
> +
>  /* vcpu_arch flags field values: */
>  #define KVM_ARM64_DEBUG_DIRTY		(1 << 0)
>  #define KVM_ARM64_FP_ENABLED		(1 << 1) /* guest FP regs loaded */
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 7053bf4..6e3c9c8 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -87,10 +87,11 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
>  
>  	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
>  		fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.gp_regs.fp_regs,
> -					 NULL, SVE_VL_MIN);
> +					 vcpu->arch.sve_state,
> +					 vcpu->arch.sve_max_vl);
>  
>  		clear_thread_flag(TIF_FOREIGN_FPSTATE);
> -		clear_thread_flag(TIF_SVE);
> +		update_thread_flag(TIF_SVE, vcpu_has_sve(vcpu));
>  	}
>  }
>  
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 9f07403..cdc9063 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -98,7 +98,10 @@ static void activate_traps_vhe(struct kvm_vcpu *vcpu)
>  	val = read_sysreg(cpacr_el1);
>  	val |= CPACR_EL1_TTA;
>  	val &= ~CPACR_EL1_ZEN;
> -	if (!update_fp_enabled(vcpu)) {
> +	if (update_fp_enabled(vcpu)) {
> +		if (vcpu_has_sve(vcpu))
> +			val |= CPACR_EL1_ZEN;
> +	} else {
>  		val &= ~CPACR_EL1_FPEN;
>  		__activate_traps_fpsimd32(vcpu);
>  	}
> @@ -313,16 +316,43 @@ static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> -static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
> +/* Check for an FPSIMD/SVE trap and handle as appropriate */
> +static bool __hyp_text __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
>  {
> -	struct user_fpsimd_state *host_fpsimd = vcpu->arch.host_fpsimd_state;
> +	bool vhe, sve_guest, sve_host;
> +	u8 trap_class;
>  
> -	if (has_vhe())
> -		write_sysreg(read_sysreg(cpacr_el1) | CPACR_EL1_FPEN,
> -			     cpacr_el1);
> -	else
> +	if (!system_supports_fpsimd())
> +		return false;
> +
> +	if (system_supports_sve()) {
> +		sve_guest = vcpu_has_sve(vcpu);
> +		sve_host = vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE;
> +		vhe = true;
> +	} else {
> +		sve_guest = false;
> +		sve_host = false;
> +		vhe = has_vhe();
> +	}
> +
> +	trap_class = kvm_vcpu_trap_get_class(vcpu);
> +	if (trap_class != ESR_ELx_EC_FP_ASIMD &&
> +	    (!sve_guest || trap_class != ESR_ELx_EC_SVE))
> +		return false;
> +
> +	/* The trap is an FPSIMD/SVE trap: switch the context */
> +
> +	if (vhe) {
> +		u64 reg = read_sysreg(cpacr_el1) | CPACR_EL1_FPEN;
> +
> +		if (sve_guest)
> +			reg |= CPACR_EL1_ZEN;
> +
> +		write_sysreg(reg, cpacr_el1);
> +	} else {
>  		write_sysreg(read_sysreg(cptr_el2) & ~(u64)CPTR_EL2_TFP,
>  			     cptr_el2);
> +	}
>  
>  	isb();
>  
> @@ -331,24 +361,28 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
>  		 * In the SVE case, VHE is assumed: it is enforced by
>  		 * Kconfig and kvm_arch_init().
>  		 */
> -		if (system_supports_sve() &&
> -		    (vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE)) {
> +		if (sve_host) {
>  			struct thread_struct *thread = container_of(
> -				host_fpsimd,
> +				vcpu->arch.host_fpsimd_state,
>  				struct thread_struct, uw.fpsimd_state);
>  
> -			sve_save_state(sve_pffr(thread), &host_fpsimd->fpsr);
> +			sve_save_state(sve_pffr(thread),
> +				       &vcpu->arch.host_fpsimd_state->fpsr);
>  		} else {
> -			__fpsimd_save_state(host_fpsimd);
> +			__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
>  		}
>  
>  		vcpu->arch.flags &= ~KVM_ARM64_FP_HOST;
>  	}
>  
> -	__fpsimd_restore_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
> -
> -	if (vcpu_has_sve(vcpu))
> +	if (sve_guest) {
> +		sve_load_state(vcpu_sve_pffr(vcpu),
> +			       &vcpu->arch.ctxt.gp_regs.fp_regs.fpsr,
> +			       sve_vq_from_vl(vcpu->arch.sve_max_vl) - 1);
>  		write_sysreg_s(vcpu->arch.ctxt.sys_regs[ZCR_EL1], SYS_ZCR_EL12);
> +	} else {
> +		__fpsimd_restore_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
> +	}
>  
>  	/* Skip restoring fpexc32 for AArch64 guests */
>  	if (!(read_sysreg(hcr_el2) & HCR_RW))
> @@ -384,10 +418,10 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	 * and restore the guest context lazily.
>  	 * If FP/SIMD is not implemented, handle the trap and inject an
>  	 * undefined instruction exception to the guest.
> +	 * Similarly for trapped SVE accesses.
>  	 */
> -	if (system_supports_fpsimd() &&
> -	    kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_FP_ASIMD)
> -		return __hyp_switch_fpsimd(vcpu);
> +	if (__hyp_handle_fpsimd(vcpu))
> +		return true;
>  
>  	if (!__populate_fault_info(vcpu))
>  		return true;
> 

-- 
Julien Thierry
