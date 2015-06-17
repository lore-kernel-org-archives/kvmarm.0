From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 07/10] KVM: arm/arm64: vgic: Allow HW interrupts to be
 queued to a guest
Date: Wed, 17 Jun 2015 13:23:04 +0100
Message-ID: <558166A8.3070901@arm.com>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com> <1433783045-8002-8-git-send-email-marc.zyngier@arm.com> <55815F4C.2090602@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55815F4C.2090602@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, =?windows-1252?Q?Alex?= =?windows-1252?Q?_Benn=E9e?= <alex.bennee@linaro.org>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On 17/06/15 12:51, Eric Auger wrote:
> Hi Marc,
> On 06/08/2015 07:04 PM, Marc Zyngier wrote:
>> To allow a HW interrupt to be injected into a guest, we lookup the
>> guest virtual interrupt in the irq_phys_map rbtree, and if we have
>> a match, encode both interrupts in the LR.
>>
>> We also mark the interrupt as "active" at the host distributor level.
>>
>> On guest EOI on the virtual interrupt, the host interrupt will be
>> deactivated.
>
> a "standard" physical IRQ would be first handled by the host handler
> which would ack and deactivate it a first time. Here, if my
> understanding is correct, the virtual counter PPI never hits. Instead we
> "emulate" it on world-switch by directly setting the dist state. Is that
> correct? If yes it is quite a specific handling of an "HW" IRQ.

This is (mostly) correct. Because we deal with HW that is shared between
guests, we absolutely need to make that HW quiescent before getting back
to the host. Setting the active bit in the distributor allows us to
restore the HW in a state that shows a pending interrupt at the guest
level, but ensure that the interrupt doesn't fire at the host level.

As for the "specificity", this is how the architecture has been
designed, and the way we're expected to deal with this kind of shared
HW. Rest assured I didn't come up with that on my own! ;-)

> 
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  virt/kvm/arm/vgic.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 68 insertions(+), 3 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
>> index c6604f2..495ac7d 100644
>> --- a/virt/kvm/arm/vgic.c
>> +++ b/virt/kvm/arm/vgic.c
>> @@ -1120,6 +1120,26 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
>>  	if (!vgic_irq_is_edge(vcpu, irq))
>>  		vlr.state |= LR_EOI_INT;
>>  
>> +	if (vlr.irq >= VGIC_NR_SGIS) {
>> +		struct irq_phys_map *map;
>> +		map = vgic_irq_map_search(vcpu, irq);
>> +
>> +		if (map) {
>> +			int ret;
>> +
>> +			BUG_ON(!map->active);
>> +			vlr.hwirq = map->phys_irq;
>> +			vlr.state |= LR_HW;
>> +			vlr.state &= ~LR_EOI_INT;
>> +
>> +			ret = irq_set_irqchip_state(map->irq,
>> +						    IRQCHIP_STATE_ACTIVE,
>> +						    true);
>> +			vgic_irq_set_queued(vcpu, irq);
>
> queued state was used for level sensitive IRQs only. Forwarded or "HW"
> IRQs theoretically can be edge or sensitive, right? If yes may be worth
> to justify the usage of queued state for forwarded IRQ? Also

That's because it is illegal to set a HW interrupt to be PENDING+ACTIVE,
which means we have to prevent the interrupt to be injected multiple
times. The behaviour is sufficiently close to what we do for a level
interrupt that we use the same state.

> vgic_irq_set_queued rather was called in parent vgic_queue_hwirq today.

I tried to keep the HW bit madness as localized as possible. Letting it
spread further away seems to make the code more difficult to read IMHO.

> 
>> +			WARN_ON(ret);
>> +		}
>> +	}
>> +
>>  	vgic_set_lr(vcpu, lr_nr, vlr);
>>  	vgic_sync_lr_elrsr(vcpu, lr_nr, vlr);
>>  }
>> @@ -1344,6 +1364,35 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>>  	return level_pending;
>>  }
>>  
>> +/* Return 1 if HW interrupt went from active to inactive, and 0 otherwise */
>> +static int vgic_sync_hwirq(struct kvm_vcpu *vcpu, struct vgic_lr vlr)
>> +{
>> +	struct irq_phys_map *map;
>> +	int ret;
>> +
>> +	if (!(vlr.state & LR_HW))
>> +		return 0;
>> +
>> +	map = vgic_irq_map_search(vcpu, vlr.irq);
>> +	BUG_ON(!map || !map->active);
>> +
>> +	ret = irq_get_irqchip_state(map->irq,
>> +				    IRQCHIP_STATE_ACTIVE,
>> +				    &map->active);
>
> Doesn't it work because the virtual timer was disabled during the world
> switch. Does it characterize all "shared" devices? Difficult for me to
> understand how much this is specific to arch timer integration?

Shared devices cannot be left running when the guest is not running
because (a) we have lost the context (the guest), and (b) we need to
give it to another guest. This is a fundamental property of this kind of
resource.

This is by no mean specific to the timer, BTW. The VGIC itself is a
shared resource, and we nuke it on each exit, for the same reason. The
only difference is that we don't propagate the VGIC interrupt to a guest.

>> +
>> +	WARN_ON(ret);
>> +
>> +	if (map->active) {
>> +		ret = irq_set_irqchip_state(map->irq,
>> +					    IRQCHIP_STATE_ACTIVE,
>> +					    false);
>> +		WARN_ON(ret);
>> +		return 0;
>> +	}
>> +
>> +	return 1;
>> +}
>> +
>>  /* Sync back the VGIC state after a guest run */
>>  static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>>  {
>> @@ -1358,14 +1407,30 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>>  	elrsr = vgic_get_elrsr(vcpu);
>>  	elrsr_ptr = u64_to_bitmask(&elrsr);
>>  
>> -	/* Clear mappings for empty LRs */
>> -	for_each_set_bit(lr, elrsr_ptr, vgic->nr_lr) {
>> +	/* Deal with HW interrupts, and clear mappings for empty LRs */
>> +	for (lr = 0; lr < vgic->nr_lr; lr++) {
>>  		struct vgic_lr vlr;
>>  
>> -		if (!test_and_clear_bit(lr, vgic_cpu->lr_used))
>> +		if (!test_bit(lr, vgic_cpu->lr_used))
>>  			continue;
>>  
>>  		vlr = vgic_get_lr(vcpu, lr);
>> +		if (vgic_sync_hwirq(vcpu, vlr)) {
>> +			/*
>> +			 * So this is a HW interrupt that the guest
>> +			 * EOI-ed. Clean the LR state and allow the
>> +			 * interrupt to be queued again.
>> +			 */
>> +			vlr.state &= ~LR_HW;
>> +			vlr.hwirq = 0;
>> +			vgic_set_lr(vcpu, lr, vlr);
>> +			vgic_irq_clear_queued(vcpu, vlr.irq)
>
> not necessarily a level sensitive IRQ?

As explained above, we have the same requirements when an interrupt is
forwarded to a guest.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
