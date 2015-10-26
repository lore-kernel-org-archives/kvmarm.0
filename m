From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 2/3] KVM: arm/arm64: Merge vgic_set_lr() and
 vgic_sync_lr_elrsr()
Date: Mon, 26 Oct 2015 20:42:05 +0100
Message-ID: <20151026194205.GG20298@cbox>
References: <cover.1445849885.git.p.fedin@samsung.com>
 <31bc5d39898f4a51f8d75d338229856ff49c097e.1445849885.git.p.fedin@samsung.com>
 <20151026152238.GD20298@cbox>
 <014d01d11005$f4f93a30$deebae90$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <014d01d11005$f4f93a30$deebae90$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Andre Przywara' <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 26, 2015 at 06:49:51PM +0300, Pavel Fedin wrote:
>  Hello!
> 
> > >  		/*
> > >  		 * Reestablish the pending state on the distributor and the
> > > -		 * CPU interface.  It may have already been pending, but that
> > > -		 * is fine, then we are only setting a few bits that were
> > > -		 * already set.
> > > -		 */
> > > -		if (lr.state & LR_STATE_PENDING) {
> > > -			vgic_dist_irq_set_pending(vcpu, lr.irq);
> > 
> > this looks wrong: You should still be setting the pending state on the
> > distributor, perhaps this is an ordering issue with the last patch?
> 
>  No, explained in the commit msg:
> --- cut ---
> Additionally, remove unnecessary vgic_set_lr() and LR_STATE_PENDING check
> in vgic_unqueue_irqs(), because all these things are now done by the
> following vgic_retire_lr().
> --- cut ---

This does not explain the question I'm raising.

After applying this patch, and before applying your next patch,
unqueueing an IRQ will not restore the pending state on the
distributor, but just throw that piece of state away, which breaks
bisectability and makes it impossible to understand the logic by looking
at this commit in isolation.

Please maintain at least current working semantics on a patch by patch
basis unless it's absolutely impossible to do so.

That's what I meant with an ordering issue with your last patch to which
you so elegantly reply 'No'.

Please rework this.

-Christoffer

