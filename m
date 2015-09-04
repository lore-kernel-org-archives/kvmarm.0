From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 6/9] arm/arm64: KVM: Add mapped interrupts documentation
Date: Fri, 4 Sep 2015 17:57:33 +0200
Message-ID: <20150904155733.GN5171@cbox>
References: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org>
 <1440942866-23802-7-git-send-email-christoffer.dall@linaro.org>
 <55E865D8.9080406@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55E865D8.9080406@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Sep 03, 2015 at 04:23:04PM +0100, Marc Zyngier wrote:
> On 30/08/15 14:54, Christoffer Dall wrote:
> > Mapped interrupts on arm/arm64 is a tricky concept and the way we deal
> > with them is not apparently easy to understand by reading various specs.
> > 
> > Therefore, add a proper documentation file explaining the flow and
> > rationale of the behavior of the vgic.
> > 
> > Some of this text was contributed by Marc Zyngier.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt | 59 ++++++++++++++++++++++
> >  1 file changed, 59 insertions(+)
> >  create mode 100644 Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
> > 
> > diff --git a/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt b/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
> > new file mode 100644
> > index 0000000..49e1357
> > --- /dev/null
> > +++ b/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
> > @@ -0,0 +1,59 @@
> > +KVM/ARM VGIC Mapped Interrupts
> > +==============================
> > +
> > +Setting the Physical Active State for Edge vs. Level Triggered IRQs
> > +-------------------------------------------------------------------
> > +
> > +Mapped non-shared interrupts injected to a guest should always mark the
> > +interrupt as active on the physical distributor.
> > +
> > +The reasoning for level-triggered interrupts:
> > +For level-triggered interrupts, we have to mark the interrupt as active
> > +on the physical distributor, because otherwise, as the line remains
> > +asserted, the guest will never execute because the host will keep taking
> > +interrupts.  As soon as the guest deactivates the interrupt, the
> > +physical line is sampled by the hardware again and the host takes a new
> > +interrupt if the physical line is still asserted.
> > +
> > +The reasoning for edge-triggered interrupts:
> > +For edge-triggered interrupts, if we set the HW bit in the LR we also
> > +have to mark the interrupt as active on the physical distributor.  If we
> > +don't set the physical active bit and the interrupt hits again before
> > +the guest has deactivated the interrupt, the interrupt goes to the host,
> > +which cannot set the state to ACTIVE+PENDING in the LR, because that is
> > +not supported when setting the HW bit in the LR.
> > +
> > +An alternative could be to not use HW bit at all, and inject
> > +edge-triggered interrupts from a physical assigned device as pure
> > +virtual interrupts, but that would potentially slow down handling of the
> > +interrupt in the guest, because a physical interrupt occurring in the
> > +middle of the guest ISR would preempt the guest for the host to handle
> > +the interrupt.
> 
> It would be worth mentioning that this is valid for PPIs and SPIs. LPIs
> do not have an Active state (they are either Pending or not), so we'll
> have to deal with edge interrupts as you just described at some point.
> Other architectures do something similar, I'd expect.
> 
> > +
> > +
> > +Life Cycle for Forwarded Physical Interrupts
> > +--------------------------------------------
> > +
> > +By forwarded physical interrupts we mean interrupts presented to a guest
> > +representing a real HW event originally signaled to the host as a
> 
> s/signaled/signalled/
> 
Actaully this was my first version as well, but aspell told me it was
spelled signaled.

Turns out it's mostly acceptable to use both spellings:

http://www.merriam-webster.com/dictionary/signaled

-Christoffer
