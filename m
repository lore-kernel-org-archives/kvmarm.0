From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 6/8] arm/arm64: KVM: Add forwarded physical interrupts
 documentation
Date: Mon, 14 Sep 2015 13:42:19 +0200
Message-ID: <20150914114219.GJ15712@cbox>
References: <1441395650-19663-1-git-send-email-christoffer.dall@linaro.org>
 <1441395650-19663-7-git-send-email-christoffer.dall@linaro.org>
 <55ED7427.1020901@arm.com>
 <55EE9FA4.3060204@linaro.org>
 <55EF1389.10802@arm.com>
 <CAMJs5B_Qxkfu=KSA0oUm386_mgZ73_NQEqS6e+gBGxwBMJVezg@mail.gmail.com>
 <55F2B932.2030901@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55F2B932.2030901@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Eric Auger <eric.auger@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On Fri, Sep 11, 2015 at 12:21:22PM +0100, Andre Przywara wrote:
> Hi Christoffer,
> 
> (actually you are not supposed to reply during your holidays!)

yeah, I know, but I couldn't help myself here.

> 
> On 09/09/15 09:49, Christoffer Dall wrote:
> > On Tue, Sep 8, 2015 at 6:57 PM, Andre Przywara <andre.przywara@arm.com> wrote:
> >> Hi Eric,
> >>
> >> thanks for you answer.
> >>
> >> On 08/09/15 09:43, Eric Auger wrote:
> >>> Hi Andre,
> >>> On 09/07/2015 01:25 PM, Andre Przywara wrote:
> >>>> Hi,
> >>>>
> >>>> firstly: this text is really great, thanks for coming up with that.
> >>>> See below for some information I got from tracing the host which I
> >>>> cannot make sense of....
> >>>>
> >>>>
> >>>> On 04/09/15 20:40, Christoffer Dall wrote:
> >>>>> Forwarded physical interrupts on arm/arm64 is a tricky concept and the
> >>>>> way we deal with them is not apparently easy to understand by reading
> >>>>> various specs.
> >>>>>
> >>>>> Therefore, add a proper documentation file explaining the flow and
> >>>>> rationale of the behavior of the vgic.
> >>>>>
> >>>>> Some of this text was contributed by Marc Zyngier and edited by me.
> >>>>> Omissions and errors are all mine.
> >>>>>
> >>>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >>>>> ---
> >>>>>  Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt | 181 +++++++++++++++++++++
> >>>>>  1 file changed, 181 insertions(+)
> >>>>>  create mode 100644 Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
> >>>>>
> >>>>> diff --git a/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt b/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
> >>>>> new file mode 100644
> >>>>> index 0000000..24b6f28
> >>>>> --- /dev/null
> >>>>> +++ b/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
> >>>>> @@ -0,0 +1,181 @@
> >>>>> +KVM/ARM VGIC Forwarded Physical Interrupts
> >>>>> +==========================================
> >>>>> +
> >>>>> +The KVM/ARM code implements software support for the ARM Generic
> >>>>> +Interrupt Controller's (GIC's) hardware support for virtualization by
> >>>>> +allowing software to inject virtual interrupts to a VM, which the guest
> >>>>> +OS sees as regular interrupts.  The code is famously known as the VGIC.
> >>>>> +
> >>>>> +Some of these virtual interrupts, however, correspond to physical
> >>>>> +interrupts from real physical devices.  One example could be the
> >>>>> +architected timer, which itself supports virtualization, and therefore
> >>>>> +lets a guest OS program the hardware device directly to raise an
> >>>>> +interrupt at some point in time.  When such an interrupt is raised, the
> >>>>> +host OS initially handles the interrupt and must somehow signal this
> >>>>> +event as a virtual interrupt to the guest.  Another example could be a
> >>>>> +passthrough device, where the physical interrupts are initially handled
> >>>>> +by the host, but the device driver for the device lives in the guest OS
> >>>>> +and KVM must therefore somehow inject a virtual interrupt on behalf of
> >>>>> +the physical one to the guest OS.
> >>>>> +
> >>>>> +These virtual interrupts corresponding to a physical interrupt on the
> >>>>> +host are called forwarded physical interrupts, but are also sometimes
> >>>>> +referred to as 'virtualized physical interrupts' and 'mapped interrupts'.
> >>>>> +
> >>>>> +Forwarded physical interrupts are handled slightly differently compared
> >>>>> +to virtual interrupts generated purely by a software emulated device.
> >>>>> +
> >>>>> +
> >>>>> +The HW bit
> >>>>> +----------
> >>>>> +Virtual interrupts are signalled to the guest by programming the List
> >>>>> +Registers (LRs) on the GIC before running a VCPU.  The LR is programmed
> >>>>> +with the virtual IRQ number and the state of the interrupt (Pending,
> >>>>> +Active, or Pending+Active).  When the guest ACKs and EOIs a virtual
> >>>>> +interrupt, the LR state moves from Pending to Active, and finally to
> >>>>> +inactive.
> >>>>> +
> >>>>> +The LRs include an extra bit, called the HW bit.  When this bit is set,
> >>>>> +KVM must also program an additional field in the LR, the physical IRQ
> >>>>> +number, to link the virtual with the physical IRQ.
> >>>>> +
> >>>>> +When the HW bit is set, KVM must EITHER set the Pending OR the Active
> >>>>> +bit, never both at the same time.
> >>>>> +
> >>>>> +Setting the HW bit causes the hardware to deactivate the physical
> >>>>> +interrupt on the physical distributor when the guest deactivates the
> >>>>> +corresponding virtual interrupt.
> >>>>> +
> >>>>> +
> >>>>> +Forwarded Physical Interrupts Life Cycle
> >>>>> +----------------------------------------
> >>>>> +
> >>>>> +The state of forwarded physical interrupts is managed in the following way:
> >>>>> +
> >>>>> +  - The physical interrupt is acked by the host, and becomes active on
> >>>>> +    the physical distributor (*).
> >>>>> +  - KVM sets the LR.Pending bit, because this is the only way the GICV
> >>>>> +    interface is going to present it to the guest.
> >>>>> +  - LR.Pending will stay set as long as the guest has not acked the interrupt.
> >>>>> +  - LR.Pending transitions to LR.Active on the guest read of the IAR, as
> >>>>> +    expected.
> >>>>> +  - On guest EOI, the *physical distributor* active bit gets cleared,
> >>>>> +    but the LR.Active is left untouched (set).
> >>>>
> >>>> I tried hard in the last week, but couldn't confirm this. Tracing shows
> >>>> the following pattern over and over (case 1):
> >>>> (This is the kvm/kvm.git:queue branch from last week, so including the
> >>>> mapped timer IRQ code. Tests were done on Juno and Midway)
> >>>>
> >>>> ...
> >>>> 229.340171: kvm_exit: TRAP: HSR_EC: 0x0001 (WFx), PC: 0xffffffc000098a64
> >>>> 229.340324: kvm_exit: IRQ: HSR_EC: 0x0001 (WFx), PC: 0xffffffc0001c63a0
> >>>> 229.340428: kvm_exit: TRAP: HSR_EC: 0x0024 (DABT_LOW), PC:
> >>>> 0xffffffc0004089d8
> >>>> 229.340430: kvm_vgic_sync_hwstate: LR0 vIRQ: 27, HWIRQ: 27, LR.state: 8,
> >>>> ELRSR: 1, dist active: 0, log. active: 1
> >>>> ....
> >>>>
> >>>> My hunch is that the following happens (please correct me if needed!):
> >>>> First there is an unrelated trap (line 1), then later the guest exits
> >>>> due to to an IRQ (line 2, presumably the timer, the WFx is a red herring
> >>>> here since ESR_EL2.EC is not valid on IRQ triggered exceptions).
> >>>> The host injects the timer IRQ (not shown here) and returns to the
> >>>> guest. On the next trap (line 3, due to a stage 2 page fault),
> >>>> vgic_sync_hwirq() will be called on the LR (line 4) and shows that the
> >>>> GIC actually did deactivate both the LR (state=8, which is inactive,
> >>>> just the HW bit is still set) _and_ the state on the physical
> >>>> distributor (dist active=0). This trace_printk is just after entering
> >>>> the function, so before the code there performs these steps redundantly.
> >>>> Also it shows that the ELRSR bit is set to 1 (empty), so from the GIC
> >>>> point of view this virtual IRQ cycle is finished.
> >>>>
> >>>> The other sequence I see is this one (case 2):
> >>>>
> >>>> ....
> >>>> 231.055324: kvm_exit: IRQ: HSR_EC: 0x0001 (WFx), PC: 0xffffffc0000f0e70
> >>>> 231.055329: kvm_exit: TRAP: HSR_EC: 0x0024 (DABT_LOW), PC:
> >>>> 0xffffffc0004089d8
> >>>> 231.055331: kvm_vgic_sync_hwstate: LR0 vIRQ: 27, HWIRQ: 27, LR.state: 9,
> >>>> ELRSR: 0, dist active: 1, log. active: 1
> >>>> 231.055338: kvm_exit: IRQ: HSR_EC: 0x0024 (DABT_LOW), PC: 0xffffffc0004089dc
> >>>> 231.055340: kvm_vgic_sync_hwstate: LR0 vIRQ: 27, HWIRQ: 27, LR.state: 9,
> >>>> ELRSR: 0, dist active: 0, log. active: 1
> >>>> ...
> >>>>
> >>>> In line 1 the timer fires, the host injects the timer IRQ into the
> >>>> guest, which exits again in line 2 due to a page fault (may have IRQs
> >>>> disabled?). The LR dump in line 3 shows that the timer IRQ is still
> >>>> pending in the LR (state=9) and active on the physical distributor. Now
> >>>> the code in vgic_sync_hwirq() clears the active state in the physical
> >>>> distributor (by calling irq_set_irqchip_state()), but leaves the LR
> >>>> alone (by returning 0 to the caller).
> >>>> On the next exit (line 4, due to some HW IRQ?) the LR is still the same
> >>>> (line 5), only that the physical dist state in now inactive (due to us
> >>>> clearing that explicitly during the last exit).
> >>> Normally the physical dist state was set active on previous flush, right
> >>> (done for all mapped IRQs)?
> >>
> >> Where is this done? I see that the physical dist state is altered on the
> >> actual IRQ forwarding, but not on later exits/entries? Do you mean
> >> kvm_vgic_flush_hwstate() with "flush"?
> > 
> > this is a bug and should be fixed in the 'fixes' patches I sent last
> > week.  We should set active state on every entry to the guest for IRQs
> > with the HW bit set in either pending or active state.
> 
> OK, sorry, I missed that one patch, I was looking at what should become
> -rc1 soon (because that's what I want to rebase my ITS emulation patches
> on). That patch wasn't in queue at the time I started looking at it.
> 
> So I updated to the latest queue containing those two fixes and also
> applied your v2 series. Indeed this series addresses some of the things
> I was wondering about the last time, but the main thing still persists:
> - Every time the physical dist state is active we have the virtual state
> still at pending or active.

For the arch timer, yes.

For a passthrough device, there should be a situation where the physical
dist state is active but we didn't see the virtual state updated at the
vgic yet (after physical IRQ fires and before the VFIO ISR calls
kvm_set_irq).

> - If the physical dist state is non-active, the virtual state is
> inactive (LR.state==8: HW bit) as well. The associated ELRSR bit is 1
> (LR empty).
> (I was tracing every HW mapped LR in vgic_sync_hwirq() for this)
> 
> So that contradicts:
> 
> +  - On guest EOI, the *physical distributor* active bit gets cleared,
> +    but the LR.Active is left untouched (set).
> 
> This is the main point I was actually wondering about: I cannot confirm
> this statement. In my tests the LR state and the physical dist state
> always correspond, as excepted by reading the spec.
> 
> I reckon that these observations are mostly independent from the actual
> KVM code, as I try to observe hardware state (physical distributor and
> LRs) before KVM tinkers with them.

ok, I got this paragraph from Marc, so we really need to ask him?  Which
hardware are you seeing this behavior on?  Perhaps implementations vary
on this point?

I have no objections removing this point from the doc though, I'm just
relaying information on this one.

> 
> ...
> 
> > 
> >> Is this an observation, an implementation bug or is this mentioned in
> >> the spec? Needing to spoon-feed the VGIC by doing it's job sounds a bit
> >> awkward to me.
> > 
> > What do you mean?  How are we spoon-feeding the VGIC?
> 
> By looking at the physical dist state and all LRs and clearing the LR we
> do what the GIC is actually supposed to do for us - and what it actually
> does according to my observations.
> 
> The point is that patch 1 in my ITS emulation series is reworking the LR
> handling and this patch was based on assumptions that seem to be no
> longer true (i.e. we don't care about inactive LRs except for our LR
> mapping code). So I want to be sure that I fully get what is going on
> here and I struggle at this at the moment due to the above statement.
> 
> What are the plans regarding your "v2: Rework architected timer..."
> series? Will this be queued for 4.4? I want to do the
> rebasing^Wrewriting of my series only once if possible ;-)
> 
I think we should settle on this series ASAP and base your ITS stuff on
top of it.  What do you think?

-Christoffer
