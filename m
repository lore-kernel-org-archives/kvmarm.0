From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v5 10/26] KVM: arm/arm64: GICv4: Wire mapping/unmapping of
 VLPIs in VFIO irq bypass
Date: Fri, 10 Nov 2017 10:41:34 +0100
Message-ID: <CAMJs5B_Jb_FE3OWpM1Yg1GGu0rq02RzsW70ie9ZUhzTek__RZQ@mail.gmail.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-11-marc.zyngier@arm.com>
 <1b60525f-5bb3-d19b-78df-fdfa5f48dc30@redhat.com>
 <0331ecc1-d4d6-420f-1ce8-7be1f386cdff@arm.com>
 <20171110082846.GH14144@cbox> <b9a0e890-f92c-b174-0959-5f14fd3ac726@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE21749D4B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Nov 2017 04:39:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jo90qRmIqEec for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Nov 2017 04:39:33 -0500 (EST)
Received: from mail-pf0-f193.google.com (mail-pf0-f193.google.com
 [209.85.192.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7DE9D40795
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Nov 2017 04:39:33 -0500 (EST)
Received: by mail-pf0-f193.google.com with SMTP id b85so6327767pfj.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Nov 2017 01:41:35 -0800 (PST)
In-Reply-To: <b9a0e890-f92c-b174-0959-5f14fd3ac726@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Andre Przywara <Andre.Przywara@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 10, 2017 at 10:05 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 10/11/17 08:28, Christoffer Dall wrote:
>> Hi Eric and Marc,
>>
>> On Tue, Nov 07, 2017 at 02:42:44PM +0000, Marc Zyngier wrote:
>>> Hi Eric,
>>>
>>> On 07/11/17 13:06, Auger Eric wrote:
>>>> Hi Marc,
>>>>
>>>> On 27/10/2017 16:28, Marc Zyngier wrote:
>>>>> Let's use the irq bypass mechanism introduced for platform device
>>>>> interrupts
>>>> nit: I would remove "introduced for platform device interrupts"
>>>> as this is not upstream yet. x86 posted interrupts also use it.
>>>>
>>>>>
>>>>  and establish our LPI->VLPI mapping.
>>
>> I have tweaked the commit message.
>>
>>>>>
>>>>> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
>>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>>> ---
>>>>>  include/kvm/arm_vgic.h      |   8 ++++
>>>>>  virt/kvm/arm/arm.c          |   6 ++-
>>>>>  virt/kvm/arm/vgic/vgic-v4.c | 108 ++++++++++++++++++++++++++++++++++++++++++++
>>>>>  3 files changed, 120 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>>>>> index 7eeb6c2a2f9c..2f750c770bf2 100644
>>>>> --- a/include/kvm/arm_vgic.h
>>>>> +++ b/include/kvm/arm_vgic.h
>>>>> @@ -373,4 +373,12 @@ int kvm_vgic_setup_default_irq_routing(struct kvm *kvm);
>>>>>
>>>>>  int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned int intid, void *owner);
>>>>>
>>>>> +struct kvm_kernel_irq_routing_entry;
>>>>> +
>>>>> +int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int irq,
>>>>> +                         struct kvm_kernel_irq_routing_entry *irq_entry);
>>>>> +
>>>>> +int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int irq,
>>>>> +                           struct kvm_kernel_irq_routing_entry *irq_entry);
>>>>> +
>>>>>  #endif /* __KVM_ARM_VGIC_H */
>>>>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>>>>> index 5d5218ecd547..8388c1cc23f6 100644
>>>>> --- a/virt/kvm/arm/arm.c
>>>>> +++ b/virt/kvm/arm/arm.c
>>>>> @@ -1462,7 +1462,8 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
>>>>>    struct kvm_kernel_irqfd *irqfd =
>>>>>            container_of(cons, struct kvm_kernel_irqfd, consumer);
>>>>>
>>>>> -  return 0;
>>>>> +  return kvm_vgic_v4_set_forwarding(irqfd->kvm, prod->irq,
>>>>> +                                    &irqfd->irq_entry);
>>>>>  }
>>>>>  void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
>>>>>                                  struct irq_bypass_producer *prod)
>>>>> @@ -1470,7 +1471,8 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
>>>>>    struct kvm_kernel_irqfd *irqfd =
>>>>>            container_of(cons, struct kvm_kernel_irqfd, consumer);
>>>>>
>>>>> -  return;
>>>>> +  kvm_vgic_v4_unset_forwarding(irqfd->kvm, prod->irq,
>>>>> +                               &irqfd->irq_entry);
>>>>>  }
>>>>>
>>>>>  void kvm_arch_irq_bypass_stop(struct irq_bypass_consumer *cons)
>>>>> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
>>>>> index c794f0cef09e..01a2889b7b7c 100644
>>>>> --- a/virt/kvm/arm/vgic/vgic-v4.c
>>>>> +++ b/virt/kvm/arm/vgic/vgic-v4.c
>>>>> @@ -18,6 +18,7 @@
>>>>>  #include <linux/interrupt.h>
>>>>>  #include <linux/irqdomain.h>
>>>>>  #include <linux/kvm_host.h>
>>>>> +#include <linux/irqchip/arm-gic-v3.h>
>>>>>
>>>>>  #include "vgic.h"
>>>>>
>>>>> @@ -81,3 +82,110 @@ void vgic_v4_teardown(struct kvm *kvm)
>>>>>    its_vm->nr_vpes = 0;
>>>>>    its_vm->vpes = NULL;
>>>>>  }
>>>>> +
>>>>> +static struct vgic_its *vgic_get_its(struct kvm *kvm,
>>>>> +                               struct kvm_kernel_irq_routing_entry *irq_entry)
>>>>> +{
>>>>> +  struct kvm_msi msi  = (struct kvm_msi) {
>>>>> +          .address_lo     = irq_entry->msi.address_lo,
>>>>> +          .address_hi     = irq_entry->msi.address_hi,
>>>>> +          .data           = irq_entry->msi.data,
>>>>> +          .flags          = irq_entry->msi.flags,
>>>>> +          .devid          = irq_entry->msi.devid,
>>>>> +  };
>>>>> +
>>>>> +  /*
>>>>> +   * Get a reference on the LPI. If NULL, this is not a valid
>>>>> +   * translation for any of our vITSs.
>>>>> +   */
>>>> I don't understand the relevance of the above comment.
>>>
>>> Hmmm. The first part looks like an outdated leftover, as the ITS is not
>>> refcounted, and we don't deal with LPIs here.
>>>
>>
>> I simply removed this comment.
>>
>> [...]
>>
>> I think the only thing left to fix on this patch is the IRQ_DISABLE_LAZY
>> thing on its_map_vlpi() failures, which Marc can fix post -rc1.
>
> Here's what I've queued on the irqchip side:
>
> From 9c0733704b99c89773416af3a412332b0e8bd2a4 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <marc.zyngier@arm.com>
> Date: Fri, 10 Nov 2017 09:00:41 +0000
> Subject: [PATCH] irqchip/gic-v4: Clear IRQ_DISABLE_UNLAZY again if mapping
>  fails
>
> Should the call to irq_set_vcpu_affinity() fail at map time,
> we should restore the normal lazy-disable behaviour instead
> of staying with the eager disable that GICv4 requires.
>
> Reported-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  drivers/irqchip/irq-gic-v4.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
> index cd0bcc3b7e33..dba9d67cb9c1 100644
> --- a/drivers/irqchip/irq-gic-v4.c
> +++ b/drivers/irqchip/irq-gic-v4.c
> @@ -177,6 +177,7 @@ int its_map_vlpi(int irq, struct its_vlpi_map *map)
>                         .map      = map,
>                 },
>         };
> +       int ret;
>
>         /*
>          * The host will never see that interrupt firing again, so it
> @@ -184,7 +185,11 @@ int its_map_vlpi(int irq, struct its_vlpi_map *map)
>          */
>         irq_set_status_flags(irq, IRQ_DISABLE_UNLAZY);
>
> -       return irq_set_vcpu_affinity(irq, &info);
> +       ret = irq_set_vcpu_affinity(irq, &info);
> +       if (ret)
> +               irq_clear_status_flags(irq, IRQ_DISABLE_UNLAZY);
> +
> +       return ret;
>  }
>
>  int its_get_vlpi(int irq, struct its_vlpi_map *map)
> --
> 2.14.2
>
>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
