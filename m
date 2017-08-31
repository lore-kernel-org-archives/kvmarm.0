From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 41/59] KVM: arm/arm64: GICv4: Wire mapping/unmapping of
 VLPIs in VFIO irq bypass
Date: Thu, 31 Aug 2017 11:24:37 +0100
Message-ID: <5bc68ab5-5343-0cf2-f11b-9eb5936c7e60@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-42-marc.zyngier@arm.com> <20170826194850.GB11074@cbox>
 <06930ddb-6c40-ff74-0062-cec236ce2455@arm.com> <20170830114646.GD24522@cbox>
 <9fc83ca2-bdae-ffbc-9d81-c77c331b47d2@arm.com> <20170830195930.GJ24522@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C90B40D17
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Aug 2017 06:22:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tadgB2RjcTAG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Aug 2017 06:22:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 901A440C5A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Aug 2017 06:22:30 -0400 (EDT)
In-Reply-To: <20170830195930.GJ24522@cbox>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 30/08/17 20:59, Christoffer Dall wrote:
> On Wed, Aug 30, 2017 at 01:53:30PM +0100, Marc Zyngier wrote:
>> On 30/08/17 12:46, Christoffer Dall wrote:
>>> On Wed, Aug 30, 2017 at 11:28:08AM +0100, Marc Zyngier wrote:
>>>> On 26/08/17 20:48, Christoffer Dall wrote:
>>>>> On Mon, Jul 31, 2017 at 06:26:19PM +0100, Marc Zyngier wrote:
>>>>>> Let's use the irq bypass mechanism introduced for platform device
>>>>>> interrupts to intercept the virtual PCIe endpoint configuration
>>>>>> and establish our LPI->VLPI mapping.
>>>>>>
>>>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>>>> ---
>>>>>>  include/kvm/arm_vgic.h      |   8 ++++
>>>>>>  virt/kvm/arm/arm.c          |  27 ++++++++----
>>>>>>  virt/kvm/arm/vgic/vgic-v4.c | 103 ++++++++++++++++++++++++++++++++++++++++++++
>>>>>>  3 files changed, 130 insertions(+), 8 deletions(-)
>>>>>>
>>>>>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>>>>>> index 359eeffe9857..050f78d4fb42 100644
>>>>>> --- a/include/kvm/arm_vgic.h
>>>>>> +++ b/include/kvm/arm_vgic.h
>>>>>> @@ -367,4 +367,12 @@ int kvm_vgic_set_forwarding(struct kvm *kvm, unsigned int host_irq,
>>>>>>  void kvm_vgic_unset_forwarding(struct kvm *kvm, unsigned int host_irq,
>>>>>>  			       unsigned int vintid);
>>>>>>  
>>>>>> +struct kvm_kernel_irq_routing_entry;
>>>>>> +
>>>>>> +int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int irq,
>>>>>> +			       struct kvm_kernel_irq_routing_entry *irq_entry);
>>>>>> +
>>>>>> +int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int irq,
>>>>>> +				 struct kvm_kernel_irq_routing_entry *irq_entry);
>>>>>> +
>>>>>>  #endif /* __KVM_ARM_VGIC_H */
>>>>>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>>>>>> index ebab6c29e3be..6803ea27c47d 100644
>>>>>> --- a/virt/kvm/arm/arm.c
>>>>>> +++ b/virt/kvm/arm/arm.c
>>>>>> @@ -1457,11 +1457,16 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
>>>>>>  	struct kvm_kernel_irqfd *irqfd =
>>>>>>  		container_of(cons, struct kvm_kernel_irqfd, consumer);
>>>>>>  
>>>>>> -	if (prod->type != IRQ_BYPASS_VFIO_PLATFORM)
>>>>>> +	switch (prod->type) {
>>>>>> +	case IRQ_BYPASS_VFIO_PLATFORM:
>>>>>> +		return kvm_vgic_set_forwarding(irqfd->kvm, prod->irq,
>>>>>> +					       irqfd->gsi + VGIC_NR_PRIVATE_IRQS);
>>>>>> +	case IRQ_BYPASS_VFIO_PCI_MSI:
>>>>>> +		return kvm_vgic_v4_set_forwarding(irqfd->kvm, prod->irq,
>>>>>> +						  &irqfd->irq_entry);
>>>>>> +	default:
>>>>>>  		return 0;
>>>>>> -
>>>>>> -	return kvm_vgic_set_forwarding(irqfd->kvm, prod->irq,
>>>>>> -				       irqfd->gsi + VGIC_NR_PRIVATE_IRQS);
>>>>>> +	}
>>>>>>  }
>>>>>>  void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
>>>>>>  				      struct irq_bypass_producer *prod)
>>>>>> @@ -1469,11 +1474,17 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
>>>>>>  	struct kvm_kernel_irqfd *irqfd =
>>>>>>  		container_of(cons, struct kvm_kernel_irqfd, consumer);
>>>>>>  
>>>>>> -	if (prod->type != IRQ_BYPASS_VFIO_PLATFORM)
>>>>>> -		return;
>>>>>> +	switch (prod->type) {
>>>>>> +	case IRQ_BYPASS_VFIO_PLATFORM:
>>>>>> +		kvm_vgic_unset_forwarding(irqfd->kvm, prod->irq,
>>>>>> +					  irqfd->gsi + VGIC_NR_PRIVATE_IRQS);
>>>>>> +		break;
>>>>>>  
>>>>>> -	kvm_vgic_unset_forwarding(irqfd->kvm, prod->irq,
>>>>>> -				  irqfd->gsi + VGIC_NR_PRIVATE_IRQS);
>>>>>> +	case IRQ_BYPASS_VFIO_PCI_MSI:
>>>>>> +		kvm_vgic_v4_unset_forwarding(irqfd->kvm, prod->irq,
>>>>>> +					     &irqfd->irq_entry);
>>>>>> +		break;
>>>>>> +	}
>>>>>>  }
>>>>>>  
>>>>>>  void kvm_arch_irq_bypass_stop(struct irq_bypass_consumer *cons)
>>>>>> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
>>>>>> index 207e1fda0dcd..338c86c5159f 100644
>>>>>> --- a/virt/kvm/arm/vgic/vgic-v4.c
>>>>>> +++ b/virt/kvm/arm/vgic/vgic-v4.c
>>>>>> @@ -72,3 +72,106 @@ void vgic_v4_teardown(struct kvm *kvm)
>>>>>>  	its_vm->nr_vpes = 0;
>>>>>>  	its_vm->vpes = NULL;
>>>>>>  }
>>>>>> +
>>>>>> +static struct vgic_its *vgic_get_its(struct kvm *kvm,
>>>>>> +				     struct kvm_kernel_irq_routing_entry *irq_entry)
>>>>>> +{
>>>>>> +	struct kvm_msi msi  = (struct kvm_msi) {
>>>>>> +		.address_lo	= irq_entry->msi.address_lo,
>>>>>> +		.address_hi	= irq_entry->msi.address_hi,
>>>>>> +		.data		= irq_entry->msi.data,
>>>>>> +		.flags		= irq_entry->msi.flags,
>>>>>> +		.devid		= irq_entry->msi.devid,
>>>>>> +	};
>>>>>> +
>>>>>> +	/*
>>>>>> +	 * Get a reference on the LPI. If NULL, this is not a valid
>>>>>> +	 * translation for any of our vITSs.
>>>>>> +	 */
>>>>>> +	return vgic_msi_to_its(kvm, &msi);
>>>>>> +}
>>>>>> +
>>>>>> +int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
>>>>>> +			       struct kvm_kernel_irq_routing_entry *irq_entry)
>>>>>> +{
>>>>>> +	struct vgic_its *its;
>>>>>> +	struct vgic_irq *irq;
>>>>>> +	struct its_vlpi_map map;
>>>>>> +	int ret;
>>>>>> +
>>>>>> +	if (!vgic_is_v4_capable(kvm))
>>>>>> +		return 0;
>>>>>> +
>>>>>> +	/*
>>>>>> +	 * Get the ITS, and escape early on error (not a valid
>>>>>> +	 * doorbell for any of our vITSs).
>>>>>> +	 */
>>>>>> +	its = vgic_get_its(kvm, irq_entry);
>>>>>> +	if (IS_ERR(its))
>>>>>> +		return 0;
>>>>>> +
>>>>>> +	mutex_lock(&its->its_lock);
>>>>>> +
>>>>>> +	/* Perform then actual DevID/EventID -> LPI translation. */
>>>>>> +	ret = vgic_its_resolve_lpi(kvm, its, irq_entry->msi.devid,
>>>>>> +				   irq_entry->msi.data, &irq);
>>>>>> +	if (ret)
>>>>>> +		goto out;
>>>>>> +
>>>>>> +	/*
>>>>>> +	 * Emit the mapping request. If it fails, the ITS probably
>>>>>> +	 * isn't v4 compatible, so let's silently bail out. Holding
>>>>>> +	 * the ITS lock should ensure that nothing can modify the
>>>>>> +	 * target vcpu.
>>>>>> +	 */
>>>>>> +	map = (struct its_vlpi_map) {
>>>>>> +		.vm		= &kvm->arch.vgic.its_vm,
>>>>>> +		.vintid		= irq->intid,
>>>>>> +		.db_enabled	= true,
>>>>>> +		.vpe_idx	= irq->target_vcpu->vcpu_id,
>>>>
>>>> This is just wrong. We cannot assume that the vcpu_id has anything to do
>>>> with the vpe_idx. It happens to be the same thing now, but the two things
>>>> should be clearly disconnected.
>>>>
>>>> I suggest the following (untested):
>>>>
>>>> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
>>>> index cf5d6e2de6b8..0146e004401a 100644
>>>> --- a/virt/kvm/arm/vgic/vgic-v4.c
>>>> +++ b/virt/kvm/arm/vgic/vgic-v4.c
>>>> @@ -251,13 +251,27 @@ static void dump_routing(int virq, struct kvm_kernel_irq_routing_entry *irq_entr
>>>>  
>>>>  }
>>>>  
>>>> +static int vgic_v4_vcpu_to_index(struct its_vm *its_vm, struct kvm_vcpu *vcpu)
>>>> +{
>>>> +	int i;
>>>> +
>>>> +	for (i = 0; i < its_vm->nr_vpes; i++) {
>>>> +		struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
>>>> +
>>>> +		if (its_vm->vpes[i] == vpe)
>>>> +			return i;
>>>> +	}
>>>> +
>>>> +	return -ENODEV;
>>>> +}
>>>> +
>>>
>>> Stupid question: Can we change the struct its_vlpi_map to contain a
>>> vpe pointer or in stead of or in addition to the index?
>>
>> This is obviously the right solution, because the *index* of the VPE 
>> doesn't really matter for a map/unmap (it only matters for doorbell 
>> operations, and that's a very different code path).
>>
>> I came up with the following (untested, again), which is much more
>> appealing:
>>
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
>> index b47097a3e4b4..0607541fcafc 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -900,7 +900,7 @@ static void its_send_vmapti(struct its_device *dev, u32 id)
>>  	struct its_vlpi_map *map = &dev->event_map.vlpi_maps[id];
>>  	struct its_cmd_desc desc;
>>  
>> -	desc.its_vmapti_cmd.vpe = map->vm->vpes[map->vpe_idx];
>> +	desc.its_vmapti_cmd.vpe = map->vpe;
>>  	desc.its_vmapti_cmd.dev = dev;
>>  	desc.its_vmapti_cmd.virt_id = map->vintid;
>>  	desc.its_vmapti_cmd.event_id = id;
>> @@ -914,7 +914,7 @@ static void its_send_vmovi(struct its_device *dev, u32 id)
>>  	struct its_vlpi_map *map = &dev->event_map.vlpi_maps[id];
>>  	struct its_cmd_desc desc;
>>  
>> -	desc.its_vmovi_cmd.vpe = map->vm->vpes[map->vpe_idx];
>> +	desc.its_vmovi_cmd.vpe = map->vpe;
>>  	desc.its_vmovi_cmd.dev = dev;
>>  	desc.its_vmovi_cmd.event_id = id;
>>  	desc.its_vmovi_cmd.db_enabled = map->db_enabled;
>> diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
>> index 52661b838821..58a4d89aa82c 100644
>> --- a/include/linux/irqchip/arm-gic-v4.h
>> +++ b/include/linux/irqchip/arm-gic-v4.h
>> @@ -62,15 +62,15 @@ struct its_vpe {
>>   * irq_set_vcpu_affinity().
>>   *
>>   * @vm:		Pointer to the GICv4 notion of a VM
>> + * @vpe:	Pointer to the GICv4 notion of a virtual CPU (VPE)
>>   * @vintid:	Virtual LPI number
>>   * @db_enabled:	Is the VPE doorbell to be generated?
>> - * @vpe_idx:	Index (0-based) of the VPE in this VM. Not the vpe_id!
>>   */
>>  struct its_vlpi_map {
>>  	struct its_vm		*vm;
>> +	struct its_vpe		*vpe;
>>  	u32			vintid;
>>  	bool			db_enabled;
>> -	u16			vpe_idx;
>>  };
>>  
>>  enum its_vcpu_info_cmd_type {
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index d790d0c74b8b..6ba3d73e0f70 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -715,7 +715,7 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
>>  		if (ret)
>>  			return ret;
>>  
>> -		map.vpe_idx = vcpu->vcpu_id;
>> +		map.vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
>>  
>>  		return its_map_vlpi(ite->irq->host_irq, &map);
>>  	}
>> @@ -1184,7 +1184,7 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
>>  			struct its_vlpi_map map;
>>  
>>  			if (!its_get_vlpi(irq->host_irq, &map)) {
>> -				map.vpe_idx = vcpu2->vcpu_id;
>> +				map.vpe = &vcpu2->arch.vgic_cpu.vgic_v3.its_vpe;
>>  				its_map_vlpi(irq->host_irq, &map);
>>  			}
>>  		}
>> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
>> index cf5d6e2de6b8..6ece88322013 100644
>> --- a/virt/kvm/arm/vgic/vgic-v4.c
>> +++ b/virt/kvm/arm/vgic/vgic-v4.c
>> @@ -288,9 +288,9 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
>>  	 */
>>  	map = (struct its_vlpi_map) {
>>  		.vm		= &kvm->arch.vgic.its_vm,
>> +		.vpe		= &irq->target_vcpu->arch.vgic_cpu.vgic_v3.its_vpe,
>>  		.vintid		= irq->intid,
>>  		.db_enabled	= true,
>> -		.vpe_idx	= irq->target_vcpu->vcpu_id,
>>  	};
>>  
>>  	if (its_map_vlpi(virq, &map))
>>
>> Maybe I'll introduce a vcpu_to_vpe() helper, but it already looks much 
>> better to me...
>>
> Yes, indeed.  Looks good to me as well.
> 
> The only thing that makes me slightly nervous is the use of target_vcpu,
> but I think we rely on it never being NULL for LPIs elsewhere in the
> code, so we should be fine.
Hmmm. Maybe not. When mapping an LPI, you can assign it to a collection
that is not yet mapped to a redistributor, hence no target_vcpu.

But in this case, vgic_its_resolve_lpi() fails, and we just don't enter
this code path. Annoyingly, this also shows that I do not handle MAPC at
all in this code, which is pretty embarrassing (I rely on MAPC being
done before MAPI/MAPTI).

I'll address that in the next version.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
