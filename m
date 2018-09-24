From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v7 9/9] KVM: arm64: Add support for creating PUD hugepages
 at stage 2
Date: Mon, 24 Sep 2018 22:21:43 +0100
Message-ID: <4df146fc-f9b0-882e-becb-056111a444d4@arm.com>
References: <20180924174552.8387-1-punit.agrawal@arm.com>
 <20180924174552.8387-10-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180924174552.8387-10-punit.agrawal@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Punit Agrawal <punit.agrawal@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@arm.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Punit,


On 09/24/2018 06:45 PM, Punit Agrawal wrote:
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


> 
> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index a42b9505c9a7..a8e86b926ee0 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -84,11 +84,14 @@ void kvm_clear_hyp_idmap(void);
>   
>   #define kvm_pfn_pte(pfn, prot)	pfn_pte(pfn, prot)
>   #define kvm_pfn_pmd(pfn, prot)	pfn_pmd(pfn, prot)
> +#define kvm_pfn_pud(pfn, prot)	(__pud(0))
>   
>   #define kvm_pud_pfn(pud)	({ BUG(); 0; })
>   
>   
>   #define kvm_pmd_mkhuge(pmd)	pmd_mkhuge(pmd)
> +/* No support for pud hugepages */
> +#define kvm_pud_mkhuge(pud)	(pud)
>   

shouldn't this be BUG() like other PUD huge helpers for arm32 ?

>   /*
>    * The following kvm_*pud*() functions are provided strictly to allow
> @@ -105,6 +108,23 @@ static inline bool kvm_s2pud_readonly(pud_t *pud)
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
> +


> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 3ff7ebb262d2..5b8163537bc2 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c

...


> @@ -1669,7 +1746,28 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	needs_exec = exec_fault ||
>   		(fault_status == FSC_PERM && stage2_is_exec(kvm, fault_ipa));
>   
> -	if (hugetlb && vma_pagesize == PMD_SIZE) {
> +	if (hugetlb && vma_pagesize == PUD_SIZE) {
> +		/*
> +		 * Assuming that PUD level always exists at Stage 2 -
> +		 * this is true for 4k pages with 40 bits IPA
> +		 * currently supported.
> +		 *
> +		 * When using 64k pages, 40bits of IPA results in
> +		 * using only 2-levels at Stage 2. Overlooking this
> +		 * problem for now as a PUD hugepage with 64k pages is
> +		 * too big (4TB) to be practical.
> +		 */
> +		pud_t new_pud = kvm_pfn_pud(pfn, mem_type);

Is this based on the Dynamic IPA series ? The cover letter seems
to suggest that it is. But I don't see the check to make sure we have
stage2 PUD level here before we go ahead and try PUD huge page at
stage2. Also the comment above seems outdated in that case.

> +
> +		new_pud = kvm_pud_mkhuge(new_pud);
> +		if (writable)
> +			new_pud = kvm_s2pud_mkwrite(new_pud);
> +
> +		if (needs_exec)
> +			new_pud = kvm_s2pud_mkexec(new_pud);
> +
> +		ret = stage2_set_pud_huge(kvm, memcache, fault_ipa, &new_pud);
> +	} else if (hugetlb && vma_pagesize == PMD_SIZE) {
>   		pmd_t new_pmd = kvm_pfn_pmd(pfn, mem_type);
>   
>   		new_pmd = kvm_pmd_mkhuge(new_pmd);
> 


Suzuki
