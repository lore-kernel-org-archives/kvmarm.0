From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [RFC 4/4] KVM: arm64: Add support for PUD hugepages at stage 2
Date: Tue, 06 Feb 2018 18:13:38 +0000
Message-ID: <87bmh2htpp.fsf@e105922-lin.cambridge.arm.com>
References: <20180110190729.18383-1-punit.agrawal@arm.com>
        <20180110190729.18383-5-punit.agrawal@arm.com>
        <20180206145501.GB23160@cbox>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180206145501.GB23160@cbox> (Christoffer Dall's message of
        "Tue, 6 Feb 2018 15:55:01 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, suzuki.poulose@arm.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Christoffer Dall <christoffer.dall@linaro.org> writes:

> On Wed, Jan 10, 2018 at 07:07:29PM +0000, Punit Agrawal wrote:
>> KVM only supports PMD hugepages at stage 2. Extend the stage 2 fault
>> handling to add support for PUD hugepages.
>> 
>> Addition of PUD hugpage support enables additional hugepage sizes (1G
>
>                  *hugepage
>
>> with 4K granule and 4TB with 64k granule) which can be useful on cores
>> that have support for mapping larger block sizes in the TLB entries.
>> 
>> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@linaro.org>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> ---
>>  arch/arm/include/asm/kvm_mmu.h         | 10 +++++
>>  arch/arm/include/asm/pgtable-3level.h  |  2 +
>>  arch/arm64/include/asm/kvm_mmu.h       | 19 +++++++++
>>  arch/arm64/include/asm/pgtable-hwdef.h |  2 +
>>  arch/arm64/include/asm/pgtable.h       |  4 ++
>>  virt/kvm/arm/mmu.c                     | 72 +++++++++++++++++++++++++++++-----
>>  6 files changed, 99 insertions(+), 10 deletions(-)
>> 

[...]

>> diff --git a/arch/arm/include/asm/pgtable-3level.h b/arch/arm/include/asm/pgtable-3level.h
>> index 1a7a17b2a1ba..97e04fdbfa85 100644
>> --- a/arch/arm/include/asm/pgtable-3level.h
>> +++ b/arch/arm/include/asm/pgtable-3level.h
>> @@ -249,6 +249,8 @@ PMD_BIT_FUNC(mkyoung,   |= PMD_SECT_AF);
>>  #define pfn_pmd(pfn,prot)	(__pmd(((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot)))
>>  #define mk_pmd(page,prot)	pfn_pmd(page_to_pfn(page),prot)
>>  
>> +#define pud_pfn(pud)		(((pud_val(pud) & PUD_MASK) & PHYS_MASK) >> PAGE_SHIFT)
>> +
>
> does this make sense on 32-bit arm?  Is this ever going to get called
> and return something meaningful in that case?

This macro should never get called as there are no PUD_SIZE hugepages on
arm.

Ideally we want to fold the pud to fallback to pgd like in the rest of
the code. I'll have another go at this.

>
>>  /* represent a notpresent pmd by faulting entry, this is used by pmdp_invalidate */
>>  static inline pmd_t pmd_mknotpresent(pmd_t pmd)
>>  {

[...]


>> @@ -1393,17 +1424,38 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	if (mmu_notifier_retry(kvm, mmu_seq))
>>  		goto out_unlock;
>>  
>> -	if (!hugetlb && !force_pte)
>> +	if (!hugetlb && !force_pte) {
>> +		/*
>> +		 * We only support PMD_SIZE transparent
>> +		 * hugepages. This code will need updates if we enable
>> +		 * other page sizes for THP.
>> +		 */
>>  		hugetlb = transparent_hugepage_adjust(&pfn, &fault_ipa);
>> +		vma_pagesize = PMD_SIZE;
>> +	}
>>  
>>  	if (hugetlb) {
>> -		pmd_t new_pmd = stage2_build_pmd(pfn, mem_type, writable);
>> -
>> -		if (writable)
>> -			kvm_set_pfn_dirty(pfn);
>> -
>> -		coherent_cache_guest_page(vcpu, pfn, PMD_SIZE);
>> -		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
>> +		if (vma_pagesize == PUD_SIZE) {
>> +			pud_t new_pud;
>> +
>> +			new_pud = stage2_build_pud(pfn, mem_type, writable);
>> +			if (writable)
>> +				kvm_set_pfn_dirty(pfn);
>> +
>> +			coherent_cache_guest_page(vcpu, pfn, PUD_SIZE);
>> +			ret = stage2_set_pud_huge(kvm, memcache,
>> +						  fault_ipa, &new_pud);
>> +		} else {
>> +			pmd_t new_pmd;
>> +
>> +			new_pmd = stage2_build_pmd(pfn, mem_type, writable);
>> +			if (writable)
>> +				kvm_set_pfn_dirty(pfn);
>> +
>> +			coherent_cache_guest_page(vcpu, pfn, PMD_SIZE);
>> +			ret = stage2_set_pmd_huge(kvm, memcache,
>> +						  fault_ipa, &new_pmd);
>> +		}
>
> This stuff needs rebasing onto v4.16-rc1 when we get there, and it will
> clash with Marc's icache optimizations.

Thanks for the heads up.

>
> But, you should be able to move kvm_set_pfn_dirty() out of the
> size-conditional section and also call the cache maintenance functions
> using vma_pagesize as parameter.

Agreed - I'll roll these suggestions into the next version.

Thanks a lot for the review.

Punit
