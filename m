From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 3/7] KVM: arm/arm64: Don't cache the timer IRQ level
Date: Thu, 19 Oct 2017 15:05:48 +0200
Message-ID: <20171019130548.GR8900@cbox>
References: <1505513994-77939-1-git-send-email-christoffer.dall@linaro.org>
 <1505513994-77939-4-git-send-email-christoffer.dall@linaro.org>
 <87k203uw01.fsf@on-the-bus.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87k203uw01.fsf@on-the-bus.cambridge.arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 10, 2017 at 11:39:58AM +0100, Marc Zyngier wrote:
> On Fri, Sep 15 2017 at  3:19:50 pm BST, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> > From: Christoffer Dall <cdall@linaro.org>
> >
> > The timer was modeled after a strict idea of modelling an interrupt line
> > level in software, meaning that only transitions in the level needed to
> > be reported to the VGIC.  This works well for the timer, because the
> > arch timer code is in complete control of the device and can track the
> > transitions of the line.
> >
> > However, as we are about to support using the HW bit in the VGIC not
> > just for the timer, but also for VFIO which cannot track transitions of
> > the interrupt line, we have to decide on an interface for level
> > triggered mapped interrupts to the GIC, which both the timer and VFIO
> > can use.
> >
> > VFIO only sees an asserting transition of the physical interrupt line,
> > and tells the VGIC when that happens.  That means that part of the
> > interrupt flow is offloaded to the hardware.
> >
> > To use the same interface for VFIO devices and the timer, we therefore
> > have to change the timer (we cannot change VFIO because it doesn't know
> > the details of the device it is assigning to a VM).
> >
> > Luckily, changing the timer is simple, we just need to stop 'caching'
> > the line level, but instead let the VGIC know the state of the timer on
> > every entry to the guest, and the VGIC can ignore notifications using
> > its validate mechanism.
> >
> > Signed-off-by: Christoffer Dall <cdall@linaro.org>
> > ---
> >  virt/kvm/arm/arch_timer.c | 14 ++++++++------
> >  1 file changed, 8 insertions(+), 6 deletions(-)
> >
> > diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> > index 8e89d63..2a5f877 100644
> > --- a/virt/kvm/arm/arch_timer.c
> > +++ b/virt/kvm/arm/arch_timer.c
> > @@ -219,9 +219,10 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
> >  	int ret;
> >  
> >  	timer_ctx->active_cleared_last = false;
> > +	if (timer_ctx->irq.level != new_level)
> > +		trace_kvm_timer_update_irq(vcpu->vcpu_id, timer_ctx->irq.irq,
> > +					   new_level);
> >  	timer_ctx->irq.level = new_level;
> > -	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer_ctx->irq.irq,
> > -				   timer_ctx->irq.level);
> >  
> >  	if (likely(irqchip_in_kernel(vcpu->kvm))) {
> >  		ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
> > @@ -241,6 +242,7 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
> >  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> >  	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> >  	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
> > +	bool level;
> >  
> >  	/*
> >  	 * If userspace modified the timer registers via SET_ONE_REG before
> > @@ -251,11 +253,11 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
> >  	if (unlikely(!timer->enabled))
> >  		return;
> >  
> > -	if (kvm_timer_should_fire(vtimer) != vtimer->irq.level)
> > -		kvm_timer_update_irq(vcpu, !vtimer->irq.level, vtimer);
> > +	level = kvm_timer_should_fire(vtimer);
> > +	kvm_timer_update_irq(vcpu, level, vtimer);
> >  
> > -	if (kvm_timer_should_fire(ptimer) != ptimer->irq.level)
> > -		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
> > +	level = kvm_timer_should_fire(ptimer);
> > +	kvm_timer_update_irq(vcpu, level, ptimer);
> 
> Well, at this stage, you might as well fold the kvm_timer_should_fire()
> into kvm_timer_update_irq() and from the level parameter. But I suspect
> this is going to clash badly with your timer series?
> 

Yes, it's doing extra unnecessary work in the critical path on IRQ
injections from the ISR after the timer series.

How about I rebase this series on the timer series and do a resend of
this one, without additional changes, and we have a look at it?

> >  }
> >  
> >  /* Schedule the background timer for the emulated timer. */
> 
> Otherwise:
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> 
Thanks!
-Christoffer
