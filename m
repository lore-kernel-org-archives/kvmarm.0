From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [PATCH v2 1/2] KVM: arm/arm64: Skip updating PMD entry if no change
Date: Mon, 13 Aug 2018 11:18:35 +0100
Message-ID: <87sh3i1sec.fsf@e105922-lin.cambridge.arm.com>
References: <20180813094049.3726-1-punit.agrawal@arm.com>
        <20180813094049.3726-2-punit.agrawal@arm.com>
        <e265fe94-aa14-00c5-b144-4eff77413f5a@arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e265fe94-aa14-00c5-b144-4eff77413f5a@arm.com> (Marc Zyngier's
        message of "Mon, 13 Aug 2018 11:11:30 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, stable@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Marc Zyngier <marc.zyngier@arm.com> writes:

> Hi Punit,
>
> On 13/08/18 10:40, Punit Agrawal wrote:

[...]

>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index 1d90d79706bd..2ab977edc63c 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -1015,19 +1015,36 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
>>  	pmd = stage2_get_pmd(kvm, cache, addr);
>>  	VM_BUG_ON(!pmd);
>>  
>> -	/*
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
>>  	old_pmd = *pmd;
>> +
>>  	if (pmd_present(old_pmd)) {
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
> I think the order of these two checks should be reversed: the first one
> is clearly a subset of the second one, so it'd make sense to have the
> global comparison before having the more specific one. Not that it
> matter much in practice, but I just find it easier to reason about.

Makes sense. I've reordered the checks for the next version.

Thanks,
Punit

>
>> +
>>  		pmd_clear(pmd);
>>  		kvm_tlb_flush_vmid_ipa(kvm, addr);
>>  	} else {
>> @@ -1035,6 +1052,7 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
>>  	}
>>  
>>  	kvm_set_pmd(pmd, *new_pmd);
>> +out:
>>  	return 0;
>>  }
>>  
>> 
>
> Thanks,
>
> 	M.
