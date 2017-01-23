From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Remove struct vgic_irq pending field
Date: Mon, 23 Jan 2017 19:33:08 +0100
Message-ID: <20170123183308.GG15850@cbox>
References: <20170123133951.10329-1-christoffer.dall@linaro.org>
 <CAFEAcA8yde+mkOac_Zu2CRpWeiuOL3veVhpRwze50pykQSj0-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B10DA4019A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 13:33:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tOYkMEuOvAWm for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Jan 2017 13:33:10 -0500 (EST)
Received: from mail-lf0-f46.google.com (mail-lf0-f46.google.com
 [209.85.215.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 131E140194
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 13:33:09 -0500 (EST)
Received: by mail-lf0-f46.google.com with SMTP id z134so98266537lff.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 10:33:15 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAFEAcA8yde+mkOac_Zu2CRpWeiuOL3veVhpRwze50pykQSj0-g@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 23, 2017 at 04:30:52PM +0000, Peter Maydell wrote:
> On 23 January 2017 at 13:39, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> 
> I don't think this is wrong, but maybe it's a revealed cleanup
> that this patch permits:
> 
> > diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> > index e6b03fd..76d7d75 100644
> > --- a/virt/kvm/arm/vgic/vgic-v3.c
> > +++ b/virt/kvm/arm/vgic/vgic-v3.c
> > @@ -94,7 +94,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
> >                 /* Edge is the only case where we preserve the pending bit */
> >                 if (irq->config == VGIC_CONFIG_EDGE &&
> >                     (val & ICH_LR_PENDING_BIT)) {
> > -                       irq->pending = true;
> > +                       irq_set_pending_latch(irq, true);
> >
> >                         if (vgic_irq_is_sgi(intid) &&
> >                             model == KVM_DEV_TYPE_ARM_VGIC_V2) {
> > @@ -111,9 +111,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
> >                  */
> >                 if (irq->config == VGIC_CONFIG_LEVEL) {
> >                         if (!(val & ICH_LR_PENDING_BIT))
> > -                               irq->soft_pending = false;
> > -
> > -                       irq->pending = irq->line_level || irq->soft_pending;
> > +                               irq_set_pending_latch(irq, false);
> >                 }
> >
> >                 spin_unlock(&irq->irq_lock);
> > @@ -127,11 +125,11 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
> >         u32 model = vcpu->kvm->arch.vgic.vgic_model;
> >         u64 val = irq->intid;
> >
> > -       if (irq->pending) {
> > +       if (irq_is_pending(irq)) {
> >                 val |= ICH_LR_PENDING_BIT;
> >
> >                 if (irq->config == VGIC_CONFIG_EDGE)
> > -                       irq->pending = false;
> > +                       irq_set_pending_latch(irq, false);
> >
> >                 if (vgic_irq_is_sgi(irq->intid) &&
> >                     model == KVM_DEV_TYPE_ARM_VGIC_V2) {
> > @@ -141,7 +139,7 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
> >                         val |= (src - 1) << GICH_LR_PHYSID_CPUID_SHIFT;
> >                         irq->source &= ~(1 << (src - 1));
> >                         if (irq->source)
> > -                               irq->pending = true;
> > +                               irq_set_pending_latch(irq, true);
> >                 }
> >         }
> 
> For edge-triggered irqs:
>  * when we populate the LR we clear the pending latch
>  * when we extract the info from the LRs we set the
>    pending latch again if the LR pending bit is still set
> For level-triggered irqs:
>  * we don't clear the pending latch on populate, but
>  * when we extract the info from the LRs we clear
>    the pending latch if the LR pending bit isn't set
> 
> These seem to be pretty much the same effect except
> for the value of the pending-latch while the interrupt
> is in the LR. Do they actually need to be different
> now we've cleaned up the handling of the latch state?

This is a very good question.  I think we have to clear the latch state
when populating the LR for edge-triggeres irqs, because otherwise we
wouldn't be able to track if we see another edge putting the irq back
into pending while the guest is running.

Assuming I'm right, the only question is if we can clear the latch state
when populatin a level-triggered irq to an LR.  I didn't want to do
that, because I wanted to only do that when I was sure that the guest
had acked the interrupt.  If we relax that, and enter with (line_level
&& pending_latch) and exit with the still LR pending, we should obviouly
set the pending_latch again, but how do we distinguish this at the
fold_lr time from entering with (line_level && !pending_latch)?

Therefore I think we have to stick with the current setup.

> 
> (Architecturally the pending_latch state should be
> cleared when the interrupt is acknowledged, but I
> don't know which of the populate and fold steps is
> the right place for that.)
> 

Neither really.  I've never liked this part of the GIC VE, because
there's really no way to be correct here.  Another VCPU could set the
latch state after the target VCPU acked the virtual IRQ, and that new
write from the other VCPU would be lost.  In practice, it probably
doesn't matter, but I still don't like it.

So I still think the best we can do is the EOI maintanance interrupt,
and derive that if the LR is no longer pending, the VM must have acked
it, and therefore we clear the state.

Thanks,
-Christoffer
