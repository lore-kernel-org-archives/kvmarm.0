From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v6] arm64: Add support for new control bits CTR_EL0.DIC
 and CTR_EL0.IDC
Date: Tue, 6 Mar 2018 15:23:19 +0000
Message-ID: <20180306152318.GE17454@arm.com>
References: <1519877640-11944-1-git-send-email-shankerd@codeaurora.org>
 <20180306134405.GB18080@arm.com>
 <d6182273-c23a-c4fa-ce40-c87055bfb338@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d6182273-c23a-c4fa-ce40-c87055bfb338@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Philip Elcan <pelcan@codeaurora.org>, Vikram Sethi <vikrams@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Robin Murphy <robin.murphy@arm.com>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Shanker,

On Tue, Mar 06, 2018 at 08:47:27AM -0600, Shanker Donthineni wrote:
> On 03/06/2018 07:44 AM, Will Deacon wrote:
> > I think this is a slight asymmetry with the code for the I-side. On the
> > I-side, you hook into invalidate_icache_by_line, whereas on the D-side you
> > hook into the callers of dcache_by_line_op. Why is that?
> > 
> 
> There is no particular reason other than complexity of the macro with another 
> alternative. I tried to avoid this change by updating __clean_dcache_area_pou().
> I can change if you're interested to see both I-Side and D-Side changes are
> symmetric some this like this...
> 
>  .macro dcache_by_line_op op, domain, kaddr, size, tmp1, tmp2
>   
>   .if	(\op == cvau)
>   alternative_if ARM64_HAS_CACHE_IDC
>         dsb	ishst
>         b       9997f
>   alternative_else_nop_endif
>   .endif
> 
> 	dcache_line_size \tmp1, \tmp2
> 	add	\size, \kaddr, \size
> 	sub	\tmp2, \tmp1, #1
> 	bic	\kaddr, \kaddr, \tmp2
>  9998:
> 	.if	(\op == cvau || \op == cvac)
>  alternative_if_not ARM64_WORKAROUND_CLEAN_CACHE
> 	dc	\op, \kaddr
>  alternative_else
> 	dc	civac, \kaddr
>  alternative_endif
> 	.elseif	(\op == cvap)
>  alternative_if ARM64_HAS_DCPOP
> 	sys 3, c7, c12, 1, \kaddr	// dc cvap
>  alternative_else
> 	dc	cvac, \kaddr
>  alternative_endif
> 	.else
> 	dc	\op, \kaddr
> 	.endif
> 	add	\kaddr, \kaddr, \tmp1
> 	cmp	\kaddr, \size
> 	b.lo	9998b
> 	dsb	\domain
> 9997:
> 	.endm

I think it would be cleaner the other way round, actually -- move the check
out of invalidate_icache_by_line and into its two callers.

> > I notice that the only user other than
> > flush_icache_range/__flush_cache_user_range or invalidate_icache_by_line
> > is in KVM, via invalidate_icache_range. If you want to hook in there, why
> > aren't you also patching __flush_icache_all? If so, I'd rather have the
> > I-side code consistent with the D-side code and do this in the handful of
> > callers. We might even be able to elide a branch or two that way.
> > 
> 
> Agree with you, it saves function calls overhead. I'll do this change...
> 
> static void invalidate_icache_guest_page(kvm_pfn_t pfn, unsigned long size)
> {
> 	if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC)
> 	    __invalidate_icache_guest_page(pfn, size);
> }
> 
> 
> > I'm going to assume that I-cache aliases are all coherent if DIC=1, so it's
> > safe to elide our alias sync code.
> > 
> 
> I'm not sure about I-cache whether aliases are all coherent if DIC=1 ot nor.
> Unfortunately I don't have any hardware to test DIC=1. I've verified IDC=1.

I checked with our architects and aliases don't pose a problem here, so you
can ignore me :)

Will
