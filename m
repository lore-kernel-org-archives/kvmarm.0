From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v4 07/11] KVM: arm/arm64: vgic: Allow HW interrupts to be
 queued to a guest
Date: Wed, 30 Sep 2015 15:06:32 +0100
Message-ID: <560BEC68.4010400@arm.com>
References: <1438962347-17541-1-git-send-email-marc.zyngier@arm.com>
 <1438962347-17541-8-git-send-email-marc.zyngier@arm.com>
 <5602E778.3080004@arm.com> <20150929134445.GF9002@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EDC6412A6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2015 10:03:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uZH66I-FiIwo for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Sep 2015 10:03:53 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15FB941049
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2015 10:03:52 -0400 (EDT)
In-Reply-To: <20150929134445.GF9002@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 29/09/15 14:44, Christoffer Dall wrote:
> On Wed, Sep 23, 2015 at 06:55:04PM +0100, Andre Przywara wrote:
>> Salut Marc,
>>
>> I know that this patch is already merged, but ....
>>
>> On 07/08/15 16:45, Marc Zyngier wrote:
>>> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
>>> index 51c9900..9d009d2 100644
>> ...
>>> @@ -1364,6 +1397,39 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>>>  	return level_pending;
>>>  }
>>>  
>>> +/*
>>> + * Save the physical active state, and reset it to inactive.
>>> + *
>>> + * Return 1 if HW interrupt went from active to inactive, and 0 otherwise.
>>> + */
>>> +static int vgic_sync_hwirq(struct kvm_vcpu *vcpu, struct vgic_lr vlr)
>>> +{
>>> +	struct irq_phys_map *map;
>>> +	int ret;
>>> +
>>> +	if (!(vlr.state & LR_HW))
>>> +		return 0;
>>> +
>>> +	map = vgic_irq_map_search(vcpu, vlr.irq);
>>> +	BUG_ON(!map || !map->active);
>>> +
>>> +	ret = irq_get_irqchip_state(map->irq,
>>> +				    IRQCHIP_STATE_ACTIVE,
>>> +				    &map->active);
>>> +
>>> +	WARN_ON(ret);
>>> +
>>> +	if (map->active) {
>>> +		ret = irq_set_irqchip_state(map->irq,
>>> +					    IRQCHIP_STATE_ACTIVE,
>>> +					    false);
>>> +		WARN_ON(ret);
>>> +		return 0;
>>> +	}
>>> +
>>> +	return 1;
>>> +}
>>> +
>>>  /* Sync back the VGIC state after a guest run */
>>>  static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>>>  {
>>> @@ -1378,14 +1444,31 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>>>  	elrsr = vgic_get_elrsr(vcpu);
>>>  	elrsr_ptr = u64_to_bitmask(&elrsr);
>>>  
>>> -	/* Clear mappings for empty LRs */
>>> -	for_each_set_bit(lr, elrsr_ptr, vgic->nr_lr) {
>>> +	/* Deal with HW interrupts, and clear mappings for empty LRs */
>>> +	for (lr = 0; lr < vgic->nr_lr; lr++) {
>>>  		struct vgic_lr vlr;
>>>  
>>> -		if (!test_and_clear_bit(lr, vgic_cpu->lr_used))
>>> +		if (!test_bit(lr, vgic_cpu->lr_used))
>>>  			continue;
>>>  
>>>  		vlr = vgic_get_lr(vcpu, lr);
>>> +		if (vgic_sync_hwirq(vcpu, vlr)) {
>>> +			/*
>>> +			 * So this is a HW interrupt that the guest
>>> +			 * EOI-ed. Clean the LR state and allow the
>>> +			 * interrupt to be sampled again.
>>> +			 */
>>> +			vlr.state = 0;
>>> +			vlr.hwirq = 0;
>>> +			vgic_set_lr(vcpu, lr, vlr);
>>> +			vgic_irq_clear_queued(vcpu, vlr.irq);
>>
>> Isn't this line altering common VGIC state without holding the lock?
>> Eric removed the coarse dist->lock around the whole
>> __kvm_vgic_sync_hwstate() function, we take it now in
>> vgic_process_maintenance(), but don't hold it here AFAICT.
>> As long as we are only dealing with private timer IRQs this is probably
>> not a problem, but the IRQ number could be a SPI as well, right?
>>
> I don't see a problematic race with this though, as all we're doing is
> to clear a bit in a bitmap, which is always checked atomically, so
> adding a lock around this really doesn't change anything as far as I can
> tell.

Indeed I found a similar comment in some older revisions of the code.

But isn't it that other code holding the lock (thinking about
kvm_vgic_flush_hwstate() in particular) assumes that no-one else tinkers
with the VGIC state while it holds the lock?
So couldn't we (potentially) run into inconsistent state because we
cleared the queued bit while the flushing code runs over all interrupts?
Maybe not in this particular case, but in general?

Haven't looked at your new series yet, but will do this ASAP.

Cheers,
Andre.

> 
> Nevertheless, my rework series also addresses this.
> 
> -Christoffer
> 
