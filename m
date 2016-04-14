From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 07/17] kvm-arm: arm32: Introduce stage2 page table
 helpers
Date: Thu, 14 Apr 2016 15:22:58 +0100
Message-ID: <570FA7C2.1090902@arm.com>
References: <1460640065-27658-1-git-send-email-suzuki.poulose@arm.com>
 <1460640065-27658-8-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BF9849BC5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 10:21:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YYoS++Clv3Fm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Apr 2016 10:21:18 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B36A449BC4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 10:21:18 -0400 (EDT)
In-Reply-To: <1460640065-27658-8-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 14/04/16 14:20, Suzuki K Poulose wrote:
> Define the page table helpers for walking the stage2 pagetable
> for arm. Since both hyp and stage2 have the same number of levels,
> as that of the host we reuse the host helpers.
> 
> The exceptions are the p.d_addr_end routines which have to deal
> with IPA > 32bit, hence we use the open coded version of their host helpers
> which supports 64bit.
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> Changes since v1:
>   - Drop mm (which is always NULL) parameter to stage2_p.d_xxx. Pass NULL
>     explicitly to the host helpers.
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
> index 0000000..5b61196
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
> +#define stage2_pgd_none(pgd)			pgd_none(pgd)
> +#define stage2_pgd_clear(pgd)			pgd_clear(pgd)
> +#define stage2_pgd_present(pgd)			pgd_present(pgd)
> +#define stage2_pgd_populate(pgd, pud)		pgd_populate(NULL, pgd, pud)
> +#define stage2_pud_offset(pgd, address)		pud_offset(pgd, address)
> +#define stage2_pud_free(pud)			pud_free(NULL, pud)
> +
> +#define stage2_pud_none(pud)			pud_none(pud)
> +#define stage2_pud_clear(pud)			pud_clear(pud)
> +#define stage2_pud_present(pud)			pud_present(pud)
> +#define stage2_pud_populate(pud, pmd)		pud_populate(NULL, pud, pmd)
> +#define stage2_pmd_offset(pud, address)		pmd_offset(pud, address)
> +#define stage2_pmd_free(pmd)			pmd_free(NULL, pmd)
> +
> +#define stage2_pud_huge(pud)			pud_huge(pud)
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

nit: given that the kvm_page_empty returns a boolean, I'd have defined
this to 'false' instead of zero. No need to respin for this though.

Another concern is that while stage2_* looks pretty generic, the
implementation is very KVM specific. As long as KVM is the only
in-kernel hypervisor, it doesn't matter.

> +
> +#endif	/* __ARM_S2_PGTABLE_H_ */
> 

Irrespective of the above:

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
