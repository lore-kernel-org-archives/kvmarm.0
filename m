From: Andre Przywara <andre.przywara@arm.com>
Subject: [RFC PATCH 06/45] KVM: arm/arm64: vgic-new: Implement virtual IRQ
 injection
Date: Fri, 25 Mar 2016 02:04:29 +0000
Message-ID: <1458871508-17279-7-git-send-email-andre.przywara@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CEA249B2E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:04:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N39jSdzkgZBN for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2016 22:04:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FBF741AF6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:04:34 -0400 (EDT)
In-Reply-To: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Provide a vgic_queue_irq() function which decides whether a given
IRQ needs to be queued to a VCPU's ap_list.
This should be called whenever an IRQ became pending or got enabled,
either as a result of userspace injection, from in-kernel emulated
devices like the architected timer or from MMIO accesses to the
distributor emulation.
Also provides the necessary functions to allow userland to inject an
IRQ to a guest.
[Andre: refactor out vgic_queue_irq()]

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/vgic/vgic.h  |   3 +
 virt/kvm/arm/vgic/vgic.c | 181 +++++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h |   1 +
 3 files changed, 185 insertions(+)

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index 659f8b1..f32b284 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -178,6 +178,9 @@ struct vgic_cpu {
 	struct list_head ap_list_head;
 };
 
+int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
+			bool level);
+
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	(false)
 #define vgic_ready(k)		((k)->arch.vgic.ready)
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 8e34916..a95aabc 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -19,8 +19,25 @@
 
 #include "vgic.h"
 
+#define CREATE_TRACE_POINTS
+#include "../trace.h"
+
 struct vgic_global kvm_vgic_global_state;
 
+/*
+ * Locking order is always:
+ *   vgic_cpu->ap_list_lock
+ *     vgic_irq->irq_lock
+ *
+ * (that is, always take the ap_list_lock before the struct vgic_irq lock).
+ *
+ * When taking more than one ap_list_lock at the same time, always take the
+ * lowest numbered VCPU's ap_list_lock first, so:
+ *   vcpuX->vcpu_id < vcpuY->vcpu_id:
+ *     spin_lock(vcpuX->arch.vgic_cpu.ap_list_lock);
+ *     spin_lock(vcpuY->arch.vgic_cpu.ap_list_lock);
+ */
+
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			      u32 intid)
 {
@@ -39,3 +56,167 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	WARN(1, "Looking up struct vgic_irq for reserved INTID");
 	return NULL;
 }
+
+/**
+ * kvm_vgic_target_oracle - compute the target vcpu for an irq
+ *
+ * @irq:	The irq to route. Must be already locked.
+ *
+ * Based on the current state of the interrupt (enabled, pending,
+ * active, vcpu and target_vcpu), compute the next vcpu this should be
+ * given to. Return NULL if this shouldn't be injected at all.
+ */
+static struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
+{
+	/* If the interrupt is active, it must stay on the current vcpu */
+	if (irq->active)
+		return irq->vcpu;
+
+	/* If enabled and pending, it can migrate to a new one */
+	if (irq->enabled && irq->pending)
+		return irq->target_vcpu;
+
+	/* Otherwise, it is considered idle */
+	return NULL;
+}
+
+/*
+ * Only valid injection if changing level for level-triggered IRQs or for a
+ * rising edge.
+ */
+static bool vgic_validate_injection(struct vgic_irq *irq, bool level)
+{
+	switch (irq->config) {
+	case VGIC_CONFIG_LEVEL:
+		return irq->line_level != level;
+	case VGIC_CONFIG_EDGE:
+		return level;
+	default:
+		BUG();
+	}
+}
+
+/*
+ * Check whether an IRQ needs to (and can) be queued to a VCPU's ap list.
+ * Do the queuing if necessary, taking the right locks in the right order.
+ * Returns true when the IRQ was queued, false otherwise.
+ *
+ * Needs to be entered with the IRQ lock already held, but will return
+ * with all locks dropped.
+ */
+bool vgic_queue_irq(struct kvm *kvm, struct vgic_irq *irq)
+{
+	struct kvm_vcpu *vcpu = vgic_target_oracle(irq);
+
+	if (irq->vcpu || !(irq->pending && irq->enabled) || !vcpu) {
+		/*
+		 * If this IRQ is already on a VCPU's ap_list, then it
+		 * cannot be moved or modified and there is no more work for
+		 * us to do.
+		 *
+		 * Otherwise, if the irq is not pending and enabled, it does
+		 * not need to be inserted into an ap_list and there is also
+		 * no more work for us to do.
+		 */
+		spin_unlock(&irq->irq_lock);
+		return false;
+	}
+
+	/*
+	 * We must unlock the irq lock to take the ap_list_lock where
+	 * we are going to insert this new pending interrupt.
+	 */
+	spin_unlock(&irq->irq_lock);
+
+	/* someone can do stuff here, which we re-check below */
+retry:
+	spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
+	spin_lock(&irq->irq_lock);
+
+	/*
+	 * Did something change behind our backs?
+	 *
+	 * There are two cases:
+	 * 1) The irq became pending or active behind our backs and/or
+	 *    the irq->vcpu field was set correspondingly when putting
+	 *    the irq on an ap_list. Then drop the locks and return.
+	 * 2) Someone changed the affinity on this irq behind our
+	 *    backs and we are now holding the wrong ap_list_lock.
+	 *    Then drop the locks and try the new VCPU.
+	 */
+	if (irq->vcpu || !(irq->pending && irq->enabled)) {
+		spin_unlock(&irq->irq_lock);
+		spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
+		return false;
+	}
+
+	if (irq->target_vcpu != vcpu) {
+		spin_unlock(&irq->irq_lock);
+		spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
+
+		vcpu = irq->target_vcpu;
+		goto retry;
+	}
+
+	list_add_tail(&irq->ap_list, &vcpu->arch.vgic_cpu.ap_list_head);
+	irq->vcpu = vcpu;
+
+	spin_unlock(&irq->irq_lock);
+	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
+
+	kvm_vcpu_kick(vcpu);
+
+	return true;
+}
+
+static void vgic_update_irq_pending(struct kvm *kvm, struct kvm_vcpu *vcpu,
+				    u32 intid, bool level)
+{
+	struct vgic_irq *irq = vgic_get_irq(kvm, vcpu, intid);
+
+	trace_vgic_update_irq_pending(vcpu->vcpu_id, intid, level);
+
+	BUG_ON(in_interrupt());
+
+	spin_lock(&irq->irq_lock);
+
+	if (!vgic_validate_injection(irq, level)) {
+		/* Nothing to see here, move along... */
+		spin_unlock(&irq->irq_lock);
+		return;
+	}
+
+	if (irq->config == VGIC_CONFIG_LEVEL) {
+		irq->line_level = level;
+		irq->pending = level || irq->soft_pending;
+	} else {
+		irq->pending = true;
+	}
+
+	vgic_queue_irq(kvm, irq);
+}
+
+/**
+ * kvm_vgic_inject_irq - Inject an IRQ from a device to the vgic
+ * @kvm:     The VM structure pointer
+ * @cpuid:   The CPU for PPIs
+ * @intid:   The INTID to inject a new state to.
+ *           must not be mapped to a HW interrupt.
+ * @level:   Edge-triggered:  true:  to trigger the interrupt
+ *			      false: to ignore the call
+ *	     Level-sensitive  true:  raise the input signal
+ *			      false: lower the input signal
+ *
+ * The GIC is not concerned with devices being active-LOW or active-HIGH for
+ * level-sensitive interrupts.  You can think of the level parameter as 1
+ * being HIGH and 0 being LOW and all devices being active-HIGH.
+ */
+int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
+			bool level)
+{
+	struct kvm_vcpu *vcpu;
+
+	vcpu = kvm_get_vcpu(kvm, cpuid);
+	vgic_update_irq_pending(kvm, vcpu, intid, level);
+	return 0;
+}
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 61b8d22..e9f4aa6 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -18,5 +18,6 @@
 
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			      u32 intid);
+bool vgic_queue_irq(struct kvm *kvm, struct vgic_irq *irq);
 
 #endif
-- 
2.7.3
