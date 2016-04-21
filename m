From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 5/7] KVM: arm/arm64: Remove the IRQ field from struct
 irq_phys_map
Date: Thu, 21 Apr 2016 20:32:45 +0200
Message-ID: <20160421183245.GB25288@cbox>
References: <1460729047-6346-1-git-send-email-andre.przywara@arm.com>
 <1460729047-6346-6-git-send-email-andre.przywara@arm.com>
 <571910AD.4050704@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <571910AD.4050704@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>
Cc: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 21, 2016 at 07:41:01PM +0200, Eric Auger wrote:
> Hi Andre,
> On 04/15/2016 04:04 PM, Andre Przywara wrote:
> > From: Christoffer Dall <christoffer.dall@linaro.org>
> > 
> > The communication of a Linux IRQ number from outside the VGIC to the
> > vgic was a leftover from the day when the vgic code cared about how a
> > particular device injects virtual interrupts mapped to a physical
> > interrupt.
> > 
> > We can safely remove this notion, leaving all physical IRQ handling to
> > be done in the device driver (the arch timer in this case), which makes
> > room for a saner API for the new VGIC.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  include/kvm/arm_vgic.h    |  3 +--
> >  virt/kvm/arm/arch_timer.c | 22 ++++++++++++++++++++--
> >  virt/kvm/arm/vgic.c       | 20 ++------------------
> >  3 files changed, 23 insertions(+), 22 deletions(-)
> > 
> > diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> > index 43eeb18..49c559e 100644
> > --- a/include/kvm/arm_vgic.h
> > +++ b/include/kvm/arm_vgic.h
> > @@ -157,7 +157,6 @@ struct vgic_io_device {
> >  struct irq_phys_map {
> >  	u32			virt_irq;
> >  	u32			phys_irq;
> > -	u32			irq;
> >  };
> >  
> >  struct irq_phys_map_entry {
> > @@ -345,7 +344,7 @@ int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
> >  void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
> >  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
> >  struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
> > -					   int virt_irq, int irq);
> > +					   int virt_irq, int phys_irq);
> >  int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq);
> >  bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
> >  
> > diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> > index b4d96b1..cfdf88f 100644
> > --- a/virt/kvm/arm/arch_timer.c
> > +++ b/virt/kvm/arm/arch_timer.c
> > @@ -274,7 +274,7 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
> >  	if (timer->active_cleared_last && !phys_active)
> >  		return;
> >  
> > -	ret = irq_set_irqchip_state(timer->map->irq,
> > +	ret = irq_set_irqchip_state(host_vtimer_irq,
> >  				    IRQCHIP_STATE_ACTIVE,
> >  				    phys_active);
> >  	WARN_ON(ret);
> > @@ -307,6 +307,9 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
> >  {
> >  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> >  	struct irq_phys_map *map;
> > +	struct irq_desc *desc;
> > +	struct irq_data *data;
> > +	int phys_irq;
> >  
> >  	/*
> >  	 * The vcpu timer irq number cannot be determined in
> > @@ -326,10 +329,25 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
> >  	kvm_timer_update_state(vcpu);
> >  
> >  	/*
> > +	 * Find the physical IRQ number corresponding to the host_vtimer_irq
> > +	 */
> > +	desc = irq_to_desc(host_vtimer_irq);
> > +	if (!desc) {
> can this really happen?

this is just moving the logic.  We had this check before, so I assume
so...

> > +		kvm_err("%s: no interrupt descriptor\n", __func__);
> > +		return -EINVAL;
> > +	}
> > +
> > +	data = irq_desc_get_irq_data(desc);
> > +	while (data->parent_data)
> > +		data = data->parent_data;
> > +
> > +	phys_irq = data->hwirq;
> > +
> > +	/*
> >  	 * Tell the VGIC that the virtual interrupt is tied to a
> >  	 * physical interrupt. We do that once per VCPU.
> >  	 */
> > -	map = kvm_vgic_map_phys_irq(vcpu, irq->irq, host_vtimer_irq);
> > +	map = kvm_vgic_map_phys_irq(vcpu, irq->irq, phys_irq);
> >  	if (WARN_ON(IS_ERR(map)))
> >  		return PTR_ERR(map);
> >  
> > diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> > index 2d7ae35..ac5838b 100644
> > --- a/virt/kvm/arm/vgic.c
> > +++ b/virt/kvm/arm/vgic.c
> > @@ -1723,27 +1723,13 @@ static struct list_head *vgic_get_irq_phys_map_list(struct kvm_vcpu *vcpu,
> >   * Returns a valid pointer on success, and an error pointer otherwise
> >   */
> the doc comment must be updated
>  * @irq: The Linux IRQ number
> 
> Besides
> 
> Reviewed-by: Eric Auger <eric.auger@linaro.org>
> 
Thanks!

Andre, let me know if you need me to provide an updated patch or if you
can just tweak that comment.

-Christoffer
