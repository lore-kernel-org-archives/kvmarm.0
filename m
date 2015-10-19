From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 1/3] arm/arm64: KVM: Fix arch timer behavior for disabled
 interrupts
Date: Mon, 19 Oct 2015 15:14:27 +0200
Message-ID: <20151019131427.GD24104@cbox>
References: <1445113822-7831-1-git-send-email-christoffer.dall@linaro.org>
 <1445113822-7831-2-git-send-email-christoffer.dall@linaro.org>
 <5624EB04.1090601@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5624EB04.1090601@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 19, 2015 at 03:07:16PM +0200, Eric Auger wrote:
> Hi Christoffer,
> On 10/17/2015 10:30 PM, Christoffer Dall wrote:
> > We have an interesting issue when the guest disables the timer interrupt
> > on the VGIC, which happens when turning VCPUs off using PSCI, for
> > example.
> > 
> > The problem is that because the guest disables the virtual interrupt at
> > the VGIC level, we never inject interrupts to the guest and therefore
> > never mark the interrupt as active on the physical distributor.  The
> > host also never takes the timer interrupt (we only use the timer device
> > to trigger a guest exit and everything else is done in software), so the
> > interrupt does not become active through normal means.
> > 
> > The result is that we keep entering the guest with a programmed timer
> > that will always fire as soon as we context switch the hardware timer
> > state and run the guest, preventing forward progress for the VCPU.
> > 
> > Since the active state on the physical distributor is really part of the
> > timer logic, it is the job of our virtual arch timer driver to manage
> > this state.
> > 
> > The timer->map->active boolean field indicates whether we have signalled
> > this interrupt to the vgic and if that interrupt is still pending or
> > active.  As long as that is the case, the hardware doesn't have to
> > generate physical interrupts and therefore we mark the interrupt as
> > active on the physical distributor.
> > 
> > Cc: Marc Zyngier <marc.zyngier@arm.com>
> > Reported-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  virt/kvm/arm/arch_timer.c | 19 +++++++++++++++++++
> >  virt/kvm/arm/vgic.c       | 43 +++++++++++--------------------------------
> >  2 files changed, 30 insertions(+), 32 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> > index 48c6e1a..b9d3a32 100644
> > --- a/virt/kvm/arm/arch_timer.c
> > +++ b/virt/kvm/arm/arch_timer.c
> > @@ -137,6 +137,8 @@ bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
> >  void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
> >  {
> >  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> > +	bool phys_active;
> > +	int ret;
> >  
> >  	/*
> >  	 * We're about to run this vcpu again, so there is no need to
> > @@ -151,6 +153,23 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
> >  	 */
> >  	if (kvm_timer_should_fire(vcpu))
> >  		kvm_timer_inject_irq(vcpu);
> > +
> > +	/*
> > +	 * We keep track of whether the edge-triggered interrupt has been
> > +	 * signalled to the vgic/guest, and if so, we mask the interrupt and
> > +	 * the physical distributor to prevent the timer from raising a
> > +	 * physical interrupt whenever we run a guest, preventing forward
> > +	 * VCPU progress.
> In practice don't you simply mark the IRQ as active at GIC physical
> distributor level, hence preventing the same IRQ from hitting again

yes, that's what I meant with my comment, I should reword to "...we mark
the interrupt as active on the physical distributor..."

> > +	 */
> > +	if (kvm_vgic_get_phys_irq_active(timer->map))
> > +		phys_active = true;
> > +	else
> > +		phys_active = false;
> > +
> > +	ret = irq_set_irqchip_state(timer->map->irq,
> > +				    IRQCHIP_STATE_ACTIVE,
> > +				    phys_active);
> 
> physical distributor state is set in arch timer flush. It relates to a
> shared device behavior so I find it natural to do it there.
> 
> However the map->active is set in arch_timer IRQ injection and unset in
> vgic sync. Why not doing the set in kvm_vgic_inject_mapped_irq?

Because you have to set it at every entry to the guest if you run
multiple VCPUs/VMs on this CPU or migrate this VCPU to a different CPU.

> 
> > +	WARN_ON(ret);
> >  }
> >  
> >  /**
> > diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> > index 596455a..ea21bc2 100644
> > --- a/virt/kvm/arm/vgic.c
> > +++ b/virt/kvm/arm/vgic.c
> > @@ -1092,6 +1092,15 @@ static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu)
> >  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> >  	struct vgic_lr vlr = vgic_get_lr(vcpu, lr_nr);
> >  
> > +	/*
> > +	 * We must transfer the pending state back to the distributor before
> > +	 * retiring the LR, otherwise we may loose edge-triggered interrupts.
> > +	 */
> > +	if (vlr.state & LR_STATE_PENDING) {
> > +		vgic_dist_irq_set_pending(vcpu, irq);
> > +		vlr.hwirq = 0;
> > +	}
> That fix applies to any edge-sensitive IRQ, ie. not especially the
> timer's one? In the positive shouldn't you precise this in the commit
> msg too?
> 

Probably, it could also be a separate patch.  I'll rework this.

Thanks,
-Christoffer
