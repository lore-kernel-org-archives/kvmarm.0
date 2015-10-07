From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 12/16] KVM: arm64: handle pending bit for LPIs in ITS
 emulation
Date: Wed,  7 Oct 2015 15:55:22 +0100
Message-ID: <1444229726-31559-13-git-send-email-andre.przywara@arm.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22D19487E7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Oct 2015 10:52:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5bGgwicHXkX8 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Oct 2015 10:52:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20C5B487C5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Oct 2015 10:52:56 -0400 (EDT)
In-Reply-To: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

As the actual LPI number in a guest can be quite high, but is mostly
assigned using a very sparse allocation scheme, bitmaps and arrays
for storing the virtual interrupt status are a waste of memory.
We use our equivalent of the "Interrupt Translation Table Entry"
(ITTE) to hold this extra status information for a virtual LPI.
As the normal VGIC code cannot use its fancy bitmaps to manage
pending interrupts, we provide a hook in the VGIC code to let the
ITS emulation handle the list register queueing itself.
LPIs are located in a separate number range (>=8192), so
distinguishing them is easy. With LPIs being only edge-triggered, we
get away with a less complex IRQ handling.
We extend the number of bits for storing the IRQ number in our
LR struct to 16 to cover the LPI numbers we support as well.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Changelog v2..v3:
- extend LR data structure to hold 16-bit wide IRQ IDs
- only clear pending bit if IRQ could be queued
- adapt __kvm_vgic_sync_hwstate() to upstream changes

 include/kvm/arm_vgic.h      |  4 +-
 virt/kvm/arm/its-emul.c     | 75 ++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/its-emul.h     |  3 ++
 virt/kvm/arm/vgic-v3-emul.c |  2 +
 virt/kvm/arm/vgic.c         | 93 +++++++++++++++++++++++++++++++--------------
 5 files changed, 148 insertions(+), 29 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index c3eb414..035911f 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -95,7 +95,7 @@ enum vgic_type {
 #define LR_HW			(1 << 3)
 
 struct vgic_lr {
-	unsigned irq:10;
+	unsigned irq:16;
 	union {
 		unsigned hwirq:10;
 		unsigned source:3;
@@ -147,6 +147,8 @@ struct vgic_vm_ops {
 	int	(*init_model)(struct kvm *);
 	void	(*destroy_model)(struct kvm *);
 	int	(*map_resources)(struct kvm *, const struct vgic_params *);
+	bool	(*queue_lpis)(struct kvm_vcpu *);
+	void	(*unqueue_lpi)(struct kvm_vcpu *, int irq);
 };
 
 struct vgic_io_device {
diff --git a/virt/kvm/arm/its-emul.c b/virt/kvm/arm/its-emul.c
index bab8033..8349970 100644
--- a/virt/kvm/arm/its-emul.c
+++ b/virt/kvm/arm/its-emul.c
@@ -59,8 +59,27 @@ struct its_itte {
 	struct its_collection *collection;
 	u32 lpi;
 	u32 event_id;
+	bool enabled;
+	unsigned long *pending;
 };
 
+/* To be used as an iterator this macro misses the enclosing parentheses */
+#define for_each_lpi(dev, itte, kvm) \
+	list_for_each_entry(dev, &(kvm)->arch.vgic.its.device_list, dev_list) \
+		list_for_each_entry(itte, &(dev)->itt, itte_list)
+
+static struct its_itte *find_itte_by_lpi(struct kvm *kvm, int lpi)
+{
+	struct its_device *device;
+	struct its_itte *itte;
+
+	for_each_lpi(device, itte, kvm) {
+		if (itte->lpi == lpi)
+			return itte;
+	}
+	return NULL;
+}
+
 #define BASER_BASE_ADDRESS(x) ((x) & 0xfffffffff000ULL)
 
 /* The distributor lock is held by the VGIC MMIO handler. */
@@ -154,9 +173,65 @@ static bool handle_mmio_gits_idregs(struct kvm_vcpu *vcpu,
 	return false;
 }
 
+/*
+ * Find all enabled and pending LPIs and queue them into the list
+ * registers.
+ * The dist lock is held by the caller.
+ */
+bool vits_queue_lpis(struct kvm_vcpu *vcpu)
+{
+	struct vgic_its *its = &vcpu->kvm->arch.vgic.its;
+	struct its_device *device;
+	struct its_itte *itte;
+	bool ret = true;
+
+	if (!vgic_has_its(vcpu->kvm))
+		return true;
+	if (!its->enabled || !vcpu->kvm->arch.vgic.lpis_enabled)
+		return true;
+
+	spin_lock(&its->lock);
+	for_each_lpi(device, itte, vcpu->kvm) {
+		if (!itte->enabled || !test_bit(vcpu->vcpu_id, itte->pending))
+			continue;
+
+		if (!itte->collection)
+			continue;
+
+		if (itte->collection->target_addr != vcpu->vcpu_id)
+			continue;
+
+
+		if (vgic_queue_irq(vcpu, 0, itte->lpi))
+			__clear_bit(vcpu->vcpu_id, itte->pending);
+		else
+			ret = false;
+	}
+
+	spin_unlock(&its->lock);
+	return ret;
+}
+
+/* Called with the distributor lock held by the caller. */
+void vits_unqueue_lpi(struct kvm_vcpu *vcpu, int lpi)
+{
+	struct vgic_its *its = &vcpu->kvm->arch.vgic.its;
+	struct its_itte *itte;
+
+	spin_lock(&its->lock);
+
+	/* Find the right ITTE and put the pending state back in there */
+	itte = find_itte_by_lpi(vcpu->kvm, lpi);
+	if (itte)
+		__set_bit(vcpu->vcpu_id, itte->pending);
+
+	spin_unlock(&its->lock);
+}
+
 static void its_free_itte(struct its_itte *itte)
 {
 	list_del(&itte->itte_list);
+	kfree(itte->pending);
 	kfree(itte);
 }
 
diff --git a/virt/kvm/arm/its-emul.h b/virt/kvm/arm/its-emul.h
index 472a6d0..cc5d5ff 100644
--- a/virt/kvm/arm/its-emul.h
+++ b/virt/kvm/arm/its-emul.h
@@ -33,4 +33,7 @@ void vgic_enable_lpis(struct kvm_vcpu *vcpu);
 int vits_init(struct kvm *kvm);
 void vits_destroy(struct kvm *kvm);
 
+bool vits_queue_lpis(struct kvm_vcpu *vcpu);
+void vits_unqueue_lpi(struct kvm_vcpu *vcpu, int irq);
+
 #endif
diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
index e9aa29e..f482e34 100644
--- a/virt/kvm/arm/vgic-v3-emul.c
+++ b/virt/kvm/arm/vgic-v3-emul.c
@@ -944,6 +944,8 @@ void vgic_v3_init_emulation(struct kvm *kvm)
 	dist->vm_ops.init_model = vgic_v3_init_model;
 	dist->vm_ops.destroy_model = vgic_v3_destroy_model;
 	dist->vm_ops.map_resources = vgic_v3_map_resources;
+	dist->vm_ops.queue_lpis = vits_queue_lpis;
+	dist->vm_ops.unqueue_lpi = vits_unqueue_lpi;
 
 	dist->vgic_dist_base = VGIC_ADDR_UNDEF;
 	dist->vgic_redist_base = VGIC_ADDR_UNDEF;
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 11bf692..9ee87d3 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -120,6 +120,20 @@ static bool queue_sgi(struct kvm_vcpu *vcpu, int irq)
 	return vcpu->kvm->arch.vgic.vm_ops.queue_sgi(vcpu, irq);
 }
 
+static bool vgic_queue_lpis(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->kvm->arch.vgic.vm_ops.queue_lpis)
+		return vcpu->kvm->arch.vgic.vm_ops.queue_lpis(vcpu);
+	else
+		return true;
+}
+
+static void vgic_unqueue_lpi(struct kvm_vcpu *vcpu, int irq)
+{
+	if (vcpu->kvm->arch.vgic.vm_ops.unqueue_lpi)
+		vcpu->kvm->arch.vgic.vm_ops.unqueue_lpi(vcpu, irq);
+}
+
 int kvm_vgic_map_resources(struct kvm *kvm)
 {
 	return kvm->arch.vgic.vm_ops.map_resources(kvm, vgic);
@@ -1148,18 +1162,28 @@ static void vgic_retire_lr(int lr_nr, struct kvm_vcpu *vcpu)
 static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
 				 int lr_nr, struct vgic_lr vlr)
 {
-	if (vgic_irq_is_active(vcpu, irq)) {
-		vlr.state |= LR_STATE_ACTIVE;
-		kvm_debug("Set active, clear distributor: 0x%x\n", vlr.state);
-		vgic_irq_clear_active(vcpu, irq);
-		vgic_update_state(vcpu->kvm);
-	} else if (vgic_dist_irq_is_pending(vcpu, irq)) {
-		vlr.state |= LR_STATE_PENDING;
-		kvm_debug("Set pending: 0x%x\n", vlr.state);
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+
+	/* We care only about state for SGIs/PPIs/SPIs, not for LPIs */
+	if (irq < dist->nr_irqs) {
+		if (vgic_irq_is_active(vcpu, irq)) {
+			vlr.state |= LR_STATE_ACTIVE;
+			kvm_debug("Set active, clear distributor: 0x%x\n",
+				  vlr.state);
+			vgic_irq_clear_active(vcpu, irq);
+			vgic_update_state(vcpu->kvm);
+		} else if (vgic_dist_irq_is_pending(vcpu, irq)) {
+			vlr.state |= LR_STATE_PENDING;
+			kvm_debug("Set pending: 0x%x\n", vlr.state);
+		}
+		if (!vgic_irq_is_edge(vcpu, irq))
+			vlr.state |= LR_EOI_INT;
+	} else {
+		/* If this is an LPI, it can only be pending */
+		if (irq >= 8192)
+			vlr.state |= LR_STATE_PENDING;
 	}
 
-	if (!vgic_irq_is_edge(vcpu, irq))
-		vlr.state |= LR_EOI_INT;
 
 	if (vlr.irq >= VGIC_NR_SGIS) {
 		struct irq_phys_map *map;
@@ -1190,16 +1214,14 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
  */
 bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
 {
-	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
-	struct vgic_lr vlr;
 	u64 elrsr = vgic_get_elrsr(vcpu);
 	unsigned long *elrsr_ptr = u64_to_bitmask(&elrsr);
+	struct vgic_lr vlr;
 	int lr;
 
 	/* Sanitize the input... */
 	BUG_ON(sgi_source_id & ~7);
 	BUG_ON(sgi_source_id && irq >= VGIC_NR_SGIS);
-	BUG_ON(irq >= dist->nr_irqs);
 
 	kvm_debug("Queue IRQ%d\n", irq);
 
@@ -1282,8 +1304,12 @@ static void __kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 			overflow = 1;
 	}
 
-
-
+	/*
+	 * LPIs are not mapped in our bitmaps, so we leave the iteration
+	 * to the ITS emulation code.
+	 */
+	if (!vgic_queue_lpis(vcpu))
+		overflow = 1;
 
 epilog:
 	if (overflow) {
@@ -1488,20 +1514,30 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 		if (test_bit(lr, elrsr_ptr))
 			continue;
 
-		/* Reestablish SGI source for pending and active SGIs */
-		if (vlr.irq < VGIC_NR_SGIS)
-			add_sgi_source(vcpu, vlr.irq, vlr.source);
-
-		if (vlr.state & LR_STATE_PENDING)
-			vgic_dist_irq_set_pending(vcpu, vlr.irq);
-
-		if (vlr.state & LR_STATE_ACTIVE) {
-			if (vlr.state & LR_STATE_PENDING) {
-				vgic_irq_set_active(vcpu, vlr.irq);
-			} else {
-				/* Active-only IRQs stay in the LR */
-				pending = true;
+		/* LPIs are handled separately */
+		if (vlr.irq >= 8192) {
+			/* We just need to take care about still pending LPIs */
+			if (!(vlr.state & LR_STATE_PENDING))
 				continue;
+			vgic_unqueue_lpi(vcpu, vlr.irq);
+		} else {
+			BUG_ON(!(vlr.state & LR_STATE_MASK));
+
+			/* Reestablish SGI source for pending and active SGIs */
+			if (vlr.irq < VGIC_NR_SGIS)
+				add_sgi_source(vcpu, vlr.irq, vlr.source);
+
+			if (vlr.state & LR_STATE_PENDING)
+				vgic_dist_irq_set_pending(vcpu, vlr.irq);
+
+			if (vlr.state & LR_STATE_ACTIVE) {
+				if (vlr.state & LR_STATE_PENDING) {
+					vgic_irq_set_active(vcpu, vlr.irq);
+				} else {
+					/* Active-only IRQs stay in the LR */
+					pending = true;
+					continue;
+				}
 			}
 		}
 
@@ -1512,6 +1548,7 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 	}
 	vgic_update_state(vcpu->kvm);
 
+	/* vgic_update_state would not cover only-active IRQs or LPIs */
 	if (pending)
 		set_bit(vcpu->vcpu_id, dist->irq_pending_on_cpu);
 	spin_unlock(&dist->lock);
-- 
2.5.1
