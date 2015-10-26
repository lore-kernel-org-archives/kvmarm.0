From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 2/2] enable armv8 fp/simd lazy switch
Date: Mon, 26 Oct 2015 15:32:38 +0100
Message-ID: <20151026143238.GB20298@cbox>
References: <1444098794-19244-1-git-send-email-m.smarduch@samsung.com>
 <1444098794-19244-3-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1444098794-19244-3-git-send-email-m.smarduch@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, antonios.motakis@huawei.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 05, 2015 at 07:33:14PM -0700, Mario Smarduch wrote:
> This patch enables arm64 lazy fp/simd switch. Removes the ARM constraint,
> and follows the same approach as armv7 version - found here.
> 
> https://lists.cs.columbia.edu/pipermail/kvmarm/2015-September/016567.html
> 
> To summarize - provided the guest accesses fp/simd unit we limit number
> of fp/simd context switches to two per vCPU execution schedule.
> 
> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
> ---
>  arch/arm/kvm/arm.c               |  2 --
>  arch/arm64/include/asm/kvm_asm.h |  1 +
>  arch/arm64/kvm/hyp.S             | 59 +++++++++++++++++++++++++++-------------
>  3 files changed, 41 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 1b1f9e9..fe609f1 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -112,12 +112,10 @@ void kvm_arch_check_processor_compat(void *rtn)
>   */
>  static void kvm_switch_fp_regs(struct kvm_vcpu *vcpu)
>  {
> -#ifdef CONFIG_ARM
>  	if (vcpu->arch.vfp_lazy == 1) {
>  		kvm_call_hyp(__kvm_restore_host_vfp_state, vcpu);
>  		vcpu->arch.vfp_lazy = 0;
>  	}
> -#endif

I'm assuming you'll rework this like for the 32-bit series to just do
this in EL1, yes?

>  }
>  
>  /**
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 5e37710..83dcac5 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -117,6 +117,7 @@ extern char __kvm_hyp_vector[];
>  extern void __kvm_flush_vm_context(void);
>  extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
>  extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
> +extern void __kvm_restore_host_vfp_state(struct kvm_vcpu *vcpu);
>  
>  extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> index e583613..ea99f66 100644
> --- a/arch/arm64/kvm/hyp.S
> +++ b/arch/arm64/kvm/hyp.S
> @@ -385,14 +385,6 @@
>  	tbz	\tmp, #KVM_ARM64_DEBUG_DIRTY_SHIFT, \target
>  .endm
>  
> -/*
> - * Branch to target if CPTR_EL2.TFP bit is set (VFP/SIMD trapping enabled)
> - */
> -.macro skip_fpsimd_state tmp, target
> -	mrs	\tmp, cptr_el2
> -	tbnz	\tmp, #CPTR_EL2_TFP_SHIFT, \target
> -.endm
> -
>  .macro compute_debug_state target
>  	// Compute debug state: If any of KDE, MDE or KVM_ARM64_DEBUG_DIRTY
>  	// is set, we do a full save/restore cycle and disable trapping.
> @@ -433,10 +425,6 @@
>  	mrs	x5, ifsr32_el2
>  	stp	x4, x5, [x3]
>  
> -	skip_fpsimd_state x8, 2f
> -	mrs	x6, fpexc32_el2
> -	str	x6, [x3, #16]
> -2:
>  	skip_debug_state x8, 1f
>  	mrs	x7, dbgvcr32_el2
>  	str	x7, [x3, #24]
> @@ -481,8 +469,15 @@
>  	isb
>  99:
>  	msr     hcr_el2, x2
> -	mov	x2, #CPTR_EL2_TTA
> +
> +	mov     x2, #0
> +	ldr     w3, [x0, #VCPU_VFP_LAZY]
> +	tbnz    w3, #0, 98f
> +
>  	orr     x2, x2, #CPTR_EL2_TFP
> +98:
> +	orr     x2, x2, #CPTR_EL2_TTA
> +

this can be reworked more simply by using an extra register and leaving
the initial mov x2, #CPTR_EL2_TTA alone and just skip setting the TFP
bit if we've already switched the state.

>  	msr	cptr_el2, x2
>  
>  	mov	x2, #(1 << 15)	// Trap CP15 Cr=15
> @@ -669,14 +664,12 @@ __restore_debug:
>  	ret
>  
>  __save_fpsimd:
> -	skip_fpsimd_state x3, 1f
>  	save_fpsimd
> -1:	ret
> +	ret
>  
>  __restore_fpsimd:
> -	skip_fpsimd_state x3, 1f
>  	restore_fpsimd
> -1:	ret
> +	ret
>  
>  switch_to_guest_fpsimd:
>  	push	x4, lr
> @@ -688,6 +681,9 @@ switch_to_guest_fpsimd:
>  
>  	mrs	x0, tpidr_el2
>  
> +	mov     w2, #1
> +	str     w2, [x0, #VCPU_VFP_LAZY]
> +
>  	ldr	x2, [x0, #VCPU_HOST_CONTEXT]
>  	kern_hyp_va x2
>  	bl __save_fpsimd
> @@ -763,7 +759,6 @@ __kvm_vcpu_return:
>  	add	x2, x0, #VCPU_CONTEXT
>  
>  	save_guest_regs
> -	bl __save_fpsimd
>  	bl __save_sysregs
>  
>  	skip_debug_state x3, 1f
> @@ -784,7 +779,6 @@ __kvm_vcpu_return:
>  	kern_hyp_va x2
>  
>  	bl __restore_sysregs
> -	bl __restore_fpsimd
>  	/* Clear FPSIMD and Trace trapping */
>  	msr     cptr_el2, xzr
>  
> @@ -863,6 +857,33 @@ ENTRY(__kvm_flush_vm_context)
>  	ret
>  ENDPROC(__kvm_flush_vm_context)
>  
> +/**
> + * kvm_switch_fp_regs() - switch guest/host VFP/SIMD registers
> + * @vcpu:      pointer to vcpu structure.
> + *
> + */
> +ENTRY(__kvm_restore_host_vfp_state)
> +	push    x4, lr

even when you move this to el1, I don't think you need to do the
additional store of the registers as this is going to be called from
C-code and you should have plenty of caller-save registers, if I read
the aarch64 PCS correctly.

> +
> +	kern_hyp_va x0
> +	add     x2, x0, #VCPU_CONTEXT
> +
> +	// Load Guest HCR, determine if guest is 32 or 64 bit
> +	ldr     x3, [x0, #VCPU_HCR_EL2]
> +	tbnz    x3, #HCR_RW_SHIFT, 1f
> +	mrs     x4, fpexc32_el2
> +	str     x4, [x2, #CPU_SYSREG_OFFSET(FPEXC32_EL2)]
> +1:
> +	bl __save_fpsimd
> +
> +	ldr     x2, [x0, #VCPU_HOST_CONTEXT]
> +	kern_hyp_va x2
> +	bl __restore_fpsimd
> +
> +	pop     x4, lr
> +	ret
> +ENDPROC(__kvm_restore_host_vfp_state)
> +
>  __kvm_hyp_panic:
>  	// Guess the context by looking at VTTBR:
>  	// If zero, then we're already a host.
> -- 
> 1.9.1
> 

Otherwise this looks reasonably good.


Thanks,
-Christoffer
