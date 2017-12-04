From: Christoffer Dall <cdall@kernel.org>
Subject: Re: [PATCH v5 6/8] KVM: arm/arm64: Support VGIC dist pend/active
 changes for mapped IRQs
Date: Mon, 4 Dec 2017 20:31:51 +0100
Message-ID: <20171204193151.GG32397@cbox>
References: <20171120191649.17290-1-christoffer.dall@linaro.org>
 <20171120191649.17290-7-christoffer.dall@linaro.org>
 <20171129151314.el7ndd2czsglw7lh@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 878AB49D35
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 14:28:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Oxg8y2TfLjMy for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Dec 2017 14:28:43 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 85FCC49D46
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 14:28:43 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id l141so7881574wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Dec 2017 11:31:51 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20171129151314.el7ndd2czsglw7lh@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 29, 2017 at 04:13:14PM +0100, Andrew Jones wrote:
> On Mon, Nov 20, 2017 at 08:16:47PM +0100, Christoffer Dall wrote:
> > For mapped IRQs (with the HW bit set in the LR) we have to follow some
> > rules of the architecture.  One of these rules is that VM must not be
> > allowed to deactivate a virtual interrupt with the HW bit set unless the
> > physical interrupt is also active.
> > 
> > This works fine when injecting mapped interrupts, because we leave it up
> > to the injector to either set EOImode==1 or manually set the active
> > state of the physical interrupt.
> > 
> > However, the guest can set virtual interrupt to be pending or active by
> > writing to the virtual distributor, which could lead to deactivating a
> > virtual interrupt with the HW bit set without the physical interrupt
> > being active.
> > 
> > We could set the physical interrupt to active whenever we are about to
> > enter the VM with a HW interrupt either pending or active, but that
> > would be really slow, especially on GICv2.  So we take the long way
> > around and do the hard work when needed, which is expected to be
> > extremely rare.
> > 
> > When the VM sets the pending state for a HW interrupt on the virtual
> > distributor we set the active state on the physical distributor, because
> > the virtual interrupt can become active and then the guest can
> > deactivate it.
> > 
> > When the VM clears the pending state we also clear it on the physical
> > side, because the injector might otherwise raise the interrupt.  We also
> > clear the physical active state when the virtual interrupt is not
> > active, since otherwise a SPEND/CPEND sequence from the guest would
> > prevent signaling of future interrupts.
> > 
> > Changing the state of mapped interrupts from userspace is not supported,
> > and it's expected that userspace unmaps devices from VFIO before
> > attempting to set the interrupt state, because the interrupt state is
> > driven by hardware.
> > 
> > Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  virt/kvm/arm/vgic/vgic-mmio.c | 71 +++++++++++++++++++++++++++++++++++++++----
> >  virt/kvm/arm/vgic/vgic.c      |  7 +++++
> >  virt/kvm/arm/vgic/vgic.h      |  1 +
> >  3 files changed, 73 insertions(+), 6 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> > index 6113cf850f47..294e949ece24 100644
> > --- a/virt/kvm/arm/vgic/vgic-mmio.c
> > +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/kvm.h>
> >  #include <linux/kvm_host.h>
> >  #include <kvm/iodev.h>
> > +#include <kvm/arm_arch_timer.h>
> >  #include <kvm/arm_vgic.h>
> >  
> >  #include "vgic.h"
> > @@ -142,10 +143,22 @@ static struct kvm_vcpu *vgic_get_mmio_requester_vcpu(void)
> >  	return vcpu;
> >  }
> >  
> > +/* Must be called with irq->irq_lock held */
> > +static void vgic_hw_irq_spending(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
> > +				 bool is_uaccess)
> > +{
> > +	if (!is_uaccess)
> > +		irq->pending_latch = true;
> > +
> > +	if (!is_uaccess)
> > +		vgic_irq_set_phys_active(irq, true);
> 
> I see this whole patch has this two 'if (!is_uaccess)' checks pattern.
> Is that meant to convey something? 

Yeah, that I'm a fool.

> Or is the first condition not supposed
> to have the '!'? (I'm lost with regards to the state tracking differences
> between the guest and userspace and just reviewing superficially...)
> 

This became weird becaus the first clause used to be "if (!is_uaccess ||
is_timer)", but now when the timer is interrupt driven (the timer
optimization series), we don't have that concept anymore, and I just
blindly removes the "|| is_timer" part.

I reworked this so that the functions now have

	if (is_uaccess)
		return;


Thanks,
-Christoffer
