From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v5 10/26] KVM: arm/arm64: GICv4: Wire mapping/unmapping
 of VLPIs in VFIO irq bypass
Date: Fri, 10 Nov 2017 09:28:46 +0100
Message-ID: <20171110082846.GH14144@cbox>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-11-marc.zyngier@arm.com>
 <1b60525f-5bb3-d19b-78df-fdfa5f48dc30@redhat.com>
 <0331ecc1-d4d6-420f-1ce8-7be1f386cdff@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF78349D40
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Nov 2017 03:26:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wwqzJo7OLi4i for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Nov 2017 03:26:40 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E93140FB0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Nov 2017 03:26:40 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id b9so1025979wmh.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Nov 2017 00:28:43 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <0331ecc1-d4d6-420f-1ce8-7be1f386cdff@arm.com>
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
Cc: kvm@vger.kernel.org, Andre Przywara <Andre.Przywara@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric and Marc,

On Tue, Nov 07, 2017 at 02:42:44PM +0000, Marc Zyngier wrote:
> Hi Eric,
> 
> On 07/11/17 13:06, Auger Eric wrote:
> > Hi Marc,
> > 
> > On 27/10/2017 16:28, Marc Zyngier wrote:
> >> Let's use the irq bypass mechanism introduced for platform device
> >> interrupts
> > nit: I would remove "introduced for platform device interrupts"
> > as this is not upstream yet. x86 posted interrupts also use it.
> > 
> >>
> >  and establish our LPI->VLPI mapping.

I have tweaked the commit message.

> >>
> >> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  include/kvm/arm_vgic.h      |   8 ++++
> >>  virt/kvm/arm/arm.c          |   6 ++-
> >>  virt/kvm/arm/vgic/vgic-v4.c | 108 ++++++++++++++++++++++++++++++++++++++++++++
> >>  3 files changed, 120 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> >> index 7eeb6c2a2f9c..2f750c770bf2 100644
> >> --- a/include/kvm/arm_vgic.h
> >> +++ b/include/kvm/arm_vgic.h
> >> @@ -373,4 +373,12 @@ int kvm_vgic_setup_default_irq_routing(struct kvm *kvm);
> >>  
> >>  int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned int intid, void *owner);
> >>  
> >> +struct kvm_kernel_irq_routing_entry;
> >> +
> >> +int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int irq,
> >> +			       struct kvm_kernel_irq_routing_entry *irq_entry);
> >> +
> >> +int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int irq,
> >> +				 struct kvm_kernel_irq_routing_entry *irq_entry);
> >> +
> >>  #endif /* __KVM_ARM_VGIC_H */
> >> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> >> index 5d5218ecd547..8388c1cc23f6 100644
> >> --- a/virt/kvm/arm/arm.c
> >> +++ b/virt/kvm/arm/arm.c
> >> @@ -1462,7 +1462,8 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
> >>  	struct kvm_kernel_irqfd *irqfd =
> >>  		container_of(cons, struct kvm_kernel_irqfd, consumer);
> >>  
> >> -	return 0;
> >> +	return kvm_vgic_v4_set_forwarding(irqfd->kvm, prod->irq,
> >> +					  &irqfd->irq_entry);
> >>  }
> >>  void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
> >>  				      struct irq_bypass_producer *prod)
> >> @@ -1470,7 +1471,8 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
> >>  	struct kvm_kernel_irqfd *irqfd =
> >>  		container_of(cons, struct kvm_kernel_irqfd, consumer);
> >>  
> >> -	return;
> >> +	kvm_vgic_v4_unset_forwarding(irqfd->kvm, prod->irq,
> >> +				     &irqfd->irq_entry);
> >>  }
> >>  
> >>  void kvm_arch_irq_bypass_stop(struct irq_bypass_consumer *cons)
> >> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
> >> index c794f0cef09e..01a2889b7b7c 100644
> >> --- a/virt/kvm/arm/vgic/vgic-v4.c
> >> +++ b/virt/kvm/arm/vgic/vgic-v4.c
> >> @@ -18,6 +18,7 @@
> >>  #include <linux/interrupt.h>
> >>  #include <linux/irqdomain.h>
> >>  #include <linux/kvm_host.h>
> >> +#include <linux/irqchip/arm-gic-v3.h>
> >>  
> >>  #include "vgic.h"
> >>  
> >> @@ -81,3 +82,110 @@ void vgic_v4_teardown(struct kvm *kvm)
> >>  	its_vm->nr_vpes = 0;
> >>  	its_vm->vpes = NULL;
> >>  }
> >> +
> >> +static struct vgic_its *vgic_get_its(struct kvm *kvm,
> >> +				     struct kvm_kernel_irq_routing_entry *irq_entry)
> >> +{
> >> +	struct kvm_msi msi  = (struct kvm_msi) {
> >> +		.address_lo	= irq_entry->msi.address_lo,
> >> +		.address_hi	= irq_entry->msi.address_hi,
> >> +		.data		= irq_entry->msi.data,
> >> +		.flags		= irq_entry->msi.flags,
> >> +		.devid		= irq_entry->msi.devid,
> >> +	};
> >> +
> >> +	/*
> >> +	 * Get a reference on the LPI. If NULL, this is not a valid
> >> +	 * translation for any of our vITSs.
> >> +	 */
> > I don't understand the relevance of the above comment.
> 
> Hmmm. The first part looks like an outdated leftover, as the ITS is not
> refcounted, and we don't deal with LPIs here.
> 

I simply removed this comment.

[...]

I think the only thing left to fix on this patch is the IRQ_DISABLE_LAZY
thing on its_map_vlpi() failures, which Marc can fix post -rc1.

Thanks,
-Christoffer
