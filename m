From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v8 9/9] KVM: arm64: Add support for creating PUD hugepages
 at stage 2
Date: Mon, 1 Oct 2018 22:30:00 +0100
Message-ID: <3bd022cd-e470-479a-d7a5-680810db6a42@arm.com>
References: <20181001155443.23032-1-punit.agrawal@arm.com>
 <20181001155443.23032-10-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181001155443.23032-10-punit.agrawal@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Punit Agrawal <punit.agrawal@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@arm.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 10/01/2018 04:54 PM, Punit Agrawal wrote:
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
>   arch/arm/include/asm/kvm_mmu.h         |  20 +++++
>   arch/arm/include/asm/stage2_pgtable.h  |   9 +++
>   arch/arm64/include/asm/kvm_mmu.h       |  16 ++++
>   arch/arm64/include/asm/pgtable-hwdef.h |   2 +
>   arch/arm64/include/asm/pgtable.h       |   2 +
>   virt/kvm/arm/mmu.c                     | 106 +++++++++++++++++++++++--
>   6 files changed, 149 insertions(+), 6 deletions(-)
> 

...

> diff --git a/arch/arm/include/asm/stage2_pgtable.h b/arch/arm/include/asm/stage2_pgtable.h
> index f6a7ea805232..a4ec25360e50 100644
> --- a/arch/arm/include/asm/stage2_pgtable.h
> +++ b/arch/arm/include/asm/stage2_pgtable.h
> @@ -68,4 +68,13 @@ stage2_pmd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
>   #define stage2_pmd_table_empty(kvm, pmdp)	kvm_page_empty(pmdp)
>   #define stage2_pud_table_empty(kvm, pudp)	false
>   
> +static inline bool kvm_stage2_has_pud(struct kvm *kvm)
> +{
> +#if CONFIG_PGTABLE_LEVELS > 3
> +	return true;
> +#else
> +	return false;
> +#endif

nit: We can only have PGTABLE_LEVELS=3 on ARM with LPAE.
AFAIT, this can be set to false always for ARM.

> +}
> +

...

> @@ -1669,7 +1752,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	needs_exec = exec_fault ||
>   		(fault_status == FSC_PERM && stage2_is_exec(kvm, fault_ipa));
>   
> -	if (hugetlb && vma_pagesize == PMD_SIZE) {
> +	if (hugetlb && vma_pagesize == PUD_SIZE) {
> +		pud_t new_pud = kvm_pfn_pud(pfn, mem_type);
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


Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
