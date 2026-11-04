Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793790963;
	b=psRAislDf++JF18Dzvrwi+p2olFFiNoSWfNwgl2mVQXC0Gt2+7zXhetAhNvL88lj79kr
	 cT9tZZ4XOZ/A5cwIrlAH8ZUDI9VDnrnFYJ4LL4E04R6cMyGRy0YxiYRHkKWaV0PhdItkb
	 2vMyPT9YHtSYWrG3Pc2NdCBjRVDA+w40K8oVWf2jgOfByvsMh1fTP2t4lGUh3Om5fKv+x
	 h7p5/DNImFBVk1YnCOrLgEHEKk1jW2gb7mUVxSb7OhAV1RPaILG6Y3XVan3tuegLrBu+5
	 1A+1cSuGxLVeVfqgTCpJpx5KQ/jhgxk41C1G3q3iMe8HpDJm0YYty3FGDd4G3EnDLPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793790963;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=eiOg2MAhenDRU05DYhPV4wcEx3dEmInNUCVn3k09uGs=;
	b=tWgxWm0/QtITTw1wINMQiKovIcsHXqt+XirMveGzRxMIfhqZvcTkm3Yw9l+wMn1Kz/7b
	 CLPvDdZanO9Q+XUZzdd8tLP4GI5RVZwG1Yv4gJ7f3Ooeu5fLEZlspAYRabwq0VflqoS4M
	 zMjmybWmXcp6w2nHdELCSDQwL7reUwCHMd2fIsIbHloSJlkHm19RrhSD5fGRZ71NPVduQ
	 BeRrYEz0JXoblDh5wPYA0jLOi2AqBuVOIkJAJd9zC+iiSnKQ3KN51QEXreLS5sPQOnnso
	 WQV4LZq3YL+f4Pi9CTEsc8nr1oeHEiENrgaLAbOgugyN+iNbcq5te2di3Y/12faIpCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=GBc4Kszk;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F1C5606A329;
	Wed,  4 Nov 2026 11:16:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F1C5606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=GBc4Kszk
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D4EB1576;
	Wed,  4 Nov 2026 03:15:59 -0800 (PST)
Received: from [10.57.59.2] (unknown [10.57.59.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 324AB3F632;
	Wed,  4 Nov 2026 03:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793790962; bh=cflYTwlnX/LQKRuXIK+Nr6/tiZUt0ss+xE+1fUqXsIY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GBc4KszkPtmLUrVuRxdXpxKasJFaPFjvfTJOAdshl0CMWVb+tbMNvUTE/u7e3aVEj
	 FhZLSr2QECxb7Z7SkvNRB77DJ3Lpo8s3iAavtoAGLNwXsNo2pZ65AEKY7gjU/HrYPh
	 xVrhCat+0wKZV7RRM1E3/rxAjAH/kFra+nJVaRRk=
Message-ID: <3231e650-87ca-4a23-b46f-d10d79eb8674@arm.com>
Date: Wed, 4 Nov 2026 11:15:58 +0000
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
Subject: Re: [PATCH 08/11] KVM: arm64: CCA: Add Realm RTT mapping and
 invalidation helpers
To: sashiko-reviews@lists.linux.dev, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-9-steven.price@arm.com>
 <sashiko-outbox-193686@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <sashiko-outbox-193686@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 02/11/2026 15:37, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] KVM: arm64: uninitialized next_addr in realm_unmap_private_range()
> - [High] KVM: arm64: broken address alignment and recursion in realm_fold_rtt_level()
> - [Medium] KVM: arm64: page accounting after free_page() in free_rtt()
> --
> 
> commit cc0b24728b73f60b1dd39eb4cc60fe5eb12322c6
> Author: Steven Price <steven.price@arm.com>
> 
> KVM: arm64: CCA: Add Realm RTT mapping and invalidation helpers
> 
> This commit adds Realm Management Interface (RMI) Realm Translation Table
> (RTT) creation, folding, and unmap helpers needed for CCA Realm stage-2
> memory operations.
> 
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index f190143b33ba5..1066f767f85d9 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -34,6 +34,83 @@ static int get_start_level(struct realm *realm)
> 
> [ ... ]
> 
>> +static phys_addr_t alloc_delegated_granule(struct kvm_mmu_memory_cache *mc)
>> +{
>> +	phys_addr_t phys;
>> +	void *virt;
>> +
>> +	if (mc) {
>> +		virt = kvm_mmu_memory_cache_alloc(mc);
>> +	} else {
>> +		virt = (void *)__get_free_page(GFP_ATOMIC | __GFP_ZERO |
>> +					       __GFP_ACCOUNT);
>> +	}
>> +
>> +	if (!virt)
>> +		return PHYS_ADDR_MAX;
>> +
>> +	phys = virt_to_phys(virt);
>> +	if (rmi_delegate_page(phys)) {
>> +		free_page((unsigned long)virt);
>> +		return PHYS_ADDR_MAX;
>> +	}
>> +
>> +	return phys;
>> +}
>> +
>> +static phys_addr_t alloc_rtt(struct kvm_mmu_memory_cache *mc)
>> +{
>> +	phys_addr_t phys = alloc_delegated_granule(mc);
>> +
>> +	if (phys != PHYS_ADDR_MAX)
>> +		kvm_account_pgtable_pages(phys_to_virt(phys), 1);
>> +
>> +	return phys;
>> +}
>> +
>>  static void free_rtt(phys_addr_t phys)
>>  {
>>  	if (rmi_free_delegated_page(phys))
>> @@ -42,6 +119,32 @@ static void free_rtt(phys_addr_t phys)
>>  	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
>>  }
> 
> [Severity: Medium]
> Does free_rtt() leak the NR_SECONDARY_PAGETABLE counter in the memory cgroup
> lruvec (or touch a reallocated page) by calling kvm_account_pgtable_pages()
> after rmi_free_delegated_page()?
> 
> In alloc_rtt(), RTT pages are allocated via alloc_delegated_granule() with
> __GFP_ACCOUNT and accounted with kvm_account_pgtable_pages(..., 1). However,
> when free_rtt() frees an RTT, rmi_free_delegated_page() already calls
> free_page() before returning:
> 
> drivers/firmware/arm_rmm/rmi.c:rmi_free_delegated_page() {
> 	if (WARN_ON_ONCE(rmi_undelegate_page(phys))) {
> 		/* Undelegate failed: leak the page */
> 		return -EBUSY;
> 	}
> 
> 	free_page((unsigned long)phys_to_virt(phys));
> 
> 	return 0;
> }
> 
> Because free_page() uncharges the page and clears page->memcg_data (and
> returns the page to the allocator where another CPU can immediately
> reallocate it), the subsequent kvm_account_pgtable_pages(phys_to_virt(phys),
> -1) in free_rtt() operates on a freed page whose memcg association has been
> cleared.

This was covered in the previous patch.

> [ ... ]
> 
>> @@ -161,6 +301,64 @@ static int realm_tear_down_rtt_range(struct realm *realm,
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
>> +
>> +	map_size = rmi_rtt_level_mapsize(level - 1);
>> +
>> +	for (addr = start; addr < end; addr = next_addr) {
>> +		phys_addr_t rtt_granule;
>> +		long ret;
>> +		unsigned long align_addr = ALIGN(addr, map_size);
>> +
>> +		next_addr = ALIGN(addr + 1, map_size);
>> +
>> +		ret = realm_rtt_fold(realm, align_addr, level, &rtt_granule);
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +		switch (RMI_RESULT_STATUS(ret)) {
>> +		case RMI_SUCCESS:\
>> +			free_rtt(rtt_granule);
>> +			break;
>> +		case RMI_ERROR_RTT:
>> +			if (level == KVM_PGTABLE_LAST_LEVEL ||
>> +			    RMI_RESULT_DATA_LEVEL(ret) < level) {
>> +				not_folded++;
>> +				break;
>> +			}
>> +			/* Recurse a level deeper */
>> +			ret = realm_fold_rtt_level(realm,
>> +						   level + 1,
>> +						   addr,
>> +						   next_addr);
>> +			if (ret < 0) {
>> +				return ret;
>> +			} else if (ret == 0) {
>> +				/* Try again at this level */
>> +				next_addr = addr;
>> +			}
>> +			break;
>> +		default:
>> +			WARN_ON(1);
>> +			return -ENXIO;
>> +		}
>> +	}
>> +
>> +	return not_folded;
>> +}
> 
> [Severity: High]
> In realm_fold_rtt_level(), align_addr is computed using ALIGN(addr, map_size)
> before calling realm_rtt_fold(realm, align_addr, level, &rtt_granule).
> 
> When addr is not aligned to map_size, ALIGN(addr, map_size) rounds addr up
> to the next RTT boundary (equal to next_addr), defeating the ALIGN_DOWN()
> inside realm_rtt_fold(). As a result, realm_rtt_fold() folds the next RTT
> instead of the RTT covering addr, and if addr lies in the final map_size
> block below BIT(realm->ia_bits), align_addr rounds up to BIT(realm->ia_bits),
> which is out of bounds for rmi_rtt_fold() and triggers the default WARN_ON(1)
> path.
> 
> Additionally, in the RMI_ERROR_RTT case:
> 1. The recursive call passes next_addr instead of min(next_addr, end),
>    scanning up to a full parent map_size beyond end while holding
>    kvm->mmu_lock for write.
> 2. When the recursive call returns a positive value (some child tables were
>    not folded), not_folded is not incremented at the current level. If this
>    level returns 0 to its caller, the caller sees ret == 0, sets
>    next_addr = addr to retry, and can loop indefinitely.
> 3. Conversely, when recursing to level + 1 across [addr, next_addr), any
>    entry at level that is already a leaf entry (such as UNASSIGNED) has no
>    table at level + 1, so rmi_rtt_fold() returns RMI_ERROR_RTT with
>    RMI_RESULT_DATA_LEVEL(ret) < level + 1 and increments not_folded,
>    preventing the parent table at level from being retried and folded even if
>    all of its child RTTs were folded. And if ret == 0 is returned when the
>    table at level still cannot be folded (because entries in [addr, next_addr)
>    are non-homogeneous or align_addr targeted the next block), setting
>    next_addr = addr will retry and recurse on the same range in an infinite
>    loop.
> 
> Should realm_fold_rtt_level() pass addr directly to realm_rtt_fold() (which
> already aligns down to map_size), clamp the recursive end to
> min(next_addr, end), and avoid retrying in a loop when the parent table
> itself cannot be folded?

Yes this looks broken. And I think the suggestion provided should work.
I'll fix this up in the next posting.

>> @@ -196,6 +394,154 @@ int kvm_realm_teardown_stage2(struct kvm *kvm)
> 
> [ ... ]
> 
>> +static void realm_unmap_private_range(struct kvm *kvm,
>> +				      unsigned long start,
>> +				      unsigned long end,
>> +				      bool may_block)
>> +{
>> +	struct realm *realm = &kvm->arch.realm;
>> +	unsigned long rd = virt_to_phys(realm->rd);
>> +	unsigned long next_addr, addr;
>> +	long ret;
>> +
>> +	for (addr = start; addr < end; addr = next_addr) {
>> +		unsigned long out_range;
>> +		unsigned long flags = RMI_ADDR_TYPE_SINGLE;
>> +		/* TODO: Optimise using RMI_ADDR_TYPE_LIST */
>> +
>> +retry:
>> +		ret = rmi_rtt_data_unmap(rd, addr, end, flags, 0,
>> +					 &next_addr, &out_range, NULL);
>> +		if (WARN_ON(ret < 0))
>> +			return;
>> +
>> +		if (RMI_RESULT_STATUS(ret) == RMI_ERROR_RTT) {
>> +			phys_addr_t rtt;
>> +
>> +			if (next_addr > addr)
>> +				continue; /* UNASSIGNED */
>> +
>> +			rtt = alloc_rtt(NULL);
>> +			if (WARN_ON(rtt == PHYS_ADDR_MAX))
>> +				return;
>> +			ret = realm_rtt_create(realm, addr,
>> +					       RMI_RESULT_DATA_LEVEL(ret) + 1, rtt);
>> +			if (WARN_ON(ret)) {
>> +				free_rtt(rtt);
>> +				return;
>> +			}
>> +			goto retry;
>> +		} else if (WARN_ON(ret)) {
>> +			continue;
>> +		}
> 
> [Severity: High]
> What happens in realm_unmap_private_range() when rmi_rtt_data_unmap() returns
> RMI_ERROR_RTT or another non-zero status?
> 
> Looking at rmi_rtt_data_unmap() in include/linux/arm-rmi-cmds.h:
> 
> 	ret = rmi_sro_execute(&regs);
> 
> 	if (ret != RMI_SUCCESS)
> 		return ret;
> 
> 	if (out_top)
> 		*out_top = regs.a1;
> 
> *out_top (&next_addr) is only written when ret == RMI_SUCCESS.
> 
> When rmi_rtt_data_unmap() returns RMI_ERROR_RTT on the first iteration
> (addr == start), next_addr is uninitialized on the stack when evaluated by:
> 
> 	if (next_addr > addr)
> 		continue; /* UNASSIGNED */
> 
> If the uninitialized stack value happens to be greater than start, the loop
> advances addr to that garbage address and skips unmapping the range.
> 
> If next_addr <= addr on the first iteration (or on any subsequent iteration
> where addr == next_addr from the loop header), next_addr > addr is false even
> when the entry is UNASSIGNED. The code then allocates RTTs and calls
> realm_rtt_create(realm, addr, RMI_RESULT_DATA_LEVEL(ret) + 1, rtt) in a retry
> loop until RMI_RESULT_DATA_LEVEL(ret) reaches KVM_PGTABLE_LAST_LEVEL (3),
> where it attempts to create an RTT at level 4, hits WARN_ON(ret), and returns
> early without unmapping the remaining range.
> 
> Similarly, in the else if (WARN_ON(ret)) continue; branch, next_addr was not
> updated by rmi_rtt_data_unmap(), so continuing either jumps to uninitialized
> stack memory on the first iteration or repeats the same addr in an infinite
> loop while holding kvm->mmu_lock for write.
> 
> Should this handle RMI_ERROR_RTT in the same way as
> realm_unmap_shared_range(), using find_map_level(realm, addr, end) and
> advancing next_addr by rmi_rtt_level_mapsize(err_level) when err_level >=
> level?
> 

Again, makes sense - I'll fix this in the next posting.

Thanks,
Steve

