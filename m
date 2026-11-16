Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794856145;
	b=hL2RnacrPIxpjO7w/bqs7AqfoIfBJLidbjQR/sBnREPaxJ5KAa8J8WKG+Wb4j4CpmCn3
	 0ipmcdK2lZA2jor+xL4gmYq2f0644jxA36hJozKcEYFYQz2bQbNoV0hywUDOSWTIPXvcQ
	 BUixXpfVw4+HnEY+pLaf8GXhY+brwZ7qDr2m/fQECqIHD3Bc4We1zG85yV3HhRQwuh2H8
	 KYKPtQ8KiHGOcyESeCJl+ONgeJ9kFptXKm89rXLRiolJVVYFI+83myP9iBtd563J/HK7+
	 DbjdTdWY3bNBpFxqN70jm3xQh5ya1ULCuPpzkObA7stBo9mbiGLiibzj3ocjWW/MVww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794856145;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=xa5m2kQ4McS89naKgeW1MFetHUtXxopI9MUGzN5ygBU=;
	b=VGF6aoQloK/EMRJV9A9rL6YKOUDBGeg0MI8Z7uMz7/mk9TMm9ozt9udtA2Qhl8djq71Z
	 n0nrz5BoXLf8Fp86QZM0w2XXLg8oSAklDTuEQ0KntxDZiNeqBuw6uqt6UorPlUMiswfEl
	 cftI7zF+rkt/S7T62KYVwFfbvn0ymVcbrp6Fy42nFT+ZEPyl4GOinOxKQmqamwfbiL8sJ
	 b60DbVZMSNLFniCodWAz8OhM/MI+5JDnIqHv3GYYInaxbPZcP6w+QozISsPbgrx8VPIXX
	 wkuqKmb39wII+36dvsHLXB/HSUu4OlEghN4BY5lZ3Iy+Hroko8Y9mxyZCmFRAYfrh8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=vLbwuybu;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD115606A32A;
	Mon, 16 Nov 2026 19:09:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD115606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=vLbwuybu
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 920641684;
	Mon, 16 Nov 2026 11:09:00 -0800 (PST)
Received: from [10.57.69.37] (unknown [10.57.69.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9638C3F763;
	Mon, 16 Nov 2026 11:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794856143; bh=f2swxQ3wi7X4GorXhzlcfPLv2QaLk/FTXlMHUk2SH3Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vLbwuybuJ1gnxVNNBPUef0Ug4GMpb03qX4MOQFkuIvDvKnSaA2YBECf3PHbl6Mh0S
	 5CmTmGAzP11/8d1l6rOX4yk43dY6xvUg7SEvtmTeaHbNuJOuTmgZjUZMl+ZVE4zyYl
	 fzz5Zk8O1bhcT12ZEDIxdCJJyZVCkD/N3LujRf1E=
Message-ID: <5c70e40a-114d-4fe3-ad0d-506589b8e7bc@arm.com>
Date: Mon, 16 Nov 2026 19:09:00 +0000
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
Content-Language: en-GB
To: sashiko-reviews@lists.linux.dev, Steven Price <steven.price@arm.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261116164358.142785-1-steven.price@arm.com>
 <20261116164358.142785-10-steven.price@arm.com>
 <sashiko-outbox-217436@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <sashiko-outbox-217436@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/11/2026 17:31, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential
> issues to consider:
> - [Medium] KVM: arm64: KVM_CAP_PRE_FAULT_MEMORY advertised for Realm VMs
> - [Medium] KVM: arm64: missing unmap on partial failure in
>    realm_map_unprotected()
> - [Low] KVM: arm64: unhandled exec fault on shared Realm IPA in
>    gmem_abort() and user_mem_abort()
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
>>   		goto out_unlock;
>>   	}
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
>>   	if (!perm_fault_granule && !s2vi->map_non_cacheable && kvm_has_mte(kvm))
>>   		sanitise_mte_tags(kvm, pfn, mapping_size);
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

No, this is wrong. As per RMM spec, Rule XLSKP in A5.2.7 Realm access to 
an Unprotected IPA , version 2.0-beta3:

"Realm instruction fetch from an Unprotected IPA causes a Synchronous 
External Abort taken to the Realm."

So the execute permission fault do not come to the KVM.

We could a comment here to make it clear.

> 
> [ ... ]
> 
>> @@ -3155,7 +3217,7 @@ pre_fault_bytes_consumed(gpa_t gpa, unsigned long granule_size,
>>   
>>   int kvm_arch_pre_fault_allowed(struct kvm_vcpu *vcpu)
>>   {
>> -	if (is_protected_kvm_enabled())
>> +	if (is_protected_kvm_enabled() || kvm_vm_is_realm(vcpu->kvm))
>>   		return -EOPNOTSUPP;
>>   	if (!kvm_vcpu_initialized(vcpu))
>>   		return -ENOEXEC;
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

This is taken care of in the later patches on the integration branch,
where the capabilities are restricted for Realms.

Suzuki
