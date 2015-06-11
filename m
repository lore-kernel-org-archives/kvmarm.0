From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 07/10] KVM: arm/arm64: vgic: Allow HW interrupts to be
 queued to a guest
Date: Thu, 11 Jun 2015 10:44:02 +0100
Message-ID: <55795862.1050407@arm.com>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com>
 <1433783045-8002-8-git-send-email-marc.zyngier@arm.com>
 <55794A7A.2080306@arm.com> <557951C6.2090408@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0864653DA9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jun 2015 05:33:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yxRP4SCghphT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Jun 2015 05:33:26 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB2FF53D8D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jun 2015 05:33:26 -0400 (EDT)
In-Reply-To: <557951C6.2090408@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/11/2015 10:15 AM, Marc Zyngier wrote:
> On 11/06/15 09:44, Andre Przywara wrote:
>> On 06/08/2015 06:04 PM, Marc Zyngier wrote:
...
>>> @@ -1344,6 +1364,35 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>>>  	return level_pending;
>>>  }
>>>  
>>> +/* Return 1 if HW interrupt went from active to inactive, and 0 otherwise */
>>> +static int vgic_sync_hwirq(struct kvm_vcpu *vcpu, struct vgic_lr vlr)
>>> +{
>>> +	struct irq_phys_map *map;
>>> +	int ret;
>>> +
>>> +	if (!(vlr.state & LR_HW))
>>> +		return 0;
>>> +
>>> +	map = vgic_irq_map_search(vcpu, vlr.irq);
>>
>> I wonder if it's safe to rely on that mapping here. Are we sure that
>> this hasn't changed while the VCPU was running? If I got this correctly,
>> currently only vcpu_reset will actually add a map entry, but I guess in
>> the future there will be more users.
> 
> How can the guest interrupt change? This is HW, as far as the guest is
> concerned. An actual interrupt line. We don't reconfigure the HW live.

I was thinking about the rbtree mapping we introduced. There we map a
guest interrupt to a hardware interrupt. Are we sure that no one tears
down that mapping while we have an LR populated with this pair?
I am not talking about the timer here, but more about future users.

>> Also we rely on the irqdomain mapping to be still the same, but that is
>> probably a safe assumption.
> 
> Like I said before, this *cannot* change.

OK, got it.

> 
>> But I'd still find it more natural to use the hwirq number from the LR
>> at this point. Can't we use irq_find_mapping() here to learn Linux'
>> (current) irq number from that?
> 
> I think you're confused.
> 
> - The guest irq (vlr.irq) is entirely made up, and has no connection
> with reality. it is stable, and cannot change during the lifetime of the
> guest (think of it as a HW irq line).
> 
> - The host hwirq (vlr.hwirq) is stable as well, for the same reason.
> 
> - The Linux IRQ cannot change because we've been given it by the kernel,
> and that's what we use for *everything* as far as the kernel is
> concerned. Its mapping to hwirq is stable as well because this is how we
> talk to the HW.

Not disputing any of them, but:

> - irq_find_mapping gives you the *reverse* mapping (from hwirq to Linux
> irq), and for that to work, you need the domain on which you want to
> apply the translation. This is only useful when actually taking the
> interrupt (i.e. in an interrupt controller driver). I can't see how that
> could make sense here.

So if the guest has acked/EOIed it's IRQ, the GIC at the same time
acked/EOIed the hardware IRQ it found in the LR. Now we assume that this
is the very same as the HW IRQ we found doing our rbtree traversal.
I just wanted to be sure that this is always true and that this mapping
didn't change while the VCPU was running.
If you are sure of this, fine, I was just concerned that someone breaks
this assumption in the future by more dynamically mapping/unmapping
entries (say some irq forwarding user) and we will not notice.

Cheers,
Andre.

> 
> The purpose of this mapping is to, given the guest irq (because that's
> what we inject), what the other values are:
> - hwirq: to provide GICH with the interrupt to deactivate
> - Linux irq: to control the active state through the irqchip state API.
> 
>> Or am I too paranoid here?
> 
> Hope it makes more sense to you now.
> 
> Thanks,
> 
> 	M.
> 
