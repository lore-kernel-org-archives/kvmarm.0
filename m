From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 10/10] KVM: arm/arm64: vgic: Allow non-shared device HW
 interrupts
Date: Wed, 17 Jun 2015 17:50:50 +0200
Message-ID: <5581975A.8070509@linaro.org>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com>
 <1433783045-8002-11-git-send-email-marc.zyngier@arm.com>
 <55818E06.8010400@linaro.org> <55819445.4090309@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9010955E58
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2015 11:40:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id snZ0UxC-mMAB for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Jun 2015 11:40:30 -0400 (EDT)
Received: from mail-wi0-f180.google.com (mail-wi0-f180.google.com
 [209.85.212.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 31CE055E57
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2015 11:40:29 -0400 (EDT)
Received: by wicnd19 with SMTP id nd19so33468676wic.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2015 08:51:07 -0700 (PDT)
In-Reply-To: <55819445.4090309@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Cc: Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/17/2015 05:37 PM, Marc Zyngier wrote:
> On 17/06/15 16:11, Eric Auger wrote:
>> Hi Marc,
>> On 06/08/2015 07:04 PM, Marc Zyngier wrote:
>>> So far, the only use of the HW interrupt facility is the timer,
>>> implying that the active state is context-switched for each vcpu,
>>> as the device is is shared across all vcpus.
>> s/is//
>>>
>>> This does not work for a device that has been assigned to a VM,
>>> as the guest is entierely in control of that device (the HW is
>> entirely?
>>> not shared). In that case, it makes sense to bypass the whole
>>> active state srtwitchint, and only track the deactivation of the
>> switching
> 
> Congratulations, I think you're now ready to try deciphering my
> handwriting... ;-)
good to see you're not a machine or maybe you do it on purpose some
times ;-)
> 
>>> interrupt.
>>>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>  include/kvm/arm_vgic.h    |  5 +++--
>>>  virt/kvm/arm/arch_timer.c |  2 +-
>>>  virt/kvm/arm/vgic.c       | 37 ++++++++++++++++++++++++-------------
>>>  3 files changed, 28 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>>> index 1c653c1..5d47d60 100644
>>> --- a/include/kvm/arm_vgic.h
>>> +++ b/include/kvm/arm_vgic.h
>>> @@ -164,7 +164,8 @@ struct irq_phys_map {
>>>  	u32			virt_irq;
>>>  	u32			phys_irq;
>>>  	u32			irq;
>>> -	bool			active;
>>> +	bool			shared;
>>> +	bool			active; /* Only valid if shared */
>>>  };
>>>  
>>>  struct vgic_dist {
>>> @@ -347,7 +348,7 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
>>>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
>>>  int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
>>>  struct irq_phys_map *vgic_map_phys_irq(struct kvm_vcpu *vcpu,
>>> -				       int virt_irq, int irq);
>>> +				       int virt_irq, int irq, bool shared);
>>>  int vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
>>>  bool vgic_get_phys_irq_active(struct irq_phys_map *map);
>>>  void vgic_set_phys_irq_active(struct irq_phys_map *map, bool active);
>>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>>> index b9fff78..9544d79 100644
>>> --- a/virt/kvm/arm/arch_timer.c
>>> +++ b/virt/kvm/arm/arch_timer.c
>>> @@ -202,7 +202,7 @@ void kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
>>>  	 * Tell the VGIC that the virtual interrupt is tied to a
>>>  	 * physical interrupt. We do that once per VCPU.
>>>  	 */
>>> -	timer->map = vgic_map_phys_irq(vcpu, irq->irq, host_vtimer_irq);
>>> +	timer->map = vgic_map_phys_irq(vcpu, irq->irq, host_vtimer_irq, true);
>>>  	WARN_ON(!timer->map);
>>>  }
>>>  
>>> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
>>> index f376b56..4223166 100644
>>> --- a/virt/kvm/arm/vgic.c
>>> +++ b/virt/kvm/arm/vgic.c
>>> @@ -1125,18 +1125,21 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
>>>  		map = vgic_irq_map_search(vcpu, irq);
>>>  
>>>  		if (map) {
>>> -			int ret;
>>> -
>>> -			BUG_ON(!map->active);
>>>  			vlr.hwirq = map->phys_irq;
>>>  			vlr.state |= LR_HW;
>>>  			vlr.state &= ~LR_EOI_INT;
>>>  
>>> -			ret = irq_set_irqchip_state(map->irq,
>>> -						    IRQCHIP_STATE_ACTIVE,
>>> -						    true);
>>>  			vgic_irq_set_queued(vcpu, irq);
>>
>> the queued state is set again in vgic_queue_hwirq for level_sensitive
>> IRQs although not harmful.
> 
> Indeed. We still need it for edge interrupts though. I'll try to find a
> nicer way...
> 
>>> -			WARN_ON(ret);
>>> +
>>> +			if (map->shared) {
>>> +				int ret;
>>> +
>>> +				BUG_ON(!map->active);
>>> +				ret = irq_set_irqchip_state(map->irq,
>>> +							    IRQCHIP_STATE_ACTIVE,
>>> +							    true);
>>> +				WARN_ON(ret);
>>> +			}
>>>  		}
>>>  	}
>>>  
>>> @@ -1368,21 +1371,28 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>>>  static int vgic_sync_hwirq(struct kvm_vcpu *vcpu, struct vgic_lr vlr)
>>>  {
>>>  	struct irq_phys_map *map;
>>> +	bool active;
>>>  	int ret;
>>>  
>>>  	if (!(vlr.state & LR_HW))
>>>  		return 0;
>>>  
>>>  	map = vgic_irq_map_search(vcpu, vlr.irq);
>>> -	BUG_ON(!map || !map->active);
>>> +	BUG_ON(!map);
>>> +	BUG_ON(map->shared && !map->active);
>>>  
>>>  	ret = irq_get_irqchip_state(map->irq,
>>>  				    IRQCHIP_STATE_ACTIVE,
>>> -				    &map->active);
>>> +				    &active);
>>>  
>> In case of non shared and EOIMode = 1 - I know this is not your current
>> interest here though ;-) - , once the guest EOIs its virtual IRQ and GIC
>> deactivates the physical one, a new phys IRQ can hit immediatly, the
>> physical handler can be entered and the state is seen as active here.
>> The queued state is never reset in such a case and the system gets stuck
>> since the can_sample fails I think. What I mean here is sounds the state
>> machine as is does not work for my VFIO case. So some adaptations still
>> are needed I think. Do you share my diagnosis?
> 
> Yup, there is something that doesn't quite work here.
> 
> I think the mistake is to sample the distributor active state. I wonder
> if I can simply rely on the LR state. If it is neither pending nor
> active, it means that we have done the deactivation, and we can then
> reset the queued state.

I tried to use the LR in the past - it was also Christoffer's will - but
it was not working. I observed injection before seeing the LR voided.
This is why I resorted to using the pending state instead and treated
forwarded IRQ as edge in vgic_queue_hwirq.  sampling could be done only
if the IRQ was pending.

Eric
> 
> As a bonus, it would save a read from MMIO, which is often dog slow.
> 
> Thoughts?
> 
> 	M.
>>
>> Eric
>>>  
>>> -	if (map->active) {
>>> +	if (!map->shared)
>>> +		return !active;
>>> +
>>> +	map->active = active;
>>> +
>>> +	if (active) {
>>>  		ret = irq_set_irqchip_state(map->irq,
>>>  					    IRQCHIP_STATE_ACTIVE,
>>>  					    false);
>>> @@ -1663,7 +1673,7 @@ static struct rb_root *vgic_get_irq_phys_map(struct kvm_vcpu *vcpu,
>>>  }
>>>  
>>>  struct irq_phys_map *vgic_map_phys_irq(struct kvm_vcpu *vcpu,
>>> -				       int virt_irq, int irq)
>>> +				       int virt_irq, int irq, bool shared)
>>>  {
>>>  	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>>>  	struct rb_root *root = vgic_get_irq_phys_map(vcpu, virt_irq);
>>> @@ -1710,6 +1720,7 @@ struct irq_phys_map *vgic_map_phys_irq(struct kvm_vcpu *vcpu,
>>>  	new_map->virt_irq = virt_irq;
>>>  	new_map->phys_irq = phys_irq;
>>>  	new_map->irq = irq;
>>> +	new_map->shared = shared;
>>>  
>>>  	rb_link_node(&new_map->node, parent, new);
>>>  	rb_insert_color(&new_map->node, root);
>>> @@ -1746,13 +1757,13 @@ static struct irq_phys_map *vgic_irq_map_search(struct kvm_vcpu *vcpu,
>>>  
>>>  bool vgic_get_phys_irq_active(struct irq_phys_map *map)
>>>  {
>>> -	BUG_ON(!map);
>>> +	BUG_ON(!map || !map->shared);
>>>  	return map->active;
>>>  }
>>>  
>>>  void vgic_set_phys_irq_active(struct irq_phys_map *map, bool active)
>>>  {
>>> -	BUG_ON(!map);
>>> +	BUG_ON(!map || !map->shared);
>>>  	map->active = active;
>>>  }
>>>  
>>>
>>
> 
> 
