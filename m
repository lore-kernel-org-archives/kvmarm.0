From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 5/6] irqchip: GICv3: Don't deactivate interrupts forwarded
 to a guest
Date: Wed, 12 Aug 2015 17:09:54 +0200
Message-ID: <55CB61C2.3010306@linaro.org>
References: <1436447951-22357-1-git-send-email-marc.zyngier@arm.com> <1436447951-22357-6-git-send-email-marc.zyngier@arm.com> <55C9C860.4020107@linaro.org> <55CB5617.1030901@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55CB5617.1030901@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Jiang Liu <jiang.liu@linux.intel.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 08/12/2015 04:20 PM, Marc Zyngier wrote:
> On 11/08/15 11:03, Eric Auger wrote:
>> On 07/09/2015 03:19 PM, Marc Zyngier wrote:
>>> Commit 0a4377de3056 ("genirq: Introduce irq_set_vcpu_affinity() to
>>> target an interrupt to a VCPU") added just what we needed at the
>>> lowest level to allow an interrupt to be deactivated by a guest.
>>>
>>> When such a request reaches the GIC, it knows it doesn't need to
>>> perform the deactivation anymore, and can safely leave the guest
>>> do its magic. This of course requires additional support in both
>>> VFIO and KVM.
>>>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>  drivers/irqchip/irq-gic-v3.c | 29 +++++++++++++++++++++++++++--
>>>  1 file changed, 27 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
>>> index e02592b..a1ca9e6 100644
>>> --- a/drivers/irqchip/irq-gic-v3.c
>>> +++ b/drivers/irqchip/irq-gic-v3.c
>>> @@ -70,6 +70,11 @@ static inline int gic_irq_in_rdist(struct irq_data *d)
>>>  	return gic_irq(d) < 32;
>>>  }
>>>  
>>> +static inline bool forwarded_irq(struct irq_data *d)
>>> +{
>>> +	return d->handler_data != NULL;
>>> +}
>>> +
>>>  static inline void __iomem *gic_dist_base(struct irq_data *d)
>>>  {
>>>  	if (gic_irq_in_rdist(d))	/* SGI+PPI -> SGI_base for this CPU */
>>> @@ -231,6 +236,12 @@ static void gic_poke_irq(struct irq_data *d, u32 offset)
>>>  static void gic_mask_irq(struct irq_data *d)
>>>  {
>>>  	gic_poke_irq(d, GICD_ICENABLER);
>>> +	/*
>>> +	 * When masking a forwarded interrupt, make sure it is
>>> +	 * deactivated as well.
>> To me it is not straightforward to understand why a forwarded IRQ would
>> need to be DIR'ed when masked. This is needed because of the disable_irq
>> optimisation, I would add a related comment.
>>
> 
> The lazy disable_irq is just an optimization.
yes that's true but it causes a real problem here since although you
disabled the IRQ, a new one can show up, we do not call the actual
handler (that was supposed to forward it to the guest) but still you
expect the guest to complete it. Practically that's why the host must
take in charge the deactivation in that case, and this happens during
the masking with this implementation.
> 
> The real reason is that if we mask an interrupt on the host, it is
> because we don't want the guest to process it at all. There is three cases:
> 
> 1) The interrupt was inactive: no problem
> 2) The interrupt was active, but not presented to the guest yet: no
> problem either. The interrupt will be taken again on unmask.
> 3) The interrupt was active and presented to the guest: we might get a
> double deactivate, which shouldn't be a big deal (but mostly should not
> occur at all).
> 
> Would something like this make sense?
yes makes sense. The only thing that scares me a bit is 3: when
masking/DIR an edge irq (#n) we can have the same new physical IRQ
showing up when unmasking (#n+1); when guest deactivates the #nth
virtual IRQ it is going to DIR #n+1 physical IRQ.

Also with VGIC state machine, we must be attention not to inject the
second forwarded edge irq while there is one programmed in the LR. We
said "it comes from the HW so it must be true"? Not safe anymore here ...

> 
> On a related note, I wonder if we need to mark the interrupt pending if
> it is configured as edge. Otherwise, we could loose an interrupt in case
> 2 (mask, deactivate, unmask, oh look nothing triggers). Thoughts?
Yes I think this makes sense indeed. Definitively this one will be lost.

Eric
> 
> Thanks,
> 
> 	M.
> 

