From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v9 6/9] KVM: arm/arm64: Support VGIC dist pend/active changes
 for mapped IRQs
Date: Wed, 20 Dec 2017 12:36:03 +0100
Message-ID: <20171220113606.7030-7-christoffer.dall@linaro.org>
References: <20171220113606.7030-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4351349D6A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Dec 2017 06:32:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0hO81mP48AA8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Dec 2017 06:32:38 -0500 (EST)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E841049DAD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Dec 2017 06:32:37 -0500 (EST)
Received: by mail-wm0-f67.google.com with SMTP id b76so9195239wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Dec 2017 03:36:27 -0800 (PST)
In-Reply-To: <20171220113606.7030-1-christoffer.dall@linaro.org>
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

For mapped IRQs (with the HW bit set in the LR) we have to follow some
rules of the architecture.  One of these rules is that VM must not be
allowed to deactivate a virtual interrupt with the HW bit set unless the
physical interrupt is also active.

This works fine when injecting mapped interrupts, because we leave it up
to the injector to either set EOImode==1 or manually set the active
state of the physical interrupt.

However, the guest can set virtual interrupt to be pending or active by
writing to the virtual distributor, which could lead to deactivating a
virtual interrupt with the HW bit set without the physical interrupt
being active.

We could set the physical interrupt to active whenever we are about to
enter the VM with a HW interrupt either pending or active, but that
would be really slow, especially on GICv2.  So we take the long way
around and do the hard work when needed, which is expected to be
extremely rare.

When the VM sets the pending state for a HW interrupt on the virtual
distributor we set the active state on the physical distributor, because
the virtual interrupt can become active and then the guest can
deactivate it.

When the VM clears the pending state we also clear it on the physical
side, because the injector might otherwise raise the interrupt.  We also
clear the physical active state when the virtual interrupt is not
active, since otherwise a SPEND/CPEND sequence from the guest would
prevent signaling of future interrupts.

Changing the state of mapped interrupts from userspace is not supported,
and it's expected that userspace unmaps devices from VFIO before
attempting to set the interrupt state, because the interrupt state is
driven by hardware.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-mmio.c | 71 +++++++++++++++++++++++++++++++++++++++----
 virt/kvm/arm/vgic/vgic.c      |  7 +++++
 virt/kvm/arm/vgic/vgic.h      |  1 +
 3 files changed, 73 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index fdad95f62fa3..83d82bd7dc4e 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -16,6 +16,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <kvm/iodev.h>
+#include <kvm/arm_arch_timer.h>
 #include <kvm/arm_vgic.h>
 
 #include "vgic.h"
@@ -143,10 +144,22 @@ static struct kvm_vcpu *vgic_get_mmio_requester_vcpu(void)
 	return vcpu;
 }
 
+/* Must be called with irq->irq_lock held */
+static void vgic_hw_irq_spending(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
+				 bool is_uaccess)
+{
+	if (is_uaccess)
+		return;
+
+	irq->pending_latch = true;
+	vgic_irq_set_phys_active(irq, true);
+}
+
 void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 			      gpa_t addr, unsigned int len,
 			      unsigned long val)
 {
+	bool is_uaccess = !vgic_get_mmio_requester_vcpu();
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
 	unsigned long flags;
@@ -155,17 +168,45 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
 		spin_lock_irqsave(&irq->irq_lock, flags);
-		irq->pending_latch = true;
-
+		if (irq->hw)
+			vgic_hw_irq_spending(vcpu, irq, is_uaccess);
+		else
+			irq->pending_latch = true;
 		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
 
+/* Must be called with irq->irq_lock held */
+static void vgic_hw_irq_cpending(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
+				 bool is_uaccess)
+{
+	if (is_uaccess)
+		return;
+
+	irq->pending_latch = false;
+
+	/*
+	 * We don't want the guest to effectively mask the physical
+	 * interrupt by doing a write to SPENDR followed by a write to
+	 * CPENDR for HW interrupts, so we clear the active state on
+	 * the physical side if the virtual interrupt is not active.
+	 * This may lead to taking an additional interrupt on the
+	 * host, but that should not be a problem as the worst that
+	 * can happen is an additional vgic injection.  We also clear
+	 * the pending state to maintain proper semantics for edge HW
+	 * interrupts.
+	 */
+	vgic_irq_set_phys_pending(irq, false);
+	if (!irq->active)
+		vgic_irq_set_phys_active(irq, false);
+}
+
 void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 			      gpa_t addr, unsigned int len,
 			      unsigned long val)
 {
+	bool is_uaccess = !vgic_get_mmio_requester_vcpu();
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
 	unsigned long flags;
@@ -175,7 +216,10 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 
 		spin_lock_irqsave(&irq->irq_lock, flags);
 
-		irq->pending_latch = false;
+		if (irq->hw)
+			vgic_hw_irq_cpending(vcpu, irq, is_uaccess);
+		else
+			irq->pending_latch = false;
 
 		spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(vcpu->kvm, irq);
@@ -202,8 +246,19 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
 	return value;
 }
 
+/* Must be called with irq->irq_lock held */
+static void vgic_hw_irq_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
+				      bool active, bool is_uaccess)
+{
+	if (is_uaccess)
+		return;
+
+	irq->active = active;
+	vgic_irq_set_phys_active(irq, active);
+}
+
 static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
-				    bool new_active_state)
+				    bool active)
 {
 	unsigned long flags;
 	struct kvm_vcpu *requester_vcpu = vgic_get_mmio_requester_vcpu();
@@ -231,8 +286,12 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 	       irq->vcpu->cpu != -1) /* VCPU thread is running */
 		cond_resched_lock(&irq->irq_lock);
 
-	irq->active = new_active_state;
-	if (new_active_state)
+	if (irq->hw)
+		vgic_hw_irq_change_active(vcpu, irq, active, !requester_vcpu);
+	else
+		irq->active = active;
+
+	if (irq->active)
 		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 	else
 		spin_unlock_irqrestore(&irq->irq_lock, flags);
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index d57b3bf8eb36..c7c5ef190afa 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -144,6 +144,13 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 	kfree(irq);
 }
 
+void vgic_irq_set_phys_pending(struct vgic_irq *irq, bool pending)
+{
+	WARN_ON(irq_set_irqchip_state(irq->host_irq,
+				      IRQCHIP_STATE_PENDING,
+				      pending));
+}
+
 bool vgic_get_phys_line_level(struct vgic_irq *irq)
 {
 	bool line_level;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index d0787983a357..12c37b89f7a3 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -146,6 +146,7 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			      u32 intid);
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq);
 bool vgic_get_phys_line_level(struct vgic_irq *irq);
+void vgic_irq_set_phys_pending(struct vgic_irq *irq, bool pending);
 void vgic_irq_set_phys_active(struct vgic_irq *irq, bool active);
 bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 			   unsigned long flags);
-- 
2.14.2
