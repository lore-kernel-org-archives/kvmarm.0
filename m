From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 01/36] KVM: arm64: Avoid storing the vcpu pointer on
 the stack
Date: Mon, 11 Dec 2017 10:30:31 +0100
Message-ID: <20171211093031.GF910@cbox>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
 <20171207170630.592-2-christoffer.dall@linaro.org>
 <868tebstsi.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DED5649D14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 04:27:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p6JQSJijcehi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Dec 2017 04:27:11 -0500 (EST)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B48940EA6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 04:27:11 -0500 (EST)
Received: by mail-wm0-f67.google.com with SMTP id n138so13069652wmg.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 01:30:37 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <868tebstsi.wl-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Dec 09, 2017 at 05:19:41PM +0000, Marc Zyngier wrote:
> On Thu, 07 Dec 2017 17:05:55 +0000,
> Christoffer Dall wrote:
> > 
> > We already have the percpu area for the host cpu state, which points to
> > the VCPU, so there's no need to store the VCPU pointer on the stack on
> > every context switch.  We can be a little more clever and just use
> > tpidr_el2 for the percpu offset and load the VCPU pointer from the host
> > context.
> > 
> > This does require us to calculate the percpu offset without including
> > the offset from the kernel mapping of the percpu array to the linaro
> 
> "linaro"?
> 

*linear* - spell check must have played a trick on me.

> > mapping of the array (which is what we store in tpidr_el1), because a
> > PC-relative generated address in EL2 is already giving us the hyp alias
> > of the linear mapping of a kernel address.  We do this in
> > __cpu_init_hyp_mode() by using kvm_ksym_ref().
> > 
> > This change also requires us to have a scratch register, so we take the
> > chance to rearrange some of the el1_sync code to only look at the
> > vttbr_el2 to determine if this is a trap from the guest or an HVC from
> > the host.  We do add an extra check to call the panic code if the kernel
> > is configured with debugging enabled and we saw a trap from the host
> > which wasn't an HVC, indicating that we left some EL2 trap configured by
> > mistake.
> > 
> > The code that accesses ESR_EL2 was previously using an alternative to
> > use the _EL1 accessor on VHE systems, but this was actually unnecessary
> > as the _EL1 accessor aliases the ESR_EL2 register on VHE, and the _EL2
> > accessor does the same thing on both systems.
> > 
> > Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> > 
> > Notes:
> >     Changes since v1:
> >      - Use PC-relative addressing to access per-cpu variables instead of
> >        using a load from the literal pool.
> >      - Remove stale comments as pointed out by Marc
> >      - Reworded the commit message as suggested by Drew
> > 
> >  arch/arm64/include/asm/kvm_asm.h  | 15 ++++++++++++++
> >  arch/arm64/include/asm/kvm_host.h | 15 ++++++++++++++
> >  arch/arm64/kernel/asm-offsets.c   |  1 +
> >  arch/arm64/kvm/hyp/entry.S        |  6 +-----
> >  arch/arm64/kvm/hyp/hyp-entry.S    | 41 ++++++++++++++++++---------------------
> >  arch/arm64/kvm/hyp/switch.c       |  5 +----
> >  arch/arm64/kvm/hyp/sysreg-sr.c    |  5 +++++
> >  7 files changed, 57 insertions(+), 31 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index ab4d0a926043..33e0edc6f8be 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -33,6 +33,7 @@
> >  #define KVM_ARM64_DEBUG_DIRTY_SHIFT	0
> >  #define KVM_ARM64_DEBUG_DIRTY		(1 << KVM_ARM64_DEBUG_DIRTY_SHIFT)
> >  
> > +/* Translate a kernel address of @sym into its equivalent linear mapping */
> >  #define kvm_ksym_ref(sym)						\
> >  	({								\
> >  		void *val = &sym;					\
> > @@ -70,4 +71,18 @@ extern u32 __init_stage2_translation(void);
> >  
> >  #endif
> >  
> > +#ifdef __ASSEMBLY__
> 
> You could turn this and the previous #endif into a simple #else.
> 

yup

> > +.macro get_host_ctxt reg, tmp
> > +	adr_l	\reg, kvm_host_cpu_state
> > +	mrs	\tmp, tpidr_el2
> > +	add	\reg, \reg, \tmp
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
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 7ee72b402907..af58deb6ec3c 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -348,10 +348,15 @@ int kvm_perf_teardown(void);
> >  
> >  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
> >  
> > +extern void __kvm_set_tpidr_el2(u64 tpidr_el2);
> 
> Is there any advantage in having this prototype in kvm_host.h, instead
> of putting it in kvm_hyp.h (which feels more appropriate)?
> 

asm-offsets.c pukes all over the place and I can't include asm/kvm_hyp.h
from kvm_host.h, because it depends on kvm_host.h, and I can't include
asm/kvm_hyp.h easily in asm-offsets.c because it pukes again from all
sorts of other missing things.

If you care strongly about this point, I can try to dig deeper in this
or refactor this somehow more substantially.  Ideas?

> > +DECLARE_PER_CPU(kvm_cpu_context_t, kvm_host_cpu_state);
> > +
> >  static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
> >  				       unsigned long hyp_stack_ptr,
> >  				       unsigned long vector_ptr)
> >  {
> > +	u64 tpidr_el2;
> > +
> >  	/*
> >  	 * Call initialization code, and switch to the full blown HYP code.
> >  	 * If the cpucaps haven't been finalized yet, something has gone very
> > @@ -360,6 +365,16 @@ static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
> >  	 */
> >  	BUG_ON(!static_branch_likely(&arm64_const_caps_ready));
> >  	__kvm_call_hyp((void *)pgd_ptr, hyp_stack_ptr, vector_ptr);
> > +
> > +	/*
> > +	 * Calculate the raw per-cpu offset without a translation from the
> > +	 * kernel's mapping to the linear mapping, and store it in tpidr_el2
> > +	 * so that we can use adr_l to access per-cpu variables in EL2.
> > +	 */
> > +	tpidr_el2 = (u64)this_cpu_ptr(&kvm_host_cpu_state)
> > +		- (u64)kvm_ksym_ref(kvm_host_cpu_state);
> > +
> > +	kvm_call_hyp(__kvm_set_tpidr_el2, tpidr_el2);
> >  }
> >  
> >  static inline void kvm_arch_hardware_unsetup(void) {}
> > diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> > index 71bf088f1e4b..612021dce84f 100644
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
> > index 9a8ab5dddd9e..a360ac6e89e9 100644
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
> > @@ -118,8 +115,7 @@ ENTRY(__guest_exit)
> >  	// Store the guest regs x19-x29, lr
> >  	save_callee_saved_regs x1
> >  
> > -	// Restore the host_ctxt from the stack
> > -	ldr	x2, [sp], #16
> > +	get_host_ctxt	x2, x3
> >  
> >  	// Now restore the host regs
> >  	restore_callee_saved_regs x2
> > diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> > index e4f37b9dd47c..71b4cc92895e 100644
> > --- a/arch/arm64/kvm/hyp/hyp-entry.S
> > +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> > @@ -56,18 +56,15 @@ ENDPROC(__vhe_hyp_call)
> >  el1_sync:				// Guest trapped into EL2
> >  	stp	x0, x1, [sp, #-16]!
> >  
> > -alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
> > -	mrs	x1, esr_el2
> > -alternative_else
> > -	mrs	x1, esr_el1
> > -alternative_endif
> > -	lsr	x0, x1, #ESR_ELx_EC_SHIFT
> > +	mrs	x1, vttbr_el2		// If vttbr is valid, this is a trap
> > +	cbnz	x1, el1_trap		// from the guest
> >  
> > -	cmp	x0, #ESR_ELx_EC_HVC64
> > -	b.ne	el1_trap
> > -
> > -	mrs	x1, vttbr_el2		// If vttbr is valid, the 64bit guest
> > -	cbnz	x1, el1_trap		// called HVC
> > +#ifdef CONFIG_DEBUG
> > +	mrs	x0, esr_el2
> > +	lsr	x0, x0, #ESR_ELx_EC_SHIFT
> > +	cmp     x0, #ESR_ELx_EC_HVC64
> > +	b.ne    __hyp_panic
> > +#endif
> >  
> >  	/* Here, we're pretty sure the host called HVC. */
> >  	ldp	x0, x1, [sp], #16
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
> > index f7307b6b42f0..6fcb37e220b5 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c
> > @@ -449,7 +449,7 @@ static hyp_alternate_select(__hyp_call_panic,
> >  			    __hyp_call_panic_nvhe, __hyp_call_panic_vhe,
> >  			    ARM64_HAS_VIRT_HOST_EXTN);
> >  
> > -void __hyp_text __noreturn hyp_panic(struct kvm_cpu_context *__host_ctxt)
> > +void __hyp_text __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
> >  {
> >  	struct kvm_vcpu *vcpu = NULL;
> >  
> > @@ -458,9 +458,6 @@ void __hyp_text __noreturn hyp_panic(struct kvm_cpu_context *__host_ctxt)
> >  	u64 par = read_sysreg(par_el1);
> >  
> >  	if (read_sysreg(vttbr_el2)) {
> > -		struct kvm_cpu_context *host_ctxt;
> > -
> > -		host_ctxt = kern_hyp_va(__host_ctxt);
> >  		vcpu = host_ctxt->__hyp_running_vcpu;
> >  		__timer_disable_traps(vcpu);
> >  		__deactivate_traps(vcpu);
> > diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> > index c54cc2afb92b..e19d89cabf2a 100644
> > --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> > +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> > @@ -183,3 +183,8 @@ void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
> >  	if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
> >  		write_sysreg(sysreg[DBGVCR32_EL2], dbgvcr32_el2);
> >  }
> > +
> > +void __hyp_text __kvm_set_tpidr_el2(u64 tpidr_el2)
> > +{
> > +	asm("msr tpidr_el2, %0": : "r" (tpidr_el2));
> > +}
> > -- 
> > 2.14.2
> > 
> 
> Other than the couple of nits above:
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> 

Thanks!
-Christoffer
