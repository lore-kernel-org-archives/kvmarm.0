Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 789612571DD
	for <kvmarm@lists.linux.dev>; Mon, 23 Feb 2026 15:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771859658; cv=none; b=Pkw0D1qO+QcItWxkrLOkAg0KPyG3Lyibf6cOeots7RHIDXFbXPEJuzxIpKMfUaH3iq26x9b1Ycd5JWzaS8DLJtrcVo0dYpgtQPIrg6FGmneVRBICof/3F1vtO8sfX6XaV29/1bPXajheH/xuvOUT2cLGx3iGNDKTjjk7TOv46lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771859658; c=relaxed/simple;
	bh=eQCBwFby1Ld0oHSGDVr5wV0jA7HiMI9T0gPIm1knDqQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a1J+aLHkMgNbIFKNOVAsbWOiBRjbQGkhXov5eYk9yI1MeJkHpqO9JE7ujMqy0hwNtlw06741y6tiipRcZ3XzDDbV5UTXar8j/M+Bwqc8Ki9wPDXkVcBSsEGJXVTnlesx0l3sJMT+dJM5EtfeqKTOQtHM0ZYMTB2pbqHKFbl4mvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 17F00339;
	Mon, 23 Feb 2026 07:14:02 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7F1863F59E;
	Mon, 23 Feb 2026 07:14:06 -0800 (PST)
Message-ID: <aabcf0b8-6fdd-46ee-beb8-e22e01869c77@arm.com>
Date: Mon, 23 Feb 2026 15:14:04 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: Force the use of CNTVCT_EL0 in __delay()
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Hyesoo Yu <hyesoo.yu@samsung.com>, Quentin Perret <qperret@google.com>,
 stable@vger.kernel.org
References: <20260213141619.1791283-1-maz@kernel.org>
 <aZw3EGs4rbQvbAzV@e134344.arm.com> <86ldgja5v3.wl-maz@kernel.org>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <86ldgja5v3.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 2/23/26 14:31, Marc Zyngier wrote:
> Hi Ben,
> 
> On Mon, 23 Feb 2026 11:16:32 +0000,
> Ben Horgan <ben.horgan@arm.com> wrote:
>>
>> Hi Marc,
>>
>> On Fri, Feb 13, 2026 at 02:16:19PM +0000, Marc Zyngier wrote:
>>> Quentin forwards a report from Hyesoo Yu, describing an interesting
>>> problem with the use of WFxT in __delay() when a vcpu is loaded and
>>> that KVM is *not* in VHE mode (either nVHE or hVHE).
>>>
>>> In this case, CNTVOFF_EL2 is set to a non-zero value to reflect the
>>> state of the guest virtual counter. At the same time, __delay() is
>>> using get_cycles() to read the counter value, which is indirected to
>>> reading CNTPCT_EL0.
>>>
>>> The core of the issue is that WFxT is using the *virtual* counter,
>>> while the kernel is using the physical counter, and that the offset
>>> introduces a really bad discrepancy between the two.
>>>
>>> Fix this by forcing the use of CNTVCT_EL0, making __delay() consistent
>>> irrespective of the value of CNTVOFF_EL2.
>>>
>>> Reported-by: Hyesoo Yu <hyesoo.yu@samsung.com>
>>> Reported-by: Quentin Perret <qperret@google.com>
>>> Reviewed-by: Quentin Perret <qperret@google.com>
>>> Fixes: 7d26b0516a0df ("arm64: Use WFxT for __delay() when possible")
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> Link: https://lore.kernel.org/r/ktosachvft2cgqd5qkukn275ugmhy6xrhxur4zqpdxlfr3qh5h@o3zrfnsq63od
>>> Cc: stable@vger.kernel.org
>>> ---
>>>  arch/arm64/lib/delay.c | 19 +++++++++++++++----
>>>  1 file changed, 15 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/arm64/lib/delay.c b/arch/arm64/lib/delay.c
>>> index cb2062e7e2340..d02341303899e 100644
>>> --- a/arch/arm64/lib/delay.c
>>> +++ b/arch/arm64/lib/delay.c
>>> @@ -23,9 +23,20 @@ static inline unsigned long xloops_to_cycles(unsigned long xloops)
>>>  	return (xloops * loops_per_jiffy * HZ) >> 32;
>>>  }
>>>  
>>> +/*
>>> + * Force the use of CNTVCT_EL0 in order to have the same base as WFxT.
>>> + * This avoids some annoying issues when CNTVOFF_EL2 is not reset 0 on a
>>> + * KVM host running at EL1 until we do a vcpu_put() on the vcpu. When
>>> + * running at EL2, the effective offset is always 0.
>>> + *
>>> + * Note that userspace cannot change the offset behind our back either,
>>> + * as the vcpu mutex is held as long as KVM_RUN is in progress.
>>> + */
>>> +#define __delay_cycles()	__arch_counter_get_cntvct_stable()
>>
>> I'm seeing this CONFIG_DEBUG_PREEMPT warning, see below, when running 7.0-rc1 on
>> FVP Base RevC. I haven't tried bisecting but it looks to be introduced by this
>> change.
>>
>> The calls are:
>>
>> __this_cpu_read()
>> erratum_handler()
>> arch_timer_reg_read_stable()
>> __arch_counter_get_cntvct_stable()
>> __delay()
>>
>> This silences the warning:
>>
>> diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
>> index f5794d50f51d..f07e4efa0d2b 100644
>> --- a/arch/arm64/include/asm/arch_timer.h
>> +++ b/arch/arm64/include/asm/arch_timer.h
>> @@ -24,14 +24,14 @@
>>  #define has_erratum_handler(h)                                         \
>>         ({                                                              \
>>                 const struct arch_timer_erratum_workaround *__wa;       \
>> -               __wa = __this_cpu_read(timer_unstable_counter_workaround); \
>> +               __wa = raw_cpu_read(timer_unstable_counter_workaround); \
>>                 (__wa && __wa->h);                                      \
>>         })
>>  
>>  #define erratum_handler(h)                                             \
>>         ({                                                              \
>>                 const struct arch_timer_erratum_workaround *__wa;       \
>> -               __wa = __this_cpu_read(timer_unstable_counter_workaround); \
>> +               __wa = raw_cpu_read(timer_unstable_counter_workaround); \
>>                 (__wa && __wa->h) ? ({ isb(); __wa->h;}) : arch_timer_##h; \
>>         })
> 
> It does indeed silence it, but that's IMO the wrong thing to do since
> you can end-up calling a workaround helper on the wrong CPU if

Agreed. This just hides the problem.

> preempted.  If you look at how things were done before this patch, we
> had:
> 
> get_cycles() -> arch_timer_read_counter() -> arch_counter_get_cntvct_stable()
> 
> Crucially, arch_counter_get_cntvct_stable() does disable preemption,
> and we should preserve it. Something like this:
> 
> diff --git a/arch/arm64/lib/delay.c b/arch/arm64/lib/delay.c
> index d02341303899e..25fb593f95b0c 100644
> --- a/arch/arm64/lib/delay.c
> +++ b/arch/arm64/lib/delay.c
> @@ -32,7 +32,16 @@ static inline unsigned long xloops_to_cycles(unsigned long xloops)
>   * Note that userspace cannot change the offset behind our back either,
>   * as the vcpu mutex is held as long as KVM_RUN is in progress.
>   */
> -#define __delay_cycles()	__arch_counter_get_cntvct_stable()
> +static cycles_t __delay_cycles(void)
> +{
> +	cycles_t val;
> +
> +	preempt_disable();
> +	val = __arch_counter_get_cntvct_stable();
> +	preenpt_enable();
> +
> +	return val;
> +}

Modulo the typo (preenpt) this looks to be correct and I see no warnings.

>  
>  void __delay(unsigned long cycles)
>  {
> 
> The question is whether there is a material benefit in replicating the
> arch_timer_read_counter() indirection for the virtual counter in order
> to not pay the price of preempt_disable() when we're on a non-broken
> system (hopefully the vast majority of implementations).

I'm unsure of the tradeoffs here.

> 
> Thanks,
> 
> 	M.
> 

Thanks,

Ben

