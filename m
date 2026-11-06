Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793974956;
	b=z2CppHEPpR+nvAAUsgEhFm4bOzOXzOFH/7BeSW3ZKpR2AMTheShN1rBMov+63FNV97IV
	 wqwBaAdX2+M3LjPmQfgcDayYyR5AoSwNaUGJEXOzAV9n/JbGPnWAn6EduyiaqTpLLzxa1
	 sHpgYJlYgqvQuA6DPRvkJJzwOGqgv/5bFJtgRF7CR8Y1LNt5l8r3GVNUnyKFhZDIuHiV+
	 if9Gud1G/O5uM2L73BxauruSIQvLXsCt3/AG+bVsefYxXZTcKgVR0tTUN6gZCy5h9kbYe
	 /KI/rxTen34MbkQSztqFXT0r5zpKl8B0XhfyGnY6xXLxNQqLTM+hafEr15bAegttMqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793974956;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=fTcrCWxsZHIriDZWkvIqlif7JUYF9Ion4vAVQflrPbU=;
	b=dZrj8ZL/4I5AC7C7E76PekN5E1ZU3/fhn422bxjThhX9SB4JPTDUTbf2GyCWzZoai1sL
	 wV9ZdrM+PeA1pszbLi/WK5xoc4DIRHmN0cmsLXc3icDnfgWglmwJ9r/e0MAQG4sT7VbOb
	 VziV6MGBafCD4W3br5nJH9Fr/1A70AJLTQmOgroYr2KUmK0L9C1uYmcEMy2IhX0SmayCX
	 tddMRwcd6GKHpl19jXNK+druDmcSj5AozpBJ7spCpCZaPhx797B/Qqo/zSLcjwMVV33FC
	 bd0k/5SPDG+v+7bxo1RgofOg2xvmhPpDogSCPaPV4xqytrZplSkDQzX+tNsW+7GAeUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=AzhrJoGR;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC042606A32E;
	Fri,  6 Nov 2026 14:22:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC042606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=AzhrJoGR
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A4C481650;
	Fri,  6 Nov 2026 06:22:30 -0800 (PST)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CB6D93F673;
	Fri,  6 Nov 2026 06:22:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793974953; bh=22RVcKJoZ5NKv3XgoNQ8sUIaq6jPGe49X9aSwuY2zBc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AzhrJoGR50jH4UI7p6E6V6JBsJGQJm7me4fObInq/JDMEgpaHqZNQporI5hUGwHp6
	 b0+Io29IXVu1Flqep4AA+q0a0PcTOEg1uQ9KPfHrPIO/OFTKcSnEawMDagq1wqXJC0
	 mP8tjhvkpxKtGKpK4MAHr2wmrZUPTpPRS2+NI1Uc=
Message-ID: <ae4f4bb4-4e72-47ac-8b91-d275484c22a8@arm.com>
Date: Fri, 6 Nov 2026 14:22:31 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/11] KVM: arm64: CCA: Add Realm stage-2 MMU operations
To: sashiko-reviews@lists.linux.dev, Steven Price <steven.price@arm.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-12-steven.price@arm.com>
 <sashiko-outbox-193812@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <sashiko-outbox-193812@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/11/2026 17:12, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 7 potential issue(s) to consider:
> - [Critical] KVM: arm64: read_lock() used instead of write_lock() in kvm_fault_lock()
> - [Critical] KVM: arm64: unaligned PFN and empty memcache on Realm permission faults
> - [High] KVM: arm64: uninitialized next_addr in realm_unmap_private_range()
> - [High] KVM: arm64: page accounting after page free in free_rtt()
> - [High] KVM: arm64: stage-2 PGD leak in kvm_uninit_stage2_mmu() for Realms
> - [High] KVM: arm64: leaked delegated pages on error in realm_map_protected()
> - [High] KVM: arm64: uninitialized out_top and positive error in realm_map_non_secure()
> --
> 
> commit c7041c45fed830c50c8f37ff21d6036da29c1302
> Author: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> KVM: arm64: CCA: Add Realm stage-2 MMU operations
> 
> This commit defines and registers realm_vm_s2_ops for VM_REALM, routing
> stage-2 unmapping through kvm_realm_unmap_range_filter() and stage-2 memory
> aborts through kvm_vm_mem_abort(). It also provides no-op TLB flush and GFN
> aging callbacks since the RMM manages stage-2 TLB invalidation and does not
> support stage-2 access flags.
> 
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 20aedbe6ec072..bb33c07569e3b 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
> 
> [ ... ]

...

> 
> [Severity: High]
> In the same unmap path, when realm_unmap_shared_range() or
> realm_unmap_private_range() folds RTT levels via
> realm_fold_rtt_level()->free_rtt(), does free_rtt() access the page after it
> has already been freed?
> 
> In arch/arm64/kvm/rmi.c:
> 
> static void free_rtt(phys_addr_t phys)
> {
> 	if (rmi_free_delegated_page(phys))
> 		return;
> 
> 	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
> }
> 
> And in drivers/firmware/arm_rmm/rmi.c:
> 
> int rmi_free_delegated_page(phys_addr_t phys)
> {
> 	if (WARN_ON_ONCE(rmi_undelegate_page(phys))) {
> 		/* Undelegate failed: leak the page */
> 		return -EBUSY;
> 	}
> 
> 	free_page((unsigned long)phys_to_virt(phys));
> 
> 	return 0;
> }
> 
> Because rmi_free_delegated_page() calls free_page() first (which uncharges the
> folio and clears its memcg association before returning the page to the
> allocator), calling kvm_account_pgtable_pages() afterwards touches a freed
> page and fails to decrement NR_SECONDARY_PAGETABLE on the original memcg.
> Should kvm_account_pgtable_pages(phys_to_virt(phys), -1) be called before
> free_page() (or before rmi_free_delegated_page())?
> 
> [ ... ]
> 
>> @@ -3291,6 +3313,15 @@ static const struct kvm_vm_s2_ops kvm_default_vm_s2_ops = {
>>   	.vm_mem_abort			= kvm_vm_mem_abort,
>>   };
>>   
>> +static const struct kvm_vm_s2_ops realm_vm_s2_ops = {
>> +	.vm_flush_remote_tlbs		= realm_flush_remote_tlbs,
>> +	.vm_flush_remote_tlbs_range	= realm_flush_remote_tlbs_range,
>> +	.vm_age_gfn			= no_age_gfn,
>> +	.vm_test_age_gfn		= no_age_gfn,
>> +	.vm_stage2_unmap_range		= realm_stage2_unmap_range,
>> +	.vm_mem_abort			= kvm_vm_mem_abort,
> 
> [Severity: Critical]
> When kvm_vm_mem_abort() handles stage-2 faults for a Realm VM via
> gmem_abort() or user_mem_abort()->kvm_s2_fault_map(), it acquires
> kvm->mmu_lock using kvm_fault_lock(kvm). Does kvm_fault_lock() take a read
> lock instead of a write lock for Realm VMs?
> 
> In arch/arm64/include/asm/kvm_mmu.h:
> 
> static inline void kvm_fault_lock(struct kvm *kvm)
> {
> 	if (is_protected_kvm_enabled())
> 		write_lock(&kvm->mmu_lock);
> 	else
> 		read_lock(&kvm->mmu_lock);
> }

We could change that to

	if (kvm_vm_hyp_is_distrusting(kvm))
		write_lock()
	else
		read_lock();


> [Severity: Critical]
> In kvm_vm_mem_abort()->user_mem_abort()->kvm_s2_fault_map(), how are stage-2
> permission faults on shared IPAs handled for Realm VMs?
> 
> First, in user_mem_abort():
> 
> 	memcache = get_mmu_memcache(s2fd->vcpu);
> 	if (!perm_fault || memslot_is_logging(s2fd->memslot) ||
> 	    is_protected_kvm_enabled()) {
> 		ret = topup_mmu_memcache(s2fd->mmu, memcache);
> 		if (ret)
> 			return ret;
> 	}
> 
> Because is_protected_kvm_enabled() is false for Realm VMs, memcache is not
> topped up on permission faults, even though realm_map_non_secure() unmaps and
> folds the existing RTT entry via realm_unmap_shared_range() and then allocates
> RTTs from memcache via realm_create_rtt_levels().
> 
> Second, in kvm_s2_fault_map():
> 
> 	if (mapping_size == PAGE_SIZE && s2vi->max_map_size != PAGE_SIZE) {
> 		if (perm_fault_granule > PAGE_SIZE) {
> 			mapping_size = perm_fault_granule;
> 		} else {
> 			mapping_size = transparent_hugepage_adjust(s2fd, &pfn, &gfn);
> 			if (mapping_size < 0) {
> 				ret = mapping_size;
> 				goto out_unlock;
> 			}
> 		}
> 		canonical_ipa = ALIGN_DOWN(canonical_ipa, mapping_size);
> 	}
> 
> 	if (!perm_fault_granule && !s2vi->map_non_cacheable && kvm_has_mte(kvm))
> 		sanitise_mte_tags(kvm, pfn, mapping_size);
> 
> 	if (kvm_vm_is_realm(kvm)) {
> 		ret = realm_map_ipa(kvm, s2fd->fault_ipa, pfn, mapping_size,
> 				    prot, memcache);
> 
> When perm_fault_granule > PAGE_SIZE on a THP VMA (where s2vi->vma_pagesize is
> PAGE_SIZE), kvm_s2_fault_map() sets mapping_size = perm_fault_granule without
> calling transparent_hugepage_adjust() to verify that the host VMA is still
> backed by a huge page (for example, if a write fault split the THP via CoW) or
> to align pfn down to mapping_size. For normal VMs this is safe because
> kvm_pgtable_stage2_relax_perms() does not use pfn, but for a Realm VM

I see, the cheaper option for us is to figure out the real granularity
at the host (rather than fixing up permissions at the *current* mapped
level). So I think it is better to adjust the pfn here locally.


> realm_map_ipa() aligns fault_ipa down to mapping_size while mapping from the
> unaligned 4KB pfn for mapping_size bytes. Can this map adjacent host physical
> pages beyond the end of the folio (or from a split THP) into the Realm guest?
> 
> [Severity: High]
> When kvm_vm_mem_abort() calls realm_map_ipa()->realm_map_protected(), can the
> err_undelegate path fail to undelegate the remaining unmapped pages if an
> error occurs after part of the range was already mapped?
> 
> In arch/arm64/kvm/rmi.c:
> 
> err_undelegate:
> 	realm_unmap_private_range(kvm, base_ipa, ipa, true);
> 	/* A range which cannot be undelegated remains owned by the RMM. */
> 	WARN_ON(rmi_undelegate_range(base_phys, map_size));
> 	return ret < 0 ? ret : -ENXIO;
> 
> If the loop mapped [base_ipa, ipa) before failing, realm_unmap_private_range()
> unmaps [base_ipa, ipa) and undelegates [base_phys, phys). Calling
> rmi_undelegate_range(base_phys, map_size) then starts at base_phys, which is
> already undelegated, so rmi_granule_range_undelegate() fails on the first page
> and aborts the loop, triggering the WARN_ON and leaving [phys,
> base_phys + map_size) permanently delegated. Should this call
> rmi_undelegate_range(phys, ipa_top - ipa) instead?

This is not true. RMI_GRANULE_UNDELEGATE() skips the granules that are
alreay UNDELEGATED. See "state" condition.


> 
> [Severity: High]
> In kvm_vm_mem_abort()->...->realm_map_ipa()->realm_map_non_secure(), what
> happens if rmi_rtt_unprot_map() returns a positive RMI error code?
> 
> In arch/arm64/kvm/rmi.c:
> 
> 		if (RMI_RESULT_STATUS(ret) == RMI_ERROR_RTT) {
> 			...
> 			ret = realm_create_rtt_levels(realm, ipa, level,
> 						      req_level,
> 						      memcache);
> 			if (ret)
> 				return ret;
> 
> 			ret = rmi_rtt_unprot_map(rd, ipa, ipa_top, flags,
> 						 range_desc, &out_top);
> 			if (ret < 0)
> 				return ret;
> 		}
> 
> 		if (ret && RMI_RESULT_STATUS(ret) != RMI_ERROR_RTT)
> 			return ret;
> 
> 		phys += out_top - ipa;
> 		ipa = out_top;
> 
> If the retry of rmi_rtt_unprot_map() after realm_create_rtt_levels() returns
> RMI_ERROR_RTT, out_top is never written by rmi_rtt_unprot_map(), and execution
> falls through to phys += out_top - ipa; ipa = out_top; using an uninitialized
> out_top. And if rmi_rtt_unprot_map() returns any other positive RMI status
> code, realm_map_non_secure() returns that positive value up through
> kvm_vm_mem_abort() to kvm_handle_guest_abort(), which treats positive return
> values as a successfully handled fault and re-enters the guest.

Yep, that is correct, we need to fix this.

> 
>> +};
>> +
>>   #define KVM_VM_S2_OPS(flavor, ops)		\
>>   		[flavor] = &(ops)
>>   
>> @@ -3299,7 +3330,7 @@ static const struct kvm_vm_s2_ops *arm64_vm_s2_ops[] = {
>>   	KVM_VM_S2_OPS(VM_NVHE, kvm_default_vm_s2_ops),
>>   	KVM_VM_S2_OPS(VM_PKVM, pkvm_vm_s2_ops),
>>   	KVM_VM_S2_OPS(VM_PROTECTED_PKVM, protected_pkvm_vm_s2_ops),
>> -	[VM_REALM] = NULL,
>> +	KVM_VM_S2_OPS(VM_REALM, realm_vm_s2_ops),
> 
> [Severity: High]
> Now that arm64_vm_s2_ops[VM_REALM] is populated, kvm_init_stage2_mmu()
> succeeds for Realm VMs and allocates mmu->pgt, its PGD pages, and
> mmu->last_vcpu_ran. Does kvm_uninit_stage2_mmu() leak those allocations if
> kvm_arch_init_vm() fails at err_uninit_mmu or if the VM is destroyed before
> the Realm is created?
> 
> In arch/arm64/kvm/mmu.c:
> 
> void kvm_uninit_stage2_mmu(struct kvm *kvm)
> {
> 	if (kvm_vm_is_realm(kvm))
> 		kvm_realm_uninit_stage2(&kvm->arch.mmu);
> 	else
> 		kvm_free_stage2_pgd(&kvm->arch.mmu);
> 	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
> }
> 
> And in arch/arm64/kvm/rmi.c:
> 
> void kvm_destroy_realm(struct kvm *kvm)
> {
> 	struct realm *realm = &kvm->arch.realm;
> 	int i;
> 
> 	if (!kvm_realm_is_created(kvm)) {
> 		kfree(realm->sro);
> 		realm->sro = NULL;
> 		return;
> 	}
> 	...
> 	kvm_free_stage2_pgd(&kvm->arch.mmu);
> }
> 
> When realm->state is REALM_STATE_NONE, kvm_realm_uninit_stage2() is a no-op
> and kvm_destroy_realm() returns early before calling
> kvm_free_stage2_pgd(&kvm->arch.mmu) (or is not called at all on the
> err_uninit_mmu failure path of kvm_arch_init_vm()), leaving mmu->pgt, the
> stage-2 PGD pages, and mmu->last_vcpu_ran allocated.

I think we have already discussed in a previous patch and will be addressed.


Cheers
Suzuki

> 

