Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793891167;
	b=I1TuiG0DWKkQ/K4hpsc6VcYwemYEg35fCihZ670gr/7Rh3qHWELM7AXwEyVtRVvscrkT
	 fpp0mjPvHuV6RGoVFUK3TsSieapAZqh8v7zd7kzPrTFJ8Dxs0oLoCTM8LZ67cnyToMuiw
	 ieTi6UM2CLtpVcDvt+ZltYv9PZPWglXyKFkEAk6ux++JmgapiCUU/mQksVpG4Pbf7dp8X
	 eZd10y8ZG6vsQSVGWdX6xb1lUCWqpI105Gr/7m/Y7teTHOTaHsHRM3Jsr+Z8qnZVg7D6S
	 1shemuuf2rWqpLPQ5NBNqMxjF+x7wBLmU9Q1wMwzL/Vlz5b/LhKShc245IY03t3gfXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793891167;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Yn0QkHatHx/W4aQMXIv5zjBEyzOdn1ftmVP/Kr4JG3I=;
	b=Mx1AzcefZzTMq/ND15GuazorkHnhiqnNgRpIEBkc953pR+cl1YtL1DU+qCvS6mok0Zou
	 2dmvWrxpgWg+Yyq/+mVMou3lS2otTKnTzhfpSVfGWHKenmLiZ883Wq1V+R9fvyHxGDHOG
	 ZWcOiiMYwMpDmSewtOLPsPOeX/cMgp4uWRTVX49Sz8KIhWPsTNn4CnnHCOm3cEGMpObyH
	 9KPOdN735nfLwLlwrFb/CN/25HBo29GwjDhvvmqB90cwQz9GOla5yrhIvy8WszpbUfDJs
	 yQj32r5Xh90eRWQyuD9Dgr5i+Qyl7SGbnJcqi+tMPFb0G+PYp+Y2/o7AYD2O49n/wzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=kKXfLjoc;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0000606A326;
	Thu,  5 Nov 2026 15:06:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0000606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=kKXfLjoc
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E1B1F168F;
	Thu,  5 Nov 2026 07:06:02 -0800 (PST)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A0EAC3F628;
	Thu,  5 Nov 2026 07:06:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793891166; bh=vR85onfgpCUJLCUOJVtduoihfsVyEmN6bASRt05GYAE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kKXfLjoclyMl8CP3Re4DQ96z4xr/dqy8V5kGJ/OP5jC95ZOfzQfIJo9MzX6dqZ6Ki
	 jCsZ6IIq6tbX9oIWC069Ft0VmSwARjBJ5HFMZeihHBUb2RZohH524i9QGemxuSTrkw
	 DIFGGCTU58ihEFxRV7Lfr+BTtJ1EN/QkipS8Zneg=
Message-ID: <a2dfb2ad-7c52-43e1-8b77-cacb2fa00c05@arm.com>
Date: Thu, 5 Nov 2026 15:06:03 +0000
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
Subject: Re: [PATCH 09/11] KVM: arm64: CCA: Prevent memslot modifications
 after Realm creation
To: Steven Price <steven.price@arm.com>, sashiko-reviews@lists.linux.dev,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Ackerley Tng <ackerleytng@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-10-steven.price@arm.com>
 <sashiko-outbox-193708@kernel.org>
 <9489ebe7-4c75-4229-811e-3f618028d367@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <9489ebe7-4c75-4229-811e-3f618028d367@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/11/2026 11:15, Steven Price wrote:
> On 02/11/2026 15:50, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
>> - [High] KVM: arm64: CCA: guest_memfd memslot delete rejected after Stage-2 unmap
>> --
>>
>> commit 5106402397c36eec1e5fa59a5bb2c5adf4ee2aa8
>> Author: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> KVM: arm64: CCA: Prevent memslot modifications after Realm creation
>>
>> This commit updates kvm_arch_prepare_memory_region() to disallow creating,
>> modifying, or deleting guest_memfd-backed memslots once a Realm has been
>> created.
>>
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index 51fda7b2ff7f3..eb8c5f9e9791d 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -2862,13 +2862,28 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>>   	    (new->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)))
>>>   		return -EPERM;
>>>   
>>> -	if (kvm->arch.vm_flavor == VM_PROTECTED_PKVM) {
>>> +	switch (kvm->arch.vm_flavor) {
>>> +	case VM_PROTECTED_PKVM:
>>>   		/* Cannot modify memslots once a pVM has run. */
>>>   		if (pkvm_hyp_vm_is_created(kvm) &&
>>> -		    (change == KVM_MR_DELETE || change == KVM_MR_MOVE)) {
>>> +		    (change == KVM_MR_DELETE || change == KVM_MR_MOVE))
>>>   			return -EPERM;
>>> -		}
>>> +		break;
>>> +	case VM_REALM:
>>> +		/*
>>> +		 * Once the Realm is created, we cannot modify any slots that
>>> +		 * could be providing private memory. i.e., guest_memfd backed
>>> +		 * slots.
>>> +		 * TODO: Handle trusted device private memory slots
>>> +		 */
>>> +		if (!kvm_realm_is_created(kvm))
>>> +			break;
>>>   
>>> +		if (kvm_slot_has_gmem(old) || kvm_slot_has_gmem(new))
>>> +			return -EPERM;
>>
>> [Severity: High]
>> Does checking kvm_slot_has_gmem(old) in kvm_arch_prepare_memory_region() run
>> too late to prevent Stage-2 unmapping when deleting a guest_memfd-backed
>> memslot on a created Realm?
>>
>> In virt/kvm/kvm_main.c:kvm_set_memory_region(), non-delete changes
>> (KVM_MR_MOVE and KVM_MR_FLAGS_ONLY) on KVM_MEM_GUEST_MEMFD memslots are
>> already rejected upfront with -EINVAL, so kvm_slot_has_gmem(old) is reached
>> here when change == KVM_MR_DELETE.
>>
>> However, in virt/kvm/kvm_main.c:kvm_set_memslot(), KVM invalidates and
>> flushes the old memslot before calling kvm_prepare_memory_region():
>>
>> virt/kvm/kvm_main.c:kvm_set_memslot() {
>> 	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
>> 		invalid_slot = kzalloc_obj(*invalid_slot, GFP_KERNEL_ACCOUNT);
>> 		if (!invalid_slot) {
>> 			mutex_unlock(&kvm->slots_arch_lock);
>> 			return -ENOMEM;
>> 		}
>> 		kvm_invalidate_memslot(kvm, old, invalid_slot);
>> 	}
>>
>> 	r = kvm_prepare_memory_region(kvm, old, new, change);
>> 	if (r)
>> 		goto err;
>> }
>>
>> kvm_invalidate_memslot() marks the active slot as KVM_MEMSLOT_INVALID and
>> calls arch/arm64/kvm/mmu.c:kvm_arch_flush_shadow_memslot():
>>
>> arch/arm64/kvm/mmu.c:kvm_arch_flush_shadow_memslot() {
>> 	write_lock(&kvm->mmu_lock);
>> 	kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, size, true);
>> 	kvm_nested_unmap_cipa_range(kvm, gpa, size, true);
>> 	write_unlock(&kvm->mmu_lock);
>> }
>>
>> For a Realm VM, kvm_stage2_unmap_range() invokes
>> arch/arm64/kvm/rmi.c:kvm_realm_unmap_range_filter() with
>> KVM_FILTER_PRIVATE | KVM_FILTER_SHARED:
>>
>> arch/arm64/kvm/rmi.c:kvm_realm_unmap_range_filter() {
>> 	if (attr_filter & KVM_FILTER_SHARED)
>> 		realm_unmap_shared_range(kvm, start, end, may_block);
>> 	if (attr_filter & KVM_FILTER_PRIVATE)
>> 		realm_unmap_private_range(kvm, start, end, may_block);
>> }
>>
>> By the time kvm_arch_prepare_memory_region() returns -EPERM and
>> kvm_set_memslot() restores the old memslot in the error path, hasn't
>> realm_unmap_private_range() already unmapped and undelegated the Realm's
>> private Stage-2 DATA granules across the memslot's GPA range?
>>
> 
> I think this should be fixable by checking in
> kvm_arch_flush_shadow_memslot() and preserving the stage-2 mappings by
> returning early. kvm_arch_prepare_memory_region() will then reject the
> operation but the mappings will still be in place.

Or is the better fix to delay the kvm_invalidate_memslot() after 
kvm_prepare_memory_region() ? i.e., if we the KVM backend doesn't
approve the change, why do invalidate the slot ? For most of the CoCo
VMs, this would be disastrous.

Suzuki



> 
> Steve

