Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F3F4C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 28 Jan 2022 16:09:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 052504B1C7;
	Fri, 28 Jan 2022 11:09:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oeliumTF0eEW; Fri, 28 Jan 2022 11:08:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01CA84B1DB;
	Fri, 28 Jan 2022 11:08:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09F714B1CB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jan 2022 11:08:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d1VPh-6CRSUH for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Jan 2022 11:08:54 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7B674B1C7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jan 2022 11:08:54 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AEF7D113E;
 Fri, 28 Jan 2022 08:08:53 -0800 (PST)
Received: from [10.57.13.224] (unknown [10.57.13.224])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE1693F793;
 Fri, 28 Jan 2022 08:08:51 -0800 (PST)
Message-ID: <65e1ae7d-44ae-a19f-e193-583590cfa0c3@arm.com>
Date: Fri, 28 Jan 2022 16:08:50 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH 03/12] arm64: mm: use a fixmap slot for user page
 table modifications
Content-Language: en-GB
To: Ard Biesheuvel <ardb@kernel.org>, linux-arm-kernel@lists.infradead.org
References: <20220126173011.3476262-1-ardb@kernel.org>
 <20220126173011.3476262-4-ardb@kernel.org>
From: Steven Price <steven.price@arm.com>
In-Reply-To: <20220126173011.3476262-4-ardb@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, linux-hardening@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Ard,

Interesting series - I attempted[1] something similar a few years ago,
but only dealing with the page tables in the linear map.

At first glace the series looks like it should work, but this patch
caught my eye because there's only a single fixmap slot for page table
modifications. The upshot of which is you need the patch_pte_lock
serialising multiple CPUs' access to the page tables. Which looks like
it would hurt badly as the number of CPUs grows.

Do you have any benchmarks of the performance? I've lost any I did at
the time I previously looked at this idea but obviously thought it was
important at the time.

Thanks,

Steve

[1]
https://lore.kernel.org/lkml/20200417152619.41680-1-steven.price@arm.com/

On 26/01/2022 17:30, Ard Biesheuvel wrote:
> To prepare for user and kernel page tables being remapped read-only in
> the linear region, define a new fixmap slot and use it to apply all page
> table descriptor updates that target page tables other than swapper.
> 
> Fortunately for us, the fixmap descriptors themselves are always
> manipulated via their kernel mapping in .bss, so there is no special
> exception required to avoid circular logic here.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/Kconfig               |  11 +++
>  arch/arm64/include/asm/fixmap.h  |   1 +
>  arch/arm64/include/asm/pgalloc.h |  28 +++++-
>  arch/arm64/include/asm/pgtable.h |  79 +++++++++++++---
>  arch/arm64/mm/Makefile           |   2 +
>  arch/arm64/mm/fault.c            |   8 +-
>  arch/arm64/mm/ro_page_tables.c   | 100 ++++++++++++++++++++
>  7 files changed, 209 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 6978140edfa4..a3e98286b074 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1311,6 +1311,17 @@ config RODATA_FULL_DEFAULT_ENABLED
>  	  This requires the linear region to be mapped down to pages,
>  	  which may adversely affect performance in some cases.
>  
> +config ARM64_RO_PAGE_TABLES
> +	bool "Remap page tables read-only in the kernel VA space"
> +	select RODATA_FULL_DEFAULT_ENABLED
> +	help
> +	  Remap linear mappings of page table pages read-only as long as they
> +	  are being used as such, and use a fixmap API to manipulate all page
> +	  table descriptors, instead of manipulating them directly via their
> +	  writable mappings in the direct map. This is intended as a debug
> +	  and/or hardening feature, as it removes the ability for stray writes
> +	  to be exploited to bypass permission restrictions.
> +
>  config ARM64_SW_TTBR0_PAN
>  	bool "Emulate Privileged Access Never using TTBR0_EL1 switching"
>  	help
> diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
> index 4335800201c9..71dfbe0452bb 100644
> --- a/arch/arm64/include/asm/fixmap.h
> +++ b/arch/arm64/include/asm/fixmap.h
> @@ -50,6 +50,7 @@ enum fixed_addresses {
>  
>  	FIX_EARLYCON_MEM_BASE,
>  	FIX_TEXT_POKE0,
> +	FIX_TEXT_POKE_PTE,
>  
>  #ifdef CONFIG_ACPI_APEI_GHES
>  	/* Used for GHES mapping from assorted contexts */
> diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/pgalloc.h
> index 237224484d0f..d54ac9f8d6c7 100644
> --- a/arch/arm64/include/asm/pgalloc.h
> +++ b/arch/arm64/include/asm/pgalloc.h
> @@ -30,7 +30,11 @@ static inline void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmdp)
>  	pudval_t pudval = PUD_TYPE_TABLE;
>  
>  	pudval |= (mm == &init_mm) ? PUD_TABLE_UXN : PUD_TABLE_PXN;
> -	__pud_populate(pudp, __pa(pmdp), pudval);
> +	if (page_tables_are_ro())
> +		xchg_ro_pte(mm, (pte_t *)pudp,
> +			    __pte(__phys_to_pud_val(__pa(pmdp) | pudval)));
> +	else
> +		__pud_populate(pudp, __pa(pmdp), pudval);
>  }
>  #else
>  static inline void __pud_populate(pud_t *pudp, phys_addr_t pmdp, pudval_t prot)
> @@ -51,7 +55,11 @@ static inline void p4d_populate(struct mm_struct *mm, p4d_t *p4dp, pud_t *pudp)
>  	p4dval_t p4dval = P4D_TYPE_TABLE;
>  
>  	p4dval |= (mm == &init_mm) ? P4D_TABLE_UXN : P4D_TABLE_PXN;
> -	__p4d_populate(p4dp, __pa(pudp), p4dval);
> +	if (page_tables_are_ro())
> +		xchg_ro_pte(mm, (pte_t *)p4dp,
> +			    __pte(__phys_to_p4d_val(__pa(pudp) | p4dval)));
> +	else
> +		__p4d_populate(p4dp, __pa(pudp), p4dval);
>  }
>  #else
>  static inline void __p4d_populate(p4d_t *p4dp, phys_addr_t pudp, p4dval_t prot)
> @@ -76,15 +84,27 @@ static inline void __pmd_populate(pmd_t *pmdp, phys_addr_t ptep,
>  static inline void
>  pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmdp, pte_t *ptep)
>  {
> +	pmdval_t pmdval = PMD_TYPE_TABLE | PMD_TABLE_UXN;
> +
>  	VM_BUG_ON(mm && mm != &init_mm);
> -	__pmd_populate(pmdp, __pa(ptep), PMD_TYPE_TABLE | PMD_TABLE_UXN);
> +	if (page_tables_are_ro())
> +		xchg_ro_pte(mm, (pte_t *)pmdp,
> +			    __pte(__phys_to_pmd_val(__pa(ptep) | pmdval)));
> +	else
> +		__pmd_populate(pmdp, __pa(ptep), pmdval);
>  }
>  
>  static inline void
>  pmd_populate(struct mm_struct *mm, pmd_t *pmdp, pgtable_t ptep)
>  {
> +	pmdval_t pmdval = PMD_TYPE_TABLE | PMD_TABLE_PXN;
> +
>  	VM_BUG_ON(mm == &init_mm);
> -	__pmd_populate(pmdp, page_to_phys(ptep), PMD_TYPE_TABLE | PMD_TABLE_PXN);
> +	if (page_tables_are_ro())
> +		xchg_ro_pte(mm, (pte_t *)pmdp,
> +			    __pte(__phys_to_pmd_val(page_to_phys(ptep) | pmdval)));
> +	else
> +		__pmd_populate(pmdp, page_to_phys(ptep), pmdval);
>  }
>  
>  #endif
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 8d3806c68687..a8daea6b4ac9 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -30,6 +30,7 @@
>  
>  #include <asm/cmpxchg.h>
>  #include <asm/fixmap.h>
> +#include <linux/jump_label.h>
>  #include <linux/mmdebug.h>
>  #include <linux/mm_types.h>
>  #include <linux/sched.h>
> @@ -37,6 +38,17 @@
>  int set_pgtable_ro(void *addr);
>  int set_pgtable_rw(void *addr);
>  
> +DECLARE_STATIC_KEY_FALSE(ro_page_tables);
> +
> +static inline bool page_tables_are_ro(void)
> +{
> +	return IS_ENABLED(CONFIG_ARM64_RO_PAGE_TABLES) &&
> +	       static_branch_unlikely(&ro_page_tables);
> +}
> +
> +pte_t xchg_ro_pte(struct mm_struct *mm, pte_t *ptep, pte_t pte);
> +pte_t cmpxchg_ro_pte(struct mm_struct *mm, pte_t *ptep, pte_t old, pte_t new);
> +
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
>  
> @@ -89,7 +101,7 @@ static inline pteval_t __phys_to_pte_val(phys_addr_t phys)
>  	__pte(__phys_to_pte_val((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
>  
>  #define pte_none(pte)		(!pte_val(pte))
> -#define pte_clear(mm,addr,ptep)	set_pte(ptep, __pte(0))
> +#define pte_clear(mm,addr,ptep)	set_pte_at(mm, addr, ptep, __pte(0))
>  #define pte_page(pte)		(pfn_to_page(pte_pfn(pte)))
>  
>  /*
> @@ -257,7 +269,10 @@ static inline pte_t pte_mkdevmap(pte_t pte)
>  
>  static inline void set_pte(pte_t *ptep, pte_t pte)
>  {
> -	WRITE_ONCE(*ptep, pte);
> +	if (page_tables_are_ro())
> +		xchg_ro_pte(&init_mm, ptep, pte);
> +	else
> +		WRITE_ONCE(*ptep, pte);
>  
>  	/*
>  	 * Only if the new pte is valid and kernel, otherwise TLB maintenance
> @@ -343,7 +358,10 @@ static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
>  
>  	__check_racy_pte_update(mm, ptep, pte);
>  
> -	set_pte(ptep, pte);
> +	if (page_tables_are_ro())
> +		xchg_ro_pte(mm, ptep, pte);
> +	else
> +		set_pte(ptep, pte);
>  }
>  
>  /*
> @@ -579,7 +597,10 @@ static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
>  	}
>  #endif /* __PAGETABLE_PMD_FOLDED */
>  
> -	WRITE_ONCE(*pmdp, pmd);
> +	if (page_tables_are_ro())
> +		xchg_ro_pte(&init_mm, (pte_t *)pmdp, pmd_pte(pmd));
> +	else
> +		WRITE_ONCE(*pmdp, pmd);
>  
>  	if (pmd_valid(pmd)) {
>  		dsb(ishst);
> @@ -589,7 +610,10 @@ static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
>  
>  static inline void pmd_clear(pmd_t *pmdp)
>  {
> -	set_pmd(pmdp, __pmd(0));
> +	if (page_tables_are_ro())
> +		xchg_ro_pte(NULL, (pte_t *)pmdp, __pte(0));
> +	else
> +		set_pmd(pmdp, __pmd(0));
>  }
>  
>  static inline phys_addr_t pmd_page_paddr(pmd_t pmd)
> @@ -640,7 +664,10 @@ static inline void set_pud(pud_t *pudp, pud_t pud)
>  	}
>  #endif /* __PAGETABLE_PUD_FOLDED */
>  
> -	WRITE_ONCE(*pudp, pud);
> +	if (page_tables_are_ro())
> +		xchg_ro_pte(&init_mm, (pte_t *)pudp, pud_pte(pud));
> +	else
> +		WRITE_ONCE(*pudp, pud);
>  
>  	if (pud_valid(pud)) {
>  		dsb(ishst);
> @@ -650,7 +677,10 @@ static inline void set_pud(pud_t *pudp, pud_t pud)
>  
>  static inline void pud_clear(pud_t *pudp)
>  {
> -	set_pud(pudp, __pud(0));
> +	if (page_tables_are_ro())
> +		xchg_ro_pte(NULL, (pte_t *)pudp, __pte(0));
> +	else
> +		set_pud(pudp, __pud(0));
>  }
>  
>  static inline phys_addr_t pud_page_paddr(pud_t pud)
> @@ -704,14 +734,20 @@ static inline void set_p4d(p4d_t *p4dp, p4d_t p4d)
>  		return;
>  	}
>  
> -	WRITE_ONCE(*p4dp, p4d);
> +	if (page_tables_are_ro())
> +		xchg_ro_pte(&init_mm, (pte_t *)p4dp, p4d_pte(p4d));
> +	else
> +		WRITE_ONCE(*p4dp, p4d);
>  	dsb(ishst);
>  	isb();
>  }
>  
>  static inline void p4d_clear(p4d_t *p4dp)
>  {
> -	set_p4d(p4dp, __p4d(0));
> +	if (page_tables_are_ro())
> +		xchg_ro_pte(NULL, (pte_t *)p4dp, __pte(0));
> +	else
> +		set_p4d(p4dp, __p4d(0));
>  }
>  
>  static inline phys_addr_t p4d_page_paddr(p4d_t p4d)
> @@ -806,7 +842,7 @@ static inline int pgd_devmap(pgd_t pgd)
>   * Atomic pte/pmd modifications.
>   */
>  #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
> -static inline int __ptep_test_and_clear_young(pte_t *ptep)
> +static inline int __ptep_test_and_clear_young(struct mm_struct *mm, pte_t *ptep)
>  {
>  	pte_t old_pte, pte;
>  
> @@ -814,8 +850,13 @@ static inline int __ptep_test_and_clear_young(pte_t *ptep)
>  	do {
>  		old_pte = pte;
>  		pte = pte_mkold(pte);
> -		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
> -					       pte_val(old_pte), pte_val(pte));
> +
> +		if (page_tables_are_ro())
> +			pte = cmpxchg_ro_pte(mm, ptep, old_pte, pte);
> +		else
> +			pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
> +						       pte_val(old_pte),
> +						       pte_val(pte));
>  	} while (pte_val(pte) != pte_val(old_pte));
>  
>  	return pte_young(pte);
> @@ -825,7 +866,7 @@ static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
>  					    unsigned long address,
>  					    pte_t *ptep)
>  {
> -	return __ptep_test_and_clear_young(ptep);
> +	return __ptep_test_and_clear_young(vma->vm_mm, ptep);
>  }
>  
>  #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
> @@ -863,6 +904,8 @@ static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
>  static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
>  				       unsigned long address, pte_t *ptep)
>  {
> +	if (page_tables_are_ro())
> +		return xchg_ro_pte(mm, ptep, __pte(0));
>  	return __pte(xchg_relaxed(&pte_val(*ptep), 0));
>  }
>  
> @@ -888,8 +931,12 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addres
>  	do {
>  		old_pte = pte;
>  		pte = pte_wrprotect(pte);
> -		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
> -					       pte_val(old_pte), pte_val(pte));
> +		if (page_tables_are_ro())
> +			pte = cmpxchg_ro_pte(mm, ptep, old_pte, pte);
> +		else
> +			pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
> +						       pte_val(old_pte),
> +						       pte_val(pte));
>  	} while (pte_val(pte) != pte_val(old_pte));
>  }
>  
> @@ -905,6 +952,8 @@ static inline void pmdp_set_wrprotect(struct mm_struct *mm,
>  static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
>  		unsigned long address, pmd_t *pmdp, pmd_t pmd)
>  {
> +	if (page_tables_are_ro())
> +		return pte_pmd(xchg_ro_pte(vma->vm_mm, (pte_t *)pmdp, pmd_pte(pmd)));
>  	return __pmd(xchg_relaxed(&pmd_val(*pmdp), pmd_val(pmd)));
>  }
>  #endif
> diff --git a/arch/arm64/mm/Makefile b/arch/arm64/mm/Makefile
> index ff1e800ba7a1..7750cafd969a 100644
> --- a/arch/arm64/mm/Makefile
> +++ b/arch/arm64/mm/Makefile
> @@ -14,3 +14,5 @@ KASAN_SANITIZE_physaddr.o	+= n
>  
>  obj-$(CONFIG_KASAN)		+= kasan_init.o
>  KASAN_SANITIZE_kasan_init.o	:= n
> +
> +obj-$(CONFIG_ARM64_RO_PAGE_TABLES) += ro_page_tables.o
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 77341b160aca..5a5055c3e1c2 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -220,7 +220,13 @@ int ptep_set_access_flags(struct vm_area_struct *vma,
>  		pteval ^= PTE_RDONLY;
>  		pteval |= pte_val(entry);
>  		pteval ^= PTE_RDONLY;
> -		pteval = cmpxchg_relaxed(&pte_val(*ptep), old_pteval, pteval);
> +		if (page_tables_are_ro())
> +			pteval = pte_val(cmpxchg_ro_pte(vma->vm_mm, ptep,
> +							__pte(old_pteval),
> +							__pte(pteval)));
> +		else
> +			pteval = cmpxchg_relaxed(&pte_val(*ptep), old_pteval,
> +						 pteval);
>  	} while (pteval != old_pteval);
>  
>  	/* Invalidate a stale read-only entry */
> diff --git a/arch/arm64/mm/ro_page_tables.c b/arch/arm64/mm/ro_page_tables.c
> new file mode 100644
> index 000000000000..f497adfd774d
> --- /dev/null
> +++ b/arch/arm64/mm/ro_page_tables.c
> @@ -0,0 +1,100 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2021 - Google Inc
> + * Author: Ard Biesheuvel <ardb@google.com>
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/memory.h>
> +#include <linux/mm.h>
> +#include <linux/sizes.h>
> +
> +#include <asm/fixmap.h>
> +#include <asm/kernel-pgtable.h>
> +#include <asm/mmu_context.h>
> +#include <asm/pgalloc.h>
> +#include <asm/tlbflush.h>
> +#include <asm/sections.h>
> +
> +static DEFINE_RAW_SPINLOCK(patch_pte_lock);
> +
> +DEFINE_STATIC_KEY_FALSE(ro_page_tables);
> +
> +static bool __initdata ro_page_tables_enabled = true;
> +
> +static int __init parse_ro_page_tables(char *arg)
> +{
> +	return strtobool(arg, &ro_page_tables_enabled);
> +}
> +early_param("ro_page_tables", parse_ro_page_tables);
> +
> +static bool in_kernel_text_or_rodata(phys_addr_t pa)
> +{
> +	/*
> +	 * This is a minimal check to ensure that the r/o page table patching
> +	 * API is not being abused to make changes to the kernel text. This
> +	 * should ideally cover module and BPF text/rodata as well, but that
> +	 * is less straight-forward and hence more costly.
> +	 */
> +	return pa >= __pa_symbol(_stext) && pa < __pa_symbol(__init_begin);
> +}
> +
> +pte_t xchg_ro_pte(struct mm_struct *mm, pte_t *ptep, pte_t pte)
> +{
> +	unsigned long flags;
> +	u64 pte_pa;
> +	pte_t ret;
> +	pte_t *p;
> +
> +	/* can we use __pa() on ptep? */
> +	if (!virt_addr_valid(ptep)) {
> +		/* only linear aliases are remapped r/o anyway */
> +		pte_val(ret) = xchg_relaxed(&pte_val(*ptep), pte_val(pte));
> +		return ret;
> +	}
> +
> +	pte_pa = __pa(ptep);
> +	BUG_ON(in_kernel_text_or_rodata(pte_pa));
> +
> +	raw_spin_lock_irqsave(&patch_pte_lock, flags);
> +	p = (pte_t *)set_fixmap_offset(FIX_TEXT_POKE_PTE, pte_pa);
> +	pte_val(ret) = xchg_relaxed(&pte_val(*p), pte_val(pte));
> +	clear_fixmap(FIX_TEXT_POKE_PTE);
> +	raw_spin_unlock_irqrestore(&patch_pte_lock, flags);
> +	return ret;
> +}
> +
> +pte_t cmpxchg_ro_pte(struct mm_struct *mm, pte_t *ptep, pte_t old, pte_t new)
> +{
> +	unsigned long flags;
> +	u64 pte_pa;
> +	pte_t ret;
> +	pte_t *p;
> +
> +	BUG_ON(!virt_addr_valid(ptep));
> +
> +	pte_pa = __pa(ptep);
> +	BUG_ON(in_kernel_text_or_rodata(pte_pa));
> +
> +	raw_spin_lock_irqsave(&patch_pte_lock, flags);
> +	p = (pte_t *)set_fixmap_offset(FIX_TEXT_POKE_PTE, pte_pa);
> +	pte_val(ret) = cmpxchg_relaxed(&pte_val(*p), pte_val(old), pte_val(new));
> +	clear_fixmap(FIX_TEXT_POKE_PTE);
> +	raw_spin_unlock_irqrestore(&patch_pte_lock, flags);
> +	return ret;
> +}
> +
> +static int __init ro_page_tables_init(void)
> +{
> +	if (ro_page_tables_enabled) {
> +		if (!rodata_full) {
> +			pr_err("Failed to enable R/O page table protection, rodata=full is not enabled\n");
> +		} else {
> +			pr_err("Enabling R/O page table protection\n");
> +			static_branch_enable(&ro_page_tables);
> +		}
> +	}
> +	return 0;
> +}
> +early_initcall(ro_page_tables_init);

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
