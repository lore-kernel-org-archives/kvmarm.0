From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 41/59] KVM: arm/arm64: GICv4: Wire mapping/unmapping of
 VLPIs in VFIO irq bypass
Date: Wed, 30 Aug 2017 11:42:46 +0100
Message-ID: <6c6aad59-8e36-dc7e-1aef-8f95de7d7eef@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-42-marc.zyngier@arm.com> <20170826194850.GB11074@cbox>
 <53116ae6-fd94-2687-740f-5917e158eda7@arm.com>
 <a6f5aa8e-e4ab-4a9d-3b86-0dd5d0c8c745@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF7C34104E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Aug 2017 06:40:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R48EN-2Uptmj for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Aug 2017 06:40:39 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4774D40FB0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Aug 2017 06:40:39 -0400 (EDT)
In-Reply-To: <a6f5aa8e-e4ab-4a9d-3b86-0dd5d0c8c745@redhat.com>
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
To: Auger Eric <eric.auger@redhat.com>, Christoffer Dall <cdall@linaro.org>
Cc: Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On 30/08/17 11:20, Auger Eric wrote:
> Hi Marc,
> 
> On 30/08/2017 11:42, Marc Zyngier wrote:
>> On 26/08/17 20:48, Christoffer Dall wrote:
>>> On Mon, Jul 31, 2017 at 06:26:19PM +0100, Marc Zyngier wrote:
>>>> Let's use the irq bypass mechanism introduced for platform device
>>>> interrupts to intercept the virtual PCIe endpoint configuration
>>>> and establish our LPI->VLPI mapping.
>>>>
>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>> ---
>>>>  include/kvm/arm_vgic.h      |   8 ++++
>>>>  virt/kvm/arm/arm.c          |  27 ++++++++----
>>>>  virt/kvm/arm/vgic/vgic-v4.c | 103 ++++++++++++++++++++++++++++++++++++++++++++
>>>>  3 files changed, 130 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>>>> index 359eeffe9857..050f78d4fb42 100644
>>>> --- a/include/kvm/arm_vgic.h
>>>> +++ b/include/kvm/arm_vgic.h
>>>> @@ -367,4 +367,12 @@ int kvm_vgic_set_forwarding(struct kvm *kvm, unsigned int host_irq,
>>>>  void kvm_vgic_unset_forwarding(struct kvm *kvm, unsigned int host_irq,
>>>>  			       unsigned int vintid);
>>>>  
>>>> +struct kvm_kernel_irq_routing_entry;
>>>> +
>>>> +int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int irq,
>>>> +			       struct kvm_kernel_irq_routing_entry *irq_entry);
>>>> +
>>>> +int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int irq,
>>>> +				 struct kvm_kernel_irq_routing_entry *irq_entry);
>>>> +
>>>>  #endif /* __KVM_ARM_VGIC_H */
>>>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>>>> index ebab6c29e3be..6803ea27c47d 100644
>>>> --- a/virt/kvm/arm/arm.c
>>>> +++ b/virt/kvm/arm/arm.c
>>>> @@ -1457,11 +1457,16 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
>>>>  	struct kvm_kernel_irqfd *irqfd =
>>>>  		container_of(cons, struct kvm_kernel_irqfd, consumer);
>>>>  
>>>> -	if (prod->type != IRQ_BYPASS_VFIO_PLATFORM)
>>>> +	switch (prod->type) {
>>>> +	case IRQ_BYPASS_VFIO_PLATFORM:
>>>> +		return kvm_vgic_set_forwarding(irqfd->kvm, prod->irq,
>>>> +					       irqfd->gsi + VGIC_NR_PRIVATE_IRQS);
>>>> +	case IRQ_BYPASS_VFIO_PCI_MSI:
>>>> +		return kvm_vgic_v4_set_forwarding(irqfd->kvm, prod->irq,
>>>> +						  &irqfd->irq_entry);
>>>> +	default:
>>>>  		return 0;
>>>> -
>>>> -	return kvm_vgic_set_forwarding(irqfd->kvm, prod->irq,
>>>> -				       irqfd->gsi + VGIC_NR_PRIVATE_IRQS);
>>>> +	}
>>>>  }
>>>>  void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
>>>>  				      struct irq_bypass_producer *prod)
>>>> @@ -1469,11 +1474,17 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
>>>>  	struct kvm_kernel_irqfd *irqfd =
>>>>  		container_of(cons, struct kvm_kernel_irqfd, consumer);
>>>>  
>>>> -	if (prod->type != IRQ_BYPASS_VFIO_PLATFORM)
>>>> -		return;
>>>> +	switch (prod->type) {
>>>> +	case IRQ_BYPASS_VFIO_PLATFORM:
>>>> +		kvm_vgic_unset_forwarding(irqfd->kvm, prod->irq,
>>>> +					  irqfd->gsi + VGIC_NR_PRIVATE_IRQS);
>>>> +		break;
>>>>  
>>>> -	kvm_vgic_unset_forwarding(irqfd->kvm, prod->irq,
>>>> -				  irqfd->gsi + VGIC_NR_PRIVATE_IRQS);
>>>> +	case IRQ_BYPASS_VFIO_PCI_MSI:
>>>> +		kvm_vgic_v4_unset_forwarding(irqfd->kvm, prod->irq,
>>>> +					     &irqfd->irq_entry);
>>>> +		break;
>>>> +	}
>>>>  }
>>>>  
>>>>  void kvm_arch_irq_bypass_stop(struct irq_bypass_consumer *cons)
>>>> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
>>>> index 207e1fda0dcd..338c86c5159f 100644
>>>> --- a/virt/kvm/arm/vgic/vgic-v4.c
>>>> +++ b/virt/kvm/arm/vgic/vgic-v4.c
>>>> @@ -72,3 +72,106 @@ void vgic_v4_teardown(struct kvm *kvm)
>>>>  	its_vm->nr_vpes = 0;
>>>>  	its_vm->vpes = NULL;
>>>>  }
>>>> +
>>>> +static struct vgic_its *vgic_get_its(struct kvm *kvm,
>>>> +				     struct kvm_kernel_irq_routing_entry *irq_entry)
>>>> +{
>>>> +	struct kvm_msi msi  = (struct kvm_msi) {
>>>> +		.address_lo	= irq_entry->msi.address_lo,
>>>> +		.address_hi	= irq_entry->msi.address_hi,
>>>> +		.data		= irq_entry->msi.data,
>>>> +		.flags		= irq_entry->msi.flags,
>>>> +		.devid		= irq_entry->msi.devid,
>>>> +	};
>>>> +
>>>> +	/*
>>>> +	 * Get a reference on the LPI. If NULL, this is not a valid
>>>> +	 * translation for any of our vITSs.
>>>> +	 */
>>>> +	return vgic_msi_to_its(kvm, &msi);
>>>> +}
>>>> +
>>>> +int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
>>>> +			       struct kvm_kernel_irq_routing_entry *irq_entry)
>>>> +{
>>>> +	struct vgic_its *its;
>>>> +	struct vgic_irq *irq;
>>>> +	struct its_vlpi_map map;
>>>> +	int ret;
>>>> +
>>>> +	if (!vgic_is_v4_capable(kvm))
>>>> +		return 0;
>>>> +
>>>> +	/*
>>>> +	 * Get the ITS, and escape early on error (not a valid
>>>> +	 * doorbell for any of our vITSs).
>>>> +	 */
>>>> +	its = vgic_get_its(kvm, irq_entry);
>>>> +	if (IS_ERR(its))
>>>> +		return 0;
>>>> +
>>>> +	mutex_lock(&its->its_lock);
>>>> +
>>>> +	/* Perform then actual DevID/EventID -> LPI translation. */
>>>> +	ret = vgic_its_resolve_lpi(kvm, its, irq_entry->msi.devid,
>>>> +				   irq_entry->msi.data, &irq);
>>>> +	if (ret)
>>>> +		goto out;
>>>> +
>>>> +	/*
>>>> +	 * Emit the mapping request. If it fails, the ITS probably
>>>> +	 * isn't v4 compatible, so let's silently bail out. Holding
>>>> +	 * the ITS lock should ensure that nothing can modify the
>>>> +	 * target vcpu.
>>>> +	 */
>>>> +	map = (struct its_vlpi_map) {
>>>> +		.vm		= &kvm->arch.vgic.its_vm,
>>>> +		.vintid		= irq->intid,
>>>> +		.db_enabled	= true,
>>>> +		.vpe_idx	= irq->target_vcpu->vcpu_id,
>>>> +	};
>>>> +
>>>> +	if (its_map_vlpi(virq, &map))
>>>> +		goto out;
>>>
>>> This seems to be able to return things like -ENOMEM, whould we really
>>> not report this back to the caller in any way?
>>
>>
>> That's a good question.
>>
>> If we return -ENOMEM, we'll probably end-up returning an error to
>> userspace (as a result of the VFIO ioctl), which will in turn probably
>> terminate the guest (I'm guessing, I haven't actually looked at what
>> userspace does).
>>
>> If we don't return the error, then we have a chance to keep the guest
>> running by sticking to software injection.
> I have not read the whole stuff yet but userspace is not aware of this
> negotiation. Everything happens under the hood in kernel, see
> virt/lib/irqbypass.c __connect(): if add_producer() fails
> prod->del_consumer() is called and we should return to the not optimized
> injection.

Ah, fair enough. I guess del_consumer() does nothing on PCI?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
