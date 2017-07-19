From: Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH] arm64: kvm: reuse existing cache type/info related macros
Date: Wed, 19 Jul 2017 10:13:17 +0100
Message-ID: <f934c7d0-5568-f018-f2f8-978686d5b076@arm.com>
References: <1498759604-7564-1-git-send-email-sudeep.holla@arm.com>
 <20170719090159.GC11435@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170719090159.GC11435@cbox>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu



On 19/07/17 10:01, Christoffer Dall wrote:
> On Thu, Jun 29, 2017 at 07:06:44PM +0100, Sudeep Holla wrote:
>> We already have various macros related to cache type and bitfields in
>> CLIDR system register. We can replace some of the hardcoded values
>> here using those existing macros.
>>
>> This patch reuses those existing cache type/info related macros and
>> replaces the hardcorded values. It also removes some of the comments
>> that become trivial with the macro names.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@linaro.org>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
>> ---
>>  arch/arm64/include/asm/cache.h |  7 +++++++
>>  arch/arm64/kernel/cacheinfo.c  |  7 -------
>>  arch/arm64/kvm/sys_regs.c      | 29 +++++++++++++++--------------
>>  3 files changed, 22 insertions(+), 21 deletions(-)
>>

[...]
>>  /* Which cache CCSIDR represents depends on CSSELR value. */
>>  static u32 get_ccsidr(u32 csselr)
>> @@ -1894,19 +1896,18 @@ static bool is_valid_cache(u32 val)
>>  		return false;
>>  
>>  	/* Bottom bit is Instruction or Data bit.  Next 3 bits are level. */
>> -	level = (val >> 1);
>> -	ctype = (cache_levels >> (level * 3)) & 7;
>> +	level = (val >> 1) + 1;
>> +	ctype = CLIDR_CTYPE(cache_levels, level);
>>  
>>  	switch (ctype) {
>> -	case 0: /* No cache */
>> -		return false;
>> -	case 1: /* Instruction cache only */
>> -		return (val & 1);
>> -	case 2: /* Data cache only */
>> -	case 4: /* Unified cache */
>> -		return !(val & 1);
>> -	case 3: /* Separate instruction and data caches */
>> +	case CACHE_TYPE_INST:
>> +		return (val & CACHE_TYPE_INST);
>> +	case CACHE_TYPE_DATA:
>> +	case CACHE_TYPE_UNIFIED:
>> +		return !(val & CACHE_TYPE_INST);
>> +	case CACHE_TYPE_SEPARATE:
>>  		return true;
>> +	case CACHE_TYPE_NOCACHE:
>>  	default: /* Reserved: we can't know instruction or data. */
>>  		return false;
>>  	}
> 
> These defines seem to be arch-generic concepts defined in
> include/linux/cacheinfo.h.  Are they guaranteed to not change and
> therefore always match the format of ARM registers?
> 

Indeed, I have added the mapping code for other architectures which
doesn't match. We can do the same when ARM deviates :)

> Otherwise, this looks good to me.
>

Thanks, Will/Marc had requested to repost after -rc1, will do that ASAP.

-- 
Regards,
Sudeep
