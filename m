From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 1/2] KVM: ARM: Properly protect VGIC locks from IRQs
Date: Fri,  4 May 2018 18:19:44 +0100
Message-ID: <20180504171945.22118-1-andre.przywara@arm.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, Jan Glauber <jan.glauber@caviumnetworks.com>
List-Id: kvmarm@lists.cs.columbia.edu

As Jan reported [1], lockdep complains about the VGIC not being bullet
proof. This seems to be due to two issues:
- When commit 006df0f34930 ("KVM: arm/arm64: Support calling
  vgic_update_irq_pending from irq context") promoted irq_lock and
  ap_list_lock to _irqsave, we forgot two instances of irq_lock.
  lockdeps seems to pick those up.
- If a lock is _irqsave, any other locks we take inside them should be
  _irqsafe as well. So the lpi_list_lock needs to be promoted also.

This fixes both issues by simply making the remaining instances of those
locks _irqsave.
One irq_lock is addressed in a separate patch, to simplify backporting.

Cc: stable@vger.kernel.org
Fixes: 006df0f34930 ("KVM: arm/arm64: Support calling vgic_update_irq_pending from irq context")
Reported-by: Jan Glauber <jan.glauber@caviumnetworks.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2018-May/575718.html
---
 virt/kvm/arm/vgic/vgic-debug.c |  5 +++--
 virt/kvm/arm/vgic/vgic-its.c   | 10 ++++++----
 virt/kvm/arm/vgic/vgic.c       | 22 ++++++++++++++--------
 3 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-debug.c b/virt/kvm/arm/vgic/vgic-debug.c
index 10b38178cff2..4ffc0b5e6105 100644
--- a/virt/kvm/arm/vgic/vgic-debug.c
+++ b/virt/kvm/arm/vgic/vgic-debug.c
@@ -211,6 +211,7 @@ static int vgic_debug_show(struct seq_file *s, void *v)
 	struct vgic_state_iter *iter = (struct vgic_state_iter *)v;
 	struct vgic_irq *irq;
 	struct kvm_vcpu *vcpu = NULL;
+	unsigned long flags;
 
 	if (iter->dist_id == 0) {
 		print_dist_state(s, &kvm->arch.vgic);
@@ -227,9 +228,9 @@ static int vgic_debug_show(struct seq_file *s, void *v)
 		irq = &kvm->arch.vgic.spis[iter->intid - VGIC_NR_PRIVATE_IRQS];
 	}
 
-	spin_lock(&irq->irq_lock);
+	spin_lock_irqsave(&irq->irq_lock, flags);
 	print_irq_state(s, irq, vcpu);
-	spin_unlock(&irq->irq_lock);
+	spin_unlock_irqrestore(&irq->irq_lock, flags);
 
 	return 0;
 }
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index a8f07243aa9f..41abf92f2699 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -52,6 +52,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_irq *irq = vgic_get_irq(kvm, NULL, intid), *oldirq;
+	unsigned long flags;
 	int ret;
 
 	/* In this case there is no put, since we keep the reference. */
@@ -71,7 +72,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	irq->intid = intid;
 	irq->target_vcpu = vcpu;
 
-	spin_lock(&dist->lpi_list_lock);
+	spin_lock_irqsave(&dist->lpi_list_lock, flags);
 
 	/*
 	 * There could be a race with another vgic_add_lpi(), so we need to
@@ -99,7 +100,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	dist->lpi_list_count++;
 
 out_unlock:
-	spin_unlock(&dist->lpi_list_lock);
+	spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 
 	/*
 	 * We "cache" the configuration table entries in our struct vgic_irq's.
@@ -315,6 +316,7 @@ static int vgic_copy_lpi_list(struct kvm_vcpu *vcpu, u32 **intid_ptr)
 {
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	struct vgic_irq *irq;
+	unsigned long flags;
 	u32 *intids;
 	int irq_count, i = 0;
 
@@ -330,7 +332,7 @@ static int vgic_copy_lpi_list(struct kvm_vcpu *vcpu, u32 **intid_ptr)
 	if (!intids)
 		return -ENOMEM;
 
-	spin_lock(&dist->lpi_list_lock);
+	spin_lock_irqsave(&dist->lpi_list_lock, flags);
 	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
 		if (i == irq_count)
 			break;
@@ -339,7 +341,7 @@ static int vgic_copy_lpi_list(struct kvm_vcpu *vcpu, u32 **intid_ptr)
 			continue;
 		intids[i++] = irq->intid;
 	}
-	spin_unlock(&dist->lpi_list_lock);
+	spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 
 	*intid_ptr = intids;
 	return i;
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index c62ecca24579..f7dc2347395b 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -43,9 +43,13 @@ struct vgic_global kvm_vgic_global_state __ro_after_init = {
  * kvm->lock (mutex)
  *   its->cmd_lock (mutex)
  *     its->its_lock (mutex)
- *       vgic_cpu->ap_list_lock
- *         kvm->lpi_list_lock
- *           vgic_irq->irq_lock
+ *       vgic_cpu->ap_list_lock		must be taken with IRQs disabled
+ *         kvm->lpi_list_lock		must be taken with IRQs disabled
+ *           vgic_irq->irq_lock		must be taken with IRQs disabled
+ *
+ * As the ap_list_lock might be taken from the timer interrupt handler,
+ * we have to disable IRQs before taking this lock and everything lower
+ * than it.
  *
  * If you need to take multiple locks, always take the upper lock first,
  * then the lower ones, e.g. first take the its_lock, then the irq_lock.
@@ -72,8 +76,9 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u32 intid)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_irq *irq = NULL;
+	unsigned long flags;
 
-	spin_lock(&dist->lpi_list_lock);
+	spin_lock_irqsave(&dist->lpi_list_lock, flags);
 
 	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
 		if (irq->intid != intid)
@@ -89,7 +94,7 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u32 intid)
 	irq = NULL;
 
 out_unlock:
-	spin_unlock(&dist->lpi_list_lock);
+	spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 
 	return irq;
 }
@@ -134,19 +139,20 @@ static void vgic_irq_release(struct kref *ref)
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
+	unsigned long flags;
 
 	if (irq->intid < VGIC_MIN_LPI)
 		return;
 
-	spin_lock(&dist->lpi_list_lock);
+	spin_lock_irqsave(&dist->lpi_list_lock, flags);
 	if (!kref_put(&irq->refcount, vgic_irq_release)) {
-		spin_unlock(&dist->lpi_list_lock);
+		spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 		return;
 	};
 
 	list_del(&irq->lpi_list);
 	dist->lpi_list_count--;
-	spin_unlock(&dist->lpi_list_lock);
+	spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 
 	kfree(irq);
 }
-- 
2.14.1
