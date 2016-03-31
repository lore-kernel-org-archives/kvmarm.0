From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 43/45] KVM: arm/arm64: vgic-new: implement mapped IRQ
 handling
Date: Thu, 31 Mar 2016 20:15:17 +0200
Message-ID: <20160331181517.GG4126@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-44-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458871508-17279-44-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 25, 2016 at 02:05:06AM +0000, Andre Przywara wrote:
> We now store the mapped hardware IRQ number in our struct, so we
> don't need the irq_phys_map any longer for the new VGIC.
> Implement the hardware IRQ mapping on top of the reworked arch
> timer interface.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/vgic/vgic.h  | 15 ++++++++
>  virt/kvm/arm/vgic/vgic.c | 92 ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 107 insertions(+)
> 
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> index e418de9..7c1d145 100644
> --- a/include/kvm/vgic/vgic.h
> +++ b/include/kvm/vgic/vgic.h
> @@ -206,6 +206,21 @@ int kvm_vgic_hyp_init(void);
>  
>  int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>  			bool level);
> +int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid, unsigned int intid,
> +			       bool level);
> +
> +/*
> + * This is not really needed, but we need this type to keep the arch
> + * timer compatible with the old VGIC implementation.
> + * This should be removed upon retiring the old VGIC.
> + */
> +struct irq_phys_map {};
> +
> +struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
> +					   u32 virt_irq, u32 irq);
> +int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map,
> +			    u32 intid);
> +bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, u32 intid);
>  
>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
>  
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 4ade7c0..65395af 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -17,6 +17,9 @@
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
>  #include <linux/list_sort.h>
> +#include <linux/irq.h>
> +#include <linux/interrupt.h>
> +#include <linux/irqdesc.h>
>  
>  #include "vgic.h"
>  
> @@ -276,6 +279,83 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>  
>  	vcpu = kvm_get_vcpu(kvm, cpuid);
>  	vgic_update_irq_pending(kvm, vcpu, intid, level);
> +
> +	return 0;
> +}
> +
> +/**
> + * kvm_vgic_inject_mapped_irq - Inject a hardware mapped IRQ to the vgic
> + * @kvm:     The VM structure pointer
> + * @cpuid:   The CPU for PPIs
> + * @irq_num: The INTID to inject a new state to.
> + * @level:   Edge-triggered:  true:  to trigger the interrupt
> + *			      false: to ignore the call
> + *	     Level-sensitive  true:  raise the input signal
> + *			      false: lower the input signal
> + *
> + * The GIC is not concerned with devices being active-LOW or active-HIGH for
> + * level-sensitive interrupts.  You can think of the level parameter as 1
> + * being HIGH and 0 being LOW and all devices being active-HIGH.
> + */
> +int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid, unsigned int intid,
> +			       bool level)
> +{
> +	struct kvm_vcpu *vcpu;
> +	int ret;
> +
> +	ret = vgic_lazy_init(kvm);
> +	if (ret)
> +		return ret;
> +
> +	vcpu = kvm_get_vcpu(kvm, cpuid);
> +	vgic_update_irq_pending(kvm, vcpu, intid, level);
> +
> +	return 0;
> +}
> +
> +struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
> +					   u32 virt_irq, u32 intid)
> +{
> +	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
> +	struct irq_desc *desc;
> +	struct irq_data *data;
> +
> +	BUG_ON(!irq);
> +
> +	desc = irq_to_desc(intid);

eh, but that's not an INTID, that's a linux IRQ number then right?

> +	if (!desc) {
> +		kvm_err("%s: no interrupt descriptor\n", __func__);
> +		return NULL;
> +	}
> +
> +	data = irq_desc_get_irq_data(desc);
> +	while (data->parent_data)
> +		data = data->parent_data;
> +
> +	spin_lock(&irq->irq_lock);
> +
> +	irq->hw = true;
> +	irq->hwintid = data->hwirq;
> +
> +	spin_unlock(&irq->irq_lock);
> +
> +	return NULL;
> +}
> +
> +int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map,
> +			    u32 intid)
> +{
> +	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
> +
> +	BUG_ON(!irq);
> +
> +	spin_lock(&irq->irq_lock);
> +
> +	irq->hw = false;
> +	irq->hwintid = 0;
> +
> +	spin_unlock(&irq->irq_lock);
> +
>  	return 0;
>  }
>  
> @@ -520,3 +600,15 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
>  
>  	return pending;
>  }
> +
> +bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, u32 intid)
> +{
> +	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
> +	bool map_is_active;
> +
> +	spin_lock(&irq->irq_lock);
> +	map_is_active = irq->hw && irq->active;
> +	spin_unlock(&irq->irq_lock);
> +
> +	return map_is_active;
> +}
> -- 
> 2.7.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
