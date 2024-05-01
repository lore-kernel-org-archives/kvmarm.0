Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93C9012FB29;
	Wed,  1 May 2024 14:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714575399; cv=none; b=NtYRxj71wRac0vrCCA6NLZ+QjaOQL0rZYUK51HsyvFP2Q3MGMTtqUoGdYLIsgDHvw1ziGwANLJowr2Vdw9aRt5rP7yS/7BqhKkTjmGg6K+bpGnmoTSrGrDie0ZjfhUTus1T1ZSC92MLHvezGvNlagOaCIo5QhS4adCrqM+bbnyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714575399; c=relaxed/simple;
	bh=p52p3F37XvyVfrfrsqWyEV0jgw7gj7LU4qdYq7WAN2o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZVtRyFTK09BBYEfKQlz5B+xHQXW0RY0GTy5hEUBMH9TnsYEyyLs+jz5TT5gAhehOai/MeusH7C6AdwxagDYyrB91h1cba+pF6RBptYgibkKaOxlXN9T9E9tU3H0XKLCg5o7CMc5ADj6/lZxzAzyRGVzF24g+BiPan3HRayYVhlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 20F062F4;
	Wed,  1 May 2024 07:57:03 -0700 (PDT)
Received: from [10.57.82.68] (unknown [10.57.82.68])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B37333F793;
	Wed,  1 May 2024 07:56:34 -0700 (PDT)
Message-ID: <fcb0cd30-ba40-48d2-8ce1-c5aa1d36cd1f@arm.com>
Date: Wed, 1 May 2024 15:56:33 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/43] arm64: RME: Allow VMM to set RIPAS
Content-Language: en-GB
To: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
 <20240412084309.1733783-18-steven.price@arm.com>
 <20240501142712.GB484338@myrica>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240501142712.GB484338@myrica>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/05/2024 15:27, Jean-Philippe Brucker wrote:
> On Fri, Apr 12, 2024 at 09:42:43AM +0100, Steven Price wrote:
>> +static inline bool realm_is_addr_protected(struct realm *realm,
>> +					   unsigned long addr)
>> +{
>> +	unsigned int ia_bits = realm->ia_bits;
>> +
>> +	return !(addr & ~(BIT(ia_bits - 1) - 1));
> 
> Is it enough to return !(addr & BIT(realm->ia_bits - 1))?

I thought about that too. But if we are dealing with an IPA
that is > (BIT(realm->ia_bits)), we don't want to be treating
that as a protected address. This could only happen if the Realm
is buggy (or the VMM has tricked it). So the existing check
looks safer.

> 
>> +static void realm_unmap_range_shared(struct kvm *kvm,
>> +				     int level,
>> +				     unsigned long start,
>> +				     unsigned long end)
>> +{
>> +	struct realm *realm = &kvm->arch.realm;
>> +	unsigned long rd = virt_to_phys(realm->rd);
>> +	ssize_t map_size = rme_rtt_level_mapsize(level);
>> +	unsigned long next_addr, addr;
>> +	unsigned long shared_bit = BIT(realm->ia_bits - 1);
>> +
>> +	if (WARN_ON(level > RME_RTT_MAX_LEVEL))
>> +		return;
>> +
>> +	start |= shared_bit;
>> +	end |= shared_bit;
>> +
>> +	for (addr = start; addr < end; addr = next_addr) {
>> +		unsigned long align_addr = ALIGN(addr, map_size);
>> +		int ret;
>> +
>> +		next_addr = ALIGN(addr + 1, map_size);
>> +
>> +		if (align_addr != addr || next_addr > end) {
>> +			/* Need to recurse deeper */
>> +			if (addr < align_addr)
>> +				next_addr = align_addr;
>> +			realm_unmap_range_shared(kvm, level + 1, addr,
>> +						 min(next_addr, end));
>> +			continue;
>> +		}
>> +
>> +		ret = rmi_rtt_unmap_unprotected(rd, addr, level, &next_addr);
>> +		switch (RMI_RETURN_STATUS(ret)) {
>> +		case RMI_SUCCESS:
>> +			break;
>> +		case RMI_ERROR_RTT:
>> +			if (next_addr == addr) {
>> +				next_addr = ALIGN(addr + 1, map_size);
>> +				realm_unmap_range_shared(kvm, level + 1, addr,
>> +							 next_addr);
>> +			}
>> +			break;
>> +		default:
>> +			WARN_ON(1);
> 
> In this case we also need to return, because RMM returns with next_addr ==
> 0, causing an infinite loop. At the moment a VMM can trigger this easily
> by creating guest memfd before creating a RD, see below

Thats a good point. I agree.

> 
>> +		}
>> +	}
>> +}
>> +
>> +static void realm_unmap_range_private(struct kvm *kvm,
>> +				      unsigned long start,
>> +				      unsigned long end)
>> +{
>> +	struct realm *realm = &kvm->arch.realm;
>> +	ssize_t map_size = RME_PAGE_SIZE;
>> +	unsigned long next_addr, addr;
>> +
>> +	for (addr = start; addr < end; addr = next_addr) {
>> +		int ret;
>> +
>> +		next_addr = ALIGN(addr + 1, map_size);
>> +
>> +		ret = realm_destroy_protected(realm, addr, &next_addr);
>> +
>> +		if (WARN_ON(ret))
>> +			break;
>> +	}
>> +}
>> +
>> +static void realm_unmap_range(struct kvm *kvm,
>> +			      unsigned long start,
>> +			      unsigned long end,
>> +			      bool unmap_private)
>> +{
> 
> Should this check for a valid kvm->arch.realm.rd, or a valid realm state?
> I'm not sure what the best place is but none of the RMM calls will succeed
> if the RD is NULL, causing some WARNs.
> 
> I can trigger this with set_memory_attributes() ioctls before creating a
> RD for example.
> 

True, this could be triggered by a buggy VMM in other ways, and we could
easily gate it on the Realm state >= NEW.

Suzuki


