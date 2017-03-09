From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 07/10] arm64/mmu: ignore debug_pagealloc for kernel
 segments
Date: Thu, 9 Mar 2017 17:51:17 +0000
Message-ID: <20170309175116.GD11966@leverpostej>
References: <1489047912-642-1-git-send-email-ard.biesheuvel@linaro.org>
 <1489047912-642-8-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84A54408EB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 12:50:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fIV-aIasRTlQ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Mar 2017 12:50:04 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BB8B40625
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 12:50:04 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1489047912-642-8-git-send-email-ard.biesheuvel@linaro.org>
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

On Thu, Mar 09, 2017 at 09:25:09AM +0100, Ard Biesheuvel wrote:
> The debug_pagealloc facility manipulates kernel mappings in the linear
> region at page granularity to detect out of bounds or use-after-free
> accesses. Since the kernel segments are not allocated dynamically,
> there is no point in taking the debug_pagealloc_enabled flag into
> account for them, and we can use block mappings unconditionally.
> 
> Note that this applies equally to the linear alias of text/rodata:
> we will never have dynamic allocations there given that the same
> memory is statically in use by the kernel image.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

This makes sense to me, and I haven't found anything this breaks.

It may be worth noting that a similar reasoning already applies the the
FDT mapping, where we use create_mapping_noalloc(), and never mandate
page mappings.

Regardless:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/mm/mmu.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index c3963c592ec3..d3fecd20a136 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -328,8 +328,7 @@ static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
>  		return;
>  	}
>  
> -	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot,
> -			     NULL, debug_pagealloc_enabled());
> +	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL, false);
>  
>  	/* flush the TLBs after updating live kernel mappings */
>  	flush_tlb_kernel_range(virt, virt + size);
> @@ -381,7 +380,7 @@ static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end
>  	 */
>  	__create_pgd_mapping(pgd, kernel_start, __phys_to_virt(kernel_start),
>  			     kernel_end - kernel_start, PAGE_KERNEL,
> -			     early_pgtable_alloc, debug_pagealloc_enabled());
> +			     early_pgtable_alloc, false);
>  }
>  
>  void __init mark_linear_text_alias_ro(void)
> @@ -437,7 +436,7 @@ static void __init map_kernel_segment(pgd_t *pgd, void *va_start, void *va_end,
>  	BUG_ON(!PAGE_ALIGNED(size));
>  
>  	__create_pgd_mapping(pgd, pa_start, (unsigned long)va_start, size, prot,
> -			     early_pgtable_alloc, debug_pagealloc_enabled());
> +			     early_pgtable_alloc, false);
>  
>  	vma->addr	= va_start;
>  	vma->phys_addr	= pa_start;
> -- 
> 2.7.4
> 
