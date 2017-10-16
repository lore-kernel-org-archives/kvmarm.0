From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 02/10] arm64: KVM: Add invalidate_icache_range helper
Date: Mon, 16 Oct 2017 22:08:53 +0200
Message-ID: <20171016200853.GM1845@lvm>
References: <20171009152032.27804-1-marc.zyngier@arm.com>
 <20171009152032.27804-3-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1761A41185
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 16:08:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id boZ8H0f8aEug for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Oct 2017 16:08:00 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A37D49D09
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 16:08:00 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id t69so6260795wmt.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 13:08:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20171009152032.27804-3-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 09, 2017 at 04:20:24PM +0100, Marc Zyngier wrote:
> We currently tightly couple dcache clean with icache invalidation,
> but KVM could do without the initial flush to PoU, as we've
> already flushed things to PoC.
> 
> Let's introduce invalidate_icache_range which is limited to
> invalidating the icache from the linear mapping (and thus
> has none of the userspace fault handling complexity), and
> wire it in KVM instead of flush_icache_range.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/cacheflush.h |  8 ++++++++
>  arch/arm64/include/asm/kvm_mmu.h    |  4 ++--
>  arch/arm64/mm/cache.S               | 24 ++++++++++++++++++++++++
>  3 files changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/cacheflush.h b/arch/arm64/include/asm/cacheflush.h
> index 76d1cc85d5b1..ad56406944c6 100644
> --- a/arch/arm64/include/asm/cacheflush.h
> +++ b/arch/arm64/include/asm/cacheflush.h
> @@ -52,6 +52,13 @@
>   *		- start  - virtual start address
>   *		- end    - virtual end address
>   *
> + *	invalidate_icache_range(start, end)
> + *
> + *		Invalidate the I-cache in the region described by start, end.
> + *		Linear mapping only!
> + *		- start  - virtual start address
> + *		- end    - virtual end address
> + *
>   *	__flush_cache_user_range(start, end)
>   *
>   *		Ensure coherency between the I-cache and the D-cache in the
> @@ -66,6 +73,7 @@
>   *		- size   - region size
>   */
>  extern void flush_icache_range(unsigned long start, unsigned long end);
> +extern void invalidate_icache_range(unsigned long start, unsigned long end);
>  extern void __flush_dcache_area(void *addr, size_t len);
>  extern void __inval_dcache_area(void *addr, size_t len);
>  extern void __clean_dcache_area_poc(void *addr, size_t len);
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 4c4cb4f0e34f..48d31ca2ce9c 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -250,8 +250,8 @@ static inline void __coherent_icache_guest_page(struct kvm_vcpu *vcpu,
>  		/* PIPT or VPIPT at EL2 (see comment in __kvm_tlb_flush_vmid_ipa) */
>  		void *va = page_address(pfn_to_page(pfn));
>  
> -		flush_icache_range((unsigned long)va,
> -				   (unsigned long)va + size);
> +		invalidate_icache_range((unsigned long)va,
> +					(unsigned long)va + size);
>  	}
>  }
>  
> diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
> index 7f1dbe962cf5..0c330666a8c9 100644
> --- a/arch/arm64/mm/cache.S
> +++ b/arch/arm64/mm/cache.S
> @@ -80,6 +80,30 @@ USER(9f, ic	ivau, x4	)		// invalidate I line PoU
>  ENDPROC(flush_icache_range)
>  ENDPROC(__flush_cache_user_range)
>  
> +/*
> + *	invalidate_icache_range(start,end)
> + *
> + *	Ensure that the I cache is invalid within specified region. This
> + *	assumes that this is done on the linear mapping. Do not use it
> + *	on a userspace range, as this may fault horribly.
> + *
> + *	- start   - virtual start address of region
> + *	- end     - virtual end address of region
> + */
> +ENTRY(invalidate_icache_range)
> +	icache_line_size x2, x3
> +	sub	x3, x2, #1
> +	bic	x4, x0, x3
> +1:
> +	ic	ivau, x4			// invalidate I line PoU
> +	add	x4, x4, x2
> +	cmp	x4, x1
> +	b.lo	1b
> +	dsb	ish
> +	isb
> +	ret
> +ENDPROC(invalidate_icache_range)
> +
>  /*
>   *	__flush_dcache_area(kaddr, size)
>   *
> -- 
> 2.14.1
> 

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
