From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 12/13] arm64: KVM: Split sysreg save/restore
Date: Mon, 31 Aug 2015 20:49:17 +0200
Message-ID: <20150831184917.GC10991@cbox>
References: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
 <1436372356-30410-13-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436372356-30410-13-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jul 08, 2015 at 05:19:15PM +0100, Marc Zyngier wrote:
> As we're starting to get different requirements for non-VHE and VHE
> code paths, use a slightly more fine-grained approach:
> 
> - __save/restore_sysregs: save/restore non-shared sysregs
> - __save/restore_shared_sysregs: save/restore only shared sysregs
> 
> Of course, non-VHE always requires both.
> 

I'm sorry, I don't really understand what this patch does.

What is a 'shared sysreg' exactly?  One that is shared between the host
and the guest?

Or one that is shared between EL1 and EL2?  Or is that the same thing?

> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp.S | 91 +++++++++++++++++++++++++---------------------------
>  1 file changed, 44 insertions(+), 47 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> index b61591b..3cbd2c4 100644
> --- a/arch/arm64/kvm/hyp.S
> +++ b/arch/arm64/kvm/hyp.S
> @@ -280,11 +280,6 @@ skip_el1_restore:
>  	mrs	x20,	par_el1
>  	mrs	x21,	mdscr_el1
>  
> -	mrs	x22,	tpidr_el0
> -	mrs	x23,	tpidrro_el0
> -	mrs	x24,	tpidr_el1
> -	mrs	x25,	actlr_el1
> -
>  	stp	x4, x5, [x3]
>  	stp	x6, x7, [x3, #16]
>  	stp	x8, x9, [x3, #32]
> @@ -294,8 +289,6 @@ skip_el1_restore:
>  	stp	x16, x17, [x3, #96]
>  	stp	x18, x19, [x3, #112]
>  	stp	x20, x21, [x3, #128]
> -	stp	x22, x23, [x3, #144]
> -	stp	x24, x25, [x3, #160]
>  .endm
>  
>  .macro save_debug
> @@ -508,8 +501,6 @@ skip_el1_restore:
>  	ldp	x16, x17, [x3, #96]
>  	ldp	x18, x19, [x3, #112]
>  	ldp	x20, x21, [x3, #128]
> -	ldp	x22, x23, [x3, #144]
> -	ldp	x24, x25, [x3, #160]
>  
>  	msr	vmpidr_el2,	x4
>  	msr	csselr_el1,	x5
> @@ -529,11 +520,6 @@ skip_el1_restore:
>  	msr_el1(cntkctl,	x19)
>  	msr	par_el1,	x20
>  	msr	mdscr_el1,	x21
> -
> -	msr	tpidr_el0,	x22
> -	msr	tpidrro_el0,	x23
> -	msr	tpidr_el1,	x24
> -	msr	actlr_el1,	x25
>  .endm
>  
>  .macro restore_debug
> @@ -913,10 +899,12 @@ ifnvhe	nop,					"msr	vbar_el1, x2"
>  
>  .macro save_timer_state
>  	// x0: vcpu pointer
> -	ldr	x2, [x0, #VCPU_KVM]
> -	kern_hyp_va x2
> -	ldr	w3, [x2, #KVM_TIMER_ENABLED]
> -	cbz	w3, 1f
> +	// x1: return code
> +	// x2: vcpu context
> +	ldr	x3, [x0, #VCPU_KVM]
> +	kern_hyp_va x3
> +	ldr	w4, [x3, #KVM_TIMER_ENABLED]
> +	cbz	w4, 1f
>  
>  	mrs_el0(x3, cntv_ctl)
>  	and	x3, x3, #3
> @@ -931,9 +919,9 @@ ifnvhe	nop,					"msr	vbar_el1, x2"
>  
>  1:
>  	// Allow physical timer/counter access for the host
> -	mrs	x2, cnthctl_el2
> -	orr	x2, x2, #3
> -	msr	cnthctl_el2, x2
> +	mrs	x3, cnthctl_el2
> +	orr	x3, x3, #3
> +	msr	cnthctl_el2, x3
>  
>  	// Clear cntvoff for the host
>  ifnvhe "msr	cntvoff_el2, xzr",		nop
> @@ -941,34 +929,43 @@ ifnvhe "msr	cntvoff_el2, xzr",		nop
>  
>  .macro restore_timer_state
>  	// x0: vcpu pointer
> +	// x2: vcpu context
>  	// Disallow physical timer access for the guest
>  	// Physical counter access is allowed
> -	mrs	x2, cnthctl_el2
> -	orr	x2, x2, #1
> -	bic	x2, x2, #2
> -	msr	cnthctl_el2, x2
> -
> -	ldr	x2, [x0, #VCPU_KVM]
> -	kern_hyp_va x2
> -	ldr	w3, [x2, #KVM_TIMER_ENABLED]
> -	cbz	w3, 1f
> -
> -	ldr	x3, [x2, #KVM_TIMER_CNTVOFF]
> -	msr	cntvoff_el2, x3
> -	ldr	x2, [x0, #VCPU_TIMER_CNTV_CVAL]
> -	msr_el0(cntv_cval, x2)
> +	mrs	x3, cnthctl_el2
> +	orr	x3, x3, #1
> +	bic	x3, x3, #2
> +	msr	cnthctl_el2, x3
> +
> +	ldr	x3, [x0, #VCPU_KVM]
> +	kern_hyp_va x3
> +	ldr	w4, [x3, #KVM_TIMER_ENABLED]
> +	cbz	w4, 1f
> +
> +	ldr	x4, [x3, #KVM_TIMER_CNTVOFF]
> +	msr	cntvoff_el2, x4
> +	ldr	x4, [x0, #VCPU_TIMER_CNTV_CVAL]
> +	msr_el0(cntv_cval, x4)
>  	isb
>  
> -	ldr	w2, [x0, #VCPU_TIMER_CNTV_CTL]
> -	and	x2, x2, #3
> -	msr_el0(cntv_ctl, x2)
> +	ldr	w4, [x0, #VCPU_TIMER_CNTV_CTL]
> +	and	x4, x4, #3
> +	msr_el0(cntv_ctl, x4)
>  1:
>  .endm
>  
> +__save_shared_sysregs:
> +	save_shared_sysregs
> +	ret
> +
>  __save_sysregs:
>  	save_sysregs
>  	ret
>  
> +__restore_shared_sysregs:
> +	restore_shared_sysregs
> +	ret
> +
>  __restore_sysregs:
>  	restore_sysregs
>  	ret
> @@ -1010,10 +1007,9 @@ ENTRY(__kvm_vcpu_run)
>  
>  	save_host_regs
>  	bl __save_fpsimd
> -ifnvhe "bl	__save_sysregs",		nop
> -ifnvhe "b	1f",				nop
> -	save_shared_sysregs
> -1:
> +ifnvhe "bl	__save_sysregs",		"nop"
> +	bl	__save_shared_sysregs
> +
>  	compute_debug_state 1f
>  	bl	__save_debug
>  1:
> @@ -1027,6 +1023,7 @@ ifnvhe "b	1f",				nop
>  	add	x2, x0, #VCPU_CONTEXT
>  
>  	bl __restore_sysregs
> +	bl __restore_shared_sysregs
>  	bl __restore_fpsimd
>  
>  	skip_debug_state x3, 1f
> @@ -1048,6 +1045,7 @@ __kvm_vcpu_return:
>  	save_guest_regs
>  	bl __save_fpsimd
>  	bl __save_sysregs
> +	bl __save_shared_sysregs
>  
>  	skip_debug_state x3, 1f
>  	bl	__save_debug
> @@ -1064,10 +1062,8 @@ __kvm_vcpu_return:
>  	ldr	x2, [x0, #VCPU_HOST_CONTEXT]
>  	kern_hyp_va x2
>  
> -ifnvhe "bl	__restore_sysregs",		nop
> -ifnvhe "b	1f",				nop
> -	restore_shared_sysregs
> -1:
> +ifnvhe "bl	__restore_sysregs",		"nop"
> +	bl	__restore_shared_sysregs
>  	bl __restore_fpsimd
>  
>  	skip_debug_state x3, 1f
> @@ -1159,7 +1155,8 @@ __kvm_hyp_panic:
>  	ldr	x2, [x0, #VCPU_HOST_CONTEXT]
>  	kern_hyp_va x2
>  
> -	bl __restore_sysregs
> +ifnvhe "bl __restore_sysregs",			"nop"
> +	bl __restore_shared_sysregs
>  
>  1:	adr	x0, __hyp_panic_str
>  	adr	x1, 2f
> -- 
> 2.1.4
> 
