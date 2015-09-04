From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 6/9] arm/arm64: KVM: Add mapped interrupts documentation
Date: Fri, 4 Sep 2015 17:54:41 +0200
Message-ID: <20150904155441.GL5171@cbox>
References: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org>
 <1440942866-23802-7-git-send-email-christoffer.dall@linaro.org>
 <55E865D8.9080406@arm.com>
 <55E86DAA.1050901@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55E86DAA.1050901@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Sep 03, 2015 at 05:56:26PM +0200, Eric Auger wrote:
> Hi Christoffer,
> On 09/03/2015 05:23 PM, Marc Zyngier wrote:
> > On 30/08/15 14:54, Christoffer Dall wrote:
> >> Mapped interrupts on arm/arm64 is a tricky concept and the way we deal
> >> with them is not apparently easy to understand by reading various specs.
> >>
> >> Therefore, add a proper documentation file explaining the flow and
> >> rationale of the behavior of the vgic.
> >>
> >> Some of this text was contributed by Marc Zyngier.
> >>
> >> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >> ---
> >>  Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt | 59 ++++++++++++++++++++++
> >>  1 file changed, 59 insertions(+)
> >>  create mode 100644 Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
> >>
> >> diff --git a/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt b/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
> >> new file mode 100644
> >> index 0000000..49e1357
> >> --- /dev/null
> >> +++ b/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
> >> @@ -0,0 +1,59 @@
> >> +KVM/ARM VGIC Mapped Interrupts
> >> +==============================
> >> +
> >> +Setting the Physical Active State for Edge vs. Level Triggered IRQs
> >> +-------------------------------------------------------------------
> >> +
> >> +Mapped non-shared interrupts injected to a guest should always mark the
> >> +interrupt as active on the physical distributor.
> When injecting the virtual IRQ associated to the mapped=forwarded IRQ
> (see next comment), the host must not deactivate the physical IRQ so
> that its active state remains?

almost, but this is not the case for the timer, where we set the active
state manually, I'll attempt a reword.

> >> +
> >> +The reasoning for level-triggered interrupts:
> >> +For level-triggered interrupts, we have to mark the interrupt as active
> >> +on the physical distributor,
> to leave the interrupt as active? I have the impression you talk about
> shared IRQ here where the HW would not have any impact on the physical
> distributor state? The physical IRQ can be pending+active too?
>  because otherwise, as the line remains

I'm talking about any level-triggered interrupt where you handle the
interrupt in the guest.  In that case, if you keep deactivating the
interrupt on the host the guest will never make progress.

This is not specific to the timer I think?

Yes, the physical IRQ can be pending+active, but the key is that the
host doesn't deactivate the IRQ.

> >> +asserted, the guest will never execute because the host will keep taking
> >> +interrupts.  As soon as the guest deactivates the interrupt, the
> >> +physical line is sampled by the hardware again and the host takes a new
> >> +interrupt if the physical line is still asserted.
> >> +
> >> +The reasoning for edge-triggered interrupts:
> >> +For edge-triggered interrupts, if we set the HW bit in the LR we also
> >> +have to mark the interrupt as active on the physical distributor.  If we
> >> +don't set the physical active bit and the interrupt hits again before
> >> +the guest has deactivated the interrupt, the interrupt goes to the host,
> >> +which cannot set the state to ACTIVE+PENDING in the LR, because that is
> >> +not supported when setting the HW bit in the LR.
> >> +
> >> +An alternative could be to not use HW bit at all, and inject
> >> +edge-triggered interrupts from a physical assigned device as pure
> >> +virtual interrupts, but that would potentially slow down handling of the
> >> +interrupt in the guest, because a physical interrupt occurring in the
> >> +middle of the guest ISR would preempt the guest for the host to handle
> >> +the interrupt.
> > 
> > It would be worth mentioning that this is valid for PPIs and SPIs. LPIs
> > do not have an Active state (they are either Pending or not), so we'll
> > have to deal with edge interrupts as you just described at some point.
> > Other architectures do something similar, I'd expect.
> > 
> >> +
> >> +
> >> +Life Cycle for Forwarded Physical Interrupts
> >> +--------------------------------------------
> >> +
> >> +By forwarded physical interrupts we mean interrupts presented to a guest
> >> +representing a real HW event originally signaled to the host as a
> > 
> > s/signaled/signalled/
> > 
> >> +physical interrupt
> is it always true for the timer? sometimes isn't it a SW counter that
> expires and upon that event you inject the virtual IRQ with HW bit set?
>  and injecting this as a virtual interrupt with the HW

well you restore the timer state at the same time, so you setup the
hardware exactly as if the timer device raised a physical interrupt
while running the VM.  (in fact that's why we set the active state as
well, because we re-program the arch-timer to assert the line when we
enter the guest).

> >> +bit set in the LR.
> another definition of a forwarded/mapped physical IRQ is a physical IRQ
> that is deactivated by the guest and not by the host.

I was deliberately going for a broader definition; generally trying to
describe how we deal with interrupts from a physical device handled by a
guest, which we do by letting the guest deactive the interrupt.  I think
this is the correct causality analysis ... ?

> 
> Shouldn't we start this file by the definition of a Forwarded Physical
> Interrupts. Here you were supposed to describe their Life Cycle. Also
> note that we previously talked about mapped IRQ and now we talk about
> forwarded IRQ which can be confusing for the reader. 

I agree that the flow feels a bit ad-hoc here.  I'll try to rework the
doc.


> Also we may
> re-introduce the fact that we distinguish between shared and non shared
> beasts to give the full picture?

I'll try to clarify this as well.


> >> +
> >> +The state of such an interrupt is managed in the following way:
> >> +
> >> +  - LR.Pending must be set when the interrupt is first injected, because this
> >> +    is the only way the GICV interface is going to present it to the guest.
> >> +  - LR.Pending will stay set as long as the guest has not acked the interrupt.
> >> +  - LR.Pending transitions to LR.Active on read of IAR, as expected.
> >> +  - On EOI, the *physical distributor* active bit gets cleared, but the
> >> +    LR.Active is left untouched - it looks like the GIC can only clear a
> >> +    single bit (either the virtual active, or the physical one).
> >> +  - This means we cannot trust LR.Active to find out about the state of the
> >> +    interrupt, and we definitely need to look at the distributor version.
> physical distributor version?

indeed, I'll reword.

Thanks,
-Christoffer
