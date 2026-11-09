Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794224439;
	b=TLyTraiNjs5fOxvGRAiCTvumNUecu3Agg59bWDUiRwwxTqnVG74yamCxui6OFcTNXMKt
	 VnIZWq+No10j4Ts2s5Zv6Q4nMIIxFnzzr474tJB2tFMpVHx3IT7y93gOWkRJUT04himbi
	 mwa5zU9Izu2StAA+HJxJc+Brv44k4xFSetGgU98zf7mkFXtoxgyM4KL8NWTVj+Zlt89Nk
	 rRwD0rxLR1cR4a/HzuGumyCBzdtM+7Y1ylr4lF4Ic2HXA/DKeW53ihVdv1oUnsojZi1Xg
	 2rI0elGiqWeRYJsUSH7CimhKfNPJ8obrk95wZZ8yh21kfPhQrJjbuxM8dJjlK4tHwYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794224439;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=P6FEhudR6ogRTinDCF4ByfUrAD0LKnaB9jVuLbde22U=;
	b=tE77hCZBKU/rqMakBfuSct4kyiUR0OpShyYJMM6+Y46vinnsHvzpbGX/3uMy57HvbjEL
	 kDevEpZImGyRiG1VJmBlER4zm9CFOgpZ8Aexe91V6NbJqJtZw5Q7NhOkUOOYp4lRzeDTO
	 BLKGLQ88V1SstdZE2I4FF2Mf+GnOTbauiZOeUCgzwcGkhEj6PXQkG8KMcuY7d83IGUOGe
	 39wR0t1T+iTtIRCCkRizeNg7Cb7HlgUT2RzoJtmbDWmxfB1G4LLUuIUjaLG2nBHrTZwx+
	 ZZDB1nDdDeQ3K8t/3IsbR8zSwWV7U2F0KGzZrUlz9hv6DmzTVhdgaLKTO0Tqm1jPS7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=NJbxBxRz;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BC67606A321;
	Mon,  9 Nov 2026 11:40:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BC67606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=NJbxBxRz
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1E811516;
	Mon,  9 Nov 2026 03:40:34 -0800 (PST)
Received: from [10.57.60.25] (unknown [10.57.60.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18CCA3F85F;
	Mon,  9 Nov 2026 03:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794224438; bh=uO5FVvRUavaqZi2S2bczdX18f8tYe8+iWi9xblGgeKI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NJbxBxRzdd9XX/idxIQIYdRoG7/DHFZ2pE2GGmkGH11OSsGFKQAOucsXjcBgn64Ys
	 KH6pduBr3QDl+RRD1jv5BRgYSIU+hbhP9fXHS6r708/NWaLzmxOENIoj3DXysni5fv
	 k/Oe8QgVzWzSPmmLkWCTkm+YECh4nzcVbC9dW7/U=
Message-ID: <641e8e57-a0b4-498f-b0d2-b8250802cf67@arm.com>
Date: Mon, 9 Nov 2026 11:40:30 +0000
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
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
 sashiko-reviews@lists.linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Ackerley Tng <ackerleytng@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-10-steven.price@arm.com>
 <sashiko-outbox-193708@kernel.org>
 <9489ebe7-4c75-4229-811e-3f618028d367@arm.com>
 <a2dfb2ad-7c52-43e1-8b77-cacb2fa00c05@arm.com>
 <0d5a4b59-f38c-4c1d-a59e-202e7efb4b54@arm.com>
 <80a956c7-b2b2-411e-99c7-d703c92f3c34@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <80a956c7-b2b2-411e-99c7-d703c92f3c34@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 06/11/2026 16:40, Suzuki K Poulose wrote:
> 
> 
> On 05/11/2026 17:31, Suzuki K Poulose wrote:
>>
>>
>> On 05/11/2026 15:06, Suzuki K Poulose wrote:
>>> On 04/11/2026 11:15, Steven Price wrote:
>>>> On 02/11/2026 15:50, sashiko-bot@kernel.org wrote:
>>>>> Thank you for your contribution! Sashiko AI review found 1
>>>>> potential issue(s) to consider:
>>>>> - [High] KVM: arm64: CCA: guest_memfd memslot delete rejected after
>>>>> Stage-2 unmap
>>>>> -- 
>>>>>
>>>>> commit 5106402397c36eec1e5fa59a5bb2c5adf4ee2aa8
>>>>> Author: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>>>
>>>>> KVM: arm64: CCA: Prevent memslot modifications after Realm creation
>>>>>
>>>>> This commit updates kvm_arch_prepare_memory_region() to disallow
>>>>> creating,
>>>>> modifying, or deleting guest_memfd-backed memslots once a Realm has
>>>>> been
>>>>> created.
>>>>>
>>>>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>>>>> index 51fda7b2ff7f3..eb8c5f9e9791d 100644
>>>>>> --- a/arch/arm64/kvm/mmu.c
>>>>>> +++ b/arch/arm64/kvm/mmu.c
>>>>>> @@ -2862,13 +2862,28 @@ int kvm_arch_prepare_memory_region(struct
>>>>>> kvm *kvm,
>>>>>>           (new->flags & (KVM_MEM_LOG_DIRTY_PAGES |
>>>>>> KVM_MEM_READONLY)))
>>>>>>           return -EPERM;
>>>>>> -    if (kvm->arch.vm_flavor == VM_PROTECTED_PKVM) {
>>>>>> +    switch (kvm->arch.vm_flavor) {
>>>>>> +    case VM_PROTECTED_PKVM:
>>>>>>           /* Cannot modify memslots once a pVM has run. */
>>>>>>           if (pkvm_hyp_vm_is_created(kvm) &&
>>>>>> -            (change == KVM_MR_DELETE || change == KVM_MR_MOVE)) {
>>>>>> +            (change == KVM_MR_DELETE || change == KVM_MR_MOVE))
>>>>>>               return -EPERM;
>>>>>> -        }
>>>>>> +        break;
>>>>>> +    case VM_REALM:
>>>>>> +        /*
>>>>>> +         * Once the Realm is created, we cannot modify any slots
>>>>>> that
>>>>>> +         * could be providing private memory. i.e., guest_memfd
>>>>>> backed
>>>>>> +         * slots.
>>>>>> +         * TODO: Handle trusted device private memory slots
>>>>>> +         */
>>>>>> +        if (!kvm_realm_is_created(kvm))
>>>>>> +            break;
>>>>>> +        if (kvm_slot_has_gmem(old) || kvm_slot_has_gmem(new))
>>>>>> +            return -EPERM;
>>>>>
>>>>> [Severity: High]
>>>>> Does checking kvm_slot_has_gmem(old) in
>>>>> kvm_arch_prepare_memory_region() run
>>>>> too late to prevent Stage-2 unmapping when deleting a guest_memfd-
>>>>> backed
>>>>> memslot on a created Realm?
>>>>>
>>>>> In virt/kvm/kvm_main.c:kvm_set_memory_region(), non-delete changes
>>>>> (KVM_MR_MOVE and KVM_MR_FLAGS_ONLY) on KVM_MEM_GUEST_MEMFD memslots
>>>>> are
>>>>> already rejected upfront with -EINVAL, so kvm_slot_has_gmem(old) is
>>>>> reached
>>>>> here when change == KVM_MR_DELETE.
>>>>>
>>>>> However, in virt/kvm/kvm_main.c:kvm_set_memslot(), KVM invalidates and
>>>>> flushes the old memslot before calling kvm_prepare_memory_region():
>>>>>
>>>>> virt/kvm/kvm_main.c:kvm_set_memslot() {
>>>>>     if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
>>>>>         invalid_slot = kzalloc_obj(*invalid_slot, GFP_KERNEL_ACCOUNT);
>>>>>         if (!invalid_slot) {
>>>>>             mutex_unlock(&kvm->slots_arch_lock);
>>>>>             return -ENOMEM;
>>>>>         }
>>>>>         kvm_invalidate_memslot(kvm, old, invalid_slot);
>>>>>     }
>>>>>
>>>>>     r = kvm_prepare_memory_region(kvm, old, new, change);
>>>>>     if (r)
>>>>>         goto err;
>>>>> }
>>>>>
>>>>> kvm_invalidate_memslot() marks the active slot as
>>>>> KVM_MEMSLOT_INVALID and
>>>>> calls arch/arm64/kvm/mmu.c:kvm_arch_flush_shadow_memslot():
>>>>>
>>>>> arch/arm64/kvm/mmu.c:kvm_arch_flush_shadow_memslot() {
>>>>>     write_lock(&kvm->mmu_lock);
>>>>>     kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, size, true);
>>>>>     kvm_nested_unmap_cipa_range(kvm, gpa, size, true);
>>>>>     write_unlock(&kvm->mmu_lock);
>>>>> }
>>>>>
>>>>> For a Realm VM, kvm_stage2_unmap_range() invokes
>>>>> arch/arm64/kvm/rmi.c:kvm_realm_unmap_range_filter() with
>>>>> KVM_FILTER_PRIVATE | KVM_FILTER_SHARED:
>>>>>
>>>>> arch/arm64/kvm/rmi.c:kvm_realm_unmap_range_filter() {
>>>>>     if (attr_filter & KVM_FILTER_SHARED)
>>>>>         realm_unmap_shared_range(kvm, start, end, may_block);
>>>>>     if (attr_filter & KVM_FILTER_PRIVATE)
>>>>>         realm_unmap_private_range(kvm, start, end, may_block);
>>>>> }
>>>>>
>>>>> By the time kvm_arch_prepare_memory_region() returns -EPERM and
>>>>> kvm_set_memslot() restores the old memslot in the error path, hasn't
>>>>> realm_unmap_private_range() already unmapped and undelegated the
>>>>> Realm's
>>>>> private Stage-2 DATA granules across the memslot's GPA range?
>>>>>
>>>>
>>>> I think this should be fixable by checking in
>>>> kvm_arch_flush_shadow_memslot() and preserving the stage-2 mappings by
>>>> returning early. kvm_arch_prepare_memory_region() will then reject the
>>>> operation but the mappings will still be in place.
>>>
>>> Or is the better fix to delay the kvm_invalidate_memslot() after
>>> kvm_prepare_memory_region() ? i.e., if we the KVM backend doesn't
>>> approve the change, why do invalidate the slot ? For most of the CoCo
>>> VMs, this would be disastrous.
>>
>>
>> Ignore this, driver for CCA is doing the wrong thing. Instead of
>> flushing (which is a NOP for CCA), we were removing the mapping.
> 
> Well, I got it confused with arm64 calling stage2_flush_memslot()
> (called for flushing the dcache for a memory slot) with
> kvm_arch_flush_shadow_memslot() (unmapping a memslot from the guest).
> 
> We do have a problem with the memslot code ordering. For all VMs, on a
> memslot deletion, we first invalidate the memslot and then run the
> "prepare" hook for the architecture, which could reject a DELETE. This
> is particularly an issue for the Coco VMs, if they want to reject
> deletion of memslots while the VM is active ( e.g., Realm and pKVM),
> unless the VM prevents the stage2 modification (e.g., pKVM ignores
> stage2 unmap requests). Even there, the pKVM may keep the memory mapped
> when the memslot is deleted. But the page pinning keeps the pages in
> tact.
> 
> Something like the following could work:

Yes, that's better than the hack I had locally - I'll pick that patch up
for v2.

Thanks,
Steve

> ---8>---
> 
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> Date: Fri, 6 Nov 2026 16:31:15 +0000
> Subject: [PATCH] KVM: Allow architectures to reject memslot changes before
>  invalidation
> 
> Architectures may need to reject deletion of a memory slot without
> changing the guest's memory mappings. Currently, KVM invalidates the slot
> and calls kvm_arch_flush_shadow_memslot() before
> kvm_arch_prepare_memory_region() can reject the request. On arm64, this
> unmaps the slot from stage-2. Restoring the old memslot on failure does not
> restore those mappings, so even a rejected deletion has side effects.
> 
> Add kvm_arch_validate_memory_region() and invoke it before invalidating
> the slot, with slots_lock and slots_arch_lock held. The hook performs
> validation only, allowing architectures to reject a request without
> changing the memslot or its mappings. Provide a weak no-op implementation
> for architectures that do not need early validation.
> 
> Move arm64's protected VM checks into the new hook so that unsupported
> deletions and moves are rejected before stage-2 unmapping. Keep resource
> preparation after invalidation, since invalidation drops slots_arch_lock
> and allows concurrent updates to architecture-specific memslot metadata.
> 
> Assisted-by: LLM
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm64/kvm/mmu.c     | 22 ++++++++++++++++------
>  arch/arm64/kvm/pkvm.c    |  2 +-
>  include/linux/kvm_host.h |  4 ++++
>  virt/kvm/kvm_main.c      | 33 ++++++++++++++++++++++++++-------
>  4 files changed, 47 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1db10d8d6db7..c3469551fe3c 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2806,13 +2806,12 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>      }
>  }
> 
> -int kvm_arch_prepare_memory_region(struct kvm *kvm,
> -                   const struct kvm_memory_slot *old,
> -                   struct kvm_memory_slot *new,
> -                   enum kvm_mr_change change)
> +int kvm_arch_validate_memory_region(struct kvm *kvm,
> +                    const struct kvm_memory_slot *old,
> +                    const struct kvm_memory_slot *new,
> +                    enum kvm_mr_change change)
>  {
> -    hva_t hva, reg_end;
> -    int ret = 0;
> +    lockdep_assert_held(&kvm->slots_lock);
> 
>      if (kvm_vm_is_protected(kvm)) {
>          /* Cannot modify memslots once a pVM has run. */
> @@ -2827,6 +2826,17 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>          }
>      }
> 
> +    return 0;
> +}
> +
> +int kvm_arch_prepare_memory_region(struct kvm *kvm,
> +                   const struct kvm_memory_slot *old,
> +                   struct kvm_memory_slot *new,
> +                   enum kvm_mr_change change)
> +{
> +    hva_t hva, reg_end;
> +    int ret = 0;
> +
>      if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
>              change != KVM_MR_FLAGS_ONLY)
>          return 0;
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 016997288fd2..552a40871ab1 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -262,7 +262,7 @@ int pkvm_create_hyp_vm(struct kvm *kvm)
>      int ret = 0;
> 
>      /*
> -     * Synchronise with kvm_arch_prepare_memory_region(), as we
> +     * Synchronise with kvm_arch_validate_memory_region(), as we
>       * prevent memslot modifications on a pVM that has been run.
>       */
>      mutex_lock(&kvm->slots_lock);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e7fc94e2910a..310afcaf7021 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1255,6 +1255,10 @@ int kvm_set_internal_memslot(struct kvm *kvm,
>                   const struct kvm_userspace_memory_region2 *mem);
>  void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot);
>  void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen);
> +int kvm_arch_validate_memory_region(struct kvm *kvm,
> +                    const struct kvm_memory_slot *old,
> +                    const struct kvm_memory_slot *new,
> +                    enum kvm_mr_change change);
>  int kvm_arch_prepare_memory_region(struct kvm *kvm,
>                  const struct kvm_memory_slot *old,
>                  struct kvm_memory_slot *new,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index cf4cb586f140..3ef370d71818 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1682,6 +1682,20 @@ static void kvm_swap_active_memslots(struct kvm
> *kvm, int as_id)
>      slots->generation = gen;
>  }
> 
> +/*
> + * Validate a memslot change before invalidation, which may
> irreversibly reclaim
> + * private guest memory. Called with slots_lock and slots_arch_lock held.
> + * Implementations must not modify memslot state or allocate resources;
> leave
> + * those operations to kvm_arch_prepare_memory_region().
> + */
> +__weak int kvm_arch_validate_memory_region(struct kvm *kvm,
> +                       const struct kvm_memory_slot *old,
> +                       const struct kvm_memory_slot *new,
> +                       enum kvm_mr_change change)
> +{
> +    return 0;
> +}
> +
>  static int kvm_prepare_memory_region(struct kvm *kvm,
>                       const struct kvm_memory_slot *old,
>                       struct kvm_memory_slot *new,
> @@ -1934,6 +1948,10 @@ static int kvm_set_memslot(struct kvm *kvm,
>       */
>      mutex_lock(&kvm->slots_arch_lock);
> 
> +    r = kvm_arch_validate_memory_region(kvm, old, new, change);
> +    if (r)
> +        goto unlock_err;
> +
>      /*
>       * Invalidate the old slot if it's being deleted or moved.  This is
>       * done prior to actually deleting/moving the memslot to allow
> vCPUs to
> @@ -1950,22 +1968,22 @@ static int kvm_set_memslot(struct kvm *kvm,
>      if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
>          invalid_slot = kzalloc_obj(*invalid_slot, GFP_KERNEL_ACCOUNT);
>          if (!invalid_slot) {
> -            mutex_unlock(&kvm->slots_arch_lock);
> -            return -ENOMEM;
> +            r = -ENOMEM;
> +            goto unlock_err;
>          }
>          kvm_invalidate_memslot(kvm, old, invalid_slot);
>      }
> 
>      r = kvm_prepare_memory_region(kvm, old, new, change);
>      if (r)
> -        goto err;
> +        goto revert_slot;
> 
>      if (change == KVM_MR_CREATE && (new->flags & KVM_MEM_GUEST_MEMFD)) {
>          r = kvm_gmem_commit_memory_region(kvm, new);
>          if (r) {
>              kvm_arch_free_memslot(kvm, new);
>              kvm_destroy_dirty_bitmap(new);
> -            goto err;
> +            goto unlock_err;
>          }
>      }
> 
> @@ -2000,7 +2018,7 @@ static int kvm_set_memslot(struct kvm *kvm,
> 
>      return 0;
> 
> -err:
> +revert_slot:
>      /*
>       * For DELETE/MOVE, revert the above INVALID change.  No modifications
>       * required since the original slot was preserved in the inactive
> slots.
> @@ -2009,9 +2027,10 @@ static int kvm_set_memslot(struct kvm *kvm,
>      if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
>          kvm_activate_memslot(kvm, invalid_slot, old);
>          kfree(invalid_slot);
> -    } else {
> -        mutex_unlock(&kvm->slots_arch_lock);
> +        return r;
>      }
> +unlock_err:
> +    mutex_unlock(&kvm->slots_arch_lock);
>      return r;
>  }
> 

