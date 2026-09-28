Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7405835C69F;
	Mon, 28 Sep 2026 08:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790583058; cv=none; b=tYZp3nP7d8rEejho0gZ1ir3rIJt5N8FoGhWHVd18VZ6wmMdyI49HRKLfbWzFGCUVF5Ks1pdH3R3ddLBFb632fsCWllTZGdh8TSZg7uL4lzpRwUyCEBF5TyUMEvWvRhHCJyMmsTmRr5Vl3DK7f4mZaLqBdM7fGmQamlFzdpXjALg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790583058; c=relaxed/simple;
	bh=iX0JHr3OaK1F907tUkdtLXi8iMAHjfLYQ9uHjk2hIIQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o536s8T2zeRzyI0W6ufWKxil6lKowu6YfHU84Gf8s30vavZr/jDanmrvc4ec2H6dYnqGBMVkQxVsB2xMfnZ7uf+yrImTXVurT91/duxc57GTtFjsXsK3X58DEcIrAD5g+7XTp5CAw9RhT4FhoflF7JUfUH72jMsQngWrfeBg/AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ItMPqOto; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ItMPqOto"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4BAE01570;
	Mon, 28 Sep 2026 01:10:50 -0700 (PDT)
Received: from [10.57.12.79] (unknown [10.57.12.79])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D5A2C3F86F;
	Mon, 28 Sep 2026 01:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790583053; bh=iX0JHr3OaK1F907tUkdtLXi8iMAHjfLYQ9uHjk2hIIQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ItMPqOtowS0ZHlYRac5WKIgJ9uZtyWAWWq3/qzMaPipTg35S8D4i59hxkFzWQ0PAZ
	 MY0/f8DdQORcc2licSIabU2dBhHPp3dzpUT5etsrc/ndkO6ywv+1PRsBkvsMtYTQsJ
	 23fq3M4L2W07KsDbGcAExLWRwXfeOQKulXsWeHms=
Message-ID: <01361954-ad51-46ec-a9a1-89413fbb6084@arm.com>
Date: Mon, 28 Sep 2026 09:10:48 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 09/20] KVM: arm64: Add VM specific callback for S2 MMU
 operations
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260920212845.707-1-suzuki.poulose@arm.com>
 <20260920212845.707-10-suzuki.poulose@arm.com>
 <647ae455-4175-4070-a40e-d2d89f18971f@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <647ae455-4175-4070-a40e-d2d89f18971f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 28/09/2026 02:09, Gavin Shan wrote:
> On 9/21/26 7:28 AM, Suzuki K Poulose wrote:
>> Add VM type specific S2 MMU operation backends which can be 
>> initialized per
>> VM flavor, to keep the handling cleaner.
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   arch/arm64/include/asm/kvm_host.h |  15 ++++
>>   arch/arm64/kvm/mmu.c              | 137 +++++++++++++++++++++++++-----
>>   2 files changed, 131 insertions(+), 21 deletions(-)
>>
> 
> Apart from the comments from Jonathan, some nitpicks and questions below.
> 
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/ 
>> asm/kvm_host.h
>> index 149f4582c8b6a..7664d8b8cce5a 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -155,6 +155,19 @@ struct kvm_vcpu_ops {
>>       void (*vcpu_put)(struct kvm_vcpu *vcpu);
>>   };
>> +struct kvm_gfn_range;
>> +
>> +struct kvm_vm_s2_ops {
>> +    bool (*vm_age_gfn)(struct kvm *kvm, struct kvm_gfn_range *range);
>> +    bool (*vm_test_age_gfn)(struct kvm *kvm, struct kvm_gfn_range 
>> *range);
>> +    int (*vm_flush_remote_tlbs)(struct kvm *kvm);

...

>> @@ -166,6 +168,18 @@ static bool memslot_is_logging(struct 
>> kvm_memory_slot *memslot)
>>       return memslot->dirty_bitmap && !(memslot->flags & 
>> KVM_MEM_READONLY);
>>   }
>> +static int pkvm_flush_remote_tlbs(struct kvm *kvm)
>> +{
>> +    kvm_call_hyp_nvhe(__pkvm_tlb_flush_vmid, kvm->arch.pkvm.handle);
>> +    return 0;
>> +}
>> +
>> +static int kvm_vm_flush_remote_tlbs(struct kvm *kvm)
>> +{
>> +    kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
>> +    return 0;
>> +}
>> +
>>   /**
>>    * kvm_arch_flush_remote_tlbs() - flush all VM TLB entries for v7/8
>>    * @kvm:    pointer to kvm structure.
>> @@ -174,26 +188,36 @@ static bool memslot_is_logging(struct 
>> kvm_memory_slot *memslot)
>>    */
>>   int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>>   {
>> -    if (is_protected_kvm_enabled())
>> -        kvm_call_hyp_nvhe(__pkvm_tlb_flush_vmid, kvm->arch.pkvm.handle);
>> -    else
>> -        kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
>> -    return 0;
>> +    if (!kvm->arch.vm_s2_ops->vm_flush_remote_tlbs)
>> +        return 1;
> 
> For the return value, I'm wandering if 0 should be returned. More details
> can be found below.

Answered below.

> 

...

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
>> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
>> +                     gfn_t gfn, u64 nr_pages)
>> +{
>> +    if (!kvm->arch.vm_s2_ops->vm_flush_remote_tlbs_range)
>> +        return 1;
>> +
> 
> Realm would the only case where vm_s2_ops->vm_flush_remote_{tlbs, 
> tlbs_range) 
> are NULL. On request to flush remote TLBs by 
> kvm_flush_remote_tlbs_range(), it
> ends up with event KVM_REQ_TLB_FLUSH queued for each vCPU. How this 
> queued event
> is linked to a remote TLB flush for realm? The problem is TLBs are owned 
> by EL2
> realm and there are no RMI calls for the management. So I'm wandering we 
> should
> return 0 here?

Please note that, the Realm s2 callbacks are not NULL for 
flush_remote_tlb*. They all return 0, indicating that everything
is taken care of. (See Patch 14/20: KVM: arm64: CCA: Add bare minimal S2 
operations for Realm)
...

>> +
>> +#define KVM_VM_S2_OPS(flavor, ops)        \
>> +        [flavor] = ops
> 
> Parentheses are needed, to be consistent with KVM_VCPU_OPS at least.
> 
> #define KVM_VM_S2_OPS(flavor, ops)        \
>          [(flavor)] = (ops)
> 

Ack


> Actually, KVM_{VCPU, VM_S2}_OPS() can be combined to one in kvm_host.h 
> as below.
> 
> #define KVM_FLAVOR_OPS() [(flavor)] = (ops)

I would leave it as they are to avoid confusion.

Cheers
Suzuki


