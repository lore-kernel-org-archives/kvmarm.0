From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 8/8] arm/arm64: KVM: Support edge-triggered forwarded
 interrupts
Date: Fri, 2 Oct 2015 23:08:21 +0200
Message-ID: <20151002210821.GG32011@cbox>
References: <1443538145-11990-1-git-send-email-christoffer.dall@linaro.org>
 <1443538145-11990-9-git-send-email-christoffer.dall@linaro.org>
 <560EBC4B.3050706@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <560EBC4B.3050706@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 02, 2015 at 06:18:03PM +0100, Andre Przywara wrote:
> On 29/09/15 15:49, Christoffer Dall wrote:
> > We mark edge-triggered interrupts with the HW bit set as queued to
> > prevent the VGIC code from injecting LRs with both the Active and
> > Pending bits set at the same time while also setting the HW bit,
> > because the hardware does not support this.
> > 
> > However, this means that we must also clear the queued flag when we sync
> > back a LR where the state on the physical distributor went from active
> > to inactive because the guest deactivated the interrupt.  At this point
> > we must also check if the interrupt is pending on the distributor, and
> > tell the VGIC to queue it again if it is.
> > 
> > Since these actions on the sync path are extremely close to those for
> > level-triggered interrupts, rename process_level_irq to
> > process_queued_irq, allowing it to cater for both cases.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> 
> 
> > ---
> >  virt/kvm/arm/vgic.c | 40 ++++++++++++++++++++++------------------
> >  1 file changed, 22 insertions(+), 18 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> > index 53548f1..f3e76e5 100644
> > --- a/virt/kvm/arm/vgic.c
> > +++ b/virt/kvm/arm/vgic.c
> > @@ -1322,13 +1322,10 @@ epilog:
> >  	}
> >  }
> >  
> > -static int process_level_irq(struct kvm_vcpu *vcpu, int lr, struct vgic_lr vlr)
> > +static int process_queued_irq(struct kvm_vcpu *vcpu,
> > +				   int lr, struct vgic_lr vlr)
> >  {
> > -	int level_pending = 0;
> > -
> > -	vlr.state = 0;
> > -	vlr.hwirq = 0;
> > -	vgic_set_lr(vcpu, lr, vlr);
> > +	int pending = 0;
> 
> As I mentioned in my reply to 3/8 already: shouldn't this be "bool"?
> 
> >  
> >  	/*
> >  	 * If the IRQ was EOIed (called from vgic_process_maintenance) or it
> > @@ -1344,26 +1341,35 @@ static int process_level_irq(struct kvm_vcpu *vcpu, int lr, struct vgic_lr vlr)
> >  	vgic_dist_irq_clear_soft_pend(vcpu, vlr.irq);
> >  
> >  	/*
> > -	 * Tell the gic to start sampling the line of this interrupt again.
> > +	 * Tell the gic to start sampling this interrupt again.
> >  	 */
> >  	vgic_irq_clear_queued(vcpu, vlr.irq);
> >  
> >  	/* Any additional pending interrupt? */
> > -	if (vgic_dist_irq_get_level(vcpu, vlr.irq)) {
> > -		vgic_cpu_irq_set(vcpu, vlr.irq);
> > -		level_pending = 1;
> > +	if (vgic_irq_is_edge(vcpu, vlr.irq)) {
> > +		BUG_ON(!(vlr.state & LR_HW));
> 
> Is that really needed here?

Are BUG_ON statements every 'really needed' ?

> I don't see how this function would fail if
> called on a non-mapped IRQ. Also the two current callers would always
> fulfil this requirement:
> - vgic_process_maintenance() already has a WARN_ON(vgic_irq_is_edge)
> - vgic_sync_irq() returns early if it's not a mapped IRQ

yes, that's why it's a BUG_ON, don't ever do this;)

> 
> Removing this would also allow to pass "int irq" instead of "struct
> vgic_lr vlr".
> 
> Just an idea, though and not a show-stopper.

I don't see a problem with having it there and I put it there because I
wanted to protect us (developers) against accidentally writing a patch
that reuses this function for a non-forwarded edge-triggered interrupt,
which is not supposed to ever happen.

> 
> Other than that it looks good to me.
> 
Thanks,
-Christoffer
