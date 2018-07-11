From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v5 5/7] KVM: arm64: Support handling access faults for PUD
 hugepages
Date: Wed, 11 Jul 2018 14:16:56 +0100
Message-ID: <be9492ce-271c-e87f-e934-a6bb3a5ac119@arm.com>
References: <20180709143835.28971-1-punit.agrawal@arm.com>
 <20180709144124.29164-1-punit.agrawal@arm.com>
 <20180709144124.29164-5-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180709144124.29164-5-punit.agrawal@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Punit Agrawal <punit.agrawal@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@arm.com, linux-kernel@vger.kernel.org, will.deacon@arm.com, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 09/07/18 15:41, Punit Agrawal wrote:
> In preparation for creating larger hugepages at Stage 2, extend the
> access fault handling at Stage 2 to support PUD hugepages when
> encountered.
> 
> Provide trivial helpers for arm32 to allow sharing of code.
> 
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>   arch/arm/include/asm/kvm_mmu.h   |  8 ++++++++
>   arch/arm64/include/asm/kvm_mmu.h |  7 +++++++
>   arch/arm64/include/asm/pgtable.h |  6 ++++++
>   virt/kvm/arm/mmu.c               | 29 ++++++++++++++++-------------
>   4 files changed, 37 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index d05c8986e495..a4298d429efc 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -78,6 +78,8 @@ void kvm_clear_hyp_idmap(void);
>   #define kvm_pfn_pte(pfn, prot)	pfn_pte(pfn, prot)
>   #define kvm_pfn_pmd(pfn, prot)	pfn_pmd(pfn, prot)
>   
> +#define kvm_pud_pfn(pud)	(((pud_val(pud) & PUD_MASK) & PHYS_MASK) >> PAGE_SHIFT)

Since we don't have PUD in arm32, it would be good to trigger a BUG()
instead of silently doing something wrong.

> @@ -102,6 +104,12 @@ static inline bool kvm_s2pud_exec(pud_t *pud)
>   	return false;
>   }
>   
> +static inline pud_t kvm_s2pud_mkyoung(pud_t pud)
> +{
> +	BUG();
> +	return pud;
> +}
> +

Like this. ^

> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index e73909a31e02..d2c705e31584 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1637,33 +1637,36 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>    */
>   static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>   {
> -	pmd_t *pmd;
> -	pte_t *pte;
> +	pud_t *pud = NULL;
> +	pmd_t *pmd = NULL;
> +	pte_t *pte = NULL;
>   	kvm_pfn_t pfn;
> -	bool pfn_valid = false;
> +	bool found, pfn_valid = false;

nit: You could use pfn_valid instead of a new "found" variable.

>   
>   	trace_kvm_access_fault(fault_ipa);
>   
>   	spin_lock(&vcpu->kvm->mmu_lock);
>   
> -	pmd = stage2_get_pmd(vcpu->kvm, NULL, fault_ipa);
> -	if (!pmd || pmd_none(*pmd))	/* Nothing there */
> +	found = stage2_get_leaf_entry(vcpu->kvm, fault_ipa, &pud, &pmd, &pte);
> +	if (!found)
>   		goto out;
>   
> -	if (pmd_thp_or_huge(*pmd)) {	/* THP, HugeTLB */
> +	if (pud) {		/* HugeTLB */
> +		*pud = kvm_s2pud_mkyoung(*pud);
> +		pfn = kvm_pud_pfn(*pud);
> +		pfn_valid = true;
> +		goto out;

You don't need these goto's and the out lable anymore.

> +	} else 	if (pmd) {	/* THP, HugeTLB */
>   		*pmd = pmd_mkyoung(*pmd);
>   		pfn = pmd_pfn(*pmd);
>   		pfn_valid = true;
>   		goto out;
> +	} else {
> +		*pte = pte_mkyoung(*pte);	/* Just a page... */
> +		pfn = pte_pfn(*pte);
> +		pfn_valid = true;
>   	}
>   
> -	pte = pte_offset_kernel(pmd, fault_ipa);
> -	if (pte_none(*pte))		/* Nothing there either */
> -		goto out;
> -
> -	*pte = pte_mkyoung(*pte);	/* Just a page... */
> -	pfn = pte_pfn(*pte);
> -	pfn_valid = true;
>   out:
>   	spin_unlock(&vcpu->kvm->mmu_lock);
>   	if (pfn_valid)
> 

Otherwise look good to me.

Suzuki
