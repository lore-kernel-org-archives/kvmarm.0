From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] KVM: arm/arm64: Let vcpu thread modify its own active
 state
Date: Tue, 7 Mar 2017 01:57:10 -0800
Message-ID: <20170307095710.GC101711@lvm>
References: <1488807757-86131-1-git-send-email-christoffer.dall@linaro.org>
 <CAHyh4xgQDy9t8YD2P_q8MSQfv_1wa9JicZkQKV2OQNG3w48+9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89BFA40A80
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Mar 2017 04:55:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ogrFgRgW6AmT for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Mar 2017 04:55:51 -0500 (EST)
Received: from mail-wr0-f180.google.com (mail-wr0-f180.google.com
 [209.85.128.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7838D40A54
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Mar 2017 04:55:51 -0500 (EST)
Received: by mail-wr0-f180.google.com with SMTP id g10so134997671wrg.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Mar 2017 01:57:12 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAHyh4xgQDy9t8YD2P_q8MSQfv_1wa9JicZkQKV2OQNG3w48+9A@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: KVM General <kvm@vger.kernel.org>, Eric Auger <eric.auger@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 06, 2017 at 02:20:44PM -0500, Jintack Lim wrote:
> Hi Christoffer,
> 
> thanks for submitting this patch.
> 
> On Mon, Mar 6, 2017 at 8:42 AM, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> > From: Jintack Lim <jintack@cs.columbia.edu>
> >
> > Currently, if a vcpu thread tries to change the active state of an
> > interrupt which is already on the same vcpu's AP list,
> 
> "it'll loop forever" is remove accidentally in the commit message in v2?

yes, we can fix this up when applying the patch.  Thanks.

> 
> > Since the VGIC
> > mmio handler is called after a vcpu has already synced back the LR state
> > to the struct vgic_irq, we can just let it proceed safely.
> >
> > Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> > ---
> > Changes since v1:
> >  - Reworked comment
> >  - Consider userspace accesses
> >  - Get the right requester VCPU for GICv3 private IRQ accesses
> >  - Tested using kvm-unit-tests and verified that it deadlocked without
> >    this patch and passed the test with this patch :)
> 
> nice!
> 
> >
> >  virt/kvm/arm/vgic/vgic-mmio.c | 32 ++++++++++++++++++++++++--------
> >  1 file changed, 24 insertions(+), 8 deletions(-)
> >
> > diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> > index 3654b4c..2a5db13 100644
> > --- a/virt/kvm/arm/vgic/vgic-mmio.c
> > +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> > @@ -180,21 +180,37 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
> >  static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
> >                                     bool new_active_state)
> >  {
> > +       struct kvm_vcpu *requester_vcpu;
> >         spin_lock(&irq->irq_lock);
> > +
> > +       /*
> > +        * The vcpu parameter here can mean multiple things depending on how
> > +        * this function is called; when handling a trap from the kernel it
> > +        * depends on the GIC version, and these functions are also called as
> > +        * part of save/restore from userspace.
> > +        *
> > +        * Therefore, we have to figure out the requester in a reliable way.
> > +        *
> > +        * When accessing VGIC state from user space, the requester_vcpu is
> > +        * NULL, which is fine, because we guarantee that no VCPUs are running
> > +        * when accessing VGIC state from user space so irq->vcpu->cpu is
> > +        * always -1.
> > +        */
> > +       requester_vcpu = kvm_arm_get_running_vcpu();
> > +
> >         /*
> >          * If this virtual IRQ was written into a list register, we
> >          * have to make sure the CPU that runs the VCPU thread has
> > -        * synced back LR state to the struct vgic_irq.  We can only
> > -        * know this for sure, when either this irq is not assigned to
> > -        * anyone's AP list anymore, or the VCPU thread is not
> > -        * running on any CPUs.
> > +        * synced back the LR state to the struct vgic_irq.
> >          *
> > -        * In the opposite case, we know the VCPU thread may be on its
> > -        * way back from the guest and still has to sync back this
> > -        * IRQ, so we release and re-acquire the spin_lock to let the
> > -        * other thread sync back the IRQ.
> > +        * As long as the conditions below are true, we know the VCPU thread
> > +        * may be on its way back from the guest (we kicked the VCPU thread in
> > +        * vgic_change_active_prepare)  and still has to sync back this IRQ,
> > +        * so we release and re-acquire the spin_lock to let the other thread
> > +        * sync back the IRQ.
> >          */
> >         while (irq->vcpu && /* IRQ may have state in an LR somewhere */
> > +              irq->vcpu != requester_vcpu && /* Current thread is not the VCPU thread */
> >                irq->vcpu->cpu != -1) /* VCPU thread is running */
> >                 cond_resched_lock(&irq->irq_lock);
> >
> > --
> > 2.5.0
> >
> >
> 
