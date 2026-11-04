Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793807518;
	b=XNqzOqeXiqFKVjTsU3HrwluJPWMN1VnzUfKNaiS1SixjOar3KiKe7CLPLriLrOetsOkH
	 df6EADmFNH3+hdm5fmmT/rEHulyFZITmR1J//hxVydTBD8igABjd3ZrFqWNAfcuyWnqIN
	 pIZ2J4A3JK8yMZK9hSnHX/5KzufY51paIZPYypoGo7ste+KdA7/g46Qleyi2oIj5TMuv5
	 /D7jxZq1i7Q69xkRjezYIRE1dDLCnt+++oUDRVZhtcdTN650vzKSIb15puPyIjON0GZMF
	 +BaR6jMpW5lX63pK+yac4Gb6acsA2bSayfMliSGHuhlvUnmcs53uG7py3zjNjsTenMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793807518;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=E+mCTJ1/zlQAccC0oSzxyVS68k7b/xSMswKz6SrmrhI=;
	b=P4TV379I3hcEVSjjLBTLxbn7WPLeQpjXAwwmaAsow5DmCrMFc/3ujQo6VTdkBIVb+OTk
	 VEoB89I0MgFDJtFObSYcBhm5tt86r9MORZhD0BwJ0yCp+4eWIvli6ppObgGRpQoN6DDlH
	 TpFKP3aQWqlk1HAZw4rZK22Ux8OU0bHYpZ+Y62LEkDOY/Gm8z7iwTQdIy7JwYu/zzecf6
	 ciRCFL6nKnYKZ7e675eqAGeGK5OqX3gkAfbHI9vT8BVciLh2H6pefrZ2IJXnKx1/J3C+v
	 WI7jiSh/JO+n4Qyt9zH9TCYbzUXVchXuHEn8sut67TNsiPPUsyzNZpCS7Nj/fzkM1Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Va5Hv74m;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC207606A31B;
	Wed,  4 Nov 2026 15:51:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC207606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Va5Hv74m
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 16F501BB0;
	Wed,  4 Nov 2026 07:51:53 -0800 (PST)
Received: from [10.57.59.2] (unknown [10.57.59.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C40A53F632;
	Wed,  4 Nov 2026 07:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793807516; bh=OO2b33YKQQ5mum9nj/fFLFvzFP58I0Bk4MB+r57vJts=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Va5Hv74mGtQDSlgyyStTOy0slW+Khat1+XB/cz5rzlb0LknjwwEmgGeICztDlitBf
	 ccdVaROOgoOCKJ4FgUGARC/CP+oevJRhHBF6pTBKJlYOWZEOr7F6az5TJ3Qv0ngG7f
	 Jj2QyrLwEbWyhO1ronI4ElJqaQIi2/NDperbSffI=
Message-ID: <11726b5e-6bc9-473d-b587-cb2dc5dcfd42@arm.com>
Date: Wed, 4 Nov 2026 15:51:52 +0000
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
Subject: Re: [PATCH 10/11] KVM: arm64: CCA: Support runtime faulting of memory
To: sashiko-reviews@lists.linux.dev, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-11-steven.price@arm.com>
 <sashiko-outbox-193750@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <sashiko-outbox-193750@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 02/11/2026 16:26, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 11 potential issue(s) to consider:
> - [Critical] KVM: arm64: kvm_fault_lock() takes read_lock on mmu_lock for Realm VMs
> - [Critical] KVM: arm64: realm_map_non_secure() drops mmu_lock after mmu_invalidate_retry()
> - [High] KVM: arm64: unaligned PFN passed to realm_map_ipa() on THP perm fault
> - [High] KVM: arm64: missing memcache topup on Realm permission faults
> - [High] KVM: arm64: uninitialized out_top and positive error return in realm_map_non_secure()
> - [High] KVM: arm64: upward ALIGN() in realm_fold_rtt_level() prevents RTT folding
> - [High] KVM: arm64: uninitialized next_addr read in realm_unmap_private_range()
> - [High] KVM: arm64: broken pre-fault handling for Realms in gmem_abort() and mmu
> - [Medium] KVM: arm64: missing alignment check and bad page count in addr_range_desc()
> - [Medium] KVM: arm64: kvm_memslot_is_gmem_only() is always true for gmem slots
> - [Low] KVM: arm64: unhandled exec fault on shared IPA in gmem_abort()

Ooof, that's a lot of issues. But there do seem to be real issues to fix
here. I'll attempt to provide fixes in the next posting.

Steve

> --
> 
> commit fc65c5faff3855065d9684753b8a03a5284ae490
> Author: Steven Price <steven.price@arm.com>
> 
> KVM: arm64: CCA: Support runtime faulting of memory
> 
> This commit adds runtime Stage-2 fault handling for CCA Realm guests,
> delegating and mapping protected pages via the RMM for lower-half IPAs,
> mapping non-secure shared pages for upper-half IPAs, and exiting with
> KVM_EXIT_MEMORY_FAULT on guest_memfd attribute mismatches.
> 
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index eb8c5f9e9791d..20aedbe6ec072 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
> 
> [ ... ]
> 
>> @@ -1790,6 +1798,10 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
>>  	void *memcache = NULL;
>>  	gfn_t canonical_gfn;
>>  	int ret;
>> +	bool is_realm_private = false;
>> +
>> +	if (KVM_BUG_ON(!kvm_slot_has_gmem(s2fd->memslot), kvm))
>> +		return -EINVAL;
>>  
>>  	if (!perm_fault) {
>>  		memcache = get_mmu_memcache(s2fd->vcpu);
>> @@ -1804,7 +1816,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
>>  	}
> 
> [Severity: High]
> Should gmem_abort() and user_mem_abort() also top up memcache on permission
> faults when kvm_vm_is_realm(kvm) is true?
> 
> In gmem_abort(), memcache is left NULL when perm_fault is true, and in
> user_mem_abort(), topup_mmu_memcache() is skipped on permission faults
> because both memslot_is_logging() and is_protected_kvm_enabled() are false
> for a Realm VM:
> 
> arch/arm64/kvm/mmu.c:user_mem_abort() {
> 	memcache = get_mmu_memcache(s2fd->vcpu);
> 	if (!perm_fault || memslot_is_logging(s2fd->memslot) ||
> 	    is_protected_kvm_enabled()) {
> 		ret = topup_mmu_memcache(s2fd->mmu, memcache);
> 		if (ret)
> 			return ret;
> 	}
> }
> 
> However, unlike normal VMs that relax permissions in place, both paths call
> realm_map_ipa(..., memcache) -> realm_map_non_secure(..., memcache). When
> relaxing permissions on an existing shared mapping, realm_map_non_secure()
> calls realm_unmap_shared_range(), which unmaps the entry and folds empty RTT
> levels via realm_fold_rtt_level(), and the subsequent iteration calls
> realm_create_rtt_levels(..., memcache) -> alloc_rtt(memcache) ->
> alloc_delegated_granule(memcache).
> 
> In user_mem_abort(), passing an un-topped-up memcache to
> kvm_mmu_memory_cache_alloc() can trigger WARN_ON(!mc->nobjs) (and BUG_ON(!p)
> if the atomic fallback fails), while in gmem_abort() passing a NULL memcache
> forces alloc_delegated_granule() to fall back to GFP_ATOMIC page allocations
> under kvm->mmu_lock.
> 
>>  	s2vi.vma_pagesize = PAGE_SIZE;
>> -	s2vi.gfn = ALIGN_DOWN(s2fd->fault_ipa, s2vi.vma_pagesize) >> PAGE_SHIFT;
>> +	s2vi.gfn = gpa_to_gfn(kvm_gpa_from_fault(kvm, s2fd->fault_ipa));
>>  	canonical_gfn = get_canonical_gfn(s2fd, &s2vi);
>>  
>>  	write_fault = kvm_s2_fault_is_write(s2fd);
>> @@ -1816,13 +1828,28 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
>>  	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
>>  	smp_rmb();
>>  
>> +	if (kvm_vm_is_realm(kvm)) {
>> +		is_realm_private = kvm_realm_is_private_address(&kvm->arch.realm,
>> +								s2fd->fault_ipa);
>> +
>> +		if (is_realm_private != kvm_gmem_is_private_gfn(kvm, canonical_gfn)) {
>> +			kvm_prepare_memory_fault_exit(s2fd->vcpu,
>> +						      gfn_to_gpa(canonical_gfn),
>> +						      PAGE_SIZE,
>> +						      write_fault, exec_fault,
>> +						      is_realm_private);
>> +			kfree(mapping);
>> +			return -EFAULT;
>> +		}
>> +	}
> 
> [Severity: High]
> How is KVM_PRE_FAULT_MEMORY supposed to interact with Realm VMs here and in
> kvm_arch_pre_fault_allowed()?
> 
> In gmem_abort(), the kvm_gmem_get_pfn() error path below guards
> kvm_prepare_memory_fault_exit() with if (!result) so that synthetic faults
> from __pre_fault_s2() do not overwrite vcpu->run, whereas this attribute
> mismatch path calls kvm_prepare_memory_fault_exit() unconditionally.
> 
> More broadly, kvm_arch_pre_fault_allowed() only checks
> is_protected_kvm_enabled():
> 
> arch/arm64/kvm/mmu.c:kvm_arch_pre_fault_allowed() {
> 	if (is_protected_kvm_enabled())
> 		return -EOPNOTSUPP;
> 
> 	return 0;
> }
> 
> Because is_protected_kvm_enabled() is false in KVM_MODE_RMM, userspace can
> invoke KVM_PRE_FAULT_MEMORY on a Realm vCPU:
> 
> 1. In pre_fault_s2(), kvm_walk_s2(mmu->pgt, gpa, &level) walks the stage-2
>    page tables directly from the host CPU, which will trigger a Granule
>    Protection Fault once the root PGD pages have been delegated to the RMM.
> 
> 2. If called before the Realm is created while realm.ia_bits is still 0,
>    kvm_gpa_from_fault() and kvm_realm_is_private_address() evaluate
>    BIT(realm->ia_bits - 1), causing a negative shift.
> 
> 3. __pre_fault_s2() dispatches solely on kvm_slot_has_gmem(memslot),
>    bypassing the private_ipa_fault() and kvm_fault_is_gmem_abort() checks in
>    kvm_vm_mem_abort().
> 
> Should kvm_arch_pre_fault_allowed() reject Realm VMs (or support them via
> RMM-aware walks), and should the attribute mismatch path in gmem_abort()
> also check if (!result)?
> 
>> +
>>  	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, canonical_gfn, &s2vi.pfn, NULL);
>>  	if (ret) {
>>  		/* If result is non-NULL this is a synthetic fault. */
>>  		if (!result)
>>  			kvm_prepare_memory_fault_exit(s2fd->vcpu, gfn_to_gpa(canonical_gfn),
>>  						      s2vi.vma_pagesize, write_fault, exec_fault,
>> -						      false);
>> +						      is_realm_private);
>>  		kfree(mapping);
>>  		return ret;
>>  	}
>> @@ -1845,6 +1872,13 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
>>  		goto out_unlock;
>>  	}
>>  
>> +	if (kvm_vm_is_realm(kvm)) {
>> +		prot &= ~KVM_PGTABLE_PROT_X;
>> +		ret = realm_map_ipa(kvm, s2fd->fault_ipa, s2vi.pfn,
>> +				    PAGE_SIZE, prot, memcache);
>> +		goto out_unlock;
>> +	}
> 
> [Severity: Critical]
> Does kvm_fault_lock() acquire the wrong lock mode on kvm->mmu_lock for Realm
> VMs?
> 
> Both gmem_abort() and kvm_s2_fault_map() call realm_map_ipa() while holding
> kvm_fault_lock(kvm). In arch/arm64/include/asm/kvm_rmi.h, struct realm notes
> that Realm stage-2 map/unmap paths require kvm->mmu_lock to be held for
> write, and assumes kvm_fault_lock() takes the write lock:
> 
> arch/arm64/include/asm/kvm_mmu.h:kvm_fault_lock() {
> 	if (is_protected_kvm_enabled())
> 		write_lock(&kvm->mmu_lock);
> 	else
> 		read_lock(&kvm->mmu_lock);
> }
> 
> However, is_protected_kvm_enabled() only checks ARM64_KVM_PROTECTED_MODE
> (pKVM) and is false in KVM_MODE_RMM, so kvm_fault_lock() only takes
> read_lock(&kvm->mmu_lock) for a Realm VM.
> 
> Inside realm_map_ipa(), realm_map_protected() calls
> realm_unmap_private_range(kvm, base_ipa, ipa, true) on error and
> realm_map_non_secure() calls realm_unmap_shared_range(kvm, ipa, ipa_top,
> true) when level >= req_level. Both unmap helpers execute
> cond_resched_rwlock_write(&kvm->mmu_lock) when may_block is true, performing
> a write_unlock() and write_lock() on a read-locked rwlock before
> kvm_fault_unlock() calls read_unlock(). Holding only the read lock also
> allows concurrent vCPUs to race on RTT creation/folding, page delegation,
> and realm->sro usage.
> 
> Should kvm_fault_lock() and kvm_fault_unlock() take kvm->mmu_lock for write
> when kvm_vm_is_protected(kvm) (or kvm_vm_is_realm(kvm)) is true?
> 
> [Severity: Low]
> This question rests on an ARM CCA / RMM architecture detail that I could not
> confirm from the kernel source: can a Realm guest instruction fetch from an
> unprotected (shared) IPA cause a stage-2 instruction abort exit to the host
> that reaches kvm_handle_guest_abort(), or does the RMM always handle or
> reject unprotected instruction fetches internally?
> 
> If the RMM can exit to the host with a stage-2 instruction abort on a shared
> IPA (where kvm_s2_fault_is_exec(s2fd) is true), unprotected mappings only
> support RMI_S2AP_DIRECT_READ and RMI_S2AP_DIRECT_WRITE in
> realm_map_non_secure(), and gmem_abort() strips KVM_PGTABLE_PROT_X. Neither
> gmem_abort() nor user_mem_abort() returns -ENOEXEC to inject an instruction
> abort into the guest, so realm_map_non_secure() would install a
> non-executable mapping and repeatedly unmap and remap it on subsequent
> instruction permission faults.
> 
> [ ... ]
> 
>> @@ -2241,12 +2276,15 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>>  	if (!perm_fault_granule && !s2vi->map_non_cacheable && kvm_has_mte(kvm))
>>  		sanitise_mte_tags(kvm, pfn, mapping_size);
>>  
>> -	/*
>> -	 * Under the premise of getting a FSC_PERM fault, we just need to relax
>> -	 * permissions only if mapping_size equals perm_fault_granule. Otherwise,
>> -	 * kvm_pgtable_stage2_map() should be called to change block size.
>> -	 */
>> -	if (mapping_size == perm_fault_granule) {
>> +	if (kvm_vm_is_realm(kvm)) {
>> +		ret = realm_map_ipa(kvm, s2fd->fault_ipa, pfn, mapping_size,
>> +				    prot, memcache);
>> +	} else if (mapping_size == perm_fault_granule) {
> 
> [Severity: High]
> Can kvm_s2_fault_map() pass an unaligned 4KB subpage pfn with a 2MB
> mapping_size to realm_map_ipa() on a Transparent Huge Page permission fault?
> 
> When a shared IPA is backed by a non-hugetlbfs VMA using a 2MB THP,
> kvm_s2_fault_get_vma_info() sets s2vi->vma_pagesize = PAGE_SIZE and resolves
> s2vi->pfn to the specific 4KB page for s2fd->fault_ipa. If the 2MB block was
> initially mapped read-only and the guest later writes to a non-zero 4KB page
> offset within that block, perm_fault_granule is PMD_SIZE.
> 
> Earlier in kvm_s2_fault_map():
> 
> arch/arm64/kvm/mmu.c:kvm_s2_fault_map() {
> 	if (mapping_size == PAGE_SIZE && s2vi->max_map_size != PAGE_SIZE) {
> 		if (perm_fault_granule > PAGE_SIZE) {
> 			mapping_size = perm_fault_granule;
> 		} else {
> 			mapping_size = transparent_hugepage_adjust(s2fd, &pfn, &gfn);
> ...
> 		}
> 		canonical_ipa = ALIGN_DOWN(canonical_ipa, mapping_size);
> 	}
> }
> 
> When perm_fault_granule > PAGE_SIZE, mapping_size is set to
> perm_fault_granule without calling transparent_hugepage_adjust() to align
> pfn down to the block boundary (or verify that the host stage-1 mapping is
> still a huge page after FOLL_WRITE). Non-Realm VMs take the
> kvm_pgtable_stage2_relax_perms() branch which does not use pfn, but Realm
> VMs call realm_map_ipa(), which aligns ipa down to map_size while leaving
> pfn at the unaligned 4KB subpage physical address.
> 
> [ ... ]
> 
>> @@ -2339,18 +2377,43 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd,
>>  	return kvm_s2_fault_map(s2fd, &s2vi, prot, memcache, result);
>>  }
>>  
>> +static bool private_ipa_fault(struct kvm *kvm, phys_addr_t fault_ipa);
>> +static bool kvm_fault_is_gmem_abort(struct kvm *kvm,
>> +				    const struct kvm_s2_fault_desc *s2fd);
>> +
>>  static int kvm_vm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>>  {
>>  	VM_WARN_ON_ONCE(kvm_s2_fault_is_perm(s2fd) &&
>>  			!esr_abt_is_write_fault(s2fd->esr) &&
>>  			!kvm_s2_fault_is_exec(s2fd));
>>  
>> -	if (kvm_slot_has_gmem(s2fd->memslot))
>> +	if (private_ipa_fault(s2fd->vcpu->kvm, s2fd->fault_ipa) &&
>> +	    !kvm_slot_has_gmem(s2fd->memslot))
>> +		return -EINVAL;
>> +
>> +	if (kvm_fault_is_gmem_abort(s2fd->vcpu->kvm, s2fd))
>>  		return gmem_abort(s2fd, NULL);
>>  	else
>>  		return user_mem_abort(s2fd, NULL);
>>  }
>>  
>> +/* Decide if an abort should be handled by the gmem */
>> +static bool kvm_fault_is_gmem_abort(struct kvm *kvm,
>> +				    const struct kvm_s2_fault_desc *s2fd)
>> +{
>> +	if (!kvm_slot_has_gmem(s2fd->memslot))
>> +		return false;
>> +	if (kvm_memslot_is_gmem_only(s2fd->memslot))
>> +		return true;
>> +	/*
>> +	 * For Realms, all private faults must be backed by GMEM.
>> +	 * TODO: Handle Trusted device private memory mappings.
>> +	 */
>> +	if (private_ipa_fault(kvm, s2fd->fault_ipa))
>> +		return true;
>> +	return false;
>> +}
> 
> [Severity: Medium]
> Isn't kvm_memslot_is_gmem_only() unconditionally true for every guest_memfd
> memslot on arm64 once kvm_arch_has_private_mem() is defined?
> 
> In include/linux/kvm_host.h, defining kvm_arch_has_private_mem without
> CONFIG_KVM_PRIVATE_MEMATTR_VM sets gmem_in_place_conversion to true, which
> causes kvm_gmem_prepare_memory_region() to set KVM_MEMSLOT_GMEM_ONLY on
> every guest_memfd memslot regardless of whether GUEST_MEMFD_FLAG_MMAP was
> requested:
> 
> virt/kvm/guest_memfd.c:kvm_gmem_prepare_memory_region() {
> 	if (gmem_in_place_conversion || kvm_gmem_supports_mmap(inode))
> 		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
> }
> 
> Because kvm_memslot_is_gmem_only() is always true whenever
> kvm_slot_has_gmem() is true:
> 
> 1. In kvm_fault_is_gmem_abort(), the private_ipa_fault() check and final
>    return false become unreachable, and shared IPA faults on non-MMAP
>    guest_memfd memslots are routed to gmem_abort() instead of
>    user_mem_abort().
> 
> 2. In kvm_arch_prepare_memory_region() below, the check
>    if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new) &&
>    !kvm_vm_is_realm(kvm)) never triggers, so non-Realm VMs are no longer
>    prevented from binding guest_memfd instances created without
>    GUEST_MEMFD_FLAG_MMAP.
> 
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index 1066f767f85d9..f89460d8adcba 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -531,15 +531,231 @@ void kvm_realm_unmap_range_filter(struct kvm *kvm, unsigned long start,
>>  }
>>  
>>  void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start,
>> -			   unsigned long size, bool unmap_private,
>> -			   bool may_block)
>> +			   unsigned long size, bool may_block)
>>  {
>> -	enum kvm_gfn_range_filter attr_filter = KVM_FILTER_SHARED;
>> +	kvm_realm_unmap_range_filter(kvm, start, size, may_block,
>> +				     KVM_FILTER_SHARED | KVM_FILTER_PRIVATE);
>> +}
>> +
>> +static unsigned long addr_range_desc(unsigned long phys, unsigned long size,
>> +				     unsigned long state)
>> +{
>> +	unsigned long count = 1;
>> +	unsigned long out;
>> +	int rmi_size;
>> +
>> +	for (rmi_size = KVM_PGTABLE_LAST_LEVEL; rmi_size >= 0; rmi_size--) {
>> +		unsigned long entry_size = rmi_range_entry_size(rmi_size);
>> +
>> +		if (size == entry_size)
>> +			break;
>> +		if (size > entry_size) {
>> +			rmi_size = -1;
>> +			break;
>> +		}
>> +	}
>> +
>> +	if (rmi_size < 0) {
>> +		/*
>> +		 * Only support mapping at the page level granularity when
>> +		 * it's an unusual length. This should get us back onto a larger
>> +		 * block size for the subsequent mappings.
>> +		 */
>> +		rmi_size = 0;
>> +		count = MIN(size >> PAGE_SHIFT, PTRS_PER_PTE - 1);
>> +	}
> 
> [Severity: Medium]
> Should addr_range_desc() also verify that phys is aligned to entry_size
> before selecting a block rmi_size?
> 
> When rmi_size < 0 (for example, after a partial delegation in
> realm_map_protected()), mapping PTRS_PER_PTE - 1 (511) pages from a
> block-aligned address advances ipa and phys to one page short of the next
> 2MB block boundary. If the remaining size (ipa_top - ipa) on a subsequent
> iteration happens to equal a block entry_size, the loop will select that
> block rmi_size even though ipa and phys are only page-aligned, causing the
> RMM map call to fail with RMI_ERROR_INPUT.
> 
> [ ... ]
> 
>> +err_undelegate:
>> +	realm_unmap_private_range(kvm, base_ipa, ipa, true);
>> +	/* A range which cannot be undelegated remains owned by the RMM. */
>> +	WARN_ON(rmi_undelegate_range(base_phys, map_size));
>> +	return ret < 0 ? ret : -ENXIO;
>> +}
> 
> [Severity: High]
> When realm_map_protected() (or kvm_realm_unmap_range()) calls
> realm_unmap_private_range(), can realm_unmap_private_range() read an
> uninitialized or stale next_addr when rmi_rtt_data_unmap() returns
> RMI_ERROR_RTT?
> 
> In realm_unmap_private_range():
> 
> arch/arm64/kvm/rmi.c:realm_unmap_private_range() {
> 	unsigned long next_addr, addr;
> 	long ret;
> 
> 	for (addr = start; addr < end; addr = next_addr) {
> ...
> retry:
> 		ret = rmi_rtt_data_unmap(rd, addr, end, flags, 0,
> 					 &next_addr, &out_range, NULL);
> 		if (WARN_ON(ret < 0))
> 			return;
> 
> 		if (RMI_RESULT_STATUS(ret) == RMI_ERROR_RTT) {
> 			phys_addr_t rtt;
> 
> 			if (next_addr > addr)
> 				continue; /* UNASSIGNED */
> }
> 
> In include/linux/arm-rmi-cmds.h, rmi_rtt_data_unmap() returns early when
> ret != RMI_SUCCESS without writing *out_top (&next_addr). On the first loop
> iteration, next_addr is uninitialized on the stack; on later iterations
> after a successful unmap, next_addr equals addr, so next_addr > addr is
> false even for an unassigned entry at the leaf level, causing
> realm_unmap_private_range() to attempt to create a level-4 RTT and trigger
> WARN_ON(ret).
> 
> [ ... ]
> 
>> +	while (ipa < ipa_top) {
>> +		unsigned long range_desc = addr_range_desc(phys, ipa_top - ipa,
>> +							   RMI_OP_MEM_UNDELEGATED);
>> +		unsigned long out_top;
>> +
>> +		ret = rmi_rtt_unprot_map(rd, ipa, ipa_top, flags, range_desc,
>> +					 &out_top);
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +		if (RMI_RESULT_STATUS(ret) == RMI_ERROR_RTT) {
>> +			/* Create missing RTTs and retry */
>> +			int level = RMI_RESULT_DATA_LEVEL(ret);
>> +			int req_level = find_map_level(realm, ipa, ipa_top);
>> +
>> +			/*
>> +			 * There already exists a mapping at the level. May be
>> +			 * we are relaxing a permission for the given range ?
>> +			 */
>> +			if (level >= req_level) {
>> +				realm_unmap_shared_range(kvm, ipa, ipa_top, true);
>> +				continue;
>> +			}
> 
> [Severity: Critical]
> Is it safe to pass may_block = true to realm_unmap_shared_range() here while
> mapping a PFN resolved before kvm_fault_lock()?
> 
> In gmem_abort() and kvm_s2_fault_map(), mmu_invalidate_retry() is checked
> once after acquiring kvm_fault_lock(kvm). Passing may_block = true to
> realm_unmap_shared_range() calls cond_resched_rwlock_write(&kvm->mmu_lock),
> which can drop and re-acquire kvm->mmu_lock. If a concurrent MMU notifier or
> guest_memfd invalidation runs while the lock is dropped and frees or
> converts the backing page, continuing the loop will map the stale phys into
> the Realm without re-checking mmu_invalidate_retry().
> 
> [Severity: High]
> Can this level >= req_level path also get stuck in an infinite loop when
> replacing 4KB page mappings with a 2MB block mapping at an IPA that is not
> aligned to the top-level RTT map_size?
> 
> realm_unmap_shared_range() calls realm_fold_rtt_level(), which computes
> align_addr using ALIGN() instead of ALIGN_DOWN():
> 
> arch/arm64/kvm/rmi.c:realm_fold_rtt_level() {
> 	for (addr = start; addr < end; addr = next_addr) {
> 		phys_addr_t rtt_granule;
> 		long ret;
> 		unsigned long align_addr = ALIGN(addr, map_size);
> 
> 		next_addr = ALIGN(addr + 1, map_size);
> 
> 		ret = realm_rtt_fold(realm, align_addr, level, &rtt_granule);
> }
> 
> When start is not aligned to map_size at the starting level (for example, a
> 2MB range at a non-1GB-aligned IPA), ALIGN(addr, map_size) rounds align_addr
> up to the next table boundary (or to BIT(realm->ia_bits) if addr is in the
> last top-level entry, triggering WARN_ON(1) on RMI_ERROR_INPUT). As a
> result, realm_fold_rtt_level() does not fold the emptied child RTT covering
> ipa, and the next iteration of realm_map_non_secure() sees RMI_ERROR_RTT
> with level >= req_level again and loops indefinitely.
> 
>> +
>> +			ret = realm_create_rtt_levels(realm, ipa, level,
>> +						      req_level,
>> +						      memcache);
>> +			if (ret)
>> +				return ret;
>> +
>> +			ret = rmi_rtt_unprot_map(rd, ipa, ipa_top, flags,
>> +						 range_desc, &out_top);
>> +			if (ret < 0)
>> +				return ret;
>> +		}
>> +
>> +		if (ret && RMI_RESULT_STATUS(ret) != RMI_ERROR_RTT)
>> +			return ret;
>> +
>> +		phys += out_top - ipa;
>> +		ipa = out_top;
>> +	}
> 
> [Severity: High]
> What happens in realm_map_non_secure() if the second rmi_rtt_unprot_map()
> call returns RMI_ERROR_RTT, or if rmi_rtt_unprot_map() returns a positive
> RMI error code?
> 
> 1. out_top is declared uninitialized at the top of the loop, and
>    rmi_rtt_unprot_map() only writes *out_top when ret == RMI_SUCCESS. If the
>    second rmi_rtt_unprot_map() call after realm_create_rtt_levels() also
>    returns RMI_ERROR_RTT (for example, if addr_range_desc() fell back to
>    page granularity while req_level < KVM_PGTABLE_LAST_LEVEL, or if a deeper
>    RTT exists in part of the range), the check
>    if (ret && RMI_RESULT_STATUS(ret) != RMI_ERROR_RTT) is false and
>    execution falls through to phys += out_top - ipa; ipa = out_top; using an
>    uninitialized out_top. Why not use continue after
>    realm_create_rtt_levels() like realm_map_protected() does?
> 
> 2. When rmi_rtt_unprot_map() returns a non-zero positive RMI status code
>    (such as RMI_ERROR_INPUT), returning ret directly propagates a positive
>    integer back through realm_map_ipa() -> kvm_s2_fault_map() / gmem_abort()
>    -> kvm_vm_mem_abort() -> kvm_handle_guest_abort(), where a positive
>    return value is treated as a successfully handled fault and re-enters the
>    guest. Should this return -ENXIO on positive RMI errors like
>    realm_map_protected() does?
> 

