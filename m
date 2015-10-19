From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 2/3] arm/arm64: KVM: Clear map->active on pend/active
 clear
Date: Mon, 19 Oct 2015 17:39:26 +0200
Message-ID: <20151019153926.GG24104@cbox>
References: <1445113822-7831-1-git-send-email-christoffer.dall@linaro.org>
 <1445113822-7831-3-git-send-email-christoffer.dall@linaro.org>
 <56250D1A.9010203@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56250D1A.9010203@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 19, 2015 at 05:32:42PM +0200, Eric Auger wrote:
> Hi,
> On 10/17/2015 10:30 PM, Christoffer Dall wrote:
> > When a guest reboots or offlines/onlines CPUs, it is not uncommon for it
> > to clear the pending and active states of an interrupt through the
> > emulated VGIC distributor.  However, since we emulate an edge-triggered
> > based on a level-triggered device,
> I do not get this sentence.

Fair enough.  The guest expects a level-triggered timer, so it expects
to be able to do:

  disable interrupt, set timer(*), clear pending state, enable interrupt

and this only works because the device is level-triggered, so it should
hit again after clearing the pending state and the guest should see it
after enabling interrupts.

but because we have virtual edge-triggered behavior, we loose the
interrupt generated at (*) unless we inject it again, which we will
after this patch, because the actual device is level triggered, so we'll
sample its state in the KVM timer code contiuously and now  (after this
patch) notice that we have to inject the edge-triggered IRQ again.

Yes, I know, we're lucky we can make it work like this.

> 
> Besides that
> Reviewed-by: Eric Auger <eric.auger@linaro.org>

Thanks!

-Christoffer

>  the guest expects the timer interrupt
> > to hit even after clearing the pending state.
> > 
> > We currently do not signal the VGIC when the map->active field is true,
> > because it indicates that the guest has already been signalled of the
> > interrupt as required.  Normally this field is set to false when the
> > guest deactivates the virtual interrupt through the sync path.
> > 
> > We also need to catch the case where the guest deactivates the interrupt
> > through the emulated distributor, again allowing guests to boot even if
> > the original virtual timer signal hit before the guest's GIC
> > initialization sequence is run.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  virt/kvm/arm/vgic.c | 32 +++++++++++++++++++++++++++++++-
> >  1 file changed, 31 insertions(+), 1 deletion(-)
> > 
> > diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> > index ea21bc2..58b1256 100644
> > --- a/virt/kvm/arm/vgic.c
> > +++ b/virt/kvm/arm/vgic.c
> > @@ -531,6 +531,34 @@ bool vgic_handle_set_pending_reg(struct kvm *kvm,
> >  	return false;
> >  }
> >  
> > +/*
> > + * If a mapped interrupt's state has been modified by the guest such that it
> > + * is no longer active or pending, without it have gone through the sync path,
> > + * then the map->active field must be cleared so the interrupt can be taken
> > + * again.
> > + */
> > +static void vgic_handle_clear_mapped_irq(struct kvm_vcpu *vcpu)
> > +{
> > +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> > +	struct list_head *root;
> > +	struct irq_phys_map_entry *entry;
> > +	struct irq_phys_map *map;
> > +
> > +	rcu_read_lock();
> > +
> > +	/* Check for PPIs */
> > +	root = &vgic_cpu->irq_phys_map_list;
> > +	list_for_each_entry_rcu(entry, root, entry) {
> > +		map = &entry->map;
> > +
> > +		if (!vgic_dist_irq_is_pending(vcpu, map->virt_irq) &&
> > +		    !vgic_irq_is_active(vcpu, map->virt_irq))
> > +			map->active = false;
> > +	}
> > +
> > +	rcu_read_unlock();
> > +}
> > +
> >  bool vgic_handle_clear_pending_reg(struct kvm *kvm,
> >  				   struct kvm_exit_mmio *mmio,
> >  				   phys_addr_t offset, int vcpu_id)
> > @@ -561,6 +589,7 @@ bool vgic_handle_clear_pending_reg(struct kvm *kvm,
> >  					  vcpu_id, offset);
> >  		vgic_reg_access(mmio, reg, offset, mode);
> >  
> > +		vgic_handle_clear_mapped_irq(kvm_get_vcpu(kvm, vcpu_id));
> >  		vgic_update_state(kvm);
> >  		return true;
> >  	}
> > @@ -598,6 +627,7 @@ bool vgic_handle_clear_active_reg(struct kvm *kvm,
> >  			ACCESS_READ_VALUE | ACCESS_WRITE_CLEARBIT);
> >  
> >  	if (mmio->is_write) {
> > +		vgic_handle_clear_mapped_irq(kvm_get_vcpu(kvm, vcpu_id));
> >  		vgic_update_state(kvm);
> >  		return true;
> >  	}
> > @@ -1406,7 +1436,7 @@ static int vgic_sync_hwirq(struct kvm_vcpu *vcpu, struct vgic_lr vlr)
> >  		return 0;
> >  
> >  	map = vgic_irq_map_search(vcpu, vlr.irq);
> > -	BUG_ON(!map || !map->active);
> > +	BUG_ON(!map);
> >  
> >  	ret = irq_get_irqchip_state(map->irq,
> >  				    IRQCHIP_STATE_ACTIVE,
> > 
> 
