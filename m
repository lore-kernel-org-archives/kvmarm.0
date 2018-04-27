From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [PATCH 1/4] KVM: arm/arm64: Share common code in user_mem_abort()
Date: Fri, 27 Apr 2018 15:21:23 +0100
Message-ID: <87bme4zq58.fsf@e105922-lin.cambridge.arm.com>
References: <20180420145409.24485-1-punit.agrawal@arm.com>
        <20180420145409.24485-2-punit.agrawal@arm.com>
        <20180427111429.GL13249@C02W217FHV2R.local>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180427111429.GL13249@C02W217FHV2R.local> (Christoffer Dall's
        message of "Fri, 27 Apr 2018 13:14:29 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, suzuki.poulose@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Christoffer Dall <christoffer.dall@arm.com> writes:

> On Fri, Apr 20, 2018 at 03:54:06PM +0100, Punit Agrawal wrote:
>> The code for operations such as marking the pfn as dirty, and
>> dcache/icache maintenance during stage 2 fault handling is duplicated
>> between normal pages and PMD hugepages.
>> 
>> Instead of creating another copy of the operations when we introduce
>> PUD hugepages, let's share them across the different pagesizes.
>> 
>> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  virt/kvm/arm/mmu.c | 36 +++++++++++++++++++++---------------
>>  1 file changed, 21 insertions(+), 15 deletions(-)
>> 
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index 7f6a944db23d..db382c7c7cd7 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -1428,7 +1428,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	kvm_pfn_t pfn;
>>  	pgprot_t mem_type = PAGE_S2;
>>  	bool logging_active = memslot_is_logging(memslot);
>> -	unsigned long flags = 0;
>> +	unsigned long vma_pagesize, flags = 0;
>>  
>>  	write_fault = kvm_is_write_fault(vcpu);
>>  	exec_fault = kvm_vcpu_trap_is_iabt(vcpu);
>> @@ -1448,7 +1448,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  		return -EFAULT;
>>  	}
>>  
>> -	if (vma_kernel_pagesize(vma) == PMD_SIZE && !logging_active) {
>> +	vma_pagesize = vma_kernel_pagesize(vma);
>> +	if (vma_pagesize == PMD_SIZE && !logging_active) {
>>  		hugetlb = true;
>>  		gfn = (fault_ipa & PMD_MASK) >> PAGE_SHIFT;
>>  	} else {
>> @@ -1517,23 +1518,33 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	if (mmu_notifier_retry(kvm, mmu_seq))
>>  		goto out_unlock;
>>  
>> -	if (!hugetlb && !force_pte)
>> +	if (!hugetlb && !force_pte) {
>> +		/*
>> +		 * Only PMD_SIZE transparent hugepages(THP) are
>> +		 * currently supported. This code will need to be
>> +		 * updated if other THP sizes are supported.
>> +		 */
>>  		hugetlb = transparent_hugepage_adjust(&pfn, &fault_ipa);
>> +		vma_pagesize = PMD_SIZE;
>> +	}
>> +
>> +	if (writable)
>> +		kvm_set_pfn_dirty(pfn);
>> +
>> +	if (fault_status != FSC_PERM)
>> +		clean_dcache_guest_page(pfn, vma_pagesize);
>> +
>> +	if (exec_fault)
>> +		invalidate_icache_guest_page(pfn, vma_pagesize);
>>  
>>  	if (hugetlb) {
>>  		pmd_t new_pmd = pfn_pmd(pfn, mem_type);
>>  		new_pmd = pmd_mkhuge(new_pmd);
>> -		if (writable) {
>> +		if (writable)
>>  			new_pmd = kvm_s2pmd_mkwrite(new_pmd);
>> -			kvm_set_pfn_dirty(pfn);
>> -		}
>> -
>> -		if (fault_status != FSC_PERM)
>> -			clean_dcache_guest_page(pfn, PMD_SIZE);
>>  
>>  		if (exec_fault) {
>>  			new_pmd = kvm_s2pmd_mkexec(new_pmd);
>> -			invalidate_icache_guest_page(pfn, PMD_SIZE);
>>  		} else if (fault_status == FSC_PERM) {
>
> This could now be rewritten to:
>
> 		if (exec_fault ||
> 		    (fault_status == FSC_PERM && stage2_is_exec(kvm, fault_ipa)))
> 			new_pmd = kvm_s2pmd_mkexec(new_pmd);
>
> which we could even consider making
>
> static bool stage2_should_exec(struct kvm *kvm, phys_addr_t addr,
> 			       bool exec_fault, unsigned long fault_status)
> {
> 	/*
> 	 * If we took an execution fault we will have made the
> 	 * icache/dcache coherent and should now let the s2 mapping be
> 	 * executable.
> 	 *
> 	 * Write faults (!exec_fault && FSC_PERM) are orthogonal to
> 	 * execute permissions, and we preserve whatever we have.
> 	 */
> 	return exec_fault ||
> 	       (fault_status == FSC_PERM && stage2_is_exec(kvm, fault_ipa));
> }
>
> The benefit would be to have this documentation in a single place and
> slightly simply both the hugetlb and !hugetlb blocks.

Makes sense. And saves another copy when we introduce PUD handling in a
latter patch. I've rolled this in with minor changes.
>
>
>>  			/* Preserve execute if XN was already cleared */
>>  			if (stage2_is_exec(kvm, fault_ipa))
>> @@ -1546,16 +1557,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  
>>  		if (writable) {
>>  			new_pte = kvm_s2pte_mkwrite(new_pte);
>> -			kvm_set_pfn_dirty(pfn);
>>  			mark_page_dirty(kvm, gfn);
>>  		}
>>  
>> -		if (fault_status != FSC_PERM)
>> -			clean_dcache_guest_page(pfn, PAGE_SIZE);
>> -
>>  		if (exec_fault) {
>>  			new_pte = kvm_s2pte_mkexec(new_pte);
>> -			invalidate_icache_guest_page(pfn, PAGE_SIZE);
>>  		} else if (fault_status == FSC_PERM) {
>>  			/* Preserve execute if XN was already cleared */
>>  			if (stage2_is_exec(kvm, fault_ipa))
>> -- 
>> 2.17.0
>> 
>
> Notwithstanding my suggestion above:
>
> Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>

Thanks,
Punit
