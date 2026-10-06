Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 830062C08BB;
	Tue,  6 Oct 2026 05:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791264163; cv=none; b=s95lnv/3IFnIET0p103ltY69pNBchzbQTVguMPvukWQysQjSjofc/asMyJ77is4aAzHZhtbBaUH6pbSBt7Apck6A0bagXA74Zn5KShCVh60ZJ6Xab3Cb99MMuETEyk3xHBD0KnNc40JEcBgBHc6SPT59AHKpqyr+DhHtSOrSTKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791264163; c=relaxed/simple;
	bh=apeCLqXJxkJ5C/oZWPqe1TVWMJV9KZcTBW5WHp1m2uM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ys5Uo7UcIfZ/66pigiJqUOcrCwYhhqrJa3/QF19gNbrP7qkbno2XC5ZhgXnG7rtlK6/wari8RCNuNl6Y5vUkzwhzGOHBNZqjSuv+1wZVKARJ31KXHPyh8r8LFQAIiG9eRyLdbOIN0w98AnBNop/UceDWK29W5oyW76p5OFYgsMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jhDL5/yg; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jhDL5/yg"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F5291595;
	Mon,  5 Oct 2026 22:22:37 -0700 (PDT)
Received: from [10.57.10.233] (unknown [10.57.10.233])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B53923F763;
	Mon,  5 Oct 2026 22:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791264160; bh=apeCLqXJxkJ5C/oZWPqe1TVWMJV9KZcTBW5WHp1m2uM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jhDL5/ygTyv6yWP4ZL/BapCmkZIE8zMHlQiG6ocX+igXTa/d+yjiNUbwkDPy48qap
	 kB+m7uZkt1BuScX5lKgbQX4sOC+1xQhADDebNfrG2e7wtZLSoRqn/ldMTEYQpWpipC
	 ynCoaL846E/qCZAadCt3E8LJWAmiun6ujqTEvSKI=
Message-ID: <c3cdfb9f-42b2-452e-a49c-32abe8e6f839@arm.com>
Date: Tue, 6 Oct 2026 07:22:35 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 11/23] KVM: arm64: Add VM specific callback for S2 MMU
 operations
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
 <20261005090754.2140522-12-suzuki.poulose@arm.com>
 <b6de5d5c-e7e5-4e24-abd6-bdea9bcf8db6@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <b6de5d5c-e7e5-4e24-abd6-bdea9bcf8db6@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 06/10/2026 04:00, Gavin Shan wrote:
> On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
>> Add VM type specific S2 MMU operation backends which can be 
>> initialized per
>> VM flavor, to keep the handling cleaner.
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>> Change since v21:
>>   - Define all vm_s2_ops call back. All calls are mandatory.
>>   - Define callback for each flavor, disjointing the non-protetcted 
>> pKVM and
>>     normal KVM (VHE & nVHE) and remove the KVM_PGT_FN() hacks.
>>   - Dropped Reviews due to the changes.
>>   - Add "no_age_gfn" and "no_stage2_unmap_range" for pKVM callbacks, 
>> no_age_*
>>     to be also reused by Realms later.
>>   - Move kvm_vm_s2_ops field to keep the structure packed

...

>>    */
>>   int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>>   {
>> -    if (is_protected_kvm_enabled())
>> -        kvm_call_hyp_nvhe(__pkvm_tlb_flush_vmid, kvm->arch.pkvm.handle);
>> -    else
>> -        kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
>> -    return 0;
>> +    return kvm->arch.vm_s2_ops->vm_flush_remote_tlbs(kvm);
>>   }
>> -int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
>> -                      gfn_t gfn, u64 nr_pages)
>> +static int pkvm_flush_remote_tlbs_range(struct kvm *kvm,
>> +                    gfn_t gfn, u64 nr_pages)
>> +{
>> +    return pkvm_flush_remote_tlbs(kvm);
> 
> No need to have another function call, which causes unnecessary overhead?
> 
>      kvm_call_hyp_nvhe(__pkvm_tlb_flush_vmid, kvm->arch.pkvm.handle);

Maybe, but that is in another way, telling the reader that pKVM can only
do full VM TLB flush, no range TLB flush.

>      return 0;
> 
>> +}
>> +
>> +static int kvm_vm_flush_remote_tlbs_range(struct kvm *kvm,
>> +                     gfn_t gfn, u64 nr_pages)
>>   {
>>       u64 size = nr_pages << PAGE_SHIFT;
>>       u64 addr = gfn << PAGE_SHIFT;
>> -    if (is_protected_kvm_enabled())
>> -        kvm_call_hyp_nvhe(__pkvm_tlb_flush_vmid, kvm->arch.pkvm.handle);
>> -    else
>> -        kvm_tlb_flush_vmid_range(&kvm->arch.mmu, addr, size);
>> +    kvm_tlb_flush_vmid_range(&kvm->arch.mmu, addr, size);
>>       return 0;
>>   }
>>
> 
> Since we're here, the local variable 'addr' and 'size' can be dropped by:
> 
>      kvm_tlb_flush_vmid_range(&kvm->arch.mmu,
>                                   gfn << PAGE_SHIFT,
>                                   nr_pages << PAGE_SHIFT);
> 

Does it really matter, the compiler can optimise this anyways and looks
more readable ?

> 
>> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
>> +                     gfn_t gfn, u64 nr_pages)
>> +{
>> +    return kvm->arch.vm_s2_ops->vm_flush_remote_tlbs_range(kvm, gfn, 
>> nr_pages);
>> +}
>> +

...

>> +static const struct kvm_vm_s2_ops kvm_default_vm_s2_ops = {
>> +    .vm_flush_remote_tlbs        = kvm_vm_flush_remote_tlbs,
>> +    .vm_flush_remote_tlbs_range    = kvm_vm_flush_remote_tlbs_range,
>> +    .vm_age_gfn            = kvm_vm_age_gfn,
>> +    .vm_test_age_gfn        = kvm_vm_test_age_gfn,
>> +    .vm_stage2_unmap_range        = kvm_vm_stage2_unmap_range,
>> +};
>> +
>> +#define KVM_VM_S2_OPS(flavor, ops)        \
>> +        [flavor] = &(ops)
> 
> s/[flavor]/[(flavor)]

Ack


Thanks !
Suzuki
