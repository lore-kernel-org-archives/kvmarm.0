From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC 4/4] KVM: arm64: Add support for PUD hugepages at stage 2
Date: Tue, 6 Feb 2018 15:55:01 +0100
Message-ID: <20180206145501.GB23160@cbox>
References: <20180110190729.18383-1-punit.agrawal@arm.com>
 <20180110190729.18383-5-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180110190729.18383-5-punit.agrawal@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: suzuki.poulose@arm.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 10, 2018 at 07:07:29PM +0000, Punit Agrawal wrote:
> KVM only supports PMD hugepages at stage 2. Extend the stage 2 fault
> handling to add support for PUD hugepages.
> 
> Addition of PUD hugpage support enables additional hugepage sizes (1G

                 *hugepage

> with 4K granule and 4TB with 64k granule) which can be useful on cores
> that have support for mapping larger block sizes in the TLB entries.
> 
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm/include/asm/kvm_mmu.h         | 10 +++++
>  arch/arm/include/asm/pgtable-3level.h  |  2 +
>  arch/arm64/include/asm/kvm_mmu.h       | 19 +++++++++
>  arch/arm64/include/asm/pgtable-hwdef.h |  2 +
>  arch/arm64/include/asm/pgtable.h       |  4 ++
>  virt/kvm/arm/mmu.c                     | 72 +++++++++++++++++++++++++++++-----
>  6 files changed, 99 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index 3fbe919b9181..6e2e34348cb3 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -59,6 +59,10 @@ phys_addr_t kvm_get_idmap_vector(void);
>  int kvm_mmu_init(void);
>  void kvm_clear_hyp_idmap(void);
>  
> +static inline void kvm_set_pud(pud_t *pud, pud_t new_pud)
> +{
> +}
> +
>  static inline void kvm_set_pmd(pmd_t *pmd, pmd_t new_pmd)
>  {
>  	*pmd = new_pmd;
> @@ -230,6 +234,12 @@ static inline unsigned int kvm_get_vmid_bits(void)
>  	return 8;
>  }
>  
> +static inline pud_t stage2_build_pud(kvm_pfn_t pfn, pgprot_t mem_type,
> +				     bool writable)
> +{
> +	return __pud(0);
> +}
> +
>  #endif	/* !__ASSEMBLY__ */
>  
>  #endif /* __ARM_KVM_MMU_H__ */
> diff --git a/arch/arm/include/asm/pgtable-3level.h b/arch/arm/include/asm/pgtable-3level.h
> index 1a7a17b2a1ba..97e04fdbfa85 100644
> --- a/arch/arm/include/asm/pgtable-3level.h
> +++ b/arch/arm/include/asm/pgtable-3level.h
> @@ -249,6 +249,8 @@ PMD_BIT_FUNC(mkyoung,   |= PMD_SECT_AF);
>  #define pfn_pmd(pfn,prot)	(__pmd(((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot)))
>  #define mk_pmd(page,prot)	pfn_pmd(page_to_pfn(page),prot)
>  
> +#define pud_pfn(pud)		(((pud_val(pud) & PUD_MASK) & PHYS_MASK) >> PAGE_SHIFT)
> +

does this make sense on 32-bit arm?  Is this ever going to get called
and return something meaningful in that case?

>  /* represent a notpresent pmd by faulting entry, this is used by pmdp_invalidate */
>  static inline pmd_t pmd_mknotpresent(pmd_t pmd)
>  {
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index dbfd18e08cfb..89eac3dbe123 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -160,6 +160,7 @@ void kvm_clear_hyp_idmap(void);
>  
>  #define	kvm_set_pte(ptep, pte)		set_pte(ptep, pte)
>  #define	kvm_set_pmd(pmdp, pmd)		set_pmd(pmdp, pmd)
> +#define kvm_set_pud(pudp, pud)		set_pud(pudp, pud)
>  
>  static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
>  {
> @@ -173,6 +174,12 @@ static inline pmd_t kvm_s2pmd_mkwrite(pmd_t pmd)
>  	return pmd;
>  }
>  
> +static inline pud_t kvm_s2pud_mkwrite(pud_t pud)
> +{
> +	pud_val(pud) |= PUD_S2_RDWR;
> +	return pud;
> +}
> +
>  static inline void kvm_set_s2pte_readonly(pte_t *pte)
>  {
>  	pteval_t old_pteval, pteval;
> @@ -319,5 +326,17 @@ static inline unsigned int kvm_get_vmid_bits(void)
>  	return (cpuid_feature_extract_unsigned_field(reg, ID_AA64MMFR1_VMIDBITS_SHIFT) == 2) ? 16 : 8;
>  }
>  
> +static inline pud_t stage2_build_pud(kvm_pfn_t pfn, pgprot_t mem_type,
> +				     bool writable)
> +{
> +	pud_t pud = pfn_pud(pfn, mem_type);
> +
> +	pud = pud_mkhuge(pud);
> +	if (writable)
> +		pud = kvm_s2pud_mkwrite(pud);
> +
> +	return pud;
> +}
> +
>  #endif /* __ASSEMBLY__ */
>  #endif /* __ARM64_KVM_MMU_H__ */
> diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
> index 40a998cdd399..a091a6192eee 100644
> --- a/arch/arm64/include/asm/pgtable-hwdef.h
> +++ b/arch/arm64/include/asm/pgtable-hwdef.h
> @@ -181,6 +181,8 @@
>  #define PMD_S2_RDONLY		(_AT(pmdval_t, 1) << 6)   /* HAP[2:1] */
>  #define PMD_S2_RDWR		(_AT(pmdval_t, 3) << 6)   /* HAP[2:1] */
>  
> +#define PUD_S2_RDWR		(_AT(pudval_t, 3) << 6)   /* HAP[2:1] */
> +
>  /*
>   * Memory Attribute override for Stage-2 (MemAttr[3:0])
>   */
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index bdcc7f1c9d06..d5ffff4369d2 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -362,7 +362,11 @@ static inline int pmd_protnone(pmd_t pmd)
>  #define mk_pmd(page,prot)	pfn_pmd(page_to_pfn(page),prot)
>  
>  #define pud_write(pud)		pte_write(pud_pte(pud))
> +
> +#define pud_mkhuge(pud)		(__pud(pud_val(pud) & ~PUD_TABLE_BIT))
> +
>  #define pud_pfn(pud)		(((pud_val(pud) & PUD_MASK) & PHYS_MASK) >> PAGE_SHIFT)
> +#define pfn_pud(pfn, prot)	(__pud(((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot)))
>  
>  #define set_pmd_at(mm, addr, pmdp, pmd)	set_pte_at(mm, addr, (pte_t *)pmdp, pmd_pte(pmd))
>  
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index f02219a91b19..5362de098768 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -872,6 +872,32 @@ static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
>  	return stage2_pud_offset(pgd, addr);
>  }
>  
> +static int stage2_set_pud_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
> +			       *cache, phys_addr_t addr, const pud_t *new_pud)
> +{
> +	pud_t *pud, old_pud;
> +
> +	pud = stage2_get_pud(kvm, cache, addr);
> +	VM_BUG_ON(!pud);
> +
> +	/*
> +	 * Mapping in huge pages should only happen through a fault.
> +	 */
> +	VM_BUG_ON(stage2_pud_present(*pud) &&
> +		  pud_pfn(*pud) != pud_pfn(*new_pud));
> +
> +	old_pud = *pud;
> +	if (stage2_pud_present(old_pud)) {
> +		stage2_pud_clear(pud);
> +		kvm_tlb_flush_vmid_ipa(kvm, addr);
> +	} else {
> +		get_page(virt_to_page(pud));
> +	}
> +
> +	kvm_set_pud(pud, *new_pud);
> +	return 0;
> +}
> +
>  static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
>  			     phys_addr_t addr)
>  {
> @@ -1307,6 +1333,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	kvm_pfn_t pfn;
>  	pgprot_t mem_type = PAGE_S2;
>  	bool logging_active = memslot_is_logging(memslot);
> +	unsigned long vma_pagesize;
>  	unsigned long flags = 0;
>  
>  	write_fault = kvm_is_write_fault(vcpu);
> @@ -1324,9 +1351,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		return -EFAULT;
>  	}
>  
> -	if (vma_kernel_pagesize(vma) == PMD_SIZE && !logging_active) {
> +	vma_pagesize = vma_kernel_pagesize(vma);
> +	if ((vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE) &&
> +	    !logging_active) {
> +		struct hstate *h = hstate_vma(vma);
> +
>  		hugetlb = true;
> -		gfn = (fault_ipa & PMD_MASK) >> PAGE_SHIFT;
> +		gfn = (fault_ipa & huge_page_mask(h)) >> PAGE_SHIFT;
>  	} else {
>  		/*
>  		 * Pages belonging to memslots that don't have the same
> @@ -1393,17 +1424,38 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	if (mmu_notifier_retry(kvm, mmu_seq))
>  		goto out_unlock;
>  
> -	if (!hugetlb && !force_pte)
> +	if (!hugetlb && !force_pte) {
> +		/*
> +		 * We only support PMD_SIZE transparent
> +		 * hugepages. This code will need updates if we enable
> +		 * other page sizes for THP.
> +		 */
>  		hugetlb = transparent_hugepage_adjust(&pfn, &fault_ipa);
> +		vma_pagesize = PMD_SIZE;
> +	}
>  
>  	if (hugetlb) {
> -		pmd_t new_pmd = stage2_build_pmd(pfn, mem_type, writable);
> -
> -		if (writable)
> -			kvm_set_pfn_dirty(pfn);
> -
> -		coherent_cache_guest_page(vcpu, pfn, PMD_SIZE);
> -		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
> +		if (vma_pagesize == PUD_SIZE) {
> +			pud_t new_pud;
> +
> +			new_pud = stage2_build_pud(pfn, mem_type, writable);
> +			if (writable)
> +				kvm_set_pfn_dirty(pfn);
> +
> +			coherent_cache_guest_page(vcpu, pfn, PUD_SIZE);
> +			ret = stage2_set_pud_huge(kvm, memcache,
> +						  fault_ipa, &new_pud);
> +		} else {
> +			pmd_t new_pmd;
> +
> +			new_pmd = stage2_build_pmd(pfn, mem_type, writable);
> +			if (writable)
> +				kvm_set_pfn_dirty(pfn);
> +
> +			coherent_cache_guest_page(vcpu, pfn, PMD_SIZE);
> +			ret = stage2_set_pmd_huge(kvm, memcache,
> +						  fault_ipa, &new_pmd);
> +		}

This stuff needs rebasing onto v4.16-rc1 when we get there, and it will
clash with Marc's icache optimizations.

But, you should be able to move kvm_set_pfn_dirty() out of the
size-conditional section and also call the cache maintenance functions
using vma_pagesize as parameter.

>  	} else {
>  		pte_t new_pte = pfn_pte(pfn, mem_type);
>  
> -- 
> 2.15.1
> 

Thanks,
-Christoffer
