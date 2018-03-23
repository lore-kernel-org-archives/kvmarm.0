From: Peng Hao <peng.hao2@zte.com.cn>
Subject: [PATCH] KVM: arm/arm64 : add lpi info in vgic-debug
Date: Fri, 23 Mar 2018 18:36:05 +0800
Message-ID: <1521801365-63266-1-git-send-email-peng.hao2@zte.com.cn>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Peng Hao <peng.hao2@zte.com.cn>
List-Id: kvmarm@lists.cs.columbia.edu

Add lpi debug info to vgic-stat.
the printed info like this:
     SPI  287      0 000001        0        0   0 160      -1
     LPI 8192      2 000100        0        0   0 160      -1

Signed-off-by: Peng Hao <peng.hao2@zte.com.cn>
---
 virt/kvm/arm/vgic/vgic-debug.c | 61 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 56 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-debug.c b/virt/kvm/arm/vgic/vgic-debug.c
index 10b3817..444115e 100644
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
@@ -52,6 +55,40 @@ static void iter_next(struct vgic_state_iter *iter)
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
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	int i = 0;
+	struct vgic_irq *irq = NULL, **lpi_irqs;
+
+again:
+	iter->nr_lpis = dist->lpi_list_count;
+	lpi_irqs = kmalloc_array(iter->nr_lpis, sizeof(irq), GFP_KERNEL);
+	if (!lpi_irqs) {
+		iter->nr_lpis = 0;
+		return;
+	}
+	spin_lock(&dist->lpi_list_lock);
+	if (iter->nr_lpis != dist->lpi_list_count) {
+		kfree(lpi_irqs);
+		spin_unlock(&dist->lpi_list_lock);
+		goto again;
+	}
+
+	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
+		vgic_get_irq_kref(irq);
+		lpi_irqs[i++] = irq;
+	}
+	spin_unlock(&dist->lpi_list_lock);
+	iter->lpi_irqs = lpi_irqs;
 }
 
 static void iter_init(struct kvm *kvm, struct vgic_state_iter *iter,
@@ -64,6 +101,8 @@ static void iter_init(struct kvm *kvm, struct vgic_state_iter *iter,
 	iter->nr_cpus = nr_cpus;
 	iter->nr_spis = kvm->arch.vgic.nr_spis;
 
+	if (vgic_supports_direct_msis(kvm) && !pos)
+		vgic_debug_get_lpis(kvm, iter);
 	/* Fast forward to the right position if needed */
 	while (pos--)
 		iter_next(iter);
@@ -73,7 +112,9 @@ static bool end_of_vgic(struct vgic_state_iter *iter)
 {
 	return iter->dist_id > 0 &&
 		iter->vcpu_id == iter->nr_cpus &&
-		(iter->intid - VGIC_NR_PRIVATE_IRQS) == iter->nr_spis;
+		(iter->intid - VGIC_NR_PRIVATE_IRQS) >= iter->nr_spis &&
+		((iter->nr_lpis == 0) ||
+		(iter->lpi_print_count == iter->nr_lpis + 1));
 }
 
 static void *vgic_debug_start(struct seq_file *s, loff_t *pos)
@@ -130,6 +171,7 @@ static void vgic_debug_stop(struct seq_file *s, void *v)
 
 	mutex_lock(&kvm->lock);
 	iter = kvm->arch.vgic.iter;
+	kfree(iter->lpi_irqs);
 	kfree(iter);
 	kvm->arch.vgic.iter = NULL;
 	mutex_unlock(&kvm->lock);
@@ -154,7 +196,7 @@ static void print_header(struct seq_file *s, struct vgic_irq *irq,
 			 struct kvm_vcpu *vcpu)
 {
 	int id = 0;
-	char *hdr = "SPI ";
+	char *hdr = "S/LPI ";
 
 	if (vcpu) {
 		hdr = "VCPU";
@@ -162,7 +204,10 @@ static void print_header(struct seq_file *s, struct vgic_irq *irq,
 	}
 
 	seq_printf(s, "\n");
-	seq_printf(s, "%s%2d TYP   ID TGT_ID PLAEHC     HWID   TARGET SRC PRI VCPU_ID\n", hdr, id);
+	if (vcpu)
+		seq_printf(s, "%s%2d TYP   ID TGT_ID PLAEHC     HWID   TARGET SRC PRI VCPU_ID\n", hdr, id);
+	else
+		seq_printf(s, "%s TYP   ID TGT_ID PLAEHC     HWID   TARGET SRC PRI VCPU_ID\n", hdr);
 	seq_printf(s, "---------------------------------------------------------------\n");
 }
 
@@ -174,8 +219,10 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
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
@@ -220,7 +267,9 @@ static int vgic_debug_show(struct seq_file *s, void *v)
 	if (!kvm->arch.vgic.initialized)
 		return 0;
 
-	if (iter->vcpu_id < iter->nr_cpus) {
+	if (iter->intid >= VGIC_MIN_LPI)
+		irq = iter->lpi_irqs[iter->lpi_print_count - 1];
+	else if (iter->vcpu_id < iter->nr_cpus) {
 		vcpu = kvm_get_vcpu(kvm, iter->vcpu_id);
 		irq = &vcpu->arch.vgic_cpu.private_irqs[iter->intid];
 	} else {
@@ -230,6 +279,8 @@ static int vgic_debug_show(struct seq_file *s, void *v)
 	spin_lock(&irq->irq_lock);
 	print_irq_state(s, irq, vcpu);
 	spin_unlock(&irq->irq_lock);
+	if (iter->intid >= VGIC_MIN_LPI)
+		vgic_put_irq(kvm, irq);
 
 	return 0;
 }
-- 
1.8.3.1
