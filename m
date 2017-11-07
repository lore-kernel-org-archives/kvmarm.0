From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 10/26] KVM: arm/arm64: GICv4: Wire mapping/unmapping of
 VLPIs in VFIO irq bypass
Date: Tue, 7 Nov 2017 14:06:36 +0100
Message-ID: <1b60525f-5bb3-d19b-78df-fdfa5f48dc30@redhat.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-11-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2590A49D4E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 08:04:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WMi2Snb5tsQ1 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Nov 2017 08:04:47 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA6ED40418
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 08:04:47 -0500 (EST)
In-Reply-To: <20171027142855.21584-11-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 27/10/2017 16:28, Marc Zyngier wrote:
> Let's use the irq bypass mechanism introduced for platform device
> interrupts
nit: I would remove "introduced for platform device interrupts"
as this is not upstream yet. x86 posted interrupts also use it.

>
 and establish our LPI->VLPI mapping.
> 
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  include/kvm/arm_vgic.h      |   8 ++++
>  virt/kvm/arm/arm.c          |   6 ++-
>  virt/kvm/arm/vgic/vgic-v4.c | 108 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 120 insertions(+), 2 deletions(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 7eeb6c2a2f9c..2f750c770bf2 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -373,4 +373,12 @@ int kvm_vgic_setup_default_irq_routing(struct kvm *kvm);
>  
>  int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned int intid, void *owner);
>  
> +struct kvm_kernel_irq_routing_entry;
> +
> +int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int irq,
> +			       struct kvm_kernel_irq_routing_entry *irq_entry);
> +
> +int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int irq,
> +				 struct kvm_kernel_irq_routing_entry *irq_entry);
> +
>  #endif /* __KVM_ARM_VGIC_H */
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 5d5218ecd547..8388c1cc23f6 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1462,7 +1462,8 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
>  	struct kvm_kernel_irqfd *irqfd =
>  		container_of(cons, struct kvm_kernel_irqfd, consumer);
>  
> -	return 0;
> +	return kvm_vgic_v4_set_forwarding(irqfd->kvm, prod->irq,
> +					  &irqfd->irq_entry);
>  }
>  void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
>  				      struct irq_bypass_producer *prod)
> @@ -1470,7 +1471,8 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
>  	struct kvm_kernel_irqfd *irqfd =
>  		container_of(cons, struct kvm_kernel_irqfd, consumer);
>  
> -	return;
> +	kvm_vgic_v4_unset_forwarding(irqfd->kvm, prod->irq,
> +				     &irqfd->irq_entry);
>  }
>  
>  void kvm_arch_irq_bypass_stop(struct irq_bypass_consumer *cons)
> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
> index c794f0cef09e..01a2889b7b7c 100644
> --- a/virt/kvm/arm/vgic/vgic-v4.c
> +++ b/virt/kvm/arm/vgic/vgic-v4.c
> @@ -18,6 +18,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/irqdomain.h>
>  #include <linux/kvm_host.h>
> +#include <linux/irqchip/arm-gic-v3.h>
>  
>  #include "vgic.h"
>  
> @@ -81,3 +82,110 @@ void vgic_v4_teardown(struct kvm *kvm)
>  	its_vm->nr_vpes = 0;
>  	its_vm->vpes = NULL;
>  }
> +
> +static struct vgic_its *vgic_get_its(struct kvm *kvm,
> +				     struct kvm_kernel_irq_routing_entry *irq_entry)
> +{
> +	struct kvm_msi msi  = (struct kvm_msi) {
> +		.address_lo	= irq_entry->msi.address_lo,
> +		.address_hi	= irq_entry->msi.address_hi,
> +		.data		= irq_entry->msi.data,
> +		.flags		= irq_entry->msi.flags,
> +		.devid		= irq_entry->msi.devid,
> +	};
> +
> +	/*
> +	 * Get a reference on the LPI. If NULL, this is not a valid
> +	 * translation for any of our vITSs.
> +	 */
I don't understand the relevance of the above comment.
> +	return vgic_msi_to_its(kvm, &msi);
> +}
> +
> +int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
@virq is the host linux irq. virq naming is a bit confusing to me.
> +			       struct kvm_kernel_irq_routing_entry *irq_entry)
> +{
> +	struct vgic_its *its;
> +	struct vgic_irq *irq;
> +	struct its_vlpi_map map;
> +	int ret;
> +
Don't you need to check that the linux irq (virq) is an LPI? You may
encounter some VFIO "producers" for irq that are not LPIs, typically if
we eventually upstream SPI forwarding.
> +	if (!vgic_supports_direct_msis(kvm))
> +		return 0;
> +
> +	/*
> +	 * Get the ITS, and escape early on error (not a valid
> +	 * doorbell for any of our vITSs).
> +	 */
> +	its = vgic_get_its(kvm, irq_entry);
> +	if (IS_ERR(its))
> +		return 0;
> +
> +	mutex_lock(&its->its_lock);
wouldn't it be safer to take the its_lock before the get_its()? and even
before the vgic_supports_direct_msis, in an unlikely case where the its
would disappear?
> +
> +	/* Perform then actual DevID/EventID -> LPI translation. */
> +	ret = vgic_its_resolve_lpi(kvm, its, irq_entry->msi.devid,
> +				   irq_entry->msi.data, &irq);
> +	if (ret)
> +		goto out;
> +
> +	/*
> +	 * Emit the mapping request. If it fails, the ITS probably
> +	 * isn't v4 compatible, so let's silently bail out. Holding
> +	 * the ITS lock should ensure that nothing can modify the
> +	 * target vcpu.
> +	 */
> +	map = (struct its_vlpi_map) {
> +		.vm		= &kvm->arch.vgic.its_vm,
> +		.vpe		= &irq->target_vcpu->arch.vgic_cpu.vgic_v3.its_vpe,
> +		.vintid		= irq->intid,
> +		.properties	= ((irq->priority & 0xfc) |
> +				   (irq->enabled ? LPI_PROP_ENABLED : 0) |
> +				   LPI_PROP_GROUP1),
there is an inconsistency between the comment in irqchip/arm-gic-v4.h
and this setting:

* @properties: Priority and enable bits (as written in the prop table)

Also maybe we could use LPI_PROP_PRIORITY macro instead of 0xfc?
> +		.db_enabled	= true,
> +	};
> +
> +	ret = its_map_vlpi(virq, &map);
Looking at its_map_lpi implementation, assuming irq_set_vcpu_affinity()
fails, will you get a change to turn  IRQ_DISABLE_LAZY again.
> +	if (ret)
> +		goto out;
> +
> +	irq->hw		= true;
> +	irq->host_irq	= virq;
Shouldn't we theoretically hold the irq lock here?
> +
> +out:
> +	mutex_unlock(&its->its_lock);
> +	return ret;
> +}
> +
> +int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int virq,
same
> +				 struct kvm_kernel_irq_routing_entry *irq_entry)
> +{
> +	struct vgic_its *its;
> +	struct vgic_irq *irq;
> +	int ret;
> +
> +	if (!vgic_supports_direct_msis(kvm))
> +		return 0;
> +
> +	/*
> +	 * Get the ITS, and escape early on error (not a valid
> +	 * doorbell for any of our vITSs).
> +	 */
> +	its = vgic_get_its(kvm, irq_entry);
> +	if (IS_ERR(its))
> +		return 0;
> +
> +	mutex_lock(&its->its_lock);
same?

Thanks

Eric
> +
> +	ret = vgic_its_resolve_lpi(kvm, its, irq_entry->msi.devid,
> +				   irq_entry->msi.data, &irq);
> +	if (ret)
> +		goto out;
> +
> +	WARN_ON(!(irq->hw && irq->host_irq == virq));
> +	irq->hw = false;
> +	ret = its_unmap_vlpi(virq);
> +
> +out:
> +	mutex_unlock(&its->its_lock);
> +	return ret;
> +}
> 
