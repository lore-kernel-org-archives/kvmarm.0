From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v3 1/3] KVM: arm/arm64: vgic: Make vgic_irq->irq_lock a
 raw_spinlock
Date: Fri, 1 Feb 2019 17:55:43 +0000
Message-ID: <6eeb2d94-cdda-006b-f32f-7857b61b3eaa@arm.com>
References: <1546873577-13895-1-git-send-email-julien.thierry@arm.com>
 <1546873577-13895-2-git-send-email-julien.thierry@arm.com>
 <fa628aae-68eb-7140-0533-367cafa26ed6@arm.com>
 <20190201173650.GC29111@jcartwri.amer.corp.natinst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190201173650.GC29111@jcartwri.amer.corp.natinst.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Cartwright <julia@ni.com>
Cc: Julien Thierry <julien.thierry@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "bigeasy@linutronix.de" <bigeasy@linutronix.de>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Julia,

On 01/02/2019 17:36, Julia Cartwright wrote:
> On Fri, Feb 01, 2019 at 03:30:58PM +0000, Julien Grall wrote:
>> Hi Julien,
>>
>> On 07/01/2019 15:06, Julien Thierry wrote:
>>> vgic_irq->irq_lock must always be taken with interrupts disabled as
>>> it is used in interrupt context.
>>
>> I am a bit confused with the reason here. The code mention that ap_list_lock
>> could be taken from the timer interrupt handler interrupt. I assume it
>> speaks about the handler kvm_arch_timer_handler. Looking at the
>> configuration of the interrupt, the flag IRQF_NO_THREAD is not set, so the
>> interrupt should be threaded when CONFIG_PREEMPT_FULL is set. If my
>> understanding is correct, this means the interrupt thread would sleep if it
>> takes the spinlock.
>>
>> Did I miss anything? Do you have an exact path where the vGIC is actually
>> called from an interrupt context?
> 
> The part you're missing is that percpu interrupts are not force
> threaded:
> 
> 	static int irq_setup_forced_threading(struct irqaction *new)
> 	{
> 		if (!force_irqthreads)
> 			return 0;
> 		if (new->flags & (IRQF_NO_THREAD | IRQF_PERCPU | IRQF_ONESHOT))
> 			return 0;
> 	
> 		/* ...*/
> 	}

Thank you for the pointer! I think it would be worth mentioning in the commit 
message that per-cpu interrupts are not threaded.

Best regards,

-- 
Julien Grall
