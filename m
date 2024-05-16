Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF1431459F3;
	Thu, 16 May 2024 15:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715872432; cv=none; b=fFlU7401ShGJnt1BL16os87/pTrKBBk3XEP1pXSep/evGj9/hQK9Ip8I66M8u/mh/aw3xhePrVK3lHxIsw2/oUyOxzpi+DeQbpc9QOQv5YKU9f+NhB9za9nsFKwl6gcg6rfVrvIUPwH0i0e4OGvFCabkGWuXlRvd1DLVINE+FNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715872432; c=relaxed/simple;
	bh=XfgR26NvsXa0WA/2rJqxXL9YCkCSEKI2m8bMfsvqjog=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qtL2s+xbx2h7WAdPegMt5wYoGRa8jlM+2VOYjFDUnWHUbKCxIedue6L5aemm8AzYMaXFty+SknHZADRCk2Zgb9RmQo2eKXz8z/0C0IHFkdMaDuc0dokMwoc+dfRjiR+4U4hyhisvxPweV6cAJLE09ICpzvJILi2Qac3u9iBa6sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B7E8DA7;
	Thu, 16 May 2024 08:14:12 -0700 (PDT)
Received: from [10.1.25.38] (e122027.cambridge.arm.com [10.1.25.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2C64F3F7A6;
	Thu, 16 May 2024 08:13:45 -0700 (PDT)
Message-ID: <c3672ee2-ae50-4750-87e0-5001953a5371@arm.com>
Date: Thu, 16 May 2024 16:13:43 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/14] arm64: realm: Query IPA size from the RMM
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Marc Zyngier
 <maz@kernel.org>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-4-steven.price@arm.com> <ZkIdqoELmQ3tUJ8M@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <ZkIdqoELmQ3tUJ8M@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 13/05/2024 15:03, Catalin Marinas wrote:
> On Fri, Apr 12, 2024 at 09:42:02AM +0100, Steven Price wrote:
>> diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
>> index dd9ee67d1d87..15d8f0133af8 100644
>> --- a/arch/arm64/include/asm/pgtable-prot.h
>> +++ b/arch/arm64/include/asm/pgtable-prot.h
>> @@ -63,6 +63,9 @@
>>  #include <asm/pgtable-types.h>
>>  
>>  extern bool arm64_use_ng_mappings;
>> +extern unsigned long prot_ns_shared;
>> +
>> +#define PROT_NS_SHARED		((prot_ns_shared))
> 
> Nit: what's with the double parenthesis here?

No idea - I'll remove a set!

>>  #define PTE_MAYBE_NG		(arm64_use_ng_mappings ? PTE_NG : 0)
>>  #define PMD_MAYBE_NG		(arm64_use_ng_mappings ? PMD_SECT_NG : 0)
>> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
>> index 1076649ac082..b93252ed6fc5 100644
>> --- a/arch/arm64/kernel/rsi.c
>> +++ b/arch/arm64/kernel/rsi.c
>> @@ -7,6 +7,11 @@
>>  #include <linux/memblock.h>
>>  #include <asm/rsi.h>
>>  
>> +struct realm_config __attribute((aligned(PAGE_SIZE))) config;
> 
> Another nit: use __aligned(PAGE_SIZE).
> 
> However, does the spec require this to be page-size aligned? The spec
> says aligned to 0x1000 and that's not necessarily the kernel page size.
> It also states that the RsiRealmConfig structure is 4096 and I did not
> see this in the first patch, you only have 8 bytes in this structure.
> Some future spec may write more data here overriding your other
> variables in the data section.
> 
> So that's the wrong place to force the alignment. Just do this when you
> define the actual structure in the first patch:
> 
> struct realm_config {
> 	union {
> 		unsigned long ipa_bits; /* Width of IPA in bits */
> 		u8 __pad[4096];
> 	};
> } __aligned(4096);
> 
> and maybe with a comment on why the alignment and padding. You could
> also have an unnamed struct around ipa_bits in case you want to add more
> fields in the future (siginfo follows this pattern).

Good suggestion - I'll update this. It turns out struct realm_config is
already missing "hash_algo" (not that we use it yet), so I'll add that too.

Thanks,

Steve

>> +
>> +unsigned long prot_ns_shared;
>> +EXPORT_SYMBOL(prot_ns_shared);
>> +
>>  DEFINE_STATIC_KEY_FALSE_RO(rsi_present);
>>  EXPORT_SYMBOL(rsi_present);
>>  
>> @@ -53,6 +58,9 @@ void __init arm64_rsi_init(void)
>>  {
>>  	if (!rsi_version_matches())
>>  		return;
>> +	if (rsi_get_realm_config(&config))
>> +		return;
>> +	prot_ns_shared = BIT(config.ipa_bits - 1);
>>  
>>  	static_branch_enable(&rsi_present);
>>  }
> 

