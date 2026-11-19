Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795101958;
	b=ANgTlI6Lx7+yunVY5E1czXh6VxLjNDdvFaU+SOz+dPt5WoK/l7HisE/rLpKeQw9MGuga
	 zVzBeo9L/1CYlP7qNnsL8FVtN3iTtVivLMfK/32/ggjvMkbOyym7RlDT5nHE6YMtVi1rs
	 F5lOOr5tXnKn6z4lcYODgt4WDpfqqdVYMAkcNysRn6iX3nd1VuxeYRTZsHblQpfRKOASS
	 PyYMVUlJFA2ap3xRHDzxc4RExtvLrbxXHeA2GmASg7q4/qP1xRHGdzS36gXFVxBDh0+5V
	 gU7vW+nZeJpjwJHbbAFYKXjAeTsvelyD6+Ngq7+T0p4E6PaFf+v87gYGEZbt9BrmQJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795101958;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=zdB2fPtL2z7ZG6LCXpPbQvhRXPEXVT2iZIQyInkp3MU=;
	b=ajKoU+GO8UPEEui0qdbDzErqYwvphFHv8Eg2yN8kpTFd2oE4YqrJG9SH2F3fvAxB5aAw
	 tzx7DikzFRyfYTOTzoa9zLd7kJKSG7c0k2DwOIZEHRbNLuYKXgfv1N5NyWpfQ7LxwDVID
	 5ju25Oo6093rR603JFKzBxFggoUYki6xtKTTXcird+jtJyPR8hPcv5ZDKvJ9axKjSJYyU
	 cWXMO3qQqV0Cl9G9qDnSqfBXCA+AEVvoRwsC/RmJyB2s0ZXkV8rpoisSLyTnW8UzBYxAF
	 Lrkvc4o2eSq5Jzw8ia+Tl9teBNguqZt2naaqIWkugokpx0cS6hZnCSSsH5KyQ0eMlTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="DH8BaBb/";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC8BA606A325;
	Thu, 19 Nov 2026 15:25:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC8BA606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=DH8BaBb/
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 761591575;
	Thu, 19 Nov 2026 07:25:54 -0800 (PST)
Received: from [10.0.129.37] (e122027.cambridge.arm.com [10.0.129.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AA5633F882;
	Thu, 19 Nov 2026 07:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795101957; bh=L8AM1088GXZp/KUuwOmJHtuk4LM/8kxdRfiw72oFviw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DH8BaBb//yLeBr2dmfTFqY2aimtfu4bNYokOLjm0EYWZ/gI/t4YS7vcWCodD6wvw4
	 bkUybIOFHqUe9l9oMSaiGQGxZ1UU+EayJjNDyVPfSwy87x6C9AJVSQyCuVf9MJbRsH
	 D/m9URoICxgF1J1ZDBBUwarfFfsKqOR8wh2lNpso=
Message-ID: <1715c8bd-3738-4d1a-9d22-0abbdd688e4c@arm.com>
Date: Thu, 19 Nov 2026 15:25:53 +0000
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
Subject: Re: [PATCH v3 06/11] KVM: arm64: CCA: Add Realm RTT mapping and
 invalidation helpers
To: sashiko-reviews@lists.linux.dev, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261116164358.142785-1-steven.price@arm.com>
 <20261116164358.142785-7-steven.price@arm.com>
 <sashiko-outbox-217428@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <sashiko-outbox-217428@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 16/11/2026 17:21, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 5 potential
> issues to consider:
> - [Medium] KVM: arm64: cca: broken split-failure fallback in
>   realm_unmap_*_range()
> - [Medium] KVM: arm64: cca: stale err_level after
>   realm_unmap_cache_topup() failure
> - [Medium] KVM: arm64: cca: get_start_level() misses 2-level minimum on
>   64K pages
> - [Medium] KVM: arm64: KVM_BUG_ON() on -ENOMEM in
>   realm_unmap_private_range()
> - [Low] KVM: arm64: cca: possible RTT creation for unmapped entry in
>   realm_unmap_*()
> --
> 
> commit 453fd020abf481912e2fee6d2f403740b481af92
> Author: Steven Price <steven.price@arm.com>
> 
> KVM: arm64: CCA: Add Realm RTT mapping and invalidation helpers
> 
> This commit adds RMI RTT creation, folding, and unmap helpers for CCA
> Realm stage-2 shared and private address ranges.
> 
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index 74b89da4e8015..838f95c201ada 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
> 
> [ ... ]
> 
>> @@ -154,12 +291,94 @@ static int realm_tear_down_rtt_range(struct realm *realm,
>>  					 start, end);
>>  }
>>  
>> +/*
>> + * Returns 0 on successful fold, a negative value on error, a positive value if
>> + * we were not able to fold all tables at this level.
>> + */
>> +static int realm_fold_rtt_level(struct realm *realm, int level,
>> +				unsigned long start, unsigned long end)
>> +{
>> +	int not_folded = 0;
>> +	ssize_t map_size;
>> +	unsigned long addr, next_addr;
>> +
>> +	if (WARN_ON(level > KVM_PGTABLE_LAST_LEVEL))
>> +		return -EINVAL;
> 
> [Severity: Medium]
> On a CONFIG_ARM64_64K_PAGES kernel, can realm_fold_rtt_level() be called
> with level == 4 and trigger this WARN_ON()?
> 
> For a 32-bit or 33-bit IPA, stage2_pgtable_levels(realm->ia_bits) returns
> 1 on 64K pages, so get_start_level() returns 4 - 1 = 3
> (KVM_PGTABLE_LAST_LEVEL) even though kvm_get_vtcr() clamps stage-2 tables
> to at least 2 levels (start_level = 2).  When realm_unmap_shared_range()
> or realm_unmap_private_range() then calls realm_fold_rtt_level(realm,
> get_start_level(realm) + 1, start, end), level is 4, triggering the
> warning and skipping RTT folding (and similarly in
> realm_tear_down_rtt_range()).
> 
> [ ... ]

Already discussed in previous email about get_start_level().

>> @@ -189,6 +408,208 @@ int kvm_realm_teardown_stage2(struct kvm *kvm)
>>  	return 0;
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
>> +
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
>> +			if (WARN_ON(err_level < get_start_level(realm) ||
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
> This question rests on an RMM architecture detail that could not be
> confirmed from the kernel source: can SMC_RMI_RTT_UNPROT_UNMAP or
> SMC_RMI_RTT_DATA_UNMAP return RMI_ERROR_RTT with err_level < level when
> the RTT walk stops at an unassigned ancestor entry (where neither a child
> RTT nor a block mapping exists), rather than advancing next_addr across
> the unmapped ancestor and returning RMI_SUCCESS?

As per the spec:

IQTXJY: A Range-based memory unmapping operation skips over RTT entries
within the target IPA range whose state is already equal to the target
value.

So no it won't stop at an unassigned entry.

> If yes, unmapping a sub-block range (such as a single page where level is
> KVM_PGTABLE_LAST_LEVEL) in an unpopulated region will fall through to
> realm_create_rtt_levels() in both realm_unmap_shared_range() and
> realm_unmap_private_range(), allocating and delegating intermediate RTTs
> only to fold them again at the end of the function, and hitting
> KVM_BUG_ON(1, kvm) in realm_unmap_private_range() if that allocation
> fails.
> 
>> +
>> +			if (may_block && realm_unmap_cache_topup(kvm, mc,
>> +								 level - err_level)) {
>> +				next_addr = addr;
>> +				break;
>> +			}
>> +
>> +			ret = realm_create_rtt_levels(realm, addr, err_level,
>> +						      level, mc);
> 
> [Severity: Medium]
> Can realm_create_rtt_levels() run with a stale err_level if
> __kvm_mmu_topup_memory_cache() fails inside realm_unmap_cache_topup()?
> 
> When the cache has fewer than needed objects and topup fails with
> -ENOMEM, realm_unmap_cache_topup() still drops and re-acquires
> kvm->mmu_lock before returning false.  If another thread folds or modifies
> the RTTs while mmu_lock is dropped, continuing into
> realm_create_rtt_levels() with the pre-unlock err_level (in both
> realm_unmap_shared_range() and realm_unmap_private_range()) can fail with
> RMI_ERROR_RTT at an ancestor level and trigger the WARN() in
> realm_create_rtt_levels().

I don't really get how this could sensibly be improved. In the event
that the cache top-up fails then we're already critically low on memory.
Looping round to have an up-to-date err_level would (most likely) put us
back in the same situation of needing to top-up the cache (and failing).

Continuing does indeed use a potentially stale err_level in the call to
realm_create_rtt_levels(). The only issue here is if another thread had
folded (if the RTTs had been created then we already handle that case
gracefully). In that case we'd need even more memory so the operation
would almost certainly fail.

And if realm_create_rtt_levels() fails then we fall to unmapping the
entire block - which isn't ideal but regains memory (which we're
apparently very short on).

There's perhaps an argument that the WARN_ON() below might be able to
trigger, but then under these extreme memory allocation failures we
should already have the allocator WARNing. So I don't think that's a
real consideration either.

>> +			if (!ret) {
>> +				/* Retry with the RTT levels in place. */
>> +				next_addr = addr;
>> +				break;
>> +			}
>> +			WARN_ON(ret != -ENOMEM);
>> +
>> +			/* Splitting failed; unmap the entire existing block. */
>> +			next_addr = ALIGN_DOWN(addr, kvm_granule_size(err_level));
>> +			end = max(end, next_addr + kvm_granule_size(err_level));
>> +			break;
> 
> [Severity: Medium]
> If realm_create_rtt_levels() fails partway through a multi-level split
> (for example, after creating a level-2 RTT to split a 1 GiB level-1 block,
> then failing with -ENOMEM at level 3), doesn't this fallback use the
> initial err_level and widen the unmap to the full 1 GiB block instead of
> the 2 MiB block at the last level created?
> 
> Also, when next_addr is aligned down below start, start is not updated, so
> the realm_fold_rtt_level() call after the loop starts at the original
> start and skips folding RTTs in [next_addr, start).  Both issues also
> apply to the fallback in realm_unmap_private_range().

This is technically correct. But equally this is a "shouldn't happen in
practice" situation. If we can't split then we can't unmap the requested
range. While there are corner cases like Sashiko describes which could
be improved on slightly, I don't see the point in unnecessarily
complicating the code for them. Ultimately if we get here then we're
unmapping too much - and we just have to hope that the system as a whole
can recover at the cost of the VM.

Certainly in the case of realm_unmap_private_range() the VM can't
recover (hence KVM_BUG_ON()). For the shared memory case we can at least
fault the memory back in if memory pressure has reduced sufficiently.

> [ ... ]
> 
>> +static void realm_unmap_private_range(struct kvm *kvm,
>> +				      unsigned long start,
>> +				      unsigned long end,
>> +				      bool may_block,
>> +				      struct kvm_mmu_memory_cache *mc)
>> +{
> 
> [ ... ]
> 
>> +			ret = realm_create_rtt_levels(realm, addr, err_level,
>> +						      level, mc);
>> +			if (!ret) {
>> +				next_addr = addr;
>> +				break;
>> +			}
>> +
>> +			/* A failed split cannot leave the backing pages mapped. */\n> +			KVM_BUG_ON(1, kvm);
> 
> [Severity: Medium]
> Can an RTT allocation failure (-ENOMEM) in realm_create_rtt_levels()
> trigger a host WARN_ON_ONCE() via KVM_BUG_ON()?

Yes.

> Both __kvm_mmu_topup_memory_cache() and alloc_delegated_granule() use
> __GFP_ACCOUNT, so a host VMM hitting its memcg limit or host memory
> pressure can cause realm_create_rtt_levels() to return -ENOMEM.  Unlike
> realm_unmap_shared_range(), which guards its warning with WARN_ON(ret !=
> -ENOMEM), KVM_BUG_ON(1, kvm) unconditionally warns even on -ENOMEM; using
> WARN_ON(ret != -ENOMEM) and marking the VM dead or bugged without warning
> on allocation failure would avoid a user-triggerable kernel warning.
> 

So the cache topup can fail (silently) due to memcg limits. However
alloc_delegated_granule() falls back to __get_free_page(GFP_ATOMIC |
__GFP_ZERO | __GFP_ACCOUNT) which AFAICT will not be subject to the
memcg limit and will WARN itself before failing.

So unless I've misunderstood something the only path that can trigger
the WARN_ON_ONCE in KVM_BUG_ON() is one which has already triggered a WARN.

As above this isn't a case I expect to happen, and it would be good to
be fairly noisy about it because we've just killed off the VM (most
likely due to no fault of the VM or VMM). But I'm open to suggestions to
improve this if anyone has them.

Thanks,
Steve
