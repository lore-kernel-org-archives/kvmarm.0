From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] KVM: arm/arm64: vgic-debug: Show LPI status
Date: Mon,  9 Jul 2018 12:20:31 +0100
Message-ID: <20180709112031.20217-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A418549FAC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jul 2018 07:08:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V5R12lRqwnmv for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jul 2018 07:08:03 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C0C24086E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jul 2018 07:08:03 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>, Eric Auger <eric.auger@redhat.com>, Andre Przywara <Andre.Przywara@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The vgic debugfs file only knows about SGI/PPI/SPI interrupts, and
completely ignores LPIs. Let's fix that.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
I've had this patch in my tree for almost 4 months now, and it has been
useful at least once. Thoughts?

 virt/kvm/arm/vgic/vgic-debug.c | 42 ++++++++++++++++++++++++++--------
 virt/kvm/arm/vgic/vgic-its.c   | 12 +++++-----
 virt/kvm/arm/vgic/vgic.h       |  1 +
 3 files changed, 39 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-debug.c b/virt/kvm/arm/vgic/vgic-debug.c
index d3a403f63010..07aa900bac56 100644
--- a/virt/kvm/arm/vgic/vgic-debug.c
+++ b/virt/kvm/arm/vgic/vgic-debug.c
@@ -36,9 +36,12 @@
 struct vgic_state_iter {
 	int nr_cpus;
 	int nr_spis;
+	int nr_lpis;
 	int dist_id;
 	int vcpu_id;
 	int intid;
+	int lpi_idx;
+	u32 *lpi_array;
 };
 
 static void iter_next(struct vgic_state_iter *iter)
@@ -52,6 +55,12 @@ static void iter_next(struct vgic_state_iter *iter)
 	if (iter->intid == VGIC_NR_PRIVATE_IRQS &&
 	    ++iter->vcpu_id < iter->nr_cpus)
 		iter->intid = 0;
+
+	if (iter->intid >= (iter->nr_spis + VGIC_NR_PRIVATE_IRQS)) {
+		if (iter->lpi_idx < iter->nr_lpis)
+			iter->intid = iter->lpi_array[iter->lpi_idx];
+		iter->lpi_idx++;
+	}
 }
 
 static void iter_init(struct kvm *kvm, struct vgic_state_iter *iter,
@@ -63,6 +72,11 @@ static void iter_init(struct kvm *kvm, struct vgic_state_iter *iter,
 
 	iter->nr_cpus = nr_cpus;
 	iter->nr_spis = kvm->arch.vgic.nr_spis;
+	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+		iter->nr_lpis = vgic_copy_lpi_list(kvm, NULL, &iter->lpi_array);
+		if (iter->nr_lpis < 0)
+			iter->nr_lpis = 0;
+	}
 
 	/* Fast forward to the right position if needed */
 	while (pos--)
@@ -73,7 +87,8 @@ static bool end_of_vgic(struct vgic_state_iter *iter)
 {
 	return iter->dist_id > 0 &&
 		iter->vcpu_id == iter->nr_cpus &&
-		(iter->intid - VGIC_NR_PRIVATE_IRQS) == iter->nr_spis;
+		iter->intid >= (iter->nr_spis + VGIC_NR_PRIVATE_IRQS) &&
+		iter->lpi_idx > iter->nr_lpis;
 }
 
 static void *vgic_debug_start(struct seq_file *s, loff_t *pos)
@@ -130,6 +145,7 @@ static void vgic_debug_stop(struct seq_file *s, void *v)
 
 	mutex_lock(&kvm->lock);
 	iter = kvm->arch.vgic.iter;
+	kfree(iter->lpi_array);
 	kfree(iter);
 	kvm->arch.vgic.iter = NULL;
 	mutex_unlock(&kvm->lock);
@@ -137,12 +153,14 @@ static void vgic_debug_stop(struct seq_file *s, void *v)
 
 static void print_dist_state(struct seq_file *s, struct vgic_dist *dist)
 {
+	bool v3 = dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3;
+
 	seq_printf(s, "Distributor\n");
 	seq_printf(s, "===========\n");
-	seq_printf(s, "vgic_model:\t%s\n",
-		   (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) ?
-		   "GICv3" : "GICv2");
+	seq_printf(s, "vgic_model:\t%s\n", v3 ? "GICv3" : "GICv2");
 	seq_printf(s, "nr_spis:\t%d\n", dist->nr_spis);
+	if (v3)
+		seq_printf(s, "nr_lpis:\t%d\n", dist->lpi_list_count);
 	seq_printf(s, "enabled:\t%d\n", dist->enabled);
 	seq_printf(s, "\n");
 
@@ -175,8 +193,10 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
 		type = "SGI";
 	else if (irq->intid < VGIC_NR_PRIVATE_IRQS)
 		type = "PPI";
-	else
+	else if (irq->intid < VGIC_MAX_SPI)
 		type = "SPI";
+	else
+		type = "LPI";
 
 	if (irq->intid ==0 || irq->intid == VGIC_NR_PRIVATE_IRQS)
 		print_header(s, irq, vcpu);
@@ -204,7 +224,6 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
 			irq->source,
 			irq->priority,
 			(irq->vcpu) ? irq->vcpu->vcpu_id : -1);
-
 }
 
 static int vgic_debug_show(struct seq_file *s, void *v)
@@ -223,17 +242,20 @@ static int vgic_debug_show(struct seq_file *s, void *v)
 	if (!kvm->arch.vgic.initialized)
 		return 0;
 
-	if (iter->vcpu_id < iter->nr_cpus) {
+	if (iter->vcpu_id < iter->nr_cpus)
 		vcpu = kvm_get_vcpu(kvm, iter->vcpu_id);
-		irq = &vcpu->arch.vgic_cpu.private_irqs[iter->intid];
-	} else {
-		irq = &kvm->arch.vgic.spis[iter->intid - VGIC_NR_PRIVATE_IRQS];
+
+	irq = vgic_get_irq(kvm, vcpu, iter->intid);
+	if (!irq) {
+		seq_printf(s, "       LPI %4d freed\n", iter->intid);
+		return 0;
 	}
 
 	spin_lock_irqsave(&irq->irq_lock, flags);
 	print_irq_state(s, irq, vcpu);
 	spin_unlock_irqrestore(&irq->irq_lock, flags);
 
+	vgic_put_irq(kvm, irq);
 	return 0;
 }
 
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 92840c06fcd7..d23e365dfc40 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -313,9 +313,9 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
  * enumerate those LPIs without holding any lock.
  * Returns their number and puts the kmalloc'ed array into intid_ptr.
  */
-static int vgic_copy_lpi_list(struct kvm_vcpu *vcpu, u32 **intid_ptr)
+int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
 {
-	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_irq *irq;
 	unsigned long flags;
 	u32 *intids;
@@ -338,7 +338,7 @@ static int vgic_copy_lpi_list(struct kvm_vcpu *vcpu, u32 **intid_ptr)
 		if (i == irq_count)
 			break;
 		/* We don't need to "get" the IRQ, as we hold the list lock. */
-		if (irq->target_vcpu != vcpu)
+		if (vcpu && irq->target_vcpu != vcpu)
 			continue;
 		intids[i++] = irq->intid;
 	}
@@ -430,7 +430,7 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
 	unsigned long flags;
 	u8 pendmask;
 
-	nr_irqs = vgic_copy_lpi_list(vcpu, &intids);
+	nr_irqs = vgic_copy_lpi_list(vcpu->kvm, vcpu, &intids);
 	if (nr_irqs < 0)
 		return nr_irqs;
 
@@ -1155,7 +1155,7 @@ static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
 
 	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
 
-	irq_count = vgic_copy_lpi_list(vcpu, &intids);
+	irq_count = vgic_copy_lpi_list(kvm, vcpu, &intids);
 	if (irq_count < 0)
 		return irq_count;
 
@@ -1203,7 +1203,7 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 	vcpu1 = kvm_get_vcpu(kvm, target1_addr);
 	vcpu2 = kvm_get_vcpu(kvm, target2_addr);
 
-	irq_count = vgic_copy_lpi_list(vcpu1, &intids);
+	irq_count = vgic_copy_lpi_list(kvm, vcpu1, &intids);
 	if (irq_count < 0)
 		return irq_count;
 
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index ead00b2072b2..ed9d9d9e2fc5 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -305,6 +305,7 @@ static inline bool vgic_dist_overlap(struct kvm *kvm, gpa_t base, size_t size)
 		(base < d->vgic_dist_base + KVM_VGIC_V3_DIST_SIZE);
 }
 
+int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr);
 int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 			 u32 devid, u32 eventid, struct vgic_irq **irq);
 struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
-- 
2.18.0
