Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795105826;
	b=Sykiom4AAC2XHvrfx13/w53rQz52EENbRj1FBBj5Mh3Unorb6BSt2dZA70nqlVPDv1Tl
	 t6gFITwxGrrqDmolPFMujGGav/vpBkEWCpTJNuB1on1EJ2O9lDb2Lo8z5NaONeRxCL7ao
	 Bw8z7eETY8yynkIfe0LJti+KMTY1U5MQFW7S6LbM9a2mWz0lwVUQatUsmVFi8h4NDKcRR
	 IqPUPqSiBAop6eZzA3YsMHIMoMkDvO7c24AtGoZRs9FEOOGDNz8qf25v5wn4VCcZnUp/O
	 OjuF4vo5tp4okLmolfwPechRgNTWdx95nTJCYPyJD1VcXQUqg7C7pMnBQiUmjq43HwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795105826;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=B7S41Zukdg+I/ZQxYfdUjeKVx5b0WM1uS5IcxJRO3Jc=;
	b=KP4++Dmkvth+NsKBX1TzYiI2ur8P3+sjJqPAkT3y3E8M8YEub9NJr72ZrOfc6zXSKyGj
	 0qCA/+1DvtnXn1eNeXi2RGM9iuSozOZ4tnNmTV0W5+qPX+IT1bn2iSOy8+w75P/s6JDjN
	 YKjFLTG5GjwgajtEFYMHxizFknAzuQ6tf85qWHzanQKKkfOyHZ/Mu5ysnrVvDPjnjrVza
	 IaQA4EuW2W6YhLXUFR0EWOgcSi/TP2+hbMo2xh3sobXbEK9fZlBcjG7CcHk9TY5j92Krj
	 teaUy7JP1jIJ6u9UnEmptQZJtl2i2oWnF2KGrHMAWlRuk/jRi/BSAb7BOqRvo8OiYRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="BfxBm/fV";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FE67606A32A;
	Thu, 19 Nov 2026 16:30:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2FE67606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=BfxBm/fV
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 297411575;
	Thu, 19 Nov 2026 08:30:21 -0800 (PST)
Received: from [10.0.129.37] (e122027.cambridge.arm.com [10.0.129.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C63E3F673;
	Thu, 19 Nov 2026 08:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795105824; bh=TfeeoY3dbjuoXmWt8STXVUxkB4zqZ4VB5GwHRYqCWgo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BfxBm/fVGNFz9TQPGkkzc/eHqs6DUHUOOipdcMQe09W7FtjjWo8/X81fI2NcVOkmO
	 isXEDZBejSROWABKqcfkZvdE0PcqAvbehF/ZYKfFwJeWoBQRG2qjZm167goR0Ex6LO
	 VDGTbPiWQGZx6Pz1LH64JFNH0rYtFHAcJ2ox2HrA=
Message-ID: <2cfeaf5c-e329-4f57-ad9f-1e729f02f5c2@arm.com>
Date: Thu, 19 Nov 2026 16:30:20 +0000
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
Subject: Re: [PATCH v3 09/11] KVM: arm64: CCA: Support runtime faulting of
 memory
To: sashiko-reviews@lists.linux.dev, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261116164358.142785-1-steven.price@arm.com>
 <20261116164358.142785-10-steven.price@arm.com>
 <sashiko-outbox-217436@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <sashiko-outbox-217436@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 16/11/2026 17:31, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential
> issues to consider:
> - [Medium] KVM: arm64: KVM_CAP_PRE_FAULT_MEMORY advertised for Realm VMs
> - [Medium] KVM: arm64: missing unmap on partial failure in
>   realm_map_unprotected()
> - [Low] KVM: arm64: unhandled exec fault on shared Realm IPA in
>   gmem_abort() and user_mem_abort()
> --
> 
> commit 5a0919ef6adc946a1afb4f6ad7cf84e5573597f3
> Author: Steven Price <steven.price@arm.com>
> 
> KVM: arm64: CCA: Support runtime faulting of memory
> 
> This commit adds runtime stage-2 fault handling for Realm VMs, delegating
> and mapping private guest_memfd pages in the protected IPA region and
> mapping shared pages in the unprotected IPA region via the RMM.
> 
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 0db3c293fdd52..9b371159be92c 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
> [ ... ]
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
>> +
> [ ... ]
>> @@ -2242,12 +2289,15 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
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
> 
> [Severity: Low]
> This question rests on an architecture detail that could not be confirmed
> from the kernel source: can a Realm guest instruction fetch from an
> unprotected (shared) IPA exit to the host as a stage-2 instruction abort
> that reaches kvm_handle_guest_abort()?
> 
> If so, unprotected RTT mappings only encode RMI_S2AP_DIRECT_READ and
> RMI_S2AP_DIRECT_WRITE and cannot grant execute permission, but neither
> gmem_abort() nor user_mem_abort() rejects kvm_s2_fault_is_exec(s2fd) with
> -ENOEXEC to inject an instruction abort.  Instead, realm_map_unprotected()
> installs a non-executable mapping, and on subsequent instruction permission
> faults at the same IPA where level >= req_level, unmaps and remaps the page
> with the same non-executable permissions and returns 0 in an endless fault
> loop.

Suzuki already covered this. I'll add a comment in the code.

> [ ... ]
> 
>> @@ -3155,7 +3217,7 @@ pre_fault_bytes_consumed(gpa_t gpa, unsigned long granule_size,
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
> Should kvm_vm_ioctl_check_extension() also report 0 for
> KVM_CAP_PRE_FAULT_MEMORY when kvm && kvm_vm_is_realm(kvm)?
> 
> Currently kvm_vm_ioctl_check_extension() only gates capabilities on
> is_protected_kvm_enabled() and otherwise unconditionally sets r = 1 for
> KVM_CAP_PRE_FAULT_MEMORY, advertising the capability on a Realm VM file
> descriptor even though KVM_PRE_FAULT_MEMORY always fails here with
> -EOPNOTSUPP.

As Suzuki says, this is handled in later patches in the integration
branch. I don't think we want to complicate matters by trying to pull it
into this series.

>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index 838f95c201ada..4cacb9fe000f4 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
> [ ... ]
>> +static int realm_map_unprotected(struct kvm *kvm,
>> +				 unsigned long ipa,
>> +				 kvm_pfn_t pfn,
>> +				 unsigned long size,
>> +				 enum kvm_pgtable_prot prot,
>> +				 struct kvm_mmu_memory_cache *memcache)
>> +{
> [ ... ]
>> +	while (ipa < ipa_top) {
>> +		unsigned long range_desc = addr_range_desc(realm, ipa, phys,
>> +							   ipa_top - ipa,
>> +							   RMI_OP_MEM_UNDELEGATED);
>> +		unsigned long call_top = ipa + RMI_ADDR_RANGE_COUNT(range_desc) *
>> +			rmi_addr_block_size_to_bytes(RMI_ADDR_RANGE_BLOCK_SIZE(range_desc));
>> +		unsigned long out_top;
>> +
>> +		ret = rmi_rtt_unprot_map(rd, ipa, call_top, flags, range_desc,
>> +					 &out_top);
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +		if (ret) {
>> +			/* Create missing RTTs and retry */
>> +			int level = RMI_RESULT_DATA_LEVEL(ret);
>> +			int req_level = KVM_PGTABLE_LAST_LEVEL -
>> +				RMI_ADDR_RANGE_BLOCK_SIZE(range_desc);
>> +
>> +			if (RMI_RESULT_STATUS(ret) != RMI_ERROR_RTT ||
>> +			    ++retries > KVM_PGTABLE_LAST_LEVEL + 2)
>> +				return -ENXIO;
>> +
>> +			/* Replace an existing mapping to update its permissions. */
>> +			if (level >= req_level) {
>> +				realm_unmap_shared_range(kvm, ipa, ipa_top, false,
>> +							 memcache);
>> +				continue;
>> +			}
>> +
>> +			ret = realm_create_rtt_levels(realm, ipa, level,
>> +						      req_level,
>> +						      memcache);
>> +			if (ret)
>> +				return ret;
>> +
>> +			continue;
>> +		}
>> +
>> +		/* Retry the fault after releasing mmu_lock to service the IRQ. */
>> +		if (out_top == ipa)
>> +			return -EAGAIN;
>> +		if (WARN_ON_ONCE(out_top < ipa || out_top > call_top))
>> +			return -ENXIO;
>> +
>> +		phys += out_top - ipa;
>> +		ipa = out_top;
>> +		retries = 0;
>> +	}
> 
> [Severity: Medium]
> Can a multi-iteration call to realm_map_unprotected() leave a writable
> prefix mapped when a later iteration fails or returns -EAGAIN?
> 
> For a Realm with a 32- to 34-bit IPA space on 4KB pages, get_start_level()
> is 2, so addr_range_desc() caps rmi_size at 1 (PMD_SIZE).  When a shared
> memslot is backed by a 1GB hugetlbfs VMA, kvm_s2_fault_map() passes
> mapping_size = PUD_SIZE and this loop runs across multiple 2MB iterations.
> If an iteration after the first is interrupted (out_top == ipa) or hits an
> error, realm_map_unprotected() returns non-zero without unmapping the
> already-installed prefix (unlike realm_map_protected()).  kvm_s2_fault_map()
> then passes !!ret (unused = true) to kvm_release_faultin_page() and skips
> mark_page_dirty_in_slot(), so if the faulting IPA lies in the mapped prefix,
> the guest can write to the page without marking the host folio dirty.
> 

Valid point, I'll unmap if things fail.

Thanks,
Steve
