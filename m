From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v6 6/6] arm/arm64: KVM: Enable armv8 fp/simd enhanced
 context switch
Date: Sun, 10 Jan 2016 17:32:23 +0100
Message-ID: <20160110163223.GH30867@cbox>
References: <1451167016-3787-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1451167016-3787-1-git-send-email-m.smarduch@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Dec 26, 2015 at 01:56:56PM -0800, Mario Smarduch wrote:
> Enable armv8 enhanced fp/simd context switch. Guest and host registers are only
> context switched on first access and vcpu put.
> 
> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
> ---
>  arch/arm/kvm/arm.c              | 13 +++++++++++--
>  arch/arm64/kernel/asm-offsets.c |  1 +
>  arch/arm64/kvm/hyp/entry.S      |  1 +
>  arch/arm64/kvm/hyp/switch.c     | 26 ++------------------------
>  4 files changed, 15 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index b16ed98..633a208 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -316,10 +316,19 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  {
>  	/* If the fp/simd registers are dirty save guest, restore host. */
> -	if (vcpu_vfp_isdirty(vcpu))
> +	if (vcpu_vfp_isdirty(vcpu)) {
> +
>  		vcpu_restore_host_vfp_state(vcpu);
>  
> -	/* Restore host FPEXC trashed in vcpu_load */
> +		/*
> +		 * For 32bit guest on arm64 save the guest fpexc register
> +		 * in EL2 mode.
> +		 */
> +		if (vcpu_guest_is_32bit(vcpu))
> +			vcpu_save_fpexc(vcpu);
> +	}
> +
> +	/* For arm32 restore host FPEXC trashed in vcpu_load. */
>  	vcpu_restore_host_fpexc(vcpu);
>  
>  	/*
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> index 94090a6..d69145c 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -112,6 +112,7 @@ int main(void)
>    DEFINE(VCPU_ESR_EL2,		offsetof(struct kvm_vcpu, arch.fault.esr_el2));
>    DEFINE(VCPU_FAR_EL2,		offsetof(struct kvm_vcpu, arch.fault.far_el2));
>    DEFINE(VCPU_HPFAR_EL2,	offsetof(struct kvm_vcpu, arch.fault.hpfar_el2));
> +  DEFINE(VCPU_CPTR_EL2,		offsetof(struct kvm_vcpu, arch.cptr_el2));
>    DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
>  #endif
>  #ifdef CONFIG_CPU_PM
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index fd0fbe9..ce7e903 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -136,6 +136,7 @@ ENTRY(__fpsimd_guest_restore)
>  	isb
>  
>  	mrs	x3, tpidr_el2
> +	str	w2, [x3, #VCPU_CPTR_EL2]

I'm confused here, why do we need to do this now and not in the previous
patch?

Maybe it helps if we merge these last two patches into one.

>  
>  	ldr	x0, [x3, #VCPU_HOST_CONTEXT]
>  	kern_hyp_va x0
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index ca8f5a5..962d179 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -19,24 +19,10 @@
>  
>  static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
>  {
> -	u64 val;
> -
> -	/*
> -	 * We are about to set CPTR_EL2.TFP to trap all floating point
> -	 * register accesses to EL2, however, the ARM ARM clearly states that
> -	 * traps are only taken to EL2 if the operation would not otherwise
> -	 * trap to EL1.  Therefore, always make sure that for 32-bit guests,
> -	 * we set FPEXC.EN to prevent traps to EL1, when setting the TFP bit.
> -	 */
> -	val = vcpu->arch.hcr_el2;
> -	if (!(val & HCR_RW)) {
> -		write_sysreg(1 << 30, fpexc32_el2);
> -		isb();
> -	}
> -	write_sysreg(val, hcr_el2);
> +	write_sysreg(vcpu->arch.hcr_el2, hcr_el2);
>  	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
>  	write_sysreg(1 << 15, hstr_el2);
> -	write_sysreg(CPTR_EL2_TTA | CPTR_EL2_TFP, cptr_el2);
> +	write_sysreg(vcpu->arch.cptr_el2, cptr_el2);
>  	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
>  }
>  
> @@ -89,7 +75,6 @@ static int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpu_context *host_ctxt;
>  	struct kvm_cpu_context *guest_ctxt;
> -	bool fp_enabled;
>  	u64 exit_code;
>  
>  	vcpu = kern_hyp_va(vcpu);
> @@ -119,8 +104,6 @@ static int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
>  	exit_code = __guest_enter(vcpu, host_ctxt);
>  	/* And we're baaack! */
>  
> -	fp_enabled = __fpsimd_enabled();
> -
>  	__sysreg_save_state(guest_ctxt);
>  	__sysreg32_save_state(vcpu);
>  	__timer_save_state(vcpu);
> @@ -131,11 +114,6 @@ static int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
>  
>  	__sysreg_restore_state(host_ctxt);
>  
> -	if (fp_enabled) {
> -		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
> -		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
> -	}
> -

why do we remove this logic here but preserve something in
__sysreg32_save_state() ?



>  	__debug_save_state(vcpu, kern_hyp_va(vcpu->arch.debug_ptr), guest_ctxt);
>  	__debug_cond_restore_host_state(vcpu);
>  
> -- 
> 1.9.1
> 
Thanks,
-Christoffer
