From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 08/10] arm64/mmu: add contiguous bit to sanity bug check
Date: Thu, 9 Mar 2017 18:04:06 +0000
Message-ID: <20170309180406.GE11966@leverpostej>
References: <1489047912-642-1-git-send-email-ard.biesheuvel@linaro.org>
 <1489047912-642-9-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6260240A7B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 13:02:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ljHj5LH74UOe for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Mar 2017 13:02:54 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AE8B40625
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 13:02:53 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1489047912-642-9-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: keescook@chromium.org, kernel-hardening@lists.openwall.com, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, labbott@fedoraproject.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 09, 2017 at 09:25:10AM +0100, Ard Biesheuvel wrote:
> A mapping with the contiguous bit cannot be safely manipulated while
> live, regardless of whether the bit changes between the old and new
> mapping. So take this into account when deciding whether the change
> is safe.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Strictly speaking, I think this is marginally more stringent than what
the ARM ARM describes. My reading is that the "Misprogramming of the
Contiguous bit" rules only apply when there are multiple valid entries,
and hence if you had a contiguous span with only a single valid entry
(and TLBs up-to-date), you could modify that in-place so long as you
followed the usual BBM rules.

However, I don't see us ever (deliberately) doing that, given it would
require more work, and there's no guarantee that the CPU would consider
the whole span as being mapped. It's also possible my reading of the ARM
ARM is flawed.

Thanks,
Mark.

> ---
>  arch/arm64/mm/mmu.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index d3fecd20a136..a6d7a86dd2b8 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -103,7 +103,15 @@ static bool pgattr_change_is_safe(u64 old, u64 new)
>  	 */
>  	static const pteval_t mask = PTE_PXN | PTE_RDONLY | PTE_WRITE;
>  
> -	return old  == 0 || new  == 0 || ((old ^ new) & ~mask) == 0;
> +	/* creating or taking down mappings is always safe */
> +	if (old == 0 || new == 0)
> +		return true;
> +
> +	/* live contiguous mappings may not be manipulated at all */
> +	if ((old | new) & PTE_CONT)
> +		return false;
> +
> +	return ((old ^ new) & ~mask) == 0;
>  }
>  
>  static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
> -- 
> 2.7.4
> 
