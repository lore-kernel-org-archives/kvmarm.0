From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v8 9/9] KVM: arm/arm64: Update timer and forwarded irq
 documentation
Date: Tue, 19 Dec 2017 21:29:54 +0100
Message-ID: <20171219202954.GC5380@cbox>
References: <20171213104602.16383-1-christoffer.dall@linaro.org>
 <20171213104602.16383-10-christoffer.dall@linaro.org>
 <86efnywfjl.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <86efnywfjl.wl-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Dec 13, 2017 at 08:15:10PM +0000, Marc Zyngier wrote:
> On Wed, 13 Dec 2017 10:46:02 +0000,
> Christoffer Dall wrote:
> > 
> > Now when we've reworked how mapped level-triggered interrupts are
> > processed for the timer interrupts, we update the documentation
> > correspondingly.
> 
> Seems like the documentation is more out of date than we thought, see
> below.
> 

Indeed.  And I wondered if we should just nuke this file.  The reason I
added it originally was that the concept of "never taking the interrupt"
was confusing to most, and we had to explain it several times over, but
perhaps it's really not needed anymore and we should let people read the
code instead?

> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt | 50 ++++++++++------------
> >  1 file changed, 23 insertions(+), 27 deletions(-)
> > 
> > diff --git a/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt b/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
> > index 38bca2835278..f68c7d95a341 100644
> > --- a/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
> > +++ b/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
> > @@ -7,9 +7,10 @@ allowing software to inject virtual interrupts to a VM, which the guest
> >  OS sees as regular interrupts.  The code is famously known as the VGIC.
> >  
> >  Some of these virtual interrupts, however, correspond to physical
> > -interrupts from real physical devices.  One example could be the
> > -architected timer, which itself supports virtualization, and therefore
> > -lets a guest OS program the hardware device directly to raise an
> > +interrupts from real physical devices.  One example could be the ARM
> > +Generic Timers (also known as the "architected timers"), which are
> > +directly assigned to a VM while it's running, and therefore
> > +makes it possible for guest OSes to program the timers directly to raise an
> >  interrupt at some point in time.  When such an interrupt is raised, the
> >  host OS initially handles the interrupt and must somehow signal this
> >  event as a virtual interrupt to the guest.  Another example could be a
> > @@ -37,7 +38,7 @@ inactive.
> >  
> >  The LRs include an extra bit, called the HW bit.  When this bit is set,
> >  KVM must also program an additional field in the LR, the physical IRQ
> > -number, to link the virtual with the physical IRQ.
> > +number, to link the virtual and physical IRQs together.
> >  
> >  When the HW bit is set, KVM must EITHER set the Pending OR the Active
> >  bit, never both at the same time.
> > @@ -59,21 +60,21 @@ The state of forwarded physical interrupts is managed in the following way:
> >    - LR.Pending will stay set as long as the guest has not acked the interrupt.
> >    - LR.Pending transitions to LR.Active on the guest read of the IAR, as
> >      expected.
> > -  - On guest EOI, the *physical distributor* active bit gets cleared,
> > +  - On guest deactivate, the *physical distributor* active bit gets cleared,
> >      but the LR.Active is left untouched (set).
> 
> Is this true? I seem to remember that we established it wasn't (back
> when we redesigned the vgic). Certainly, the current code relies on
> the Active bit being cleared in the LR as well as in the physical
> distributor.
> 

No, you're right, it' crap.

> >    - KVM clears the LR on VM exits when the physical distributor
> >      active state has been cleared.
> 
> And this isn't either, if my above assertion stands.
> 

Right again.

> >  
> >  (*): The host handling is slightly more complicated.  For some forwarded
> > -interrupts (shared), KVM directly sets the active state on the physical
> > -distributor before entering the guest, because the interrupt is never actually
> > -handled on the host (see details on the timer as an example below).  For other
> > -forwarded interrupts (non-shared) the host does not deactivate the interrupt
> > -when the host ISR completes, but leaves the interrupt active until the guest
> > -deactivates it.  Leaving the interrupt active is allowed, because Linux
> > -configures the physical GIC with EOIMode=1, which causes EOI operations to
> > -perform a priority drop allowing the GIC to receive other interrupts of the
> > -default priority.
> > +interrupts (shared), in some cases, KVM directly sets the active state
> > +on the physical distributor before entering the guest, because the
> > +interrupt is never actually handled on the host (see details on the
> > +timer as an example below).  In other cases, the host does not
> 
> This isn't true either. We now handle the timer interrupt on the host.
> 

And again.  I've rewritten this.

Thanks,
-Christoffer
