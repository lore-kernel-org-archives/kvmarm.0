Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794501517;
	b=dubcP957vYZZrlJiFNh/PiyZDjFHIrUYm4lZnURkFwVvdxS2YPL4wTTWUADaGaoXZ43b
	 fZ6eldIsdAmTCfjWyyDBK380wfMh3KYKrntwngWf0Cbnd1dwu833Qyh/xrXT/1vf6P+mP
	 OnObmmFmDUGiL4jltTbyUVAdMkpz5xwcBJB/JzBeLHkIOF/Zb3hvogUQtcd2POiVQH6cx
	 rVr5ntS96LOmdkScuF9Z1IFIetzk4sZ0Pi/D9e0mbJ1K7eQrK0Pz5xInmq+7trhpF3ZoD
	 KAeXBi+5aTDP2R5JFw1bN8sC2bTAaC5qJFwvBA1FpXIBxyE0RgvgEcTo4EKm6ZxzQSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794501517;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=v2gF4aHHWpEIFImP/DPmIYRLFp+X8A6di/NiItcHlnE=;
	b=jFaapCU7M45UhY3IvzYzrYV65pa2MSV8Z6p9TGiencPbLMVbfYAPfpJHnw1y5QOUHEvZ
	 xRjoWCTQzLu359LzpIjNv1PAqp7HaUBYkZMPa1qKu1sKtv7rFCsanPMoLvAHKjbfIBG7U
	 dReS6MfebG5WFLgxzBP5RztsPmasE+8fQzNgPALoevMSluQc7yTvUDnM0eovU8OGDP0ZK
	 CsQeTO2rPT+6lI/xbJ2fWJsUFv47mz5AXL8wBngMx2noHjfE48vFNztEskEDChAhFmbS6
	 eWXRtXUVFUMzsyqG2dAx8JTx9UCNt6y1WxFiCfElKWNNUAMtH7QayXAwySL5ZnoQmHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=d1CjBbn2;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27D2560A2633;
	Thu, 12 Nov 2026 16:38:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27D2560A2633
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=d1CjBbn2
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 571DE1516;
	Thu, 12 Nov 2026 08:38:32 -0800 (PST)
Received: from [10.0.129.47] (e122027.cambridge.arm.com [10.0.129.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 176583F673;
	Thu, 12 Nov 2026 08:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794501515; bh=IfAVo4vBtykoPmUjXuBHIIJ7Pw85nRDkVIIg21ET3+s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=d1CjBbn2/7//aQwbZNDEwljJyfRcnwXmXdrb6lOxiOtX9xrDqdPR+W+mFNUUZ4JQ5
	 JmrnwK1mR2oqvhLSsFKv9tPPlRxdoGWTXhaqzitDiDKrAr95QpHiSv/X/QjAPiTgaG
	 BODMYd3h+x81om2HLBH7685OhvLmZST938Waokyk=
Message-ID: <f9c3deee-2526-46a5-be98-f02235ad57be@arm.com>
Date: Thu, 12 Nov 2026 16:38:32 +0000
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
Subject: Re: [PATCH v2 08/12] KVM: arm64: CCA: Add Realm RTT mapping and
 invalidation helpers
To: sashiko-reviews@lists.linux.dev, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261111145758.217946-1-steven.price@arm.com>
 <20261111145758.217946-9-steven.price@arm.com>
 <sashiko-outbox-209447@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <sashiko-outbox-209447@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/11/2026 18:06, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [Medium] KVM: arm64: wrong granule level when skipping missing RTT in
>   realm_fold_rtt_level()
> - [Medium] KVM: arm64: cca: unhandled GFP_ATOMIC failure in
>   realm_create_rtt_levels()
> --
> 
> commit 68d993c0f3cb9846fd5972acfd789cb5ebe22bac
> Author: Steven Price <steven.price@arm.com>
> 
> KVM: arm64: CCA: Add Realm RTT mapping and invalidation helpers
> 
> This commit adds helpers to create, fold, and unmap Realm Translation
> Tables (RTTs) for shared and private IPA ranges.
> 
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index b904e6541fb07..5aa34d68de595 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
> 
> [ ... ]
> 
>> @@ -156,12 +286,94 @@ static int realm_tear_down_rtt_range(struct realm *realm,
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
>> +	map_size = kvm_granule_size(level - 1);
>> +
>> +	for (addr = start; addr < end; addr = next_addr) {
>> +		phys_addr_t rtt_granule;
>> +		long ret;
>> +
>> +		next_addr = ALIGN(addr + 1, map_size);
>> +
>> +		ret = realm_rtt_fold(realm, addr, level, &rtt_granule);
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +		switch (RMI_RESULT_STATUS(ret)) {
>> +		case RMI_SUCCESS:
>> +			free_rtt(rtt_granule);
>> +			break;
>> +		case RMI_ERROR_RTT: {
>> +			int err_level = RMI_RESULT_DATA_LEVEL(ret);
>> +
>> +			if (err_level < level) {
>> +				/* No RTT at this level; skip the missing ancestor. */
>> +				if (WARN_ON(err_level < get_start_level(realm)))
>> +					return -EINVAL;
>> +				next_addr = ALIGN(addr + 1,
>> +						  kvm_granule_size(err_level - 1));
>> +				break;
>> +			}
> 
> [Severity: Medium]
> Should this advance next_addr by kvm_granule_size(err_level) instead of
> kvm_granule_size(err_level - 1) (matching realm_unmap_shared_range() and
> realm_unmap_private_range())?

Indeed, this looks wrong. I'll correct in the next version.

> When realm_rtt_fold() fails at err_level < level, the walk stopped at a
> single non-table entry in the table at err_level, which spans
> kvm_granule_size(err_level).  Using err_level - 1 skips the span of the
> entire table at err_level, leaving any foldable sibling RTTs in the rest of
> that table unfolded, and evaluates kvm_granule_size(-1) when err_level is 0
> on 4-level stage-2 tables (shifting past 64 bits on 16KB and 64KB pages).
> 
> [ ... ]
> 
>> @@ -191,6 +403,154 @@ int kvm_realm_teardown_stage2(struct kvm *kvm)
>>  	return 0;
>>  }
>>  
>> +static void realm_unmap_shared_range(struct kvm *kvm,
>> +				     unsigned long start,
>> +				     unsigned long end,
>> +				     bool may_block)
>> +{
> 
> [ ... ]
> 
>> +		case RMI_ERROR_RTT: {
>> +			int err_level = RMI_RESULT_DATA_LEVEL(ret);
>> +			int level = find_map_level(realm, addr, end);
>> +
>> +			if (WARN_ON(err_level > KVM_PGTABLE_LAST_LEVEL))
>> +				return;
>> +
>> +			if (err_level >= level) {
>> +				/* Nothing present, so skip */
>> +				next_addr = ALIGN(addr + 1,
>> +						  kvm_granule_size(err_level));
>> +				break;
>> +			}
>> +
>> +			ret = realm_create_rtt_levels(realm, addr, err_level,
>> +						      level, NULL);
>> +			if (WARN_ON(ret))
>> +				return;
> 
> [ ... ]
> 
>> +static void realm_unmap_private_range(struct kvm *kvm,
>> +				      unsigned long start,
>> +				      unsigned long end,
>> +				      bool may_block)
>> +{
> 
> [ ... ]
> 
>> +		case RMI_ERROR_RTT: {
>> +			int err_level = RMI_RESULT_DATA_LEVEL(ret);
>> +			int level = find_map_level(realm, addr, end);
>> +
>> +			if (WARN_ON(err_level > KVM_PGTABLE_LAST_LEVEL))
>> +				return;
>> +
>> +			if (err_level >= level) {
>> +				/* Nothing present, so skip this RTT entry. */
>> +				next_addr = ALIGN(addr + 1,
>> +						  kvm_granule_size(err_level));
>> +				break;
>> +			}
>> +
>> +			ret = realm_create_rtt_levels(realm, addr, err_level,
>> +						      level, NULL);
>> +			if (WARN_ON(ret))
>> +				return;
> 
> [Severity: Medium]
> Can realm_create_rtt_levels() fail with -ENOMEM here, triggering WARN_ON()
> and aborting the unmap?
> 
> Passing mc = NULL causes alloc_delegated_granule() to allocate RTT pages
> with GFP_ATOMIC | __GFP_ZERO | __GFP_ACCOUNT.  When unmapping a sub-block
> range under memory pressure or a memcg limit, an allocation failure fires
> WARN_ON(ret) and returns early, leaving the rest of [addr, end) mapped in
> the Realm RTTs (for example across an MMU notifier invalidation before the
> host frees the backing pages).

Yes, this isn't ideal.

This should really have a memcache and allocate from that - that would
stop this path hitting in the normal case where the allocation can be
satisfied from the cache. With the cache being topped up when necessary
with the mmu_lock dropped.

Finally I could handle the case where we actually can't allocate an RTT
(and therefore can't split a huge page) by simply unmapping the huge
page in one go. For the shared range this is fine (the pages can be
faulted back in - assuming the memory becomes available), for the
private range it would be fatal to the VM, but the system can continue.

As Sashiko has pointed out, this would already have provoked a WARN_ON()
from the allocator, so I think that's probably fine.

Steve

