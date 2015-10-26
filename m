From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v3 2/3] KVM: arm/arm64: Merge vgic_set_lr() and
 vgic_sync_lr_elrsr()
Date: Mon, 26 Oct 2015 18:49:51 +0300
Message-ID: <014d01d11005$f4f93a30$deebae90$@samsung.com>
References: <cover.1445849885.git.p.fedin@samsung.com>
 <31bc5d39898f4a51f8d75d338229856ff49c097e.1445849885.git.p.fedin@samsung.com>
 <20151026152238.GD20298@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20151026152238.GD20298@cbox>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Andre Przywara' <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> >  		/*
> >  		 * Reestablish the pending state on the distributor and the
> > -		 * CPU interface.  It may have already been pending, but that
> > -		 * is fine, then we are only setting a few bits that were
> > -		 * already set.
> > -		 */
> > -		if (lr.state & LR_STATE_PENDING) {
> > -			vgic_dist_irq_set_pending(vcpu, lr.irq);
> 
> this looks wrong: You should still be setting the pending state on the
> distributor, perhaps this is an ordering issue with the last patch?

 No, explained in the commit msg:
--- cut ---
Additionally, remove unnecessary vgic_set_lr() and LR_STATE_PENDING check
in vgic_unqueue_irqs(), because all these things are now done by the
following vgic_retire_lr().
--- cut ---
 The last patch touches vgic_irq_clear_queued(). LR_STATE_PENDING check was included in vgic_retire_lr() by
cff9211eb1a1f58ce7f5a2d596b617928fd4be0e ("arm/arm64: KVM: Fix arch timer behavior for disabled interrupts "), so i simply removed
duplicated code.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


