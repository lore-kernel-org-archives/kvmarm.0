From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v2 2/6] KVM: arm/arm64: arch_timer: Rely on the arch timer
 to parse the firmware tables
Date: Fri, 4 Mar 2016 10:32:38 +0000
Message-ID: <56D96446.2090107@arm.com>
References: <1455204804-31830-1-git-send-email-julien.grall@arm.com>
 <1455204804-31830-3-git-send-email-julien.grall@arm.com>
 <20160303193808.GK9634@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160303193808.GK9634@cbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, fu.wei@linaro.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, wei@redhat.com, al.stone@linaro.org, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 03/03/16 19:38, Christoffer Dall wrote:
> On Thu, Feb 11, 2016 at 03:33:20PM +0000, Julien Grall wrote:

[...]

>> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
>> index 6eb2c5d..3cdbefd 100644
>> --- a/drivers/clocksource/arm_arch_timer.c
>> +++ b/drivers/clocksource/arm_arch_timer.c
>> @@ -451,6 +451,8 @@ static struct arch_timer_kvm_info arch_timer_kvm_info;
>>
>>   struct arch_timer_kvm_info *arch_timer_get_kvm_info(void)
>>   {
>> +	arch_timer_kvm_info.virtual_irq = arch_timer_ppi[VIRT_PPI];
>> +
>
> it feels weird that we set this member on every retrieval of the pointer
> to the struct?
>
> wouldn't it be more natural to intialize the struct somewhere during
> init and then this function just returns a pointer to the struct?

True, I will move the initialization into arch_timer_common_init.

>
>>   	return &arch_timer_kvm_info;
>>   }
>>

[...]

>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>> index a669c6a..e4de549 100644
>> --- a/virt/kvm/arm/arch_timer.c
>> +++ b/virt/kvm/arm/arch_timer.c
>> @@ -17,7 +17,6 @@
>>    */
>>
>>   #include <linux/cpu.h>
>> -#include <linux/of_irq.h>
>>   #include <linux/kvm.h>
>>   #include <linux/kvm_host.h>
>>   #include <linux/interrupt.h>
>> @@ -375,45 +374,28 @@ static struct notifier_block kvm_timer_cpu_nb = {
>>   	.notifier_call = kvm_timer_cpu_notify,
>>   };
>>
>> -static const struct of_device_id arch_timer_of_match[] = {
>> -	{ .compatible	= "arm,armv7-timer",	},
>> -	{ .compatible	= "arm,armv8-timer",	},
>> -	{},
>> -};
>> -
>>   int kvm_timer_hyp_init(void)
>>   {
>> -	struct device_node *np;
>> -	unsigned int ppi;
>>   	struct arch_timer_kvm_info *info;
>>   	int err;
>>
>>   	info = arch_timer_get_kvm_info();
>>   	timecounter = &info->timecounter;
>>
>> -	np = of_find_matching_node(NULL, arch_timer_of_match);
>> -	if (!np) {
>> -		kvm_err("kvm_arch_timer: can't find DT node\n");
>> +	host_vtimer_irq = info->virtual_irq;
>> +	if (host_vtimer_irq <= 0) {
>> +		kvm_err("kvm_arch_timer: can't find virtual timer info or config virtual timer interrupt\n");
>
> I don't understand the difference between the two cases in this error
> message.
>
> How about: "Invalid virtual timer IRQ: %d\n" ?

I will update the error message.

>
>>   		return -ENODEV;
>>   	}
>>
>> -	ppi = irq_of_parse_and_map(np, 2);
>> -	if (!ppi) {
>> -		kvm_err("kvm_arch_timer: no virtual timer interrupt\n");
>> -		err = -EINVAL;
>> -		goto out;
>> -	}
>> -
>> -	err = request_percpu_irq(ppi, kvm_arch_timer_handler,
>> +	err = request_percpu_irq(host_vtimer_irq, kvm_arch_timer_handler,
>>   				 "kvm guest timer", kvm_get_running_vcpus());
>>   	if (err) {
>>   		kvm_err("kvm_arch_timer: can't request interrupt %d (%d)\n",
>> -			ppi, err);
>> +			host_vtimer_irq, err);
>>   		goto out;
>>   	}
>>
>> -	host_vtimer_irq = ppi;
>> -
>>   	err = __register_cpu_notifier(&kvm_timer_cpu_nb);
>>   	if (err) {
>>   		kvm_err("Cannot register timer CPU notifier\n");
>> @@ -426,14 +408,13 @@ int kvm_timer_hyp_init(void)
>>   		goto out_free;
>>   	}
>>
>> -	kvm_info("%s IRQ%d\n", np->name, ppi);
>> +	kvm_info("vtimer IRQ%d\n", host_vtimer_irq);
>
> is "vtimer" a known concept anywhere?  If not, can you use some known
> terms intead?

I will use "virtual timer".

>
>>   	on_each_cpu(kvm_timer_init_interrupt, NULL, 1);
>>
>>   	goto out;
>>   out_free:
>> -	free_percpu_irq(ppi, kvm_get_running_vcpus());
>> +	free_percpu_irq(host_vtimer_irq, kvm_get_running_vcpus());
>>   out:
>> -	of_node_put(np);
>>   	return err;
>>   }

Regards,

-- 
Julien Grall
