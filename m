From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 6/8] arm/arm64: KVM: Add forwarded physical interrupts
 documentation
Date: Mon, 7 Sep 2015 12:25:27 +0100
Message-ID: <55ED7427.1020901@arm.com>
References: <1441395650-19663-1-git-send-email-christoffer.dall@linaro.org>
 <1441395650-19663-7-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D68B41252
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2015 07:23:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2J-akauY8ODm for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Sep 2015 07:23:35 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CA3C40FB5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2015 07:23:34 -0400 (EDT)
In-Reply-To: <1441395650-19663-7-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

firstly: this text is really great, thanks for coming up with that.
See below for some information I got from tracing the host which I
cannot make sense of....


On 04/09/15 20:40, Christoffer Dall wrote:
> Forwarded physical interrupts on arm/arm64 is a tricky concept and the
> way we deal with them is not apparently easy to understand by reading
> various specs.
> 
> Therefore, add a proper documentation file explaining the flow and
> rationale of the behavior of the vgic.
> 
> Some of this text was contributed by Marc Zyngier and edited by me.
> Omissions and errors are all mine.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt | 181 +++++++++++++++++++++
>  1 file changed, 181 insertions(+)
>  create mode 100644 Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
> 
> diff --git a/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt b/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
> new file mode 100644
> index 0000000..24b6f28
> --- /dev/null
> +++ b/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
> @@ -0,0 +1,181 @@
> +KVM/ARM VGIC Forwarded Physical Interrupts
> +==========================================
> +
> +The KVM/ARM code implements software support for the ARM Generic
> +Interrupt Controller's (GIC's) hardware support for virtualization by
> +allowing software to inject virtual interrupts to a VM, which the guest
> +OS sees as regular interrupts.  The code is famously known as the VGIC.
> +
> +Some of these virtual interrupts, however, correspond to physical
> +interrupts from real physical devices.  One example could be the
> +architected timer, which itself supports virtualization, and therefore
> +lets a guest OS program the hardware device directly to raise an
> +interrupt at some point in time.  When such an interrupt is raised, the
> +host OS initially handles the interrupt and must somehow signal this
> +event as a virtual interrupt to the guest.  Another example could be a
> +passthrough device, where the physical interrupts are initially handled
> +by the host, but the device driver for the device lives in the guest OS
> +and KVM must therefore somehow inject a virtual interrupt on behalf of
> +the physical one to the guest OS.
> +
> +These virtual interrupts corresponding to a physical interrupt on the
> +host are called forwarded physical interrupts, but are also sometimes
> +referred to as 'virtualized physical interrupts' and 'mapped interrupts'.
> +
> +Forwarded physical interrupts are handled slightly differently compared
> +to virtual interrupts generated purely by a software emulated device.
> +
> +
> +The HW bit
> +----------
> +Virtual interrupts are signalled to the guest by programming the List
> +Registers (LRs) on the GIC before running a VCPU.  The LR is programmed
> +with the virtual IRQ number and the state of the interrupt (Pending,
> +Active, or Pending+Active).  When the guest ACKs and EOIs a virtual
> +interrupt, the LR state moves from Pending to Active, and finally to
> +inactive.
> +
> +The LRs include an extra bit, called the HW bit.  When this bit is set,
> +KVM must also program an additional field in the LR, the physical IRQ
> +number, to link the virtual with the physical IRQ.
> +
> +When the HW bit is set, KVM must EITHER set the Pending OR the Active
> +bit, never both at the same time.
> +
> +Setting the HW bit causes the hardware to deactivate the physical
> +interrupt on the physical distributor when the guest deactivates the
> +corresponding virtual interrupt.
> +
> +
> +Forwarded Physical Interrupts Life Cycle
> +----------------------------------------
> +
> +The state of forwarded physical interrupts is managed in the following way:
> +
> +  - The physical interrupt is acked by the host, and becomes active on
> +    the physical distributor (*).
> +  - KVM sets the LR.Pending bit, because this is the only way the GICV
> +    interface is going to present it to the guest.
> +  - LR.Pending will stay set as long as the guest has not acked the interrupt.
> +  - LR.Pending transitions to LR.Active on the guest read of the IAR, as
> +    expected.
> +  - On guest EOI, the *physical distributor* active bit gets cleared,
> +    but the LR.Active is left untouched (set).

I tried hard in the last week, but couldn't confirm this. Tracing shows
the following pattern over and over (case 1):
(This is the kvm/kvm.git:queue branch from last week, so including the
mapped timer IRQ code. Tests were done on Juno and Midway)

...
229.340171: kvm_exit: TRAP: HSR_EC: 0x0001 (WFx), PC: 0xffffffc000098a64
229.340324: kvm_exit: IRQ: HSR_EC: 0x0001 (WFx), PC: 0xffffffc0001c63a0
229.340428: kvm_exit: TRAP: HSR_EC: 0x0024 (DABT_LOW), PC:
0xffffffc0004089d8
229.340430: kvm_vgic_sync_hwstate: LR0 vIRQ: 27, HWIRQ: 27, LR.state: 8,
ELRSR: 1, dist active: 0, log. active: 1
....

My hunch is that the following happens (please correct me if needed!):
First there is an unrelated trap (line 1), then later the guest exits
due to to an IRQ (line 2, presumably the timer, the WFx is a red herring
here since ESR_EL2.EC is not valid on IRQ triggered exceptions).
The host injects the timer IRQ (not shown here) and returns to the
guest. On the next trap (line 3, due to a stage 2 page fault),
vgic_sync_hwirq() will be called on the LR (line 4) and shows that the
GIC actually did deactivate both the LR (state=8, which is inactive,
just the HW bit is still set) _and_ the state on the physical
distributor (dist active=0). This trace_printk is just after entering
the function, so before the code there performs these steps redundantly.
Also it shows that the ELRSR bit is set to 1 (empty), so from the GIC
point of view this virtual IRQ cycle is finished.

The other sequence I see is this one (case 2):

....
231.055324: kvm_exit: IRQ: HSR_EC: 0x0001 (WFx), PC: 0xffffffc0000f0e70
231.055329: kvm_exit: TRAP: HSR_EC: 0x0024 (DABT_LOW), PC:
0xffffffc0004089d8
231.055331: kvm_vgic_sync_hwstate: LR0 vIRQ: 27, HWIRQ: 27, LR.state: 9,
ELRSR: 0, dist active: 1, log. active: 1
231.055338: kvm_exit: IRQ: HSR_EC: 0x0024 (DABT_LOW), PC: 0xffffffc0004089dc
231.055340: kvm_vgic_sync_hwstate: LR0 vIRQ: 27, HWIRQ: 27, LR.state: 9,
ELRSR: 0, dist active: 0, log. active: 1
...

In line 1 the timer fires, the host injects the timer IRQ into the
guest, which exits again in line 2 due to a page fault (may have IRQs
disabled?). The LR dump in line 3 shows that the timer IRQ is still
pending in the LR (state=9) and active on the physical distributor. Now
the code in vgic_sync_hwirq() clears the active state in the physical
distributor (by calling irq_set_irqchip_state()), but leaves the LR
alone (by returning 0 to the caller).
On the next exit (line 4, due to some HW IRQ?) the LR is still the same
(line 5), only that the physical dist state in now inactive (due to us
clearing that explicitly during the last exit). Now vgic_sync_hwirq()
returns 1, leading to the LR being cleaned up in the caller.
So to me it looks like we kill that IRQ before the guest had the chance
to handle it (presumably because it has IRQs off).

The distribution of those patterns in my particular snapshot are (all
with timer IRQ 27):
 7107  LR.state:  8, ELRSR: 1, dist active: 0, log. active: 1
 1629  LR.state:  9, ELRSR: 0, dist active: 0, log. active: 1
 1629  LR.state:  9, ELRSR: 0, dist active: 1, log. active: 1
  331  LR.state: 10, ELRSR: 0, dist active: 1, log. active: 1
   68  LR.state: 10, ELRSR: 0, dist active: 0, log. active: 1

So for the majority of exits with the timer having been injected before
we redundantly clean the LR (case 1 above). Also there is quite a number
of cases where we "kill" the IRQ (case 2 above). The active state case
(state: 10 in the last two lines) seems to be a variation of case 2,
just with the guest exiting from within the IRQ handler (after
activation, before EOI).

I'd appreciate if someone could shed some light on this and show me
where I am wrong here or what is going on instead.

Cheers,
Andre.

> +  - KVM clears the LR when on VM exits when the physical distributor
> +    active state has been cleared.
> +
> +(*): The host handling is slightly more complicated.  For some devices
> +(shared), KVM directly sets the active state on the physical distributor
> +before entering the guest, and for some devices (non-shared) the host
> +configures the GIC such that it does not deactivate the interrupt on
> +host EOIs, but only performs a priority drop allowing the GIC to receive
> +other interrupts and leaves the interrupt in the active state on the
> +physical distributor.
> +
> +
> +Forwarded Edge and Level Triggered PPIs and SPIs
> +------------------------------------------------
> +Forwarded physical interrupts injected should always be active on the
> +physical distributor when injected to a guest.
> +
> +Level-triggered interrupts will keep the interrupt line to the GIC
> +asserted, typically until the guest programs the device to deassert the
> +line.  This means that the interrupt will remain pending on the physical
> +distributor until the guest has reprogrammed the device.  Since we
> +always run the VM with interrupts enabled on the CPU, a pending
> +interrupt will exit the guest as soon as we switch into the guest,
> +preventing the guest from ever making progress as the process repeats
> +over and over.  Therefore, the active state on the physical distributor
> +must be set when entering the guest, preventing the GIC from forwarding
> +the pending interrupt to the CPU.  As soon as the guest deactivates
> +(EOIs) the interrupt, the physical line is sampled by the hardware again
> +and the host takes a new interrupt if and only if the physical line is
> +still asserted.
> +
> +Edge-triggered interrupts do not exhibit the same problem with
> +preventing guest execution that level-triggered interrupts do.  One
> +option is to not use HW bit at all, and inject edge-triggered interrupts
> +from a physical device as pure virtual interrupts.  But that would
> +potentially slow down handling of the interrupt in the guest, because a
> +physical interrupt occurring in the middle of the guest ISR would
> +preempt the guest for the host to handle the interrupt.  Additionally,
> +if you configure the system to handle interrupts on a separate physical
> +core from that running your VCPU, you still have to interrupt the VCPU
> +to queue the pending state onto the LR, even though the guest won't use
> +this information until the guest ISR completes.  Therefore, the HW
> +bit should always be set for forwarded edge-triggered interrupts.  With
> +the HW bit set, the virtual interrupt is injected and additional
> +physical interrupts occurring before the guest deactivates the interrupt
> +simply mark the state on the physical distributor as Pending+Active.  As
> +soon as the guest deactivates the interrupt, the host takes another
> +interrupt if and only if there was a physical interrupt between
> +injecting the forwarded interrupt to the guest the guest deactivating
> +the interrupt.
> +
> +Consequently, whenever we schedule a VCPU with one or more LRs with the
> +HW bit set, the interrupt must also be active on the physical
> +distributor.
> +
> +
> +Forwarded LPIs
> +--------------
> +LPIs, introduced in GICv3, are always edge-triggered and do not have an
> +active state.  They become pending when a device signal them, and as
> +soon as they are acked by the CPU, they are inactive again.
> +
> +It therefore doesn't make sense, and is not supported, to set the HW bit
> +for physical LPIs that are forwarded to a VM as virtual interrupts,
> +typically virtual SPIs.
> +
> +For LPIs, there is no other choice than to preempt the VCPU thread if
> +necessary, and queue the pending state onto the LR.
> +
> +
> +Putting It Together: The Architected Timer
> +------------------------------------------
> +The architected timer is a device that signals interrupts with level
> +triggered semantics.  The timer hardware is directly accessed by VCPUs
> +which program the timer to fire at some point in time.  Each VCPU on a
> +system programs the timer to fire at different times, and therefore the
> +hardware is multiplexed between multiple VCPUs.  This is implemented by
> +context-switching the timer state along with each VCPU thread.
> +
> +However, this means that a scenario like the following is entirely
> +possible, and in fact, typical:
> +
> +1.  KVM runs the VCPU
> +2.  The guest programs the time to fire in T+100
> +3.  The guest is idle and calls WFI (wait-for-interrupts)
> +4.  The hardware traps to the host
> +5.  KVM stores the timer state to memory and disables the hardware timer
> +6.  KVM schedules a soft timer to fire in T+(100 - time since step 2)
> +7.  KVM puts the VCPU thread to sleep (on a waitqueue)
> +8.  The soft timer fires, waking up the VCPU thread
> +9.  KVM reprograms the timer hardware with the VCPU's values
> +10. KVM marks the timer interrupt as active on the physical distributor
> +11. KVM injects a forwarded physical interrupt to the guest
> +12. KVM runs the VCPU
> +
> +Notice that KVM injects a forwarded physical interrupt in step 11 without
> +the corresponding interrupt having actually fired on the host.  That is
> +exactly why we mark the timer interrupt as active in step 10, because
> +the active state on the physical distributor is part of the state
> +belonging to the timer hardware, which is context-switched along with
> +the VCPU thread.
> +
> +If the guest does not idle because it is busy, flow looks like this
> +instead:
> +
> +1.  KVM runs the VCPU
> +2.  The guest programs the time to fire in T+100
> +4.  At T+100 the timer fires and a physical IRQ causes the VM to exit
> +5.  With interrupts disabled on the CPU, KVM looks at the timer state
> +    and injects a forwarded physical interrupt because it concludes the
> +    timer has expired.
> +6.  KVM marks the timer interrupt as active on the physical distributor
> +7.  KVM runs the VCPU
> +
> +Notice that again the forwarded physical interrupt is injected to the
> +guest without having actually been handled on the host.  In this case it
> +is because the physical interrupt is forwarded to the guest before KVM
> +enables physical interrupts on the CPU after exiting the guest.
> 
