From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v3 1/3] KVM: arm/arm64: Optimize away redundant LR tracking
Date: Mon, 26 Oct 2015 12:00:28 +0300
Message-ID: <dcd7c6a5f97f89cbe35f62aa6898116e260bbb5f.1445849885.git.p.fedin@samsung.com>
References: <cover.1445849885.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <cover.1445849885.git.p.fedin@samsung.com>
In-reply-to: <cover.1445849885.git.p.fedin@samsung.com>
References: <cover.1445849885.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
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
 include/kvm/arm_vgic.h |  6 ------
 virt/kvm/arm/vgic-v2.c |  1 +
 virt/kvm/arm/vgic-v3.c |  1 +
 virt/kvm/arm/vgic.c    | 53 ++++++++++++++------------------------------------
 4 files changed, 17 insertions(+), 44 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 8065801..3936bf8 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -295,9 +295,6 @@ struct vgic_v3_cpu_if {
 };
 
 struct vgic_cpu {
-	/* per IRQ to LR mapping */
-	u8		*vgic_irq_lr_map;
-
 	/* Pending/active/both interrupts on this VCPU */
 	DECLARE_BITMAP(pending_percpu, VGIC_NR_PRIVATE_IRQS);
 	DECLARE_BITMAP(active_percpu, VGIC_NR_PRIVATE_IRQS);
@@ -308,9 +305,6 @@ struct vgic_cpu {
 	unsigned long   *active_shared;
 	unsigned long   *pend_act_shared;
 
-	/* Bitmap of used/free list registers */
-	DECLARE_BITMAP(lr_used, VGIC_V2_MAX_LRS);
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
index d4669eb..265a410 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -108,6 +108,7 @@ static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu);
 static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu);
 static struct vgic_lr vgic_get_lr(const struct kvm_vcpu *vcpu, int lr);
 static void vgic_set_lr(struct kvm_vcpu *vcpu, int lr, struct vgic_lr lr_desc);
+static u64 vgic_get_elrsr(struct kvm_vcpu *vcpu);
 static struct irq_phys_map *vgic_irq_map_search(struct kvm_vcpu *vcpu,
 						int virt_irq);
 static int compute_pending_for_cpu(struct kvm_vcpu *vcpu);
@@ -691,9 +692,11 @@ bool vgic_handle_cfg_reg(u32 *reg, struct kvm_exit_mmio *mmio,
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
@@ -1098,7 +1101,6 @@ static inline void vgic_enable(struct kvm_vcpu *vcpu)
 
 static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu)
 {
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_lr vlr = vgic_get_lr(vcpu, lr_nr);
 
 	/*
@@ -1112,8 +1114,6 @@ static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu)
 
 	vlr.state = 0;
 	vgic_set_lr(vcpu, lr_nr, vlr);
-	clear_bit(lr_nr, vgic_cpu->lr_used);
-	vgic_cpu->vgic_irq_lr_map[irq] = LR_EMPTY;
 	vgic_sync_lr_elrsr(vcpu, lr_nr, vlr);
 }
 
@@ -1128,10 +1128,11 @@ static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu)
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
@@ -1188,8 +1189,9 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
  */
 bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
 {
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	u64 elrsr = vgic_get_elrsr(vcpu);
+	unsigned long *elrsr_ptr = u64_to_bitmask(&elrsr);
 	struct vgic_lr vlr;
 	int lr;
 
@@ -1200,28 +1202,22 @@ bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
 
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
@@ -1456,7 +1452,6 @@ static bool vgic_sync_hwirq(struct kvm_vcpu *vcpu, int lr, struct vgic_lr vlr)
 /* Sync back the VGIC state after a guest run */
 static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	u64 elrsr;
 	unsigned long *elrsr_ptr;
@@ -1469,22 +1464,10 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 
 	/* Deal with HW interrupts, and clear mappings for empty LRs */
 	for (lr = 0; lr < vgic->nr_lr; lr++) {
-		struct vgic_lr vlr;
-
-		if (!test_bit(lr, vgic_cpu->lr_used))
-			continue;
-
-		vlr = vgic_get_lr(vcpu, lr);
-		if (vgic_sync_hwirq(vcpu, lr, vlr))
-			level_pending = true;
-
-		if (!test_bit(lr, elrsr_ptr))
-			continue;
-
-		clear_bit(lr, vgic_cpu->lr_used);
+		struct vgic_lr vlr = vgic_get_lr(vcpu, lr);
 
+		level_pending |= vgic_sync_hwirq(vcpu, lr, vlr);
 		BUG_ON(vlr.irq >= dist->nr_irqs);
-		vgic_cpu->vgic_irq_lr_map[vlr.irq] = LR_EMPTY;
 	}
 
 	/* Check if we still have something up our sleeve... */
@@ -1912,12 +1895,10 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
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
@@ -1928,18 +1909,14 @@ static int vgic_vcpu_init_maps(struct kvm_vcpu *vcpu, int nr_irqs)
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
2.4.4

