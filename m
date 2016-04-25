From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 5/7] KVM: arm/arm64: Remove the IRQ field from struct
 irq_phys_map
Date: Mon, 25 Apr 2016 11:25:52 +0100
Message-ID: <571DF0B0.6070004@arm.com>
References: <1460729047-6346-1-git-send-email-andre.przywara@arm.com>
 <1460729047-6346-6-git-send-email-andre.przywara@arm.com>
 <571910AD.4050704@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37C0449B2F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2016 06:23:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PPxX8P95OSbJ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Apr 2016 06:23:19 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F222F49B1D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2016 06:23:17 -0400 (EDT)
In-Reply-To: <571910AD.4050704@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 21/04/16 18:41, Eric Auger wrote:
> Hi Andre,
> On 04/15/2016 04:04 PM, Andre Przywara wrote:
>> From: Christoffer Dall <christoffer.dall@linaro.org>
>>
>> The communication of a Linux IRQ number from outside the VGIC to the
>> vgic was a leftover from the day when the vgic code cared about how a
>> particular device injects virtual interrupts mapped to a physical
>> interrupt.
>>
>> We can safely remove this notion, leaving all physical IRQ handling to
>> be done in the device driver (the arch timer in this case), which makes
>> room for a saner API for the new VGIC.
>>
>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  include/kvm/arm_vgic.h    |  3 +--
>>  virt/kvm/arm/arch_timer.c | 22 ++++++++++++++++++++--
>>  virt/kvm/arm/vgic.c       | 20 ++------------------
>>  3 files changed, 23 insertions(+), 22 deletions(-)
>>
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index 43eeb18..49c559e 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -157,7 +157,6 @@ struct vgic_io_device {
>>  struct irq_phys_map {
>>  	u32			virt_irq;
>>  	u32			phys_irq;
>> -	u32			irq;
>>  };
>>  
>>  struct irq_phys_map_entry {
>> @@ -345,7 +344,7 @@ int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
>>  void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
>>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
>>  struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
>> -					   int virt_irq, int irq);
>> +					   int virt_irq, int phys_irq);
>>  int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq);
>>  bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
>>  
>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>> index b4d96b1..cfdf88f 100644
>> --- a/virt/kvm/arm/arch_timer.c
>> +++ b/virt/kvm/arm/arch_timer.c
>> @@ -274,7 +274,7 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
>>  	if (timer->active_cleared_last && !phys_active)
>>  		return;
>>  
>> -	ret = irq_set_irqchip_state(timer->map->irq,
>> +	ret = irq_set_irqchip_state(host_vtimer_irq,
>>  				    IRQCHIP_STATE_ACTIVE,
>>  				    phys_active);
>>  	WARN_ON(ret);
>> @@ -307,6 +307,9 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
>>  {
>>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>>  	struct irq_phys_map *map;
>> +	struct irq_desc *desc;
>> +	struct irq_data *data;
>> +	int phys_irq;
>>  
>>  	/*
>>  	 * The vcpu timer irq number cannot be determined in
>> @@ -326,10 +329,25 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
>>  	kvm_timer_update_state(vcpu);
>>  
>>  	/*
>> +	 * Find the physical IRQ number corresponding to the host_vtimer_irq
>> +	 */
>> +	desc = irq_to_desc(host_vtimer_irq);
>> +	if (!desc) {
> can this really happen?

I guess not, as vhost_timer_irq is set by request_percpu_irq() and we
check that return value.
But frankly I'd like to go with the check here, as having a kernel NULL
pointer dereference is a really bad alternative.
And if I am not mistaken, this is only called on the reset path, so
quite rarely.

>> +		kvm_err("%s: no interrupt descriptor\n", __func__);
>> +		return -EINVAL;
>> +	}
>> +
>> +	data = irq_desc_get_irq_data(desc);
>> +	while (data->parent_data)
>> +		data = data->parent_data;
>> +
>> +	phys_irq = data->hwirq;
>> +
>> +	/*
>>  	 * Tell the VGIC that the virtual interrupt is tied to a
>>  	 * physical interrupt. We do that once per VCPU.
>>  	 */
>> -	map = kvm_vgic_map_phys_irq(vcpu, irq->irq, host_vtimer_irq);
>> +	map = kvm_vgic_map_phys_irq(vcpu, irq->irq, phys_irq);
>>  	if (WARN_ON(IS_ERR(map)))
>>  		return PTR_ERR(map);
>>  
>> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
>> index 2d7ae35..ac5838b 100644
>> --- a/virt/kvm/arm/vgic.c
>> +++ b/virt/kvm/arm/vgic.c
>> @@ -1723,27 +1723,13 @@ static struct list_head *vgic_get_irq_phys_map_list(struct kvm_vcpu *vcpu,
>>   * Returns a valid pointer on success, and an error pointer otherwise
>>   */
> the doc comment must be updated
>  * @irq: The Linux IRQ number

Indeed, I think I managed to mess this part up during some rebase.

Cheers,
Andre.

> Besides
> 
> Reviewed-by: Eric Auger <eric.auger@linaro.org>
> 
> Cheers
> 
> Eric
> 
>>  struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
>> -					   int virt_irq, int irq)
>> +					   int virt_irq, int phys_irq)
>>  {
>>  	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>>  	struct list_head *root = vgic_get_irq_phys_map_list(vcpu, virt_irq);
>>  	struct irq_phys_map *map;
>>  	struct irq_phys_map_entry *entry;
>> -	struct irq_desc *desc;
>> -	struct irq_data *data;
>> -	int phys_irq;
>>  
>> -	desc = irq_to_desc(irq);
>> -	if (!desc) {
>> -		kvm_err("%s: no interrupt descriptor\n", __func__);
>> -		return ERR_PTR(-EINVAL);
>> -	}
>> -
>> -	data = irq_desc_get_irq_data(desc);
>> -	while (data->parent_data)
>> -		data = data->parent_data;
>> -
>> -	phys_irq = data->hwirq;
>>  
>>  	/* Create a new mapping */
>>  	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
>> @@ -1756,8 +1742,7 @@ struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
>>  	map = vgic_irq_map_search(vcpu, virt_irq);
>>  	if (map) {
>>  		/* Make sure this mapping matches */
>> -		if (map->phys_irq != phys_irq	||
>> -		    map->irq      != irq)
>> +		if (map->phys_irq != phys_irq)
>>  			map = ERR_PTR(-EINVAL);
>>  
>>  		/* Found an existing, valid mapping */
>> @@ -1767,7 +1752,6 @@ struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
>>  	map           = &entry->map;
>>  	map->virt_irq = virt_irq;
>>  	map->phys_irq = phys_irq;
>> -	map->irq      = irq;
>>  
>>  	list_add_tail_rcu(&entry->entry, root);
>>  
>>
> 
