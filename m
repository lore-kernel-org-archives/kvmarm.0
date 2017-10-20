From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 02/10] arm64: KVM: Add invalidate_icache_range helper
Date: Fri, 20 Oct 2017 14:41:29 +0100
Message-ID: <278f54d4-6235-8ff0-da98-f7d59e4c5345@arm.com>
References: <20171009152032.27804-1-marc.zyngier@arm.com>
 <20171009152032.27804-3-marc.zyngier@arm.com>
 <20171019164736.GC30652@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171019164736.GC30652@arm.com>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 19/10/17 17:47, Will Deacon wrote:
> On Mon, Oct 09, 2017 at 04:20:24PM +0100, Marc Zyngier wrote:
>> We currently tightly couple dcache clean with icache invalidation,
>> but KVM could do without the initial flush to PoU, as we've
>> already flushed things to PoC.
>>
>> Let's introduce invalidate_icache_range which is limited to
>> invalidating the icache from the linear mapping (and thus
>> has none of the userspace fault handling complexity), and
>> wire it in KVM instead of flush_icache_range.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/include/asm/cacheflush.h |  8 ++++++++
>>  arch/arm64/include/asm/kvm_mmu.h    |  4 ++--
>>  arch/arm64/mm/cache.S               | 24 ++++++++++++++++++++++++
>>  3 files changed, 34 insertions(+), 2 deletions(-)
> 
> [...]
> 
>> diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
>> index 7f1dbe962cf5..0c330666a8c9 100644
>> --- a/arch/arm64/mm/cache.S
>> +++ b/arch/arm64/mm/cache.S
>> @@ -80,6 +80,30 @@ USER(9f, ic	ivau, x4	)		// invalidate I line PoU
>>  ENDPROC(flush_icache_range)
>>  ENDPROC(__flush_cache_user_range)
>>  
>> +/*
>> + *	invalidate_icache_range(start,end)
>> + *
>> + *	Ensure that the I cache is invalid within specified region. This
>> + *	assumes that this is done on the linear mapping. Do not use it
>> + *	on a userspace range, as this may fault horribly.
>> + *
>> + *	- start   - virtual start address of region
>> + *	- end     - virtual end address of region
>> + */
>> +ENTRY(invalidate_icache_range)
>> +	icache_line_size x2, x3
>> +	sub	x3, x2, #1
>> +	bic	x4, x0, x3
>> +1:
>> +	ic	ivau, x4			// invalidate I line PoU
>> +	add	x4, x4, x2
>> +	cmp	x4, x1
>> +	b.lo	1b
>> +	dsb	ish
>> +	isb
>> +	ret
>> +ENDPROC(invalidate_icache_range)
> 
> Is there a good reason not to make this work for user addresses? If it's as
> simple as adding a USER annotation and a fallback, then we should wrap that
> in a macro and reuse it for __flush_cache_user_range.

Fair enough. I've done that now (with an optional label that triggers
the generation of a USER() annotation).

I'll post the revised series shortly.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
