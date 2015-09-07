From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 1/2] arm/arm64: KVM: vgic: Move active state handling to
 flush_hwstate
Date: Mon, 7 Sep 2015 17:46:26 +0200
Message-ID: <55EDB152.3020204@linaro.org>
References: <1441376679-8341-1-git-send-email-christoffer.dall@linaro.org>
 <1441376679-8341-2-git-send-email-christoffer.dall@linaro.org>
 <55EDA2B4.5000903@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 427904117E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2015 11:46:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FYcDT+NiLe5U for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Sep 2015 11:46:43 -0400 (EDT)
Received: from mail-wi0-f176.google.com (mail-wi0-f176.google.com
 [209.85.212.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 16B9340F90
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2015 11:46:42 -0400 (EDT)
Received: by wiclk2 with SMTP id lk2so92920091wic.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Sep 2015 08:47:16 -0700 (PDT)
In-Reply-To: <55EDA2B4.5000903@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 09/07/2015 04:44 PM, Eric Auger wrote:
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
>> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
>> index 9eb489a..6bd1c9b 100644
>> --- a/virt/kvm/arm/vgic.c
>> +++ b/virt/kvm/arm/vgic.c
>> @@ -1144,26 +1144,11 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
>>  		struct irq_phys_map *map;
>>  		map = vgic_irq_map_search(vcpu, irq);
>>  
>> -		/*
>> -		 * If we have a mapping, and the virtual interrupt is
>> -		 * being injected, then we must set the state to
>> -		 * active in the physical world. Otherwise the
>> -		 * physical interrupt will fire and the guest will
>> -		 * exit before processing the virtual interrupt.
>> -		 */
>>  		if (map) {
>> -			int ret;
>> -
>> -			BUG_ON(!map->active);
> I have a question about this map->active. I did not find any user of
> kvm_vgic_set_phys_irq_active anymore. The flag is directly updated in
> vgic_sync_hwirq through the irq_get_irqchip_state query. In the same
> function, before there is a "BUG_ON(!map || !map->active);"
> 
> Can't we have this BUG_ON firing?
hum ignore that comment. Didn't see the call to
kvm_vgic_set_phys_irq_active in arch_timer.c

Eric
> 
> 
>>  			vlr.hwirq = map->phys_irq;
>>  			vlr.state |= LR_HW;
>>  			vlr.state &= ~LR_EOI_INT;
>>  
>> -			ret = irq_set_irqchip_state(map->irq,
>> -						    IRQCHIP_STATE_ACTIVE,
>> -						    true);
>> -			WARN_ON(ret);
>> -
>>  			/*
>>  			 * Make sure we're not going to sample this
>>  			 * again, as a HW-backed interrupt cannot be
>> @@ -1255,7 +1240,7 @@ static void __kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>>  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>>  	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>>  	unsigned long *pa_percpu, *pa_shared;
>> -	int i, vcpu_id;
>> +	int i, vcpu_id, lr, ret;
>>  	int overflow = 0;
>>  	int nr_shared = vgic_nr_shared_irqs(dist);
>>  
>> @@ -1310,6 +1295,31 @@ epilog:
>>  		 */
>>  		clear_bit(vcpu_id, dist->irq_pending_on_cpu);
>>  	}
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
> 
> Eric
>> +			WARN_ON(ret);
>> +		}
>> +	}
>>  }
>>  
>>  static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>>
> 
