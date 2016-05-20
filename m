From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH] KVM: arm/arm64: vgic-new: Synchronize changes to active state
Date: Fri, 20 May 2016 15:30:27 +0200
Message-ID: <1463751027-17517-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83B3648531
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2016 09:26:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O9G04W1yTlNV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 May 2016 09:26:20 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 53BFB412A6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2016 09:26:19 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id n129so272099413wmn.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2016 06:29:42 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

When modifying the active state of an interrupt via the MMIO interface,
we should ensure that the write has the intended effect.

If a guest sets an interrupt to active, but that interrupt is already
flushed into a list register on a running VCPU, then that VCPU will
write the active state back into the struct vgic_irq upon returning from
the guest and syncing its state.  This is a non-benign race, because the
guest can observe that an interrupt is not active, and it can have a
reasonable expectations that other VCPUs will not ack any IRQs, and then
set the state to active, and expect it to stay that way.  Currently we
are not honoring this case.

Thefore, change both the SACTIVE and CACTIVE mmio handlers to stop the
world, change the irq state, potentially queue the irq if we're setting
it to active, and then continue.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-mmio.c | 69 ++++++++++++++++++++-----------------------
 1 file changed, 32 insertions(+), 37 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 4ef3571..90b0dc4 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -173,6 +173,34 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
 	return value;
 }
 
+static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
+				    bool new_active_state)
+{
+	spin_lock(&irq->irq_lock);
+	/*
+	 * If this virtual IRQ was written into a list register, we
+	 * have to make sure the CPU that runs the VCPU thread has
+	 * synced back LR state to the struct vgic_irq.  We can only
+	 * know this for sure, when either this irq is not assigned to
+	 * anyone's AP list anymore, or the VCPU thread is not
+	 * running on any CPUs.
+	 *
+	 * In the opposite case, we know the VCPU thread may be on its
+	 * way back from the guest and still has to sync back this
+	 * IRQ, so we release and re-acquire the spin_lock to let the
+	 * other thread sync back the IRQ.
+	 */
+	while (irq->vcpu && /* IRQ may have state in an LR somewhere */
+	       irq->vcpu->cpu != -1) /* VCPU thread is running */
+		cond_resched_lock(&irq->irq_lock);
+
+	irq->active = new_active_state;
+	if (new_active_state)
+		vgic_queue_irq_unlock(vcpu->kvm, irq);
+	else
+		spin_unlock(&irq->irq_lock);
+}
+
 void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
 			     gpa_t addr, unsigned int len,
 			     unsigned long val)
@@ -183,27 +211,7 @@ void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
 	kvm_arm_halt_guest(vcpu->kvm);
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
-
-		spin_lock(&irq->irq_lock);
-		/*
-		 * If this virtual IRQ was written into a list register, we
-		 * have to make sure the CPU that runs the VCPU thread has
-		 * synced back LR state to the struct vgic_irq.  We can only
-		 * know this for sure, when either this irq is not assigned to
-		 * anyone's AP list anymore, or the VCPU thread is not
-		 * running on any CPUs.
-		 *
-		 * In the opposite case, we know the VCPU thread may be on its
-		 * way back from the guest and still has to sync back this
-		 * IRQ, so we release and re-acquire the spin_lock to let the
-		 * other thread sync back the IRQ.
-		 */
-		while (irq->vcpu && /* IRQ may have state in an LR somewhere */
-		       irq->vcpu->cpu != -1) /* VCPU thread is running */
-			cond_resched_lock(&irq->irq_lock);
-
-		irq->active = false;
-		spin_unlock(&irq->irq_lock);
+		vgic_mmio_change_active(vcpu, irq, false);
 	}
 	kvm_arm_resume_guest(vcpu->kvm);
 }
@@ -215,25 +223,12 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
 
+	kvm_arm_halt_guest(vcpu->kvm);
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
-
-		spin_lock(&irq->irq_lock);
-
-		/*
-		 * If the IRQ was already active or there is no target VCPU
-		 * assigned at the moment, then just proceed.
-		 */
-		if (irq->active || !irq->target_vcpu) {
-			irq->active = true;
-
-			spin_unlock(&irq->irq_lock);
-			continue;
-		}
-
-		irq->active = true;
-		vgic_queue_irq_unlock(vcpu->kvm, irq);
+		vgic_mmio_change_active(vcpu, irq, true);
 	}
+	kvm_arm_resume_guest(vcpu->kvm);
 }
 
 unsigned long vgic_mmio_read_priority(struct kvm_vcpu *vcpu,
-- 
2.1.2.330.g565301e.dirty
