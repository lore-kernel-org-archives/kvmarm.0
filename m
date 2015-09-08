From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 6/8] arm/arm64: KVM: Add forwarded physical interrupts
 documentation
Date: Tue, 8 Sep 2015 16:18:40 +0200
Message-ID: <20150908141840.GA30664@cbox>
References: <1441395650-19663-1-git-send-email-christoffer.dall@linaro.org>
 <1441395650-19663-7-git-send-email-christoffer.dall@linaro.org>
 <55ED7427.1020901@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55ED7427.1020901@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Sep 07, 2015 at 12:25:27PM +0100, Andre Przywara wrote:
> Hi,
> 
> firstly: this text is really great, thanks for coming up with that.
> See below for some information I got from tracing the host which I
> cannot make sense of....
> 
> 
> On 04/09/15 20:40, Christoffer Dall wrote:
> > Forwarded physical interrupts on arm/arm64 is a tricky concept and the
> > way we deal with them is not apparently easy to understand by reading
> > various specs.
> > 
> > Therefore, add a proper documentation file explaining the flow and
> > rationale of the behavior of the vgic.
> > 
> > Some of this text was contributed by Marc Zyngier and edited by me.
> > Omissions and errors are all mine.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt | 181 +++++++++++++++++++++
> >  1 file changed, 181 insertions(+)
> >  create mode 100644 Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
> > 
> > diff --git a/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt b/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
> > new file mode 100644
> > index 0000000..24b6f28
> > --- /dev/null
> > +++ b/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
> > @@ -0,0 +1,181 @@
> > +KVM/ARM VGIC Forwarded Physical Interrupts
> > +==========================================
> > +
> > +The KVM/ARM code implements software support for the ARM Generic
> > +Interrupt Controller's (GIC's) hardware support for virtualization by
> > +allowing software to inject virtual interrupts to a VM, which the guest
> > +OS sees as regular interrupts.  The code is famously known as the VGIC.
> > +
> > +Some of these virtual interrupts, however, correspond to physical
> > +interrupts from real physical devices.  One example could be the
> > +architected timer, which itself supports virtualization, and therefore
> > +lets a guest OS program the hardware device directly to raise an
> > +interrupt at some point in time.  When such an interrupt is raised, the
> > +host OS initially handles the interrupt and must somehow signal this
> > +event as a virtual interrupt to the guest.  Another example could be a
> > +passthrough device, where the physical interrupts are initially handled
> > +by the host, but the device driver for the device lives in the guest OS
> > +and KVM must therefore somehow inject a virtual interrupt on behalf of
> > +the physical one to the guest OS.
> > +
> > +These virtual interrupts corresponding to a physical interrupt on the
> > +host are called forwarded physical interrupts, but are also sometimes
> > +referred to as 'virtualized physical interrupts' and 'mapped interrupts'.
> > +
> > +Forwarded physical interrupts are handled slightly differently compared
> > +to virtual interrupts generated purely by a software emulated device.
> > +
> > +
> > +The HW bit
> > +----------
> > +Virtual interrupts are signalled to the guest by programming the List
> > +Registers (LRs) on the GIC before running a VCPU.  The LR is programmed
> > +with the virtual IRQ number and the state of the interrupt (Pending,
> > +Active, or Pending+Active).  When the guest ACKs and EOIs a virtual
> > +interrupt, the LR state moves from Pending to Active, and finally to
> > +inactive.
> > +
> > +The LRs include an extra bit, called the HW bit.  When this bit is set,
> > +KVM must also program an additional field in the LR, the physical IRQ
> > +number, to link the virtual with the physical IRQ.
> > +
> > +When the HW bit is set, KVM must EITHER set the Pending OR the Active
> > +bit, never both at the same time.
> > +
> > +Setting the HW bit causes the hardware to deactivate the physical
> > +interrupt on the physical distributor when the guest deactivates the
> > +corresponding virtual interrupt.
> > +
> > +
> > +Forwarded Physical Interrupts Life Cycle
> > +----------------------------------------
> > +
> > +The state of forwarded physical interrupts is managed in the following way:
> > +
> > +  - The physical interrupt is acked by the host, and becomes active on
> > +    the physical distributor (*).
> > +  - KVM sets the LR.Pending bit, because this is the only way the GICV
> > +    interface is going to present it to the guest.
> > +  - LR.Pending will stay set as long as the guest has not acked the interrupt.
> > +  - LR.Pending transitions to LR.Active on the guest read of the IAR, as
> > +    expected.
> > +  - On guest EOI, the *physical distributor* active bit gets cleared,
> > +    but the LR.Active is left untouched (set).
> 
> I tried hard in the last week, but couldn't confirm this. Tracing shows
> the following pattern over and over (case 1):
> (This is the kvm/kvm.git:queue branch from last week, so including the
> mapped timer IRQ code. Tests were done on Juno and Midway)
> 
> ...
> 229.340171: kvm_exit: TRAP: HSR_EC: 0x0001 (WFx), PC: 0xffffffc000098a64
> 229.340324: kvm_exit: IRQ: HSR_EC: 0x0001 (WFx), PC: 0xffffffc0001c63a0
> 229.340428: kvm_exit: TRAP: HSR_EC: 0x0024 (DABT_LOW), PC:
> 0xffffffc0004089d8
> 229.340430: kvm_vgic_sync_hwstate: LR0 vIRQ: 27, HWIRQ: 27, LR.state: 8,
> ELRSR: 1, dist active: 0, log. active: 1
> ....
> 
> My hunch is that the following happens (please correct me if needed!):
> First there is an unrelated trap (line 1), then later the guest exits
> due to to an IRQ (line 2, presumably the timer, the WFx is a red herring
> here since ESR_EL2.EC is not valid on IRQ triggered exceptions).
> The host injects the timer IRQ (not shown here) and returns to the
> guest. On the next trap (line 3, due to a stage 2 page fault),
> vgic_sync_hwirq() will be called on the LR (line 4) and shows that the
> GIC actually did deactivate both the LR (state=8, which is inactive,
> just the HW bit is still set) _and_ the state on the physical
> distributor (dist active=0). This trace_printk is just after entering
> the function, so before the code there performs these steps redundantly.
> Also it shows that the ELRSR bit is set to 1 (empty), so from the GIC
> point of view this virtual IRQ cycle is finished.
> 
> The other sequence I see is this one (case 2):
> 
> ....
> 231.055324: kvm_exit: IRQ: HSR_EC: 0x0001 (WFx), PC: 0xffffffc0000f0e70
> 231.055329: kvm_exit: TRAP: HSR_EC: 0x0024 (DABT_LOW), PC:
> 0xffffffc0004089d8
> 231.055331: kvm_vgic_sync_hwstate: LR0 vIRQ: 27, HWIRQ: 27, LR.state: 9,
> ELRSR: 0, dist active: 1, log. active: 1
> 231.055338: kvm_exit: IRQ: HSR_EC: 0x0024 (DABT_LOW), PC: 0xffffffc0004089dc
> 231.055340: kvm_vgic_sync_hwstate: LR0 vIRQ: 27, HWIRQ: 27, LR.state: 9,
> ELRSR: 0, dist active: 0, log. active: 1
> ...
> 
> In line 1 the timer fires, the host injects the timer IRQ into the
> guest, which exits again in line 2 due to a page fault (may have IRQs
> disabled?). The LR dump in line 3 shows that the timer IRQ is still
> pending in the LR (state=9) and active on the physical distributor. Now
> the code in vgic_sync_hwirq() clears the active state in the physical
> distributor (by calling irq_set_irqchip_state()), but leaves the LR
> alone (by returning 0 to the caller).
> On the next exit (line 4, due to some HW IRQ?) the LR is still the same
> (line 5), only that the physical dist state in now inactive (due to us
> clearing that explicitly during the last exit). Now vgic_sync_hwirq()
> returns 1, leading to the LR being cleaned up in the caller.
> So to me it looks like we kill that IRQ before the guest had the chance
> to handle it (presumably because it has IRQs off).
> 
> The distribution of those patterns in my particular snapshot are (all
> with timer IRQ 27):
>  7107  LR.state:  8, ELRSR: 1, dist active: 0, log. active: 1
>  1629  LR.state:  9, ELRSR: 0, dist active: 0, log. active: 1
>  1629  LR.state:  9, ELRSR: 0, dist active: 1, log. active: 1
>   331  LR.state: 10, ELRSR: 0, dist active: 1, log. active: 1
>    68  LR.state: 10, ELRSR: 0, dist active: 0, log. active: 1
> 
> So for the majority of exits with the timer having been injected before
> we redundantly clean the LR (case 1 above). Also there is quite a number
> of cases where we "kill" the IRQ (case 2 above). The active state case
> (state: 10 in the last two lines) seems to be a variation of case 2,
> just with the guest exiting from within the IRQ handler (after
> activation, before EOI).
> 
> I'd appreciate if someone could shed some light on this and show me
> where I am wrong here or what is going on instead.
> 
Hi Andre,

>From your write-up it's a bit unclear exactly where you feel the flow
breaks down compared to your trace.

However, I think the case where we kill the IRQ is the thing fixed in
the other commit "arm/arm64: KVM: vgic: Move active state handling to
flush_hwstate", which I sent recently.

Can you summarize what exactly your concerns are?

Thanks,
-Christoffer
