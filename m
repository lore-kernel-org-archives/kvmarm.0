From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [PATCH v4 1/7] KVM: arm/arm64: Share common code in user_mem_abort()
Date: Thu, 05 Jul 2018 17:57:30 +0100
Message-ID: <87sh4xr56t.fsf@e105922-lin.cambridge.arm.com>
References: <20180705140850.5801-1-punit.agrawal@arm.com>
        <20180705140850.5801-2-punit.agrawal@arm.com>
        <b08f02c6-c44a-2016-3d95-7d818ec5f02d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b08f02c6-c44a-2016-3d95-7d818ec5f02d@arm.com> (Marc Zyngier's
        message of "Thu, 5 Jul 2018 17:24:14 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, christoffer.dall@arm.com, linux-kernel@vger.kernel.org, suzuki.poulose@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Marc Zyngier <marc.zyngier@arm.com> writes:

> Hi Punit,
>
> On 05/07/18 15:08, Punit Agrawal wrote:
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
>>  virt/kvm/arm/mmu.c | 68 +++++++++++++++++++++++++++-------------------
>>  1 file changed, 40 insertions(+), 28 deletions(-)
>> 
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index 1d90d79706bd..dd14cc36c51c 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -1398,6 +1398,21 @@ static void invalidate_icache_guest_page(kvm_pfn_t pfn, unsigned long size)
>>  	__invalidate_icache_guest_page(pfn, size);
>>  }
>>  
>> +static bool stage2_should_exec(struct kvm *kvm, phys_addr_t addr,
>> +			       bool exec_fault, unsigned long fault_status)
>
> I find this "should exec" very confusing.
>
>> +{
>> +	/*
>> +	 * If we took an execution fault we will have made the
>> +	 * icache/dcache coherent and should now let the s2 mapping be
>> +	 * executable.
>> +	 *
>> +	 * Write faults (!exec_fault && FSC_PERM) are orthogonal to
>> +	 * execute permissions, and we preserve whatever we have.
>> +	 */
>> +	return exec_fault ||
>> +		(fault_status == FSC_PERM && stage2_is_exec(kvm, addr));
>> +}
>> +
>>  static void kvm_send_hwpoison_signal(unsigned long address,
>>  				     struct vm_area_struct *vma)
>>  {
>> @@ -1431,7 +1446,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	kvm_pfn_t pfn;
>>  	pgprot_t mem_type = PAGE_S2;
>>  	bool logging_active = memslot_is_logging(memslot);
>> -	unsigned long flags = 0;
>> +	unsigned long vma_pagesize, flags = 0;
>>  
>>  	write_fault = kvm_is_write_fault(vcpu);
>>  	exec_fault = kvm_vcpu_trap_is_iabt(vcpu);
>> @@ -1451,7 +1466,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  		return -EFAULT;
>>  	}
>>  
>> -	if (vma_kernel_pagesize(vma) == PMD_SIZE && !logging_active) {
>> +	vma_pagesize = vma_kernel_pagesize(vma);
>> +	if (vma_pagesize == PMD_SIZE && !logging_active) {
>>  		hugetlb = true;
>>  		gfn = (fault_ipa & PMD_MASK) >> PAGE_SHIFT;
>>  	} else {
>> @@ -1520,28 +1536,34 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	if (mmu_notifier_retry(kvm, mmu_seq))
>>  		goto out_unlock;
>>  
>> -	if (!hugetlb && !force_pte)
>> +	if (!hugetlb && !force_pte) {
>> +		/*
>> +		 * Only PMD_SIZE transparent hugepages(THP) are
>> +		 * currently supported. This code will need to be
>> +		 * updated to support other THP sizes.
>> +		 */
>>  		hugetlb = transparent_hugepage_adjust(&pfn, &fault_ipa);
>> +		if (hugetlb)
>> +			vma_pagesize = PMD_SIZE;
>> +	}
>> +
>> +	if (writable)
>> +		kvm_set_pfn_dirty(pfn);
>>  
>> -	if (hugetlb) {
>> +	if (fault_status != FSC_PERM)
>> +		clean_dcache_guest_page(pfn, vma_pagesize);
>> +
>> +	if (exec_fault)
>> +		invalidate_icache_guest_page(pfn, vma_pagesize);
>> +
>> +	if (hugetlb && vma_pagesize == PMD_SIZE) {
>>  		pmd_t new_pmd = pfn_pmd(pfn, mem_type);
>>  		new_pmd = pmd_mkhuge(new_pmd);
>> -		if (writable) {
>> +		if (writable)
>>  			new_pmd = kvm_s2pmd_mkwrite(new_pmd);
>> -			kvm_set_pfn_dirty(pfn);
>> -		}
>>  
>> -		if (fault_status != FSC_PERM)
>> -			clean_dcache_guest_page(pfn, PMD_SIZE);
>> -
>> -		if (exec_fault) {
>> +		if (stage2_should_exec(kvm, fault_ipa, exec_fault, fault_status))
>>  			new_pmd = kvm_s2pmd_mkexec(new_pmd);
>
> OK, I find this absolutely horrid... ;-)
>
> The rest of the function deals with discrete flags, and all of a sudden
> we have a function call with a bunch of seemingly unrelated parameters.
> And you are repeating it for each vma_pagesize...
>
> How about something like:
>
> 	bool needs_exec;
>
> 	[...]
>
> 	needs_exec = exec_fault || (fault_status == FSC_PERM &&
> 				    stage2_is_exec(kvm, fault_ipa);
>
> And then you just check needs_exec to update the pte/pmd. And you drop
> this helper.

That does look a lot better. I'll roll the change into the next version.

Thanks,
Punit

[...]
