From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v3 6/8] arm/arm64: KVM: Add forwarded physical interrupts
 documentation
Date: Tue, 29 Sep 2015 16:49:03 +0200
Message-ID: <1443538145-11990-7-git-send-email-christoffer.dall@linaro.org>
References: <1443538145-11990-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0E584156D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2015 10:47:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bz284dsxOhu8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Sep 2015 10:47:40 -0400 (EDT)
Received: from mail-la0-f44.google.com (mail-la0-f44.google.com
 [209.85.215.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EBF3C411E3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2015 10:47:38 -0400 (EDT)
Received: by lahh2 with SMTP id h2so11758977lah.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2015 07:49:13 -0700 (PDT)
In-Reply-To: <1443538145-11990-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Forwarded physical interrupts on arm/arm64 is a tricky concept and the
way we deal with them is not apparently easy to understand by reading
various specs.

Therefore, add a proper documentation file explaining the flow and
rationale of the behavior of the vgic.

Some of this text was contributed by Marc Zyngier and edited by me.
Omissions and errors are all mine.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt | 186 +++++++++++++++++++++
 1 file changed, 186 insertions(+)
 create mode 100644 Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt

diff --git a/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt b/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
new file mode 100644
index 0000000..213d650
--- /dev/null
+++ b/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
@@ -0,0 +1,186 @@
+KVM/ARM VGIC Forwarded Physical Interrupts
+==========================================
+
+The KVM/ARM code implements software support for the ARM Generic
+Interrupt Controller's (GIC's) hardware support for virtualization by
+allowing software to inject virtual interrupts to a VM, which the guest
+OS sees as regular interrupts.  The code is famously known as the VGIC.
+
+Some of these virtual interrupts, however, correspond to physical
+interrupts from real physical devices.  One example could be the
+architected timer, which itself supports virtualization, and therefore
+lets a guest OS program the hardware device directly to raise an
+interrupt at some point in time.  When such an interrupt is raised, the
+host OS initially handles the interrupt and must somehow signal this
+event as a virtual interrupt to the guest.  Another example could be a
+passthrough device, where the physical interrupts are initially handled
+by the host, but the device driver for the device lives in the guest OS
+and KVM must therefore somehow inject a virtual interrupt on behalf of
+the physical one to the guest OS.
+
+These virtual interrupts corresponding to a physical interrupt on the
+host are called forwarded physical interrupts, but are also sometimes
+referred to as 'virtualized physical interrupts' and 'mapped interrupts'.
+
+Forwarded physical interrupts are handled slightly differently compared
+to virtual interrupts generated purely by a software emulated device.
+
+
+The HW bit
+----------
+Virtual interrupts are signalled to the guest by programming the List
+Registers (LRs) on the GIC before running a VCPU.  The LR is programmed
+with the virtual IRQ number and the state of the interrupt (Pending,
+Active, or Pending+Active).  When the guest ACKs and EOIs a virtual
+interrupt, the LR state moves from Pending to Active, and finally to
+inactive.
+
+The LRs include an extra bit, called the HW bit.  When this bit is set,
+KVM must also program an additional field in the LR, the physical IRQ
+number, to link the virtual with the physical IRQ.
+
+When the HW bit is set, KVM must EITHER set the Pending OR the Active
+bit, never both at the same time.
+
+Setting the HW bit causes the hardware to deactivate the physical
+interrupt on the physical distributor when the guest deactivates the
+corresponding virtual interrupt.
+
+
+Forwarded Physical Interrupts Life Cycle
+----------------------------------------
+
+The state of forwarded physical interrupts is managed in the following way:
+
+  - The physical interrupt is acked by the host, and becomes active on
+    the physical distributor (*).
+  - KVM sets the LR.Pending bit, because this is the only way the GICV
+    interface is going to present it to the guest.
+  - LR.Pending will stay set as long as the guest has not acked the interrupt.
+  - LR.Pending transitions to LR.Active on the guest read of the IAR, as
+    expected.
+  - On guest EOI, the *physical distributor* active bit gets cleared,
+    but the LR.Active is left untouched (set).
+  - KVM clears the LR on VM exits when the physical distributor
+    active state has been cleared.
+
+(*): The host handling is slightly more complicated.  For some forwarded
+interrupts (shared), KVM directly sets the active state on the physical
+distributor before entering the guest, because the interrupt is never actually
+handled on the host (see details on the timer as an example below).  For other
+forwarded interrupts (non-shared) the host does not deactivate the interrupt
+when the host ISR completes, but leaves the interrupt active until the guest
+deactivates it.  Leaving the interrupt active is allowed, because the GIC is
+configured with EOIMode=1, which causes EOI operations to perform a priority
+drop allowing the GIC to receive other interrupts of the default priority.
+
+
+Forwarded Edge and Level Triggered PPIs and SPIs
+------------------------------------------------
+Forwarded physical interrupts injected should always be active on the
+physical distributor when injected to a guest.
+
+Level-triggered interrupts will keep the interrupt line to the GIC
+asserted, typically until the guest programs the device to deassert the
+line.  This means that the interrupt will remain pending on the physical
+distributor until the guest has reprogrammed the device.  Since we
+always run the VM with interrupts enabled on the CPU, a pending
+interrupt will exit the guest as soon as we switch into the guest,
+preventing the guest from ever making progress as the process repeats
+over and over.  Therefore, the active state on the physical distributor
+must be set when entering the guest, preventing the GIC from forwarding
+the pending interrupt to the CPU.  As soon as the guest deactivates the
+interrupt, the physical line is sampled by the hardware again and the host
+takes a new interrupt if and only if the physical line is still asserted.
+
+Edge-triggered interrupts do not exhibit the same problem with
+preventing guest execution that level-triggered interrupts do.  One
+option is to not use HW bit at all, and inject edge-triggered interrupts
+from a physical device as pure virtual interrupts.  But that would
+potentially slow down handling of the interrupt in the guest, because a
+physical interrupt occurring in the middle of the guest ISR would
+preempt the guest for the host to handle the interrupt.  Additionally,
+if you configure the system to handle interrupts on a separate physical
+core from that running your VCPU, you still have to interrupt the VCPU
+to queue the pending state onto the LR, even though the guest won't use
+this information until the guest ISR completes.  Therefore, the HW
+bit should always be set for forwarded edge-triggered interrupts.  With
+the HW bit set, the virtual interrupt is injected and additional
+physical interrupts occurring before the guest deactivates the interrupt
+simply mark the state on the physical distributor as Pending+Active.  As
+soon as the guest deactivates the interrupt, the host takes another
+interrupt if and only if there was a physical interrupt between injecting
+the forwarded interrupt to the guest and the guest deactivating the
+interrupt.
+
+Consequently, whenever we schedule a VCPU with one or more LRs with the
+HW bit set, the interrupt must also be active on the physical
+distributor.
+
+
+Forwarded LPIs
+--------------
+LPIs, introduced in GICv3, are always edge-triggered and do not have an
+active state.  They become pending when a device signal them, and as
+soon as they are acked by the CPU, they are inactive again.
+
+It therefore doesn't make sense, and is not supported, to set the HW bit
+for physical LPIs that are forwarded to a VM as virtual interrupts,
+typically virtual SPIs.
+
+For LPIs, there is no other choice than to preempt the VCPU thread if
+necessary, and queue the pending state onto the LR.
+
+
+Putting It Together: The Architected Timer
+------------------------------------------
+The architected timer is a device that signals interrupts with level
+triggered semantics.  The timer hardware is directly accessed by VCPUs
+which program the timer to fire at some point in time.  Each VCPU on a
+system programs the timer to fire at different times, and therefore the
+hardware is multiplexed between multiple VCPUs.  This is implemented by
+context-switching the timer state along with each VCPU thread.
+
+However, this means that a scenario like the following is entirely
+possible, and in fact, typical:
+
+1.  KVM runs the VCPU
+2.  The guest programs the time to fire in T+100
+3.  The guest is idle and calls WFI (wait-for-interrupts)
+4.  The hardware traps to the host
+5.  KVM stores the timer state to memory and disables the hardware timer
+6.  KVM schedules a soft timer to fire in T+(100 - time since step 2)
+7.  KVM puts the VCPU thread to sleep (on a waitqueue)
+8.  The soft timer fires, waking up the VCPU thread
+9.  KVM reprograms the timer hardware with the VCPU's values
+10. KVM marks the timer interrupt as active on the physical distributor
+11. KVM injects a forwarded physical interrupt to the guest
+12. KVM runs the VCPU
+
+Notice that KVM injects a forwarded physical interrupt in step 11 without
+the corresponding interrupt having actually fired on the host.  That is
+exactly why we mark the timer interrupt as active in step 10, because
+the active state on the physical distributor is part of the state
+belonging to the timer hardware, which is context-switched along with
+the VCPU thread.
+
+If the guest does not idle because it is busy, flow looks like this
+instead:
+
+1.  KVM runs the VCPU
+2.  The guest programs the time to fire in T+100
+4.  At T+100 the timer fires and a physical IRQ causes the VM to exit
+    (note that this initially only traps to EL2 and does not run the host ISR
+    until KVM has returned to the host).
+5.  With interrupts still disabled on the CPU coming back from the guest, KVM
+    stores the virtual timer state to memory and disables the virtual hw timer.
+6.  KVM looks at the timer state (in memory) and injects a forwarded physical
+    interrupt because it concludes the timer has expired.
+7.  KVM marks the timer interrupt as active on the physical distributor
+7.  KVM enables the timer, enables interrupts, and runs the VCPU
+
+Notice that again the forwarded physical interrupt is injected to the
+guest without having actually been handled on the host.  In this case it
+is because the physical interrupt is never actually seen by the host because the
+timer is disabled upon guest return, and the virtual forwarded interrupt is
+injected on the KVM guest entry path.
-- 
2.1.2.330.g565301e.dirty
