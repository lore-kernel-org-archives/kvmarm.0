Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625190;
	b=G/+qoBdL0BNwPpNrqTQe+wyTCt/krc6D3K9VlYIWb3vSxxTr3D0DYuacFdV7eo5TLILu
	 t9zEo7WKfBf1M5vz1MECmVSEORaWDN1qhMoGNxeYzPfuEPomJaMs1k8oIdFjVvEVeFQuS
	 AfdmtfaCCOznZK/PfkM7ITjlMZABzQgsUGC8LxuiM9N/b6agDMb2Y+NmSMAc1ajnYbMV7
	 yGG/6AiA4pTnzns0T5QHI+VtKGPbjeL3BM9CD4Pz0Nkz1gXPtezbOV5RLxJp0l+tSi+XS
	 YpwJ5tZBb2VkCI5DuCV72qmN8FquPTTXmWmxIju7coMFqEt5meVUsm6XUsC5H61iiSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625190;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=KjZjsUyQFxsQPQHTHpl//Z+vqIh/wjMAMwg9CITWqr4=;
	b=qdoR/4IohYPXjAO/m16Bv6ByVlHzPEXDLRNhrk6eIi++uCCwb/aDKuN371rxDwuLNUPK
	 Ywv5EmbHsh1bu6342UxC+wFI07BInoIRTqZHt+M4Ao+2CGyvVBv7p2zAY72zS1LEDOAT9
	 BhFh6BhCK7dndMN8ODCyMJ3EX8KERx4B75quoEQFkyUFx2F2KmdcJFod3WABBMpKMQwcS
	 iMb/ivC8G29hdGxyyvuYoXIJOAEXEICmyhq7fwqMWlOuclWV16apfIw9vNxyC+O6AwynC
	 tWLbUpZDKhTRMABdNpdiOXUekzlYDZC0Dfg1FMLuUBgU1IkTiFhYWOrUTbqxtID0eEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Z8oFofyY;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BFA2606A31E;
	Wed, 25 Nov 2026 16:46:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BFA2606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Z8oFofyY
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A20D62F;
	Wed, 25 Nov 2026 08:46:25 -0800 (PST)
Received: from [10.57.32.107] (unknown [10.57.32.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 20FF43F632;
	Wed, 25 Nov 2026 08:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795625188; bh=0V2D5frrfjhwHE0XTZXrjncSxje69gb1mbxFSvIW8Xc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Z8oFofyYEh6F687QC/inqQz6EufsmT79XE/zqyznkNonMgsPdVs0MXG1/5JXezaL3
	 AXcacMGW+QTBh0EEq/tVAt9oYNuEZ/x2dSgNdo04S+pR6Gk8Vj4vuvgjRv8YgIJHto
	 RH09EEGj3FWGlFpS+CIv3zxZzRumCkfIHOoYKQzY=
Message-ID: <23d35fa6-721c-44c9-b092-099dbd005b96@arm.com>
Date: Wed, 25 Nov 2026 16:46:24 +0000
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
Subject: Re: [PATCH v4 07/11] KVM: arm64: CCA: Add Realm RTT mapping and
 invalidation helpers
To: sashiko-reviews@lists.linux.dev, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261123104233.95710-1-steven.price@arm.com>
 <20261123104233.95710-8-steven.price@arm.com>
 <sashiko-outbox-229102@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <sashiko-outbox-229102@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 23/11/2026 11:12, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential
> issues to consider:
> - [Medium] KVM: arm64: cca: direct-reclaim allocation in
>   realm_unmap_cache_topup()
> - [Medium] KVM: arm64: cca: stale err_level used after
>   realm_unmap_cache_topup() failure
> - [Low] KVM: arm64: cca: possible RTT creation for unmapped entry in
>   realm_unmap_*()
> --
> 
> commit 4c7e030072ac67c12f0f2603fad3d39821c47426
> Author: Steven Price <steven.price@arm.com>
> 
> KVM: arm64: CCA: Add Realm RTT mapping and invalidation helpers
> 
> This commit adds RMI Realm Translation Table creation, folding, and stage-2
> unmapping helpers for CCA Realms, including filtered range unmapping for
> shared and private memory.
> 
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index 435174ac3d87f..b34f5320b50b6 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
> 
> [ ... ]
> 
>> @@ -172,6 +391,208 @@ void kvm_realm_unmap_stage2_all(struct kvm *kvm)
>>  	realm->stage2_unmapped = true;
>>  }
>>  
>> +static bool realm_unmap_cache_topup(struct kvm *kvm,
>> +				    struct kvm_mmu_memory_cache *mc, int needed)
>> +{
>> +	int ret;
>> +
>> +	if (!mc || kvm_mmu_memory_cache_nr_free_objects(mc) >= needed)
>> +		return false;
>> +
>> +	lockdep_assert_held_write(&kvm->mmu_lock);
>> +	write_unlock(&kvm->mmu_lock);
>> +	ret = __kvm_mmu_topup_memory_cache(mc, KVM_PGTABLE_LAST_LEVEL, needed);
>> +	write_lock(&kvm->mmu_lock);
>> +
>> +	return !ret;
>> +}
> 
> [Severity: Medium]
> When __kvm_mmu_topup_memory_cache() fails, does returning false cause
> realm_unmap_shared_range() and realm_unmap_private_range() to pass a stale
> err_level to realm_create_rtt_levels()?
> 
> Because kvm->mmu_lock was dropped and re-acquired, another thread can fold
> the RTT at err_level before the lock is retaken.  The callers only retry
> from addr when realm_unmap_cache_topup() returns true; on failure they fall
> through to realm_create_rtt_levels(realm, addr, err_level, level, mc).
> alloc_rtt() can still succeed from a partially topped-up cache or via
> alloc_delegated_granule()'s GFP_ATOMIC fallback (which sets __GFP_HIGH and
> force-charges memcg), causing realm_rtt_create() at err_level + 1 to fail
> with RMI_ERROR_RTT at an ancestor level < err_level.  That triggers the
> WARN() in realm_create_rtt_levels() and returns -ENXIO, hitting
> WARN_ON(ret != -ENOMEM) in realm_unmap_shared_range() or KVM_BUG_ON(1, kvm)
> in realm_unmap_private_range().
> 
>> +static void realm_unmap_shared_range(struct kvm *kvm,
>> +				     unsigned long start,
>> +				     unsigned long end,
>> +				     bool may_block,
>> +				     struct kvm_mmu_memory_cache *mc)
>> +{
>> +	struct realm *realm = &kvm->arch.realm;
>> +	unsigned long rd = realm->rd_phys;
>> +	unsigned long next_addr, addr;
>> +	unsigned long shared_bit = BIT(realm->ia_bits - 1);
>> +
>> +	if (start >= end)
>> +		return;
>> +
>> +	/*
>> +	 * Callers may pass either an IPA range or its shared alias. Add the
>> +	 * shared bit only for the former. Use addition so an exclusive end at
>> +	 * shared_bit advances to the end of the IPA space.
>> +	 */
>> +	if (start < shared_bit) {
>> +		start += shared_bit;
>> +		end += shared_bit;
>> +	}
>> +
>> +	for (addr = start; addr < end; addr = next_addr) {
>> +		long ret;
>> +
>> +		ret = rmi_rtt_unprot_unmap(rd, addr, end, RMI_ADDR_TYPE_NONE,
>> +					   0, &next_addr, NULL, NULL);
>> +		if (WARN_ON(ret < 0))
>> +			return;
>> +
>> +		switch (RMI_RESULT_STATUS(ret)) {
>> +		case RMI_SUCCESS:
>> +			break;
>> +		case RMI_ERROR_RTT: {
>> +			int err_level = RMI_RESULT_DATA_LEVEL(ret);
>> +			int level = find_map_level(realm, addr, end);
>> +
>> +			if (WARN_ON(err_level < realm->start_level ||
>> +				    err_level > KVM_PGTABLE_LAST_LEVEL))
>> +				return;
>> +
>> +			if (err_level >= level) {
>> +				/* Nothing present, so skip */
>> +				next_addr = ALIGN(addr + 1,
>> +						  kvm_granule_size(err_level));
>> +				break;
>> +			}
> 
> [Severity: Low]
> This question rests on an RMM architectural detail that could not be
> confirmed from the kernel source: can SMC_RMI_RTT_UNPROT_UNMAP or
> SMC_RMI_RTT_DATA_UNMAP return RMI_ERROR_RTT with err_level < level when the
> RTT walk stops at an unassigned ancestor entry (where neither a child RTT
> nor a block mapping is present at err_level), rather than advancing
> next_addr and returning RMI_SUCCESS?
> 
> If so, when unmapping a sub-block range (such as a single page, where
> find_map_level() returns KVM_PGTABLE_LAST_LEVEL) across an unmapped ancestor
> entry, both realm_unmap_shared_range() and realm_unmap_private_range() only
> skip when err_level >= level.  For err_level < level, they treat the entry
> as a block mapping to split, allocating and delegating intermediate RTTs via
> realm_create_rtt_levels() only to fold them back at the end of the function,
> and if that allocation fails in realm_unmap_private_range() (for example
> under GFP_ATOMIC when may_block is false), it hits KVM_BUG_ON(1, kvm) even
> though nothing was mapped.
> 
> [ ... ]
> 
>> +void kvm_realm_unmap_range_filter(struct kvm *kvm, unsigned long start,
>> +				  unsigned long size, bool may_block,
>> +				  enum kvm_gfn_range_filter attr_filter)
>> +{
>> +	/*
>> +	 * MMU notifier callbacks cannot take slots_lock, which protects the
>> +	 * eager split cache. Use a cache owned by this invalidation instead.
>> +	 */
>> +	struct kvm_mmu_memory_cache cache = { .gfp_zero = __GFP_ZERO };
> 
> [Severity: Medium]
> Can topping up this cache from an MMU notifier callback enter direct reclaim
> and trigger a lockdep splat on __mmu_notifier_invalidate_range_start_map?
> 
> When mmu_notifier_invalidate_range_start() invokes
> kvm_mmu_notifier_invalidate_range_start() -> ... ->
> kvm_realm_unmap_range_filter() with may_block set, it holds
> __mmu_notifier_invalidate_range_start_map.  Because cache.gfp_custom is left
> at 0, realm_unmap_cache_topup() -> __kvm_mmu_topup_memory_cache() allocates
> with GFP_KERNEL_ACCOUNT (__GFP_DIRECT_RECLAIM | __GFP_FS), which enters
> fs_reclaim_acquire() and acquires __mmu_notifier_invalidate_range_start_map
> recursively (and risks reclaim recursion deadlock under memory pressure).
> Setting cache.gfp_custom to GFP_NOWAIT | __GFP_ACCOUNT avoids direct reclaim
> in the notifier path.
> 

Using GFP_NOWAIT doesn't sound a great idea. But this is actually only
an issue for the shared mappings. Protected mappings shouldn't be
triggering the mmu_notifiers because the memory is from the guest memfd.
For shared memory we can always fall back on unmapping too much, so
there's no real need to deal with the memcache.

I'll try to rework this for the next revision.

Thanks,
Steve

