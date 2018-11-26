From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH v2 1/4] KVM: arm/arm64: vgic: Do not cond_resched_lock() with IRQs disabled
Date: Mon, 26 Nov 2018 18:26:44 +0000
Message-ID: <1543256807-9768-2-git-send-email-julien.thierry@arm.com>
References: <1543256807-9768-1-git-send-email-julien.thierry@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1543256807-9768-1-git-send-email-julien.thierry@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, Christoffer.Dall@arm.com, linux-arm-kernel@lists.infradead.org, linux-rt-users@vger.kernel.org, tglx@linutronix.de, rostedt@goodmis.org, bigeasy@linutronix.de, Julien Thierry <julien.thierry@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

To change the active state of an MMIO, halt is requested for all vcpus of
the affected guest before modifying the IRQ state. This is done by calling
cond_resched_lock() in vgic_mmio_change_active(). However interrupts are
disabled at this point and we cannot reschedule a vcpu.

Solve this by waiting for all vcpus to be halted after emmiting the halt
request.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Suggested-by: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: stable@vger.kernel.org
---
 virt/kvm/arm/vgic/vgic-mmio.c | 36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index f56ff1c..5c76a92 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -313,27 +313,6 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 
 	spin_lock_irqsave(&irq->irq_lock, flags);
 
-	/*
-	 * If this virtual IRQ was written into a list register, we
-	 * have to make sure the CPU that runs the VCPU thread has
-	 * synced back the LR state to the struct vgic_irq.
-	 *
-	 * As long as the conditions below are true, we know the VCPU thread
-	 * may be on its way back from the guest (we kicked the VCPU thread in
-	 * vgic_change_active_prepare)  and still has to sync back this IRQ,
-	 * so we release and re-acquire the spin_lock to let the other thread
-	 * sync back the IRQ.
-	 *
-	 * When accessing VGIC state from user space, requester_vcpu is
-	 * NULL, which is fine, because we guarantee that no VCPUs are running
-	 * when accessing VGIC state from user space so irq->vcpu->cpu is
-	 * always -1.
-	 */
-	while (irq->vcpu && /* IRQ may have state in an LR somewhere */
-	       irq->vcpu != requester_vcpu && /* Current thread is not the VCPU thread */
-	       irq->vcpu->cpu != -1) /* VCPU thread is running */
-		cond_resched_lock(&irq->irq_lock);
-
 	if (irq->hw) {
 		vgic_hw_irq_change_active(vcpu, irq, active, !requester_vcpu);
 	} else {
@@ -368,8 +347,21 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
  */
 static void vgic_change_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
 {
-	if (intid > VGIC_NR_PRIVATE_IRQS)
+	if (intid > VGIC_NR_PRIVATE_IRQS) {
+		struct kvm_vcpu *tmp;
+		int i;
+
 		kvm_arm_halt_guest(vcpu->kvm);
+
+		/* Wait for each vcpu to be halted */
+		kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
+			if (tmp == vcpu)
+				continue;
+
+			while (tmp->cpu != -1)
+				cond_resched();
+		}
+	}
 }
 
 /* See vgic_change_active_prepare */
-- 
1.9.1
