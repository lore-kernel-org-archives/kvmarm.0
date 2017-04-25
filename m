From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH V9 1/3] irq: Allow to pass the IRQF_TIMER flag with percpu
 irq request
Date: Tue, 25 Apr 2017 08:38:56 +0100
Message-ID: <16042494-2e67-e1a5-b9f6-af57e349d8a7@arm.com>
References: <1493042494-14057-1-git-send-email-daniel.lezcano@linaro.org>
 <398f3f3d-c567-0f1f-1a43-9b8d5805d5fd@arm.com> <20170424185909.GD2137@mai>
 <92e2a022-93d4-d4f3-78af-c9b5d51bb867@arm.com> <20170424195948.GE2137@mai>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170424195948.GE2137@mai>
Sender: kvm-owner@vger.kernel.org
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: tglx@linutronix.de, Mark Rutland <mark.rutland@arm.com>, Vineet Gupta <vgupta@synopsys.com>, Patrice Chotard <patrice.chotard@st.com>, Kukjin Kim <kgene@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Javier Martinez Canillas <javier@osg.samsung.com>, Christoffer Dall <christoffer.dall@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org, kernel@stlinux.com, linux-samsung-soc@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 24/04/17 20:59, Daniel Lezcano wrote:
> On Mon, Apr 24, 2017 at 08:14:54PM +0100, Marc Zyngier wrote:
>> On 24/04/17 19:59, Daniel Lezcano wrote:
>>> On Mon, Apr 24, 2017 at 07:46:43PM +0100, Marc Zyngier wrote:
>>>> On 24/04/17 15:01, Daniel Lezcano wrote:
>>>>> In the next changes, we track when the interrupts occur in order to
>>>>> statistically compute when is supposed to happen the next interrupt.
>>>>>
>>>>> In all the interruptions, it does not make sense to store the timer interrupt
>>>>> occurences and try to predict the next interrupt as when know the expiration
>>>>> time.
>>>>>
>>>>> The request_irq() has a irq flags parameter and the timer drivers use it to
>>>>> pass the IRQF_TIMER flag, letting us know the interrupt is coming from a timer.
>>>>> Based on this flag, we can discard these interrupts when tracking them.
>>>>>
>>>>> But, the API request_percpu_irq does not allow to pass a flag, hence specifying
>>>>> if the interrupt type is a timer.
>>>>>
>>>>> Add a function request_percpu_irq_flags() where we can specify the flags. The
>>>>> request_percpu_irq() function is changed to be a wrapper to
>>>>> request_percpu_irq_flags() passing a zero flag parameter.
>>>>>
>>>>> Change the timers using request_percpu_irq() to use request_percpu_irq_flags()
>>>>> instead with the IRQF_TIMER flag set.
>>>>>
>>>>> For now, in order to prevent a misusage of this parameter, only the IRQF_TIMER
>>>>> flag (or zero) is a valid parameter to be passed to the
>>>>> request_percpu_irq_flags() function.
>>>>
>>>> [...]
>>>>
>>>>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>>>>> index 35d7100..602e0a8 100644
>>>>> --- a/virt/kvm/arm/arch_timer.c
>>>>> +++ b/virt/kvm/arm/arch_timer.c
>>>>> @@ -523,8 +523,9 @@ int kvm_timer_hyp_init(void)
>>>>>  		host_vtimer_irq_flags = IRQF_TRIGGER_LOW;
>>>>>  	}
>>>>>  
>>>>> -	err = request_percpu_irq(host_vtimer_irq, kvm_arch_timer_handler,
>>>>> -				 "kvm guest timer", kvm_get_running_vcpus());
>>>>> +	err = request_percpu_irq_flags(host_vtimer_irq, kvm_arch_timer_handler,
>>>>> +				       IRQF_TIMER, "kvm guest timer",
>>>>> +				       kvm_get_running_vcpus());
>>>>>  	if (err) {
>>>>>  		kvm_err("kvm_arch_timer: can't request interrupt %d (%d)\n",
>>>>>  			host_vtimer_irq, err);
>>>>>
>>>>
>>>> How is that useful? This timer is controlled by the guest OS, and not
>>>> the host kernel. Can you explain how you intend to make use of that
>>>> information in this case?
>>>
>>> Isn't it a source of interruption on the host kernel?
>>
>> Only to cause an exit of the VM, and not under the control of the host.
>> This isn't triggering any timer related action on the host code either.
>>
>> Your patch series seems to assume some kind of predictability of the
>> timer interrupt, which can make sense on the host. Here, this interrupt
>> is shared among *all* guests running on this system.
>>
>> Maybe you could explain why you think this interrupt is relevant to what
>> you're trying to achieve?
> 
> If this interrupt does not happen on the host, we don't care.

All interrupts happen on the host. There is no such thing as a HW 
interrupt being directly delivered to a guest (at least so far). The 
timer is under control of the guest, which uses as it sees fit. When 
the HW timer expires, the interrupt fires on the host, which re-inject 
the interrupt in the guest.

> The flag IRQF_TIMER is used by the spurious irq handler in the try_one_irq()
> function. However the per cpu timer interrupt will be discarded in the function
> before because it is per cpu.

Right. That's not because this is a timer, but because it is per-cpu. 
So why do we need this IRQF_TIMER flag, instead of fixing try_one_irq()?

> IMO, for consistency reason, adding the IRQF_TIMER makes sense. Other than
> that, as the interrupt is not happening on the host, this flag won't be used.
> 
> Do you want to drop this change?

No, I'd like to understand the above. Why isn't the following patch 
doing the right thing?

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 061ba7eed4ed..a4a81c6c7602 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -72,6 +72,7 @@ static int try_one_irq(struct irq_desc *desc, bool force)
 	 * marked polled are excluded from polling.
 	 */
 	if (irq_settings_is_per_cpu(desc) ||
+	    irq_settings_is_per_cpu_devid(desc) ||
 	    irq_settings_is_nested_thread(desc) ||
 	    irq_settings_is_polled(desc))
 		goto out;

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
