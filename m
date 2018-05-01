From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [PATCH v2 2/4] KVM: arm/arm64: Introduce helpers to manupulate page table entries
Date: Tue, 01 May 2018 14:00:43 +0100
Message-ID: <871sevr0n8.fsf@e105922-lin.cambridge.arm.com>
References: <20180501102659.13188-1-punit.agrawal@arm.com>
        <20180501102659.13188-3-punit.agrawal@arm.com>
        <3eab5997-30b2-c51a-ca8e-5545bbadffc0@arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3eab5997-30b2-c51a-ca8e-5545bbadffc0@arm.com> (Suzuki
        K. Poulose's message of "Tue, 1 May 2018 11:36:26 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@arm.com, linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,

Thanks for having a look.

Suzuki K Poulose <Suzuki.Poulose@arm.com> writes:

> On 01/05/18 11:26, Punit Agrawal wrote:
>> Introduce helpers to abstract architectural handling of the conversion
>> of pfn to page table entries and marking a PMD page table entry as a
>> block entry.
>>
>> The helpers are introduced in preparation for supporting PUD hugepages
>> at stage 2 - which are supported on arm64 but do not exist on arm.
>
> Punit,
>
> The change are fine by me. However, we usually do not define kvm_*
> accessors for something which we know matches with the host variant.
> i.e, PMD and PTE helpers, which are always present and we make use
> of them directly. (see unmap_stage2_pmds for e.g)

In general, I agree - it makes sense to avoid duplication.

Having said that, the helpers here allow following a common pattern for
handling the various page sizes - pte, pmd and pud - during stage 2
fault handling (see patch 4).

As you've said you're OK with this change, I'd prefer to keep this patch
but will drop it if any others reviewers are concerned about the
duplication as well.

Thanks,
Punit

>
> Cheers
> Suzuki
>
>>
>> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
>> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Russell King <linux@armlinux.org.uk>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> ---
>>   arch/arm/include/asm/kvm_mmu.h   | 5 +++++
>>   arch/arm64/include/asm/kvm_mmu.h | 5 +++++
>>   virt/kvm/arm/mmu.c               | 7 ++++---
>>   3 files changed, 14 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
>> index 707a1f06dc5d..5907a81ad5c1 100644
>> --- a/arch/arm/include/asm/kvm_mmu.h
>> +++ b/arch/arm/include/asm/kvm_mmu.h
>> @@ -75,6 +75,11 @@ phys_addr_t kvm_get_idmap_vector(void);
>>   int kvm_mmu_init(void);
>>   void kvm_clear_hyp_idmap(void);
>>   +#define kvm_pfn_pte(pfn, prot)	pfn_pte(pfn, prot)
>> +#define kvm_pfn_pmd(pfn, prot)	pfn_pmd(pfn, prot)
>> +
>> +#define kvm_pmd_mkhuge(pmd)	pmd_mkhuge(pmd)
>> +
>>   static inline void kvm_set_pmd(pmd_t *pmd, pmd_t new_pmd)
>>   {
>>   	*pmd = new_pmd;
>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>> index 082110993647..d962508ce4b3 100644
>> --- a/arch/arm64/include/asm/kvm_mmu.h
>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>> @@ -173,6 +173,11 @@ void kvm_clear_hyp_idmap(void);
>>   #define	kvm_set_pte(ptep, pte)		set_pte(ptep, pte)
>>   #define	kvm_set_pmd(pmdp, pmd)		set_pmd(pmdp, pmd)
>>   +#define kvm_pfn_pte(pfn, prot)		pfn_pte(pfn, prot)
>> +#define kvm_pfn_pmd(pfn, prot)		pfn_pmd(pfn, prot)
>> +
>> +#define kvm_pmd_mkhuge(pmd)		pmd_mkhuge(pmd)
>> +
>>   static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
>>   {
>>   	pte_val(pte) |= PTE_S2_RDWR;
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index 686fc6a4b866..74750236f445 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -1554,8 +1554,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   		invalidate_icache_guest_page(pfn, vma_pagesize);
>>     	if (hugetlb) {
>> -		pmd_t new_pmd = pfn_pmd(pfn, mem_type);
>> -		new_pmd = pmd_mkhuge(new_pmd);
>> +		pmd_t new_pmd = kvm_pfn_pmd(pfn, mem_type);
>> +
>> +		new_pmd = kvm_pmd_mkhuge(new_pmd);
>>   		if (writable)
>>   			new_pmd = kvm_s2pmd_mkwrite(new_pmd);
>>   @@ -1564,7 +1565,7 @@ static int user_mem_abort(struct kvm_vcpu
>> *vcpu, phys_addr_t fault_ipa,
>>     		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa,
>> &new_pmd);
>>   	} else {
>> -		pte_t new_pte = pfn_pte(pfn, mem_type);
>> +		pte_t new_pte = kvm_pfn_pte(pfn, mem_type);
>>     		if (writable) {
>>   			new_pte = kvm_s2pte_mkwrite(new_pte);
>>
