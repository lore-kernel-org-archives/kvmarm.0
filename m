From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [PATCH v5 7/7] KVM: arm64: Add support for creating PUD hugepages at stage 2
Date: Wed, 11 Jul 2018 17:05:57 +0100
Message-ID: <87zhyxoize.fsf@e105922-lin.cambridge.arm.com>
References: <20180709143835.28971-1-punit.agrawal@arm.com>
        <20180709144124.29164-1-punit.agrawal@arm.com>
        <20180709144124.29164-7-punit.agrawal@arm.com>
        <bbc3f286-be5b-d0dc-2037-54d5b995a0a5@arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <bbc3f286-be5b-d0dc-2037-54d5b995a0a5@arm.com> (Suzuki
        K. Poulose's message of "Wed, 11 Jul 2018 14:38:38 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, will.deacon@arm.com, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Suzuki K Poulose <Suzuki.Poulose@arm.com> writes:

> On 09/07/18 15:41, Punit Agrawal wrote:
>> KVM only supports PMD hugepages at stage 2. Now that the various page
>> handling routines are updated, extend the stage 2 fault handling to
>> map in PUD hugepages.
>>
>> Addition of PUD hugepage support enables additional page sizes (e.g.,
>> 1G with 4K granule) which can be useful on cores that support mapping
>> larger block sizes in the TLB entries.
>>
>> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Russell King <linux@armlinux.org.uk>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> ---
>>   arch/arm/include/asm/kvm_mmu.h         | 19 +++++++
>>   arch/arm64/include/asm/kvm_mmu.h       | 15 +++++
>>   arch/arm64/include/asm/pgtable-hwdef.h |  2 +
>>   arch/arm64/include/asm/pgtable.h       |  2 +
>>   virt/kvm/arm/mmu.c                     | 78 ++++++++++++++++++++++++--
>>   5 files changed, 112 insertions(+), 4 deletions(-)
>>

[...]

>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index a6d3ac9d7c7a..d8e2497e5353 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c

[...]

>> @@ -1100,6 +1139,7 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
>>   			  phys_addr_t addr, const pte_t *new_pte,
>>   			  unsigned long flags)
>>   {
>> +	pud_t *pud;
>>   	pmd_t *pmd;
>>   	pte_t *pte, old_pte;
>>   	bool iomap = flags & KVM_S2PTE_FLAG_IS_IOMAP;
>> @@ -1108,6 +1148,22 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
>>   	VM_BUG_ON(logging_active && !cache);
>>     	/* Create stage-2 page table mapping - Levels 0 and 1 */
>> +	pud = stage2_get_pud(kvm, cache, addr);
>> +	if (!pud) {
>> +		/*
>> +		 * Ignore calls from kvm_set_spte_hva for unallocated
>> +		 * address ranges.
>> +		 */
>> +		return 0;
>> +	}
>> +
>> +	/*
>> +	 * While dirty page logging - dissolve huge PUD, then continue
>> +	 * on to allocate page.
>
> Punit,
>
> We don't seem to allocate a page here for the PUD entry, in case if it is dissolved
> or empty (i.e, stage2_pud_none(*pud) is true.).

I was trying to avoid duplicating the PUD allocation by reusing the
functionality in stage2_get_pmd().

Does the below updated comment help?

	/*
	 * While dirty page logging - dissolve huge PUD, it'll be
	 * allocated in stage2_get_pmd().
	 */

The other option is to duplicate the stage2_pud_none() case from
stage2_get_pmd() here.

What do you think?

Thanks,
Punit

>> +	 */
>> +	if (logging_active)
>> +		stage2_dissolve_pud(kvm, addr, pud);
>> +
>>   	pmd = stage2_get_pmd(kvm, cache, addr);
>>   	if (!pmd) {
>
> And once you add an entry, pmd is just the matter of getting stage2_pmd_offset() from your pud.
> No need to start again from the top-level with stage2_get_pmd().
>
> Cheers
> Suzuki
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
