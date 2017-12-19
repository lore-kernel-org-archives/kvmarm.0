From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v8 8/9] KVM: arm/arm64: Avoid work when userspace iqchips
 are not used
Date: Tue, 19 Dec 2017 14:34:52 +0100
Message-ID: <20171219133452.GA5380@cbox>
References: <20171213104602.16383-1-christoffer.dall@linaro.org>
 <20171213104602.16383-9-christoffer.dall@linaro.org>
 <86fu8ewfzm.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <86fu8ewfzm.wl-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Dec 13, 2017 at 08:05:33PM +0000, Marc Zyngier wrote:
> On Wed, 13 Dec 2017 10:46:01 +0000,
> Christoffer Dall wrote:
> > 
> > We currently check if the VM has a userspace irqchip on every exit from
> > the VCPU, and if so, we do some work to ensure correct timer behavior.
> > This is unfortunate, as we could avoid doing any work entirely, if we
> > didn't have to support irqchip in userspace.
> > 
> > Realizing the userspace irqchip on ARM is mostly a developer or hobby
> > feature, and is unlikely to be used in servers or other scenarios where
> > performance is a priority, we can use a refcounted static key to only
> > check the irqchip configuration when we have at least one VM that uses
> > an irqchip in userspace.
> > 
> > Reviewed-by: Eric Auger <eric.auger@redhat.com>
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> 
> On its own, this doesn't seem to be that useful. As far as I can see,
> it saves us a load from the kvm structure before giving up.

A load and a conditional.  But what I really wanted to also avoid was
the function call from the main run loop, which I neglected as well.  I
think I can achieve that with a static inline wrapper in the arch timer
header file which first evaluates the static key and then calls into the
arch timer code.


> I think it
> is more the cumulative effect of this load that could have an impact,
> but you're only dealing with it at a single location.
> 
> How about making this a first class helper and redefine
> irqchip_in_kernel as such:
> 
> static inline bool irqchip_in_kernel(struct kvm *kvm)
> {
> 	if (static_branch_unlikely(&userspace_irqchip_in_use) &&
> 	    unlikely(!irqchip_in_kernel(kvm)))
> 		return true;
> 
> 	return false;
> }
> 
> and move that static key to a more central location?
> 

That's a neat idea.  The only problem is that creating a new VM would
then flip the static key, and then we'd have to flip it back when a vgic
is created on that VM, and I don't particularly like the idea of doing
this too often.

What I'd suggest then is to have two versions of the function:
irqchip_in_kernel() which is what it is today, and then
__irqchip_in_kernel() which can only be called from within the critical
path of the run loop, so that we can increment the static key on
kvm_vcpu_first_run_init() when we don't have a VGIC.

How does that sound?

Thanks,
-Christoffer


> > ---
> >  virt/kvm/arm/arch_timer.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> > index f8d09665ddce..73d262c4712b 100644
> > --- a/virt/kvm/arm/arch_timer.c
> > +++ b/virt/kvm/arm/arch_timer.c
> > @@ -51,6 +51,8 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
> >  				 struct arch_timer_context *timer_ctx);
> >  static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx);
> >  
> > +static DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
> > +
> >  u64 kvm_phys_timer_read(void)
> >  {
> >  	return timecounter->cc->read(timecounter->cc);
> > @@ -562,7 +564,8 @@ static void unmask_vtimer_irq_user(struct kvm_vcpu *vcpu)
> >  
> >  void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
> >  {
> > -	unmask_vtimer_irq_user(vcpu);
> > +	if (static_branch_unlikely(&userspace_irqchip_in_use))
> > +		unmask_vtimer_irq_user(vcpu);
> >  }
> >  
> >  int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
> > @@ -767,6 +770,8 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
> >  	soft_timer_cancel(&timer->bg_timer, &timer->expired);
> >  	soft_timer_cancel(&timer->phys_timer, NULL);
> >  	kvm_vgic_unmap_phys_irq(vcpu, vtimer->irq.irq);
> > +	if (timer->enabled && !irqchip_in_kernel(vcpu->kvm))
> > +		static_branch_dec(&userspace_irqchip_in_use);
> >  }
> >  
> >  static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
> > @@ -819,8 +824,10 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
> >  		return 0;
> >  
> >  	/* Without a VGIC we do not map virtual IRQs to physical IRQs */
> > -	if (!irqchip_in_kernel(vcpu->kvm))
> > +	if (!irqchip_in_kernel(vcpu->kvm)) {
> > +		static_branch_inc(&userspace_irqchip_in_use);
> >  		goto no_vgic;
> > +	}
> >  
> >  	if (!vgic_initialized(vcpu->kvm))
> >  		return -ENODEV;
> > -- 
> > 2.14.2
> > 
> 
> Thanks,
> 
> 	M.
