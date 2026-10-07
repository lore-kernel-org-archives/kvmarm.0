Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FA884248B1;
	Wed,  7 Oct 2026 08:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791363175; cv=none; b=KoQI+eeq/1JQqUD12LnqCNGp/NRJTmrzrKWxHMrYv60t39wq40iKWyT6Ph/3vUE8RT2R74eAdi5yGoGReMLUGu4Q54QoFskg8cPjcuKZFFWZDzOfmQrYduv33ic9iPDYHwUwVNh4xSlFDr7KaGC6ZAOItMF24eLr2bODzS6/mC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791363175; c=relaxed/simple;
	bh=fbAFs6PdZDs7wkzcASXComet5zETmBDkzcq/s+x9zTY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hNnfzpzQj10DfiblQtsJCLBXkNQYJ2JBjIyoZF3Yqa530EwyCtWGbGr5bjxbAo8+EeTPkJBv3LC0N7XE9LgZCoJNX8Z4XKtulGP/DdCUUc5seHBDUApGogwD+upNhj8aqzb0vpO79KQ4UozahDQM0Hw1Smibgs40hiouHWdLO+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=awkXBHjP; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="awkXBHjP"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 30974152B;
	Wed,  7 Oct 2026 01:52:48 -0700 (PDT)
Received: from [10.57.11.70] (unknown [10.57.11.70])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 776793F86F;
	Wed,  7 Oct 2026 01:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791363171; bh=fbAFs6PdZDs7wkzcASXComet5zETmBDkzcq/s+x9zTY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=awkXBHjPXC7A6fmHvGkqngM+Vy7PhjN6Qdwvph8Ze2c5cLs0gwmnIqixDMwRO7Dby
	 bZeDbB2004N+OisBknA/6lTAMx7fmDRqJimzLQW2sX9TKU/AXf9M/6kOVFQJjNvBWh
	 AIJqcC2gkLKBLZzcT81MYSvoNR8AdxZxVbapvWaY=
Message-ID: <6e7f8a1c-73e4-478e-9979-3c3cb01c2306@arm.com>
Date: Wed, 7 Oct 2026 10:52:48 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v23 09/14] KVM: arm64: Consolidate stage2 unmap range into
 kvm_stage2_unmap_range
Content-Language: en-GB
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, Fuad Tabba <tabba@google.com>
References: <20261007073537.2454351-1-suzuki.poulose@arm.com>
 <20261007073537.2454351-10-suzuki.poulose@arm.com>
 <sashiko-outbox-162730@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <sashiko-outbox-162730@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07/10/2026 08:49, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] kvm: arm64: UAF in stage2_apply_range() when nested_mmus is reallocated
> --
> 
> commit f49216e04631aee4e96534b9604d42f899f085d6
> Author: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> KVM: arm64: Consolidate stage2 unmap range into kvm_stage2_unmap_range
> 
> This patch simplifies the stage-2 unmap operations by removing
> __unmap_stage2_range() and folding its logic directly into
> kvm_stage2_unmap_range(). It also updates callers to use the consolidated
> function.
> 
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 9ba86450fe4af..3fef16393f568 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -314,36 +314,30 @@ static void invalidate_icache_guest_page(void *va, size_t size)
> [ ... ]
>> -static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size,
>> -				 bool may_block)
>> +void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
>> +			    u64 size, bool may_block)
>>   {
>>   	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>> -	phys_addr_t end = start + size;
>> +
>> +	if (kvm_vm_is_protected(kvm))
>> +		return;
>>   
>>   	lockdep_assert_held_write(&kvm->mmu_lock);
>>   	WARN_ON(size & ~PAGE_MASK);
>> -	WARN_ON(stage2_apply_range(mmu, start, end, KVM_PGT_FN(kvm_pgtable_stage2_unmap),
>> -				   may_block));
>> -}
>>   
>> -void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
>> -			    u64 size, bool may_block)
>> -{
>> -	if (kvm_vm_is_protected(kvm_s2_mmu_to_kvm(mmu)))
>> -		return;
>> -
>> -	__unmap_stage2_range(mmu, start, size, may_block);
>> +	WARN_ON(stage2_apply_range(mmu, start, start + size,
>> +				   KVM_PGT_FN(kvm_pgtable_stage2_unmap),
>> +				   may_block));
> 
> [Severity: High]
> Does this allow a use-after-free of the kvm->arch.nested_mmus array if
> may_block is true?
> 
> If kvm_nested_s2_unmap() is called during a memory reclaim event via
> kvm_mmu_notifier_invalidate_range_start(), it caches a pointer to an
> element of kvm->arch.nested_mmus (e.g., mmu = &kvm->arch.nested_mmus[i])
> and passes it here with may_block=true.
> 
> When stage2_apply_range() iterates, it can drop kvm->mmu_lock via
> cond_resched_rwlock_write():
> 
> stage2_apply_range() {
> 	do {
> 		struct kvm_pgtable *pgt = mmu->pgt;
> 		...
> 		if (resched && next != end)
> 			cond_resched_rwlock_write(&kvm->mmu_lock);
> 	} while (addr = next, addr != end);
> }
> 
> Concurrently, could userspace initializing a new vCPU via KVM_ARM_VCPU_INIT
> invoke kvm_vcpu_init_nested(), grab kvm->mmu_lock, reallocate the
> kvm->arch.nested_mmus array, and free the old one?
> 
> kvm_vcpu_init_nested() {
> 	...
> 	swap(kvm->arch.nested_mmus, tmp);
> 	write_unlock(&kvm->mmu_lock);
> 	kvfree(tmp);
> }
> 
> If stage2_apply_range() then reacquires the lock, it would dereference
> mmu->pgt using the mmu pointer that still points into the now-freed
> nested_mmus array.
> 
> Can we ensure the array is not freed while we iterate, or refresh the mmu
> pointer after reacquiring the lock?

This is a pre-existing issue and has been fixed in v7.3-rc5.

commit 33346f8960c7 ("KVM: arm64: nv: Fix life cycle of the nested_mmus 
array")

Suzuki

> 
>>   }
> 

