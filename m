From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 06/12] kvm-arm: Pass kvm parameter for pagetable
 helpers
Date: Tue, 22 Mar 2016 10:30:37 +0100
Message-ID: <20160322093037.GD21047@cbox>
References: <1457974391-28456-1-git-send-email-suzuki.poulose@arm.com>
 <1457974391-28456-7-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1457974391-28456-7-git-send-email-suzuki.poulose@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, kvm@vger.kernel.org, will.deacon@arm.com, catalin.marinas@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 14, 2016 at 04:53:05PM +0000, Suzuki K Poulose wrote:
> Pass 'kvm' to existing kvm_p.d_* page table wrappers to prepare
> them to choose between hyp and stage2 page table. No functional
> changes yet. Also while at it, convert them to static inline
> functions.

I have to say that I'm not really crazy about the idea of having common
hyp and stage2 code and having the pgtable macros change behavior
depending on the type.

Is it not so that that host pgtable macros will always be valid for the
hyp mappings, because we have the same VA space available etc.?  It's
just a matter of different page table entry attributes.

Looking at arch/arm/kvm/mmu.c, it looks to me like we would get the
cleanest separation by separating stuff that touches hyp page tables
from stuff that touches stage2 page tables.

Then you can get rid of the whole kvm_ prefix and directly use stage2
accessors (which you may want to consider renaming to s2_) directly.

I think we've seen in the past that the confusion from functions
potentially touching both hyp and stage2 page tables is a bad thing and
we should seek to avoid it.

Thanks,
-Christoffer

> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm/include/asm/kvm_mmu.h   |   38 +++++++++++++++++++++++++++-----------
>  arch/arm/kvm/mmu.c               |   34 +++++++++++++++++-----------------
>  arch/arm64/include/asm/kvm_mmu.h |   31 ++++++++++++++++++++++++++-----
>  3 files changed, 70 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index 4448e77..17c6781 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -45,6 +45,7 @@
>  #ifndef __ASSEMBLY__
>  
>  #include <linux/highmem.h>
> +#include <linux/hugetlb.h>
>  #include <asm/cacheflush.h>
>  #include <asm/pgalloc.h>
>  
> @@ -135,22 +136,37 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
>  	return (pmd_val(*pmd) & L_PMD_S2_RDWR) == L_PMD_S2_RDONLY;
>  }
>  
> -#define kvm_pud_huge(_x)	pud_huge(_x)
> +static inline int kvm_pud_huge(struct kvm *kvm, pud_t pud)
> +{
> +	return pud_huge(pud);
> +}
> +
>  
>  /* Open coded p*d_addr_end that can deal with 64bit addresses */
> -#define kvm_pgd_addr_end(addr, end)					\
> -({	u64 __boundary = ((addr) + PGDIR_SIZE) & PGDIR_MASK;		\
> -	(__boundary - 1 < (end) - 1)? __boundary: (end);		\
> -})
> +static inline phys_addr_t
> +kvm_pgd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
> +{
> +	phys_addr_t boundary = (addr + PGDIR_SIZE) & PGDIR_MASK;
> +	return (boundary - 1 < end - 1) ? boundary : end;
> +}
>  
> -#define kvm_pud_addr_end(addr,end)		(end)
> +static inline phys_addr_t
> +kvm_pud_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
> +{
> +	return end;
> +}
>  
> -#define kvm_pmd_addr_end(addr, end)					\
> -({	u64 __boundary = ((addr) + PMD_SIZE) & PMD_MASK;		\
> -	(__boundary - 1 < (end) - 1)? __boundary: (end);		\
> -})
> +static inline phys_addr_t
> +kvm_pmd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
> +{
> +	phys_addr_t boundary = (addr + PMD_SIZE) & PMD_MASK;
> +	return (boundary - 1 < end - 1) ? boundary : end;
> +}
>  
> -#define kvm_pgd_index(addr)			pgd_index(addr)
> +static inline phys_addr_t kvm_pgd_index(struct kvm *kvm, phys_addr_t addr)
> +{
> +	return pgd_index(addr);
> +}
>  
>  static inline bool kvm_page_empty(void *ptr)
>  {
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index d1e9a71..22b4c99 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -165,7 +165,7 @@ static void clear_pgd_entry(struct kvm *kvm, pgd_t *pgd, phys_addr_t addr)
>  static void clear_pud_entry(struct kvm *kvm, pud_t *pud, phys_addr_t addr)
>  {
>  	pmd_t *pmd_table = pmd_offset(pud, 0);
> -	VM_BUG_ON(pud_huge(*pud));
> +	VM_BUG_ON(kvm_pud_huge(kvm, *pud));
>  	pud_clear(pud);
>  	kvm_tlb_flush_vmid_ipa(kvm, addr);
>  	pmd_free(NULL, pmd_table);
> @@ -236,7 +236,7 @@ static void unmap_pmds(struct kvm *kvm, pud_t *pud,
>  
>  	start_pmd = pmd = pmd_offset(pud, addr);
>  	do {
> -		next = kvm_pmd_addr_end(addr, end);
> +		next = kvm_pmd_addr_end(kvm, addr, end);
>  		if (!pmd_none(*pmd)) {
>  			if (huge_pmd(*pmd)) {
>  				pmd_t old_pmd = *pmd;
> @@ -265,9 +265,9 @@ static void unmap_puds(struct kvm *kvm, pgd_t *pgd,
>  
>  	start_pud = pud = pud_offset(pgd, addr);
>  	do {
> -		next = kvm_pud_addr_end(addr, end);
> +		next = kvm_pud_addr_end(kvm, addr, end);
>  		if (!pud_none(*pud)) {
> -			if (pud_huge(*pud)) {
> +			if (kvm_pud_huge(kvm, *pud)) {
>  				pud_t old_pud = *pud;
>  
>  				pud_clear(pud);
> @@ -294,9 +294,9 @@ static void unmap_range(struct kvm *kvm, pgd_t *pgdp,
>  	phys_addr_t addr = start, end = start + size;
>  	phys_addr_t next;
>  
> -	pgd = pgdp + kvm_pgd_index(addr);
> +	pgd = pgdp + kvm_pgd_index(kvm, addr);
>  	do {
> -		next = kvm_pgd_addr_end(addr, end);
> +		next = kvm_pgd_addr_end(kvm, addr, end);
>  		if (!pgd_none(*pgd))
>  			unmap_puds(kvm, pgd, addr, next);
>  	} while (pgd++, addr = next, addr != end);
> @@ -322,7 +322,7 @@ static void stage2_flush_pmds(struct kvm *kvm, pud_t *pud,
>  
>  	pmd = pmd_offset(pud, addr);
>  	do {
> -		next = kvm_pmd_addr_end(addr, end);
> +		next = kvm_pmd_addr_end(kvm, addr, end);
>  		if (!pmd_none(*pmd)) {
>  			if (huge_pmd(*pmd))
>  				kvm_flush_dcache_pmd(*pmd);
> @@ -340,9 +340,9 @@ static void stage2_flush_puds(struct kvm *kvm, pgd_t *pgd,
>  
>  	pud = pud_offset(pgd, addr);
>  	do {
> -		next = kvm_pud_addr_end(addr, end);
> +		next = kvm_pud_addr_end(kvm, addr, end);
>  		if (!pud_none(*pud)) {
> -			if (pud_huge(*pud))
> +			if (kvm_pud_huge(kvm, *pud))
>  				kvm_flush_dcache_pud(*pud);
>  			else
>  				stage2_flush_pmds(kvm, pud, addr, next);
> @@ -358,9 +358,9 @@ static void stage2_flush_memslot(struct kvm *kvm,
>  	phys_addr_t next;
>  	pgd_t *pgd;
>  
> -	pgd = kvm->arch.pgd + kvm_pgd_index(addr);
> +	pgd = kvm->arch.pgd + kvm_pgd_index(kvm, addr);
>  	do {
> -		next = kvm_pgd_addr_end(addr, end);
> +		next = kvm_pgd_addr_end(kvm, addr, end);
>  		stage2_flush_puds(kvm, pgd, addr, next);
>  	} while (pgd++, addr = next, addr != end);
>  }
> @@ -802,7 +802,7 @@ static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
>  	pgd_t *pgd;
>  	pud_t *pud;
>  
> -	pgd = kvm->arch.pgd + kvm_pgd_index(addr);
> +	pgd = kvm->arch.pgd + kvm_pgd_index(kvm, addr);
>  	if (WARN_ON(pgd_none(*pgd))) {
>  		if (!cache)
>  			return NULL;
> @@ -1040,7 +1040,7 @@ static void stage2_wp_pmds(pud_t *pud, phys_addr_t addr, phys_addr_t end)
>  	pmd = pmd_offset(pud, addr);
>  
>  	do {
> -		next = kvm_pmd_addr_end(addr, end);
> +		next = kvm_pmd_addr_end(NULL, addr, end);
>  		if (!pmd_none(*pmd)) {
>  			if (huge_pmd(*pmd)) {
>  				if (!kvm_s2pmd_readonly(pmd))
> @@ -1067,10 +1067,10 @@ static void  stage2_wp_puds(pgd_t *pgd, phys_addr_t addr, phys_addr_t end)
>  
>  	pud = pud_offset(pgd, addr);
>  	do {
> -		next = kvm_pud_addr_end(addr, end);
> +		next = kvm_pud_addr_end(NULL, addr, end);
>  		if (!pud_none(*pud)) {
>  			/* TODO:PUD not supported, revisit later if supported */
> -			BUG_ON(kvm_pud_huge(*pud));
> +			BUG_ON(kvm_pud_huge(NULL, *pud));
>  			stage2_wp_pmds(pud, addr, next);
>  		}
>  	} while (pud++, addr = next, addr != end);
> @@ -1087,7 +1087,7 @@ static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
>  	pgd_t *pgd;
>  	phys_addr_t next;
>  
> -	pgd = kvm->arch.pgd + kvm_pgd_index(addr);
> +	pgd = kvm->arch.pgd + kvm_pgd_index(kvm, addr);
>  	do {
>  		/*
>  		 * Release kvm_mmu_lock periodically if the memory region is
> @@ -1099,7 +1099,7 @@ static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
>  		if (need_resched() || spin_needbreak(&kvm->mmu_lock))
>  			cond_resched_lock(&kvm->mmu_lock);
>  
> -		next = kvm_pgd_addr_end(addr, end);
> +		next = kvm_pgd_addr_end(kvm, addr, end);
>  		if (pgd_present(*pgd))
>  			stage2_wp_puds(pgd, addr, next);
>  	} while (pgd++, addr = next, addr != end);
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index a01d87d..416ca23 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -71,6 +71,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/mmu_context.h>
>  #include <asm/pgtable.h>
> +#include <linux/hugetlb.h>
>  
>  #define KERN_TO_HYP(kva)	((unsigned long)kva - PAGE_OFFSET + HYP_PAGE_OFFSET)
>  
> @@ -141,11 +142,28 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
>  	return (pmd_val(*pmd) & PMD_S2_RDWR) == PMD_S2_RDONLY;
>  }
>  
> -#define kvm_pud_huge(_x)	pud_huge(_x)
> +static inline int kvm_pud_huge(struct kvm *kvm, pud_t pud)
> +{
> +	return pud_huge(pud);
> +}
> +
> +static inline phys_addr_t
> +kvm_pgd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
> +{
> +	return	pgd_addr_end(addr, end);
> +}
> +
> +static inline phys_addr_t
> +kvm_pud_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
> +{
> +	return	pud_addr_end(addr, end);
> +}
>  
> -#define kvm_pgd_addr_end(addr, end)	pgd_addr_end(addr, end)
> -#define kvm_pud_addr_end(addr, end)	pud_addr_end(addr, end)
> -#define kvm_pmd_addr_end(addr, end)	pmd_addr_end(addr, end)
> +static inline phys_addr_t
> +kvm_pmd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
> +{
> +	return	pmd_addr_end(addr, end);
> +}
>  
>  /*
>   * In the case where PGDIR_SHIFT is larger than KVM_PHYS_SHIFT, we can address
> @@ -161,7 +179,10 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
>  #endif
>  #define PTRS_PER_S2_PGD		(1 << PTRS_PER_S2_PGD_SHIFT)
>  
> -#define kvm_pgd_index(addr)	(((addr) >> PGDIR_SHIFT) & (PTRS_PER_S2_PGD - 1))
> +static inline phys_addr_t kvm_pgd_index(struct kvm *kvm, phys_addr_t addr)
> +{
> +	return (addr >> PGDIR_SHIFT) & (PTRS_PER_S2_PGD - 1);
> +}
>  
>  /*
>   * If we are concatenating first level stage-2 page tables, we would have less
> -- 
> 1.7.9.5
> 
