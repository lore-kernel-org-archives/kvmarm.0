From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 2/5] arm64: mmu: move TLB maintenance from callers to
 create_mapping_late()
Date: Tue, 14 Feb 2017 15:54:36 +0000
Message-ID: <20170214155436.GC23718@leverpostej>
References: <1486844586-26135-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486844586-26135-3-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30C7A40992
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Feb 2017 10:54:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UfgWakgdXiYq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Feb 2017 10:53:59 -0500 (EST)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01on0072.outbound.protection.outlook.com [104.47.0.72])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A98440064
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Feb 2017 10:53:59 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1486844586-26135-3-git-send-email-ard.biesheuvel@linaro.org>
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
Cc: keescook@chromium.org, marc.zyngier@arm.com, catalin.marinas@arm.com, kernel-hardening@lists.openwall.com, will.deacon@arm.com, andre.przywara@arm.com, nd@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, labbott@fedoraproject.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Feb 11, 2017 at 08:23:03PM +0000, Ard Biesheuvel wrote:
> In preparation of changing the way we invoke create_mapping_late() (which
> is currently invoked twice from the same function), move the TLB flushing
> it performs from the caller into create_mapping_late() itself, and change
> it to a TLB maintenance by VA rather than a full flush, which is more
> appropriate here.

It's not immediately clear what's meant by "changing the way we invoke
create_mapping_late()" here.

It's probably worth explicitly mentioning that we need to add another
caller of create_mapping_late(), and this saves us adding (overly
strong) TLB maintenance to all callers.

> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/mm/mmu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 2131521ddc24..9e0ec1a8cd3b 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -356,6 +356,9 @@ static void create_mapping_late(phys_addr_t phys, unsigned long virt,
>  
>  	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot,
>  			     NULL, debug_pagealloc_enabled());
> +
> +	/* flush the TLBs after updating live kernel mappings */
> +	flush_tlb_kernel_range(virt, virt + size);
>  }

It feels  a little odd to have the maintenance here given we still call
this *create*_mapping_late.

Given the only users of this are changing permissions, perhaps we should
rename this to change_mapping_prot(), or something like that?

Otherwise, this looks fine to me, and boots fine. Either way:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.

>  static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end)
> @@ -438,9 +441,6 @@ void mark_rodata_ro(void)
>  	create_mapping_late(__pa_symbol(__start_rodata), (unsigned long)__start_rodata,
>  			    section_size, PAGE_KERNEL_RO);
>  
> -	/* flush the TLBs after updating live kernel mappings */
> -	flush_tlb_all();
> -
>  	debug_checkwx();
>  }
>  
> -- 
> 2.7.4
> 
