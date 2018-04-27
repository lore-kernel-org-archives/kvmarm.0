From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [PATCH 4/4] KVM: arm64: Add support for PUD hugepages at stage 2
Date: Fri, 27 Apr 2018 15:50:44 +0100
Message-ID: <877eoszosb.fsf@e105922-lin.cambridge.arm.com>
References: <20180420145409.24485-1-punit.agrawal@arm.com>
        <20180420145409.24485-5-punit.agrawal@arm.com>
        <20180427111422.GK13249@C02W217FHV2R.local>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180427111422.GK13249@C02W217FHV2R.local> (Christoffer Dall's
        message of "Fri, 27 Apr 2018 13:14:22 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: marc.zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Christoffer Dall <christoffer.dall@arm.com> writes:

> On Fri, Apr 20, 2018 at 03:54:09PM +0100, Punit Agrawal wrote:
>> KVM only supports PMD hugepages at stage 2. Extend the stage 2 fault
>> handling to add support for PUD hugepages.
>> 
>> Addition of pud hugepage support enables additional hugepage
>> sizes (e.g., 1G with 4K granule) which can be useful on cores that
>> support mapping larger block sizes in the TLB entries.
>> 
>> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Russell King <linux@armlinux.org.uk>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> ---
>>  arch/arm/include/asm/kvm_mmu.h         | 19 +++++++++
>>  arch/arm64/include/asm/kvm_mmu.h       | 15 +++++++
>>  arch/arm64/include/asm/pgtable-hwdef.h |  4 ++
>>  arch/arm64/include/asm/pgtable.h       |  2 +
>>  virt/kvm/arm/mmu.c                     | 54 ++++++++++++++++++++------
>>  5 files changed, 83 insertions(+), 11 deletions(-)
>> 

[...]

>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c

[...]

>> @@ -1452,9 +1472,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	}
>>  
>>  	vma_pagesize = vma_kernel_pagesize(vma);
>> -	if (vma_pagesize == PMD_SIZE && !logging_active) {
>> +	if ((vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE) &&
>> +	    !logging_active) {
>> +		struct hstate *h = hstate_vma(vma);
>> +
>>  		hugetlb = true;
>> -		gfn = (fault_ipa & PMD_MASK) >> PAGE_SHIFT;
>> +		gfn = (fault_ipa & huge_page_mask(h)) >> PAGE_SHIFT;
>>  	} else {
>>  		/*
>>  		 * Pages belonging to memslots that don't have the same
>> @@ -1521,15 +1544,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	if (mmu_notifier_retry(kvm, mmu_seq))
>>  		goto out_unlock;
>>  
>> -	if (!hugetlb && !force_pte) {
>> -		/*
>> -		 * Only PMD_SIZE transparent hugepages(THP) are
>> -		 * currently supported. This code will need to be
>> -		 * updated if other THP sizes are supported.
>> -		 */
>> +	if (!hugetlb && !force_pte)
>>  		hugetlb = transparent_hugepage_adjust(&pfn, &fault_ipa);
>> -		vma_pagesize = PMD_SIZE;
>
> Why this change?  Won't you end up trying to map THPs as individual
> pages now?

Argh - that's a rebase gone awry. Thanks for spotting.

There's another issue with this hunk - hugetlb can be false after the
call to transparent_hugepage_adjust(). I've fixed that up for the next
update.

>
>> -	}
>>  
>>  	if (writable)
>>  		kvm_set_pfn_dirty(pfn);
>> @@ -1540,7 +1556,23 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	if (exec_fault)
>>  		invalidate_icache_guest_page(pfn, vma_pagesize);
>>  
>> -	if (hugetlb) {
>> +	if (vma_pagesize == PUD_SIZE) {
>> +		pud_t new_pud = kvm_pfn_pud(pfn, mem_type);
>> +
>> +		new_pud = kvm_pud_mkhuge(new_pud);
>> +		if (writable)
>> +			new_pud = kvm_s2pud_mkwrite(new_pud);
>> +
>> +		if (exec_fault) {
>> +			new_pud = kvm_s2pud_mkexec(new_pud);
>> +		} else if (fault_status == FSC_PERM) {
>> +			/* Preserve execute if XN was already cleared */
>> +			if (stage2_is_exec(kvm, fault_ipa))
>> +				new_pud = kvm_s2pud_mkexec(new_pud);
>> +		}
>
> aha, another reason for my suggestion in the other patch.

Ack! Already fixed locally.

>
>> +
>> +		ret = stage2_set_pud_huge(kvm, memcache, fault_ipa, &new_pud);
>> +	} else if (vma_pagesize == PMD_SIZE) {
>>  		pmd_t new_pmd = kvm_pfn_pmd(pfn, mem_type);
>>  
>>  		new_pmd = kvm_pmd_mkhuge(new_pmd);
>> -- 
>> 2.17.0
>> 
>
> Otherwise, this patch looks fine.

Thanks a lot for reviewing the patches. I'll send out an update
incorporating your suggestions.

Punit
