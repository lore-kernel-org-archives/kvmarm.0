Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF236121
	for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 15:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9461BC433AC;
	Wed, 12 Apr 2023 15:47:38 +0000 (UTC)
Date: Wed, 12 Apr 2023 16:47:35 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 01/12] arm64/mm: Update non-range tlb invalidation
 routines for FEAT_LPA2
Message-ID: <ZDbSl8vccLiMCrDz@arm.com>
References: <20230306195438.1557851-1-ryan.roberts@arm.com>
 <20230306195438.1557851-2-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306195438.1557851-2-ryan.roberts@arm.com>

On Mon, Mar 06, 2023 at 07:54:27PM +0000, Ryan Roberts wrote:
> FEAT_LPA2 impacts tlb invalidation in 2 ways; Firstly, the TTL field in
> the non-range tlbi instructions can now validly take a 0 value for the
> 4KB granule (this is due to the extra level of translation). Secondly,
> the BADDR field in the range tlbi instructions must be aligned to 64KB
> when LPA2 is in use (TCR.DS=1). Changes are required for tlbi to
> continue to operate correctly when LPA2 is in use.
> 
> KVM only uses the non-range (__tlbi_level()) routines. Therefore we only
> solve the first problem with this patch.

There are some patches on the list to add support for range invalidation
in KVM:

https://lore.kernel.org/r/20230206172340.2639971-1-rananta@google.com

> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> index 412a3b9a3c25..67dd47df42d5 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -93,19 +93,22 @@ static inline unsigned long get_trans_granule(void)
>   * When ARMv8.4-TTL exists, TLBI operations take an additional hint for
>   * the level at which the invalidation must take place. If the level is
>   * wrong, no invalidation may take place. In the case where the level
> - * cannot be easily determined, a 0 value for the level parameter will
> - * perform a non-hinted invalidation.
> + * cannot be easily determined, the value TLBI_TTL_UNKNOWN will perform
> + * a non-hinted invalidation. Any provided level outside the hint range
> + * will also cause fall-back to non-hinted invalidation.
>   *
>   * For Stage-2 invalidation, use the level values provided to that effect
>   * in asm/stage2_pgtable.h.
>   */
>  #define TLBI_TTL_MASK		GENMASK_ULL(47, 44)
>  
> +#define TLBI_TTL_UNKNOWN	(-1)
> +
>  #define __tlbi_level(op, addr, level) do {				\
>  	u64 arg = addr;							\
>  									\
>  	if (cpus_have_const_cap(ARM64_HAS_ARMv8_4_TTL) &&		\
> -	    level) {							\
> +	    level >= 0 && level <= 3) {					\

I'd just use level != TLBI_TTL_UNKNOWN here.

>  		u64 ttl = level & 3;					\
>  		ttl |= get_trans_granule() << 2;			\
>  		arg &= ~TLBI_TTL_MASK;					\
> @@ -133,16 +136,17 @@ static inline unsigned long get_trans_granule(void)
>   * [BADDR, BADDR + (NUM + 1) * 2^(5*SCALE + 1) * PAGESIZE)
>   *
>   */
> -#define __TLBI_VADDR_RANGE(addr, asid, scale, num, ttl)		\
> -	({							\
> -		unsigned long __ta = (addr) >> PAGE_SHIFT;	\
> -		__ta &= GENMASK_ULL(36, 0);			\
> -		__ta |= (unsigned long)(ttl) << 37;		\
> -		__ta |= (unsigned long)(num) << 39;		\
> -		__ta |= (unsigned long)(scale) << 44;		\
> -		__ta |= get_trans_granule() << 46;		\
> -		__ta |= (unsigned long)(asid) << 48;		\
> -		__ta;						\
> +#define __TLBI_VADDR_RANGE(addr, asid, scale, num, ttl)				\
> +	({									\
> +		unsigned long __ta = (addr) >> PAGE_SHIFT;			\
> +		unsigned long __ttl = (ttl >= 1 && ttl <= 3) ? ttl : 0;		\

And here, set __ttl to 0 if TLBI_TTL_UNKNOWN.

Otherwise it looks fine:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
