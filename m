From: Peng Hao <peng.hao2@zte.com.cn>
Subject: [PATCH v3] KVM: arm/arm64 : add lpi info in vgic-debug
Date: Sat, 24 Mar 2018 08:42:41 +0800
Message-ID: <1521852161-67603-1-git-send-email-peng.hao2@zte.com.cn>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: cdall@kernel.org, marc.zyngier@arm.com
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Peng Hao <peng.hao2@zte.com.cn>
List-Id: kvmarm@lists.cs.columbia.edu

Add lpi debug info to vgic-stat.
The printed info like this:
    SPI  287      0 000001        0        0   0 160      -1
    LPI 8192      2 000100        0        0   0 160      -1

Signed-off-by: Peng Hao <peng.hao2@zte.com.cn>
---
 virt/kvm/arm/vgic/vgic-debug.c | 59 ++++++++++++++++++++++++++++++++++++++----
 virt/kvm/arm/vgic/vgic-its.c   | 16 ++++++------
 virt/kvm/arm/vgic/vgic.h       |  1 +
 3 files changed, 63 insertions(+), 13 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-debug.c b/virt/kvm/arm/vgic/vgic-debug.c
index 10b3817..ddac6bd 100644
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
+	int lpi_print_count;
+	struct vgic_irq **lpi_irqs;
 };
 
 static void iter_next(struct vgic_state_iter *iter)
@@ -52,6 +55,39 @@ static void iter_next(struct vgic_state_iter *iter)
 	if (iter->intid == VGIC_NR_PRIVATE_IRQS &&
 	    ++iter->vcpu_id < iter->nr_cpus)
 		iter->intid = 0;
+
+	if (iter->intid >= VGIC_NR_PRIVATE_IRQS + iter->nr_spis) {
+		if (iter->lpi_print_count < iter->nr_lpis)
+			iter->intid = iter->lpi_irqs[iter->lpi_print_count]->intid;
+		iter->lpi_print_count++;
+	}
+}
+
+static void vgic_debug_get_lpis(struct kvm *kvm, struct vgic_state_iter *iter)
+{
+	u32 *intids;
+	int i, irq_count;
+	struct vgic_irq *irq = NULL, **lpi_irqs;
+
+	iter->nr_lpis = 0;
+	irq_count = vgic_copy_lpi_list(kvm, NULL, &intids);
+	if (irq_count < 0)
+		return;
+
+	lpi_irqs = kmalloc_array(irq_count, sizeof(irq), GFP_KERNEL);
+	if (!lpi_irqs) {
+		kfree(intids);
+		return;
+	}
+
+	for (i = 0; i < irq_count; i++) {
+		irq = vgic_get_irq(kvm, NULL, intids[i]);
+		if (!irq)
+			continue;
+		lpi_irqs[iter->nr_lpis++] = irq;
+	}
+	iter->lpi_irqs = lpi_irqs;
+	kfree(intids);
 }
 
 static void iter_init(struct kvm *kvm, struct vgic_state_iter *iter,
@@ -64,6 +100,8 @@ static void iter_init(struct kvm *kvm, struct vgic_state_iter *iter,
 	iter->nr_cpus = nr_cpus;
 	iter->nr_spis = kvm->arch.vgic.nr_spis;
 
+	if (vgic_supports_direct_msis(kvm) && !pos)
+		vgic_debug_get_lpis(kvm, iter);
 	/* Fast forward to the right position if needed */
 	while (pos--)
 		iter_next(iter);
@@ -73,7 +111,9 @@ static bool end_of_vgic(struct vgic_state_iter *iter)
 {
 	return iter->dist_id > 0 &&
 		iter->vcpu_id == iter->nr_cpus &&
-		(iter->intid - VGIC_NR_PRIVATE_IRQS) == iter->nr_spis;
+		(iter->intid - VGIC_NR_PRIVATE_IRQS) >= iter->nr_spis &&
+		((iter->nr_lpis == 0) ||
+		(iter->lpi_print_count == iter->nr_lpis + 1));
 }
 
 static void *vgic_debug_start(struct seq_file *s, loff_t *pos)
@@ -130,6 +170,7 @@ static void vgic_debug_stop(struct seq_file *s, void *v)
 
 	mutex_lock(&kvm->lock);
 	iter = kvm->arch.vgic.iter;
+	kfree(iter->lpi_irqs);
 	kfree(iter);
 	kvm->arch.vgic.iter = NULL;
 	mutex_unlock(&kvm->lock);
@@ -154,7 +195,7 @@ static void print_header(struct seq_file *s, struct vgic_irq *irq,
 			 struct kvm_vcpu *vcpu)
 {
 	int id = 0;
-	char *hdr = "SPI ";
+	char *hdr = "Global";
 
 	if (vcpu) {
 		hdr = "VCPU";
@@ -162,7 +203,10 @@ static void print_header(struct seq_file *s, struct vgic_irq *irq,
 	}
 
 	seq_printf(s, "\n");
-	seq_printf(s, "%s%2d TYP   ID TGT_ID PLAEHC     HWID   TARGET SRC PRI VCPU_ID\n", hdr, id);
+	if (vcpu)
+		seq_printf(s, "%s%2d TYP   ID TGT_ID PLAEHC     HWID   TARGET SRC PRI VCPU_ID\n", hdr, id);
+	else
+		seq_printf(s, "%s TYP   ID TGT_ID PLAEHC     HWID   TARGET SRC PRI VCPU_ID\n", hdr);
 	seq_printf(s, "---------------------------------------------------------------\n");
 }
 
@@ -174,8 +218,10 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
 		type = "SGI";
 	else if (irq->intid < VGIC_NR_PRIVATE_IRQS)
 		type = "PPI";
-	else
+	else if (irq->intid < VGIC_MAX_SPI)
 		type = "SPI";
+	else if (irq->intid >= VGIC_MIN_LPI)
+		type = "LPI";
 
 	if (irq->intid ==0 || irq->intid == VGIC_NR_PRIVATE_IRQS)
 		print_header(s, irq, vcpu);
@@ -220,7 +266,9 @@ static int vgic_debug_show(struct seq_file *s, void *v)
 	if (!kvm->arch.vgic.initialized)
 		return 0;
 
-	if (iter->vcpu_id < iter->nr_cpus) {
+	if (iter->intid >= VGIC_MIN_LPI)
+		irq = iter->lpi_irqs[iter->lpi_print_count - 1];
+	else if (iter->vcpu_id < iter->nr_cpus) {
 		vcpu = kvm_get_vcpu(kvm, iter->vcpu_id);
 		irq = &vcpu->arch.vgic_cpu.private_irqs[iter->intid];
 	} else {
@@ -230,6 +278,7 @@ static int vgic_debug_show(struct seq_file *s, void *v)
 	spin_lock(&irq->irq_lock);
 	print_irq_state(s, irq, vcpu);
 	spin_unlock(&irq->irq_lock);
+	vgic_put_irq(kvm, irq);
 
 	return 0;
 }
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 4650953..3e8a47d 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -307,13 +307,13 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 }
 
 /*
- * Create a snapshot of the current LPIs targeting @vcpu, so that we can
- * enumerate those LPIs without holding any lock.
+ * Create a snapshot of the current LPIs targeting @vcpu if @vcpu!=NULL or all
+ * LPIs, so that we can enumerate those LPIs without holding any lock.
  * Returns their number and puts the kmalloc'ed array into intid_ptr.
  */
-static int vgic_copy_lpi_list(struct kvm_vcpu *vcpu, u32 **intid_ptr)
+int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
 {
-	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_irq *irq;
 	u32 *intids;
 	int irq_count = dist->lpi_list_count, i = 0;
@@ -332,7 +332,7 @@ static int vgic_copy_lpi_list(struct kvm_vcpu *vcpu, u32 **intid_ptr)
 	spin_lock(&dist->lpi_list_lock);
 	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
 		/* We don't need to "get" the IRQ, as we hold the list lock. */
-		if (irq->target_vcpu != vcpu)
+		if (vcpu && irq->target_vcpu != vcpu)
 			continue;
 		intids[i++] = irq->intid;
 	}
@@ -423,7 +423,7 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
 	unsigned long flags;
 	u8 pendmask;
 
-	nr_irqs = vgic_copy_lpi_list(vcpu, &intids);
+	nr_irqs = vgic_copy_lpi_list(vcpu->kvm, vcpu, &intids);
 	if (nr_irqs < 0)
 		return nr_irqs;
 
@@ -1147,7 +1147,7 @@ static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
 
 	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
 
-	irq_count = vgic_copy_lpi_list(vcpu, &intids);
+	irq_count = vgic_copy_lpi_list(kvm, vcpu, &intids);
 	if (irq_count < 0)
 		return irq_count;
 
@@ -1195,7 +1195,7 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 	vcpu1 = kvm_get_vcpu(kvm, target1_addr);
 	vcpu2 = kvm_get_vcpu(kvm, target2_addr);
 
-	irq_count = vgic_copy_lpi_list(vcpu1, &intids);
+	irq_count = vgic_copy_lpi_list(kvm, vcpu1, &intids);
 	if (irq_count < 0)
 		return irq_count;
 
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index f5b8519..68b5ed2 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -257,5 +257,6 @@ int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 void vgic_v4_teardown(struct kvm *kvm);
 int vgic_v4_sync_hwstate(struct kvm_vcpu *vcpu);
 int vgic_v4_flush_hwstate(struct kvm_vcpu *vcpu);
+int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr);
 
 #endif
-- 
1.8.3.1
