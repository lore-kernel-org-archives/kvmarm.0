From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 7/8] arm/arm64: KVM: Rework the arch timer to use
 level-triggered semantics
Date: Wed, 23 Sep 2015 18:44:21 +0100
Message-ID: <5602E4F5.9080109@arm.com>
References: <1441395650-19663-1-git-send-email-christoffer.dall@linaro.org>
 <1441395650-19663-8-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0049548A40
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Sep 2015 13:42:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XlTIYWVzuSYL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Sep 2015 13:42:22 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8357340F9B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Sep 2015 13:42:22 -0400 (EDT)
In-Reply-To: <1441395650-19663-8-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 9ed8d53..f4ea950 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -1422,34 +1422,43 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>  /*
>   * Save the physical active state, and reset it to inactive.
>   *
> - * Return 1 if HW interrupt went from active to inactive, and 0 otherwise.
> + * Return true if there's a pending level triggered interrupt line to queue.
>   */
> -static int vgic_sync_hwirq(struct kvm_vcpu *vcpu, struct vgic_lr vlr)
> +static bool vgic_sync_hwirq(struct kvm_vcpu *vcpu, int lr, struct vgic_lr vlr)
>  {
>  	struct irq_phys_map *map;
> +	bool phys_active;
>  	int ret;
>  
>  	if (!(vlr.state & LR_HW))
>  		return 0;
>  
>  	map = vgic_irq_map_search(vcpu, vlr.irq);
> -	BUG_ON(!map || !map->active);
> +	BUG_ON(!map);
>  
>  	ret = irq_get_irqchip_state(map->irq,
>  				    IRQCHIP_STATE_ACTIVE,
> -				    &map->active);
> +				    &phys_active);
>  
>  	WARN_ON(ret);
>  
> -	if (map->active) {
> +	if (phys_active) {
> +		/*
> +		 * Interrupt still marked as active on the physical
> +		 * distributor, so guest did not EOI it yet.  Reset to
> +		 * non-active so that other VMs can see interrupts from this
> +		 * device.
> +		 */
>  		ret = irq_set_irqchip_state(map->irq,
>  					    IRQCHIP_STATE_ACTIVE,
>  					    false);
>  		WARN_ON(ret);
> -		return 0;
> +		return false;
>  	}
>  
> -	return 1;
> +	/* Mapped edge-triggered interrupts not yet supported. */
> +	WARN_ON(vgic_irq_is_edge(vcpu, vlr.irq));
> +	return process_level_irq(vcpu, lr, vlr);

Don't you miss the dist->lock here? The other call to
process_level_irq() certainly does it, and Eric recently removed the
coarse grained lock around the whole __kvm_vgic_sync_hwstate() function.
So we don't hold the lock here, but we change quite some common VGIC
state in there.

Cheers.
Andre.

>  }
>  
>  /* Sync back the VGIC state after a guest run */
> @@ -1474,18 +1483,8 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>  			continue;
>  
>  		vlr = vgic_get_lr(vcpu, lr);
> -		if (vgic_sync_hwirq(vcpu, vlr)) {
> -			/*
> -			 * So this is a HW interrupt that the guest
> -			 * EOI-ed. Clean the LR state and allow the
> -			 * interrupt to be sampled again.
> -			 */
> -			vlr.state = 0;
> -			vlr.hwirq = 0;
> -			vgic_set_lr(vcpu, lr, vlr);
> -			vgic_irq_clear_queued(vcpu, vlr.irq);
> -			set_bit(lr, elrsr_ptr);
> -		}
> +		if (vgic_sync_hwirq(vcpu, lr, vlr))
> +			level_pending = true;
>  
>  		if (!test_bit(lr, elrsr_ptr))
>  			continue;
> @@ -1861,30 +1860,6 @@ static void vgic_free_phys_irq_map_rcu(struct rcu_head *rcu)
>  }
>  
>  /**
> - * kvm_vgic_get_phys_irq_active - Return the active state of a mapped IRQ
> - *
> - * Return the logical active state of a mapped interrupt. This doesn't
> - * necessarily reflects the current HW state.
> - */
> -bool kvm_vgic_get_phys_irq_active(struct irq_phys_map *map)
> -{
> -	BUG_ON(!map);
> -	return map->active;
> -}
> -
> -/**
> - * kvm_vgic_set_phys_irq_active - Set the active state of a mapped IRQ
> - *
> - * Set the logical active state of a mapped interrupt. This doesn't
> - * immediately affects the HW state.
> - */
> -void kvm_vgic_set_phys_irq_active(struct irq_phys_map *map, bool active)
> -{
> -	BUG_ON(!map);
> -	map->active = active;
> -}
> -
> -/**
>   * kvm_vgic_unmap_phys_irq - Remove a virtual to physical IRQ mapping
>   * @vcpu: The VCPU pointer
>   * @map: The pointer to a mapping obtained through kvm_vgic_map_phys_irq
> @@ -2112,10 +2087,14 @@ int vgic_init(struct kvm *kvm)
>  			if (i < VGIC_NR_SGIS)
>  				vgic_bitmap_set_irq_val(&dist->irq_enabled,
>  							vcpu->vcpu_id, i, 1);
> -			if (i < VGIC_NR_PRIVATE_IRQS)
> +			if (i < VGIC_NR_SGIS)
>  				vgic_bitmap_set_irq_val(&dist->irq_cfg,
>  							vcpu->vcpu_id, i,
>  							VGIC_CFG_EDGE);
> +			else if (i < VGIC_NR_PRIVATE_IRQS) /* PPIs */
> +				vgic_bitmap_set_irq_val(&dist->irq_cfg,
> +							vcpu->vcpu_id, i,
> +							VGIC_CFG_LEVEL);
>  		}
>  
>  		vgic_enable(vcpu);
> 
