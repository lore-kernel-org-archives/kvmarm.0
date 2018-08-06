From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [RFC PATCH 12/16] KVM: arm64/sve: Context switch the SVE registers
Date: Mon, 6 Aug 2018 15:19:10 +0200
Message-ID: <20180806131910.GC5985@e113682-lin.lund.arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-13-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3485949DA0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Aug 2018 09:19:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CjJGj8sQj6HB for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Aug 2018 09:19:13 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF35D40672
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Aug 2018 09:19:13 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1529593060-542-13-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 21, 2018 at 03:57:36PM +0100, Dave Martin wrote:
> In order to give each vcpu its own view of the SVE registers, this
> patch adds context storage via a new sve_state pointer in struct
> vcpu_arch.  An additional member sve_max_vl is also added for each
> vcpu, to determine the maximum vector length visible to the guest
> and thus the value to be configured in ZCR_EL2.LEN while the is
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
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/kvm/fpsimd.c           |  5 +++--
>  arch/arm64/kvm/hyp/switch.c       | 43 ++++++++++++++++++++++++++++++---------
>  3 files changed, 38 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f331abf..d2084ae 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -211,6 +211,8 @@ typedef struct kvm_cpu_context kvm_cpu_context_t;
>  
>  struct kvm_vcpu_arch {
>  	struct kvm_cpu_context ctxt;
> +	void *sve_state;
> +	unsigned int sve_max_vl;
>  
>  	/* HYP configuration */
>  	u64 hcr_el2;
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 872008c..44cf783 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -86,10 +86,11 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
>  
>  	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
>  		fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.gp_regs.fp_regs,
> -					 NULL, sve_max_vl);
> +					 vcpu->arch.sve_state,
> +					 vcpu->arch.sve_max_vl);
>  
>  		clear_thread_flag(TIF_FOREIGN_FPSTATE);
> -		clear_thread_flag(TIF_SVE);
> +		update_thread_flag(TIF_SVE, vcpu_has_sve(&vcpu->arch));
>  	}
>  }
>  
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index d496ef5..98df5c1 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -98,8 +98,13 @@ static void activate_traps_vhe(struct kvm_vcpu *vcpu)
>  	val = read_sysreg(cpacr_el1);
>  	val |= CPACR_EL1_TTA;
>  	val &= ~CPACR_EL1_ZEN;
> -	if (!update_fp_enabled(vcpu))
> +
> +	if (update_fp_enabled(vcpu)) {
> +		if (vcpu_has_sve(&vcpu->arch))
> +			val |= CPACR_EL1_ZEN;
> +	} else {
>  		val &= ~CPACR_EL1_FPEN;
> +	}
>  
>  	write_sysreg(val, cpacr_el1);
>  
> @@ -114,6 +119,7 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
>  
>  	val = CPTR_EL2_DEFAULT;
>  	val |= CPTR_EL2_TTA | CPTR_EL2_TZ;
> +
>  	if (!update_fp_enabled(vcpu))
>  		val |= CPTR_EL2_TFP;
>  
> @@ -329,16 +335,22 @@ static bool __hyp_text __skip_instr(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> -static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
> +static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu,
> +					   bool guest_has_sve)
>  {
>  	struct user_fpsimd_state *host_fpsimd = vcpu->arch.host_fpsimd_state;
>  
> -	if (has_vhe())
> -		write_sysreg(read_sysreg(cpacr_el1) | CPACR_EL1_FPEN,
> -			     cpacr_el1);
> -	else
> +	if (has_vhe()) {
> +		u64 reg = read_sysreg(cpacr_el1) | CPACR_EL1_FPEN;
> +
> +		if (system_supports_sve() && guest_has_sve)
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
> @@ -361,7 +373,13 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
>  		vcpu->arch.flags &= ~KVM_ARM64_FP_HOST;
>  	}
>  
> -	__fpsimd_restore_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
> +	if (system_supports_sve() && guest_has_sve)
> +		sve_load_state((char *)vcpu->arch.sve_state +
> +					sve_ffr_offset(vcpu->arch.sve_max_vl),

nit: would it make sense to have a macro 'vcpu_get_sve_state_ptr(vcpu)'
to make this first argument more pretty?

> +			       &vcpu->arch.ctxt.gp_regs.fp_regs.fpsr,
> +			       sve_vq_from_vl(vcpu->arch.sve_max_vl) - 1);
> +	else
> +		__fpsimd_restore_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
>  
>  	/* Skip restoring fpexc32 for AArch64 guests */
>  	if (!(read_sysreg(hcr_el2) & HCR_RW))
> @@ -380,6 +398,8 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
>   */
>  static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
> +	bool guest_has_sve;
> +
>  	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
>  		vcpu->arch.fault.esr_el2 = read_sysreg_el2(esr);
>  
> @@ -397,10 +417,13 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	 * and restore the guest context lazily.
>  	 * If FP/SIMD is not implemented, handle the trap and inject an
>  	 * undefined instruction exception to the guest.
> +	 * Similarly for trapped SVE accesses.
>  	 */
> -	if (system_supports_fpsimd() &&
> -	    kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_FP_ASIMD)
> -		return __hyp_switch_fpsimd(vcpu);
> +	guest_has_sve = vcpu_has_sve(&vcpu->arch);
> +	if ((system_supports_fpsimd() &&
> +	     kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_FP_ASIMD) ||
> +	    (guest_has_sve && kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_SVE))

nit: this may also be folded nicely into a static bool
__trap_fpsimd_sve_access() check.

> +		return __hyp_switch_fpsimd(vcpu, guest_has_sve);
>  
>  	if (!__populate_fault_info(vcpu))
>  		return true;
> -- 
> 2.1.4
> 

Thanks,
-Christoffer
