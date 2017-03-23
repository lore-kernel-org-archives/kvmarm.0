From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 00/28] arm/arm64: KVM: Rework the hyp-stub API
Date: Thu, 23 Mar 2017 15:39:16 +0100
Message-ID: <20170323143916.GA27715@cbox>
References: <20170321192058.9300-1-marc.zyngier@arm.com>
 <20170322133724.GA10969@cbox>
 <3dab2f39-88c2-e10b-942c-58a1d8053b71@arm.com>
 <20170322172708.GA17329@cbox>
 <10524c84-1e1e-05f8-97b9-436c8649ffa8@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BD3440AF9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Mar 2017 10:37:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rwKL4PuaEsw5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Mar 2017 10:37:28 -0400 (EDT)
Received: from mail-wr0-f182.google.com (mail-wr0-f182.google.com
 [209.85.128.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F407F40A86
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Mar 2017 10:37:27 -0400 (EDT)
Received: by mail-wr0-f182.google.com with SMTP id u1so14822599wra.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Mar 2017 07:39:18 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <10524c84-1e1e-05f8-97b9-436c8649ffa8@arm.com>
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
Cc: Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, Keerthy <j-keerthy@ti.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 23, 2017 at 10:53:04AM +0000, Marc Zyngier wrote:
> On 22/03/17 17:27, Christoffer Dall wrote:
> > On Wed, Mar 22, 2017 at 04:14:44PM +0000, Marc Zyngier wrote:
> >> Hi Christoffer,
> >>
> >> On 22/03/17 13:37, Christoffer Dall wrote:
> >>> Hi Marc,
> >>>
> >>>
> >>> On Tue, Mar 21, 2017 at 07:20:30PM +0000, Marc Zyngier wrote:
> >>>> As noticed by RMK in this thread[1], the hyp-stub API on 32bit ARM
> >>>> could do with some TLC (it cannot perform a soft-restart at HYP, and
> >>>> has holes in the hyp-stub support in a number of places). In general,
> >>>> it would be desirable for the 32bit behaviour to align on 64bit, if
> >>>> only to ease maintenance.
> >>>>
> >>>> This series implements the following:
> >>>> - Add HVC_[GS]ET_VECTORS and HVC_SOFT_RESTART to the 32bit code
> >>>> - Add HVC_RESET_VECTORS to both arm and arm64, removing the need for
> >>>>   __hyp_reset_vectors
> >>>> - Implement add the stub entry points in the KVM init code, which
> >>>>   didn't implement any so far
> >>>> - Convert the HYP code to use the init code stubs directly
> >>>> - Some general cleanup as a result of these changes (which includes
> >>>>   killing HVC_GET_VECTORS)
> >>>> - Add some API documentation that covers the above
> >>>>
> >>>> Patches 12 to 14 would be better squashed into 10 and 11, but I've
> >>>> kept them separate so that I can take the blame for everything I've
> >>>> broken.
> >>>
> >>> This series looks great overall.  I'm still going through the details of
> >>> the patches, but one high level questions:
> >>>
> >>> What if we formalized the way to call a function in Hyp mode, whatever
> >>> its current configuration may be, via a specific HVC number.  That would
> >>> mean that the documentation say nothing of a hypervisor specific
> >>> implementaiton.
> >>
> >> Do you mean an actual function call indirected via an HVC? Similar to
> >> what we already do today for KVM when we want to call HYP functions?
> > 
> > Yes exactly.  One question would be how to standardize that if the
> > caller is not tied to the thing owning Hyp, making it unclear if it can
> > rely on the thing working or not, but I'm not sure if that's any worse
> > than what we have today.
> > 
> >>> Could we then use that to initialize hyp mode for a hypervisor, i.e.
> >>> KVM, without having to actually change the vectors?  Couldn't we simply
> >>> use the the hvc stub to call a function in the physical address space,
> >>> and be rid of the concept of hyp-init alltogether?
> >>
> >> My problem here is when you say "in the physical space". Do you want to
> >> be able to call such a function from any context? That's certainly
> >> doable now, but I'm not completely sure of what we get.
> >>
> >> Maybe I just don't see the use case - can you enlighten me?
> >>
> > 
> > I don't think there is a great use case beyond what we already do, it
> > would just be to have one set of hyp vectors fewer, so that either the
> > hyp stub is in place, or a hypervisor is in place, not kvm-init vectors.
> > 
> > So instead of doing:
> >   __hyp_set_vectors(kvm_get_idmap_vector());
> >   hvc(); /* via the misused kvm_call_hyp thing */
> > 
> > you would do:
> > 
> >   __hyp_call_function(__kvm_hyp_init, arg1, arg2);
> > 
> > which would change the vector and initialize anything.
> > 
> > Not sure if that can work though, or if there are any downsides that I
> > haven't thought about?
> 
> I've given it a go, and that seems to work, at least on arm64. We may 
> have to set the vectors in a slightly different way on 32bit because 
> we're going to run out of registers (we only have two left once we 
> reach the function being called).

Right, that's a challenge I clearly didn't foresee.

> 
> Another thing is that the function called is not really a function. It 
> is an exception handler, as it has to end with an eret (or we may need 
> to save LR in funky ways).

Shouldn't it have the same semantics as the KVM calling function thing
where it pushes the LR on the stack?  But of course, that requires
having a stack for each runtime that owns hyp mode at any given time.
Potentially not great.

If possible, the idea would be that you'd call functions, just like you
normally do, but the functions you call can choose to never return -
again just like a C function can do if it messes with your machine
configuration.

But maybe the idea is fundamentally flawed, if the only function
you'd ever call from the hyp stub is one that takes over the hyp world,
and then the original design was just based on using set_vectors.  Hmmm.


>  The potential blocker for this is that the
> 32bit decompressor does use set_vectors in funky ways to deal with
> relocation. If we get rid of set_vectors like I just did on 64bit,
> we'll need to mess with that as well.

Interesting.  I didn't think that we'd necessarily get rid of
set_vectors, but I agree with you that if we wanted to do this, it
should probably go.

> 
> Anyway, here's the hack, 64bit only, quickly tested on Mustang. I'm not
> completely sure this is any prettier, but it is certainly manageable.

There are two things I like about it.  First, it gets rid of the
'additional runtime' in hyp and second the changes to
cpu_init_hyp_mode() are quite nice, imho.

Thanks being said, this series is pretty nice as it is, so I don't want
to impose more work on you at the moment, so maybe we save your patch
snipped below for later if we want to consider looking at it some other
time?

Thanks,
-Christoffer

> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index cbd3a3150090..9594e0acb331 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -1092,17 +1092,12 @@ static void cpu_init_hyp_mode(void *dummy)
>  	phys_addr_t pgd_ptr;
>  	unsigned long hyp_stack_ptr;
>  	unsigned long stack_page;
> -	unsigned long vector_ptr;
> -
> -	/* Switch from the HYP stub to our own HYP init vector */
> -	__hyp_set_vectors(kvm_get_idmap_vector());
>  
>  	pgd_ptr = kvm_mmu_get_httbr();
>  	stack_page = __this_cpu_read(kvm_arm_hyp_stack_page);
>  	hyp_stack_ptr = stack_page + PAGE_SIZE;
> -	vector_ptr = (unsigned long)kvm_ksym_ref(__kvm_hyp_vector);
>  
> -	__cpu_init_hyp_mode(pgd_ptr, hyp_stack_ptr, vector_ptr);
> +	__cpu_init_hyp_mode(pgd_ptr, hyp_stack_ptr);
>  	__cpu_init_stage2();
>  
>  	if (is_kernel_in_hyp_mode())
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 578df18f66b7..b314c77adfc1 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -339,6 +339,8 @@ void kvm_arm_resume_vcpu(struct kvm_vcpu *vcpu);
>  
>  u64 __kvm_call_hyp(void *hypfn, ...);
>  #define kvm_call_hyp(f, ...) __kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__)
> +u64 __hyp_call_func(void *hypfn, ...);
> +#define hyp_call_func(f, ...) __hyp_call_func(kvm_ksym_ref(f), ##__VA_ARGS__)
>  
>  void force_vm_exit(const cpumask_t *mask);
>  void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
> @@ -352,14 +354,14 @@ int kvm_perf_teardown(void);
>  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
>  
>  static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
> -				       unsigned long hyp_stack_ptr,
> -				       unsigned long vector_ptr)
> +				       unsigned long hyp_stack_ptr)
>  {
>  	/*
>  	 * Call initialization code, and switch to the full blown
>  	 * HYP code.
>  	 */
> -	__kvm_call_hyp((void *)pgd_ptr, hyp_stack_ptr, vector_ptr);
> +	__hyp_call_func(__kvm_hyp_init, pgd_ptr, hyp_stack_ptr,
> +			kvm_ksym_ref(__kvm_hyp_vector));
>  }
>  
>  static inline void kvm_arch_hardware_unsetup(void) {}
> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
> index a7c9dfdd6430..478a64545f37 100644
> --- a/arch/arm64/include/asm/virt.h
> +++ b/arch/arm64/include/asm/virt.h
> @@ -25,11 +25,12 @@
>   */
>  
>  /*
> - * HVC_SET_VECTORS - Set the value of the vbar_el2 register.
> + * HVC_CALL_FUNC - Call a function in the idmap
>   *
> - * @x1: Physical address of the new vector table.
> + * @x1: function address
> + * @x2-x5: parameters
>   */
> -#define HVC_SET_VECTORS 0
> +#define HVC_CALL_FUNC	 0
>  
>  /*
>   * HVC_SOFT_RESTART - CPU soft reset, used by the cpu_soft_restart routine.
> @@ -41,6 +42,7 @@
>   */
>  #define HVC_RESET_VECTORS 2
>  
> +
>  /* Max number of HYP stub hypercalls */
>  #define HVC_STUB_HCALL_NR 3
>  
> diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
> index 210bd6b3849d..d99968333da1 100644
> --- a/arch/arm64/kernel/hyp-stub.S
> +++ b/arch/arm64/kernel/hyp-stub.S
> @@ -55,10 +55,17 @@ ENDPROC(__hyp_stub_vectors)
>  	.align 11
>  
>  el1_sync:
> -	cmp	x0, #HVC_SET_VECTORS
> +	cmp	x0, #HVC_CALL_FUNC
>  	b.ne	2f
> -	msr	vbar_el2, x1
> -	b	9f
> +	mov	x7, x1
> +	mov	x0, x2
> +	mov	x1, x3
> +	mov	x2, x4
> +	mov	x3, x5
> +	mov	x4, x6
> +	ldr_l	x6, kimage_voffset
> +	sub	x7, x7, x6
> +	br	x7
>  
>  2:	cmp	x0, #HVC_SOFT_RESTART
>  	b.ne	3f
> @@ -93,12 +100,7 @@ ENDPROC(\label)
>  	invalid_vector	el1_error_invalid
>  
>  /*
> - * __hyp_set_vectors: Call this after boot to set the initial hypervisor
> - * vectors as part of hypervisor installation.  On an SMP system, this should
> - * be called on each CPU.
> - *
> - * x0 must be the physical address of the new vector table, and must be
> - * 2KB aligned.
> + * FIXME: Document __hyp_call_func...
>   *
>   * Before calling this, you must check that the stub hypervisor is installed
>   * everywhere, by waiting for any secondary CPUs to be brought up and then
> @@ -113,15 +115,20 @@ ENDPROC(\label)
>   * initialisation entry point.
>   */
>  
> -ENTRY(__hyp_set_vectors)
> -	mov	x1, x0
> -	mov	x0, #HVC_SET_VECTORS
> -	hvc	#0
> -	ret
> -ENDPROC(__hyp_set_vectors)
> -
>  ENTRY(__hyp_reset_vectors)
>  	mov	x0, #HVC_RESET_VECTORS
>  	hvc	#0
>  	ret
>  ENDPROC(__hyp_reset_vectors)
> +
> +ENTRY(__hyp_call_func)
> +	mov	x6, x5
> +	mov	x5, x4
> +	mov	x4, x3
> +	mov	x3, x2
> +	mov	x2, x1
> +	mov	x1, x0
> +	mov	x0, #HVC_CALL_FUNC
> +	hvc	#0
> +	ret
> +ENDPROC(__hyp_call_func)
> diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
> index cf01cdb8bc61..aa48a30178c4 100644
> --- a/arch/arm64/kvm/hyp-init.S
> +++ b/arch/arm64/kvm/hyp-init.S
> @@ -30,35 +30,11 @@
>  	.align	11
>  
>  ENTRY(__kvm_hyp_init)
> -	ventry	__invalid		// Synchronous EL2t
> -	ventry	__invalid		// IRQ EL2t
> -	ventry	__invalid		// FIQ EL2t
> -	ventry	__invalid		// Error EL2t
> -
> -	ventry	__invalid		// Synchronous EL2h
> -	ventry	__invalid		// IRQ EL2h
> -	ventry	__invalid		// FIQ EL2h
> -	ventry	__invalid		// Error EL2h
> -
> -	ventry	__do_hyp_init		// Synchronous 64-bit EL1
> -	ventry	__invalid		// IRQ 64-bit EL1
> -	ventry	__invalid		// FIQ 64-bit EL1
> -	ventry	__invalid		// Error 64-bit EL1
> -
> -	ventry	__invalid		// Synchronous 32-bit EL1
> -	ventry	__invalid		// IRQ 32-bit EL1
> -	ventry	__invalid		// FIQ 32-bit EL1
> -	ventry	__invalid		// Error 32-bit EL1
> -
> -__invalid:
> -	b	.
> -
>  	/*
>  	 * x0: HYP pgd
>  	 * x1: HYP stack
>  	 * x2: HYP vectors
>  	 */
> -__do_hyp_init:
>  	/* Check for a stub HVC call */
>  	cmp	x0, #HVC_STUB_HCALL_NR
>  	b.lo	__kvm_handle_stub_hvc
> 
> -- 
> Jazz is not dead. It just smells funny...
