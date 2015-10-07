From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 01/16] KVM: arm/arm64: VGIC: don't track used LRs in the distributor
Date: Wed,  7 Oct 2015 15:55:11 +0100
Message-ID: <1444229726-31559-2-git-send-email-andre.przywara@arm.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: eric.auger@linaro.org, p.fedin@samsung.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Currently we track which IRQ has been mapped to which VGIC list
register and also have to synchronize both. We used to do this
to hold some extra state (for instance the active bit).
It turns out that this extra state in the LRs is no longer needed and
this extra tracking causes some pain later.
Remove the tracking feature (lr_map and lr_used) and get rid of
quite some code on the way.
In places where we scan LRs we now use our shadow copy of the ELRSR
register directly.
This code change means we lose the "piggy-back" optimization, which
would re-use an active-only LR to inject the pending state on top of
it. Tracing with various workloads shows that this actually occurred
very rarely, the ballpark figure is about once every 10,000 exits
in a disk I/O heavy workload. Also the list registers don't seem to
as scarce as assumed, with all 4 LRs on the popular implementations
used less than once every 100,000 exits.

This has been briefly tested on Midway, Juno and the model (the latter
both with GICv2 and GICv3 guests).

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Changelog v2..v3:
- adapt to 4.3-rc
- keep, but change retire_lr to drop now unused parameter

 include/kvm/arm_vgic.h |   6 ---
 virt/kvm/arm/vgic-v2.c |   1 +
 virt/kvm/arm/vgic-v3.c |   1 +
 virt/kvm/arm/vgic.c    | 137 +++++++++++++++++++++----------------------------
 4 files changed, 61 insertions(+), 84 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 7bc5d02..926d67c 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -295,9 +295,6 @@ struct vgic_v3_cpu_if {
 };
 
 struct vgic_cpu {
-	/* per IRQ to LR mapping */
-	u8		*vgic_irq_lr_map;
-
 	/* Pending/active/both interrupts on this VCPU */
 	DECLARE_BITMAP(	pending_percpu, VGIC_NR_PRIVATE_IRQS);
 	DECLARE_BITMAP(	active_percpu, VGIC_NR_PRIVATE_IRQS);
@@ -308,9 +305,6 @@ struct vgic_cpu {
 	unsigned long   *active_shared;
 	unsigned long   *pend_act_shared;
 
-	/* Bitmap of used/free list registers */
-	DECLARE_BITMAP(	lr_used, VGIC_V2_MAX_LRS);
-
 	/* Number of list registers on this CPU */
 	int		nr_lr;
 
diff --git a/virt/kvm/arm/vgic-v2.c b/virt/kvm/arm/vgic-v2.c
index 8d7b04d..c0f5d7f 100644
--- a/virt/kvm/arm/vgic-v2.c
+++ b/virt/kvm/arm/vgic-v2.c
@@ -158,6 +158,7 @@ static void vgic_v2_enable(struct kvm_vcpu *vcpu)
 	 * anyway.
 	 */
 	vcpu->arch.vgic_cpu.vgic_v2.vgic_vmcr = 0;
+	vcpu->arch.vgic_cpu.vgic_v2.vgic_elrsr = ~0;
 
 	/* Get the show on the road... */
 	vcpu->arch.vgic_cpu.vgic_v2.vgic_hcr = GICH_HCR_EN;
diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
index 7dd5d62..92003cb 100644
--- a/virt/kvm/arm/vgic-v3.c
+++ b/virt/kvm/arm/vgic-v3.c
@@ -193,6 +193,7 @@ static void vgic_v3_enable(struct kvm_vcpu *vcpu)
 	 * anyway.
 	 */
 	vgic_v3->vgic_vmcr = 0;
+	vgic_v3->vgic_elrsr = ~0;
 
 	/*
 	 * If we are emulating a GICv3, we do it in an non-GICv2-compatible
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index f3e76e5..da0a866 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -102,7 +102,7 @@
 #include "vgic.h"
 
 static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu);
-static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu);
+static void vgic_retire_lr(int lr_nr, struct kvm_vcpu *vcpu);
 static struct vgic_lr vgic_get_lr(const struct kvm_vcpu *vcpu, int lr);
 static void vgic_set_lr(struct kvm_vcpu *vcpu, int lr, struct vgic_lr lr_desc);
 static struct irq_phys_map *vgic_irq_map_search(struct kvm_vcpu *vcpu,
@@ -672,6 +672,17 @@ bool vgic_handle_cfg_reg(u32 *reg, struct kvm_exit_mmio *mmio,
 	return false;
 }
 
+static void vgic_sync_lr_elrsr(struct kvm_vcpu *vcpu, int lr,
+			       struct vgic_lr vlr)
+{
+	vgic_ops->sync_lr_elrsr(vcpu, lr, vlr);
+}
+
+static inline u64 vgic_get_elrsr(struct kvm_vcpu *vcpu)
+{
+	return vgic_ops->get_elrsr(vcpu);
+}
+
 /**
  * vgic_unqueue_irqs - move pending/active IRQs from LRs to the distributor
  * @vgic_cpu: Pointer to the vgic_cpu struct holding the LRs
@@ -683,9 +694,11 @@ bool vgic_handle_cfg_reg(u32 *reg, struct kvm_exit_mmio *mmio,
 void vgic_unqueue_irqs(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	u64 elrsr = vgic_get_elrsr(vcpu);
+	unsigned long *elrsr_ptr = u64_to_bitmask(&elrsr);
 	int i;
 
-	for_each_set_bit(i, vgic_cpu->lr_used, vgic_cpu->nr_lr) {
+	for_each_clear_bit(i, elrsr_ptr, vgic_cpu->nr_lr) {
 		struct vgic_lr lr = vgic_get_lr(vcpu, i);
 
 		/*
@@ -728,7 +741,7 @@ void vgic_unqueue_irqs(struct kvm_vcpu *vcpu)
 		 * Mark the LR as free for other use.
 		 */
 		BUG_ON(lr.state & LR_STATE_MASK);
-		vgic_retire_lr(i, lr.irq, vcpu);
+		vgic_retire_lr(i, vcpu);
 		vgic_irq_clear_queued(vcpu, lr.irq);
 
 		/* Finally update the VGIC state. */
@@ -1036,17 +1049,6 @@ static void vgic_set_lr(struct kvm_vcpu *vcpu, int lr,
 	vgic_ops->set_lr(vcpu, lr, vlr);
 }
 
-static void vgic_sync_lr_elrsr(struct kvm_vcpu *vcpu, int lr,
-			       struct vgic_lr vlr)
-{
-	vgic_ops->sync_lr_elrsr(vcpu, lr, vlr);
-}
-
-static inline u64 vgic_get_elrsr(struct kvm_vcpu *vcpu)
-{
-	return vgic_ops->get_elrsr(vcpu);
-}
-
 static inline u64 vgic_get_eisr(struct kvm_vcpu *vcpu)
 {
 	return vgic_ops->get_eisr(vcpu);
@@ -1087,15 +1089,13 @@ static inline void vgic_enable(struct kvm_vcpu *vcpu)
 	vgic_ops->enable(vcpu);
 }
 
-static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu)
+static void vgic_retire_lr(int lr_nr, struct kvm_vcpu *vcpu)
 {
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_lr vlr = vgic_get_lr(vcpu, lr_nr);
 
 	vlr.state = 0;
+	vlr.hwirq = 0;
 	vgic_set_lr(vcpu, lr_nr, vlr);
-	clear_bit(lr_nr, vgic_cpu->lr_used);
-	vgic_cpu->vgic_irq_lr_map[irq] = LR_EMPTY;
 	vgic_sync_lr_elrsr(vcpu, lr_nr, vlr);
 }
 
@@ -1110,14 +1110,15 @@ static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu)
  */
 static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu)
 {
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	u64 elrsr = vgic_get_elrsr(vcpu);
+	unsigned long *elrsr_ptr = u64_to_bitmask(&elrsr);
 	int lr;
 
-	for_each_set_bit(lr, vgic_cpu->lr_used, vgic->nr_lr) {
+	for_each_clear_bit(lr, elrsr_ptr, vgic->nr_lr) {
 		struct vgic_lr vlr = vgic_get_lr(vcpu, lr);
 
 		if (!vgic_irq_is_enabled(vcpu, vlr.irq)) {
-			vgic_retire_lr(lr, vlr.irq, vcpu);
+			vgic_retire_lr(lr, vcpu);
 			if (vgic_irq_is_queued(vcpu, vlr.irq))
 				vgic_irq_clear_queued(vcpu, vlr.irq);
 		}
@@ -1169,9 +1170,10 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
  */
 bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
 {
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	struct vgic_lr vlr;
+	u64 elrsr = vgic_get_elrsr(vcpu);
+	unsigned long *elrsr_ptr = u64_to_bitmask(&elrsr);
 	int lr;
 
 	/* Sanitize the input... */
@@ -1181,28 +1183,12 @@ bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
 
 	kvm_debug("Queue IRQ%d\n", irq);
 
-	lr = vgic_cpu->vgic_irq_lr_map[irq];
+	lr = find_first_bit(elrsr_ptr, vgic->nr_lr);
 
-	/* Do we have an active interrupt for the same CPUID? */
-	if (lr != LR_EMPTY) {
-		vlr = vgic_get_lr(vcpu, lr);
-		if (vlr.source == sgi_source_id) {
-			kvm_debug("LR%d piggyback for IRQ%d\n", lr, vlr.irq);
-			BUG_ON(!test_bit(lr, vgic_cpu->lr_used));
-			vgic_queue_irq_to_lr(vcpu, irq, lr, vlr);
-			return true;
-		}
-	}
-
-	/* Try to use another LR for this interrupt */
-	lr = find_first_zero_bit((unsigned long *)vgic_cpu->lr_used,
-			       vgic->nr_lr);
 	if (lr >= vgic->nr_lr)
 		return false;
 
 	kvm_debug("LR%d allocated for IRQ%d %x\n", lr, irq, sgi_source_id);
-	vgic_cpu->vgic_irq_lr_map[irq] = lr;
-	set_bit(lr, vgic_cpu->lr_used);
 
 	vlr.irq = irq;
 	vlr.source = sgi_source_id;
@@ -1214,9 +1200,6 @@ bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
 
 static bool vgic_queue_hwirq(struct kvm_vcpu *vcpu, int irq)
 {
-	if (!vgic_can_sample_irq(vcpu, irq))
-		return true; /* level interrupt, already queued */
-
 	if (vgic_queue_irq(vcpu, 0, irq)) {
 		if (vgic_irq_is_edge(vcpu, irq)) {
 			vgic_dist_irq_clear_pending(vcpu, irq);
@@ -1299,9 +1282,6 @@ epilog:
 	for (lr = 0; lr < vgic->nr_lr; lr++) {
 		struct vgic_lr vlr;
 
-		if (!test_bit(lr, vgic_cpu->lr_used))
-			continue;
-
 		vlr = vgic_get_lr(vcpu, lr);
 
 		/*
@@ -1363,11 +1343,7 @@ static int process_queued_irq(struct kvm_vcpu *vcpu,
 	 * Despite being EOIed, the LR may not have
 	 * been marked as empty.
 	 */
-	vlr.state = 0;
-	vlr.hwirq = 0;
-	vgic_set_lr(vcpu, lr, vlr);
-
-	vgic_sync_lr_elrsr(vcpu, lr, vlr);
+	vgic_retire_lr(lr, vcpu);
 
 	return pending;
 }
@@ -1432,7 +1408,6 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
  */
 static bool vgic_sync_hwirq(struct kvm_vcpu *vcpu, int lr, struct vgic_lr vlr)
 {
-	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	struct irq_phys_map *map;
 	bool phys_active;
 	bool level_pending;
@@ -1464,50 +1439,62 @@ static bool vgic_sync_hwirq(struct kvm_vcpu *vcpu, int lr, struct vgic_lr vlr)
 		return false;
 	}
 
-	spin_lock(&dist->lock);
 	level_pending = process_queued_irq(vcpu, lr, vlr);
-	spin_unlock(&dist->lock);
 	return level_pending;
 }
 
 /* Sync back the VGIC state after a guest run */
 static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	u64 elrsr;
 	unsigned long *elrsr_ptr;
-	int lr, pending;
-	bool level_pending;
+	bool pending;
+	int lr;
 
-	level_pending = vgic_process_maintenance(vcpu);
+	pending = vgic_process_maintenance(vcpu);
 	elrsr = vgic_get_elrsr(vcpu);
 	elrsr_ptr = u64_to_bitmask(&elrsr);
 
-	/* Deal with HW interrupts, and clear mappings for empty LRs */
+	spin_lock(&dist->lock);
+	/* Put all state from the LRs back into our emulation. */
 	for (lr = 0; lr < vgic->nr_lr; lr++) {
-		struct vgic_lr vlr;
-
-		if (!test_bit(lr, vgic_cpu->lr_used))
-			continue;
+		struct vgic_lr vlr = vgic_get_lr(vcpu, lr);
 
-		vlr = vgic_get_lr(vcpu, lr);
+		/* Deal with deactivated HW interrupts */
 		if (vgic_sync_hwirq(vcpu, lr, vlr))
-			level_pending = true;
+			pending = true;
 
-		if (!test_bit(lr, elrsr_ptr))
+		if (test_bit(lr, elrsr_ptr))
 			continue;
 
-		clear_bit(lr, vgic_cpu->lr_used);
+		/* Reestablish SGI source for pending and active SGIs */
+		if (vlr.irq < VGIC_NR_SGIS)
+			add_sgi_source(vcpu, vlr.irq, vlr.source);
+
+		if (vlr.state & LR_STATE_PENDING)
+			vgic_dist_irq_set_pending(vcpu, vlr.irq);
 
-		BUG_ON(vlr.irq >= dist->nr_irqs);
-		vgic_cpu->vgic_irq_lr_map[vlr.irq] = LR_EMPTY;
+		if (vlr.state & LR_STATE_ACTIVE) {
+			if (vlr.state & LR_STATE_PENDING) {
+				vgic_irq_set_active(vcpu, vlr.irq);
+			} else {
+				/* Active-only IRQs stay in the LR */
+				pending = true;
+				continue;
+			}
+		}
+
+		pending = true;
+
+		/* Mark this LR as empty now. */
+		vgic_retire_lr(lr, vcpu);
 	}
+	vgic_update_state(vcpu->kvm);
 
-	/* Check if we still have something up our sleeve... */
-	pending = find_first_zero_bit(elrsr_ptr, vgic->nr_lr);
-	if (level_pending || pending < vgic->nr_lr)
+	if (pending)
 		set_bit(vcpu->vcpu_id, dist->irq_pending_on_cpu);
+	spin_unlock(&dist->lock);
 }
 
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
@@ -1923,12 +1910,10 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kfree(vgic_cpu->pending_shared);
 	kfree(vgic_cpu->active_shared);
 	kfree(vgic_cpu->pend_act_shared);
-	kfree(vgic_cpu->vgic_irq_lr_map);
 	vgic_destroy_irq_phys_map(vcpu->kvm, &vgic_cpu->irq_phys_map_list);
 	vgic_cpu->pending_shared = NULL;
 	vgic_cpu->active_shared = NULL;
 	vgic_cpu->pend_act_shared = NULL;
-	vgic_cpu->vgic_irq_lr_map = NULL;
 }
 
 static int vgic_vcpu_init_maps(struct kvm_vcpu *vcpu, int nr_irqs)
@@ -1939,18 +1924,14 @@ static int vgic_vcpu_init_maps(struct kvm_vcpu *vcpu, int nr_irqs)
 	vgic_cpu->pending_shared = kzalloc(sz, GFP_KERNEL);
 	vgic_cpu->active_shared = kzalloc(sz, GFP_KERNEL);
 	vgic_cpu->pend_act_shared = kzalloc(sz, GFP_KERNEL);
-	vgic_cpu->vgic_irq_lr_map = kmalloc(nr_irqs, GFP_KERNEL);
 
 	if (!vgic_cpu->pending_shared
 		|| !vgic_cpu->active_shared
-		|| !vgic_cpu->pend_act_shared
-		|| !vgic_cpu->vgic_irq_lr_map) {
+		|| !vgic_cpu->pend_act_shared) {
 		kvm_vgic_vcpu_destroy(vcpu);
 		return -ENOMEM;
 	}
 
-	memset(vgic_cpu->vgic_irq_lr_map, LR_EMPTY, nr_irqs);
-
 	/*
 	 * Store the number of LRs per vcpu, so we don't have to go
 	 * all the way to the distributor structure to find out. Only
-- 
2.5.1

