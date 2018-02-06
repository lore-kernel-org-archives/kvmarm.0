From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [RFC 2/4] KVM: arm64: Support dirty page tracking for PUD hugepages
Date: Tue, 06 Feb 2018 18:13:50 +0000
Message-ID: <87a7wmhtpd.fsf@e105922-lin.cambridge.arm.com>
References: <20180110190729.18383-1-punit.agrawal@arm.com>
        <20180110190729.18383-3-punit.agrawal@arm.com>
        <20180206145508.GC23160@cbox>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180206145508.GC23160@cbox> (Christoffer Dall's message of
        "Tue, 6 Feb 2018 15:55:08 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, suzuki.poulose@arm.com, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Christoffer Dall <christoffer.dall@linaro.org> writes:

> On Wed, Jan 10, 2018 at 07:07:27PM +0000, Punit Agrawal wrote:
>> In preparation for creating PUD hugepages at stage 2, add support for
>> write protecting PUD hugepages when they are encountered. Write
>> protecting guest tables is used to track dirty pages when migrating VMs.
>> 
>> Also, provide trivial implementations of required kvm_s2pud_* helpers to
>> allow code to compile on arm32.
>> 
>> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@linaro.org>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm/include/asm/kvm_mmu.h   |  9 +++++++++
>>  arch/arm64/include/asm/kvm_mmu.h | 10 ++++++++++
>>  virt/kvm/arm/mmu.c               |  9 ++++++---
>>  3 files changed, 25 insertions(+), 3 deletions(-)
>> 
>> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
>> index fa6f2174276b..3fbe919b9181 100644
>> --- a/arch/arm/include/asm/kvm_mmu.h
>> +++ b/arch/arm/include/asm/kvm_mmu.h
>> @@ -103,6 +103,15 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
>>  	return (pmd_val(*pmd) & L_PMD_S2_RDWR) == L_PMD_S2_RDONLY;
>>  }
>>  
>> +static inline void kvm_set_s2pud_readonly(pud_t *pud)
>> +{
>> +}
>> +
>> +static inline bool kvm_s2pud_readonly(pud_t *pud)
>> +{
>> +	return true;
>
> why true?  Shouldn't this return the pgd's readonly value, strictly
> speaking, or if we rely on this never being called, have  VM_BUG_ON() ?

It returns true as it prevents a call to kvm_set_s2pud_readonly() but
both of the above functions should never be called on ARM due to
stage2_pud_huge() returning 0.

I'll add a VM_BUG_ON(pud) to indicate that these functions should never
be called and...

>
> In any case, a comment explaining why we unconditionally return true
> would be nice.

... add a comment to explain what's going on.

>
>> +}
>> +
>>  static inline bool kvm_page_empty(void *ptr)
>>  {
>>  	struct page *ptr_page = virt_to_page(ptr);
>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>> index 672c8684d5c2..dbfd18e08cfb 100644
>> --- a/arch/arm64/include/asm/kvm_mmu.h
>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>> @@ -201,6 +201,16 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
>>  	return kvm_s2pte_readonly((pte_t *)pmd);
>>  }
>>  
>> +static inline void kvm_set_s2pud_readonly(pud_t *pud)
>> +{
>> +	kvm_set_s2pte_readonly((pte_t *)pud);
>> +}
>> +
>> +static inline bool kvm_s2pud_readonly(pud_t *pud)
>> +{
>> +	return kvm_s2pte_readonly((pte_t *)pud);
>> +}
>> +
>>  static inline bool kvm_page_empty(void *ptr)
>>  {
>>  	struct page *ptr_page = virt_to_page(ptr);
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index 9dea96380339..02eefda5d71e 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -1155,9 +1155,12 @@ static void  stage2_wp_puds(pgd_t *pgd, phys_addr_t addr, phys_addr_t end)
>>  	do {
>>  		next = stage2_pud_addr_end(addr, end);
>>  		if (!stage2_pud_none(*pud)) {
>> -			/* TODO:PUD not supported, revisit later if supported */
>> -			BUG_ON(stage2_pud_huge(*pud));
>> -			stage2_wp_pmds(pud, addr, next);
>> +			if (stage2_pud_huge(*pud)) {
>> +				if (!kvm_s2pud_readonly(pud))
>> +					kvm_set_s2pud_readonly(pud);
>> +			} else {
>> +				stage2_wp_pmds(pud, addr, next);
>> +			}
>>  		}
>>  	} while (pud++, addr = next, addr != end);
>>  }
>> -- 
>> 2.15.1
>> 
>
> Otherwise:
>
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

Thanks for taking a look.

Punit
