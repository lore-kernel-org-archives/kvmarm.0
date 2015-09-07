From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 1/2] arm/arm64: KVM: vgic: Move active state handling
 to flush_hwstate
Date: Mon, 07 Sep 2015 16:54:29 +0100
Message-ID: <55EDB335.9080009@arm.com>
References: <1441376679-8341-1-git-send-email-christoffer.dall@linaro.org> <1441376679-8341-2-git-send-email-christoffer.dall@linaro.org> <55EDA2B4.5000903@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55EDA2B4.5000903@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/09/15 15:44, Eric Auger wrote:
> Hi,
> On 09/04/2015 04:24 PM, Christoffer Dall wrote:
>> We currently set the physical active state only when we *inject* a new
>> pending virtual interrupt, but this is actually not correct, because we
>> could have been preempted and run something else on the system that
>> resets the active state to clear.  This causes us to run the VM with the
>> timer set to fire, but without setting the physical active state.
>>
>> The solution is to always check the LR configurations, and we if have a
>> mapped interrupt in the LR in either the pending or active state
>> (virtual), then set the physical active state.
>>
>> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>> ---
>>  virt/kvm/arm/vgic.c | 42 ++++++++++++++++++++++++++----------------
>>  1 file changed, 26 insertions(+), 16 deletions(-)
>>
[...]
>> +
>> +	for (lr = 0; lr < vgic->nr_lr; lr++) {
>> +		struct vgic_lr vlr;
>> +
>> +		if (!test_bit(lr, vgic_cpu->lr_used))
>> +			continue;
>> +
>> +		vlr = vgic_get_lr(vcpu, lr);
>> +
>> +		/*
>> +		 * If we have a mapping, and the virtual interrupt is
>> +		 * presented to the guest (as pending or active), then we must
>> +		 * set the state to active in the physical world. See
>> +		 * Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt.
> if upstreamed in 4.3 whereas the other series is not there,
> vgic-mapped-irqs.txt won't be available.

Good point, I'll update the queued patch.

>> +		 */
>> +		if (vlr.state & LR_HW) {
>> +			struct irq_phys_map *map;
>> +			map = vgic_irq_map_search(vcpu, vlr.irq);
>> +
>> +			ret = irq_set_irqchip_state(map->irq,
>> +						    IRQCHIP_STATE_ACTIVE,
>> +						    true);
> I understand the need for manually setting the phys dist state in case
> of timer however for non shared IRQs, GIC does the job directly. But I
> guess it does not harm.

For non-shared interrupts, I'd expect an additional test on map->shared
to avoid hitting the distributor once more.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
