From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 05/10] KVM: arm/arm64: vgic: Relax vgic_can_sample_irq
 for edge IRQs
Date: Thu, 2 Jul 2015 18:23:59 +0200
Message-ID: <20150702162359.GJ11332@cbox>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com>
 <1433783045-8002-6-git-send-email-marc.zyngier@arm.com>
 <20150630201933.GA11332@cbox>
 <5593B040.6050208@arm.com>
 <20150701115820.GC17890@cbox>
 <55942F00.6000306@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55942F00.6000306@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Eric Auger <eric.auger@linaro.org>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jul 01, 2015 at 07:18:40PM +0100, Marc Zyngier wrote:
> On 01/07/15 12:58, Christoffer Dall wrote:
> > On Wed, Jul 01, 2015 at 10:17:52AM +0100, Marc Zyngier wrote:
> >> On 30/06/15 21:19, Christoffer Dall wrote:
> >>> On Mon, Jun 08, 2015 at 06:04:00PM +0100, Marc Zyngier wrote:
> >>>> We only set the irq_queued flag for level interrupts, meaning
> >>>> that "!vgic_irq_is_queued(vcpu, irq)" is a good enough predicate
> >>>> for all interrupts.
> >>>>
> >>>> This will allow us to inject edge HW interrupts, for which the
> >>>> state ACTIVE+PENDING is not allowed.
> >>>
> >>> I don't understand this; ACTIVE+PENDING is allowed for edge interrupts.
> >>> Do you mean that if we set the HW bit in the LR, then we are linking to
> >>> an HW interrupt where we don't allow that to be ACTIVE+PENDING on the HW
> >>> GIC side?
> >>>
> >>> Why is this relevant here?  I feel like I'm missing context.
> >>
> >> I've probably taken a shortcut here - bear with me while I'm trying to
> >> explain the issue.
> >>
> >> For HW interrupts, we shouldn't even try to use the state bits in the
> >> LR, because that state is contained in the physical distributor. Setting
> >> the HW bit really means "there is something going on at the distributor
> >> level, just go there".
> > 
> > ok, so by "HW interrupts" you mean virtual interrupts with the HW bit in
> > the LR set, correct?
> 
> Yes, sorry.
> 
> >>
> >> If we were to inject a ACTIVE+PENDING interrupt at the LR level, we'd
> >> basically loose the second interrupt because that state is simply not
> >> considered.
> > 
> > Huh?  Which second interrupt.  I looked at the spec and it says don't
> > use the state bits for HW interrupts, so isn't it simply not supported
> > to set these bits at all and that's it?
> 
> I managed to confuse myself reading the same bit. It says (GICv3 spec):
> 
> "A hypervisor must only use the pending and active state for software
> originated interrupts, which are typically associated with virtual
> devices, or SGIs."
> 
> That's the PENDING+ACTIVE state, and not the pending and active bits
> like I read it initially.
> 
> Now consider the following scenario:
> 
> - We inject a virtual edge interrupt
> - We mark the corresponding physical interrupt as active.
> - Queue interrupt in an LR
> - Resume vcpu
> 
> Now, we inject another edge interrupt, the vcpu exits for whatever
> reason, and the previously injected interrupt is still active.
> 
> The normal vGIC flow would be to mark the interrupt as ACTIVE+PENDING in
> the LR, and resume the vcpu. But the above states that this is invalid
> for HW generated interrupts.

Right, ok, so we must resample the pending state even for an
edge-triggered interrupt once it's EOIed, because we cannot put it in
the LR despite it being pending on the physical distributor?

Incidentally, we do not need to set the EOI_INT bit, becuase when the
guest EOIs the interrupt, it will also deactivate it on the physical
distributor and the hardware will then take the pending physical
interrupt, we will handle it in the host, etc. etc.

If we had a different *shared* device than the timer which is
edge-triggered, don't we then also need to capture the physical
distributor's pending state along with the state of the device unless we
assume that upon restoring the state for the device count on the device
to have another rising/falling edge to trigger the interrupt again? (I
assume the line would always go high for a level-triggered interrupt in
this case).

> 
> >>
> >> So the trick we're using is to only inject the active interrupt, and
> >> prevent anything else from being injected until we can confirm that the
> >> active state has been cleared at the physical level.
> >>
> >> Does it make any sense?
> >>
> > Sort of, but what I don't understand now is how the guest ever sees the
> > interrupt then.  If we always inject the virtual interrupt by setting
> > the active state on the physical distributor, and we can't inject this
> > as active+pending, and the guest doesn't see the state in the LR, then
> > how does this ever raise a virtual interrupt and how does the guest see
> > an interrupt which is only PENDING so that it can ack it etc. etc.?
> > 
> > Maybe I don't fully understand how the HW bit works after all...
> 
> The way the spec is written is slightly misleading. But the gist of it
> is that we still signal the guest using the PENDING bit in the LR, and
> switch the LR as usual. it is just that we can't use the PENDING+ACTIVE
> state (apparently, this can lead to a double deactivation).
> 
> Not sure the above makes sense. Beer time, I suppose.
> 
It does make sense, I just had to sleep on it and see the code as a
whole instead of trying to understand it by just looking at this patch
individually.

Thanks,
-Christoffer
