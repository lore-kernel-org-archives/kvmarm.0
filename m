From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 10/10] KVM: arm/arm64: vgic: Allow non-shared device
 HW interrupts
Date: Tue, 21 Jul 2015 19:01:13 +0100
Message-ID: <55AE88E9.1070802@arm.com>
References: <1436378202-20224-1-git-send-email-marc.zyngier@arm.com>
 <1436378202-20224-11-git-send-email-marc.zyngier@arm.com>
 <20150717221521.GH14024@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37B5658F66
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jul 2015 13:49:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fPEq367Lezg7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jul 2015 13:49:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8F8758F5A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jul 2015 13:49:09 -0400 (EDT)
In-Reply-To: <20150717221521.GH14024@cbox>
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
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Andre Przywara <Andre.Przywara@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 17/07/15 23:15, Christoffer Dall wrote:
> On Wed, Jul 08, 2015 at 06:56:42PM +0100, Marc Zyngier wrote:
>> So far, the only use of the HW interrupt facility is the timer,
>> implying that the active state is context-switched for each vcpu,
>> as the device is is shared across all vcpus.
>>
>> This does not work for a device that has been assigned to a VM,
>> as the guest is entierely in control of that device (the HW is
>> not shared). In that case, it makes sense to bypass the whole
>> active state switchint, and only track the deactivation of the
> 
> switching
> 
>> interrupt.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  include/kvm/arm_vgic.h    |  5 ++--
>>  virt/kvm/arm/arch_timer.c |  2 +-
>>  virt/kvm/arm/vgic.c       | 62 ++++++++++++++++++++++++++++++++++++-----------
>>  3 files changed, 52 insertions(+), 17 deletions(-)
>>
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index 9fd4023..31c987a 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -163,7 +163,8 @@ struct irq_phys_map {
>>  	u32			virt_irq;
>>  	u32			phys_irq;
>>  	u32			irq;
>> -	bool			active;
>> +	bool			shared;
>> +	bool			active; /* Only valid if shared */
>>  };
>>  
>>  struct irq_phys_map_entry {
>> @@ -354,7 +355,7 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
>>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
>>  int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
>>  struct irq_phys_map *vgic_map_phys_irq(struct kvm_vcpu *vcpu,
>> -				       int virt_irq, int irq);
>> +				       int virt_irq, int irq, bool shared);
>>  int vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
>>  bool vgic_get_phys_irq_active(struct irq_phys_map *map);
>>  void vgic_set_phys_irq_active(struct irq_phys_map *map, bool active);
>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>> index b9fff78..9544d79 100644
>> --- a/virt/kvm/arm/arch_timer.c
>> +++ b/virt/kvm/arm/arch_timer.c
>> @@ -202,7 +202,7 @@ void kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
>>  	 * Tell the VGIC that the virtual interrupt is tied to a
>>  	 * physical interrupt. We do that once per VCPU.
>>  	 */
>> -	timer->map = vgic_map_phys_irq(vcpu, irq->irq, host_vtimer_irq);
>> +	timer->map = vgic_map_phys_irq(vcpu, irq->irq, host_vtimer_irq, true);
>>  	WARN_ON(!timer->map);
>>  }
>>  
>> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
>> index 39f9479..3585bb0 100644
>> --- a/virt/kvm/arm/vgic.c
>> +++ b/virt/kvm/arm/vgic.c
>> @@ -1123,18 +1123,21 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
>>  		map = vgic_irq_map_search(vcpu, irq);
>>  
>>  		if (map) {
>> -			int ret;
>> -
>> -			BUG_ON(!map->active);
>>  			vlr.hwirq = map->phys_irq;
>>  			vlr.state |= LR_HW;
>>  			vlr.state &= ~LR_EOI_INT;
>>  
>> -			ret = irq_set_irqchip_state(map->irq,
>> -						    IRQCHIP_STATE_ACTIVE,
>> -						    true);
>>  			vgic_irq_set_queued(vcpu, irq);
>> -			WARN_ON(ret);
>> +
>> +			if (map->shared) {
>> +				int ret;
>> +
>> +				BUG_ON(!map->active);
>> +				ret = irq_set_irqchip_state(map->irq,
>> +							    IRQCHIP_STATE_ACTIVE,
>> +							    true);
>> +				WARN_ON(ret);
> 
> do we have any other example of a shared device or is this really simply
> because the timer hardware is fscking strangely tied to the gic and is a
> total one-off?

I don't think of it as a one-off. PMUs could very well be in the same
category.

> In the latter case, would it be cleaner to drop this notion of a shared
> device entirely and put all this logic in the arch timer code instead?

My initial implementation did exactly that (hence the cut-n-paste crap
you spotted in patch #6). It wasn't bad, but it did put a lot of GIC
knowledge inside the timer code, and a few callbacks too many between
the two subsystems.

>> +			}
>>  		}
>>  	}
>>  
>> @@ -1366,21 +1369,37 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>>  static int vgic_sync_hwirq(struct kvm_vcpu *vcpu, struct vgic_lr vlr)
>>  {
>>  	struct irq_phys_map *map;
>> +	bool active;
>>  	int ret;
>>  
>>  	if (!(vlr.state & LR_HW))
>>  		return 0;
>>  
>>  	map = vgic_irq_map_search(vcpu, vlr.irq);
>> -	BUG_ON(!map || !map->active);
>> +	BUG_ON(!map);
>> +	BUG_ON(map->shared && !map->active);
>>  
>>  	ret = irq_get_irqchip_state(map->irq,
>>  				    IRQCHIP_STATE_ACTIVE,
>> -				    &map->active);
>> +				    &active);
>>  
>>  	WARN_ON(ret);
>>  
>> -	if (map->active) {
>> +	/*
>> +	 * For a non-shared interrupt, we have to catter for two
> 
> s/catter/cater/ ?

Yup.

>> +	 * possible deactivation conditions
> 
> conditions:
> 
>> +	 *
>> +	 * - the interrupt is now inactive
>> +	 * - the interrupt is still active, but is flagged as not
>> +	 *   queued, indicating another interrupt has fired before we
>> +	 *   could observe the deactivate.
> 
> are these physical or virtual interrupts we are talking about?  I assume
> virtual, but it would be good to be specific.  It's not like we're going
> to remember any of this in a little bit.

There is a massive ambiguity here. It should read:
- the physical interrupt is now inactive (EOIed from the guest)
- the physical interrupt is still active, but its virtual counterpart is
flagged as "not queued", indicating another interrupt has fired between
the EOI and the guest exit.

>> +	 */
>> +	if (!map->shared)
>> +		return !active || !vgic_irq_is_queued(vcpu, vlr.irq);
> 
> if the second part of the disjunction returns true, doesn't this mean
> we can potentially write the active+pending state in the LR for a HW
> interrupt, which is not allowed?

I don't think so. If the physical interrupt has fired, it is because it
has been EOIed (hence deactivated) first (the active state would
otherwise prevent it from firing).

>> +
>> +	map->active = active;
>> +
>> +	if (active) {
> 
> should you be doing this for a non-shared interrupt?

No. A non-shared interrupt is only dealt with by a single VM, so there
is no need to clear its state. That would actually completely confuse
both the device and the VM if you did, because you could now inject a
new interrupt while the previous one is still in progress. Mayhem follows...

>>  		ret = irq_set_irqchip_state(map->irq,
>>  					    IRQCHIP_STATE_ACTIVE,
>>  					    false);
>> @@ -1523,6 +1542,7 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
>>  	int edge_triggered, level_triggered;
>>  	int enabled;
>>  	bool ret = true, can_inject = true;
>> +	struct irq_phys_map *map;
>>  
>>  	spin_lock(&dist->lock);
>>  
>> @@ -1569,6 +1589,18 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
>>  		goto out;
>>  	}
>>  
>> +	map = vgic_irq_map_search(vcpu, irq_num);
>> +	if (map && !map->shared) {
>> +		/*
>> +		 * We are told to inject a HW irq, so we have to trust
>> +		 * the caller that the previous one has been EOIed,
>> +		 * and that a new one is now active. Clearing the
>> +		 * queued state will have the effect of making it
>> +		 * sample-able again.
>> +		 */
>> +		vgic_irq_clear_queued(vcpu, irq_num);
> 
> see my question above about active+pending

I hope I convinced you above. I realize there is one thing missing
though. Userspace shouldn't be allowed to inject a mapped interrupt.
Ever. I'll fix that.

>> +	}
>> +
>>  	if (!vgic_can_sample_irq(vcpu, irq_num)) {
>>  		/*
>>  		 * Level interrupt in progress, will be picked up
>> @@ -1662,7 +1694,7 @@ static struct list_head *vgic_get_irq_phys_map(struct kvm_vcpu *vcpu,
>>  }
>>  
>>  struct irq_phys_map *vgic_map_phys_irq(struct kvm_vcpu *vcpu,
>> -				       int virt_irq, int irq)
>> +				       int virt_irq, int irq, bool shared)
>>  {
>>  	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>>  	struct list_head *root = vgic_get_irq_phys_map(vcpu, virt_irq);
>> @@ -1691,7 +1723,8 @@ struct irq_phys_map *vgic_map_phys_irq(struct kvm_vcpu *vcpu,
>>  	if (map) {
>>  		/* Make sure this mapping matches */
>>  		if (map->phys_irq != phys_irq	||
>> -		    map->irq      != irq)
>> +		    map->irq      != irq	||
>> +		    map->shared   != shared)
> 
> this really feels like a BUG() - if we have an existing mapping for the
> same virtual IRQ, but it's shared in one case and not shared in the
> other?  Shouldn we even allow the caller to get this far?

How early do you want to detect it? All we can do is tell the caller to
bugger off by returning an error (we return NULL at the moment, meaning
that the caller doesn't get a mapping at all).

>>  			map = NULL;
>>  
>>  		goto out;
>> @@ -1706,6 +1739,7 @@ struct irq_phys_map *vgic_map_phys_irq(struct kvm_vcpu *vcpu,
>>  	map->virt_irq = virt_irq;
>>  	map->phys_irq = phys_irq;
>>  	map->irq      = irq;
>> +	map->shared   = shared;
>>  
>>  	list_add_tail_rcu(&entry->entry, root);
>>  
>> @@ -1746,13 +1780,13 @@ static void vgic_free_phys_irq_map_rcu(struct rcu_head *rcu)
>>  
>>  bool vgic_get_phys_irq_active(struct irq_phys_map *map)
>>  {
>> -	BUG_ON(!map);
>> +	BUG_ON(!map || !map->shared);
>>  	return map->active;
>>  }
>>  
>>  void vgic_set_phys_irq_active(struct irq_phys_map *map, bool active)
>>  {
>> -	BUG_ON(!map);
>> +	BUG_ON(!map || !map->shared);
>>  	map->active = active;
>>  }
>>  
>> -- 
>> 2.1.4
>>
> 
> Do we really need this patch right now as part of this series or should
> this rather go with Eric's forwarding series and we can focus on getting
> rid of the timer hack for now?

It should definitely be part of Eric's. I kept it with the rest of this
series in order to keep a relative level of sanity, but I'd be happy for
Eric to take custody of it.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
