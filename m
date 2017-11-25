From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC PATCH 4/4] arm64/sve: KVM: Basic SVE support
Date: Sat, 25 Nov 2017 18:48:36 +0100
Message-ID: <20171125174836.e4ojqsudwwykmdi4@kamzik.brq.redhat.com>
References: <1510936735-6762-1-git-send-email-Dave.Martin@arm.com>
 <1510936735-6762-5-git-send-email-Dave.Martin@arm.com>
 <20171122192327.GQ28855@cbox>
 <20171123180634.GL22781@e103592.cambridge.arm.com>
 <20171123184929.GE28855@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8371549D6D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Nov 2017 12:45:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VCB-tOSwYoJh for <kvmarm@lists.cs.columbia.edu>;
 Sat, 25 Nov 2017 12:45:57 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F7E449D6B
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Nov 2017 12:45:57 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20171123184929.GE28855@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 23, 2017 at 07:49:29PM +0100, Christoffer Dall wrote:
> On Thu, Nov 23, 2017 at 06:06:34PM +0000, Dave Martin wrote:
> > > > diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> > > > index 12ee62d..d8e8d22 100644
> > > > --- a/arch/arm64/kvm/hyp/entry.S
> > > > +++ b/arch/arm64/kvm/hyp/entry.S
> > > > @@ -162,37 +162,75 @@ ENTRY(__fpsimd_guest_restore)
> > > >  	stp	x2, x3, [sp, #-16]!
> > > >  	stp	x4, lr, [sp, #-16]!
> > > >  
> > > > +	mrs	x0, cptr_el2
> > > > +
> > > > +alternative_if_not ARM64_SVE
> > > > +	mov	x1, #CPTR_EL2_TFP
> > > > +	mov	x2, #CPACR_EL1_FPEN
> > > > +alternative_else
> > > > +	mov	x1, #CPTR_EL2_TFP | CPTR_EL2_TZ
> > > > +	mov	x2, #CPACR_EL1_FPEN | CPACR_EL1_ZEN
> > > > +alternative_endif
> > > > +
> > > >  alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
> > > > -	mrs	x2, cptr_el2
> > > > -	bic	x2, x2, #CPTR_EL2_TFP
> > > > -	msr	cptr_el2, x2
> > > > +	bic	x0, x0, x1
> > > >  alternative_else
> > > > -	mrs	x2, cpacr_el1
> > > > -	orr	x2, x2, #CPACR_EL1_FPEN
> > > > -	msr	cpacr_el1, x2
> > > > +	orr	x0, x0, x2
> > > >  alternative_endif
> > > > +
> > > > +	msr	cptr_el2, x0
> > > >  	isb
> > > >  
> > > > -	mrs	x3, tpidr_el2
> > > > +	mrs	x4, tpidr_el2
> > > >  
> > > > -	ldr	x0, [x3, #VCPU_HOST_CONTEXT]
> > > > +	ldr	x0, [x4, #VCPU_HOST_CONTEXT]
> > > >  	kern_hyp_va x0
> > > >  	add	x0, x0, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
> > > >  	bl	__fpsimd_save_state
> > > >  
> > > > -	add	x2, x3, #VCPU_CONTEXT
> > > > +	add	x2, x4, #VCPU_CONTEXT
> > > > +
> > > > +#ifdef CONFIG_ARM64_SVE
> > > > +alternative_if ARM64_SVE
> > > > +	b	2f
> > > > +alternative_else_nop_endif
> > > > +#endif
> > > > +
> > > >  	add	x0, x2, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
> > > >  	bl	__fpsimd_restore_state
> > > >  
> > > > +0:
> > > >  	// Skip restoring fpexc32 for AArch64 guests
> > > >  	mrs	x1, hcr_el2
> > > >  	tbnz	x1, #HCR_RW_SHIFT, 1f
> > > > -	ldr	x4, [x3, #VCPU_FPEXC32_EL2]
> > > > -	msr	fpexc32_el2, x4
> > > > +	ldr	x3, [x4, #VCPU_FPEXC32_EL2]
> > > > +	msr	fpexc32_el2, x3
> > > >  1:
> > > >  	ldp	x4, lr, [sp], #16
> > > >  	ldp	x2, x3, [sp], #16
> > > >  	ldp	x0, x1, [sp], #16
> > > >  
> > > >  	eret
> > > > +
> > > > +#ifdef CONFIG_ARM64_SVE
> > > > +2:
> > > > +alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
> > > > +	ldr	x0, [x4, #VCPU_ZCR_EL2]
> > > > +	ldr	x3, [x4, #VCPU_ZCR_EL1]
> > > > +	msr_s	SYS_ZCR_EL2, x0
> > > > +alternative_else
> > > > +	ldr	x0, [x4, #VCPU_ZCR_EL1]
> > > > +	ldr	x3, [x4, #VCPU_ZCR_EL2]
> > > > +	msr_s	SYS_ZCR_EL12, x0
> > > > +alternative_endif
> > > > +
> > > > +	ldr	w0, [x4, #VCPU_SVE_FFR_OFFSET]
> > > > +	add	x0, x4, x0
> > > > +	add	x1, x2, #VCPU_FPSR - VCPU_CONTEXT
> > > > +	mov	x2, x3
> > > > +	bl	__sve_load_state
> > > > +
> > > > +	b	0b
> > > > +#endif /* CONFIG_ARM64_SVE */
> > > 
> > > I think if we could move all of this out to C code that would be much
> > > nicer.  Also, we currently do the short-circuit fault-in-fpsimd state
> > > inside hyp and always save the fpsimd state when returning to the host
> > > kernel, but in my optimization series I change this to leave the state
> > > in hardware until we schedule or return to userspace, so perhaps we can
> > > go all the way back to handle_exit() then without much performance loss,
> > > which may further simplify the SVE support?

Or all the way back to VCPU RUN exiting, if Rik's proposal[*] for x86 FPU
registers makes sense for these registers as well.

[*] https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1536992.html

> > 
> > This is what I would be aiming for, coupled with awareness of whether
> > the host has any live FPSIMD/SVE state in the first place: for SVE
> > specifically the answer will _usually_ be "no".
> > 
> > Ideally, we would give a vcpu its own SVE/FPSIMD context on a par with
> > host tasks and just reuse the fpsimd.c machinery rather than inventing
> > separate machinery for KVM -- 

That's what I understand Rik is trying to do.

> > the flipside would be that the hyp code
> > may need to mainpulate thread flags etc. -- I didn't want to rush to
> > this destination before learning to walk though.
> 
> Fair enough, but then I think the "let's rely on VHE for SVE support"
> comes in, because you can mostly think of hyp code as being the host
> kernel code.
> 
> > 
> > For the first iteration of KVM SVE support I would rather not do that
> > rafactoring, to reduce the number of things I'm breaking at the same
> > time...
> > 
> 
> On the other hand, if it makes the SVE support code much simpler, it may
> be easier in the end.  It may be worth thinking of a way we can measure
> the two approaches with basic FPSIMD so that we know the consequences of
> refactoring anything.
> 
> > > 
> > > The hit would obviously be a slightly higher latency on the first fault
> > > in the guest on SVE/fpsimd.
> > 
> > For SVE it's probably not the end of the world since that's higher
> > cost to save/restore in the first place.
> > 
> > For FPSIMD I've less of a feel for it.
> > 
> 
> Yeah, me neither.  We'd have to measure something.


Thanks,
drew
