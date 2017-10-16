From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 07/10] KVM: arm/arm64: Preserve Exec permission across
 R/W permission faults
Date: Mon, 16 Oct 2017 22:08:24 +0200
Message-ID: <20171016200824.GI1845@lvm>
References: <20171009152032.27804-1-marc.zyngier@arm.com>
 <20171009152032.27804-8-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171009152032.27804-8-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 09, 2017 at 04:20:29PM +0100, Marc Zyngier wrote:
> So far, we loose the Exec property whenever we take permission
> faults, as we always reconstruct the PTE/PMD from scratch. This
> can be counter productive as we can end-up with the following
> fault sequence:
> 
> 	X -> RO -> ROX -> RW -> RWX
> 
> Instead, we can lookup the existing PTE/PMD and clear the XN bit in the
> new entry if it was already cleared in the old one, leadig to a much
> nicer fault sequence:
> 
> 	X -> ROX -> RWX
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/include/asm/kvm_mmu.h   | 10 ++++++++++
>  arch/arm64/include/asm/kvm_mmu.h | 10 ++++++++++
>  virt/kvm/arm/mmu.c               | 25 +++++++++++++++++++++++++
>  3 files changed, 45 insertions(+)
> 
> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index bf76150aad5f..ad442d86c23e 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -107,6 +107,11 @@ static inline bool kvm_s2pte_readonly(pte_t *pte)
>  	return (pte_val(*pte) & L_PTE_S2_RDWR) == L_PTE_S2_RDONLY;
>  }
>  
> +static inline bool kvm_s2pte_exec(pte_t *pte)
> +{
> +	return !(pte_val(*pte) & L_PTE_XN);
> +}
> +
>  static inline void kvm_set_s2pmd_readonly(pmd_t *pmd)
>  {
>  	pmd_val(*pmd) = (pmd_val(*pmd) & ~L_PMD_S2_RDWR) | L_PMD_S2_RDONLY;
> @@ -117,6 +122,11 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
>  	return (pmd_val(*pmd) & L_PMD_S2_RDWR) == L_PMD_S2_RDONLY;
>  }
>  
> +static inline bool kvm_s2pmd_exec(pmd_t *pmd)
> +{
> +	return !(pmd_val(*pmd) & PMD_SECT_XN);
> +}
> +
>  static inline bool kvm_page_empty(void *ptr)
>  {
>  	struct page *ptr_page = virt_to_page(ptr);
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 60c420a5ac0d..e7af74b8b51a 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -203,6 +203,11 @@ static inline bool kvm_s2pte_readonly(pte_t *pte)
>  	return (pte_val(*pte) & PTE_S2_RDWR) == PTE_S2_RDONLY;
>  }
>  
> +static inline bool kvm_s2pte_exec(pte_t *pte)
> +{
> +	return !(pte_val(*pte) & PTE_S2_XN);
> +}
> +
>  static inline void kvm_set_s2pmd_readonly(pmd_t *pmd)
>  {
>  	kvm_set_s2pte_readonly((pte_t *)pmd);
> @@ -213,6 +218,11 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
>  	return kvm_s2pte_readonly((pte_t *)pmd);
>  }
>  
> +static inline bool kvm_s2pmd_exec(pmd_t *pmd)
> +{
> +	return !(pmd_val(*pmd) & PMD_S2_XN);
> +}
> +
>  static inline bool kvm_page_empty(void *ptr)
>  {
>  	struct page *ptr_page = virt_to_page(ptr);
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 1911fadde88b..ccc6106764a6 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -926,6 +926,17 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
>  	return 0;
>  }
>  
> +static pte_t *stage2_get_pte(struct kvm *kvm, phys_addr_t addr)
> +{
> +	pmd_t *pmdp;
> +
> +	pmdp = stage2_get_pmd(kvm, NULL, addr);
> +	if (!pmdp || pmd_none(*pmdp))
> +		return NULL;
> +
> +	return pte_offset_kernel(pmdp, addr);
> +}
> +

nit, couldn't you change this to be

    stage2_is_exec(struct kvm *kvm, phys_addr_t addr)

Which, if the pmd is a section mapping just checks that, and if we find
a pte, we check that, and then we can have a simpler one-line call and
check from both the pte and pmd paths below?

>  static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
>  			  phys_addr_t addr, const pte_t *new_pte,
>  			  unsigned long flags)
> @@ -1407,6 +1418,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		if (exec_fault) {
>  			new_pmd = kvm_s2pmd_mkexec(new_pmd);
>  			coherent_icache_guest_page(vcpu, pfn, PMD_SIZE);
> +		} else if (fault_status == FSC_PERM) {
> +			/* Preserve execute if XN was already cleared */
> +			pmd_t *old_pmdp = stage2_get_pmd(kvm, NULL, fault_ipa);
> +
> +			if (old_pmdp && pmd_present(*old_pmdp) &&
> +			    kvm_s2pmd_exec(old_pmdp))
> +				new_pmd = kvm_s2pmd_mkexec(new_pmd);

Is the reverse case not also possible then?  That is, if we have an
exec_fault, we could check if the entry is already writable and maintain
the property as well.  Not sure how often that would get hit though, as
a VM would only execute instructions on a page that has been written to,
but is somehow read-only at stage2, meaning the host must have marked
the page as read-only since content was written.  I think this could be
a somewhat common pattern with something like KSM though?


>  		}
>  
>  		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
> @@ -1425,6 +1443,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		if (exec_fault) {
>  			new_pte = kvm_s2pte_mkexec(new_pte);
>  			coherent_icache_guest_page(vcpu, pfn, PAGE_SIZE);
> +		} else if (fault_status == FSC_PERM) {
> +			/* Preserve execute if XN was already cleared */
> +			pte_t *old_ptep = stage2_get_pte(kvm, fault_ipa);
> +
> +			if (old_ptep && pte_present(*old_ptep) &&
> +			    kvm_s2pte_exec(old_ptep))
> +				new_pte = kvm_s2pte_mkexec(new_pte);
>  		}
>  
>  		ret = stage2_set_pte(kvm, memcache, fault_ipa, &new_pte, flags);
> -- 
> 2.14.1
> 

Thanks,
-Christoffer
