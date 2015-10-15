From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Keep mapped, disabled interrupts quiet
Date: Thu, 15 Oct 2015 12:54:22 +0200
Message-ID: <20151015105422.GA21930@cbox>
References: <1444307769-11400-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C42841390
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 06:51:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xqv0oTVibwVx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Oct 2015 06:51:41 -0400 (EDT)
Received: from mail-lf0-f43.google.com (mail-lf0-f43.google.com
 [209.85.215.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8CB6F407A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 06:51:41 -0400 (EDT)
Received: by lffv3 with SMTP id v3so25740937lff.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 03:53:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1444307769-11400-1-git-send-email-marc.zyngier@arm.com>
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
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 08, 2015 at 01:36:09PM +0100, Marc Zyngier wrote:
> If a mapped interrupt is disabled, we must make sure the
> corresponding physical interrupt cannot fire, as we are not
> injecting the interrupt, and not setting the active bit.
> 
> For example, a guest disabling its timer interrupt at the GIC level
> but leaving the timer firing would stop making progress as noone
> would be able to prevent this timer from firing and interrupting
> the host. Not quite what is expected. And if we're rebooting
> or turning a vcpu off while the interrupt is about to fire,
> we're exactly going to face this.
> 
> In order to cope with this, parse the list of mapped interrupts,
> and mark it as active if we're about to run the guest (or inactive
> if we've exited). Hopefully, nobody is going to run with zillions
> of disabled, mapped interrupts, right?
> 
> Reported-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
> My gut feeling is that this vgic_dist_irq_set_pending should always
> be done, but I'd like some other eyes to have a look at it.
> 
> Tested on Seattle (running 4.3-rc4) with a script hammering CPU hotplug.
> 
>  virt/kvm/arm/vgic.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 60 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 6bd1c9b..0ad3f7e 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -1092,6 +1092,11 @@ static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu)
>  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>  	struct vgic_lr vlr = vgic_get_lr(vcpu, lr_nr);
>  
> +	if (vlr.state & LR_HW) {
> +		vgic_dist_irq_set_pending(vcpu, irq);
> +		vlr.hwirq = 0;
> +	}
> +

I don't understand this logic?  At least you should check if the LR
state is active or pending, sort of what vgic_unqueue_irqs does.

In fact, it looks like we can re-use the vgic_unqueue_irqs if we do
some refactoring of that function.

But why is it necessary?

>  	vlr.state = 0;
>  	vgic_set_lr(vcpu, lr_nr, vlr);
>  	clear_bit(lr_nr, vgic_cpu->lr_used);
> @@ -1232,6 +1237,57 @@ static bool vgic_queue_hwirq(struct kvm_vcpu *vcpu, int irq)
>  }
>  
>  /*
> + * If a mapped interrupt is disabled, we must make sure the
> + * corresponding physical interrupt cannot fire, as we are not
> + * injecting the interrupt, and not setting the active bit.
> + *
> + * Parse the list of mapped interrupts, and mark it as active if we're
> + * about to run the guest (or inactive if we've exited). Hopefully,
> + * nobody is going to run with zillions of disabled, mapped
> + * interrupts...
> + */
> +static void vgic_handle_disabled_mapped_irq(struct kvm_vcpu *vcpu, bool enter)
> +{
> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +	struct vgic_bitmap *spi_bitmap;
> +	struct list_head *root;
> +	struct irq_phys_map_entry *entry;
> +	struct irq_phys_map *map;
> +	int ret;
> +
> +	rcu_read_lock();
> +
> +	/* Check for PPIs */
> +	root = &vgic_cpu->irq_phys_map_list;
> +	list_for_each_entry_rcu(entry, root, entry) {
> +		map = &entry->map;
> +		if (!vgic_irq_is_enabled(vcpu, map->virt_irq)) {
> +			ret = irq_set_irqchip_state(map->irq,
> +						    IRQCHIP_STATE_ACTIVE,
> +						    enter);
> +			WARN_ON(ret);
> +		}
> +	}
> +
> +	/* Check for SPIs routed to this vcpu */
> +	root = &dist->irq_phys_map_list;
> +	spi_bitmap = &dist->irq_spi_target[vcpu->vcpu_id];
> +	list_for_each_entry_rcu(entry, root, entry) {
> +		map = &entry->map;
> +		if (!vgic_irq_is_enabled(vcpu, map->virt_irq) &&
> +		    vgic_bitmap_get_irq_val(spi_bitmap, 0, map->virt_irq)) {

why do we check the emulated target bit here?

is the right thing not to see if we're running on the physical CPU which
the physical distributor is configured to route this SPI to, and in that
case set the IRQ active to prevent it from firting?

> +			ret = irq_set_irqchip_state(map->irq,
> +						    IRQCHIP_STATE_ACTIVE,
> +						    enter);
> +			WARN_ON(ret);
> +		}
> +	}
> +
> +	rcu_read_unlock();
> +}
> +
> +/*
>   * Fill the list registers with pending interrupts before running the
>   * guest.
>   */
> @@ -1320,6 +1376,8 @@ epilog:
>  			WARN_ON(ret);
>  		}
>  	}
> +
> +	vgic_handle_disabled_mapped_irq(vcpu, true);
>  }
>  
>  static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
> @@ -1484,6 +1542,8 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>  		vgic_cpu->vgic_irq_lr_map[vlr.irq] = LR_EMPTY;
>  	}
>  
> +	vgic_handle_disabled_mapped_irq(vcpu, false);
> +

Hmm, I'm having a hard time following this state machine, and it feels
like a hack that's papering over a design flaw, but I may just not be
able to understand it.

I'm wondering if there's an alternative approach which could work, where
we disable the IRQ on the physical distributor when the IRQ is mapped
and disabled by the guest, and then we update this state while handling
emulated writes to the GICD_I{C,S}ENABLER and loop over the disabled
bitmap for mapped interrupts on vcpu_load and vcpu_put?

[Sorry for taking so long to respond to this]

-Christoffer




>  	/* Check if we still have something up our sleeve... */
>  	pending = find_first_zero_bit(elrsr_ptr, vgic->nr_lr);
>  	if (level_pending || pending < vgic->nr_lr)
> -- 
> 2.1.4
> 
