From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 07/17] kvm-arm: arm32: Introduce stage2 page table helpers
Date: Fri, 8 Apr 2016 14:43:32 +0200
Message-ID: <20160408124332.GL8961@cbox>
References: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
 <1459787177-12767-8-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99DE240F90
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 08:41:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7rr32KYE+ilX for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2016 08:41:54 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 970B64053F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 08:41:54 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id 191so17108929wmq.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2016 05:43:21 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1459787177-12767-8-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 04, 2016 at 05:26:07PM +0100, Suzuki K Poulose wrote:
> Define the page table helpers for walking the stage2 pagetable
> for arm. Since both hyp and stage2 have the same number of levels,
> as that of the host we reuse the host helpers.
> 
> The exceptions are the p.d_addr_end routines which have to deal
> with IPA > 32bit, hence we use the open coded version of their host helpers
> which supports 64bit.
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm/include/asm/kvm_mmu.h        |    1 +
>  arch/arm/include/asm/stage2_pgtable.h |   59 +++++++++++++++++++++++++++++++++
>  2 files changed, 60 insertions(+)
>  create mode 100644 arch/arm/include/asm/stage2_pgtable.h
> 
> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index c2b2b27..7d207b4 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -47,6 +47,7 @@
>  #include <linux/highmem.h>
>  #include <asm/cacheflush.h>
>  #include <asm/pgalloc.h>
> +#include <asm/stage2_pgtable.h>
>  
>  int create_hyp_mappings(void *from, void *to);
>  int create_hyp_io_mappings(void *from, void *to, phys_addr_t);
> diff --git a/arch/arm/include/asm/stage2_pgtable.h b/arch/arm/include/asm/stage2_pgtable.h
> new file mode 100644
> index 0000000..7633b0a
> --- /dev/null
> +++ b/arch/arm/include/asm/stage2_pgtable.h
> @@ -0,0 +1,59 @@
> +/*
> + * Copyright (C) 2016 - ARM Ltd
> + *
> + * stage2 page table helpers
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef __ARM_S2_PGTABLE_H_
> +#define __ARM_S2_PGTABLE_H_
> +
> +#define stage2_pgd_none(pgd)				pgd_none(pgd)
> +#define stage2_pgd_clear(pgd)				pgd_clear(pgd)
> +#define stage2_pgd_present(pgd)				pgd_present(pgd)
> +#define stage2_pgd_populate(mm, pgd, pud)		pgd_populate(mm, pgd, pud)
> +#define stage2_pud_offset(pgd, address)			pud_offset(pgd, address)
> +#define stage2_pud_free(mm, pud)			pud_free(mm, pud)
> +
> +#define stage2_pud_none(pud)				pud_none(pud)
> +#define stage2_pud_clear(pud)				pud_clear(pud)
> +#define stage2_pud_present(pud)				pud_present(pud)
> +#define stage2_pud_populate(mm, pud, pmd)		pud_populate(mm, pud, pmd)
> +#define stage2_pmd_offset(pud, address)			pmd_offset(pud, address)
> +#define stage2_pmd_free(mm, pmd)			pmd_free(mm, pmd)
> +
> +#define stage2_pud_huge(pud)				pud_huge(pud)

could we get rid of the mm parameter to all these stage2_ versions above
and simply implement them with the generic functions passing NULL in the
definitions instead?

> +
> +/* Open coded p*d_addr_end that can deal with 64bit addresses */
> +static inline phys_addr_t stage2_pgd_addr_end(phys_addr_t addr, phys_addr_t end)
> +{
> +	phys_addr_t boundary = (addr + PGDIR_SIZE) & PGDIR_MASK;
> +	return (boundary - 1 < end - 1) ? boundary : end;
> +}
> +
> +#define stage2_pud_addr_end(addr, end)		(end)
> +
> +static inline phys_addr_t stage2_pmd_addr_end(phys_addr_t addr, phys_addr_t end)
> +{
> +	phys_addr_t boundary = (addr + PMD_SIZE) & PMD_MASK;
> +	return (boundary - 1 < end - 1) ? boundary : end;
> +}
> +
> +#define stage2_pgd_index(addr)				pgd_index(addr)
> +
> +#define stage2_pte_table_empty(ptep)			kvm_page_empty(ptep)
> +#define stage2_pmd_table_empty(pmdp)			kvm_page_empty(pmdp)
> +#define stage2_pud_table_empty(pudp)			0
> +
> +#endif	/* __ARM_S2_PGTABLE_H_ */
> -- 
> 1.7.9.5
> 

Otherwise:
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
