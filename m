From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH 1/2] KVM: arm/arm64: Optimize away redundant LR tracking
Date: Fri, 02 Oct 2015 17:44:28 +0300
Message-ID: <34d659eff6cda85488561ccd2382b82377b44784.1443796321.git.p.fedin@samsung.com>
References: <cover.1443796321.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A13C410D7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 10:43:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a8e1ooo8yPvw for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Oct 2015 10:42:53 -0400 (EDT)
Received: from mailout4.w1.samsung.com (mailout4.w1.samsung.com
 [210.118.77.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 93C4A410BB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 10:42:53 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NVL00KC1KYAQH50@mailout4.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 02 Oct 2015 15:44:34 +0100 (BST)
In-reply-to: <cover.1443796321.git.p.fedin@samsung.com>
In-reply-to: <cover.1443796321.git.p.fedin@samsung.com>
References: <cover.1443796321.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Currently we use vgic_irq_lr_map in order to track which LRs hold which
IRQs, and lr_used bitmap in order to track which LRs are used or free.

vgic_irq_lr_map is actually used only for piggy-back optimization, and
can be easily replaced by iteration over lr_used. This is good because in
future, when LPI support is introduced, number of IRQs will grow up to at
least 16384, while numbers from 1024 to 8192 are never going to be used.
This would be a huge memory waste.

In its turn, lr_used is also completely redundant since
ae705930fca6322600690df9dc1c7d0516145a93 ("arm/arm64: KVM: Keep elrsr/aisr
in sync with software model"), because together with lr_used we also update
elrsr. This allows to easily replace lr_used with elrsr, inverting all
conditions (because in elrsr '1' means 'free').

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 include/kvm/arm_vgic.h |  6 ----
 virt/kvm/arm/vgic.c    | 74 +++++++++++++++++++-------------------------------
 2 files changed, 28 insertions(+), 52 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4e14dac..d908028 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -296,9 +296,6 @@ struct vgic_v3_cpu_if {
 };
 
 struct vgic_cpu {
-	/* per IRQ to LR mapping */
-	u8		*vgic_irq_lr_map;
-
 	/* Pending/active/both interrupts on this VCPU */
 	DECLARE_BITMAP(	pending_percpu, VGIC_NR_PRIVATE_IRQS);
 	DECLARE_BITMAP(	active_percpu, VGIC_NR_PRIVATE_IRQS);
@@ -309,9 +306,6 @@ struct vgic_cpu {
 	unsigned long   *active_shared;
 	unsigned long   *pend_act_shared;
 
-	/* Bitmap of used/free list registers */
-	DECLARE_BITMAP(	lr_used, VGIC_V2_MAX_LRS);
-
 	/* Number of list registers on this CPU */
 	int		nr_lr;
 
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 6bd1c9b..2f4d25a 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -102,9 +102,10 @@
 #include "vgic.h"
 
 static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu);
-static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu);
+static void vgic_retire_lr(int lr_nr, struct kvm_vcpu *vcpu);
 static struct vgic_lr vgic_get_lr(const struct kvm_vcpu *vcpu, int lr);
 static void vgic_set_lr(struct kvm_vcpu *vcpu, int lr, struct vgic_lr lr_desc);
+static u64 vgic_get_elrsr(struct kvm_vcpu *vcpu);
 static struct irq_phys_map *vgic_irq_map_search(struct kvm_vcpu *vcpu,
 						int virt_irq);
 
@@ -683,9 +684,11 @@ bool vgic_handle_cfg_reg(u32 *reg, struct kvm_exit_mmio *mmio,
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
@@ -728,7 +731,7 @@ void vgic_unqueue_irqs(struct kvm_vcpu *vcpu)
 		 * Mark the LR as free for other use.
 		 */
 		BUG_ON(lr.state & LR_STATE_MASK);
-		vgic_retire_lr(i, lr.irq, vcpu);
+		vgic_retire_lr(i, vcpu);
 		vgic_irq_clear_queued(vcpu, lr.irq);
 
 		/* Finally update the VGIC state. */
@@ -1087,15 +1090,12 @@ static inline void vgic_enable(struct kvm_vcpu *vcpu)
 	vgic_ops->enable(vcpu);
 }
 
-static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu)
+static void vgic_retire_lr(int lr_nr, struct kvm_vcpu *vcpu)
 {
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_lr vlr = vgic_get_lr(vcpu, lr_nr);
 
 	vlr.state = 0;
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
@@ -1169,8 +1170,9 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
  */
 bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
 {
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	u64 elrsr = vgic_get_elrsr(vcpu);
+	unsigned long *elrsr_ptr = u64_to_bitmask(&elrsr);
 	struct vgic_lr vlr;
 	int lr;
 
@@ -1181,28 +1183,22 @@ bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
 
 	kvm_debug("Queue IRQ%d\n", irq);
 
-	lr = vgic_cpu->vgic_irq_lr_map[irq];
-
 	/* Do we have an active interrupt for the same CPUID? */
-	if (lr != LR_EMPTY) {
+	for_each_clear_bit(lr, elrsr_ptr, vgic->nr_lr) {
 		vlr = vgic_get_lr(vcpu, lr);
-		if (vlr.source == sgi_source_id) {
+		if (vlr.irq == irq && vlr.source == sgi_source_id) {
 			kvm_debug("LR%d piggyback for IRQ%d\n", lr, vlr.irq);
-			BUG_ON(!test_bit(lr, vgic_cpu->lr_used));
 			vgic_queue_irq_to_lr(vcpu, irq, lr, vlr);
 			return true;
 		}
 	}
 
 	/* Try to use another LR for this interrupt */
-	lr = find_first_zero_bit((unsigned long *)vgic_cpu->lr_used,
-			       vgic->nr_lr);
+	lr = find_first_bit(elrsr_ptr, vgic->nr_lr);
 	if (lr >= vgic->nr_lr)
 		return false;
 
 	kvm_debug("LR%d allocated for IRQ%d %x\n", lr, irq, sgi_source_id);
-	vgic_cpu->vgic_irq_lr_map[irq] = lr;
-	set_bit(lr, vgic_cpu->lr_used);
 
 	vlr.irq = irq;
 	vlr.source = sgi_source_id;
@@ -1243,6 +1239,8 @@ static void __kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	int i, vcpu_id, lr, ret;
 	int overflow = 0;
 	int nr_shared = vgic_nr_shared_irqs(dist);
+	u64 elrsr;
+	unsigned long *elrsr_ptr;
 
 	vcpu_id = vcpu->vcpu_id;
 
@@ -1296,13 +1294,11 @@ epilog:
 		clear_bit(vcpu_id, dist->irq_pending_on_cpu);
 	}
 
-	for (lr = 0; lr < vgic->nr_lr; lr++) {
-		struct vgic_lr vlr;
-
-		if (!test_bit(lr, vgic_cpu->lr_used))
-			continue;
+	elrsr = vgic_get_elrsr(vcpu);
+	elrsr_ptr = u64_to_bitmask(&elrsr);
 
-		vlr = vgic_get_lr(vcpu, lr);
+	for_each_clear_bit(lr, elrsr_ptr, vgic->nr_lr) {
+		struct vgic_lr vlr = vgic_get_lr(vcpu, lr);
 
 		/*
 		 * If we have a mapping, and the virtual interrupt is
@@ -1443,7 +1439,6 @@ static int vgic_sync_hwirq(struct kvm_vcpu *vcpu, struct vgic_lr vlr)
 /* Sync back the VGIC state after a guest run */
 static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	u64 elrsr;
 	unsigned long *elrsr_ptr;
@@ -1456,12 +1451,8 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 
 	/* Deal with HW interrupts, and clear mappings for empty LRs */
 	for (lr = 0; lr < vgic->nr_lr; lr++) {
-		struct vgic_lr vlr;
-
-		if (!test_bit(lr, vgic_cpu->lr_used))
-			continue;
+		struct vgic_lr vlr = vgic_get_lr(vcpu, lr);
 
-		vlr = vgic_get_lr(vcpu, lr);
 		if (vgic_sync_hwirq(vcpu, vlr)) {
 			/*
 			 * So this is a HW interrupt that the guest
@@ -1474,14 +1465,6 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 			vgic_irq_clear_queued(vcpu, vlr.irq);
 			set_bit(lr, elrsr_ptr);
 		}
-
-		if (!test_bit(lr, elrsr_ptr))
-			continue;
-
-		clear_bit(lr, vgic_cpu->lr_used);
-
-		BUG_ON(vlr.irq >= dist->nr_irqs);
-		vgic_cpu->vgic_irq_lr_map[vlr.irq] = LR_EMPTY;
 	}
 
 	/* Check if we still have something up our sleeve... */
@@ -1927,33 +1910,32 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
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
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	int lr;
 
 	int sz = (nr_irqs - VGIC_NR_PRIVATE_IRQS) / 8;
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
+	/* This initializes elrsr to "all empty" */
+	for (lr = 0; lr < vgic->nr_lr; lr++)
+		vgic_retire_lr(lr, vcpu);
 
 	/*
 	 * Store the number of LRs per vcpu, so we don't have to go
-- 
2.4.4
