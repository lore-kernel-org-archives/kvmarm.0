From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v5 03/22] KVM: arm/arm64: vgic-its: rename itte into ite
Date: Fri, 14 Apr 2017 12:15:15 +0200
Message-ID: <1492164934-988-4-git-send-email-eric.auger@redhat.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

The actual abbreviation for the interrupt translation table entry
is ITE. Let's rename all itte instances by ite.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>

---

v5: Add Marc's A-b
---
 virt/kvm/arm/vgic/vgic-its.c | 148 +++++++++++++++++++++----------------------
 1 file changed, 74 insertions(+), 74 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 8d1da1a..3ffcbbe 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -114,8 +114,8 @@ struct its_collection {
 #define its_is_collection_mapped(coll) ((coll) && \
 				((coll)->target_addr != COLLECTION_NOT_MAPPED))
 
-struct its_itte {
-	struct list_head itte_list;
+struct its_ite {
+	struct list_head ite_list;
 
 	struct vgic_irq *irq;
 	struct its_collection *collection;
@@ -143,27 +143,27 @@ static struct its_device *find_its_device(struct vgic_its *its, u32 device_id)
  * Device ID/Event ID pair on an ITS.
  * Must be called with the its_lock mutex held.
  */
-static struct its_itte *find_itte(struct vgic_its *its, u32 device_id,
+static struct its_ite *find_ite(struct vgic_its *its, u32 device_id,
 				  u32 event_id)
 {
 	struct its_device *device;
-	struct its_itte *itte;
+	struct its_ite *ite;
 
 	device = find_its_device(its, device_id);
 	if (device == NULL)
 		return NULL;
 
-	list_for_each_entry(itte, &device->itt_head, itte_list)
-		if (itte->event_id == event_id)
-			return itte;
+	list_for_each_entry(ite, &device->itt_head, ite_list)
+		if (ite->event_id == event_id)
+			return ite;
 
 	return NULL;
 }
 
 /* To be used as an iterator this macro misses the enclosing parentheses */
-#define for_each_lpi_its(dev, itte, its) \
+#define for_each_lpi_its(dev, ite, its) \
 	list_for_each_entry(dev, &(its)->device_list, dev_list) \
-		list_for_each_entry(itte, &(dev)->itt_head, itte_list)
+		list_for_each_entry(ite, &(dev)->itt_head, ite_list)
 
 /*
  * We only implement 48 bits of PA at the moment, although the ITS
@@ -270,18 +270,18 @@ static int vgic_copy_lpi_list(struct kvm *kvm, u32 **intid_ptr)
  * Needs to be called whenever either the collection for a LPIs has
  * changed or the collection itself got retargeted.
  */
-static void update_affinity_itte(struct kvm *kvm, struct its_itte *itte)
+static void update_affinity_ite(struct kvm *kvm, struct its_ite *ite)
 {
 	struct kvm_vcpu *vcpu;
 
-	if (!its_is_collection_mapped(itte->collection))
+	if (!its_is_collection_mapped(ite->collection))
 		return;
 
-	vcpu = kvm_get_vcpu(kvm, itte->collection->target_addr);
+	vcpu = kvm_get_vcpu(kvm, ite->collection->target_addr);
 
-	spin_lock(&itte->irq->irq_lock);
-	itte->irq->target_vcpu = vcpu;
-	spin_unlock(&itte->irq->irq_lock);
+	spin_lock(&ite->irq->irq_lock);
+	ite->irq->target_vcpu = vcpu;
+	spin_unlock(&ite->irq->irq_lock);
 }
 
 /*
@@ -292,13 +292,13 @@ static void update_affinity_collection(struct kvm *kvm, struct vgic_its *its,
 				       struct its_collection *coll)
 {
 	struct its_device *device;
-	struct its_itte *itte;
+	struct its_ite *ite;
 
-	for_each_lpi_its(device, itte, its) {
-		if (!itte->collection || coll != itte->collection)
+	for_each_lpi_its(device, ite, its) {
+		if (!ite->collection || coll != ite->collection)
 			continue;
 
-		update_affinity_itte(kvm, itte);
+		update_affinity_ite(kvm, ite);
 	}
 }
 
@@ -425,25 +425,25 @@ static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
 				u32 devid, u32 eventid)
 {
 	struct kvm_vcpu *vcpu;
-	struct its_itte *itte;
+	struct its_ite *ite;
 
 	if (!its->enabled)
 		return -EBUSY;
 
-	itte = find_itte(its, devid, eventid);
-	if (!itte || !its_is_collection_mapped(itte->collection))
+	ite = find_ite(its, devid, eventid);
+	if (!ite || !its_is_collection_mapped(ite->collection))
 		return E_ITS_INT_UNMAPPED_INTERRUPT;
 
-	vcpu = kvm_get_vcpu(kvm, itte->collection->target_addr);
+	vcpu = kvm_get_vcpu(kvm, ite->collection->target_addr);
 	if (!vcpu)
 		return E_ITS_INT_UNMAPPED_INTERRUPT;
 
 	if (!vcpu->arch.vgic_cpu.lpis_enabled)
 		return -EBUSY;
 
-	spin_lock(&itte->irq->irq_lock);
-	itte->irq->pending_latch = true;
-	vgic_queue_irq_unlock(kvm, itte->irq);
+	spin_lock(&ite->irq->irq_lock);
+	ite->irq->pending_latch = true;
+	vgic_queue_irq_unlock(kvm, ite->irq);
 
 	return 0;
 }
@@ -511,15 +511,15 @@ int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
 }
 
 /* Requires the its_lock to be held. */
-static void its_free_itte(struct kvm *kvm, struct its_itte *itte)
+static void its_free_ite(struct kvm *kvm, struct its_ite *ite)
 {
-	list_del(&itte->itte_list);
+	list_del(&ite->ite_list);
 
 	/* This put matches the get in vgic_add_lpi. */
-	if (itte->irq)
-		vgic_put_irq(kvm, itte->irq);
+	if (ite->irq)
+		vgic_put_irq(kvm, ite->irq);
 
-	kfree(itte);
+	kfree(ite);
 }
 
 static u64 its_cmd_mask_field(u64 *its_cmd, int word, int shift, int size)
@@ -544,17 +544,17 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
 {
 	u32 device_id = its_cmd_get_deviceid(its_cmd);
 	u32 event_id = its_cmd_get_id(its_cmd);
-	struct its_itte *itte;
+	struct its_ite *ite;
 
 
-	itte = find_itte(its, device_id, event_id);
-	if (itte && itte->collection) {
+	ite = find_ite(its, device_id, event_id);
+	if (ite && ite->collection) {
 		/*
 		 * Though the spec talks about removing the pending state, we
 		 * don't bother here since we clear the ITTE anyway and the
 		 * pending state is a property of the ITTE struct.
 		 */
-		its_free_itte(kvm, itte);
+		its_free_ite(kvm, ite);
 		return 0;
 	}
 
@@ -572,26 +572,26 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
 	u32 event_id = its_cmd_get_id(its_cmd);
 	u32 coll_id = its_cmd_get_collection(its_cmd);
 	struct kvm_vcpu *vcpu;
-	struct its_itte *itte;
+	struct its_ite *ite;
 	struct its_collection *collection;
 
-	itte = find_itte(its, device_id, event_id);
-	if (!itte)
+	ite = find_ite(its, device_id, event_id);
+	if (!ite)
 		return E_ITS_MOVI_UNMAPPED_INTERRUPT;
 
-	if (!its_is_collection_mapped(itte->collection))
+	if (!its_is_collection_mapped(ite->collection))
 		return E_ITS_MOVI_UNMAPPED_COLLECTION;
 
 	collection = find_collection(its, coll_id);
 	if (!its_is_collection_mapped(collection))
 		return E_ITS_MOVI_UNMAPPED_COLLECTION;
 
-	itte->collection = collection;
+	ite->collection = collection;
 	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
 
-	spin_lock(&itte->irq->irq_lock);
-	itte->irq->target_vcpu = vcpu;
-	spin_unlock(&itte->irq->irq_lock);
+	spin_lock(&ite->irq->irq_lock);
+	ite->irq->target_vcpu = vcpu;
+	spin_unlock(&ite->irq->irq_lock);
 
 	return 0;
 }
@@ -679,7 +679,7 @@ static void vgic_its_free_collection(struct vgic_its *its, u32 coll_id)
 {
 	struct its_collection *collection;
 	struct its_device *device;
-	struct its_itte *itte;
+	struct its_ite *ite;
 
 	/*
 	 * Clearing the mapping for that collection ID removes the
@@ -690,10 +690,10 @@ static void vgic_its_free_collection(struct vgic_its *its, u32 coll_id)
 	if (!collection)
 		return;
 
-	for_each_lpi_its(device, itte, its)
-		if (itte->collection &&
-		    itte->collection->collection_id == coll_id)
-			itte->collection = NULL;
+	for_each_lpi_its(device, ite, its)
+		if (ite->collection &&
+		    ite->collection->collection_id == coll_id)
+			ite->collection = NULL;
 
 	list_del(&collection->coll_list);
 	kfree(collection);
@@ -709,7 +709,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	u32 device_id = its_cmd_get_deviceid(its_cmd);
 	u32 event_id = its_cmd_get_id(its_cmd);
 	u32 coll_id = its_cmd_get_collection(its_cmd);
-	struct its_itte *itte;
+	struct its_ite *ite;
 	struct its_device *device;
 	struct its_collection *collection, *new_coll = NULL;
 	int lpi_nr;
@@ -728,7 +728,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 		return E_ITS_MAPTI_PHYSICALID_OOR;
 
 	/* If there is an existing mapping, behavior is UNPREDICTABLE. */
-	if (find_itte(its, device_id, event_id))
+	if (find_ite(its, device_id, event_id))
 		return 0;
 
 	collection = find_collection(its, coll_id);
@@ -739,36 +739,36 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 		new_coll = collection;
 	}
 
-	itte = kzalloc(sizeof(struct its_itte), GFP_KERNEL);
-	if (!itte) {
+	ite = kzalloc(sizeof(struct its_ite), GFP_KERNEL);
+	if (!ite) {
 		if (new_coll)
 			vgic_its_free_collection(its, coll_id);
 		return -ENOMEM;
 	}
 
-	itte->event_id	= event_id;
-	list_add_tail(&itte->itte_list, &device->itt_head);
+	ite->event_id	= event_id;
+	list_add_tail(&ite->ite_list, &device->itt_head);
 
-	itte->collection = collection;
-	itte->lpi = lpi_nr;
+	ite->collection = collection;
+	ite->lpi = lpi_nr;
 
 	irq = vgic_add_lpi(kvm, lpi_nr);
 	if (IS_ERR(irq)) {
 		if (new_coll)
 			vgic_its_free_collection(its, coll_id);
-		its_free_itte(kvm, itte);
+		its_free_ite(kvm, ite);
 		return PTR_ERR(irq);
 	}
-	itte->irq = irq;
+	ite->irq = irq;
 
-	update_affinity_itte(kvm, itte);
+	update_affinity_ite(kvm, ite);
 
 	/*
 	 * We "cache" the configuration table entries in out struct vgic_irq's.
 	 * However we only have those structs for mapped IRQs, so we read in
 	 * the respective config data from memory here upon mapping the LPI.
 	 */
-	update_lpi_config(kvm, itte->irq, NULL);
+	update_lpi_config(kvm, ite->irq, NULL);
 
 	return 0;
 }
@@ -776,15 +776,15 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 /* Requires the its_lock to be held. */
 static void vgic_its_unmap_device(struct kvm *kvm, struct its_device *device)
 {
-	struct its_itte *itte, *temp;
+	struct its_ite *ite, *temp;
 
 	/*
 	 * The spec says that unmapping a device with still valid
 	 * ITTEs associated is UNPREDICTABLE. We remove all ITTEs,
 	 * since we cannot leave the memory unreferenced.
 	 */
-	list_for_each_entry_safe(itte, temp, &device->itt_head, itte_list)
-		its_free_itte(kvm, itte);
+	list_for_each_entry_safe(ite, temp, &device->itt_head, ite_list)
+		its_free_ite(kvm, ite);
 
 	list_del(&device->dev_list);
 	kfree(device);
@@ -883,14 +883,14 @@ static int vgic_its_cmd_handle_clear(struct kvm *kvm, struct vgic_its *its,
 {
 	u32 device_id = its_cmd_get_deviceid(its_cmd);
 	u32 event_id = its_cmd_get_id(its_cmd);
-	struct its_itte *itte;
+	struct its_ite *ite;
 
 
-	itte = find_itte(its, device_id, event_id);
-	if (!itte)
+	ite = find_ite(its, device_id, event_id);
+	if (!ite)
 		return E_ITS_CLEAR_UNMAPPED_INTERRUPT;
 
-	itte->irq->pending_latch = false;
+	ite->irq->pending_latch = false;
 
 	return 0;
 }
@@ -904,14 +904,14 @@ static int vgic_its_cmd_handle_inv(struct kvm *kvm, struct vgic_its *its,
 {
 	u32 device_id = its_cmd_get_deviceid(its_cmd);
 	u32 event_id = its_cmd_get_id(its_cmd);
-	struct its_itte *itte;
+	struct its_ite *ite;
 
 
-	itte = find_itte(its, device_id, event_id);
-	if (!itte)
+	ite = find_ite(its, device_id, event_id);
+	if (!ite)
 		return E_ITS_INV_UNMAPPED_INTERRUPT;
 
-	return update_lpi_config(kvm, itte->irq, NULL);
+	return update_lpi_config(kvm, ite->irq, NULL);
 }
 
 /*
@@ -1435,7 +1435,7 @@ static void vgic_its_destroy(struct kvm_device *kvm_dev)
 	struct kvm *kvm = kvm_dev->kvm;
 	struct vgic_its *its = kvm_dev->private;
 	struct its_device *dev;
-	struct its_itte *itte;
+	struct its_ite *ite;
 	struct list_head *dev_cur, *dev_temp;
 	struct list_head *cur, *temp;
 
@@ -1450,8 +1450,8 @@ static void vgic_its_destroy(struct kvm_device *kvm_dev)
 	list_for_each_safe(dev_cur, dev_temp, &its->device_list) {
 		dev = container_of(dev_cur, struct its_device, dev_list);
 		list_for_each_safe(cur, temp, &dev->itt_head) {
-			itte = (container_of(cur, struct its_itte, itte_list));
-			its_free_itte(kvm, itte);
+			ite = (container_of(cur, struct its_ite, ite_list));
+			its_free_ite(kvm, ite);
 		}
 		list_del(dev_cur);
 		kfree(dev);
-- 
2.5.5
