From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v6 10/15] KVM: arm64: connect LPIs to the VGIC emulation
Date: Fri, 17 Jun 2016 13:08:42 +0100
Message-ID: <1466165327-32060-11-git-send-email-andre.przywara@arm.com>
References: <1466165327-32060-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1466165327-32060-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

LPIs are dynamically created (mapped) at guest runtime and their
actual number can be quite high, but is mostly assigned using a very
sparse allocation scheme. So arrays are not an ideal data structure
to hold the information.
We use an RCU protected list to hold all mapped LPIs. vgic_its_get_lpi()
iterates the list using RCU list primitives, so it's safe to be called
from an non-preemptible context like the KVM exit/entry path.
Also we store a pointer to that struct vgic_irq in our struct its_itte,
so we can easily access it.
Eventually we call our new vgic_its_get_lpi() from vgic_get_irq(), so
the VGIC code gets transparently access to LPIs.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/vgic/vgic.h       |  5 +++
 virt/kvm/arm/vgic/vgic-init.c |  3 ++
 virt/kvm/arm/vgic/vgic-its.c  | 92 ++++++++++++++++++++++++++++++++++++++++++-
 virt/kvm/arm/vgic/vgic-v3.c   |  2 +
 virt/kvm/arm/vgic/vgic.c      |  9 +++--
 virt/kvm/arm/vgic/vgic.h      |  6 +++
 6 files changed, 111 insertions(+), 6 deletions(-)

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index 891775e..fdc2781 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -77,6 +77,8 @@ enum vgic_irq_config {
 
 struct vgic_irq {
 	spinlock_t irq_lock;		/* Protects the content of the struct */
+	struct list_head lpi_entry;	/* Used to link all LPIs together */
+	struct rcu_head  rcu;
 	struct list_head ap_list;
 
 	struct kvm_vcpu *vcpu;		/* SGIs and PPIs: The VCPU
@@ -181,6 +183,9 @@ struct vgic_dist {
 	 * GICv3 spec: 6.1.2 "LPI Configuration tables"
 	 */
 	u64			propbaser;
+
+	struct list_head	lpi_list_head;
+	struct mutex		lpi_list_lock;
 };
 
 struct vgic_v2_cpu_if {
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index c4a8df6..d22b094 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -157,6 +157,9 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
 	struct kvm_vcpu *vcpu0 = kvm_get_vcpu(kvm, 0);
 	int i;
 
+	INIT_LIST_HEAD(&dist->lpi_list_head);
+	mutex_init(&dist->lpi_list_lock);
+
 	dist->spis = kcalloc(nr_spis, sizeof(struct vgic_irq), GFP_KERNEL);
 	if (!dist->spis)
 		return  -ENOMEM;
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index d7f8834..9ef951f7 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -22,6 +22,7 @@
 #include <linux/kvm_host.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
+#include <linux/rculist.h>
 #include <linux/uaccess.h>
 
 #include <linux/irqchip/arm-gic-v3.h>
@@ -33,6 +34,85 @@
 #include "vgic.h"
 #include "vgic-mmio.h"
 
+/*
+ * Iterate over the VM's list of mapped LPIs to find the one with a
+ * matching INTID, _lock that_ and return a pointer to the IRQ structure.
+ * Although the corresponding LPI could be unmapped (removed from the ITS
+ * data structures) even when someone holds the IRQ lock, the reference to
+ * this struct vgic_irq stays valid within the VGIC context at least until
+ * the lock gets dropped.
+ */
+struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_irq *irq = NULL;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(irq, &dist->lpi_list_head, lpi_entry) {
+		if (irq->intid != intid)
+			continue;
+
+		spin_lock(&irq->irq_lock);
+		goto out_unlock;
+	}
+	irq = NULL;
+
+out_unlock:
+	rcu_read_unlock();
+
+	return irq;
+}
+
+static void vgic_free_irq_rcu(struct rcu_head *head)
+{
+	struct vgic_irq *irq = container_of(head, struct vgic_irq, rcu);
+
+	kfree(irq);
+}
+
+/*
+ * Drops a reference to an LPI. This is called whenever one ITS unmaps
+ * the LPI: it decreases the refcount and frees the structure if the
+ * refcount has reached zero.
+ * If this LPI is still referenced by another LPI and is on a VCPU at the
+ * moment, the removal will be deferred until those references go away as well.
+ */
+int vgic_drop_lpi(struct kvm *kvm, u32 intid)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_irq *irq, *temp;
+
+	mutex_lock(&dist->lpi_list_lock);
+	list_for_each_entry_safe(irq, temp, &dist->lpi_list_head, lpi_entry) {
+		if (irq->intid != intid)
+			continue;
+
+		spin_lock(&irq->irq_lock);
+
+		irq->refcnt--;
+		if (!irq->refcnt) {
+			list_del_rcu(&irq->lpi_entry);
+			spin_unlock(&irq->irq_lock);
+			call_rcu(&irq->rcu, vgic_free_irq_rcu);
+		} else {
+			/*
+			 * If the refcnt is not zero here, this could be due to
+			 * two cases:
+			 * 1) it's referenced by another ITS: then the last ITS
+			 *    will free the IRQ once it is done with it
+			 * 2) it's on a VCPU at the moment: upon returning from
+			 *    the guest vgic_prune_ap_list() will free the IRQ
+			 */
+			spin_unlock(&irq->irq_lock);
+		}
+		break;
+	}
+
+	mutex_unlock(&dist->lpi_list_lock);
+
+	return 0;
+}
+
 struct its_device {
 	struct list_head dev_list;
 
@@ -56,11 +136,17 @@ struct its_collection {
 struct its_itte {
 	struct list_head itte_list;
 
+	struct vgic_irq *irq;
 	struct its_collection *collection;
 	u32 lpi;
 	u32 event_id;
 };
 
+/* To be used as an iterator this macro misses the enclosing parentheses */
+#define for_each_lpi_its(dev, itte, its) \
+	list_for_each_entry(dev, &(its)->device_list, dev_list) \
+		list_for_each_entry(itte, &(dev)->itt_head, itte_list)
+
 #define CBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 12))
 #define BASER_ADDRESS(x)	((x) & GENMASK_ULL(47, 12))
 
@@ -148,9 +234,11 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
 	return 0;
 }
 
-static void its_free_itte(struct its_itte *itte)
+static void its_free_itte(struct kvm *kvm, struct its_itte *itte)
 {
 	list_del(&itte->itte_list);
+	vgic_drop_lpi(kvm, itte->lpi);
+
 	kfree(itte);
 }
 
@@ -404,7 +492,7 @@ static void vits_destroy(struct kvm *kvm, struct vgic_its *its)
 		dev = container_of(dev_cur, struct its_device, dev_list);
 		list_for_each_safe(cur, temp, &dev->itt_head) {
 			itte = (container_of(cur, struct its_itte, itte_list));
-			its_free_itte(itte);
+			its_free_itte(kvm, itte);
 		}
 		list_del(dev_cur);
 		kfree(dev);
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 21d84e9..74ab7a6 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -81,6 +81,8 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 		else
 			intid = val & GICH_LR_VIRTUALID;
 		irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
+		if (!irq)	/* An LPI could have been unmapped. */
+			continue;
 
 		/* Always preserve the active bit */
 		irq->active = !!(val & ICH_LR_ACTIVE_BIT);
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 90f2543..4655ae4 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -63,12 +63,13 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 		return irq;
 	}
 
-	/* LPIs are not yet covered */
-	if (intid >= VGIC_MIN_LPI)
+	if (intid < VGIC_MIN_LPI) {
+		WARN(1, "Looking up struct vgic_irq for reserved INTID");
 		return NULL;
+	}
 
-	WARN(1, "Looking up struct vgic_irq for reserved INTID");
-	return NULL;
+	/* LPIs */
+	return vgic_its_get_lpi(kvm, intid);
 }
 
 /**
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 24150f7..558252d 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -81,6 +81,7 @@ int vgic_v3_map_resources(struct kvm *kvm);
 int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
 bool vgic_has_its(struct kvm *kvm);
 int kvm_vgic_register_its_device(void);
+struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid);
 #else
 static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
 {
@@ -142,6 +143,11 @@ static inline int kvm_vgic_register_its_device(void)
 {
 	return -ENODEV;
 }
+
+static inline struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid)
+{
+	return NULL;
+}
 #endif
 
 int kvm_register_vgic_device(unsigned long type);
-- 
2.8.2

