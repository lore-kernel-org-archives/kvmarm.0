From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v5 7/7] KVM: arm64: Add support for creating PUD hugepages
 at stage 2
Date: Wed, 11 Jul 2018 17:13:54 +0100
Message-ID: <fe8b92a1-2584-61ab-39e2-4d3247f92c7c@arm.com>
References: <20180709143835.28971-1-punit.agrawal@arm.com>
 <20180709144124.29164-1-punit.agrawal@arm.com>
 <20180709144124.29164-7-punit.agrawal@arm.com>
 <bbc3f286-be5b-d0dc-2037-54d5b995a0a5@arm.com>
 <87zhyxoize.fsf@e105922-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87zhyxoize.fsf@e105922-lin.cambridge.arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, will.deacon@arm.com, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 11/07/18 17:05, Punit Agrawal wrote:
> Suzuki K Poulose <Suzuki.Poulose@arm.com> writes:
> 
>> On 09/07/18 15:41, Punit Agrawal wrote:
>>> KVM only supports PMD hugepages at stage 2. Now that the various page
>>> handling routines are updated, extend the stage 2 fault handling to
>>> map in PUD hugepages.
>>>
>>> Addition of PUD hugepage support enables additional page sizes (e.g.,
>>> 1G with 4K granule) which can be useful on cores that support mapping
>>> larger block sizes in the TLB entries.
>>>
>>> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
>>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>> Cc: Russell King <linux@armlinux.org.uk>
>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>> Cc: Will Deacon <will.deacon@arm.com>
>>> ---
>>>    arch/arm/include/asm/kvm_mmu.h         | 19 +++++++
>>>    arch/arm64/include/asm/kvm_mmu.h       | 15 +++++
>>>    arch/arm64/include/asm/pgtable-hwdef.h |  2 +
>>>    arch/arm64/include/asm/pgtable.h       |  2 +
>>>    virt/kvm/arm/mmu.c                     | 78 ++++++++++++++++++++++++--
>>>    5 files changed, 112 insertions(+), 4 deletions(-)
>>>
> 
> [...]
> 
>>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>>> index a6d3ac9d7c7a..d8e2497e5353 100644
>>> --- a/virt/kvm/arm/mmu.c
>>> +++ b/virt/kvm/arm/mmu.c
> 
> [...]
> 
>>> @@ -1100,6 +1139,7 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
>>>    			  phys_addr_t addr, const pte_t *new_pte,
>>>    			  unsigned long flags)
>>>    {
>>> +	pud_t *pud;
>>>    	pmd_t *pmd;
>>>    	pte_t *pte, old_pte;
>>>    	bool iomap = flags & KVM_S2PTE_FLAG_IS_IOMAP;
>>> @@ -1108,6 +1148,22 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
>>>    	VM_BUG_ON(logging_active && !cache);
>>>      	/* Create stage-2 page table mapping - Levels 0 and 1 */
>>> +	pud = stage2_get_pud(kvm, cache, addr);
>>> +	if (!pud) {
>>> +		/*
>>> +		 * Ignore calls from kvm_set_spte_hva for unallocated
>>> +		 * address ranges.
>>> +		 */
>>> +		return 0;
>>> +	}
>>> +
>>> +	/*
>>> +	 * While dirty page logging - dissolve huge PUD, then continue
>>> +	 * on to allocate page.
>>
>> Punit,
>>
>> We don't seem to allocate a page here for the PUD entry, in case if it is dissolved
>> or empty (i.e, stage2_pud_none(*pud) is true.).
> 
> I was trying to avoid duplicating the PUD allocation by reusing the
> functionality in stage2_get_pmd().
> 
> Does the below updated comment help?
> 
> 	/*
> 	 * While dirty page logging - dissolve huge PUD, it'll be
> 	 * allocated in stage2_get_pmd().
> 	 */
> 
> The other option is to duplicate the stage2_pud_none() case from
> stage2_get_pmd() here.

I think the explicit check for stage2_pud_none() suits better here.
That would make it explicit that we are tearing down the entries
from top to bottom. Also, we may be able to short cut for case
where we know we just allocated a PUD page and hence we need another
PMD level page.

Also, you are missing the comment about the assumption that stage2 PUD
level always exist with 4k fixed IPA.

Cheers
Suzuki
