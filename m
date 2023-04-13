Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21B9C7E
	for <kvmarm@lists.linux.dev>; Thu, 13 Apr 2023 08:04:41 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8BFDFD75;
	Thu, 13 Apr 2023 01:05:25 -0700 (PDT)
Received: from [10.57.68.113] (unknown [10.57.68.113])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D89413F6C4;
	Thu, 13 Apr 2023 01:04:39 -0700 (PDT)
Message-ID: <07b16237-e339-1641-a8a8-ece6d252dece@arm.com>
Date: Thu, 13 Apr 2023 09:04:37 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH v2 01/12] arm64/mm: Update non-range tlb invalidation
 routines for FEAT_LPA2
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20230306195438.1557851-1-ryan.roberts@arm.com>
 <20230306195438.1557851-2-ryan.roberts@arm.com> <ZDbSl8vccLiMCrDz@arm.com>
Content-Language: en-US
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <ZDbSl8vccLiMCrDz@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Thanks for the review!


On 12/04/2023 16:47, Catalin Marinas wrote:
> On Mon, Mar 06, 2023 at 07:54:27PM +0000, Ryan Roberts wrote:
>> FEAT_LPA2 impacts tlb invalidation in 2 ways; Firstly, the TTL field in
>> the non-range tlbi instructions can now validly take a 0 value for the
>> 4KB granule (this is due to the extra level of translation). Secondly,
>> the BADDR field in the range tlbi instructions must be aligned to 64KB
>> when LPA2 is in use (TCR.DS=1). Changes are required for tlbi to
>> continue to operate correctly when LPA2 is in use.
>>
>> KVM only uses the non-range (__tlbi_level()) routines. Therefore we only
>> solve the first problem with this patch.
> 
> There are some patches on the list to add support for range invalidation
> in KVM:
> 
> https://lore.kernel.org/r/20230206172340.2639971-1-rananta@google.com

I have the required change for range invalidation at:
https://gitlab.arm.com/linux-arm/linux-rr/-/commit/38628decb785aea42a349a857b9f8a65a19e9c2b.
But I didn't include it in this submission because it would be dead code until
either the patches you point out land, or Ard's patches land. Also, the
implementation I did uses the CPU feature to determine which variant to apply,
and since the kernel is not using LPA2 yet, it would give the wrong answer for
the case where LPA2 is supported by the system.

I think this patch (or similar) should be included with Ard's changes. What's
your view?


> 
>> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
>> index 412a3b9a3c25..67dd47df42d5 100644
>> --- a/arch/arm64/include/asm/tlbflush.h
>> +++ b/arch/arm64/include/asm/tlbflush.h
>> @@ -93,19 +93,22 @@ static inline unsigned long get_trans_granule(void)
>>   * When ARMv8.4-TTL exists, TLBI operations take an additional hint for
>>   * the level at which the invalidation must take place. If the level is
>>   * wrong, no invalidation may take place. In the case where the level
>> - * cannot be easily determined, a 0 value for the level parameter will
>> - * perform a non-hinted invalidation.
>> + * cannot be easily determined, the value TLBI_TTL_UNKNOWN will perform
>> + * a non-hinted invalidation. Any provided level outside the hint range
>> + * will also cause fall-back to non-hinted invalidation.
>>   *
>>   * For Stage-2 invalidation, use the level values provided to that effect
>>   * in asm/stage2_pgtable.h.
>>   */
>>  #define TLBI_TTL_MASK		GENMASK_ULL(47, 44)
>>  
>> +#define TLBI_TTL_UNKNOWN	(-1)
>> +
>>  #define __tlbi_level(op, addr, level) do {				\
>>  	u64 arg = addr;							\
>>  									\
>>  	if (cpus_have_const_cap(ARM64_HAS_ARMv8_4_TTL) &&		\
>> -	    level) {							\
>> +	    level >= 0 && level <= 3) {					\
> 
> I'd just use level != TLBI_TTL_UNKNOWN here.

I don't think that is correct, since if/when level -2 gets added,
TLBI_TTL_UNKNOWN would likely be changed to -2, and with your logic, you would
allow level=-1 through and ttl = -1 & 3 = 3. Callers will call this with the
actual level [-1, 3] and the intent here is to use a hint where the instruction
supports it [0, 3]. If you're concerned about the 2 comparisons, how about
leaving "level >= 0" and removing "level <= 3"?

> 
>>  		u64 ttl = level & 3;					\
>>  		ttl |= get_trans_granule() << 2;			\
>>  		arg &= ~TLBI_TTL_MASK;					\
>> @@ -133,16 +136,17 @@ static inline unsigned long get_trans_granule(void)
>>   * [BADDR, BADDR + (NUM + 1) * 2^(5*SCALE + 1) * PAGESIZE)
>>   *
>>   */
>> -#define __TLBI_VADDR_RANGE(addr, asid, scale, num, ttl)		\
>> -	({							\
>> -		unsigned long __ta = (addr) >> PAGE_SHIFT;	\
>> -		__ta &= GENMASK_ULL(36, 0);			\
>> -		__ta |= (unsigned long)(ttl) << 37;		\
>> -		__ta |= (unsigned long)(num) << 39;		\
>> -		__ta |= (unsigned long)(scale) << 44;		\
>> -		__ta |= get_trans_granule() << 46;		\
>> -		__ta |= (unsigned long)(asid) << 48;		\
>> -		__ta;						\
>> +#define __TLBI_VADDR_RANGE(addr, asid, scale, num, ttl)				\
>> +	({									\
>> +		unsigned long __ta = (addr) >> PAGE_SHIFT;			\
>> +		unsigned long __ttl = (ttl >= 1 && ttl <= 3) ? ttl : 0;		\
> 
> And here, set __ttl to 0 if TLBI_TTL_UNKNOWN.

Same argument as above.

> 
> Otherwise it looks fine:
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

