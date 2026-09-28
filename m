Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9AC849D5AB;
	Mon, 28 Sep 2026 11:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790593290; cv=none; b=KGxUL4orwr3RkAsoj2Aj21QlidLH+y1BZh0r7Jjp8oibWrsSvknuUl0MdTp92nWBK22hfPyv+hLuMC2R6RMHz8uoYO5tNE7l30JcxIbPGs9SM1bNgHQU94iH1y7FMDaoe0qySb49xqkCfeGRHb+kh9V6tFftCCuBhnqyAAS+plU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790593290; c=relaxed/simple;
	bh=OPgOww627zD19BL+U//itmZv8dXx28KLUtom1uWHtxo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gAeYbr6EaqMtT5346y1Idnmn0CoyZS/eVshgzoC1xkapGfbwYkufOwa+vgRRybeXhUcXejief0+k3jv3g4sHnLapzC/R05AFHEXFovznWSGNfOkSz7zow1ozThtYUgAiJrpP6HR7JeX8PqrmccuMqiu0jACS9D3Cq+h4hf45BSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=tKg2YA0R; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="tKg2YA0R"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A3ED81595;
	Mon, 28 Sep 2026 04:01:19 -0700 (PDT)
Received: from [10.57.12.79] (unknown [10.57.12.79])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B95943F86F;
	Mon, 28 Sep 2026 04:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790593283; bh=OPgOww627zD19BL+U//itmZv8dXx28KLUtom1uWHtxo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tKg2YA0RHPuzdmRwV0lPGoDlgCUybqftje3GGS1BYH9CKtDCPS2NkvtEfCoAcTdbL
	 ggVP7QGb7VEoJkplTGJTVfZVKoE56b1IVaD/Hu4bXFFzuEw+HScrzYRvw5CHvILr8y
	 oMAmklYeDEboPJMEJeAx1kRbKYe4TFF0mFie7dms=
Message-ID: <4e315360-5b7a-4a0e-99c0-679a0271e625@arm.com>
Date: Mon, 28 Sep 2026 12:01:18 +0100
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

Hi Catalin

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

This needs to be tweaked for Realm to support non-secure device 
assignment. Aneesh reports that the Device assignment fails now,
because the Device BAR reset deletes the memory slot and re-registers
it, which the above change prevents.

I will modify that to
1. Prevent "Guest-memfd" backed memory slot deletion. Makes sure that
    nothing can replace a private memory slot.
2. Allow non-Guest-memfd backed memory slots to be created
   after the Realm is created. We anyways prevent "private" memory
   to be mapped from a non-Guest-memfd memslot.

Suzuki

