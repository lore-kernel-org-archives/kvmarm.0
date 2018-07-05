From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v4 7/7] KVM: arm64: Add support for creating PUD hugepages
 at stage 2
Date: Thu, 5 Jul 2018 18:11:34 +0100
Message-ID: <51265e49-8b8f-cabb-d2c9-d776a8a4ace8@arm.com>
References: <20180705140850.5801-1-punit.agrawal@arm.com>
 <20180705140850.5801-8-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180705140850.5801-8-punit.agrawal@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Punit Agrawal <punit.agrawal@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@arm.com, linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Punit,

On 05/07/18 15:08, Punit Agrawal wrote:
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

> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 0c04c64e858c..5912210e94d9 100644
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
> +static void stage2_dissolve_pud(struct kvm *kvm, phys_addr_t addr, pud_t *pud)
> +{
> +	if (!pud_huge(*pud))
> +		return;
> +
> +	pud_clear(pud);

You need to use the stage2_ accessors here. The stage2_dissolve_pmd() uses
"pmd_" helpers as the PTE entries (level 3) are always guaranteed to exist.


> +	kvm_tlb_flush_vmid_ipa(kvm, addr);
> +	put_page(virt_to_page(pud));
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
> +	if (!pud || pud_huge(*pud))
>   		return NULL;

Same here.

>   
>   	if (stage2_pud_none(*pud)) {

Like this ^

> @@ -1038,6 +1057,26 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
>   	return 0;
>   }
>   
> +static int stage2_set_pud_huge(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
> +			       phys_addr_t addr, const pud_t *new_pud)
> +{
> +	pud_t *pud, old_pud;
> +
> +	pud = stage2_get_pud(kvm, cache, addr);
> +	VM_BUG_ON(!pud);
> +
> +	old_pud = *pud;
> +	if (pud_present(old_pud)) {
> +		pud_clear(pud);
> +		kvm_tlb_flush_vmid_ipa(kvm, addr);

Same here.

> +	} else {
> +		get_page(virt_to_page(pud));
> +	}
> +
> +	kvm_set_pud(pud, *new_pud);
> +	return 0;
> +}
> +
>   static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
>   {
>   	pud_t *pudp;
> @@ -1069,6 +1108,7 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
>   			  phys_addr_t addr, const pte_t *new_pte,
>   			  unsigned long flags)
>   {
> +	pud_t *pud;
>   	pmd_t *pmd;
>   	pte_t *pte, old_pte;
>   	bool iomap = flags & KVM_S2PTE_FLAG_IS_IOMAP;
> @@ -1077,6 +1117,22 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
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
> +	 */
> +	if (logging_active)
> +		stage2_dissolve_pud(kvm, addr, pud);
> +
>   	pmd = stage2_get_pmd(kvm, cache, addr);
>   	if (!pmd) {
>   		/*
> @@ -1483,9 +1539,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	}
>   
>   	vma_pagesize = vma_kernel_pagesize(vma);
> -	if (vma_pagesize == PMD_SIZE && !logging_active) {
> +	if ((vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE) &&
> +	    !logging_active) {
> +		struct hstate *h = hstate_vma(vma);
> +
>   		hugetlb = true;
> -		gfn = (fault_ipa & PMD_MASK) >> PAGE_SHIFT;
> +		gfn = (fault_ipa & huge_page_mask(h)) >> PAGE_SHIFT;
>   	} else {
>   		/*
>   		 * Pages belonging to memslots that don't have the same
> @@ -1572,7 +1631,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	if (exec_fault)
>   		invalidate_icache_guest_page(pfn, vma_pagesize);
>   
> -	if (hugetlb && vma_pagesize == PMD_SIZE) {
> +	if (hugetlb && vma_pagesize == PUD_SIZE) {

I think we may need to check if the stage2 indeed has 3 levels of
tables to use stage2 PUD. Otherwise, fall back to PTE level mapping
or even PMD huge pages. Also, this cannot be triggered right now,
as we only get PUD hugepages with 4K and we are guaranteed to have
at least 3 levels with 40bit IPA. May be I can take care of it in
the Dynamic IPA series, when we run a guest with say 32bit IPA.
So for now, it is worth adding a comment here.

> +		pud_t new_pud = kvm_pfn_pud(pfn, mem_type);
> +
> +		new_pud = kvm_pud_mkhuge(new_pud);
> +		if (writable)
> +			new_pud = kvm_s2pud_mkwrite(new_pud);
> +
> +		if (stage2_should_exec(kvm, fault_ipa, exec_fault, fault_status))
> +			new_pud = kvm_s2pud_mkexec(new_pud);
> +
> +		ret = stage2_set_pud_huge(kvm, memcache, fault_ipa, &new_pud);
> +	} else if (hugetlb && vma_pagesize == PMD_SIZE) {

Suzuki
