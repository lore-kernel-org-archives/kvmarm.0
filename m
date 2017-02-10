From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH 2/4] arm64: alternatives: apply boot time fixups via the
 linear mapping
Date: Fri, 10 Feb 2017 18:49:59 +0000
Message-ID: <3176bc0a-3c29-80af-9a1d-f6a35256bb15@arm.com>
References: <1486747005-15973-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486747005-15973-3-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFCFE40A2C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Feb 2017 13:49:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FlumzgMmZUlJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Feb 2017 13:49:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98E4D40A1D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Feb 2017 13:49:26 -0500 (EST)
In-Reply-To: <1486747005-15973-3-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, keescook@chromium.org, labbott@fedoraproject.org, james.morse@arm.com
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kernel-hardening@lists.openwall.com
List-Id: kvmarm@lists.cs.columbia.edu

On 10/02/17 17:16, Ard Biesheuvel wrote:
> One important rule of thumb when designing a secure software system is
> that memory should never be writable and executable at the same time.
> We mostly adhere to this rule in the kernel, except at boot time, when
> regions may be mapped RWX until after we are done applying alternatives
> or making other one-off changes.
>
> For the alternative patching, we can improve the situation by applying
> the fixups via the linear mapping, which is never mapped with executable
> permissions. So map the linear alias of .text with RW- permissions
> initially, and remove the write permissions as soon as alternative
> patching has completed.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/include/asm/mmu.h    |  1 +
>  arch/arm64/kernel/alternative.c |  6 ++---
>  arch/arm64/kernel/smp.c         |  1 +
>  arch/arm64/mm/mmu.c             | 25 ++++++++++++++++----
>  4 files changed, 25 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
> index 47619411f0ff..5468c834b072 100644
> --- a/arch/arm64/include/asm/mmu.h
> +++ b/arch/arm64/include/asm/mmu.h
> @@ -37,5 +37,6 @@ extern void create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
>  			       unsigned long virt, phys_addr_t size,
>  			       pgprot_t prot, bool page_mappings_only);
>  extern void *fixmap_remap_fdt(phys_addr_t dt_phys);
> +extern void mark_linear_text_alias_ro(void);
>
>  #endif
> diff --git a/arch/arm64/kernel/alternative.c b/arch/arm64/kernel/alternative.c
> index 06d650f61da7..eacdbcc45630 100644
> --- a/arch/arm64/kernel/alternative.c
> +++ b/arch/arm64/kernel/alternative.c
> @@ -122,7 +122,7 @@ static void __apply_alternatives(void *alt_region)
>
>  		pr_info_once("patching kernel code\n");
>
> -		origptr = ALT_ORIG_PTR(alt);
> +		origptr = lm_alias(ALT_ORIG_PTR(alt));
>  		replptr = ALT_REPL_PTR(alt);
>  		nr_inst = alt->alt_len / sizeof(insn);

Correct me if I am wrong, I think this would make "get_alt_insn" generate branch
instructions based on the  aliased linear mapped address, which could branch to linear
address of the branch target which doesn't have Execute permissions set.
I think we sould use ALT_ORIG_PTR(alt), instead of origptr for the calls to
get_alt_insn().

Suzuki
