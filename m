From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 07/10] KVM: arm/arm64: vgic: Allow HW interrupts to be
 queued to a guest
Date: Thu, 11 Jun 2015 10:15:50 +0100
Message-ID: <557951C6.2090408@arm.com>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com> <1433783045-8002-8-git-send-email-marc.zyngier@arm.com> <55794A7A.2080306@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55794A7A.2080306@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>, =?windows-1252?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 11/06/15 09:44, Andre Przywara wrote:
> Hi Marc,
> 
> On 06/08/2015 06:04 PM, Marc Zyngier wrote:
>> To allow a HW interrupt to be injected into a guest, we lookup the
>> guest virtual interrupt in the irq_phys_map rbtree, and if we have
>> a match, encode both interrupts in the LR.
>>
>> We also mark the interrupt as "active" at the host distributor level.
>>
>> On guest EOI on the virtual interrupt, the host interrupt will be
>> deactivated.
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
> 
> I wonder if it's safe to rely on that mapping here. Are we sure that
> this hasn't changed while the VCPU was running? If I got this correctly,
> currently only vcpu_reset will actually add a map entry, but I guess in
> the future there will be more users.

How can the guest interrupt change? This is HW, as far as the guest is
concerned. An actual interrupt line. We don't reconfigure the HW live.

> Also we rely on the irqdomain mapping to be still the same, but that is
> probably a safe assumption.

Like I said before, this *cannot* change.

> But I'd still find it more natural to use the hwirq number from the LR
> at this point. Can't we use irq_find_mapping() here to learn Linux'
> (current) irq number from that?

I think you're confused.

- The guest irq (vlr.irq) is entirely made up, and has no connection
with reality. it is stable, and cannot change during the lifetime of the
guest (think of it as a HW irq line).

- The host hwirq (vlr.hwirq) is stable as well, for the same reason.

- The Linux IRQ cannot change because we've been given it by the kernel,
and that's what we use for *everything* as far as the kernel is
concerned. Its mapping to hwirq is stable as well because this is how we
talk to the HW.

- irq_find_mapping gives you the *reverse* mapping (from hwirq to Linux
irq), and for that to work, you need the domain on which you want to
apply the translation. This is only useful when actually taking the
interrupt (i.e. in an interrupt controller driver). I can't see how that
could make sense here.

The purpose of this mapping is to, given the guest irq (because that's
what we inject), what the other values are:
- hwirq: to provide GICH with the interrupt to deactivate
- Linux irq: to control the active state through the irqchip state API.

> Or am I too paranoid here?

Hope it makes more sense to you now.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
