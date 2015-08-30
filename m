From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 6/9] arm/arm64: KVM: Add mapped interrupts documentation
Date: Sun, 30 Aug 2015 15:54:23 +0200
Message-ID: <1440942866-23802-7-git-send-email-christoffer.dall@linaro.org>
References: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Mapped interrupts on arm/arm64 is a tricky concept and the way we deal
with them is not apparently easy to understand by reading various specs.

Therefore, add a proper documentation file explaining the flow and
rationale of the behavior of the vgic.

Some of this text was contributed by Marc Zyngier.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt | 59 ++++++++++++++++++++++
 1 file changed, 59 insertions(+)
 create mode 100644 Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt

diff --git a/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt b/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
new file mode 100644
index 0000000..49e1357
--- /dev/null
+++ b/Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
@@ -0,0 +1,59 @@
+KVM/ARM VGIC Mapped Interrupts
+==============================
+
+Setting the Physical Active State for Edge vs. Level Triggered IRQs
+-------------------------------------------------------------------
+
+Mapped non-shared interrupts injected to a guest should always mark the
+interrupt as active on the physical distributor.
+
+The reasoning for level-triggered interrupts:
+For level-triggered interrupts, we have to mark the interrupt as active
+on the physical distributor, because otherwise, as the line remains
+asserted, the guest will never execute because the host will keep taking
+interrupts.  As soon as the guest deactivates the interrupt, the
+physical line is sampled by the hardware again and the host takes a new
+interrupt if the physical line is still asserted.
+
+The reasoning for edge-triggered interrupts:
+For edge-triggered interrupts, if we set the HW bit in the LR we also
+have to mark the interrupt as active on the physical distributor.  If we
+don't set the physical active bit and the interrupt hits again before
+the guest has deactivated the interrupt, the interrupt goes to the host,
+which cannot set the state to ACTIVE+PENDING in the LR, because that is
+not supported when setting the HW bit in the LR.
+
+An alternative could be to not use HW bit at all, and inject
+edge-triggered interrupts from a physical assigned device as pure
+virtual interrupts, but that would potentially slow down handling of the
+interrupt in the guest, because a physical interrupt occurring in the
+middle of the guest ISR would preempt the guest for the host to handle
+the interrupt.
+
+
+Life Cycle for Forwarded Physical Interrupts
+--------------------------------------------
+
+By forwarded physical interrupts we mean interrupts presented to a guest
+representing a real HW event originally signaled to the host as a
+physical interrupt and injecting this as a virtual interrupt with the HW
+bit set in the LR.
+
+The state of such an interrupt is managed in the following way:
+
+  - LR.Pending must be set when the interrupt is first injected, because this
+    is the only way the GICV interface is going to present it to the guest.
+  - LR.Pending will stay set as long as the guest has not acked the interrupt.
+  - LR.Pending transitions to LR.Active on read of IAR, as expected.
+  - On EOI, the *physical distributor* active bit gets cleared, but the
+    LR.Active is left untouched - it looks like the GIC can only clear a
+    single bit (either the virtual active, or the physical one).
+  - This means we cannot trust LR.Active to find out about the state of the
+    interrupt, and we definitely need to look at the distributor version.
+
+Consequently, when we context switch the state of a VCPU with forwarded
+physical interrupts, we must context switch set pending *or* active bits in the
+LR for that VCPU until the guest has deactivated the physical interrupt, and
+then clear the corresponding bits in the LR.  If we ever set an LR to pending or
+mapped when switching in a VCPU for a forwarded physical interrupt, we must also
+set the active state on the *physical distributor*.
-- 
2.1.2.330.g565301e.dirty

