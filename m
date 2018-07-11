From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v5 7/7] KVM: arm64: Add support for creating PUD hugepages
 at stage 2
Date: Wed, 11 Jul 2018 14:38:38 +0100
Message-ID: <bbc3f286-be5b-d0dc-2037-54d5b995a0a5@arm.com>
References: <20180709143835.28971-1-punit.agrawal@arm.com>
 <20180709144124.29164-1-punit.agrawal@arm.com>
 <20180709144124.29164-7-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB23E4A0CB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jul 2018 09:25:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0Bwk98JOABwa for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Jul 2018 09:25:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52A3849F8C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jul 2018 09:25:57 -0400 (EDT)
In-Reply-To: <20180709144124.29164-7-punit.agrawal@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Punit Agrawal <punit.agrawal@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, linux-kernel@vger.kernel.org, will.deacon@arm.com, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 09/07/18 15:41, Punit Agrawal wrote:
> KVM only supports PMD hugepages at stage 2. Now that the various page
> handling routines are updated, extend the stage 2 fault handling to
> map in PUD hugepages.
> 
> Addition of PUD hugepage support enables additional page sizes (e.g.,
> 1G with 4K granule) which can be useful on cores that support mapping
> larger block sizes in the TLB entries.
> 
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>   arch/arm/include/asm/kvm_mmu.h         | 19 +++++++
>   arch/arm64/include/asm/kvm_mmu.h       | 15 +++++
>   arch/arm64/include/asm/pgtable-hwdef.h |  2 +
>   arch/arm64/include/asm/pgtable.h       |  2 +
>   virt/kvm/arm/mmu.c                     | 78 ++++++++++++++++++++++++--
>   5 files changed, 112 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index 8e1e8aee229e..787baf9ec994 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -77,10 +77,13 @@ void kvm_clear_hyp_idmap(void);
>   
>   #define kvm_pfn_pte(pfn, prot)	pfn_pte(pfn, prot)
>   #define kvm_pfn_pmd(pfn, prot)	pfn_pmd(pfn, prot)
> +#define kvm_pfn_pud(pfn, prot)	(__pud(0))
>   
>   #define kvm_pud_pfn(pud)	(((pud_val(pud) & PUD_MASK) & PHYS_MASK) >> PAGE_SHIFT)
>   
>   #define kvm_pmd_mkhuge(pmd)	pmd_mkhuge(pmd)
> +/* No support for pud hugepages */
> +#define kvm_pud_mkhuge(pud)	(pud)
>   
>   /*
>    * The following kvm_*pud*() functionas are provided strictly to allow
> @@ -97,6 +100,22 @@ static inline bool kvm_s2pud_readonly(pud_t *pud)
>   	return false;
>   }
>   
> +static inline void kvm_set_pud(pud_t *pud, pud_t new_pud)
> +{
> +	BUG();
> +}
> +
> +static inline pud_t kvm_s2pud_mkwrite(pud_t pud)
> +{
> +	BUG();
> +	return pud;
> +}
> +
> +static inline pud_t kvm_s2pud_mkexec(pud_t pud)
> +{
> +	BUG();
> +	return pud;
> +}
>   
>   static inline bool kvm_s2pud_exec(pud_t *pud)
>   {
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index c542052fb199..dd8a23159463 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -171,13 +171,16 @@ void kvm_clear_hyp_idmap(void);
>   
>   #define	kvm_set_pte(ptep, pte)		set_pte(ptep, pte)
>   #define	kvm_set_pmd(pmdp, pmd)		set_pmd(pmdp, pmd)
> +#define kvm_set_pud(pudp, pud)		set_pud(pudp, pud)
>   
>   #define kvm_pfn_pte(pfn, prot)		pfn_pte(pfn, prot)
>   #define kvm_pfn_pmd(pfn, prot)		pfn_pmd(pfn, prot)
> +#define kvm_pfn_pud(pfn, prot)		pfn_pud(pfn, prot)
>   
>   #define kvm_pud_pfn(pud)		pud_pfn(pud)
>   
>   #define kvm_pmd_mkhuge(pmd)		pmd_mkhuge(pmd)
> +#define kvm_pud_mkhuge(pud)		pud_mkhuge(pud)
>   
>   static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
>   {
> @@ -191,6 +194,12 @@ static inline pmd_t kvm_s2pmd_mkwrite(pmd_t pmd)
>   	return pmd;
>   }
>   
> +static inline pud_t kvm_s2pud_mkwrite(pud_t pud)
> +{
> +	pud_val(pud) |= PUD_S2_RDWR;
> +	return pud;
> +}
> +
>   static inline pte_t kvm_s2pte_mkexec(pte_t pte)
>   {
>   	pte_val(pte) &= ~PTE_S2_XN;
> @@ -203,6 +212,12 @@ static inline pmd_t kvm_s2pmd_mkexec(pmd_t pmd)
>   	return pmd;
>   }
>   
> +static inline pud_t kvm_s2pud_mkexec(pud_t pud)
> +{
> +	pud_val(pud) &= ~PUD_S2_XN;
> +	return pud;
> +}
> +
>   static inline void kvm_set_s2pte_readonly(pte_t *ptep)
>   {
>   	pteval_t old_pteval, pteval;
> diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
> index 10ae592b78b8..e327665e94d1 100644
> --- a/arch/arm64/include/asm/pgtable-hwdef.h
> +++ b/arch/arm64/include/asm/pgtable-hwdef.h
> @@ -193,6 +193,8 @@
>   #define PMD_S2_RDWR		(_AT(pmdval_t, 3) << 6)   /* HAP[2:1] */
>   #define PMD_S2_XN		(_AT(pmdval_t, 2) << 53)  /* XN[1:0] */
>   
> +#define PUD_S2_RDONLY		(_AT(pudval_t, 1) << 6)   /* HAP[2:1] */
> +#define PUD_S2_RDWR		(_AT(pudval_t, 3) << 6)   /* HAP[2:1] */
>   #define PUD_S2_XN		(_AT(pudval_t, 2) << 53)  /* XN[1:0] */
>   
>   /*
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 4d9476e420d9..0afc34f94ff5 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -389,6 +389,8 @@ static inline int pmd_protnone(pmd_t pmd)
>   #define pud_mkyoung(pud)	pte_pud(pte_mkyoung(pud_pte(pud)))
>   #define pud_write(pud)		pte_write(pud_pte(pud))
>   
> +#define pud_mkhuge(pud)		(__pud(pud_val(pud) & ~PUD_TABLE_BIT))
> +
>   #define __pud_to_phys(pud)	__pte_to_phys(pud_pte(pud))
>   #define __phys_to_pud_val(phys)	__phys_to_pte_val(phys)
>   #define pud_pfn(pud)		((__pud_to_phys(pud) & PUD_MASK) >> PAGE_SHIFT)
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index a6d3ac9d7c7a..d8e2497e5353 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -116,6 +116,25 @@ static void stage2_dissolve_pmd(struct kvm *kvm, phys_addr_t addr, pmd_t *pmd)
>   	put_page(virt_to_page(pmd));
>   }
>   
> +/**
> + * stage2_dissolve_pud() - clear and flush huge PUD entry
> + * @kvm:	pointer to kvm structure.
> + * @addr:	IPA
> + * @pud:	pud pointer for IPA
> + *
> + * Function clears a PUD entry, flushes addr 1st and 2nd stage TLBs. Marks all
> + * pages in the range dirty.
> + */
> +static void stage2_dissolve_pud(struct kvm *kvm, phys_addr_t addr, pud_t *pudp)
> +{
> +	if (!stage2_pud_huge(*pudp))
> +		return;
> +
> +	stage2_pud_clear(pudp);
> +	kvm_tlb_flush_vmid_ipa(kvm, addr);
> +	put_page(virt_to_page(pudp));
> +}
> +
>   static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
>   				  int min, int max)
>   {
> @@ -993,7 +1012,7 @@ static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
>   	pmd_t *pmd;
>   
>   	pud = stage2_get_pud(kvm, cache, addr);
> -	if (!pud)
> +	if (!pud || stage2_pud_huge(*pud))
>   		return NULL;
>   
>   	if (stage2_pud_none(*pud)) {
> @@ -1038,6 +1057,26 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
>   	return 0;
>   }
>   
> +static int stage2_set_pud_huge(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
> +			       phys_addr_t addr, const pud_t *new_pudp)
> +{
> +	pud_t *pudp, old_pud;
> +
> +	pudp = stage2_get_pud(kvm, cache, addr);
> +	VM_BUG_ON(!pudp);
> +
> +	old_pud = *pudp;
> +	if (stage2_pud_present(old_pud)) {
> +		stage2_pud_clear(pudp);
> +		kvm_tlb_flush_vmid_ipa(kvm, addr);
> +	} else {
> +		get_page(virt_to_page(pudp));
> +	}
> +
> +	kvm_set_pud(pudp, *new_pudp);
> +	return 0;
> +}
> +
>   /*
>    * stage2_get_leaf_entry - walk the stage2 VM page tables and return
>    * true if a valid and present leaf-entry is found. A pointer to the
> @@ -1100,6 +1139,7 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
>   			  phys_addr_t addr, const pte_t *new_pte,
>   			  unsigned long flags)
>   {
> +	pud_t *pud;
>   	pmd_t *pmd;
>   	pte_t *pte, old_pte;
>   	bool iomap = flags & KVM_S2PTE_FLAG_IS_IOMAP;
> @@ -1108,6 +1148,22 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
>   	VM_BUG_ON(logging_active && !cache);
>   
>   	/* Create stage-2 page table mapping - Levels 0 and 1 */
> +	pud = stage2_get_pud(kvm, cache, addr);
> +	if (!pud) {
> +		/*
> +		 * Ignore calls from kvm_set_spte_hva for unallocated
> +		 * address ranges.
> +		 */
> +		return 0;
> +	}
> +
> +	/*
> +	 * While dirty page logging - dissolve huge PUD, then continue
> +	 * on to allocate page.

Punit,

We don't seem to allocate a page here for the PUD entry, in case if it is dissolved
or empty (i.e, stage2_pud_none(*pud) is true.).

> +	 */
> +	if (logging_active)
> +		stage2_dissolve_pud(kvm, addr, pud);
> +
>   	pmd = stage2_get_pmd(kvm, cache, addr);
>   	if (!pmd) {

And once you add an entry, pmd is just the matter of getting stage2_pmd_offset() from your pud.
No need to start again from the top-level with stage2_get_pmd().

Cheers
Suzuki
