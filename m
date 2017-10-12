From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 01/37] KVM: arm64: Avoid storing the vcpu pointer on the
 stack
Date: Thu, 12 Oct 2017 19:02:16 +0200
Message-ID: <20171012170216.GA26425@cbox>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-2-christoffer.dall@linaro.org>
 <ef4bffe5-b3c5-5fdd-cb8b-1840d2243ae1@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E33749D29
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 13:01:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6ksH8OU6IPRF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Oct 2017 13:01:26 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E7D4B49D25
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 13:01:25 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id b189so14843406wmd.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 10:02:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <ef4bffe5-b3c5-5fdd-cb8b-1840d2243ae1@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Shih-Wei Li <shihwei@cs.columbia.edu>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 12, 2017 at 04:49:44PM +0100, Marc Zyngier wrote:
> On 12/10/17 11:41, Christoffer Dall wrote:
> > We already have the percpu area for the host cpu state, which points to
> > the VCPU, so there's no need to store the VCPU pointer on the stack on
> > every context switch.  We can be a little more clever and just use
> > tpidr_el2 for the percpu offset and load the VCPU pointer from the host
> > context.
> > 
> > This requires us to have a scratch register though, so we take the
> > chance to rearrange some of the el1_sync code to only look at the
> > vttbr_el2 to determine if this is a trap from the guest or an HVC from
> > the host.  We do add an extra check to call the panic code if the kernel
> > is configured with debugging enabled and we saw a trap from the host
> > which wasn't an HVC, indicating that we left some EL2 trap configured by
> > mistake.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  arch/arm64/include/asm/kvm_asm.h | 20 ++++++++++++++++++++
> >  arch/arm64/kernel/asm-offsets.c  |  1 +
> >  arch/arm64/kvm/hyp/entry.S       |  5 +----
> >  arch/arm64/kvm/hyp/hyp-entry.S   | 39 ++++++++++++++++++---------------------
> >  arch/arm64/kvm/hyp/switch.c      |  2 +-
> >  5 files changed, 41 insertions(+), 26 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index ab4d0a9..7e48a39 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -70,4 +70,24 @@ extern u32 __init_stage2_translation(void);
> >  
> >  #endif
> >  
> > +#ifdef __ASSEMBLY__
> > +.macro get_host_ctxt reg, tmp
> > +	/*
> > +	 * '=kvm_host_cpu_state' is a host VA from the constant pool, it may
> > +	 * not be accessible by this address from EL2, hyp_panic() converts
> > +	 * it with kern_hyp_va() before use.
> > +	 */
> 
> This really looks like a stale comment, as there is no hyp_panic
> involved here anymore (thankfully!).
> 

yeah, I suppose.

> > +	ldr	\reg, =kvm_host_cpu_state
> > +	mrs	\tmp, tpidr_el2
> > +	add	\reg, \reg, \tmp
> > +	kern_hyp_va \reg
> 
> Here, we're trading a load from the stack for a load from the constant
> pool. Can't we do something like:
> 
> 	adr_l	\reg, kvm_host_cpu_state
> 	msr	\tmp, tpidr_el2
> 	add	\reg, \reg, \tmp
> 
> and that's it? 

That's definitely what the compiler generates from C code...

> This relies on the property that the kernel/hyp offset is
> constant, and that it doesn't matter if we add the offset to a kernel VA
> or a HYP VA... Completely untested of course!
> 

You're the hyp VA expert.  Is it valid to rely on that assumption?

> > +.endm
> > +
> > +.macro get_vcpu vcpu, ctxt
> > +	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
> > +	kern_hyp_va	\vcpu
> > +.endm
> > +
> > +#endif
> > +
> >  #endif /* __ARM_KVM_ASM_H__ */
> > diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> > index 71bf088..612021d 100644
> > --- a/arch/arm64/kernel/asm-offsets.c
> > +++ b/arch/arm64/kernel/asm-offsets.c
> > @@ -135,6 +135,7 @@ int main(void)
> >    DEFINE(CPU_FP_REGS,		offsetof(struct kvm_regs, fp_regs));
> >    DEFINE(VCPU_FPEXC32_EL2,	offsetof(struct kvm_vcpu, arch.ctxt.sys_regs[FPEXC32_EL2]));
> >    DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
> > +  DEFINE(HOST_CONTEXT_VCPU,	offsetof(struct kvm_cpu_context, __hyp_running_vcpu));
> >  #endif
> >  #ifdef CONFIG_CPU_PM
> >    DEFINE(CPU_SUSPEND_SZ,	sizeof(struct cpu_suspend_ctx));
> > diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> > index 9a8ab5d..76cd48f 100644
> > --- a/arch/arm64/kvm/hyp/entry.S
> > +++ b/arch/arm64/kvm/hyp/entry.S
> > @@ -62,9 +62,6 @@ ENTRY(__guest_enter)
> >  	// Store the host regs
> >  	save_callee_saved_regs x1
> >  
> > -	// Store host_ctxt and vcpu for use at exit time
> > -	stp	x1, x0, [sp, #-16]!
> > -
> >  	add	x18, x0, #VCPU_CONTEXT
> >  
> >  	// Restore guest regs x0-x17
> > @@ -119,7 +116,7 @@ ENTRY(__guest_exit)
> >  	save_callee_saved_regs x1
> >  
> >  	// Restore the host_ctxt from the stack
> 
> Stale comment again.
> 

yeah...

> > -	ldr	x2, [sp], #16
> > +	get_host_ctxt	x2, x3
> >  
> >  	// Now restore the host regs
> >  	restore_callee_saved_regs x2
> > diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> > index e4f37b9..2950f26 100644
> > --- a/arch/arm64/kvm/hyp/hyp-entry.S
> > +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> > @@ -56,19 +56,16 @@ ENDPROC(__vhe_hyp_call)
> >  el1_sync:				// Guest trapped into EL2
> >  	stp	x0, x1, [sp, #-16]!
> >  
> > -alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
> > -	mrs	x1, esr_el2
> > -alternative_else
> > -	mrs	x1, esr_el1
> > -alternative_endif
> > -	lsr	x0, x1, #ESR_ELx_EC_SHIFT
> > -
> > -	cmp	x0, #ESR_ELx_EC_HVC64
> > -	b.ne	el1_trap
> > -
> >  	mrs	x1, vttbr_el2		// If vttbr is valid, the 64bit guest
> >  	cbnz	x1, el1_trap		// called HVC
> 
> Comment is outdated. Any guest trap will take this path.
> 

yeah...

> >  
> > +#ifdef CONFIG_DEBUG
> > +	mrs	x0, esr_el2
> > +	lsr	x0, x0, #ESR_ELx_EC_SHIFT
> > +	cmp     x0, #ESR_ELx_EC_HVC64
> > +	b.ne    __hyp_panic
> > +#endif
> > +
> >  	/* Here, we're pretty sure the host called HVC. */
> >  	ldp	x0, x1, [sp], #16
> >  
> > @@ -101,10 +98,15 @@ alternative_endif
> >  	eret
> >  
> >  el1_trap:
> > +	get_host_ctxt	x0, x1
> > +	get_vcpu	x1, x0
> > +
> > +	mrs		x0, esr_el2
> > +	lsr		x0, x0, #ESR_ELx_EC_SHIFT
> >  	/*
> >  	 * x0: ESR_EC
> > +	 * x1: vcpu pointer
> >  	 */
> > -	ldr	x1, [sp, #16 + 8]	// vcpu stored by __guest_enter
> >  
> >  	/*
> >  	 * We trap the first access to the FP/SIMD to save the host context
> > @@ -122,13 +124,15 @@ alternative_else_nop_endif
> >  
> >  el1_irq:
> >  	stp     x0, x1, [sp, #-16]!
> > -	ldr	x1, [sp, #16 + 8]
> > +	get_host_ctxt	x0, x1
> > +	get_vcpu	x1, x0
> >  	mov	x0, #ARM_EXCEPTION_IRQ
> >  	b	__guest_exit
> >  
> >  el1_error:
> >  	stp     x0, x1, [sp, #-16]!
> > -	ldr	x1, [sp, #16 + 8]
> > +	get_host_ctxt	x0, x1
> > +	get_vcpu	x1, x0
> >  	mov	x0, #ARM_EXCEPTION_EL1_SERROR
> >  	b	__guest_exit
> >  
> > @@ -164,14 +168,7 @@ ENTRY(__hyp_do_panic)
> >  ENDPROC(__hyp_do_panic)
> >  
> >  ENTRY(__hyp_panic)
> > -	/*
> > -	 * '=kvm_host_cpu_state' is a host VA from the constant pool, it may
> > -	 * not be accessible by this address from EL2, hyp_panic() converts
> > -	 * it with kern_hyp_va() before use.
> > -	 */
> > -	ldr	x0, =kvm_host_cpu_state
> > -	mrs	x1, tpidr_el2
> > -	add	x0, x0, x1
> > +	get_host_ctxt x0, x1
> >  	b	hyp_panic
> >  ENDPROC(__hyp_panic)
> >  
> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index 69ef24a..a0123ad 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c
> > @@ -435,7 +435,7 @@ void __hyp_text __noreturn hyp_panic(struct kvm_cpu_context *__host_ctxt)
> >  	if (read_sysreg(vttbr_el2)) {
> >  		struct kvm_cpu_context *host_ctxt;
> >  
> > -		host_ctxt = kern_hyp_va(__host_ctxt);
> > +		host_ctxt = __host_ctxt;
> 
> Can't we just rename __host_ctxt to host_ctxt and drop the local definition?
> 

yes, patch splitting snafu.  Will fix.

By the way, what I'm going for is anything in the hyp address space has
leading __, and otherwise ot.

> >  		vcpu = host_ctxt->__hyp_running_vcpu;
> >  		__timer_disable_traps(vcpu);
> >  		__deactivate_traps(vcpu);
> > 
> 
Thanks,
-Christoffer
