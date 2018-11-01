From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v9 6/8] KVM: arm64: Support handling access faults for
 PUD hugepages
Date: Thu, 1 Nov 2018 14:40:15 +0100
Message-ID: <20181101134015.GM12057@e113682-lin.lund.arm.com>
References: <20181031175745.18650-1-punit.agrawal@arm.com>
 <20181031175745.18650-7-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DD7A4A2B6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Nov 2018 09:40:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pthK7lb75oMK for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Nov 2018 09:40:18 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 51E634A200
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Nov 2018 09:40:18 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20181031175745.18650-7-punit.agrawal@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: marc.zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, will.deacon@arm.com, linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Oct 31, 2018 at 05:57:43PM +0000, Punit Agrawal wrote:
> In preparation for creating larger hugepages at Stage 2, extend the
> access fault handling at Stage 2 to support PUD hugepages when
> encountered.
> 
> Provide trivial helpers for arm32 to allow sharing of code.
> 
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm/include/asm/kvm_mmu.h   |  9 +++++++++
>  arch/arm64/include/asm/kvm_mmu.h |  7 +++++++
>  arch/arm64/include/asm/pgtable.h |  6 ++++++
>  virt/kvm/arm/mmu.c               | 22 +++++++++++-----------
>  4 files changed, 33 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index 839a619873d3..fea5e723e3ac 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -85,6 +85,9 @@ void kvm_clear_hyp_idmap(void);
>  #define kvm_pfn_pte(pfn, prot)	pfn_pte(pfn, prot)
>  #define kvm_pfn_pmd(pfn, prot)	pfn_pmd(pfn, prot)
>  
> +#define kvm_pud_pfn(pud)	({ BUG(); 0; })
> +
> +
>  #define kvm_pmd_mkhuge(pmd)	pmd_mkhuge(pmd)
>  
>  /*
> @@ -108,6 +111,12 @@ static inline bool kvm_s2pud_exec(pud_t *pud)
>  	return false;
>  }
>  
> +static inline pud_t kvm_s2pud_mkyoung(pud_t pud)
> +{
> +	BUG();

nit: I think this should be WARN now.

> +	return pud;
> +}
> +
>  static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
>  {
>  	pte_val(pte) |= L_PTE_S2_RDWR;
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index c755b37b3f92..612032bbb428 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -187,6 +187,8 @@ void kvm_clear_hyp_idmap(void);
>  #define kvm_pfn_pte(pfn, prot)		pfn_pte(pfn, prot)
>  #define kvm_pfn_pmd(pfn, prot)		pfn_pmd(pfn, prot)
>  
> +#define kvm_pud_pfn(pud)		pud_pfn(pud)
> +
>  #define kvm_pmd_mkhuge(pmd)		pmd_mkhuge(pmd)
>  
>  static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
> @@ -266,6 +268,11 @@ static inline bool kvm_s2pud_exec(pud_t *pudp)
>  	return !(READ_ONCE(pud_val(*pudp)) & PUD_S2_XN);
>  }
>  
> +static inline pud_t kvm_s2pud_mkyoung(pud_t pud)
> +{
> +	return pud_mkyoung(pud);
> +}
> +
>  #define hyp_pte_table_empty(ptep) kvm_page_empty(ptep)
>  
>  #ifdef __PAGETABLE_PMD_FOLDED
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 50b1ef8584c0..f51e2271e6a3 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -314,6 +314,11 @@ static inline pte_t pud_pte(pud_t pud)
>  	return __pte(pud_val(pud));
>  }
>  
> +static inline pud_t pte_pud(pte_t pte)
> +{
> +	return __pud(pte_val(pte));
> +}
> +
>  static inline pmd_t pud_pmd(pud_t pud)
>  {
>  	return __pmd(pud_val(pud));
> @@ -381,6 +386,7 @@ static inline int pmd_protnone(pmd_t pmd)
>  #define pfn_pmd(pfn,prot)	__pmd(__phys_to_pmd_val((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
>  #define mk_pmd(page,prot)	pfn_pmd(page_to_pfn(page),prot)
>  
> +#define pud_mkyoung(pud)	pte_pud(pte_mkyoung(pud_pte(pud)))
>  #define pud_write(pud)		pte_write(pud_pte(pud))
>  
>  #define __pud_to_phys(pud)	__pte_to_phys(pud_pte(pud))
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 8e44dccd1b47..bd749601195f 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1698,6 +1698,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   */
>  static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>  {
> +	pud_t *pud;
>  	pmd_t *pmd;
>  	pte_t *pte;
>  	kvm_pfn_t pfn;
> @@ -1707,24 +1708,23 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>  
>  	spin_lock(&vcpu->kvm->mmu_lock);
>  
> -	pmd = stage2_get_pmd(vcpu->kvm, NULL, fault_ipa);
> -	if (!pmd || pmd_none(*pmd))	/* Nothing there */
> +	if (!stage2_get_leaf_entry(vcpu->kvm, fault_ipa, &pud, &pmd, &pte))
>  		goto out;
>  
> -	if (pmd_thp_or_huge(*pmd)) {	/* THP, HugeTLB */
> +	if (pud) {		/* HugeTLB */
> +		*pud = kvm_s2pud_mkyoung(*pud);
> +		pfn = kvm_pud_pfn(*pud);
> +		pfn_valid = true;
> +	} else	if (pmd) {	/* THP, HugeTLB */
>  		*pmd = pmd_mkyoung(*pmd);
>  		pfn = pmd_pfn(*pmd);
>  		pfn_valid = true;
> -		goto out;
> +	} else {
> +		*pte = pte_mkyoung(*pte);	/* Just a page... */
> +		pfn = pte_pfn(*pte);
> +		pfn_valid = true;
>  	}
>  
> -	pte = pte_offset_kernel(pmd, fault_ipa);
> -	if (pte_none(*pte))		/* Nothing there either */
> -		goto out;
> -
> -	*pte = pte_mkyoung(*pte);	/* Just a page... */
> -	pfn = pte_pfn(*pte);
> -	pfn_valid = true;
>  out:
>  	spin_unlock(&vcpu->kvm->mmu_lock);
>  	if (pfn_valid)
> -- 
> 2.19.1
> 
