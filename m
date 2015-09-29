From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 7/8] arm/arm64: KVM: Rework the arch timer to use
 level-triggered semantics
Date: Tue, 29 Sep 2015 16:30:46 +0200
Message-ID: <20150929143046.GG9002@cbox>
References: <1441395650-19663-1-git-send-email-christoffer.dall@linaro.org>
 <1441395650-19663-8-git-send-email-christoffer.dall@linaro.org>
 <5602E4F5.9080109@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5602E4F5.9080109@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 23, 2015 at 06:44:21PM +0100, Andre Przywara wrote:
> Hi Christoffer,
> 
> > diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> > index 9ed8d53..f4ea950 100644
> > --- a/virt/kvm/arm/vgic.c
> > +++ b/virt/kvm/arm/vgic.c
> > @@ -1422,34 +1422,43 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
> >  /*
> >   * Save the physical active state, and reset it to inactive.
> >   *
> > - * Return 1 if HW interrupt went from active to inactive, and 0 otherwise.
> > + * Return true if there's a pending level triggered interrupt line to queue.
> >   */
> > -static int vgic_sync_hwirq(struct kvm_vcpu *vcpu, struct vgic_lr vlr)
> > +static bool vgic_sync_hwirq(struct kvm_vcpu *vcpu, int lr, struct vgic_lr vlr)
> >  {
> >  	struct irq_phys_map *map;
> > +	bool phys_active;
> >  	int ret;
> >  
> >  	if (!(vlr.state & LR_HW))
> >  		return 0;
> >  
> >  	map = vgic_irq_map_search(vcpu, vlr.irq);
> > -	BUG_ON(!map || !map->active);
> > +	BUG_ON(!map);
> >  
> >  	ret = irq_get_irqchip_state(map->irq,
> >  				    IRQCHIP_STATE_ACTIVE,
> > -				    &map->active);
> > +				    &phys_active);
> >  
> >  	WARN_ON(ret);
> >  
> > -	if (map->active) {
> > +	if (phys_active) {
> > +		/*
> > +		 * Interrupt still marked as active on the physical
> > +		 * distributor, so guest did not EOI it yet.  Reset to
> > +		 * non-active so that other VMs can see interrupts from this
> > +		 * device.
> > +		 */
> >  		ret = irq_set_irqchip_state(map->irq,
> >  					    IRQCHIP_STATE_ACTIVE,
> >  					    false);
> >  		WARN_ON(ret);
> > -		return 0;
> > +		return false;
> >  	}
> >  
> > -	return 1;
> > +	/* Mapped edge-triggered interrupts not yet supported. */
> > +	WARN_ON(vgic_irq_is_edge(vcpu, vlr.irq));
> > +	return process_level_irq(vcpu, lr, vlr);
> 
> Don't you miss the dist->lock here? The other call to
> process_level_irq() certainly does it, and Eric recently removed the
> coarse grained lock around the whole __kvm_vgic_sync_hwstate() function.
> So we don't hold the lock here, but we change quite some common VGIC
> state in there.
> 

Indeed I think we should.

I'll fix that for the next revision.

Thanks,
-Christoffer
