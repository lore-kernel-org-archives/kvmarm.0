From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v5 6/7] KVM: arm64: Update age handlers to support PUD
 hugepages
Date: Wed, 11 Jul 2018 14:23:26 +0100
Message-ID: <5156c953-c49e-72c7-666e-c7894b728bef@arm.com>
References: <20180709143835.28971-1-punit.agrawal@arm.com>
 <20180709144124.29164-1-punit.agrawal@arm.com>
 <20180709144124.29164-6-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180709144124.29164-6-punit.agrawal@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Punit Agrawal <punit.agrawal@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@arm.com, linux-kernel@vger.kernel.org, will.deacon@arm.com, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 09/07/18 15:41, Punit Agrawal wrote:
> In preparation for creating larger hugepages at Stage 2, add support
> to the age handling notifiers for PUD hugepages when encountered.
> 
> Provide trivial helpers for arm32 to allow sharing code.
> 
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>   arch/arm/include/asm/kvm_mmu.h   |  6 ++++
>   arch/arm64/include/asm/kvm_mmu.h |  5 ++++
>   arch/arm64/include/asm/pgtable.h |  1 +
>   virt/kvm/arm/mmu.c               | 51 ++++++++++++++++++--------------
>   4 files changed, 40 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index a4298d429efc..8e1e8aee229e 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -110,6 +110,12 @@ static inline pud_t kvm_s2pud_mkyoung(pud_t pud)
>   	return pud;
>   }
>   
> +static inline bool kvm_s2pud_young(pud_t pud)
> +{
> +	BUG();
> +	return false;
> +}
> +
>   static inline void kvm_set_pmd(pmd_t *pmd, pmd_t new_pmd)
>   {
>   	*pmd = new_pmd;
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 4d2780c588b0..c542052fb199 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -261,6 +261,11 @@ static inline pud_t kvm_s2pud_mkyoung(pud_t pud)
>   	return pud_mkyoung(pud);
>   }
>   
> +static inline bool kvm_s2pud_young(pud_t pud)
> +{
> +	return pud_young(pud);
> +}
> +
>   static inline bool kvm_page_empty(void *ptr)
>   {
>   	struct page *ptr_page = virt_to_page(ptr);
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index a64a5c35beb1..4d9476e420d9 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -385,6 +385,7 @@ static inline int pmd_protnone(pmd_t pmd)
>   #define pfn_pmd(pfn,prot)	__pmd(__phys_to_pmd_val((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
>   #define mk_pmd(page,prot)	pfn_pmd(page_to_pfn(page),prot)
>   
> +#define pud_young(pud)		pte_young(pud_pte(pud))
>   #define pud_mkyoung(pud)	pte_pud(pte_mkyoung(pud_pte(pud)))
>   #define pud_write(pud)		pte_write(pud_pte(pud))
>   
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index d2c705e31584..a6d3ac9d7c7a 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1172,6 +1172,11 @@ static int stage2_pmdp_test_and_clear_young(pmd_t *pmd)
>   	return stage2_ptep_test_and_clear_young((pte_t *)pmd);
>   }
>   
> +static int stage2_pudp_test_and_clear_young(pud_t *pud)
> +{
> +	return stage2_ptep_test_and_clear_young((pte_t *)pud);
> +}
> +
>   /**
>    * kvm_phys_addr_ioremap - map a device range to guest IPA
>    *
> @@ -1879,42 +1884,42 @@ void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
>   
>   static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
>   {
> -	pmd_t *pmd;
> -	pte_t *pte;
> +	pud_t *pud = NULL;
> +	pmd_t *pmd = NULL;
> +	pte_t *pte = NULL;

minor nit: If you are spinning another revision, it would be good to get the
stage2_get_leaf_entry() to set the input parameters to NULL, rather than
expecting NULL and sprinkling this initialisation everywhere.

> +	bool found;
>   
> -	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE);
> -	pmd = stage2_get_pmd(kvm, NULL, gpa);
> -	if (!pmd || pmd_none(*pmd))	/* Nothing there */
> +	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
> +	found = stage2_get_leaf_entry(kvm, gpa, &pud, &pmd, &pte);
> +	if (!found)
>   		return 0;

minor nit: You may skip the variable here and below.
    
>   static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
>   {
> -	pmd_t *pmd;
> -	pte_t *pte;
> +	pud_t *pud = NULL;
> +	pmd_t *pmd = NULL;
> +	pte_t *pte = NULL;
> +	bool found;
>   
> -	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE);
> -	pmd = stage2_get_pmd(kvm, NULL, gpa);
> -	if (!pmd || pmd_none(*pmd))	/* Nothing there */
> +	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
> +	found = stage2_get_leaf_entry(kvm, gpa, &pud, &pmd, &pte);
> +	if (!found)
>   		return 0;


Either way,

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
