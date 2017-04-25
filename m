From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH V9 1/3] irq: Allow to pass the IRQF_TIMER flag with percpu
 irq request
Date: Tue, 25 Apr 2017 10:10:12 +0100
Message-ID: <f840e9d2-8aac-dc1d-6468-44f7658b55b1@arm.com>
References: <1493042494-14057-1-git-send-email-daniel.lezcano@linaro.org>
 <398f3f3d-c567-0f1f-1a43-9b8d5805d5fd@arm.com> <20170424185909.GD2137@mai>
 <92e2a022-93d4-d4f3-78af-c9b5d51bb867@arm.com> <20170424195948.GE2137@mai>
 <16042494-2e67-e1a5-b9f6-af57e349d8a7@arm.com> <20170425083451.GA16888@mai>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65F1340C9A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Apr 2017 05:07:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E0E2nVM6J8XS for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Apr 2017 05:07:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A07D40CD5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Apr 2017 05:07:27 -0400 (EDT)
In-Reply-To: <20170425083451.GA16888@mai>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-samsung-soc@vger.kernel.org, kernel@stlinux.com, kvm@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>, Patrice Chotard <patrice.chotard@st.com>, Krzysztof Kozlowski <krzk@kernel.org>, linux-kernel@vger.kernel.org, Javier Martinez Canillas <javier@osg.samsung.com>, Kukjin Kim <kgene@kernel.org>, linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, tglx@linutronix.de, linux-snps-arc@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 25/04/17 09:34, Daniel Lezcano wrote:
> On Tue, Apr 25, 2017 at 08:38:56AM +0100, Marc Zyngier wrote:
>> On 24/04/17 20:59, Daniel Lezcano wrote:
>>> On Mon, Apr 24, 2017 at 08:14:54PM +0100, Marc Zyngier wrote:
>>>> On 24/04/17 19:59, Daniel Lezcano wrote:
>>>>> On Mon, Apr 24, 2017 at 07:46:43PM +0100, Marc Zyngier wrote:
>>>>>> On 24/04/17 15:01, Daniel Lezcano wrote:
>>>>>>> In the next changes, we track when the interrupts occur in order to
>>>>>>> statistically compute when is supposed to happen the next interrupt.
>>>>>>>
>>>>>>> In all the interruptions, it does not make sense to store the timer interrupt
>>>>>>> occurences and try to predict the next interrupt as when know the expiration
>>>>>>> time.
>>>>>>>
>>>>>>> The request_irq() has a irq flags parameter and the timer drivers use it to
>>>>>>> pass the IRQF_TIMER flag, letting us know the interrupt is coming from a timer.
>>>>>>> Based on this flag, we can discard these interrupts when tracking them.
>>>>>>>
>>>>>>> But, the API request_percpu_irq does not allow to pass a flag, hence specifying
>>>>>>> if the interrupt type is a timer.
>>>>>>>
>>>>>>> Add a function request_percpu_irq_flags() where we can specify the flags. The
>>>>>>> request_percpu_irq() function is changed to be a wrapper to
>>>>>>> request_percpu_irq_flags() passing a zero flag parameter.
>>>>>>>
>>>>>>> Change the timers using request_percpu_irq() to use request_percpu_irq_flags()
>>>>>>> instead with the IRQF_TIMER flag set.
>>>>>>>
>>>>>>> For now, in order to prevent a misusage of this parameter, only the IRQF_TIMER
>>>>>>> flag (or zero) is a valid parameter to be passed to the
>>>>>>> request_percpu_irq_flags() function.
>>>>>>
>>>>>> [...]
>>>>>>
>>>>>>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>>>>>>> index 35d7100..602e0a8 100644
>>>>>>> --- a/virt/kvm/arm/arch_timer.c
>>>>>>> +++ b/virt/kvm/arm/arch_timer.c
>>>>>>> @@ -523,8 +523,9 @@ int kvm_timer_hyp_init(void)
>>>>>>>  		host_vtimer_irq_flags = IRQF_TRIGGER_LOW;
>>>>>>>  	}
>>>>>>>  
>>>>>>> -	err = request_percpu_irq(host_vtimer_irq, kvm_arch_timer_handler,
>>>>>>> -				 "kvm guest timer", kvm_get_running_vcpus());
>>>>>>> +	err = request_percpu_irq_flags(host_vtimer_irq, kvm_arch_timer_handler,
>>>>>>> +				       IRQF_TIMER, "kvm guest timer",
>>>>>>> +				       kvm_get_running_vcpus());
>>>>>>>  	if (err) {
>>>>>>>  		kvm_err("kvm_arch_timer: can't request interrupt %d (%d)\n",
>>>>>>>  			host_vtimer_irq, err);
>>>>>>>
>>>>>>
>>>>>> How is that useful? This timer is controlled by the guest OS, and not
>>>>>> the host kernel. Can you explain how you intend to make use of that
>>>>>> information in this case?
>>>>>
>>>>> Isn't it a source of interruption on the host kernel?
>>>>
>>>> Only to cause an exit of the VM, and not under the control of the host.
>>>> This isn't triggering any timer related action on the host code either.
>>>>
>>>> Your patch series seems to assume some kind of predictability of the
>>>> timer interrupt, which can make sense on the host. Here, this interrupt
>>>> is shared among *all* guests running on this system.
>>>>
>>>> Maybe you could explain why you think this interrupt is relevant to what
>>>> you're trying to achieve?
>>>
>>> If this interrupt does not happen on the host, we don't care.
>>
>> All interrupts happen on the host. There is no such thing as a HW 
>> interrupt being directly delivered to a guest (at least so far). The 
>> timer is under control of the guest, which uses as it sees fit. When 
>> the HW timer expires, the interrupt fires on the host, which re-inject 
>> the interrupt in the guest.
> 
> Ah, thanks for the clarification. Interesting.
> 
> How can the host know which guest to re-inject the interrupt?

The timer can only fire when the vcpu is running. If it is not running,
a software timer is queued, with a pointer to the vcpu struct.

>>> The flag IRQF_TIMER is used by the spurious irq handler in the try_one_irq()
>>> function. However the per cpu timer interrupt will be discarded in the function
>>> before because it is per cpu.
>>
>> Right. That's not because this is a timer, but because it is per-cpu. 
>> So why do we need this IRQF_TIMER flag, instead of fixing try_one_irq()?
> 
> When a timer is not per cpu, (eg. request_irq), we need this flag, no?

Sure, but in this series, they all seem to be per-cpu.

>>> IMO, for consistency reason, adding the IRQF_TIMER makes sense. Other than
>>> that, as the interrupt is not happening on the host, this flag won't be used.
>>>
>>> Do you want to drop this change?
>>
>> No, I'd like to understand the above. Why isn't the following patch 
>> doing the right thing?
> 
> Actually, the explanation is in the next patch of the series (2/3)
> 
> [ ... ]
> 
> +static inline void setup_timings(struct irq_desc *desc, struct irqaction *act)
> +{
> +	/*
> +	 * We don't need the measurement because the idle code already
> +	 * knows the next expiry event.
> +	 */
> +	if (act->flags & __IRQF_TIMER)
> +		return;

And that's where this is really wrong for the KVM guest timer. As I
said, this timer is under complete control of the guest, and the rest of
the system doesn't know about it. KVM itself will only find out when the
vcpu does a VM exit for a reason or another, and will just save/restore
the state in order to be able to give the timer to another guest.

The idle code is very much *not* aware of anything concerning that guest
timer.

> +
> +	desc->istate |= IRQS_TIMINGS;
> +}
> 
> [ ... ]
> 
> +/*
> + * The function record_irq_time is only called in one place in the
> + * interrupts handler. We want this function always inline so the code
> + * inside is embedded in the function and the static key branching
> + * code can act at the higher level. Without the explicit
> + * __always_inline we can end up with a function call and a small
> + * overhead in the hotpath for nothing.
> + */
> +static __always_inline void record_irq_time(struct irq_desc *desc)
> +{
> +	if (!static_branch_likely(&irq_timing_enabled))
> +		return;
> +
> +	if (desc->istate & IRQS_TIMINGS) {
> +		struct irq_timings *timings = this_cpu_ptr(&irq_timings);
> +
> +		timings->values[timings->count & IRQ_TIMINGS_MASK] =
> +			irq_timing_encode(local_clock(),
> +					  irq_desc_get_irq(desc));
> +
> +		timings->count++;
> +	}
> +}
> 
> [ ... ]
> 
> The purpose is to predict the next event interrupts on the system which are
> source of wake up. For now, this patchset is focused on interrupts (discarding
> timer interrupts).
> 
> The following article gives more details: https://lwn.net/Articles/673641/
> 
> When the interrupt is setup, we tag it except if it is a timer. So with this
> patch there is another usage of the IRQF_TIMER where we will be ignoring
> interrupt coming from a timer.
> 
> As the timer interrupt is delivered to the host, we should not measure it as it
> is a timer and set this flag.
> 
> The needed information is: "what is the earliest VM timer?". If this
> information is already available then there is nothing more to do, otherwise we
> should add it in the future.

This information is not readily available. You can only find it when it
is too late (timer has already fired) or when it is not relevant anymore
(guest is sleeping and we've queued a SW timer for it).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
