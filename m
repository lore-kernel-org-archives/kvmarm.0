From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 10/26] KVM: arm/arm64: GICv4: Wire mapping/unmapping of
 VLPIs in VFIO irq bypass
Date: Wed, 8 Nov 2017 11:30:08 +0000
Message-ID: <a921378a-bfca-16c0-e4e8-08592e2bbe6d@arm.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-11-marc.zyngier@arm.com>
 <1b60525f-5bb3-d19b-78df-fdfa5f48dc30@redhat.com>
 <0331ecc1-d4d6-420f-1ce8-7be1f386cdff@arm.com>
 <99bf85e8-d290-b2fa-610d-7fdeaf229940@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <99bf85e8-d290-b2fa-610d-7fdeaf229940@redhat.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 07/11/17 15:59, Auger Eric wrote:
> Hi,
> 
> On 07/11/2017 15:42, Marc Zyngier wrote:
>> Hi Eric,
>>
>> On 07/11/17 13:06, Auger Eric wrote:
>>> Hi Marc,
>>>
>>> On 27/10/2017 16:28, Marc Zyngier wrote:
>>>> Let's use the irq bypass mechanism introduced for platform device
>>>> interrupts
>>> nit: I would remove "introduced for platform device interrupts"
>>> as this is not upstream yet. x86 posted interrupts also use it.
>>>
>>>>
>>>  and establish our LPI->VLPI mapping.
>>>>
>>>> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>> ---
>>>>  include/kvm/arm_vgic.h      |   8 ++++
>>>>  virt/kvm/arm/arm.c          |   6 ++-
>>>>  virt/kvm/arm/vgic/vgic-v4.c | 108 ++++++++++++++++++++++++++++++++++++++++++++
>>>>  3 files changed, 120 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>>>> index 7eeb6c2a2f9c..2f750c770bf2 100644
>>>> --- a/include/kvm/arm_vgic.h
>>>> +++ b/include/kvm/arm_vgic.h
>>>> @@ -373,4 +373,12 @@ int kvm_vgic_setup_default_irq_routing(struct kvm *kvm);
>>>>  
>>>>  int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned int intid, void *owner);
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
>>>> index 5d5218ecd547..8388c1cc23f6 100644
>>>> --- a/virt/kvm/arm/arm.c
>>>> +++ b/virt/kvm/arm/arm.c
>>>> @@ -1462,7 +1462,8 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
>>>>  	struct kvm_kernel_irqfd *irqfd =
>>>>  		container_of(cons, struct kvm_kernel_irqfd, consumer);
>>>>  
>>>> -	return 0;
>>>> +	return kvm_vgic_v4_set_forwarding(irqfd->kvm, prod->irq,
>>>> +					  &irqfd->irq_entry);
>>>>  }
>>>>  void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
>>>>  				      struct irq_bypass_producer *prod)
>>>> @@ -1470,7 +1471,8 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
>>>>  	struct kvm_kernel_irqfd *irqfd =
>>>>  		container_of(cons, struct kvm_kernel_irqfd, consumer);
>>>>  
>>>> -	return;
>>>> +	kvm_vgic_v4_unset_forwarding(irqfd->kvm, prod->irq,
>>>> +				     &irqfd->irq_entry);
>>>>  }
>>>>  
>>>>  void kvm_arch_irq_bypass_stop(struct irq_bypass_consumer *cons)
>>>> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
>>>> index c794f0cef09e..01a2889b7b7c 100644
>>>> --- a/virt/kvm/arm/vgic/vgic-v4.c
>>>> +++ b/virt/kvm/arm/vgic/vgic-v4.c
>>>> @@ -18,6 +18,7 @@
>>>>  #include <linux/interrupt.h>
>>>>  #include <linux/irqdomain.h>
>>>>  #include <linux/kvm_host.h>
>>>> +#include <linux/irqchip/arm-gic-v3.h>
>>>>  
>>>>  #include "vgic.h"
>>>>  
>>>> @@ -81,3 +82,110 @@ void vgic_v4_teardown(struct kvm *kvm)
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
>>> I don't understand the relevance of the above comment.
>>
>> Hmmm. The first part looks like an outdated leftover, as the ITS is not
>> refcounted, and we don't deal with LPIs here.
>>
>>>> +	return vgic_msi_to_its(kvm, &msi);
>>>> +}
>>>> +
>>>> +int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
>>> @virq is the host linux irq. virq naming is a bit confusing to me.
>>
>> There is plenty of irq-related code that uses this naming. In this
>> context, we tend to use irq for the vgic view, hwirq for the irqchip
>> view. How would you call this one?
> OK
>>
>>>> +			       struct kvm_kernel_irq_routing_entry *irq_entry)
>>>> +{
>>>> +	struct vgic_its *its;
>>>> +	struct vgic_irq *irq;
>>>> +	struct its_vlpi_map map;
>>>> +	int ret;
>>>> +
>>> Don't you need to check that the linux irq (virq) is an LPI? You may
>>> encounter some VFIO "producers" for irq that are not LPIs, typically if
>>> we eventually upstream SPI forwarding.
>>
>> That's indeed a concern. The issue is that we don't really have a way to
>> check this, other than following the irq_data pointers and check that
>> the hwirq is within a certain range. And even that doesn't guarantee
>> anything.
> OK. But somehow this means the userspace can setup forwarding between an
> SPI and a vLPI, right?

Not really, or at least not as long as we only support PCI. It would
have to be that although you have a GICv4 system, you end-up with an MSI
that is assigned to a GICv2m on the physical side. This cannot happen,
by definition.

So we're actually left with the platform case. An easy way to filter
things would be to look at the routing entry flags, and see if we have a
DEVID there. That would guarantee us that this is an LPI.

[...]

>>>> +	map = (struct its_vlpi_map) {
>>>> +		.vm		= &kvm->arch.vgic.its_vm,
>>>> +		.vpe		= &irq->target_vcpu->arch.vgic_cpu.vgic_v3.its_vpe,
>>>> +		.vintid		= irq->intid,
>>>> +		.properties	= ((irq->priority & 0xfc) |
>>>> +				   (irq->enabled ? LPI_PROP_ENABLED : 0) |
>>>> +				   LPI_PROP_GROUP1),
>>> there is an inconsistency between the comment in irqchip/arm-gic-v4.h
>>> and this setting:
>>>
>>> * @properties: Priority and enable bits (as written in the prop table)
>>
>> Which inconsistency?
> I was confused by LPI_PROP_GROUP1 which was not documented in the
> comment. But looking more carefully in the spec it corresponds to [1] =
> RES1.

Yes, this is a leftover from previous revision of the architecture. That
bit used to be the Group configuration, with only group-1 being valid...
It got turned into a RES1 at a later time.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
