From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm64: Decode basic HYP fault information
Date: Sun, 30 Aug 2015 19:44:34 +0200
Message-ID: <20150830174434.GG24113@cbox>
References: <00aa01d0d408$1ba96ea0$52fc4be0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <00aa01d0d408$1ba96ea0$52fc4be0$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 11, 2015 at 10:34:07AM +0300, Pavel Fedin wrote:
> Print exception vector name, exception class and PC translated to EL1 virtual
> address. Significantly aids debugging HYP crashes without special means like
> JTAG.

my overall concern with this patch is that it adds complexity to an
already really bad situation, and potentially increases the likelihood
of not seeing any debug info at all.

do you encounter this kind of panic a lot?  I haven't experienced a
great need for more hyp debugging help lately...

> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> ---
>  arch/arm64/kvm/handle_exit.c | 30 +++++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp.S         | 46 +++++++++++++++++---------------------------
>  2 files changed, 48 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 29b184a..4d70d64 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -136,3 +136,33 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		return 0;
>  	}
>  }
> +
> +static const char *const hyp_faults[] = {
> +	"EL2t Synchronous",
> +	"EL2t IRQ",
> +	"EL2t FIQ",
> +	"EL2t Error",
> +	"EL2h Synchronous",
> +	"EL2h IRQ",
> +	"EL2h FIQ",
> +	"EL2h Error",
> +	"EL1 Synchronous",
> +	"EL1 IRQ",
> +	"EL1 FIQ",
> +	"EL1 Error"
> +};
> +
> +void kvm_hyp_panic(unsigned long vector, unsigned int spsr, unsigned long pc,
> +		   unsigned int esr, unsigned long far, unsigned long hpfar,
> +		   unsigned long par, struct kvm_vcpu *vcpu)
> +{
> +	pr_emerg("Unhandled HYP exception %s on VCPU %p\n",
> +		hyp_faults[vector], vcpu);
> +	pr_emerg("PC : %016lx SPSR : %08x         ESR: %08x\n", pc, spsr, esr);
> +	pr_emerg("FAR: %016lx HPFAR: %016lx PAR: %016lx\n", far, hpfar, par);
> +
> +	pr_emerg("Exception class: %02x Translated PC: %016lx\n",
> +		esr >> ESR_ELx_EC_SHIFT, pc - HYP_PAGE_OFFSET + PAGE_OFFSET);
> +
> +	panic("HYP panic");
> +}
> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> index c81eaaf..62785cd 100644
> --- a/arch/arm64/kvm/hyp.S
> +++ b/arch/arm64/kvm/hyp.S
> @@ -1060,13 +1060,11 @@ __kvm_hyp_panic:
>  	ldr	x2, [x0, #VCPU_HOST_CONTEXT]
>  	kern_hyp_va x2
>  
> +	mov	x0, lr
>  	bl __restore_sysregs
> +	mov	lr, x0
>  
> -1:	adr	x0, __hyp_panic_str
> -	adr	x1, 2f
> -	ldp	x2, x3, [x1]
> -	sub	x0, x0, x2
> -	add	x0, x0, x3
> +1:	mov	x0, lr
>  	mrs	x1, spsr_el2
>  	mrs	x2, elr_el2
>  	mrs	x3, esr_el2
> @@ -1078,20 +1076,11 @@ __kvm_hyp_panic:
>  	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
>  		      PSR_MODE_EL1h)
>  	msr	spsr_el2, lr
> -	ldr	lr, =panic
> +	ldr	lr, =kvm_hyp_panic
>  	msr	elr_el2, lr
>  	eret
> -
> -	.align	3
> -2:	.quad	HYP_PAGE_OFFSET
> -	.quad	PAGE_OFFSET

why can you get rid of this?

>  ENDPROC(__kvm_hyp_panic)
>  
> -__hyp_panic_str:
> -	.ascii	"HYP panic:\nPS:%08x PC:%p ESR:%p\nFAR:%p HPFAR:%p PAR:%p\nVCPU:%p\n\0"
> -
> -	.align	2
> -
>  /*
>   * u64 kvm_call_hyp(void *hypfn, ...);
>   *
> @@ -1115,26 +1104,27 @@ ENTRY(kvm_call_hyp)
>  	ret
>  ENDPROC(kvm_call_hyp)
>  
> -.macro invalid_vector	label, target
> +.macro invalid_vector	label, N, target
>  	.align	2
>  \label:
> +	mov lr, #\N
>  	b \target
>  ENDPROC(\label)
>  .endm
>  
>  	/* None of these should ever happen */
> -	invalid_vector	el2t_sync_invalid, __kvm_hyp_panic
> -	invalid_vector	el2t_irq_invalid, __kvm_hyp_panic
> -	invalid_vector	el2t_fiq_invalid, __kvm_hyp_panic
> -	invalid_vector	el2t_error_invalid, __kvm_hyp_panic
> -	invalid_vector	el2h_sync_invalid, __kvm_hyp_panic
> -	invalid_vector	el2h_irq_invalid, __kvm_hyp_panic
> -	invalid_vector	el2h_fiq_invalid, __kvm_hyp_panic
> -	invalid_vector	el2h_error_invalid, __kvm_hyp_panic
> -	invalid_vector	el1_sync_invalid, __kvm_hyp_panic
> -	invalid_vector	el1_irq_invalid, __kvm_hyp_panic
> -	invalid_vector	el1_fiq_invalid, __kvm_hyp_panic
> -	invalid_vector	el1_error_invalid, __kvm_hyp_panic
> +	invalid_vector	el2t_sync_invalid, 0, __kvm_hyp_panic
> +	invalid_vector	el2t_irq_invalid, 1, __kvm_hyp_panic
> +	invalid_vector	el2t_fiq_invalid, 2, __kvm_hyp_panic
> +	invalid_vector	el2t_error_invalid, 3, __kvm_hyp_panic
> +	invalid_vector	el2h_sync_invalid, 4, __kvm_hyp_panic
> +	invalid_vector	el2h_irq_invalid, 5, __kvm_hyp_panic
> +	invalid_vector	el2h_fiq_invalid, 6, __kvm_hyp_panic
> +	invalid_vector	el2h_error_invalid, 7, __kvm_hyp_panic
> +	invalid_vector	el1_sync_invalid, 8, __kvm_hyp_panic
> +	invalid_vector	el1_irq_invalid, 9, __kvm_hyp_panic
> +	invalid_vector	el1_fiq_invalid, 10, __kvm_hyp_panic
> +	invalid_vector	el1_error_invalid, 11, __kvm_hyp_panic
>  
>  el1_sync:					// Guest trapped into EL2
>  	push	x0, x1
> -- 
> 2.4.4
> 
> 
> Kind regards,
> Pavel Fedin
> Expert Engineer
> Samsung Electronics Research center Russia
> 
> 
> 
