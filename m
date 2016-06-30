From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 09/15] arm64: KVM: Simplify HYP init/teardown
Date: Thu, 30 Jun 2016 15:31:39 +0200
Message-ID: <20160630133139.GZ26498@cbox>
References: <1465297115-13091-1-git-send-email-marc.zyngier@arm.com>
 <1465297115-13091-10-git-send-email-marc.zyngier@arm.com>
 <20160628213141.GQ26498@cbox> <57750C39.3040703@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C995949B53
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 09:25:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id krSklMZbg-E4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2016 09:25:34 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC4BD49B2C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 09:25:33 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id f126so222005117wma.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 06:30:49 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <57750C39.3040703@arm.com>
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
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 30, 2016 at 01:10:33PM +0100, Marc Zyngier wrote:
> On 28/06/16 22:31, Christoffer Dall wrote:
> > On Tue, Jun 07, 2016 at 11:58:29AM +0100, Marc Zyngier wrote:
> >> Now that we only have the "merged page tables" case to deal with,
> >> there is a bunch of things we can simplify in the HYP code (both
> >> at init and teardown time).
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  arch/arm64/include/asm/kvm_host.h | 12 ++------
> >>  arch/arm64/kvm/hyp-init.S         | 61 +++++----------------------------------
> >>  arch/arm64/kvm/hyp/entry.S        | 19 ------------
> >>  arch/arm64/kvm/hyp/hyp-entry.S    | 15 ++++++++++
> >>  arch/arm64/kvm/reset.c            | 11 -------
> >>  5 files changed, 26 insertions(+), 92 deletions(-)
> >>
> >> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> >> index 49095fc..88462c3 100644
> >> --- a/arch/arm64/include/asm/kvm_host.h
> >> +++ b/arch/arm64/include/asm/kvm_host.h
> >> @@ -48,7 +48,6 @@
> >>  int __attribute_const__ kvm_target_cpu(void);
> >>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
> >>  int kvm_arch_dev_ioctl_check_extension(long ext);
> >> -unsigned long kvm_hyp_reset_entry(void);
> >>  void __extended_idmap_trampoline(phys_addr_t boot_pgd, phys_addr_t idmap_start);
> >>  
> >>  struct kvm_arch {
> >> @@ -357,19 +356,14 @@ static inline void __cpu_init_hyp_mode(phys_addr_t boot_pgd_ptr,
> >>  	 * Call initialization code, and switch to the full blown
> >>  	 * HYP code.
> >>  	 */
> >> -	__kvm_call_hyp((void *)boot_pgd_ptr, pgd_ptr,
> >> -		       hyp_stack_ptr, vector_ptr);
> >> +	__kvm_call_hyp((void *)pgd_ptr, hyp_stack_ptr, vector_ptr);
> >>  }
> >>  
> >> +void __kvm_hyp_teardown(void);
> >>  static inline void __cpu_reset_hyp_mode(phys_addr_t boot_pgd_ptr,
> >>  					phys_addr_t phys_idmap_start)
> >>  {
> >> -	/*
> >> -	 * Call reset code, and switch back to stub hyp vectors.
> >> -	 * Uses __kvm_call_hyp() to avoid kaslr's kvm_ksym_ref() translation.
> >> -	 */
> >> -	__kvm_call_hyp((void *)kvm_hyp_reset_entry(),
> >> -		       boot_pgd_ptr, phys_idmap_start);
> >> +	kvm_call_hyp(__kvm_hyp_teardown, phys_idmap_start);
> >>  }
> >>  
> >>  static inline void kvm_arch_hardware_unsetup(void) {}
> >> diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
> >> index a873a6d..6b29d3d 100644
> >> --- a/arch/arm64/kvm/hyp-init.S
> >> +++ b/arch/arm64/kvm/hyp-init.S
> >> @@ -53,10 +53,9 @@ __invalid:
> >>  	b	.
> >>  
> >>  	/*
> >> -	 * x0: HYP boot pgd
> >> -	 * x1: HYP pgd
> >> -	 * x2: HYP stack
> >> -	 * x3: HYP vectors
> >> +	 * x0: HYP pgd
> >> +	 * x1: HYP stack
> >> +	 * x2: HYP vectors
> >>  	 */
> >>  __do_hyp_init:
> >>  
> >> @@ -110,71 +109,27 @@ __do_hyp_init:
> >>  	msr	sctlr_el2, x4
> >>  	isb
> >>  
> >> -	/* Skip the trampoline dance if we merged the boot and runtime PGDs */
> >> -	cmp	x0, x1
> >> -	b.eq	merged
> >> -
> >> -	/* MMU is now enabled. Get ready for the trampoline dance */
> >> -	ldr	x4, =TRAMPOLINE_VA
> >> -	adr	x5, target
> >> -	bfi	x4, x5, #0, #PAGE_SHIFT
> >> -	br	x4
> >> -
> >> -target: /* We're now in the trampoline code, switch page tables */
> >> -	msr	ttbr0_el2, x1
> >> -	isb
> >> -
> >> -	/* Invalidate the old TLBs */
> >> -	tlbi	alle2
> >> -	dsb	sy
> >> -
> >> -merged:
> >>  	/* Set the stack and new vectors */
> >> +	kern_hyp_va	x1
> >> +	mov	sp, x1
> >>  	kern_hyp_va	x2
> >> -	mov	sp, x2
> >> -	kern_hyp_va	x3
> >> -	msr	vbar_el2, x3
> >> +	msr	vbar_el2, x2
> >>  
> >>  	/* Hello, World! */
> >>  	eret
> >>  ENDPROC(__kvm_hyp_init)
> >>  
> >>  	/*
> >> -	 * Reset kvm back to the hyp stub. This is the trampoline dance in
> >> -	 * reverse. If kvm used an extended idmap, __extended_idmap_trampoline
> >> -	 * calls this code directly in the idmap. In this case switching to the
> >> -	 * boot tables is a no-op.
> >> -	 *
> >> -	 * x0: HYP boot pgd
> >> -	 * x1: HYP phys_idmap_start
> >> +	 * Reset kvm back to the hyp stub.
> >>  	 */
> >>  ENTRY(__kvm_hyp_reset)
> >> -	/* We're in trampoline code in VA, switch back to boot page tables */
> >> -	msr	ttbr0_el2, x0
> >> -	isb
> >> -
> >> -	/* Ensure the PA branch doesn't find a stale tlb entry or stale code. */
> >> -	ic	iallu
> >> -	tlbi	alle2
> >> -	dsb	sy
> >> -	isb
> >> -
> >> -	/* Branch into PA space */
> >> -	adr	x0, 1f
> >> -	bfi	x1, x0, #0, #PAGE_SHIFT
> >> -	br	x1
> >> -
> >>  	/* We're now in idmap, disable MMU */
> >> -1:	mrs	x0, sctlr_el2
> >> +	mrs	x0, sctlr_el2
> >>  	ldr	x1, =SCTLR_ELx_FLAGS
> >>  	bic	x0, x0, x1		// Clear SCTL_M and etc
> >>  	msr	sctlr_el2, x0
> >>  	isb
> >>  
> >> -	/* Invalidate the old TLBs */
> >> -	tlbi	alle2
> >> -	dsb	sy
> >> -
> > 
> > why can we get rid of the above two lines now?
> 
> We never really needed them, as we always invalid TLBs before enabling
> the MMU. Simply disabling the MMU is enough here.
> 
> > 
> >>  	/* Install stub vectors */
> >>  	adr_l	x0, __hyp_stub_vectors
> >>  	msr	vbar_el2, x0
> >> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> >> index 70254a6..ce9e5e5 100644
> >> --- a/arch/arm64/kvm/hyp/entry.S
> >> +++ b/arch/arm64/kvm/hyp/entry.S
> >> @@ -164,22 +164,3 @@ alternative_endif
> >>  
> >>  	eret
> >>  ENDPROC(__fpsimd_guest_restore)
> >> -
> >> -/*
> >> - * When using the extended idmap, we don't have a trampoline page we can use
> >> - * while we switch pages tables during __kvm_hyp_reset. Accessing the idmap
> >> - * directly would be ideal, but if we're using the extended idmap then the
> >> - * idmap is located above HYP_PAGE_OFFSET, and the address will be masked by
> >> - * kvm_call_hyp using kern_hyp_va.
> >> - *
> >> - * x0: HYP boot pgd
> >> - * x1: HYP phys_idmap_start
> >> - */
> >> -ENTRY(__extended_idmap_trampoline)
> >> -	mov	x4, x1
> >> -	adr_l	x3, __kvm_hyp_reset
> >> -
> >> -	/* insert __kvm_hyp_reset()s offset into phys_idmap_start */
> >> -	bfi	x4, x3, #0, #PAGE_SHIFT
> >> -	br	x4
> >> -ENDPROC(__extended_idmap_trampoline)
> >> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> >> index 2d87f36..f6d9694 100644
> >> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> >> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> >> @@ -62,6 +62,21 @@ ENTRY(__vhe_hyp_call)
> >>  	isb
> >>  	ret
> >>  ENDPROC(__vhe_hyp_call)
> >> +
> >> +/*
> >> + * Compute the idmap address of __kvm_hyp_reset based on the idmap
> >> + * start passed as a parameter, and jump there.
> >> + *
> >> + * x0: HYP phys_idmap_start
> >> + */
> >> +ENTRY(__kvm_hyp_teardown)
> >> +	mov	x4, x0
> >> +	adr_l	x3, __kvm_hyp_reset
> >> +
> >> +	/* insert __kvm_hyp_reset()s offset into phys_idmap_start */
> >> +	bfi	x4, x3, #0, #PAGE_SHIFT
> >> +	br	x4
> >> +ENDPROC(__kvm_hyp_teardown)
> >>  	
> >>  el1_sync:				// Guest trapped into EL2
> >>  	save_x0_to_x3
> >> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> >> index d044ca3..deee1b1 100644
> >> --- a/arch/arm64/kvm/reset.c
> >> +++ b/arch/arm64/kvm/reset.c
> >> @@ -132,14 +132,3 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >>  	/* Reset timer */
> >>  	return kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq);
> >>  }
> >> -
> >> -unsigned long kvm_hyp_reset_entry(void)
> >> -{
> >> -	/*
> >> -	 * KVM is running with merged page tables, which don't have the
> >> -	 * trampoline page mapped. We know the idmap is still mapped,
> >> -	 * but can't be called into directly. Use
> >> -	 * __extended_idmap_trampoline to do the call.
> >> -	 */
> >> -	return (unsigned long)kvm_ksym_ref(__extended_idmap_trampoline);
> >> -}
> >> -- 
> >> 2.1.4
> >>
> > 
> > I'm not sure I understand why we needed the kvm_hyp_reset_entry
> > indirection before, but the resulting code here looks good to me.
> 
> We still have an indirection, it is just a bit cleaner: We cannot call
> directly into the reset function located in the idmap, as the function
> is not strictly a kernel address, and the kern_hyp_va macro will mess
> with the function address. This is why we go via:
> 
> __cpu_reset_hyp_mode -> __kvm_hyp_teardown -> __kvm_hyp_reset
> 
> __cpu_reset_hyp_mode is the arch-agnostic entry point,
> __kvm_hyp_teardown is a normal HYP function, and __kvm_hyp_reset is the
> real thing in the idmap page.
> 
> Is that clearer?
> 
Didn't we have

__cpu_reset_hyp_mode -> kvm_hyp_reset_entry ->
__extended_idmap_trampoline -> __kvm_hyp_reset before, so one more level
of indirection, which we are not removing?

In any case, both versions of the code looks correct, perhaps it was
simply that kvm_hyp_reset_entry was implemented for both arm/arm64
before?

Thanks,
-Christoffer
