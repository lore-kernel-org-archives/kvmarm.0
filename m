From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 37/55] KVM: arm64: vgic-its: Connect LPIs to the VGIC emulation
Date: Fri, 22 Jul 2016 18:28:54 +0100
Message-ID: <1469208552-4155-38-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DFDF49BDA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:24:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8bbiL566cDRF for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 13:24:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94B5C49BD2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:24:43 -0400 (EDT)
In-Reply-To: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

LPIs are dynamically created (mapped) at guest runtime and their
actual number can be quite high, but is mostly assigned using a very
sparse allocation scheme. So arrays are not an ideal data structure
to hold the information.
We use a spin-lock protected linked list to hold all mapped LPIs,
represented by their struct vgic_irq. This lock is grouped between the
ap_list_lock and the vgic_irq lock in our locking order.
Also we store a pointer to that struct vgic_irq in our struct its_itte,
so we can easily access it.
Eventually we call our new vgic_get_lpi() from vgic_get_irq(), so
the VGIC code gets transparently access to LPIs.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Tested-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h        |  6 +++++
 virt/kvm/arm/vgic/vgic-init.c |  3 +++
 virt/kvm/arm/vgic/vgic-its.c  |  5 ++++
 virt/kvm/arm/vgic/vgic-v3.c   |  2 ++
 virt/kvm/arm/vgic/vgic.c      | 63 ++++++++++++++++++++++++++++++++++++++-----
 5 files changed, 73 insertions(+), 6 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 6186749..a6ca326 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -77,6 +77,7 @@ enum vgic_irq_config {
 
 struct vgic_irq {
 	spinlock_t irq_lock;		/* Protects the content of the struct */
+	struct list_head lpi_list;	/* Used to link all LPIs together */
 	struct list_head ap_list;
 
 	struct kvm_vcpu *vcpu;		/* SGIs and PPIs: The VCPU
@@ -193,6 +194,11 @@ struct vgic_dist {
 	 * GICv3 spec: 6.1.2 "LPI Configuration tables"
 	 */
 	u64			propbaser;
+
+	/* Protects the lpi_list and the count value below. */
+	spinlock_t		lpi_list_lock;
+	struct list_head	lpi_list_head;
+	int			lpi_list_count;
 };
 
 struct vgic_v2_cpu_if {
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index ac3c1a5..535e713 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -157,6 +157,9 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
 	struct kvm_vcpu *vcpu0 = kvm_get_vcpu(kvm, 0);
 	int i;
 
+	INIT_LIST_HEAD(&dist->lpi_list_head);
+	spin_lock_init(&dist->lpi_list_lock);
+
 	dist->spis = kcalloc(nr_spis, sizeof(struct vgic_irq), GFP_KERNEL);
 	if (!dist->spis)
 		return  -ENOMEM;
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 11cfe2f..14f91ff 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -56,6 +56,7 @@ struct its_collection {
 struct its_itte {
 	struct list_head itte_list;
 
+	struct vgic_irq *irq;
 	struct its_collection *collection;
 	u32 lpi;
 	u32 event_id;
@@ -148,6 +149,10 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
 static void its_free_itte(struct kvm *kvm, struct its_itte *itte)
 {
 	list_del(&itte->itte_list);
+
+	/* This put matches the get in vgic_add_lpi. */
+	vgic_put_irq(kvm, itte->irq);
+
 	kfree(itte);
 }
 
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 6f8f31f..0506543 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -81,6 +81,8 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 		else
 			intid = val & GICH_LR_VIRTUALID;
 		irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
+		if (!irq)	/* An LPI could have been unmapped. */
+			continue;
 
 		spin_lock(&irq->irq_lock);
 
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index d3ba1b4..53299fc 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -36,7 +36,8 @@ struct vgic_global __section(.hyp.text) kvm_vgic_global_state;
  * its->cmd_lock (mutex)
  *   its->its_lock (mutex)
  *     vgic_cpu->ap_list_lock
- *       vgic_irq->irq_lock
+ *       kvm->lpi_list_lock
+ *         vgic_irq->irq_lock
  *
  * If you need to take multiple locks, always take the upper lock first,
  * then the lower ones, e.g. first take the its_lock, then the irq_lock.
@@ -51,6 +52,41 @@ struct vgic_global __section(.hyp.text) kvm_vgic_global_state;
  *     spin_lock(vcpuY->arch.vgic_cpu.ap_list_lock);
  */
 
+/*
+ * Iterate over the VM's list of mapped LPIs to find the one with a
+ * matching interrupt ID and return a reference to the IRQ structure.
+ */
+static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u32 intid)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_irq *irq = NULL;
+
+	spin_lock(&dist->lpi_list_lock);
+
+	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
+		if (irq->intid != intid)
+			continue;
+
+		/*
+		 * This increases the refcount, the caller is expected to
+		 * call vgic_put_irq() later once it's finished with the IRQ.
+		 */
+		kref_get(&irq->refcount);
+		goto out_unlock;
+	}
+	irq = NULL;
+
+out_unlock:
+	spin_unlock(&dist->lpi_list_lock);
+
+	return irq;
+}
+
+/*
+ * This looks up the virtual interrupt ID to get the corresponding
+ * struct vgic_irq. It also increases the refcount, so any caller is expected
+ * to call vgic_put_irq() once it's finished with this IRQ.
+ */
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			      u32 intid)
 {
@@ -62,9 +98,9 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	if (intid <= VGIC_MAX_SPI)
 		return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
 
-	/* LPIs are not yet covered */
+	/* LPIs */
 	if (intid >= VGIC_MIN_LPI)
-		return NULL;
+		return vgic_get_lpi(kvm, intid);
 
 	WARN(1, "Looking up struct vgic_irq for reserved INTID");
 	return NULL;
@@ -78,18 +114,33 @@ static void vgic_get_irq_kref(struct vgic_irq *irq)
 	kref_get(&irq->refcount);
 }
 
-/* The refcount should never drop to 0 at the moment. */
+/*
+ * We can't do anything in here, because we lack the kvm pointer to
+ * lock and remove the item from the lpi_list. So we keep this function
+ * empty and use the return value of kref_put() to trigger the freeing.
+ */
 static void vgic_irq_release(struct kref *ref)
 {
-	WARN_ON(1);
 }
 
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 {
+	struct vgic_dist *dist;
+
 	if (irq->intid < VGIC_MIN_LPI)
 		return;
 
-	kref_put(&irq->refcount, vgic_irq_release);
+	if (!kref_put(&irq->refcount, vgic_irq_release))
+		return;
+
+	dist = &kvm->arch.vgic;
+
+	spin_lock(&dist->lpi_list_lock);
+	list_del(&irq->lpi_list);
+	dist->lpi_list_count--;
+	spin_unlock(&dist->lpi_list_lock);
+
+	kfree(irq);
 }
 
 /**
-- 
2.8.1
