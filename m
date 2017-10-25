From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 09/26] KVM: arm/arm64: GICv4: Wire mapping/unmapping
 of VLPIs in VFIO irq bypass
Date: Wed, 25 Oct 2017 17:58:44 +0200
Message-ID: <20171025155844.GL91785@lvm>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
 <20171006153401.5481-10-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171006153401.5481-10-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 06, 2017 at 04:33:44PM +0100, Marc Zyngier wrote:
> Let's use the irq bypass mechanism introduced for platform device
> interrupts to intercept the virtual PCIe endpoint configuration
> and establish our LPI->VLPI mapping.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> ---
>  include/kvm/arm_vgic.h      |   8 ++++
>  virt/kvm/arm/arm.c          |   6 ++-
>  virt/kvm/arm/vgic/vgic-v4.c | 104 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 116 insertions(+), 2 deletions(-)
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
> index c794f0cef09e..ba1dd3162eba 100644
> --- a/virt/kvm/arm/vgic/vgic-v4.c
> +++ b/virt/kvm/arm/vgic/vgic-v4.c
> @@ -81,3 +81,107 @@ void vgic_v4_teardown(struct kvm *kvm)
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
> +	return vgic_msi_to_its(kvm, &msi);
> +}
> +
> +int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
> +			       struct kvm_kernel_irq_routing_entry *irq_entry)
> +{
> +	struct vgic_its *its;
> +	struct vgic_irq *irq;
> +	struct its_vlpi_map map;
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
> +		.db_enabled	= true,
> +	};
> +
> +	ret = its_map_vlpi(virq, &map);
> +	if (ret)
> +		goto out;
> +
> +	irq->hw		= true;
> +	irq->host_irq	= virq;
> +
> +out:
> +	mutex_unlock(&its->its_lock);
> +	return ret;
> +}
> +
> +int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int virq,
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
> -- 
> 2.14.1
> 
