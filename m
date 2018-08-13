From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [PATCH v2 1/2] KVM: arm/arm64: Skip updating PMD entry if no change
Date: Mon, 13 Aug 2018 11:01:27 +0100
Message-ID: <87wosu1t6w.fsf@e105922-lin.cambridge.arm.com>
References: <20180813094049.3726-1-punit.agrawal@arm.com>
        <20180813094049.3726-2-punit.agrawal@arm.com>
        <ceb1927d-347a-7c49-1715-a309fab8d535@arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <ceb1927d-347a-7c49-1715-a309fab8d535@arm.com> (Suzuki
        K. Poulose's message of "Mon, 13 Aug 2018 10:46:04 +0100")
Sender: stable-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, stable@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Suzuki K Poulose <suzuki.poulose@arm.com> writes:

> On 08/13/2018 10:40 AM, Punit Agrawal wrote:
>> Contention on updating a PMD entry by a large number of vcpus can lead
>> to duplicate work when handling stage 2 page faults. As the page table
>> update follows the break-before-make requirement of the architecture,
>> it can lead to repeated refaults due to clearing the entry and
>> flushing the tlbs.
>>
>> This problem is more likely when -
>>
>> * there are large number of vcpus
>> * the mapping is large block mapping
>>
>> such as when using PMD hugepages (512MB) with 64k pages.
>>
>> Fix this by skipping the page table update if there is no change in
>> the entry being updated.
>>
>> Fixes: ad361f093c1e ("KVM: ARM: Support hugetlbfs backed huge pages")
>> Change-Id: Ib417957c842ef67a6f4b786f68df62048d202c24
>> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: Suzuki Poulose <suzuki.poulose@arm.com>
>> Cc: stable@vger.kernel.org
>> ---
>>   virt/kvm/arm/mmu.c | 40 +++++++++++++++++++++++++++++-----------
>>   1 file changed, 29 insertions(+), 11 deletions(-)
>>
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index 1d90d79706bd..2ab977edc63c 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -1015,19 +1015,36 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
>>   	pmd = stage2_get_pmd(kvm, cache, addr);
>>   	VM_BUG_ON(!pmd);
>>   -	/*
>> -	 * Mapping in huge pages should only happen through a fault.  If a
>> -	 * page is merged into a transparent huge page, the individual
>> -	 * subpages of that huge page should be unmapped through MMU
>> -	 * notifiers before we get here.
>> -	 *
>> -	 * Merging of CompoundPages is not supported; they should become
>> -	 * splitting first, unmapped, merged, and mapped back in on-demand.
>> -	 */
>> -	VM_BUG_ON(pmd_present(*pmd) && pmd_pfn(*pmd) != pmd_pfn(*new_pmd));
>> -
>>   	old_pmd = *pmd;
>> +
>>   	if (pmd_present(old_pmd)) {
>> +		/*
>> +		 * Mapping in huge pages should only happen through a
>> +		 * fault.  If a page is merged into a transparent huge
>> +		 * page, the individual subpages of that huge page
>> +		 * should be unmapped through MMU notifiers before we
>> +		 * get here.
>> +		 *
>> +		 * Merging of CompoundPages is not supported; they
>> +		 * should become splitting first, unmapped, merged,
>> +		 * and mapped back in on-demand.
>> +		 */
>> +		VM_BUG_ON(pmd_pfn(old_pmd) != pmd_pfn(*new_pmd));
>> +
>> +		/*
>> +		 * Multiple vcpus faulting on the same PMD entry, can
>> +		 * lead to them sequentially updating the PMD with the
>> +		 * same value. Following the break-before-make
>> +		 * (pmd_clear() followed by tlb_flush()) process can
>> +		 * hinder forward progress due to refaults generated
>> +		 * on missing translations.
>> +		 *
>> +		 * Skip updating the page table if the entry is
>> +		 * unchanged.
>> +		 */
>> +		if (pmd_val(old_pmd) == pmd_val(*new_pmd))
>> +			goto out;
>
> minor nit: You could as well return here, as there are no other users
> for the label and there are no clean up actions.

Ok - I'll do a quick respin for the maintainers to pick up if they are
happy with the other aspects of the patch.

>
> Either way,
>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Thanks Suzuki.

>
>
>> +
>>   		pmd_clear(pmd);
>>   		kvm_tlb_flush_vmid_ipa(kvm, addr);
>>   	} else {
>> @@ -1035,6 +1052,7 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
>>   	}
>>     	kvm_set_pmd(pmd, *new_pmd);
>> +out:
>>   	return 0;
>>   }
>>   
>>
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
