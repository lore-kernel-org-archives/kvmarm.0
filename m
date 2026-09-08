Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE3FD5A0ACD;
	Tue,  8 Sep 2026 18:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788893983; cv=none; b=tUaqcXdsCvJQjFAVRPOC1j8YK/9NRnWR9BAeUGHxZ9PlNSRZV7zMH5wDLDW0YZeABXCU/GEwtqwDcslWx1xB7rSkkxLQCOvZVpQskoWxggaWimAwIl78g/4+Buy11d1UzepGcB803SOIYSsKPHPxyY1ZWEMgmFqGu/WKCDpCMnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788893983; c=relaxed/simple;
	bh=Tc9JHX4hqoWOLLQX7k0goxvIf3i5xPJlcUGqwkfM6Eg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PalmqaKqQ4kcJxyxvjsV24vsQE9yzTdJsu6QXOqCKEmj5gMPErfZCNXQgq3V9JngQ3IZkwhXu0PbwhWrKXWjSbIE4cqq5TxAF44Q0NMgDVt1bHmGDsyI9XMO9BMfzudfMheYJTM1yL7gTZKt7GSf5+h5xHYRjVy4Gmh1gQ8uYWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=V3xAfywi; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="V3xAfywi"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 703BF1476;
	Tue,  8 Sep 2026 11:59:36 -0700 (PDT)
Received: from [10.57.49.201] (unknown [10.57.49.201])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 639673F528;
	Tue,  8 Sep 2026 11:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788893980; bh=Tc9JHX4hqoWOLLQX7k0goxvIf3i5xPJlcUGqwkfM6Eg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V3xAfywiOY1K7owUgQ1fIoGPe9oQO9hu5w7NivPA0xrTLaPgJszI6BrhSeftwG0ZW
	 Jprd+f1mD0ir1X24iWayTxIK1nTh8PuDtjYO3Gq0OH8ixwXfv5mP0nsvgw/9mtsNjB
	 GaFBaLmKeigdQ/4TY6/xrZ0CEQCnVItPag7mWxz4=
Message-ID: <966de615-1349-43d4-b944-c36eab020e85@arm.com>
Date: Tue, 8 Sep 2026 19:59:37 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 19/20] KVM: arm64: Add VM specific callback for S2 MMU
 operations
Content-Language: en-GB
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 Oliver Upton <oupton@kernel.org>, kvm@vger.kernel.org
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-20-suzuki.poulose@arm.com>
 <20260908165930.561841F00A3A@smtp.kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260908165930.561841F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08/09/2026 17:59, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [Critical] Mismatch between forward declarations and definitions of pKVM S2 MMU operations structs causes KVM to silently skip critical memory management and TLB flush operations.
> - [High] `kvm_arch_flush_remote_tlbs_range` incorrectly returns 0 when the callback is NULL, bypassing the full TLB flush fallback mechanism.
> - [Low] The `type` parameter in `kvm_vm_init_vm_s2_ops` is entirely unused.
> --
> 
> commit 31d5dcbadc8339bf6a74dc7f2dc04dbc627760d7
> Author: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> KVM: arm64: Add VM specific callback for S2 MMU operations
> 
> Add VM type specific S2 MMU operation backends which can be initialized per VM
> flavor, to keep the handling cleaner.
> 
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 67852acf7a6f8..e78a56fb73696 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
> [ ... ]
>> @@ -174,26 +190,36 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
> [ ... ]
>> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
>> +				     gfn_t gfn, u64 nr_pages)
>> +{
>> +	if (!kvm->arch.vm_s2_ops->vm_flush_remote_tlbs_range)
>> +		return 0;
> 
> [Severity: High]
> Should this return an error code like -EOPNOTSUPP instead of 0?
> 
> By returning 0 (success) when the callback is NULL, the core KVM
> implementation in kvm_flush_remote_tlbs_range() will assume the flush
> was successful and skip the fallback to a full TLB flush
> (kvm_flush_remote_tlbs). This regression can lead to stale TLB entries
> if a VM flavor explicitly omits the range callback.
> 
>> +
>> +	return kvm->arch.vm_s2_ops->vm_flush_remote_tlbs_range(kvm, gfn, nr_pages);
>> +}
> [ ... ]
>> @@ -963,6 +996,18 @@ static void kvm_stage2_destroy(struct kvm_pgtable *pgt)
>>   	KVM_PGT_FN(kvm_pgtable_stage2_destroy_pgd)(pgt);
>>   }
>>   
>> +static const struct kvm_vm_s2_ops *arm64_vm_s2_ops[VM_FLAVOR_MAX] = {
>> +	[VM_VHE] = &kvm_default_vm_s2_ops,
>> +	[VM_NVHE] = &kvm_default_vm_s2_ops,
>> +	[VM_PKVM] = &unprotected_pkvm_s2_ops,
>> +	[VM_PROTECTED_PKVM] = &protected_pkvm_s2_ops,
>> +};
> 
> [Severity: Critical]
> Is there a mismatch in the struct names for the pKVM operations?
> 
> This array uses unprotected_pkvm_s2_ops and protected_pkvm_s2_ops,
> but the actual populated structs defined at the end of this file are
> named pkvm_vm_s2_ops and protected_vm_s2_ops.
> 
> Because of this mismatch, the array points to the zero-initialized
> tentative definitions instead of the populated ones, meaning all function
> pointers for pKVM guests will be silently NULL. This skips operations like
> stage-2 unmapping, which could lead to stale TLBs and unmapped host memory
> access.
> 

Thanks, that is indeed a terrible mistake from my end. I have now fixed 
this up cleanly.

>> +
>> +static void kvm_vm_init_vm_s2_ops(struct kvm *kvm, unsigned long type)
>> +{
>> +	kvm->arch.vm_s2_ops = arm64_vm_s2_ops[kvm->arch.vm_flavor];
>> +}
> 
> [Severity: Low]
> Is the type parameter intentionally ignored here?

I will drop this, left over from the rebase :-(

> 
> The function is passed type from kvm_init_stage2_mmu() but directly queries
> kvm->arch.vm_flavor instead, leaving the parameter entirely unused.
> 

Cheers
Suzuki


