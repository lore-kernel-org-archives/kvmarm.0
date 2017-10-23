From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 1/8] arm64: KVM: Add invalidate_icache_range helper
Date: Mon, 23 Oct 2017 14:07:21 +0100
Message-ID: <20171023130721.GG31263@arm.com>
References: <20171020154904.31427-1-marc.zyngier@arm.com>
 <20171020154904.31427-2-marc.zyngier@arm.com>
 <20171023120522.GD31263@arm.com>
 <86po9ehwga.fsf@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <86po9ehwga.fsf@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 23, 2017 at 01:37:09PM +0100, Marc Zyngier wrote:
> On Mon, Oct 23 2017 at  1:05:23 pm BST, Will Deacon <will.deacon@arm.com> wrote:
> > Hi Marc,
> >
> > On Fri, Oct 20, 2017 at 04:48:57PM +0100, Marc Zyngier wrote:
> >> We currently tightly couple dcache clean with icache invalidation,
> >> but KVM could do without the initial flush to PoU, as we've
> >> already flushed things to PoC.
> >> 
> >> Let's introduce invalidate_icache_range which is limited to
> >> invalidating the icache from the linear mapping (and thus
> >> has none of the userspace fault handling complexity), and
> >> wire it in KVM instead of flush_icache_range.
> >> 
> >> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  arch/arm64/include/asm/assembler.h  | 26 ++++++++++++++++++++++++++
> >>  arch/arm64/include/asm/cacheflush.h |  8 ++++++++
> >>  arch/arm64/include/asm/kvm_mmu.h    |  4 ++--
> >>  arch/arm64/mm/cache.S               | 26 ++++++++++++++++----------
> >>  4 files changed, 52 insertions(+), 12 deletions(-)
> >> 
> >> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> >> index d58a6253c6ab..efdbecc8f2ef 100644
> >> --- a/arch/arm64/include/asm/assembler.h
> >> +++ b/arch/arm64/include/asm/assembler.h
> >> @@ -374,6 +374,32 @@ alternative_endif
> >>  	dsb	\domain
> >>  	.endm
> >>  
> >> +/*
> >> + * Macro to perform an instruction cache maintenance for the interval
> >> + * [start, end)
> >> + *
> >> + * 	start, end:	virtual addresses describing the region
> >> + *	label:		A label to branch to on user fault, none if
> >> + *			only used on a kernel address
> >> + * 	Corrupts:	tmp1, tmp2
> >> + */
> >> +	.macro invalidate_icache_by_line start, end, tmp1, tmp2, label=none
> >> +	icache_line_size \tmp1, \tmp2
> >> +	sub	\tmp2, \tmp1, #1
> >> +	bic	\tmp2, \start, \tmp2
> >> +9997:
> >> +	.if	(\label == none)
> >> +	ic	ivau, \tmp2			// invalidate I line PoU
> >> +	.else
> >> +USER(\label, ic	ivau, \tmp2)			// invalidate I line PoU
> >> +	.endif
> >> +	add	\tmp2, \tmp2, \tmp1
> >> +	cmp	\tmp2, \end
> >> +	b.lo	9997b
> >> +	dsb	ish
> >> +	isb
> >> +	.endm
> >
> > Code looks fine to me, but I'd like to drop the \label == none case. See
> > below.
> >
> >>  /*
> >>   * reset_pmuserenr_el0 - reset PMUSERENR_EL0 if PMUv3 present
> >>   */
> >> diff --git a/arch/arm64/include/asm/cacheflush.h b/arch/arm64/include/asm/cacheflush.h
> >> index 76d1cc85d5b1..ad56406944c6 100644
> >> --- a/arch/arm64/include/asm/cacheflush.h
> >> +++ b/arch/arm64/include/asm/cacheflush.h
> >> @@ -52,6 +52,13 @@
> >>   *		- start  - virtual start address
> >>   *		- end    - virtual end address
> >>   *
> >> + *	invalidate_icache_range(start, end)
> >> + *
> >> + *		Invalidate the I-cache in the region described by start, end.
> >> + *		Linear mapping only!
> >> + *		- start  - virtual start address
> >> + *		- end    - virtual end address
> >> + *
> >>   *	__flush_cache_user_range(start, end)
> >>   *
> >>   *		Ensure coherency between the I-cache and the D-cache in the
> >> @@ -66,6 +73,7 @@
> >>   *		- size   - region size
> >>   */
> >>  extern void flush_icache_range(unsigned long start, unsigned long end);
> >> +extern void invalidate_icache_range(unsigned long start, unsigned long end);
> >>  extern void __flush_dcache_area(void *addr, size_t len);
> >>  extern void __inval_dcache_area(void *addr, size_t len);
> >>  extern void __clean_dcache_area_poc(void *addr, size_t len);
> >> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> >> index 8034b96fb3a4..56b3e03c85e7 100644
> >> --- a/arch/arm64/include/asm/kvm_mmu.h
> >> +++ b/arch/arm64/include/asm/kvm_mmu.h
> >> @@ -250,8 +250,8 @@ static inline void __invalidate_icache_guest_page(struct kvm_vcpu *vcpu,
> >>  		/* PIPT or VPIPT at EL2 (see comment in __kvm_tlb_flush_vmid_ipa) */
> >>  		void *va = page_address(pfn_to_page(pfn));
> >>  
> >> -		flush_icache_range((unsigned long)va,
> >> -				   (unsigned long)va + size);
> >> +		invalidate_icache_range((unsigned long)va,
> >> +					(unsigned long)va + size);
> >>  	}
> >>  }
> >>  
> >> diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
> >> index 7f1dbe962cf5..8e71d237f85e 100644
> >> --- a/arch/arm64/mm/cache.S
> >> +++ b/arch/arm64/mm/cache.S
> >> @@ -60,16 +60,7 @@ user_alt 9f, "dc cvau, x4",  "dc civac, x4",  ARM64_WORKAROUND_CLEAN_CACHE
> >>  	b.lo	1b
> >>  	dsb	ish
> >>  
> >> -	icache_line_size x2, x3
> >> -	sub	x3, x2, #1
> >> -	bic	x4, x0, x3
> >> -1:
> >> -USER(9f, ic	ivau, x4	)		// invalidate I line PoU
> >> -	add	x4, x4, x2
> >> -	cmp	x4, x1
> >> -	b.lo	1b
> >> -	dsb	ish
> >> -	isb
> >> +	invalidate_icache_by_line x0, x1, x2, x3, 9f
> >>  	mov	x0, #0
> >>  1:
> >>  	uaccess_ttbr0_disable x1
> >> @@ -80,6 +71,21 @@ USER(9f, ic	ivau, x4	)		// invalidate I line PoU
> >>  ENDPROC(flush_icache_range)
> >>  ENDPROC(__flush_cache_user_range)
> >>  
> >> +/*
> >> + *	invalidate_icache_range(start,end)
> >> + *
> >> + *	Ensure that the I cache is invalid within specified region. This
> >> + *	assumes that this is done on the linear mapping. Do not use it
> >> + *	on a userspace range, as this may fault horribly.
> >
> > I'm still not sure why we're not hooking up the user fault handling here.
> > In the worst case, we'd end up returning -EFAULT if we got passed a
> > faulting user address and there's already precedence for this with e.g.
> > flush_icache_range.
> 
> Fair enough. Confusingly, flush_icache_range is declared as returning
> void... I'll cook a separate patch addressing this. How about the
> following on top of that patch:
> 
> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> index efdbecc8f2ef..27093cf2b91f 100644
> --- a/arch/arm64/include/asm/assembler.h
> +++ b/arch/arm64/include/asm/assembler.h
> @@ -379,20 +379,15 @@ alternative_endif
>   * [start, end)
>   *
>   * 	start, end:	virtual addresses describing the region
> - *	label:		A label to branch to on user fault, none if
> - *			only used on a kernel address
> + *	label:		A label to branch to on user fault.
>   * 	Corrupts:	tmp1, tmp2
>   */
> -	.macro invalidate_icache_by_line start, end, tmp1, tmp2, label=none
> +	.macro invalidate_icache_by_line start, end, tmp1, tmp2, label
>  	icache_line_size \tmp1, \tmp2
>  	sub	\tmp2, \tmp1, #1
>  	bic	\tmp2, \start, \tmp2
>  9997:
> -	.if	(\label == none)
> -	ic	ivau, \tmp2			// invalidate I line PoU
> -	.else
>  USER(\label, ic	ivau, \tmp2)			// invalidate I line PoU
> -	.endif
>  	add	\tmp2, \tmp2, \tmp1
>  	cmp	\tmp2, \end
>  	b.lo	9997b
> diff --git a/arch/arm64/include/asm/cacheflush.h b/arch/arm64/include/asm/cacheflush.h
> index ad56406944c6..e671e73c6453 100644
> --- a/arch/arm64/include/asm/cacheflush.h
> +++ b/arch/arm64/include/asm/cacheflush.h
> @@ -55,7 +55,6 @@
>   *	invalidate_icache_range(start, end)
>   *
>   *		Invalidate the I-cache in the region described by start, end.
> - *		Linear mapping only!
>   *		- start  - virtual start address
>   *		- end    - virtual end address
>   *
> @@ -73,7 +72,7 @@
>   *		- size   - region size
>   */
>  extern void flush_icache_range(unsigned long start, unsigned long end);
> -extern void invalidate_icache_range(unsigned long start, unsigned long end);
> +extern int  invalidate_icache_range(unsigned long start, unsigned long end);
>  extern void __flush_dcache_area(void *addr, size_t len);
>  extern void __inval_dcache_area(void *addr, size_t len);
>  extern void __clean_dcache_area_poc(void *addr, size_t len);
> diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
> index 8e71d237f85e..a89f23610b7e 100644
> --- a/arch/arm64/mm/cache.S
> +++ b/arch/arm64/mm/cache.S
> @@ -74,15 +74,17 @@ ENDPROC(__flush_cache_user_range)
>  /*
>   *	invalidate_icache_range(start,end)
>   *
> - *	Ensure that the I cache is invalid within specified region. This
> - *	assumes that this is done on the linear mapping. Do not use it
> - *	on a userspace range, as this may fault horribly.
> + *	Ensure that the I cache is invalid within specified region.
>   *
>   *	- start   - virtual start address of region
>   *	- end     - virtual end address of region
>   */
>  ENTRY(invalidate_icache_range)
> -	invalidate_icache_by_line x0, x1, x2, x3
> +	invalidate_icache_by_line x0, x1, x2, x3, 1f
> +	mov	x0, xzr
> +	ret
> +1:
> +	mov	x0, #-EFAULT

You need to add the uaccess_ttbr0_{enable,disable} calls here, but with
that then I think this is good.

Will
