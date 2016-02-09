From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 19/28] ARM: KVM: Add panic handling code
Date: Tue, 9 Feb 2016 19:45:03 +0100
Message-ID: <20160209184503.GV5171@cbox>
References: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
 <1454583645-10144-20-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454583645-10144-20-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 04, 2016 at 11:00:36AM +0000, Marc Zyngier wrote:
> Instead of spinning forever, let's "properly" handle any unexpected
> exception ("properly" meaning "print a spat on the console and die").
> 
> This has proved useful quite a few times...
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/kvm/hyp/hyp-entry.S | 28 +++++++++++++++++++++-------
>  arch/arm/kvm/hyp/switch.c    | 38 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 59 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm/kvm/hyp/hyp-entry.S b/arch/arm/kvm/hyp/hyp-entry.S
> index 44bc11f..ca412ad 100644
> --- a/arch/arm/kvm/hyp/hyp-entry.S
> +++ b/arch/arm/kvm/hyp/hyp-entry.S
> @@ -75,15 +75,29 @@ __kvm_hyp_vector:
>  
>  .macro invalid_vector label, cause
>  	.align
> -\label:	b	.
> +\label:	mov	r0, #\cause
> +	b	__hyp_panic
>  .endm
>  
> -	invalid_vector	hyp_reset
> -	invalid_vector	hyp_undef
> -	invalid_vector	hyp_svc
> -	invalid_vector	hyp_pabt
> -	invalid_vector	hyp_dabt
> -	invalid_vector	hyp_fiq
> +	invalid_vector	hyp_reset	ARM_EXCEPTION_RESET
> +	invalid_vector	hyp_undef	ARM_EXCEPTION_UNDEFINED
> +	invalid_vector	hyp_svc		ARM_EXCEPTION_SOFTWARE
> +	invalid_vector	hyp_pabt	ARM_EXCEPTION_PREF_ABORT
> +	invalid_vector	hyp_dabt	ARM_EXCEPTION_DATA_ABORT
> +	invalid_vector	hyp_fiq		ARM_EXCEPTION_FIQ
> +
> +ENTRY(__hyp_do_panic)
> +	mrs	lr, cpsr
> +	bic	lr, lr, #MODE_MASK
> +	orr	lr, lr, #SVC_MODE
> +THUMB(	orr	lr, lr, #PSR_T_BIT	)
> +	msr	spsr_cxsf, lr
> +	ldr	lr, =panic
> +	msr	ELR_hyp, lr
> +	ldr	lr, =kvm_call_hyp
> +	clrex
> +	eret
> +ENDPROC(__hyp_do_panic)
>  
>  hyp_hvc:
>  	/*
> diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
> index 8bfd729..67f3944 100644
> --- a/arch/arm/kvm/hyp/switch.c
> +++ b/arch/arm/kvm/hyp/switch.c
> @@ -188,3 +188,41 @@ again:
>  }
>  
>  __alias(__guest_run) int __weak __kvm_vcpu_run(struct kvm_vcpu *vcpu);
> +
> +static const char * const __hyp_panic_string[] = {
> +	[ARM_EXCEPTION_RESET]      = "\nHYP panic: RST?? PC:%08x CPSR:%08x",
> +	[ARM_EXCEPTION_UNDEFINED]  = "\nHYP panic: UNDEF PC:%08x CPSR:%08x",
> +	[ARM_EXCEPTION_SOFTWARE]   = "\nHYP panic: SVC?? PC:%08x CPSR:%08x",
> +	[ARM_EXCEPTION_PREF_ABORT] = "\nHYP panic: PABRT PC:%08x CPSR:%08x",
> +	[ARM_EXCEPTION_DATA_ABORT] = "\nHYP panic: DABRT PC:%08x ADDR:%08x",
> +	[ARM_EXCEPTION_IRQ]        = "\nHYP panic: IRQ?? PC:%08x CPSR:%08x",
> +	[ARM_EXCEPTION_FIQ]        = "\nHYP panic: FIQ?? PC:%08x CPSR:%08x",
> +	[ARM_EXCEPTION_HVC]        = "\nHYP panic: HVC?? PC:%08x CPSR:%08x",

Why the question marks?

> +};
> +
> +void __hyp_text __noreturn __hyp_panic(int cause)
> +{
> +	u32 elr = read_special(ELR_hyp);
> +	u32 val;
> +
> +	if (cause == ARM_EXCEPTION_DATA_ABORT)
> +		val = read_sysreg(HDFAR);
> +	else
> +		val = read_special(SPSR);
> +
> +	if (read_sysreg(VTTBR)) {
> +		struct kvm_vcpu *vcpu;
> +		struct kvm_cpu_context *host_ctxt;
> +
> +		vcpu = (struct kvm_vcpu *)read_sysreg(HTPIDR);
> +		host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> +		__deactivate_traps(vcpu);
> +		__deactivate_vm(vcpu);
> +		__sysreg_restore_state(host_ctxt);
> +	}
> +
> +	/* Call panic for real */
> +	__hyp_do_panic(__hyp_panic_string[cause], elr, val);
> +
> +	unreachable();
> +}
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Otherwise:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
