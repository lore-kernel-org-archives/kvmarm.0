From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v8 9/9] KVM: arm/arm64: Update timer and forwarded irq
 documentation
Date: Wed, 13 Dec 2017 11:46:02 +0100
Message-ID: <20171213104602.16383-10-christoffer.dall@linaro.org>
References: <20171213104602.16383-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C9A040795
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Dec 2017 05:43:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CqrVbuZrLiio for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Dec 2017 05:43:18 -0500 (EST)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 345B349DB2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Dec 2017 05:43:18 -0500 (EST)
Received: by mail-wm0-f67.google.com with SMTP id g130so21259731wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Dec 2017 02:46:49 -0800 (PST)
In-Reply-To: <20171213104602.16383-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Now when we've reworked how mapped level-triggered interrupts are
processed for the timer interrupts, we update the documentation
correspondingly.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt | 50 ++++++++++------------
 1 file changed, 23 insertions(+), 27 deletions(-)

diff --git a/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt b/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
index 38bca2835278..f68c7d95a341 100644
--- a/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
+++ b/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
@@ -7,9 +7,10 @@ allowing software to inject virtual interrupts to a VM, which the guest
 OS sees as regular interrupts.  The code is famously known as the VGIC.
 
 Some of these virtual interrupts, however, correspond to physical
-interrupts from real physical devices.  One example could be the
-architected timer, which itself supports virtualization, and therefore
-lets a guest OS program the hardware device directly to raise an
+interrupts from real physical devices.  One example could be the ARM
+Generic Timers (also known as the "architected timers"), which are
+directly assigned to a VM while it's running, and therefore
+makes it possible for guest OSes to program the timers directly to raise an
 interrupt at some point in time.  When such an interrupt is raised, the
 host OS initially handles the interrupt and must somehow signal this
 event as a virtual interrupt to the guest.  Another example could be a
@@ -37,7 +38,7 @@ inactive.
 
 The LRs include an extra bit, called the HW bit.  When this bit is set,
 KVM must also program an additional field in the LR, the physical IRQ
-number, to link the virtual with the physical IRQ.
+number, to link the virtual and physical IRQs together.
 
 When the HW bit is set, KVM must EITHER set the Pending OR the Active
 bit, never both at the same time.
@@ -59,21 +60,21 @@ The state of forwarded physical interrupts is managed in the following way:
   - LR.Pending will stay set as long as the guest has not acked the interrupt.
   - LR.Pending transitions to LR.Active on the guest read of the IAR, as
     expected.
-  - On guest EOI, the *physical distributor* active bit gets cleared,
+  - On guest deactivate, the *physical distributor* active bit gets cleared,
     but the LR.Active is left untouched (set).
   - KVM clears the LR on VM exits when the physical distributor
     active state has been cleared.
 
 (*): The host handling is slightly more complicated.  For some forwarded
-interrupts (shared), KVM directly sets the active state on the physical
-distributor before entering the guest, because the interrupt is never actually
-handled on the host (see details on the timer as an example below).  For other
-forwarded interrupts (non-shared) the host does not deactivate the interrupt
-when the host ISR completes, but leaves the interrupt active until the guest
-deactivates it.  Leaving the interrupt active is allowed, because Linux
-configures the physical GIC with EOIMode=1, which causes EOI operations to
-perform a priority drop allowing the GIC to receive other interrupts of the
-default priority.
+interrupts (shared), in some cases, KVM directly sets the active state
+on the physical distributor before entering the guest, because the
+interrupt is never actually handled on the host (see details on the
+timer as an example below).  In other cases, the host does not
+deactivate the interrupt when the host ISR completes, but leaves the
+interrupt active until the guest deactivates it.  Leaving the interrupt
+active is allowed, because Linux configures the physical GIC with
+EOIMode=1, which causes EOI operations to perform a priority drop
+allowing the GIC to receive other interrupts of the default priority.
 
 
 Forwarded Edge and Level Triggered PPIs and SPIs
@@ -170,18 +171,13 @@ instead:
 
 1.  KVM runs the VCPU
 2.  The guest programs the time to fire in T+100
-4.  At T+100 the timer fires and a physical IRQ causes the VM to exit
+3.  At T+100 the timer fires and a physical IRQ causes the VM to exit
     (note that this initially only traps to EL2 and does not run the host ISR
     until KVM has returned to the host).
-5.  With interrupts still disabled on the CPU coming back from the guest, KVM
-    stores the virtual timer state to memory and disables the virtual hw timer.
-6.  KVM looks at the timer state (in memory) and injects a forwarded physical
-    interrupt because it concludes the timer has expired.
-7.  KVM marks the timer interrupt as active on the physical distributor
-7.  KVM enables the timer, enables interrupts, and runs the VCPU
-
-Notice that again the forwarded physical interrupt is injected to the
-guest without having actually been handled on the host.  In this case it
-is because the physical interrupt is never actually seen by the host because the
-timer is disabled upon guest return, and the virtual forwarded interrupt is
-injected on the KVM guest entry path.
+4.  When KVM returns to EL1 and enables interrupts, the timer interrupt
+    fires again, and the kvm arch timer ISR runs and injects a virtual
+    interrupt to the guest.
+5.  Because the timer interrupt has the vcpu affinity set, as the ISR
+    completes, the physical interrupt stays active on the physical
+    distributor.
+6.  KVM enables the timer, enables interrupts, and runs the VCPU
-- 
2.14.2
