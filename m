From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: Potential deadlock in vgic
Date: Fri,  4 May 2018 16:17:40 +0100
Message-ID: <20180504151740.12165-1-andre.przywara@arm.com>
References: <20180504130854.GA14663@hc>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180504130854.GA14663@hc>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Jan Glauber <jan.glauber@caviumnetworks.com>, Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jan,

can you please test this patch with your setup, to see if it still
screams? That converts two forgotten irq_lock's over to be irqsafe,
plus lets lpi_list_lock join them (which you already did, IIUC).
That should appease lockdep, hopefully.

Cheers,
Andre.
---
 virt/kvm/arm/vgic/vgic-debug.c |  5 +++--
 virt/kvm/arm/vgic/vgic-its.c   | 15 +++++++++------
 virt/kvm/arm/vgic/vgic.c       | 12 +++++++-----
 3 files changed, 19 insertions(+), 13 deletions(-)

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
index a8f07243aa9f..51a80b600632 100644
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
@@ -348,10 +350,11 @@ static int vgic_copy_lpi_list(struct kvm_vcpu *vcpu, u32 **intid_ptr)
 static int update_affinity(struct vgic_irq *irq, struct kvm_vcpu *vcpu)
 {
 	int ret = 0;
+	unsigned long flags;
 
-	spin_lock(&irq->irq_lock);
+	spin_lock_irqsave(&irq->irq_lock, flags);
 	irq->target_vcpu = vcpu;
-	spin_unlock(&irq->irq_lock);
+	spin_unlock_irqrestore(&irq->irq_lock, flags);
 
 	if (irq->hw) {
 		struct its_vlpi_map map;
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 5f52a2bca36f..6efcddfb5167 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -75,8 +75,9 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u32 intid)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_irq *irq = NULL;
+	unsigned long flags;
 
-	spin_lock(&dist->lpi_list_lock);
+	spin_lock_irqsave(&dist->lpi_list_lock, flags);
 
 	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
 		if (irq->intid != intid)
@@ -92,7 +93,7 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u32 intid)
 	irq = NULL;
 
 out_unlock:
-	spin_unlock(&dist->lpi_list_lock);
+	spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 
 	return irq;
 }
@@ -137,19 +138,20 @@ static void vgic_irq_release(struct kref *ref)
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
