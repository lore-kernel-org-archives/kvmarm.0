From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 5/6] irqchip: GICv3: Don't deactivate interrupts forwarded
 to a guest
Date: Wed, 12 Aug 2015 17:51:58 +0200
Message-ID: <55CB6B9E.9020900@linaro.org>
References: <1436447951-22357-1-git-send-email-marc.zyngier@arm.com>
 <1436447951-22357-6-git-send-email-marc.zyngier@arm.com>
 <55C9C860.4020107@linaro.org> <55CB5617.1030901@arm.com>
 <55CB61C2.3010306@linaro.org> <55CB68E3.8020508@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDA0D5AD08
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2015 11:39:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QBptlUf0Bcim for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Aug 2015 11:39:34 -0400 (EDT)
Received: from mail-wi0-f170.google.com (mail-wi0-f170.google.com
 [209.85.212.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C26675ACFE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2015 11:39:34 -0400 (EDT)
Received: by wicne3 with SMTP id ne3so224195225wic.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2015 08:52:40 -0700 (PDT)
In-Reply-To: <55CB68E3.8020508@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 08/12/2015 05:40 PM, Marc Zyngier wrote:
> On 12/08/15 16:09, Eric Auger wrote:
>> On 08/12/2015 04:20 PM, Marc Zyngier wrote:
>>> On 11/08/15 11:03, Eric Auger wrote:
>>>> On 07/09/2015 03:19 PM, Marc Zyngier wrote:
>>>>> Commit 0a4377de3056 ("genirq: Introduce irq_set_vcpu_affinity() to
>>>>> target an interrupt to a VCPU") added just what we needed at the
>>>>> lowest level to allow an interrupt to be deactivated by a guest.
>>>>>
>>>>> When such a request reaches the GIC, it knows it doesn't need to
>>>>> perform the deactivation anymore, and can safely leave the guest
>>>>> do its magic. This of course requires additional support in both
>>>>> VFIO and KVM.
>>>>>
>>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>>> ---
>>>>>  drivers/irqchip/irq-gic-v3.c | 29 +++++++++++++++++++++++++++--
>>>>>  1 file changed, 27 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
>>>>> index e02592b..a1ca9e6 100644
>>>>> --- a/drivers/irqchip/irq-gic-v3.c
>>>>> +++ b/drivers/irqchip/irq-gic-v3.c
>>>>> @@ -70,6 +70,11 @@ static inline int gic_irq_in_rdist(struct irq_data *d)
>>>>>  	return gic_irq(d) < 32;
>>>>>  }
>>>>>  
>>>>> +static inline bool forwarded_irq(struct irq_data *d)
>>>>> +{
>>>>> +	return d->handler_data != NULL;
>>>>> +}
>>>>> +
>>>>>  static inline void __iomem *gic_dist_base(struct irq_data *d)
>>>>>  {
>>>>>  	if (gic_irq_in_rdist(d))	/* SGI+PPI -> SGI_base for this CPU */
>>>>> @@ -231,6 +236,12 @@ static void gic_poke_irq(struct irq_data *d, u32 offset)
>>>>>  static void gic_mask_irq(struct irq_data *d)
>>>>>  {
>>>>>  	gic_poke_irq(d, GICD_ICENABLER);
>>>>> +	/*
>>>>> +	 * When masking a forwarded interrupt, make sure it is
>>>>> +	 * deactivated as well.
>>>> To me it is not straightforward to understand why a forwarded IRQ would
>>>> need to be DIR'ed when masked. This is needed because of the disable_irq
>>>> optimisation, I would add a related comment.
>>>>
>>>
>>> The lazy disable_irq is just an optimization.
>> yes that's true but it causes a real problem here since although you
>> disabled the IRQ, a new one can show up, we do not call the actual
>> handler (that was supposed to forward it to the guest) but still you
>> expect the guest to complete it. Practically that's why the host must
>> take in charge the deactivation in that case, and this happens during
>> the masking with this implementation.
> 
> Yeah, I see what you mean. If we end-up here with an active interrupt,
> that's because the lazy interrupt masking has been used, and we need to
> fix up things.
> 
>>>
>>> The real reason is that if we mask an interrupt on the host, it is
>>> because we don't want the guest to process it at all. There is three cases:
>>>
>>> 1) The interrupt was inactive: no problem
>>> 2) The interrupt was active, but not presented to the guest yet: no
>>> problem either. The interrupt will be taken again on unmask.
>>> 3) The interrupt was active and presented to the guest: we might get a
>>> double deactivate, which shouldn't be a big deal (but mostly should not
>>> occur at all).
>>>
>>> Would something like this make sense?
>> yes makes sense. The only thing that scares me a bit is 3: when
>> masking/DIR an edge irq (#n) we can have the same new physical IRQ
>> showing up when unmasking (#n+1); when guest deactivates the #nth
>> virtual IRQ it is going to DIR #n+1 physical IRQ.
> 
> That bit is not worrying me too much for a few reasons reasons:
> - You normally don't mask a forwarded interrupt. You only do that on
> specific events like guest termination. At that point, it doesn't matter
> anymore.
> - Edge interrupts can always be coalesced. So getting one event instead
> of two is not a problem.
> - Deactivation (specially on EOI from a guest) is not "refcounted". It
> just clears the active bit.
> 
>> Also with VGIC state machine, we must be attention not to inject the
>> second forwarded edge irq while there is one programmed in the LR. We
>> said "it comes from the HW so it must be true"? Not safe anymore here ...
> 
> I don't believe this is a problem. You should never end-up masking the
> interrupt if you don't intend to tear it down (this is why we have the
> active bit - to avoid masking thing in normal operations).

OK
> 
>>
>>>
>>> On a related note, I wonder if we need to mark the interrupt pending if
>>> it is configured as edge. Otherwise, we could loose an interrupt in case
>>> 2 (mask, deactivate, unmask, oh look nothing triggers). Thoughts?
>> Yes I think this makes sense indeed. Definitively this one will be lost.
> 
> Depends. If we are to restore a working interrupt flow, then we need it.
> If we just mask to allow an interrupt to be "unforwarded", then we do
> not have to care.

yes. I am currently focused on unforwarding and effectively that works
fine since, as you explained before, I am tearing down the system.

Best Regards

Eric
> 
> Thanks,
> 
> 	M.
> 
