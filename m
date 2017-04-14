From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v5 19/22] KVM: arm64: vgic-its: ITT save and restore
Date: Fri, 14 Apr 2017 12:15:31 +0200
Message-ID: <1492164934-988-20-git-send-email-eric.auger@redhat.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Introduce routines to save and restore device ITT and their
interrupt table entries (ITE).

The routines will be called on device table save and
restore. They will become static in subsequent patches.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v4 -> v5:
- ITE are now sorted by eventid on the flush
- rename *flush* into *save*
- use macros for shits and masks
- pass ite_esz to vgic_its_save_ite

v3 -> v4:
- lookup_table and compute_next_eventid_offset become static in this
  patch
- remove static along with vgic_its_flush/restore_itt to avoid
  compilation warnings
- next field only computed with a shift (mask removed)
- handle the case where the last element has not been found

v2 -> v3:
- add return 0 in vgic_its_restore_ite (was in subsequent patch)

v2: creation
---
 virt/kvm/arm/vgic/vgic-its.c | 128 ++++++++++++++++++++++++++++++++++++++++++-
 virt/kvm/arm/vgic/vgic.h     |   4 ++
 2 files changed, 129 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 35b2ca1..b02fc3f 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/uaccess.h>
+#include <linux/list_sort.h>
 
 #include <linux/irqchip/arm-gic-v3.h>
 
@@ -1695,7 +1696,7 @@ u32 compute_next_devid_offset(struct list_head *h, struct its_device *dev)
 	return min_t(u32, next_offset, VITS_DTE_MAX_DEVID_OFFSET);
 }
 
-u32 compute_next_eventid_offset(struct list_head *h, struct its_ite *ite)
+static u32 compute_next_eventid_offset(struct list_head *h, struct its_ite *ite)
 {
 	struct list_head *e = &ite->ite_list;
 	struct its_ite *next;
@@ -1737,8 +1738,8 @@ typedef int (*entry_fn_t)(struct vgic_its *its, u32 id, void *entry,
  *
  * Return: < 0 on error, 1 if last element identified, 0 otherwise
  */
-int lookup_table(struct vgic_its *its, gpa_t base, int size, int esz,
-		 int start_id, entry_fn_t fn, void *opaque)
+static int lookup_table(struct vgic_its *its, gpa_t base, int size, int esz,
+			int start_id, entry_fn_t fn, void *opaque)
 {
 	void *entry = kzalloc(esz, GFP_KERNEL);
 	struct kvm *kvm = its->dev->kvm;
@@ -1773,6 +1774,127 @@ int lookup_table(struct vgic_its *its, gpa_t base, int size, int esz,
 }
 
 /**
+ * vgic_its_save_ite - Save an interrupt translation entry at @gpa
+ */
+static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
+			      struct its_ite *ite, gpa_t gpa, int ite_esz)
+{
+	struct kvm *kvm = its->dev->kvm;
+	u32 next_offset;
+	u64 val;
+
+	next_offset = compute_next_eventid_offset(&dev->itt_head, ite);
+	val = ((u64)next_offset << KVM_ITS_ITE_NEXT_SHIFT) |
+	       ((u64)ite->lpi << KVM_ITS_ITE_PINTID_SHIFT) |
+		ite->collection->collection_id;
+	val = cpu_to_le64(val);
+	return kvm_write_guest(kvm, gpa, &val, ite_esz);
+}
+
+/**
+ * vgic_its_restore_ite - restore an interrupt translation entry
+ * @event_id: id used for indexing
+ * @ptr: pointer to the ITE entry
+ * @opaque: pointer to the its_device
+ * @next: id offset to the next entry
+ */
+static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
+				void *ptr, void *opaque, u32 *next)
+{
+	struct its_device *dev = (struct its_device *)opaque;
+	struct its_collection *collection;
+	struct kvm *kvm = its->dev->kvm;
+	u64 val, *p = (u64 *)ptr;
+	struct vgic_irq *irq;
+	u32 coll_id, lpi_id;
+	struct its_ite *ite;
+	int ret;
+
+	val = *p;
+	*next = 1;
+
+	val = le64_to_cpu(val);
+
+	coll_id = val & KVM_ITS_ITE_ICID_MASK;
+	lpi_id = (val & KVM_ITS_ITE_PINTID_MASK) >> KVM_ITS_ITE_PINTID_SHIFT;
+
+	if (!lpi_id)
+		return 0;
+
+	*next = val >> KVM_ITS_ITE_NEXT_SHIFT;
+
+	collection = find_collection(its, coll_id);
+	if (!collection)
+		return -EINVAL;
+
+	ret = vgic_its_alloc_ite(dev, &ite, collection,
+				  lpi_id, event_id);
+	if (ret)
+		return ret;
+
+	irq = vgic_add_lpi(kvm, lpi_id);
+	if (IS_ERR(irq))
+		return PTR_ERR(irq);
+	ite->irq = irq;
+
+	/* restore the configuration of the LPI */
+	ret = update_lpi_config(kvm, irq, NULL);
+	if (ret)
+		return ret;
+
+	update_affinity_ite(kvm, ite);
+	return 0;
+}
+
+static int vgic_its_ite_cmp(void *priv, struct list_head *a,
+			    struct list_head *b)
+{
+	struct its_ite *itea = container_of(a, struct its_ite, ite_list);
+	struct its_ite *iteb = container_of(b, struct its_ite, ite_list);
+
+	if (itea->event_id < iteb->event_id)
+		return -1;
+	else
+		return 1;
+}
+
+int vgic_its_save_itt(struct vgic_its *its, struct its_device *device)
+{
+	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
+	gpa_t base = device->itt_addr;
+	struct its_ite *ite;
+	int ret, ite_esz = abi->ite_esz;
+
+	list_sort(NULL, &device->itt_head, vgic_its_ite_cmp);
+
+	list_for_each_entry(ite, &device->itt_head, ite_list) {
+		gpa_t gpa = base + ite->event_id * ite_esz;
+
+		ret = vgic_its_save_ite(its, device, ite, gpa, ite_esz);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
+{
+	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
+	gpa_t base = dev->itt_addr;
+	int ret, ite_esz = abi->ite_esz;
+	size_t max_size = BIT_ULL(dev->nb_eventid_bits) * ite_esz;
+
+	ret =  lookup_table(its, base, max_size, ite_esz, 0,
+			    vgic_its_restore_ite, dev);
+
+	if (ret < 0)
+		return ret;
+
+	/* if the last element has not been found we are in trouble */
+	return ret ? 0 : -EINVAL;
+}
+
+/**
  * vgic_its_save_device_tables - Save the device table and all ITT
  * into guest RAM
  */
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 56e57c1..ce57fbd 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -81,6 +81,10 @@
 #define KVM_ITS_CTE_VALID_MASK		BIT_ULL(63)
 #define KVM_ITS_CTE_RDBASE_SHIFT	16
 #define KVM_ITS_CTE_ICID_MASK		GENMASK_ULL(15, 0)
+#define KVM_ITS_ITE_NEXT_SHIFT		48
+#define KVM_ITS_ITE_PINTID_SHIFT	16
+#define KVM_ITS_ITE_PINTID_MASK		GENMASK_ULL(47, 16)
+#define KVM_ITS_ITE_ICID_MASK		GENMASK_ULL(15, 0)
 
 static inline bool irq_is_pending(struct vgic_irq *irq)
 {
-- 
2.5.5
