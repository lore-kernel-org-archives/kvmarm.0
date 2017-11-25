From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH 08/37] KVM: arm64: Defer restoring host VFP state to
 vcpu_put
Date: Sat, 25 Nov 2017 10:52:21 +0300
Message-ID: <20171125075221.oj5euwo7hnktxxsj@yury-thinkpad>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-9-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171012104141.26902-9-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On Thu, Oct 12, 2017 at 12:41:12PM +0200, Christoffer Dall wrote:
> Avoid saving the guest VFP registers and restoring the host VFP
> registers on every exit from the VM.  Only when we're about to run
> userspace or other threads in the kernel do we really have to switch the
> state back to the host state.
> 
> We still initially configure the VFP registers to trap when entering the
> VM, but the difference is that we now leave the guest state in the
> hardware registers while running the VM.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h |  5 ++++
>  arch/arm64/include/asm/kvm_host.h    |  3 +++
>  arch/arm64/kernel/asm-offsets.c      |  1 +
>  arch/arm64/kvm/hyp/entry.S           |  3 +++
>  arch/arm64/kvm/hyp/switch.c          | 47 +++++++++++-------------------------
>  arch/arm64/kvm/hyp/sysreg-sr.c       | 21 +++++++++++++---
>  6 files changed, 44 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 1fbfe96..630dd60 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -56,6 +56,11 @@ static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
>  	return (unsigned long *)&vcpu->arch.hcr_el2;
>  }
>  
> +static inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
> +{
> +	return (!(vcpu->arch.hcr_el2 & HCR_RW));
> +}
> +
>  static inline unsigned long *vcpu_pc(const struct kvm_vcpu *vcpu)
>  {
>  	return (unsigned long *)&vcpu_gp_regs(vcpu)->regs.pc;
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 7d3bfa7..5e09eb9 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -210,6 +210,9 @@ struct kvm_vcpu_arch {
>  	/* Guest debug state */
>  	u64 debug_flags;
>  
> +	/* 1 if the guest VFP state is loaded into the hardware */
> +	u64 guest_vfp_loaded;

May it be just u8/bool?

Yury

> +
>  	/*
>  	 * We maintain more than a single set of debug registers to support
>  	 * debugging the guest from the host and to maintain separate host and
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> index 612021d..9946732 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -133,6 +133,7 @@ int main(void)
>    DEFINE(CPU_GP_REGS,		offsetof(struct kvm_cpu_context, gp_regs));
>    DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_regs, regs));
>    DEFINE(CPU_FP_REGS,		offsetof(struct kvm_regs, fp_regs));
> +  DEFINE(VCPU_GUEST_VFP_LOADED,	offsetof(struct kvm_vcpu, arch.guest_vfp_loaded));
>    DEFINE(VCPU_FPEXC32_EL2,	offsetof(struct kvm_vcpu, arch.ctxt.sys_regs[FPEXC32_EL2]));
>    DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
>    DEFINE(HOST_CONTEXT_VCPU,	offsetof(struct kvm_cpu_context, __hyp_running_vcpu));
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index 76cd48f..b3e7191 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -185,6 +185,9 @@ alternative_endif
>  	add	x0, x2, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
>  	bl	__fpsimd_restore_state
>  
> +	mov	x0, #1
> +	str	x0, [x3, #VCPU_GUEST_VFP_LOADED]
> +
>  	// Skip restoring fpexc32 for AArch64 guests
>  	mrs	x1, hcr_el2
>  	tbnz	x1, #HCR_RW_SHIFT, 1f
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 7703d63..ef05c59 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -23,43 +23,31 @@
>  #include <asm/kvm_hyp.h>
>  #include <asm/fpsimd.h>
>  
> -static bool __hyp_text __fpsimd_enabled_nvhe(void)
> -{
> -	return !(read_sysreg(cptr_el2) & CPTR_EL2_TFP);
> -}
> -
> -static bool __hyp_text __fpsimd_enabled_vhe(void)
> -{
> -	return !!(read_sysreg(cpacr_el1) & CPACR_EL1_FPEN);
> -}
> -
> -static hyp_alternate_select(__fpsimd_is_enabled,
> -			    __fpsimd_enabled_nvhe, __fpsimd_enabled_vhe,
> -			    ARM64_HAS_VIRT_HOST_EXTN);
> -
> -bool __hyp_text __fpsimd_enabled(void)
> -{
> -	return __fpsimd_is_enabled()();
> -}
> -
> -static void __hyp_text __activate_traps_vhe(void)
> +static void __hyp_text __activate_traps_vhe(struct kvm_vcpu *vcpu)
>  {
>  	u64 val;
>  
>  	val = read_sysreg(cpacr_el1);
>  	val |= CPACR_EL1_TTA;
> -	val &= ~CPACR_EL1_FPEN;
> +	if (vcpu->arch.guest_vfp_loaded)
> +		val |= CPACR_EL1_FPEN;
> +	else
> +		val &= ~CPACR_EL1_FPEN;
>  	write_sysreg(val, cpacr_el1);
>  
>  	write_sysreg(__kvm_hyp_vector, vbar_el1);
>  }
>  
> -static void __hyp_text __activate_traps_nvhe(void)
> +static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
>  {
>  	u64 val;
>  
>  	val = CPTR_EL2_DEFAULT;
> -	val |= CPTR_EL2_TTA | CPTR_EL2_TFP;
> +	val |= CPTR_EL2_TTA;
> +	if (vcpu->arch.guest_vfp_loaded)
> +		val &= ~CPTR_EL2_TFP;
> +	else
> +		val |= CPTR_EL2_TFP;
>  	write_sysreg(val, cptr_el2);
>  }
>  
> @@ -81,7 +69,8 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
>  	 * it will cause an exception.
>  	 */
>  	val = vcpu->arch.hcr_el2;
> -	if (!(val & HCR_RW) && system_supports_fpsimd()) {
> +	if (vcpu_el1_is_32bit(vcpu) && system_supports_fpsimd() &&
> +	    !vcpu->arch.guest_vfp_loaded) {
>  		write_sysreg(1 << 30, fpexc32_el2);
>  		isb();
>  	}
> @@ -97,7 +86,7 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
>  	write_sysreg(0, pmselr_el0);
>  	write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
>  	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
> -	__activate_traps_arch()();
> +	__activate_traps_arch()(vcpu);
>  }
>  
>  static void __hyp_text __deactivate_traps_vhe(void)
> @@ -273,7 +262,6 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpu_context *host_ctxt;
>  	struct kvm_cpu_context *guest_ctxt;
> -	bool fp_enabled;
>  	u64 exit_code;
>  
>  	vcpu = kern_hyp_va(vcpu);
> @@ -355,8 +343,6 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  		/* 0 falls through to be handled out of EL2 */
>  	}
>  
> -	fp_enabled = __fpsimd_enabled();
> -
>  	__sysreg_save_guest_state(guest_ctxt);
>  	__sysreg32_save_state(vcpu);
>  	__timer_disable_traps(vcpu);
> @@ -367,11 +353,6 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  
>  	__sysreg_restore_host_state(host_ctxt);
>  
> -	if (fp_enabled) {
> -		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
> -		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
> -	}
> -
>  	__debug_save_state(vcpu, kern_hyp_va(vcpu->arch.debug_ptr), guest_ctxt);
>  	/*
>  	 * This must come after restoring the host sysregs, since a non-VHE
> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index b7438c8..c4a3714 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> @@ -19,6 +19,7 @@
>  #include <linux/kvm_host.h>
>  
>  #include <asm/kvm_asm.h>
> +#include <asm/kvm_emulate.h>
>  #include <asm/kvm_hyp.h>
>  
>  /* Yes, this does nothing, on purpose */
> @@ -137,6 +138,11 @@ void __hyp_text __sysreg_restore_guest_state(struct kvm_cpu_context *ctxt)
>  	__sysreg_restore_common_state(ctxt);
>  }
>  
> +static void __hyp_text __fpsimd32_save_state(struct kvm_cpu_context *ctxt)
> +{
> +	ctxt->sys_regs[FPEXC32_EL2] = read_sysreg(fpexc32_el2);
> +}
> +
>  void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
>  {
>  	u64 *spsr, *sysreg;
> @@ -155,9 +161,6 @@ void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
>  	sysreg[DACR32_EL2] = read_sysreg(dacr32_el2);
>  	sysreg[IFSR32_EL2] = read_sysreg(ifsr32_el2);
>  
> -	if (__fpsimd_enabled())
> -		sysreg[FPEXC32_EL2] = read_sysreg(fpexc32_el2);
> -
>  	if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
>  		sysreg[DBGVCR32_EL2] = read_sysreg(dbgvcr32_el2);
>  }
> @@ -209,4 +212,16 @@ void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
>   */
>  void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_cpu_context *host_ctxt = vcpu->arch.host_cpu_context;
> +	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
> +
> +	/* Restore host FP/SIMD state */
> +	if (vcpu->arch.guest_vfp_loaded) {
> +		if (vcpu_el1_is_32bit(vcpu))
> +			kvm_call_hyp(__fpsimd32_save_state,
> +				     kern_hyp_va(guest_ctxt));
> +		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
> +		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
> +		vcpu->arch.guest_vfp_loaded = 0;
> +	}
>  }
> -- 
> 2.9.0
