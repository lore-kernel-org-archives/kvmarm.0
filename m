From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v5 2/4] KVM: arm/arm64: Replace lr_used with elrsr
Date: Tue, 03 Nov 2015 11:34:06 +0300
Message-ID: <6e27262820a145c5626bc14efb6eb5b828383516.1446539212.git.p.fedin@samsung.com>
References: <cover.1446539212.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBB0C49080
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2015 03:31:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HDj8w8cuDO3F for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Nov 2015 03:31:17 -0500 (EST)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE8294976C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2015 03:31:17 -0500 (EST)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NX8001LED55B2A0@mailout2.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 03 Nov 2015 08:34:17 +0000 (GMT)
In-reply-to: <cover.1446539212.git.p.fedin@samsung.com>
In-reply-to: <cover.1446539212.git.p.fedin@samsung.com>
References: <cover.1446539212.git.p.fedin@samsung.com>
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

Since commit ae705930fca6322600690df9dc1c7d0516145a93 ("arm/arm64: KVM:
Keep elrsr/aisr in sync with software model") lr_used is completely
redundant, because together with lr_used we also update elrsr. This allows
to easily replace lr_used with elrsr, inverting all conditions (because in
elrsr '1' means 'free').

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 include/kvm/arm_vgic.h |  3 ---
 virt/kvm/arm/vgic-v2.c |  1 +
 virt/kvm/arm/vgic-v3.c |  1 +
 virt/kvm/arm/vgic.c    | 37 +++++++++++++------------------------
 4 files changed, 15 insertions(+), 27 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index c74dc7b..3936bf8 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -305,9 +305,6 @@ struct vgic_cpu {
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
index 54233e0..265a410 100644
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
@@ -1112,7 +1114,6 @@ static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu)
 
 	vlr.state = 0;
 	vgic_set_lr(vcpu, lr_nr, vlr);
-	clear_bit(lr_nr, vgic_cpu->lr_used);
 	vgic_sync_lr_elrsr(vcpu, lr_nr, vlr);
 }
 
@@ -1127,10 +1128,11 @@ static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu)
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
@@ -1187,8 +1189,9 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
  */
 bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
 {
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	u64 elrsr = vgic_get_elrsr(vcpu);
+	unsigned long *elrsr_ptr = u64_to_bitmask(&elrsr);
 	struct vgic_lr vlr;
 	int lr;
 
@@ -1200,7 +1203,7 @@ bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
 	kvm_debug("Queue IRQ%d\n", irq);
 
 	/* Do we have an active interrupt for the same CPUID? */
-	for_each_set_bit(lr, vgic_cpu->lr_used, vgic_cpu->nr_lr) {
+	for_each_clear_bit(lr, elrsr_ptr, vgic->nr_lr) {
 		vlr = vgic_get_lr(vcpu, lr);
 		if (vlr.irq == irq && vlr.source == sgi_source_id) {
 			kvm_debug("LR%d piggyback for IRQ%d\n", lr, vlr.irq);
@@ -1210,13 +1213,11 @@ bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
 	}
 
 	/* Try to use another LR for this interrupt */
-	lr = find_first_zero_bit((unsigned long *)vgic_cpu->lr_used,
-			       vgic->nr_lr);
+	lr = find_first_bit(elrsr_ptr, vgic->nr_lr);
 	if (lr >= vgic->nr_lr)
 		return false;
 
 	kvm_debug("LR%d allocated for IRQ%d %x\n", lr, irq, sgi_source_id);
-	set_bit(lr, vgic_cpu->lr_used);
 
 	vlr.irq = irq;
 	vlr.source = sgi_source_id;
@@ -1451,7 +1452,6 @@ static bool vgic_sync_hwirq(struct kvm_vcpu *vcpu, int lr, struct vgic_lr vlr)
 /* Sync back the VGIC state after a guest run */
 static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	u64 elrsr;
 	unsigned long *elrsr_ptr;
@@ -1464,20 +1464,9 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 
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
 	}
 
-- 
2.4.4
