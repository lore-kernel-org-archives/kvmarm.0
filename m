From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v7 22/24] KVM: arm64: vgic-its: ITT save and restore
Date: Sat,  6 May 2017 17:24:41 +0200
Message-ID: <1494084283-12723-23-git-send-email-eric.auger@redhat.com>
References: <1494084283-12723-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1494084283-12723-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com, bjsprakash.linux@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Implement routines to save and restore device ITT and their
interrupt table entries (ITE).

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>

---
v6 -> v7:
- added Christoffer's R-b

v5 -> v6:
- accomodate vgic_its_alloc_ite change of proto
- check LPI ID on restore, check eventid offset
- initializations on separate line
- coming after device save/restore
- add_lpi does config and pending bit sync

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
 virt/kvm/arm/vgic/vgic-its.c | 116 +++++++++++++++++++++++++++++++++++++++++--
 virt/kvm/arm/vgic/vgic.h     |   4 ++
 2 files changed, 117 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 3dea626..adb3d9e 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1750,7 +1750,7 @@ static u32 compute_next_devid_offset(struct list_head *h,
 	return min_t(u32, next_offset, VITS_DTE_MAX_DEVID_OFFSET);
 }
 
-u32 compute_next_eventid_offset(struct list_head *h, struct its_ite *ite)
+static u32 compute_next_eventid_offset(struct list_head *h, struct its_ite *ite)
 {
 	struct its_ite *next;
 	u32 next_offset;
@@ -1827,14 +1827,124 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, int esz,
 	return ret;
 }
 
+/**
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
+ */
+static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
+				void *ptr, void *opaque)
+{
+	struct its_device *dev = (struct its_device *)opaque;
+	struct its_collection *collection;
+	struct kvm *kvm = its->dev->kvm;
+	struct kvm_vcpu *vcpu = NULL;
+	u64 val;
+	u64 *p = (u64 *)ptr;
+	struct vgic_irq *irq;
+	u32 coll_id, lpi_id;
+	struct its_ite *ite;
+	u32 offset;
+
+	val = *p;
+
+	val = le64_to_cpu(val);
+
+	coll_id = val & KVM_ITS_ITE_ICID_MASK;
+	lpi_id = (val & KVM_ITS_ITE_PINTID_MASK) >> KVM_ITS_ITE_PINTID_SHIFT;
+
+	if (!lpi_id)
+		return 1; /* invalid entry, no choice but to scan next entry */
+
+	if (lpi_id < VGIC_MIN_LPI)
+		return -EINVAL;
+
+	offset = val >> KVM_ITS_ITE_NEXT_SHIFT;
+	if (event_id + offset >= BIT_ULL(dev->num_eventid_bits))
+		return -EINVAL;
+
+	collection = find_collection(its, coll_id);
+	if (!collection)
+		return -EINVAL;
+
+	ite = vgic_its_alloc_ite(dev, collection, lpi_id, event_id);
+	if (IS_ERR(ite))
+		return PTR_ERR(ite);
+
+	if (its_is_collection_mapped(collection))
+		vcpu = kvm_get_vcpu(kvm, collection->target_addr);
+
+	irq = vgic_add_lpi(kvm, lpi_id, vcpu);
+	if (IS_ERR(irq))
+		return PTR_ERR(irq);
+	ite->irq = irq;
+
+	return offset;
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
 static int vgic_its_save_itt(struct vgic_its *its, struct its_device *device)
 {
-	return -ENXIO;
+	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
+	gpa_t base = device->itt_addr;
+	struct its_ite *ite;
+	int ret;
+	int ite_esz = abi->ite_esz;
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
 }
 
 static int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
 {
-	return -ENXIO;
+	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
+	gpa_t base = dev->itt_addr;
+	int ret;
+	int ite_esz = abi->ite_esz;
+	size_t max_size = BIT_ULL(dev->num_eventid_bits) * ite_esz;
+
+	ret = scan_its_table(its, base, max_size, ite_esz, 0,
+			     vgic_its_restore_ite, dev);
+
+	return ret;
 }
 
 /**
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index e896114..92a8ca0 100644
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
 #define KVM_ITS_DTE_VALID_SHIFT		63
 #define KVM_ITS_DTE_VALID_MASK		BIT_ULL(63)
 #define KVM_ITS_DTE_NEXT_SHIFT		49
-- 
2.5.5
