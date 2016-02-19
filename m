From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 1/6] KVM: arm/arm64: arch_timer: Gather KVM specific
 information in a structure
Date: Fri, 19 Feb 2016 11:54:02 +0000
Message-ID: <56C7025A.8030307@arm.com>
References: <1455204804-31830-1-git-send-email-julien.grall@arm.com>
 <1455204804-31830-2-git-send-email-julien.grall@arm.com>
 <56C6C318.3000205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8A6848536
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2016 06:47:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EAlVaHRjn686 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Feb 2016 06:47:41 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45BDD49444
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2016 06:47:40 -0500 (EST)
In-Reply-To: <56C6C318.3000205@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Wei Huang <wei@redhat.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, al.stone@linaro.org, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, fu.wei@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 19/02/16 07:24, Wei Huang wrote:
> 
> 
> On 02/11/2016 09:33 AM, Julien Grall wrote:
>> Introduce a structure which are filled up by the arch timer driver and
>> used by the virtual timer in KVM.
>>
>> The first member of this structure will be the timecounter. More members
>> will be added later.
>>
>> This is also dropping arch_timer_get_timecounter as it was only used by
>> the KVM code. Furthermore, a stub for the new helper hasn't been
>> introduced because KVM is requiring the arch timer for both ARM64 and
>> ARM32.
>>
>> Signed-off-by: Julien Grall <julien.grall@arm.com>
>>
>> ---
>> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Christoffer Dall <christoffer.dall@linaro.org>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Gleb Natapov <gleb@kernel.org>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>  drivers/clocksource/arm_arch_timer.c |  9 +++++----
>>  include/clocksource/arm_arch_timer.h | 12 ++++++------
>>  virt/kvm/arm/arch_timer.c            |  6 +++---
>>  3 files changed, 14 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
>> index c64d543..6eb2c5d 100644
>> --- a/drivers/clocksource/arm_arch_timer.c
>> +++ b/drivers/clocksource/arm_arch_timer.c
>> @@ -447,11 +447,11 @@ static struct cyclecounter cyclecounter = {
>>  	.mask	= CLOCKSOURCE_MASK(56),
>>  };
>>  
>> -static struct timecounter timecounter;
>> +static struct arch_timer_kvm_info arch_timer_kvm_info;
>>  
>> -struct timecounter *arch_timer_get_timecounter(void)
>> +struct arch_timer_kvm_info *arch_timer_get_kvm_info(void)
>>  {
>> -	return &timecounter;
>> +	return &arch_timer_kvm_info;
>>  }
>>  
>>  static void __init arch_counter_register(unsigned type)
>> @@ -479,7 +479,8 @@ static void __init arch_counter_register(unsigned type)
>>  	clocksource_register_hz(&clocksource_counter, arch_timer_rate);
>>  	cyclecounter.mult = clocksource_counter.mult;
>>  	cyclecounter.shift = clocksource_counter.shift;
>> -	timecounter_init(&timecounter, &cyclecounter, start_count);
>> +	timecounter_init(&arch_timer_kvm_info.timecounter,
>> +			 &cyclecounter, start_count);
>>  
>>  	/* 56 bits minimum, so we assume worst case rollover */
>>  	sched_clock_register(arch_timer_read_counter, 56, arch_timer_rate);
>> diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
>> index 25d0914..4d487f8 100644
>> --- a/include/clocksource/arm_arch_timer.h
>> +++ b/include/clocksource/arm_arch_timer.h
>> @@ -49,11 +49,16 @@ enum arch_timer_reg {
>>  
>>  #define ARCH_TIMER_EVT_STREAM_FREQ	10000	/* 100us */
>>  
>> +struct arch_timer_kvm_info {
>> +	struct timecounter timecounter;
>> +};
>> +
>>  #ifdef CONFIG_ARM_ARCH_TIMER
>>  
>>  extern u32 arch_timer_get_rate(void);
>>  extern u64 (*arch_timer_read_counter)(void);
>> -extern struct timecounter *arch_timer_get_timecounter(void);
>> +
>> +extern struct arch_timer_kvm_info *arch_timer_get_kvm_info(void);
>>  
>>  #else
>>  
>> @@ -67,11 +72,6 @@ static inline u64 arch_timer_read_counter(void)
>>  	return 0;
>>  }
>>  
>> -static inline struct timecounter *arch_timer_get_timecounter(void)
>> -{
>> -	return NULL;
>> -}
>> -
> 
> Most parts are OK. Regarding removing this function from the #else area,
> is there a possibility to have CONFIG_ARM_ARCH_TIMER=n and CONFIG_KVM=y.
> If so, will the compilation fails here?

On arm64, arch timers are not optional (see the "select ARM_ARCH_TIMER"
in arch/arm64/Kconfig). On 32bit, we have "depends on ARM_VIRT_EXT &&
ARM_LPAE && ARM_ARCH_TIMER", which nails it as well.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
