From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 03/15] arm64: Introduce helpers for page table levels
Date: Wed, 7 Oct 2015 10:26:52 +0200
Message-ID: <20151007082652.GM9011@cbox>
References: <1442331684-28818-1-git-send-email-suzuki.poulose@arm.com>
 <1442331684-28818-4-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 787154130A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Oct 2015 04:24:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5gNL3QejKrrb for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Oct 2015 04:24:45 -0400 (EDT)
Received: from mail-la0-f46.google.com (mail-la0-f46.google.com
 [209.85.215.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 662F4412F3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Oct 2015 04:24:45 -0400 (EDT)
Received: by lacdq7 with SMTP id dq7so5601261lac.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Oct 2015 01:26:40 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1442331684-28818-4-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, ard.biesheuvel@linaro.org, Marc.Zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,

On Tue, Sep 15, 2015 at 04:41:12PM +0100, Suzuki K. Poulose wrote:
> From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
> 
> Introduce helpers for finding the number of page table
> levels required for a given VA width, shift for a particular
> page table level.
> 
> Convert the existing users to the new helpers. More users
> to follow.
> 
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
> Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/include/asm/pgtable-hwdef.h |   15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
> index 24154b0..ce18389 100644
> --- a/arch/arm64/include/asm/pgtable-hwdef.h
> +++ b/arch/arm64/include/asm/pgtable-hwdef.h
> @@ -16,13 +16,21 @@
>  #ifndef __ASM_PGTABLE_HWDEF_H
>  #define __ASM_PGTABLE_HWDEF_H
>  
> +/*
> + * Number of page-table levels required to address 'va_bits' wide
> + * address, without section mapping
> + */
> +#define ARM64_HW_PGTABLE_LEVELS(va_bits) (((va_bits) - 4) / (PAGE_SHIFT - 3))

I don't understand the '(va_bits) - 4' here, can you explain it (and add a
comment to that effect) ?

> +#define ARM64_HW_PGTABLE_LEVEL_SHIFT(level) \
> +		((PAGE_SHIFT - 3) * (level) + 3)
> +

While this change is clearly correct, if you can explain the math here
in a comment as well, that would be helpful.

Thanks,
-Christoffer

>  #define PTRS_PER_PTE		(1 << (PAGE_SHIFT - 3))
>  
>  /*
>   * PMD_SHIFT determines the size a level 2 page table entry can map.
>   */
>  #if CONFIG_PGTABLE_LEVELS > 2
> -#define PMD_SHIFT		((PAGE_SHIFT - 3) * 2 + 3)
> +#define PMD_SHIFT		ARM64_HW_PGTABLE_LEVEL_SHIFT(2)
>  #define PMD_SIZE		(_AC(1, UL) << PMD_SHIFT)
>  #define PMD_MASK		(~(PMD_SIZE-1))
>  #define PTRS_PER_PMD		PTRS_PER_PTE
> @@ -32,7 +40,7 @@
>   * PUD_SHIFT determines the size a level 1 page table entry can map.
>   */
>  #if CONFIG_PGTABLE_LEVELS > 3
> -#define PUD_SHIFT		((PAGE_SHIFT - 3) * 3 + 3)
> +#define PUD_SHIFT		ARM64_HW_PGTABLE_LEVEL_SHIFT(3)
>  #define PUD_SIZE		(_AC(1, UL) << PUD_SHIFT)
>  #define PUD_MASK		(~(PUD_SIZE-1))
>  #define PTRS_PER_PUD		PTRS_PER_PTE
> @@ -42,7 +50,8 @@
>   * PGDIR_SHIFT determines the size a top-level page table entry can map
>   * (depending on the configuration, this level can be 0, 1 or 2).
>   */
> -#define PGDIR_SHIFT		((PAGE_SHIFT - 3) * CONFIG_PGTABLE_LEVELS + 3)
> +#define PGDIR_SHIFT	\
> +		ARM64_HW_PGTABLE_LEVEL_SHIFT(CONFIG_PGTABLE_LEVELS)
>  #define PGDIR_SIZE		(_AC(1, UL) << PGDIR_SHIFT)
>  #define PGDIR_MASK		(~(PGDIR_SIZE-1))
>  #define PTRS_PER_PGD		(1 << (VA_BITS - PGDIR_SHIFT))
> -- 
> 1.7.9.5
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
