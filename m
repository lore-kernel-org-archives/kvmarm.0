From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v7] arm64: Add support for new control bits CTR_EL0.DIC
 and CTR_EL0.IDC
Date: Fri, 9 Mar 2018 13:44:40 +0000
Message-ID: <20180309134439.76b43chxnrw7okrw@lakrids.cambridge.arm.com>
References: <1520434808-29703-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1520434808-29703-1-git-send-email-shankerd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Will Deacon <will.deacon@arm.com>, Robin Murphy <robin.murphy@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>, Vikram Sethi <vikrams@codeaurora.org>, Philip Elcan <pelcan@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 07, 2018 at 09:00:08AM -0600, Shanker Donthineni wrote:
>  static inline void __flush_icache_all(void)
>  {
> -	asm("ic	ialluis");
> -	dsb(ish);
> +	/* Instruction cache invalidation is not required for I/D coherence? */
> +	if (!cpus_have_const_cap(ARM64_HAS_CACHE_DIC)) {
> +		asm("ic	ialluis");
> +		dsb(ish);
> +	}
>  }

I don't think we need the comment here. We don't have this in the other
cases we look at the ARM64_HAS_CACHE_{IDC,DIC} caps.

This would also be slightly nicer as an early return:

static inline void __flush_icache_all(void)
{
	if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC))
		return;
	
	asm("ic ialluis");
	dsb(ish);
}

... which minimizes indentation, and the diffstat.

The rest looks fine to me, so with the above changes:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.
