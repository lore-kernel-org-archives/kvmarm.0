Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC5593749E3;
	Tue, 22 Sep 2026 13:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790083282; cv=none; b=ZNYeyegtdMZUmd6zVnAI/nrnzPqyMFcfi9WCzL18rEm4LO0/7UXCVWNc+u5IJZQ5RZvp/Xd6ex239qS2Oq+jx+wrwNSnKIs9Oct2/v8iFbxrmpuefkC115/2GlfhkZWQj/8QpyoX4EqCYxCq26Yrv5EI+yp4gq3PQK18k/Xtgoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790083282; c=relaxed/simple;
	bh=xrhxmYRJ3exYToZIwckZeEM/ye2FI4uMt5lT4VUw7/s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qWvQLHkH3iZpKRv8BDTQc0ypqdvOgGFdNkoI5e3ma7maBxJOtcwaui1G7qkKefvu92kILv5jyHHXDVpA9kMmE023ABE74GfSjGklXFuenFUM2GcoiB451cPAGeS1A6kki7yDSZkpfgNpDXPt5VabQwoxqUFKb8KSO9N0kxsJEkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Fezc+pwV; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Fezc+pwV"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0641B1576;
	Tue, 22 Sep 2026 06:21:15 -0700 (PDT)
Received: from [10.0.128.141] (unknown [10.0.128.141])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 288CE3F528;
	Tue, 22 Sep 2026 06:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790083278; bh=xrhxmYRJ3exYToZIwckZeEM/ye2FI4uMt5lT4VUw7/s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Fezc+pwVgB2Q4yk8pMzu0lSh4oRsM2AoyznvJEKbquznTYI8da3CnVeUBg5R+vc4H
	 EAaYOCenq71LSbSO9o8g+QEAXUpImhKENpTJvw/AQNx4pmVGKL78IA0b5kpccsoJrr
	 SfO7aYxh7TtA8H3nK9IGl2MolrdU+LMBzoipwCM8=
Message-ID: <749ab0c9-810d-4989-8fa5-1706124f05bc@arm.com>
Date: Tue, 22 Sep 2026 14:21:13 +0100
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
 <aqvCwM_73qMpqzvV@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <aqvCwM_73qMpqzvV@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17/09/2026 11:36, Catalin Marinas wrote:
> Hi Suzuki,
> 
> On Thu, Sep 17, 2026 at 10:03:14AM +0100, Suzuki K Poulose wrote:
>> On 16/09/2026 17:39, Catalin Marinas wrote:
>>> On Sun, Sep 13, 2026 at 08:04:58AM +0100, Suzuki K Poulose wrote:
>>>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>>>> index 75c3e463df2ef..dc3a87902a60c 100644
>>>> --- a/arch/arm64/mm/fault.c
>>>> +++ b/arch/arm64/mm/fault.c
>>>> @@ -914,6 +914,24 @@ static int do_tag_check_fault(unsigned long far, unsigned long esr,
>>>>    	return 0;
>>>>    }
>>>> +static int do_gpf_ptw(unsigned long far, unsigned long esr, struct pt_regs *regs)
>>>> +{
>>>> +	const struct fault_info *inf = esr_to_fault_info(esr);
>>>> +	unsigned long addr = untagged_addr(far);
>>>> +
>>>> +	die_kernel_fault(inf->name, addr, esr, regs);
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int do_gpf(unsigned long far, unsigned long esr, struct pt_regs *regs)
>>>> +{
>>>> +	if (!user_mode(regs) && !is_el1_instruction_abort(esr) &&
>>>> +	    fixup_exception(regs, esr))
>>>> +		return 0;
>>>> +
>>>> +	return 1;
>>>> +}
>>>
>>> We discussed briefly offline. With the latest patches around, would we
>>> ever end up with private memory mapped in the VMM and hence the GPF? If
>>> not, I would still keep this handling but add a
>>> WARN_ON_ONCE(user_mode(regs)).
>>>
>>> However, can we end up delegating a non-guest_memfd memslot page as
>>> protected?
>>>
>>> I played a bit with codex and it reckons it's possible if a guest_memfd
>>> memslot is deleted after its IPA range has been initialised with
>>> RIPAS=RAM. Removing the memslot unmaps and undelegates any data pages
>>> but leaves the RMM state as RAM. The VMM can then install an ordinary
>>> memslot over the same GPA range.
>>
>> This should be prevented by the following predicates:
>>
>> 1) Realms only support guest_memfd backed memslots for mappable memory.
>> 2) Memslots cannot be created after the Realm is created, as is with the
>> protected VMs. (This check seems to have been lost over the iterations,
>>   but should be reinstated).
> 
> If that's the intended model, I think it should work. But v18 doesn't
> enforce either of them. I noticed the second predicate for pKVM only -
> your 'Widen the scope of "protected" VMs' patch makes this restriction
> explicit to pKVM.
> 
> For the first one, if !kvm_slot_has_gmem(), it simply continues with the
> registration.
> 
>>> A subsequent private-IPA S2 fault sees the non-guest_memfd slot, takes
>>> user_mem_abort(), GUPs the user page and passes it to
>>> realm_map_protected(). The userspace mapping remains present, so a later
>>> EL0 access can generate a GPF.
>>
>> The Realm mem abort code should prevent this by ensuring that the
>> memslot is backed by gmem for private_faults. With the mandate of
>> in-place conversion, even the shared pages must come from the
>> gmem backed memslots.
> 
> IIUC this only works if the memslot is gmem but I can't see what
> prevents ordinary slots from being assigned to realms. I think we can
> enter the user_mem_abort() -> realm_map_ipa() for ordinary slots unless
> we prevent the deletion of the original slots and enforce gmem only
> slots early.


I had another look and we could handle this via 
kvm_fault_is_gmem_abort() see in arch/arm64/kvm/mmu.c:


diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 87e49251e0447..af5a4bf961aae 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1731,6 +1731,9 @@ static int gmem_abort(const struct 
kvm_s2_fault_desc *s2fd)
         gfn_t gfn;
         int ret;

+       if (!kvm_slot_has_gmem(s2fd->memslot))
+               return -EINVAL;
+
         if (!perm_fault) {
                 memcache = get_mmu_memcache(vcpu);
                 ret = topup_mmu_memcache(vcpu, memcache);
@@ -2277,10 +2280,12 @@ static bool private_ipa_fault(struct kvm *kvm, 
phys_addr_t fault_ipa);
  static bool kvm_fault_is_gmem_abort(struct kvm *kvm,
                                     const struct kvm_s2_fault_desc *s2fd)
  {
-       if (!kvm_slot_has_gmem(s2fd->memslot))
-               return false;
         if (kvm_memslot_is_gmem_only(s2fd->memslot))
                 return true;
+       /*
+        * For Realms, all private faults must be backed by GMEM.
+        * TODO: Handle Trusted device private memory mappings.
+        */
         if (private_ipa_fault(kvm, s2fd->fault_ipa))
                 return true;
         return false;




Also, I have the following hunk for preventing memslot modifications.
I will add this to v20 integration branch, which is almost ready ;-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 582b48e34486b..87e49251e0447 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2783,6 +2783,18 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
         }
  }

+static bool kvm_prevents_memslot_change(struct kvm *kvm, enum 
kvm_mr_change change)
+{
+       /* Cannot modify memslots once a pVM has run or Realm created */
+       if (change != KVM_MR_DELETE && change != KVM_MR_MOVE)
+               return false;
+
+       if ((kvm_vm_is_protected_pkvm(kvm) && 
pkvm_hyp_vm_is_created(kvm)) ||
+            kvm_realm_is_created(kvm))
+               return true;
+       return false;
+}
+
  int kvm_arch_prepare_memory_region(struct kvm *kvm,
                                    const struct kvm_memory_slot *old,
                                    struct kvm_memory_slot *new,
@@ -2791,12 +2803,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
         hva_t hva, reg_end;
         int ret = 0;

-       if (kvm_vm_is_protected_pkvm(kvm)) {
-               /* Cannot modify memslots once a pVM has run. */
-               if (pkvm_hyp_vm_is_created(kvm) &&
-                   (change == KVM_MR_DELETE || change == KVM_MR_MOVE)) {
+       if (kvm_vm_is_protected(kvm)) {
+               if (kvm_prevents_memslot_change(kvm, change))
                         return -EPERM;
-               }

                 if (new &&
                     new->flags & (KVM_MEM_LOG_DIRTY_PAGES | 
KVM_MEM_READONLY)) {
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index fc0297103f08b..6ec4e4487dff9 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -1596,6 +1596,7 @@ int kvm_activate_realm(struct kvm *kvm)
         if (kvm_realm_state(kvm) >= REALM_STATE_ACTIVE)
                 return 0;

+       guard(mutex)(&kvm->slots_lock);
         guard(mutex)(&kvm->arch.config_lock);
         /* Check again with the lock held */
         if (kvm_realm_state(kvm) >= REALM_STATE_ACTIVE)


Cheers
Suzuki

