From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 4/5] KVM: arm/arm64: Support VGIC dist pend/active
 changes for mapped IRQs
Date: Fri, 8 Sep 2017 18:05:58 +0200
Message-ID: <CAMJs5B89AsrDMhuNjC7La2ZP+ndiAWhY=7nqTbq1v6mp7=BDqA@mail.gmail.com>
References: <20170906122612.18050-1-cdall@linaro.org> <20170906122612.18050-5-cdall@linaro.org>
 <d51a40df-92f9-eeff-0d16-ea12fd451dea@redhat.com> <2e1352d7-fb64-907d-7726-4d53d7af5768@arm.com>
 <5579210b-9b62-b33d-ac36-df3cb835c1e7@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5579210b-9b62-b33d-ac36-df3cb835c1e7@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Andre Przywara <andre.przywara@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 8, 2017 at 4:27 PM, Auger Eric <eric.auger@redhat.com> wrote:
> Hi Marc,
>
> On 08/09/2017 15:32, Marc Zyngier wrote:
>> On 08/09/17 14:04, Auger Eric wrote:
>>> Hi Christoffer,
>>>
>>> On 06/09/2017 14:26, Christoffer Dall wrote:
>>>> For mapped IRQs (with the HW bit set in the LR) we have to follow some
>>>> rules of the architecture.  One of these rules is that VM must not be
>>>> allowed to deactivate a virtual interrupt with the HW bit set unless the
>>>> physical interrupt is also active.
>>>>
>>>> This works fine when injecting mapped interrupts, because we leave it up
>>>> to the injector to either set EOImode==1 or manually set the active
>>>> state of the physical interrupt.
>>>>
>>>> However, the guest can set virtual interrupt to be pending or active by
>>>> writing to the virtual distributor, which could lead to deactivating a
>>>> virtual interrupt with the HW bit set without the physical interrupt
>>>> being active.
>>>>
>>>> We could set the physical interrupt to active whenever we are about to
>>>> enter the VM with a HW interrupt either pending or active, but that
>>>> would be really slow, especially on GICv2.  So we take the long way
>>>> around and do the hard work when needed, which is expected to be
>>>> extremely rare.
>>>>
>>>> When the VM sets the pending state for a HW interrupt on the virtual
>>>> distributor we set the active state on the physical distributor, because
>>>> the virtual interrupt can become active and then the guest can
>>>> deactivate it.
>>>>
>>>> When the VM clears the pending state we also clear it on the physical
>>>> side, because the injector might otherwise raise the interrupt.
>>>>
>>>> Signed-off-by: Christoffer Dall <cdall@linaro.org>
>>>> ---
>>>>  virt/kvm/arm/vgic/vgic-mmio.c | 33 +++++++++++++++++++++++++++++++++
>>>>  virt/kvm/arm/vgic/vgic.c      |  7 +++++++
>>>>  virt/kvm/arm/vgic/vgic.h      |  1 +
>>>>  3 files changed, 41 insertions(+)
>>>>
>>>> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
>>>> index c1e4bdd..00003ae 100644
>>>> --- a/virt/kvm/arm/vgic/vgic-mmio.c
>>>> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
>>>> @@ -131,6 +131,9 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
>>>>             struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>>>>
>>>>             spin_lock(&irq->irq_lock);
>>>> +           if (irq->hw)
>>>> +                   vgic_irq_set_phys_active(irq, true);
>>>> +
>>>>             irq->pending_latch = true;
>>>>
>>>>             vgic_queue_irq_unlock(vcpu->kvm, irq);
>>>> @@ -149,6 +152,20 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
>>>>             struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>>>>
>>>>             spin_lock(&irq->irq_lock);
>>>> +           /*
>>>> +            * We don't want the guest to effectively mask the physical
>>>> +            * interrupt by doing a write to SPENDR followed by a write to
>>>> +            * CPENDR for HW interrupts, so we clear the active state on
>>>> +            * the physical side here.  This may lead to taking an
>>>> +            * additional interrupt on the host, but that should not be a
>>>> +            * problem as the worst that can happen is an additional vgic
>>>> +            * injection.  We also clear the pending state to maintain
>>>> +            * proper semantics for edge HW interrupts.
>>>> +            */
>>>> +           if (irq->hw) {
>>>> +                   vgic_irq_set_phys_pending(irq, false);
>>>> +                   vgic_irq_set_phys_active(irq, false);
>>> I fail in understanding why the active state is reset here. Can you
>>> provide an example?
>>
>>
>> If we're clearing the pending state on the virtual side, we need to be
>> able to let an incoming physical interrupt fire so that it can be made
>> pending again. We may have to check that the virtual active state is
>> clear though.
>>
>>> If the physical dist has an active state can't the virtual IRQ be in
>>> active state, in which case you may later on deactivate a phys IRQ which
>>> is not active?
>>
>>
>> Well, I think we must be able to handle both cases:
>>
>> - CPENDR write:
>>       clear physical pending
>>       if (virtual active clear)
>>               clear physical active
>>
>> - CACTIVER write:
>>       clear physical active
>>
>> Does this work for you?
>
> yes it does with that change!
>
I agree, I should fix that.

But then I wondered, are we properly handling PPIs for
setting/clearing the pending state?  Don't we actually need to do
something similar like the active cpu where we check the requester CPU
and make sure we're not fiddling with some random hardware state when
accessed by userspace?

Thanks,
-Christoffer
