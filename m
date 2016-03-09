From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v3 2/9] clocksource: arm_arch_timer: Extend
 arch_timer_kvm_info to get the virtual IRQ
Date: Wed, 9 Mar 2016 12:52:08 +0700
Message-ID: <56DFBA08.7060000@arm.com>
References: <1457436573-6180-1-git-send-email-julien.grall@arm.com>
 <1457436573-6180-3-git-send-email-julien.grall@arm.com>
 <20160309032713.GF26583@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160309032713.GF26583@lvm>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, fu.wei@linaro.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, wei@redhat.com, al.stone@linaro.org, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 09/03/2016 10:27, Christoffer Dall wrote:
> On Tue, Mar 08, 2016 at 11:29:26AM +0000, Julien Grall wrote:
>> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
>> index b7ab588..d8887f3 100644
>> --- a/drivers/clocksource/arm_arch_timer.c
>> +++ b/drivers/clocksource/arm_arch_timer.c
>> @@ -701,6 +701,8 @@ static void __init arch_timer_common_init(void)
>>   	arch_timer_banner(arch_timers_present);
>>   	arch_counter_register(arch_timers_present);
>>   	arch_timer_arch_init();
>> +
>> +	arch_timer_kvm_info.virtual_irq = arch_timer_ppi[VIRT_PPI];
>
> why is this in common_init and not just in init?

I thought we wanted to initialize virtual_irq for both the system 
registers timer and the memory timer. Although, as talked IRL, KVM 
mandates system registers timer. So I will initialize the virtual_irq in 
arch_timer_init.

Cheers,

-- 
Julien Grall
