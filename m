Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793899914;
	b=CpBdyXir8oKXrWtEACZaVJqqS4jyxv8oOa+8COpzWz5WD4GwPcfqnPzxFGAnbpknU6KG
	 GL/LR4Prx5sHeJ6xQOrt1z2iOo79Jg7Dmx97TCt0g4e7JvVNiJrv9VBsTh6/VJPTzC7UA
	 CAlsgOOpN3jvzrc2z1cbQoXx1kl2Ifr2rTSJyweiSOtAvVnmsGE1xKQeWQMUhr16A/eXY
	 wy/gOdcDRfC6mr8E1+PsOPIH1l56KgV9LgfrgbtdNRacMlaN+0B83aal7XrKzxGGfTSkk
	 kd+kNjeXubPXU3xen3aML1hfFgFJWnZxqOrelQyIR6I02NoawuOwKzTwTzaTCooeQGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899914;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:From:To:Cc:References:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=YKulzZM0URwerrPabJBi4D2xYbrKiSJ1N2beCoy9biU=;
	b=UQzlRnO9kQE1gctIzRZAgN4Ku7wJJ2OupGeEum4g1IOqUqgSR8ETs7d4jVbePyTPYvZG
	 Mue8RT3djgy4Mdl7GRR+sKxa5SPPnHFHildfsq4MeFd7gIyHum5MIvqUz/2WERxLwq1SJ
	 lylUKgJiGS+s3pjUBOe6Kh66iLoKQnGGMmH+JJKWVUmFxyxUPiqUDthRC/95sTkQ1KNUU
	 A2zjuWk5Ai4e1LQjtNv3hfFxO7vbcNTFPhPIBoXY+2EQ4ch4leHgvgnNHL/NmasXnU720
	 cxy50E+I+PCJrvBa2wUm6+DznrURPhXTZRHftbh1XtTqyHIh6QHN4j20cS+4qQ2K2kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=i7RS6puz;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 641FE606A326;
	Thu,  5 Nov 2026 17:31:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 641FE606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=i7RS6puz
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A96541596;
	Thu,  5 Nov 2026 09:31:49 -0800 (PST)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A1C0D3F628;
	Thu,  5 Nov 2026 09:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793899912; bh=XXpaSz8VDhnp2Ua2FudpG2j4Ty9LSQB5GikQ0O0/Xag=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=i7RS6puz/MVKzQ5X29iNuL78bzNVknNnJjndXSlO1sQTMsU8SNXVGXQVzi3eDMMwu
	 17m3I0U+ra/NW5Cy8hJjp3g/Mnqzor7WloMuegvmPpr/zNYSLPLSFg1JJQd6wcb45V
	 QoeMT8yjWQRRVczYl1Srd0/rUQCwN8WwLK858djU=
Message-ID: <0d5a4b59-f38c-4c1d-a59e-202e7efb4b54@arm.com>
Date: Thu, 5 Nov 2026 17:31:50 +0000
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
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Steven Price <steven.price@arm.com>, sashiko-reviews@lists.linux.dev,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Ackerley Tng <ackerleytng@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-10-steven.price@arm.com>
 <sashiko-outbox-193708@kernel.org>
 <9489ebe7-4c75-4229-811e-3f618028d367@arm.com>
 <a2dfb2ad-7c52-43e1-8b77-cacb2fa00c05@arm.com>
Content-Language: en-US
In-Reply-To: <a2dfb2ad-7c52-43e1-8b77-cacb2fa00c05@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 05/11/2026 15:06, Suzuki K Poulose wrote:
> On 04/11/2026 11:15, Steven Price wrote:
>> On 02/11/2026 15:50, sashiko-bot@kernel.org wrote:
>>> Thank you for your contribution! Sashiko AI review found 1 potential 
>>> issue(s) to consider:
>>> - [High] KVM: arm64: CCA: guest_memfd memslot delete rejected after 
>>> Stage-2 unmap
>>> -- 
>>>
>>> commit 5106402397c36eec1e5fa59a5bb2c5adf4ee2aa8
>>> Author: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>
>>> KVM: arm64: CCA: Prevent memslot modifications after Realm creation
>>>
>>> This commit updates kvm_arch_prepare_memory_region() to disallow 
>>> creating,
>>> modifying, or deleting guest_memfd-backed memslots once a Realm has been
>>> created.
>>>
>>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>>> index 51fda7b2ff7f3..eb8c5f9e9791d 100644
>>>> --- a/arch/arm64/kvm/mmu.c
>>>> +++ b/arch/arm64/kvm/mmu.c
>>>> @@ -2862,13 +2862,28 @@ int kvm_arch_prepare_memory_region(struct 
>>>> kvm *kvm,
>>>>           (new->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)))
>>>>           return -EPERM;
>>>> -    if (kvm->arch.vm_flavor == VM_PROTECTED_PKVM) {
>>>> +    switch (kvm->arch.vm_flavor) {
>>>> +    case VM_PROTECTED_PKVM:
>>>>           /* Cannot modify memslots once a pVM has run. */
>>>>           if (pkvm_hyp_vm_is_created(kvm) &&
>>>> -            (change == KVM_MR_DELETE || change == KVM_MR_MOVE)) {
>>>> +            (change == KVM_MR_DELETE || change == KVM_MR_MOVE))
>>>>               return -EPERM;
>>>> -        }
>>>> +        break;
>>>> +    case VM_REALM:
>>>> +        /*
>>>> +         * Once the Realm is created, we cannot modify any slots that
>>>> +         * could be providing private memory. i.e., guest_memfd backed
>>>> +         * slots.
>>>> +         * TODO: Handle trusted device private memory slots
>>>> +         */
>>>> +        if (!kvm_realm_is_created(kvm))
>>>> +            break;
>>>> +        if (kvm_slot_has_gmem(old) || kvm_slot_has_gmem(new))
>>>> +            return -EPERM;
>>>
>>> [Severity: High]
>>> Does checking kvm_slot_has_gmem(old) in 
>>> kvm_arch_prepare_memory_region() run
>>> too late to prevent Stage-2 unmapping when deleting a guest_memfd-backed
>>> memslot on a created Realm?
>>>
>>> In virt/kvm/kvm_main.c:kvm_set_memory_region(), non-delete changes
>>> (KVM_MR_MOVE and KVM_MR_FLAGS_ONLY) on KVM_MEM_GUEST_MEMFD memslots are
>>> already rejected upfront with -EINVAL, so kvm_slot_has_gmem(old) is 
>>> reached
>>> here when change == KVM_MR_DELETE.
>>>
>>> However, in virt/kvm/kvm_main.c:kvm_set_memslot(), KVM invalidates and
>>> flushes the old memslot before calling kvm_prepare_memory_region():
>>>
>>> virt/kvm/kvm_main.c:kvm_set_memslot() {
>>>     if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
>>>         invalid_slot = kzalloc_obj(*invalid_slot, GFP_KERNEL_ACCOUNT);
>>>         if (!invalid_slot) {
>>>             mutex_unlock(&kvm->slots_arch_lock);
>>>             return -ENOMEM;
>>>         }
>>>         kvm_invalidate_memslot(kvm, old, invalid_slot);
>>>     }
>>>
>>>     r = kvm_prepare_memory_region(kvm, old, new, change);
>>>     if (r)
>>>         goto err;
>>> }
>>>
>>> kvm_invalidate_memslot() marks the active slot as KVM_MEMSLOT_INVALID 
>>> and
>>> calls arch/arm64/kvm/mmu.c:kvm_arch_flush_shadow_memslot():
>>>
>>> arch/arm64/kvm/mmu.c:kvm_arch_flush_shadow_memslot() {
>>>     write_lock(&kvm->mmu_lock);
>>>     kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, size, true);
>>>     kvm_nested_unmap_cipa_range(kvm, gpa, size, true);
>>>     write_unlock(&kvm->mmu_lock);
>>> }
>>>
>>> For a Realm VM, kvm_stage2_unmap_range() invokes
>>> arch/arm64/kvm/rmi.c:kvm_realm_unmap_range_filter() with
>>> KVM_FILTER_PRIVATE | KVM_FILTER_SHARED:
>>>
>>> arch/arm64/kvm/rmi.c:kvm_realm_unmap_range_filter() {
>>>     if (attr_filter & KVM_FILTER_SHARED)
>>>         realm_unmap_shared_range(kvm, start, end, may_block);
>>>     if (attr_filter & KVM_FILTER_PRIVATE)
>>>         realm_unmap_private_range(kvm, start, end, may_block);
>>> }
>>>
>>> By the time kvm_arch_prepare_memory_region() returns -EPERM and
>>> kvm_set_memslot() restores the old memslot in the error path, hasn't
>>> realm_unmap_private_range() already unmapped and undelegated the Realm's
>>> private Stage-2 DATA granules across the memslot's GPA range?
>>>
>>
>> I think this should be fixable by checking in
>> kvm_arch_flush_shadow_memslot() and preserving the stage-2 mappings by
>> returning early. kvm_arch_prepare_memory_region() will then reject the
>> operation but the mappings will still be in place.
> 
> Or is the better fix to delay the kvm_invalidate_memslot() after 
> kvm_prepare_memory_region() ? i.e., if we the KVM backend doesn't
> approve the change, why do invalidate the slot ? For most of the CoCo
> VMs, this would be disastrous.


Ignore this, driver for CCA is doing the wrong thing. Instead of
flushing (which is a NOP for CCA), we were removing the mapping.


Cheers
Suzuki

> 
> Suzuki
> 
> 
> 
>>
>> Steve
> 

