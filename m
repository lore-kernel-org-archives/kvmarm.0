From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 2/2] KVM: arm/arm64: Route vtimer events to user space
Date: Thu, 22 Sep 2016 13:35:53 +0100
Message-ID: <57E3D029.90603@arm.com>
References: <1474283695-212421-1-git-send-email-agraf@suse.de>
 <1474283695-212421-3-git-send-email-agraf@suse.de> <57DFFAD3.3080009@arm.com>
 <0960d2a7-6100-3212-c544-d5377df34d57@suse.de> <57E0FF95.7040305@arm.com>
 <57E3CF5A.3050608@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <57E3CF5A.3050608@suse.de>
Sender: kvm-owner@vger.kernel.org
To: Alexander Graf <agraf@suse.de>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, drjones@redhat.com, christoffer.dall@linaro.org, peter.maydell@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 22/09/16 13:32, Alexander Graf wrote:
> On 09/20/2016 11:21 AM, Marc Zyngier wrote:
>> On 19/09/16 18:39, Alexander Graf wrote:
>>>
>>> On 19.09.16 16:48, Marc Zyngier wrote:
>>>
>>>>> +
>>>>> +		/*
>>>>> +		 * So we can just explicitly mask or unmask the IRQ, gaining
>>>>> +		 * more compatibility with oddball irq controllers.
>>>>> +		 */
>>>>> +		if (phys_active)
>>>>> +			disable_percpu_irq(host_vtimer_irq);
>>>>> +		else
>>>>> +			enable_percpu_irq(host_vtimer_irq, 0);
>>>> Since you are now targeting random irqchips (as opposed to a GIC
>>>> specifically), what guarantees that the timer is a per-cpu IRQ?
>>> This is the host interrupt controller - and we're already using percpu
>>> irqs on it :). Also as it happens the RPi has them percpu (anything else
>>> wouldn't make sense...).
>> Not really. The RPi is faking percpu interrupts just to have some level
>> of compatibility with the host arch timer driver. But nonetheless, if
>> you're opening the code to something else than a GIC, then you should
>> check that the interrupt you're getting is percpu.
> 
> This should already be covered by request_percpu_irq() in 
> kvm_timer_hyp_init(), no?

Ah, true. Ignore me, then.

	M.
-- 
Jazz is not dead. It just smells funny...
