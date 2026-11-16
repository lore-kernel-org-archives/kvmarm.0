Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794832294;
	b=zJ7ZD2JpIkGqRkE5MFVz1WCEFaQmxWgH8bunZdxKKOd+/sDwR5RZFoP5yWZNSO7xe+bj
	 OOwqE9rk6KkYSchv6n4hhTmmIaqKhlWhsta8F+BvcWSKlZneHmvRKLNEmvsKdrNe5s3EB
	 Je9MUAJMFxMJPYzLUDXuaULFa6CErCqT2RO0Euevwdh5+oUM/yq+5NswXZx9Gu2htpWzt
	 0yX8RuPtt+V9e4WpXYQLP3hBA6VRaZLtxhX//8HjdNZUxA8FrnBsU/x6B4oDPS5c8Krf0
	 Gjw/ensaaG1XFeOD5i6WTKNeFCmPld9gQXiQkI64sQ65K6ZJEPau7+yWmaDBOXRtdFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794832294;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=UXWEq6GylonDqejwpJ3gmpS0qCBY2G7N/kYI6AoO3k8=;
	b=UbeRyES6W8vXUkQLTgRn/xwj3GNHKXmR68FcCXGNccKxyvg4GYKmykzI2HNE3CaTQM61
	 xt1toWREXvIzr1GWYcBlQPHdtVJLf3FbdzL9nNVMoGJ4WvKP45BCfeqQRA7XHK1B3w8z3
	 8NZkhsA7tdcoXjSA4TxqsGU6la0ey0VlDov5bhhlsX35h3ZZYUmtT7lT2TCEGLjtShDh4
	 NRW6lDKsw5Fe/TBAHfVUsRgYEvaZrmcfsnr8i3ZOaysiNBZbD4WpjlZNshYGXqENm1nVY
	 jHMFXkgq5YpXB4in/YcoVR6Z8XhOc3kytSht4FDBHjRTKqmgkOh5Wzewj0jm53qtl5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="R8rKd/7d";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6711A606A329;
	Mon, 16 Nov 2026 12:31:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6711A606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=R8rKd/7d
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 720271713;
	Mon, 16 Nov 2026 04:31:29 -0800 (PST)
Received: from [10.57.63.54] (unknown [10.57.63.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 40ECB3F632;
	Mon, 16 Nov 2026 04:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794832292; bh=s7rrkrPJqSn/VjCcV69VrZwhRBwoHg2LiBmbvlJS4QU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=R8rKd/7dshc6bJehTX2gQKEe2ooXJn49EI7bnRMenRMJj9Ex8tsbMyrQrjIPKWeHU
	 jHlR4ImkKT+gb84NFUwB+6wvlHV8Q6TJDWSrPpmNbD0byPt94PGSn2iBZBzy2W7k6j
	 K9BaMsEbWRW2P8Cl9a3RVLN/dji+D5lZUVdYUbCI=
Message-ID: <2b5abe0e-547b-44ac-a0c2-18c7206f3eda@arm.com>
Date: Mon, 16 Nov 2026 12:31:29 +0000
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
Subject: Re: [PATCH v2 11/12] KVM: arm64: CCA: Support runtime faulting of
 memory
To: sashiko-reviews@lists.linux.dev, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261111145758.217946-1-steven.price@arm.com>
 <20261111145758.217946-12-steven.price@arm.com>
 <sashiko-outbox-209568@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <sashiko-outbox-209568@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/11/2026 19:34, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 6 potential
> issues to consider:
> - [Medium] KVM: arm64: KVM_CAP_PRE_FAULT_MEMORY advertised for Realm VMs
> - [Medium] KVM: arm64: cca: user-triggerable WARN_ON and retry bug in
>   realm_map_protected()
> - [Medium] KVM: arm64: cca: bound block level in addr_range_desc() by
>   start level
> - [Low] KVM: arm64: unhandled exec fault on shared Realm IPA in
>   gmem_abort() and user_mem_abort()
> - [Low] KVM: arm64: dead code and missing memory fault exit in
>   kvm_vm_mem_abort()
> - [Low] KVM: arm64: unreachable dead code in kvm_fault_is_gmem_abort()
> --
> 
> commit 7a04ef54472b7db03df4200b280f4db2cc49ed58
> Author: Steven Price <steven.price@arm.com>
> 
> KVM: arm64: CCA: Support runtime faulting of memory
> 
> This commit adds stage-2 runtime fault handling for Realm VMs, mapping
> private guest_memfd pages into the protected IPA range via the RMM and
> mapping shared guest_memfd or normal memslot pages into the unprotected
> IPA range.
> 
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index e550360fc94d0..b6c61d7890c89 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
> 
> [ ... ]
> 
>> @@ -1846,6 +1882,16 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
>>  		goto out_unlock;
>>  	}
>>  
>> +	switch (kvm->arch.vm_flavor) {
>> +	case VM_REALM:
>> +		prot &= ~KVM_PGTABLE_PROT_X;
>> +		ret = realm_map_ipa(kvm, s2fd->fault_ipa, s2vi.pfn,
>> +				    PAGE_SIZE, prot, memcache);
>> +		goto out_unlock;
>> +	default:
>> +		break;
>> +	}
> 
> [Severity: Low]
> This question rests on an architecture detail that this review could not
> confirm from the kernel source: can a Realm guest instruction fetch from an
> unprotected (shared) IPA cause the RMM to exit to the host with a stage-2
> instruction abort (ESR_ELx_EC_IABT_LOW) that reaches
> kvm_handle_guest_abort()?
> 
> If the answer is yes, unprotected Realm mappings cannot grant execute
> permission because RMI_RTT_UNPROT_MAP only encodes RMI_S2AP_DIRECT_READ and
> RMI_S2AP_DIRECT_WRITE, yet neither gmem_abort() nor user_mem_abort() checks
> kvm_s2_fault_is_exec(s2fd) on a shared IPA to return -ENOEXEC (so
> kvm_handle_guest_abort() can inject an instruction abort via
> kvm_inject_sea_iabt()).  Instead, realm_map_unprotected() installs a
> non-executable mapping and returns 0, and on subsequent instruction
> permission faults at that IPA, unmaps and remaps the page with the same
> non-executable permissions in an endless fault loop.

Realm guests should never execute from unprotected mappings (that would
largely defeat the point of confidential compute). The spec covers this
case:

RXLSKP: Realm instruction fetch from an Unprotected IPA causes a
Synchronous External Abort taken to the Realm.

So the fault isn't taken to the host.

> [ ... ]
> 
>> @@ -2340,13 +2391,40 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd,
>>  	return kvm_s2_fault_map(s2fd, &s2vi, prot, memcache, result);
>>  }
>>  
>> +static bool private_ipa_fault(struct kvm *kvm, phys_addr_t fault_ipa)
>> +{
>> +	return kvm_vm_is_realm(kvm) &&
>> +		kvm_realm_is_private_address(&kvm->arch.realm, fault_ipa);
>> +}
>> +
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
> [Severity: Low]
> Is the private_ipa_fault() check in kvm_fault_is_gmem_abort() reachable?
> 
> On arm64, include/linux/kvm_host.h defines gmem_in_place_conversion as true
> because kvm_arch_has_private_mem is defined without
> CONFIG_KVM_PRIVATE_MEMATTR_VM, so kvm_gmem_prepare_memory_region() sets
> KVM_MEMSLOT_GMEM_ONLY on every guest_memfd-backed memslot:
> 
> virt/kvm/guest_memfd.c:kvm_gmem_prepare_memory_region() {
>     ...
> 	if (gmem_in_place_conversion || kvm_gmem_supports_mmap(inode))
> 		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
>     ...
> }
> 
> Once kvm_slot_has_gmem(s2fd->memslot) is true,
> kvm_memslot_is_gmem_only(s2fd->memslot) always returns true, making the rest
> of kvm_fault_is_gmem_abort() unreachable and the helper equivalent to
> kvm_slot_has_gmem(s2fd->memslot).

Indeed it isn't reachable. All memslots are now gmem only. Which means
this function is now simply kvm_slot_has_gmem() so I'll drop it.

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
> 
> [Severity: Low]
> When a Realm guest faults on the private IPA alias of a non-guest_memfd
> memslot, should kvm_vm_mem_abort() call kvm_prepare_memory_fault_exit() and
> return -EFAULT instead of returning -EINVAL?

I don't think we can actually reach this path without protected device
support (which will come later). Exposing this to the VM as a memory
fault doesn't seem appropriate when we don't have the kernel support for
handling protected devices.

> Returning -EINVAL leaves vcpu->run->exit_reason unpopulated and causes
> KVM_RUN to fail with EINVAL rather than reporting KVM_EXIT_MEMORY_FAULT
> (with KVM_MEMORY_EXIT_FLAG_PRIVATE) to userspace, and as noted above,
> kvm_fault_is_gmem_abort() is also redundant with kvm_slot_has_gmem() on
> arm64.
> 
> [ ... ]
> 
>> @@ -3156,7 +3235,7 @@ pre_fault_bytes_consumed(gpa_t gpa, unsigned long granule_size,
>>  
>>  int kvm_arch_pre_fault_allowed(struct kvm_vcpu *vcpu)
>>  {
>> -	if (is_protected_kvm_enabled())
>> +	if (is_protected_kvm_enabled() || kvm_vm_is_realm(vcpu->kvm))
>>  		return -EOPNOTSUPP;
>>  	if (!kvm_vcpu_initialized(vcpu))
>>  		return -ENOEXEC;
> 
> [Severity: Medium]
> Should kvm_vm_ioctl_check_extension() also gate KVM_CAP_PRE_FAULT_MEMORY on
> !kvm_vm_is_realm(kvm)?
> 
> kvm_arch_pre_fault_allowed() rejects KVM_PRE_FAULT_MEMORY on Realm VMs with
> -EOPNOTSUPP, but kvm_vm_ioctl_check_extension() in arch/arm64/kvm/arm.c
> still advertises KVM_CAP_PRE_FAULT_MEMORY as supported when queried on a
> Realm VM file descriptor.

False positive. kvm_realm_ext_allowed() already prevents
kvm_vm_ioctl_check_extension() returning 1 for a realm VM.

>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index 5aa34d68de595..682ed7005d579 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -551,6 +551,241 @@ void kvm_realm_unmap_range_filter(struct kvm *kvm, unsigned long start,
>>  		realm_unmap_private_range(kvm, start, end, may_block);
>>  }
>>  
>> +static unsigned long addr_range_desc(unsigned long ipa, unsigned long phys,
>> +				     unsigned long size, unsigned long state)
>> +{
>> +	unsigned long count = 1;
>> +	unsigned long out;
>> +	int rmi_size;
>> +
>> +	for (rmi_size = KVM_PGTABLE_LAST_LEVEL; rmi_size >= 0; rmi_size--) {
>> +		unsigned long entry_size = rmi_addr_block_size_to_bytes(rmi_size);
>> +
>> +		if (size >= entry_size && IS_ALIGNED(ipa, entry_size) &&
>> +		    IS_ALIGNED(phys, entry_size))
>> +			break;
>> +	}
> 
> [Severity: Medium]
> Can addr_range_desc() select a block level above the Realm's RTT start level?
> 
> When a Realm VM is created with a 32..34-bit IPA range on 4KB pages,
> get_start_level(realm) is 2 (concatenated level-2 root RTTs).  If the guest
> faults on a 1GB-aligned shared memslot backed by a 1GB hugetlbfs VMA,
> kvm_s2_resolve_vma_size() sets vma_pagesize to PUD_SIZE (1GB) and
> addr_range_desc() picks rmi_size = 2 (RTT level 1).  In
> realm_map_unprotected(), req_level is then 1, which is above the root RTT
> level 2, causing rmi_rtt_unprot_map() to fail until retries are exhausted
> and terminating the fault with -ENXIO.

Valid point - I'll change the for loop to:

	for (rmi_size = KVM_PGTABLE_LAST_LEVEL - get_start_level(realm);
	     rmi_size >= 0; rmi_size--) {

>> +
>> +	if (rmi_size == 0) {
>> +		/*
>> +		 * Stop at the next block boundary so that a later iteration can
>> +		 * use a larger mapping when both addresses are aligned.
>> +		 */
>> +		count = MIN(size >> PAGE_SHIFT, PTRS_PER_PTE - 1);
>> +		count = min(count, (PMD_SIZE - (ipa & (PMD_SIZE - 1))) >> PAGE_SHIFT);
>> +		count = min(count, (PMD_SIZE - (phys & (PMD_SIZE - 1))) >> PAGE_SHIFT);
>> +	}
>> +
>> +	WARN_ON(phys & ~PAGE_MASK);
>> +
>> +	out = FIELD_PREP(RMI_ADDR_RANGE_BLOCK_SIZE_MASK, rmi_size) |
>> +	      FIELD_PREP(RMI_ADDR_RANGE_COUNT_MASK, count) |
>> +	      FIELD_PREP(RMI_ADDR_RANGE_STATE_MASK, state);
>> +	out |= phys & PAGE_MASK;
>> +
>> +	return out;
>> +}
>> +
>> +static int realm_map_protected(struct kvm *kvm,
>> +			       unsigned long ipa,
>> +			       kvm_pfn_t pfn,
>> +			       unsigned long map_size,
>> +			       struct kvm_mmu_memory_cache *memcache)
>> +{
> 
> [ ... ]
> 
>> +	while (ipa < ipa_top) {
>> +		unsigned long flags = RMI_ADDR_TYPE_SINGLE;
>> +		unsigned long range_desc = addr_range_desc(ipa, phys, ipa_top - ipa,
>> +							   RMI_OP_MEM_DELEGATED);
>> +		unsigned long out_top;
>> +
>> +		ret = rmi_rtt_data_map(rd, ipa, ipa_top, flags, range_desc,
>> +				       &out_top);
>> +		if (ret < 0)
>> +			goto err_undelegate;
>> +
>> +		if (RMI_RESULT_STATUS(ret) == RMI_ERROR_RTT) {
>> +			/* Create missing RTTs and retry */
>> +			int level = RMI_RESULT_DATA_LEVEL(ret);
>> +
>> +			if (WARN_ON(level >= KVM_PGTABLE_LAST_LEVEL))
>> +				goto err_undelegate;
>> +			ret = realm_create_rtt_levels(realm, ipa, level,
>> +						      level + 1,
>> +						      memcache);
>> +			if (ret)
>> +				goto err_undelegate;
>> +
>> +			continue;
>> +		}
>> +
>> +		if (WARN_ON(ret))
>> +			goto err_undelegate;
> 
> [Severity: Medium]
> Can userspace or a Realm guest trigger WARN_ON(level >=
> KVM_PGTABLE_LAST_LEVEL) and WARN_ON(ret) in realm_map_protected()?
> 
> If userspace punches a hole in guest_memfd on an already-mapped protected
> page, realm_unmap_private_range() unmaps the page via rmi_rtt_data_unmap()
> (leaving the level-3 RTT entry in the DESTROYED state) and undelegates the
> folio while the guest_memfd range remains private.  When a vCPU faults on
> that GPA again, gmem_abort() allocates a fresh undelegated folio and
> realm_map_protected() delegates it, but rmi_rtt_data_map() fails with
> RMI_ERROR_RTT at level 3 (or if the guest has not initialized RIPAS to RAM),
> hitting WARN_ON(level >= KVM_PGTABLE_LAST_LEVEL).  Similarly, any non-RTT
> status such as RMI_BLOCKED hits WARN_ON(ret).

If the guest hasn't reinitialized to RIPAS_RAM then the RMM wouldn't
allow this. A realm guest hitting DESTROYED is fatal for the guest.

> In addition, unlike realm_map_unprotected(), realm_map_protected() passes
> ipa_top instead of call_top to rmi_rtt_data_map(), checks
> KVM_PGTABLE_LAST_LEVEL and passes level + 1 instead of req_level to
> realm_create_rtt_levels(), and does not bound retries.  If map_size >
> PAGE_SIZE is used, addr_range_desc() can describe a sub-range smaller than
> ipa_top - ipa (failing with RMI_ERROR_INPUT) or a block mapping where a
> child RTT at level + 1 already exists, causing realm_create_rtt_levels() to
> return 0 on RMI_ERROR_RTT and spin forever under write_lock(&kvm->mmu_lock).

That might well be valid though. I'll do the call_top dance here too.

Steve

