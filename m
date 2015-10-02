From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 3/8] arm/arm64: KVM: vgic: Factor out level irq
 processing on guest exit
Date: Fri, 2 Oct 2015 22:48:43 +0200
Message-ID: <20151002204843.GE32011@cbox>
References: <1443538145-11990-1-git-send-email-christoffer.dall@linaro.org>
 <1443538145-11990-4-git-send-email-christoffer.dall@linaro.org>
 <560E9A3A.6020209@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <560E9A3A.6020209@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 02, 2015 at 03:52:42PM +0100, Andre Przywara wrote:
> Hi Christoffer,
> 
> On 29/09/15 15:49, Christoffer Dall wrote:
> > Currently vgic_process_maintenance() processes dealing with a completed
> > level-triggered interrupt directly, but we are soon going to reuse this
> > logic for level-triggered mapped interrupts with the HW bit set, so
> > move this logic into a separate static function.
> > 
> > Probably the most scary part of this commit is convincing yourself that
> > the current flow is safe compared to the old one.  In the following I
> > try to list the changes and why they are harmless:
> > 
> >   Move vgic_irq_clear_queued after kvm_notify_acked_irq:
> >     Harmless because the only potential effect of clearing the queued
> >     flag wrt.  kvm_set_irq is that vgic_update_irq_pending does not set
> >     the pending bit on the emulated CPU interface or in the
> >     pending_on_cpu bitmask if the function is called with level=1.
> >     However, the point of kvm_notify_acked_irq is to call kvm_set_irq
> >     with level=0, and we set the queued flag again in
> >     __kvm_vgic_sync_hwstate later on if the level is stil high.
> > 
> >   Move vgic_set_lr before kvm_notify_acked_irq:
> >     Also, harmless because the LR are cpu-local operations and
> >     kvm_notify_acked only affects the dist
> > 
> >   Move vgic_dist_irq_clear_soft_pend after kvm_notify_acked_irq:
> >     Also harmless because it's just a bit which is cleared and altering
> >     the line state does not affect this bit.
> 
> Mmmh, kvm_set_irq(level=0) will eventually execute (in
> vgic_update_irq_pending()):
> 
> 	vgic_dist_irq_clear_level(vcpu, irq_num);
> 	if (!vgic_dist_irq_soft_pend(vcpu, irq_num))
> 		vgic_dist_irq_clear_pending(vcpu, irq_num);
> 
> So with the former code we would clear the (dist) pending bit if
> soft_pend was set before, while with the newer code we wouldn't.
> Is this just still working because Linux guests will never set the
> soft_pend bit? Or is this safe because will always clear the pending bit
> anyway later on? (my brain is too much jellyfish by now to still work
> this dependency out)
> Or what do I miss here?
> 

you're right, I need to add a check for the level state and clear the
pnding bit in the vgic_dist_irq_clear_soft_pend() function as well.

> > 
> > Reviewed-by: Eric Auger <eric.auger@linaro.org>
> > Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  virt/kvm/arm/vgic.c | 88 ++++++++++++++++++++++++++++++-----------------------
> >  1 file changed, 50 insertions(+), 38 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> > index 6bd1c9b..fe0e5db 100644
> > --- a/virt/kvm/arm/vgic.c
> > +++ b/virt/kvm/arm/vgic.c
> > @@ -1322,12 +1322,56 @@ epilog:
> >  	}
> >  }
> >  
> > +static int process_level_irq(struct kvm_vcpu *vcpu, int lr, struct vgic_lr vlr)
> > +{
> > +	int level_pending = 0;
> 
> Why is this an int and not a bool? Also see below ...
> 

because I apply a bitwise or operation in the caller, and I wasn't sure
if this was strictly kosher to do that on a bool, so I Googled it, and
found some reports of that going wrong on certain compilers, so I
figured better safe than sorry.

I couldn't easily dig up that resource again though.

> > +
> > +	vlr.state = 0;
> > +	vlr.hwirq = 0;
> > +	vgic_set_lr(vcpu, lr, vlr);
> > +
> > +	/*
> > +	 * If the IRQ was EOIed (called from vgic_process_maintenance) or it
> > +	 * went from active to non-active (called from vgic_sync_hwirq) it was
> > +	 * also ACKed and we we therefore assume we can clear the soft pending
> > +	 * state (should it had been set) for this interrupt.
> > +	 *
> > +	 * Note: if the IRQ soft pending state was set after the IRQ was
> > +	 * acked, it actually shouldn't be cleared, but we have no way of
> > +	 * knowing that unless we start trapping ACKs when the soft-pending
> > +	 * state is set.
> > +	 */
> > +	vgic_dist_irq_clear_soft_pend(vcpu, vlr.irq);
> > +
> > +	/*
> > +	 * Tell the gic to start sampling the line of this interrupt again.
> > +	 */
> > +	vgic_irq_clear_queued(vcpu, vlr.irq);
> > +
> > +	/* Any additional pending interrupt? */
> > +	if (vgic_dist_irq_get_level(vcpu, vlr.irq)) {
> > +		vgic_cpu_irq_set(vcpu, vlr.irq);
> > +		level_pending = 1;
> > +	} else {
> > +		vgic_dist_irq_clear_pending(vcpu, vlr.irq);
> > +		vgic_cpu_irq_clear(vcpu, vlr.irq);
> > +	}
> > +
> > +	/*
> > +	 * Despite being EOIed, the LR may not have
> > +	 * been marked as empty.
> > +	 */
> > +	vgic_sync_lr_elrsr(vcpu, lr, vlr);
> > +
> > +	return level_pending;
> > +}
> > +
> >  static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
> >  {
> >  	u32 status = vgic_get_interrupt_status(vcpu);
> >  	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> > -	bool level_pending = false;
> >  	struct kvm *kvm = vcpu->kvm;
> > +	int level_pending = 0;
> 
> Why this change here? Even after 8/8 I don't see any use of values
> outside of true/false.
> 
See above.

Thanks for the review,
-Christoffer
