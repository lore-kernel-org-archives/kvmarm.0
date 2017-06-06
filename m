From: Christoffer Dall <cdall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 01/11] KVM: arm64: Store vcpu on the stack during
 __guest_enter()
Date: Tue, 6 Jun 2017 21:59:51 +0200
Message-ID: <20170606195951.GN9464@cbox>
References: <20170515174400.29735-1-james.morse@arm.com>
 <20170515174400.29735-2-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170515174400.29735-2-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 15, 2017 at 06:43:49PM +0100, James Morse wrote:
> KVM uses tpidr_el2 as its private vcpu register, which makes sense for
> non-vhe world switch as only KVM can access this register. This means
> vhe Linux has to use tpidr_el1, which KVM has to save/restore as part
> of the host context.
> 
> __guest_enter() stores the host_ctxt on the stack, do the same with
> the vcpu.
> 
> Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
> ---
>  arch/arm64/kvm/hyp/entry.S     | 12 ++++++++----
>  arch/arm64/kvm/hyp/hyp-entry.S |  6 +++---
>  2 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index 12ee62d6d410..113735df7d01 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -62,8 +62,8 @@ ENTRY(__guest_enter)
>  	// Store the host regs
>  	save_callee_saved_regs x1
>  
> -	// Store the host_ctxt for use at exit time
> -	str	x1, [sp, #-16]!
> +	// Store host_ctxt and vcpu for use at exit time
> +	stp	x1, x0, [sp, #-16]!
>  
>  	add	x18, x0, #VCPU_CONTEXT
>  
> @@ -159,9 +159,15 @@ abort_guest_exit_end:
>  ENDPROC(__guest_exit)
>  
>  ENTRY(__fpsimd_guest_restore)
> +	// x0: esr
> +	// x1: vcpu
> +	// x2-x29,lr: vcpu regs
> +	// vcpu x0-x1 on the stack
>  	stp	x2, x3, [sp, #-16]!
>  	stp	x4, lr, [sp, #-16]!
>  
> +	mov	x3, x1
> +

nit: can you avoid this by using x1 for the vcpu pointer in this routine
instead?

>  alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
>  	mrs	x2, cptr_el2
>  	bic	x2, x2, #CPTR_EL2_TFP
> @@ -173,8 +179,6 @@ alternative_else
>  alternative_endif
>  	isb
>  
> -	mrs	x3, tpidr_el2
> -
>  	ldr	x0, [x3, #VCPU_HOST_CONTEXT]
>  	kern_hyp_va x0
>  	add	x0, x0, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> index 5170ce1021da..fce7cc507e0a 100644
> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> @@ -104,6 +104,7 @@ el1_trap:
>  	/*
>  	 * x0: ESR_EC
>  	 */
> +	ldr	x1, [sp, #16 + 8]	// vcpu stored by __guest_enter
>  
>  	/*
>  	 * We trap the first access to the FP/SIMD to save the host context
> @@ -116,19 +117,18 @@ alternative_if_not ARM64_HAS_NO_FPSIMD
>  	b.eq	__fpsimd_guest_restore
>  alternative_else_nop_endif
>  
> -	mrs	x1, tpidr_el2
>  	mov	x0, #ARM_EXCEPTION_TRAP
>  	b	__guest_exit
>  
>  el1_irq:
>  	stp     x0, x1, [sp, #-16]!
> -	mrs	x1, tpidr_el2
> +	ldr	x1, [sp, #16 + 8]
>  	mov	x0, #ARM_EXCEPTION_IRQ
>  	b	__guest_exit
>  
>  el1_error:
>  	stp     x0, x1, [sp, #-16]!
> -	mrs	x1, tpidr_el2
> +	ldr	x1, [sp, #16 + 8]
>  	mov	x0, #ARM_EXCEPTION_EL1_SERROR
>  	b	__guest_exit
>  
> -- 
> 2.10.1
> 

Otherwise:
Reviewed-by: Christoffer Dall <cdall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
