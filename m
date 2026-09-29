Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92B1F496D31;
	Tue, 29 Sep 2026 10:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790678834; cv=none; b=nSksDf9RimoSzgB9S92iGELWtH8rew5tPpmapaIUjc/7QlypKBiq8D1eayORKYJ5fXI535+02z3Jon1cxPsx6cpUBiBJ55GvoMlwzQIkread9Y+ZJhqefWhkTCl/D+MUdg2ZReFq+sWBFB+/dF2cs3+td+mdbB0+4lH5aUNwPDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790678834; c=relaxed/simple;
	bh=hDXphX09qKnZTaJnf2uETn6cTi5T0p2DOBdhFYlOQCQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=heDUCBNiaKr9UMjMKN9jFTRjkV2duKObi+D1j+LEUD+03/d4SeoRNaO1MazPHuzA+QeipBgokXBbpCuGqscIfJ438JJS7xwMZYIdLin8U4yiMzuNATsOEjrEfdlPEoBKQmeiyE3RAJsdmOrMaSHoWAi3UUHemIAet5oLOckZipU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lKxkrxDj; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lKxkrxDj"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0CFC0143D;
	Tue, 29 Sep 2026 03:47:02 -0700 (PDT)
Received: from [10.57.12.116] (unknown [10.57.12.116])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 87A813F86F;
	Tue, 29 Sep 2026 03:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790678825; bh=hDXphX09qKnZTaJnf2uETn6cTi5T0p2DOBdhFYlOQCQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lKxkrxDjvga5FOjH3t6Yj1iKwWagsd/wMmWoA1WYkVLzMM4llvhziG7QgcnfVdXib
	 tu+C5uVpMbjZ+ckSbcRTtXaNmdq6FjJcWtA3LYkyHniieLc6R7hR35T/CrN9ou94HE
	 IH6YjWHpRHoYZRCC0zogCsU5b0m6BAEs3zlVuGUQ=
Message-ID: <26e097b4-58f6-42e1-ad7e-1b5c67673a21@arm.com>
Date: Tue, 29 Sep 2026 11:47:01 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18] arm64: mm: Handle Granule Protection Faults (GPFs)
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260913070459.2547407-1-suzuki.poulose@arm.com>
 <aqrGPK0lFBFXL2qY@arm.com> <985520fa-99b0-4620-bfee-8e6321b36104@arm.com>
 <aqvCwM_73qMpqzvV@arm.com> <749ab0c9-810d-4989-8fa5-1706124f05bc@arm.com>
 <arKVcjCOJf8p9rWL@arm.com> <4e315360-5b7a-4a0e-99c0-679a0271e625@arm.com>
 <aruVrvQcYCGe0HJ6@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <aruVrvQcYCGe0HJ6@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/09/2026 11:40, Catalin Marinas wrote:
> On Mon, Sep 28, 2026 at 12:01:18PM +0100, Suzuki K Poulose wrote:
>> On 22/09/2026 15:49, Catalin Marinas wrote:
>>> On Tue, Sep 22, 2026 at 02:21:13PM +0100, Suzuki K Poulose wrote:
>>>> I had another look and we could handle this via kvm_fault_is_gmem_abort()
>>>> see in arch/arm64/kvm/mmu.c:
>>>>
>>>>
>>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>>> index 87e49251e0447..af5a4bf961aae 100644
>>>> --- a/arch/arm64/kvm/mmu.c
>>>> +++ b/arch/arm64/kvm/mmu.c
>>>> @@ -1731,6 +1731,9 @@ static int gmem_abort(const struct kvm_s2_fault_desc
>>>> *s2fd)
>>>>           gfn_t gfn;
>>>>           int ret;
>>>>
>>>> +       if (!kvm_slot_has_gmem(s2fd->memslot))
>>>> +               return -EINVAL;
>>>
>>> I wonder whether we should add a KVM_BUG_ON() here. With the rest of the
>>> changes, we should never get in this situation. Well, to be revisited
>>> for private devices.
>>>
>>> Also maybe move it to the caller, kvm_vm_mem_abort(), and not change
>>> kvm_fault_is_gmem_abort(). Something like:
>>>
>>> 	if (private_ipa_fault(kvm, s2fd->fault_ipa) &&
>>> 	    KVM_BUG_ON(!kvm_slot_has_gmem(s2fd->memslot), kvm))
>>> 		return -EIO;
>>>
>>> To me it makes more sense for gmem_abort() to be called only *if* it's a
>>> gmem slot. So any inconsistency, avoiding user_mem_abort() for private
>>> memory, should be done in the caller. I assume the caller will also have
>>> to route the private device path as well rather than rely on
>>> gmem_abort().
>>>
>>>> +
>>>>           if (!perm_fault) {
>>>>                   memcache = get_mmu_memcache(vcpu);
>>>>                   ret = topup_mmu_memcache(vcpu, memcache);
>>>> @@ -2277,10 +2280,12 @@ static bool private_ipa_fault(struct kvm *kvm,
>>>> phys_addr_t fault_ipa);
>>>>    static bool kvm_fault_is_gmem_abort(struct kvm *kvm,
>>>>                                       const struct kvm_s2_fault_desc *s2fd)
>>>>    {
>>>> -       if (!kvm_slot_has_gmem(s2fd->memslot))
>>>> -               return false;
>>>>           if (kvm_memslot_is_gmem_only(s2fd->memslot))
>>>>                   return true;
>>>> +       /*
>>>> +        * For Realms, all private faults must be backed by GMEM.
>>>> +        * TODO: Handle Trusted device private memory mappings.
>>>> +        */
>>>>           if (private_ipa_fault(kvm, s2fd->fault_ipa))
>>>>                   return true;
>>>>           return false;
>>>>
>>>>
>>>> Also, I have the following hunk for preventing memslot modifications.
>>>> I will add this to v20 integration branch, which is almost ready ;-)
>>>>
>>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>>> index 582b48e34486b..87e49251e0447 100644
>>>> --- a/arch/arm64/kvm/mmu.c
>>>> +++ b/arch/arm64/kvm/mmu.c
>>>> @@ -2783,6 +2783,18 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>>>>           }
>>>>    }
>>>>
>>>> +static bool kvm_prevents_memslot_change(struct kvm *kvm, enum kvm_mr_change change)
>>>> +{
>>>> +       /* Cannot modify memslots once a pVM has run or Realm created */
>>>> +       if (change != KVM_MR_DELETE && change != KVM_MR_MOVE)
>>>> +               return false;
>>>> +
>>>> +       if ((kvm_vm_is_protected_pkvm(kvm) && pkvm_hyp_vm_is_created(kvm)) ||
>>>> +            kvm_realm_is_created(kvm))
>>>> +               return true;
>>>> +       return false;
>>>> +}
>>>> +
>>
>> This needs to be tweaked for Realm to support non-secure device assignment.
>> Aneesh reports that the Device assignment fails now,
>> because the Device BAR reset deletes the memory slot and re-registers
>> it, which the above change prevents.
>>
>> I will modify that to
>> 1. Prevent "Guest-memfd" backed memory slot deletion. Makes sure that
>>     nothing can replace a private memory slot.
>> 2. Allow non-Guest-memfd backed memory slots to be created
>>    after the Realm is created. We anyways prevent "private" memory
>>    to be mapped from a non-Guest-memfd memslot.
> 
> Yes, I think this should be fine. But at least with the last version I
> looked at, we did not prevent private memory from being mapped from
> non-guest_memfd slots (there was a way to delete the gmem slot, add a
> normal one while the guest does a private IPA access). If we prevent
> gmem slot deletion, we no longer have this issue, although we should
> warn somewhere on the user_mem_abort() both.
> 
> Anyway, to be discussed on the KVM patches, not here. I raised it
> initially here as I was looking whether a non-gmem slot ever ends up
> private and trigger the GPF.

Agree. For the record here is what the change looks like, to be included
in v21 kvm-integration. We can discuss it with KVM changes.



KVM: arm64: CCA: Prevent memslot modifications after Realm creation

Once the Realm is created, prevent any changes to guest_memfd backed
memslots, as the private memory is provided by slots backed by gmem.
This is also validated when we handle a fault for Realm Stage2.

Additionally, similar to pKVM, we do not support dirty logging or
read-only memslots.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2e584a187602f..ea14f66ed9f29 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2726,17 +2726,28 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
         hva_t hva, reg_end;
         int ret = 0;

+       if (kvm_vm_is_protected(kvm)) {
+               if (new &&
+                   new->flags & (KVM_MEM_LOG_DIRTY_PAGES | 
KVM_MEM_READONLY)) {
+                       return -EPERM;
+               }
+       }
+
         if (kvm_vm_is_protected_pkvm(kvm)) {
                 /* Cannot modify memslots once a pVM has run. */
                 if (pkvm_hyp_vm_is_created(kvm) &&
                     (change == KVM_MR_DELETE || change == KVM_MR_MOVE)) {
                         return -EPERM;
                 }
-
-               if (new &&
-                   new->flags & (KVM_MEM_LOG_DIRTY_PAGES | 
KVM_MEM_READONLY)) {
+       } else if (kvm_realm_is_created(kvm)) {
+               /*
+                * Once the Realm is created, we cannot modify any slots 
that
+                * could be providing private memory. i.e., guest_memfd 
backed
+                * slots.
+                * TODO: Handle trusted device private memory slots
+                */
+               if (kvm_slot_has_gmem(old) || kvm_slot_has_gmem(new))
                         return -EPERM;
-               }
         }

         if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 8756ea4c76619..5755422ddcb49 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -1196,6 +1196,7 @@ int kvm_activate_realm(struct kvm *kvm)
         if (kvm_realm_state(kvm) >= REALM_STATE_ACTIVE)
                 return 0;

+       guard(mutex)(&kvm->slots_lock);
         guard(mutex)(&kvm->arch.config_lock);
         /* Check again with the lock held */
         if (kvm_realm_state(kvm) >= REALM_STATE_ACTIVE)

> 

