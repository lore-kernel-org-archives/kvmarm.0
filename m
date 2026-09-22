Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B9E39DBC9;
	Tue, 22 Sep 2026 15:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790090102; cv=none; b=OmcdX86wVEC0GNRbu7hwWKeOODxQQiQ9E32V5uUj3QFvohFQtDasJfTK/64m4BACG1pji33oSP7RMM0eMzOpWCCqySrhL3bOkFVS7Eeump/gkd70dRSWvYVL8c10HlNHwbAg18j9KD/8ReaZYpe5RCpNA1+R33qbgOWsCpsv8fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790090102; c=relaxed/simple;
	bh=qfLhNMxLDQamnRL3jBZjojzJCuPyPkvcYSCFDpX/jF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E1lCWVouMDRmkiT/u4dJXHEt4KVbeuIlGOiGQ/CV794MI24MzL+3hwsTk9mWcH1HrlKNjdTz59PeiQG9FajJ5skhhIlofHbLyaMOmBjM5yGxb64RoCEVCHa5Si/63wPmuCnCEAKMox1RVBTewowjCjNCMbUDqiDXvMv8i1uyC9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=id03qeF4; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="id03qeF4"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D06C41576;
	Tue, 22 Sep 2026 08:14:55 -0700 (PDT)
Received: from [10.57.9.253] (unknown [10.57.9.253])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 778833F86F;
	Tue, 22 Sep 2026 08:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790090099; bh=qfLhNMxLDQamnRL3jBZjojzJCuPyPkvcYSCFDpX/jF8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=id03qeF4VWrD2FyYassCVvtscxdW55gRzwGJdpvJgtyiQ3TdEIEUt2WyO0ePxhU9Y
	 a0+jXmaJ6rch0a6KggX/v5JwO/mQ+8LlpGzR+8c3+f5YGW2Ev3f+HJI9gRU3IdaDPz
	 2wjKveDSTNbtxF9X/+0KOXnvUQJF2YXWpFvlcBww=
Message-ID: <359c7adb-e18e-423d-a5a1-6031eb17e421@arm.com>
Date: Tue, 22 Sep 2026 16:14:54 +0100
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
 <arKVcjCOJf8p9rWL@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <arKVcjCOJf8p9rWL@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/09/2026 15:49, Catalin Marinas wrote:
> On Tue, Sep 22, 2026 at 02:21:13PM +0100, Suzuki K Poulose wrote:
>> I had another look and we could handle this via kvm_fault_is_gmem_abort()
>> see in arch/arm64/kvm/mmu.c:
>>
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 87e49251e0447..af5a4bf961aae 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1731,6 +1731,9 @@ static int gmem_abort(const struct kvm_s2_fault_desc
>> *s2fd)
>>          gfn_t gfn;
>>          int ret;
>>
>> +       if (!kvm_slot_has_gmem(s2fd->memslot))
>> +               return -EINVAL;
> 
> I wonder whether we should add a KVM_BUG_ON() here. With the rest of the
> changes, we should never get in this situation. Well, to be revisited
> for private devices.

Sure, I could add that

> 
> Also maybe move it to the caller, kvm_vm_mem_abort(), and not change
> kvm_fault_is_gmem_abort(). Something like:
> 
> 	if (private_ipa_fault(kvm, s2fd->fault_ipa) &&
> 	    KVM_BUG_ON(!kvm_slot_has_gmem(s2fd->memslot), kvm))
> 		return -EIO;
> 
> To me it makes more sense for gmem_abort() to be called only *if* it's a
> gmem slot. So any inconsistency, avoiding user_mem_abort() for private
> memory, should be done in the caller. I assume the caller will also have
> to route the private device path as well rather than rely on
> gmem_abort().

Agree.

> 
>> +
>>          if (!perm_fault) {
>>                  memcache = get_mmu_memcache(vcpu);
>>                  ret = topup_mmu_memcache(vcpu, memcache);
>> @@ -2277,10 +2280,12 @@ static bool private_ipa_fault(struct kvm *kvm,
>> phys_addr_t fault_ipa);
>>   static bool kvm_fault_is_gmem_abort(struct kvm *kvm,
>>                                      const struct kvm_s2_fault_desc *s2fd)
>>   {
>> -       if (!kvm_slot_has_gmem(s2fd->memslot))
>> -               return false;
>>          if (kvm_memslot_is_gmem_only(s2fd->memslot))
>>                  return true;
>> +       /*
>> +        * For Realms, all private faults must be backed by GMEM.
>> +        * TODO: Handle Trusted device private memory mappings.
>> +        */
>>          if (private_ipa_fault(kvm, s2fd->fault_ipa))
>>                  return true;
>>          return false;
>>
>>
>> Also, I have the following hunk for preventing memslot modifications.
>> I will add this to v20 integration branch, which is almost ready ;-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 582b48e34486b..87e49251e0447 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -2783,6 +2783,18 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>>          }
>>   }
>>
>> +static bool kvm_prevents_memslot_change(struct kvm *kvm, enum kvm_mr_change change)
>> +{
>> +       /* Cannot modify memslots once a pVM has run or Realm created */
>> +       if (change != KVM_MR_DELETE && change != KVM_MR_MOVE)
>> +               return false;
>> +
>> +       if ((kvm_vm_is_protected_pkvm(kvm) && pkvm_hyp_vm_is_created(kvm)) ||
>> +            kvm_realm_is_created(kvm))
>> +               return true;
>> +       return false;
>> +}
>> +
>>   int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>                                     const struct kvm_memory_slot *old,
>>                                     struct kvm_memory_slot *new,
>> @@ -2791,12 +2803,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>          hva_t hva, reg_end;
>>          int ret = 0;
>>
>> -       if (kvm_vm_is_protected_pkvm(kvm)) {
>> -               /* Cannot modify memslots once a pVM has run. */
>> -               if (pkvm_hyp_vm_is_created(kvm) &&
>> -                   (change == KVM_MR_DELETE || change == KVM_MR_MOVE)) {
>> +       if (kvm_vm_is_protected(kvm)) {
>> +               if (kvm_prevents_memslot_change(kvm, change))
>>                          return -EPERM;
>> -               }
>>
>>                  if (new &&
>>                      new->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)) {
> 
> I think this should work.

Cheers
Suzuki

> 
> Thanks.
> 

