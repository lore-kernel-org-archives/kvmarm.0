From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v6 13/15] KVM: arm64: implement ITS command queue command
 handlers
Date: Fri, 17 Jun 2016 13:08:45 +0100
Message-ID: <1466165327-32060-14-git-send-email-andre.przywara@arm.com>
References: <1466165327-32060-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC52749B8F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2016 08:04:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5VzD8W62RGSm for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2016 08:04:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A74C49B87
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2016 08:04:19 -0400 (EDT)
In-Reply-To: <1466165327-32060-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The connection between a device, an event ID, the LPI number and the
allocated CPU is stored in in-memory tables in a GICv3, but their
format is not specified by the spec. Instead software uses a command
queue in a ring buffer to let the ITS implementation use their own
format.
Implement handlers for the various ITS commands and let them store
the requested relation into our own data structures. Those data
structures are protected by the its_lock mutex.
Our internal ring buffer read and write pointers are protected by the
its_cmd mutex, so that at most one VCPU per ITS can handle commands at
any given time.
Error handling is very basic at the moment, as we don't have a good
way of communicating errors to the guest (usually a SError).
The INT command handler is missing at this point, as we gain the
capability of actually injecting MSIs into the guest only later on.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/linux/irqchip/arm-gic-v3.h |  19 +-
 virt/kvm/arm/vgic/vgic-its.c       | 594 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 610 insertions(+), 3 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index fe5a7fe..4b165e2 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -256,7 +256,10 @@
  */
 #define GITS_CMD_MAPD			0x08
 #define GITS_CMD_MAPC			0x09
-#define GITS_CMD_MAPVI			0x0a
+#define GITS_CMD_MAPTI			0x0a
+/* older GIC documentation used MAPVI for this command */
+#define GITS_CMD_MAPVI			GITS_CMD_MAPTI
+#define GITS_CMD_MAPI			0x0b
 #define GITS_CMD_MOVI			0x01
 #define GITS_CMD_DISCARD		0x0f
 #define GITS_CMD_INV			0x0c
@@ -267,6 +270,20 @@
 #define GITS_CMD_SYNC			0x05
 
 /*
+ * ITS error numbers
+ */
+#define E_ITS_MOVI_UNMAPPED_INTERRUPT           0x010107
+#define E_ITS_MOVI_UNMAPPED_COLLECTION          0x010109
+#define E_ITS_CLEAR_UNMAPPED_INTERRUPT          0x010507
+#define E_ITS_MAPC_PROCNUM_OOR                  0x010902
+#define E_ITS_MAPTI_UNMAPPED_DEVICE             0x010a04
+#define E_ITS_MAPTI_PHYSICALID_OOR              0x010a06
+#define E_ITS_INV_UNMAPPED_INTERRUPT            0x010c07
+#define E_ITS_INVALL_UNMAPPED_COLLECTION        0x010d09
+#define E_ITS_MOVALL_PROCNUM_OOR                0x010e01
+#define E_ITS_DISCARD_UNMAPPED_INTERRUPT        0x010f07
+
+/*
  * CPU interface registers
  */
 #define ICC_CTLR_EL1_EOImode_drop_dir	(0U << 1)
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 285cbe6..c2a4b88 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/rculist.h>
+#include <linux/slab.h>
 #include <linux/uaccess.h>
 
 #include <linux/irqchip/arm-gic-v3.h>
@@ -63,6 +64,45 @@ out_unlock:
 	return irq;
 }
 
+/*
+ * Creates a new (reference to a) struct vgic_irq for a given LPI.
+ * If this LPI is already mapped on another ITS, we increase its refcount
+ * and return a pointer to the existing structure.
+ * If this is a "new" LPI, we allocate and initialize a new struct vgic_irq.
+ * This function returns a pointer to the _unlocked_ structure.
+ */
+static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_irq *irq = vgic_its_get_lpi(kvm, intid);
+
+	if (irq) {
+		irq->refcnt++;
+		spin_unlock(&irq->irq_lock);
+
+		return irq;
+	}
+
+	irq = kzalloc(sizeof(struct vgic_irq), GFP_KERNEL);
+
+	if (!irq)
+		return NULL;
+
+	INIT_LIST_HEAD(&irq->lpi_entry);
+	INIT_LIST_HEAD(&irq->ap_list);
+	spin_lock_init(&irq->irq_lock);
+
+	irq->config = VGIC_CONFIG_EDGE;
+	irq->refcnt = 1;
+	irq->intid = intid;
+
+	mutex_lock(&dist->lpi_list_lock);
+	list_add_tail_rcu(&irq->lpi_entry, &dist->lpi_list_head);
+	mutex_unlock(&dist->lpi_list_lock);
+
+	return irq;
+}
+
 static void vgic_free_irq_rcu(struct rcu_head *head)
 {
 	struct vgic_irq *irq = container_of(head, struct vgic_irq, rcu);
@@ -142,6 +182,43 @@ struct its_itte {
 	u32 event_id;
 };
 
+/*
+ * Find and returns a device in the device table for an ITS.
+ * Must be called with the its_lock held.
+ */
+static struct its_device *find_its_device(struct vgic_its *its, u32 device_id)
+{
+	struct its_device *device;
+
+	list_for_each_entry(device, &its->device_list, dev_list)
+		if (device_id == device->device_id)
+			return device;
+
+	return NULL;
+}
+
+/*
+ * Find and returns an interrupt translation table entry (ITTE) for a given
+ * Device ID/Event ID pair on an ITS.
+ * Must be called with the its_lock held.
+ */
+static struct its_itte *find_itte(struct vgic_its *its, u32 device_id,
+				  u32 event_id)
+{
+	struct its_device *device;
+	struct its_itte *itte;
+
+	device = find_its_device(its, device_id);
+	if (device == NULL)
+		return NULL;
+
+	list_for_each_entry(itte, &device->itt_head, itte_list)
+		if (itte->event_id == event_id)
+			return itte;
+
+	return NULL;
+}
+
 /* To be used as an iterator this macro misses the enclosing parentheses */
 #define for_each_lpi_its(dev, itte, its) \
 	list_for_each_entry(dev, &(its)->device_list, dev_list) \
@@ -154,6 +231,22 @@ struct its_itte {
 
 #define GIC_LPI_OFFSET 8192
 
+/*
+ * Finds and returns a collection in the ITS collection table.
+ * Must be called with the its_lock held.
+ */
+static struct its_collection *find_collection(struct vgic_its *its, int coll_id)
+{
+	struct its_collection *collection;
+
+	list_for_each_entry(collection, &its->collection_list, coll_list) {
+		if (coll_id == collection->collection_id)
+			return collection;
+	}
+
+	return NULL;
+}
+
 #define LPI_PROP_ENABLE_BIT(p)	((p) & LPI_PROP_ENABLED)
 #define LPI_PROP_PRIORITY(p)	((p) & 0xfc)
 
@@ -191,12 +284,54 @@ static int update_lpi_config_filtered(struct kvm *kvm, struct vgic_irq *irq,
 }
 
 /* Updates the priority and enable bit for a given LPI. */
-int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq)
+static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq)
 {
 	return update_lpi_config_filtered(kvm, irq, NULL);
 }
 
 /*
+ * Promotes the ITS view of affinity of an ITTE (which redistributor this LPI
+ * is targeting) to the VGIC's view, which deals with target VCPUs.
+ * Needs to be called whenever either the collection for a LPIs has
+ * changed or the collection itself got retargeted.
+ */
+static void update_affinity_itte(struct kvm *kvm, struct its_itte *itte)
+{
+	struct kvm_vcpu *vcpu;
+
+	vcpu = kvm_get_vcpu(kvm, itte->collection->target_addr);
+
+	spin_lock(&itte->irq->irq_lock);
+	itte->irq->target_vcpu = vcpu;
+	spin_unlock(&itte->irq->irq_lock);
+}
+
+/*
+ * Updates the target VCPU for every LPI targeting this collection.
+ * Must be called with the its_lock held.
+ */
+static void update_affinity_collection(struct kvm *kvm, struct vgic_its *its,
+				       struct its_collection *coll)
+{
+	struct its_device *device;
+	struct its_itte *itte;
+
+	for_each_lpi_its(device, itte, its) {
+		if (!itte->collection || coll != itte->collection)
+			continue;
+
+		update_affinity_itte(kvm, itte);
+	}
+}
+
+static u32 max_lpis_propbaser(u64 propbaser)
+{
+	int nr_idbits = (propbaser & 0x1f) + 1;
+
+	return 1U << min(nr_idbits, INTERRUPT_ID_BITS_ITS);
+}
+
+/*
  * Scan the whole LPI pending table and sync the pending bit in there
  * with our own data structures. This relies on the LPI being
  * mapped before.
@@ -324,10 +459,465 @@ static void its_free_itte(struct kvm *kvm, struct its_itte *itte)
 	kfree(itte);
 }
 
+static u64 its_cmd_mask_field(u64 *its_cmd, int word, int shift, int size)
+{
+	return (le64_to_cpu(its_cmd[word]) >> shift) & (BIT_ULL(size) - 1);
+}
+
+#define its_cmd_get_command(cmd)	its_cmd_mask_field(cmd, 0,  0,  8)
+#define its_cmd_get_deviceid(cmd)	its_cmd_mask_field(cmd, 0, 32, 32)
+#define its_cmd_get_id(cmd)		its_cmd_mask_field(cmd, 1,  0, 32)
+#define its_cmd_get_physical_id(cmd)	its_cmd_mask_field(cmd, 1, 32, 32)
+#define its_cmd_get_collection(cmd)	its_cmd_mask_field(cmd, 2,  0, 16)
+#define its_cmd_get_target_addr(cmd)	its_cmd_mask_field(cmd, 2, 16, 32)
+#define its_cmd_get_validbit(cmd)	its_cmd_mask_field(cmd, 2, 63,  1)
+
+/* The DISCARD command frees an Interrupt Translation Table Entry (ITTE). */
+static int vits_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
+				   u64 *its_cmd)
+{
+	u32 device_id;
+	u32 event_id;
+	struct its_itte *itte;
+	int ret = E_ITS_DISCARD_UNMAPPED_INTERRUPT;
+
+	device_id = its_cmd_get_deviceid(its_cmd);
+	event_id = its_cmd_get_id(its_cmd);
+
+	mutex_lock(&its->its_lock);
+	itte = find_itte(its, device_id, event_id);
+	if (itte && itte->collection) {
+		/*
+		 * Though the spec talks about removing the pending state, we
+		 * don't bother here since we clear the ITTE anyway and the
+		 * pending state is a property of the ITTE struct.
+		 */
+		its_free_itte(kvm, itte);
+		ret = 0;
+	}
+
+	mutex_unlock(&its->its_lock);
+	return ret;
+}
+
+/* The MOVI command moves an ITTE to a different collection. */
+static int vits_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
+				u64 *its_cmd)
+{
+	u32 device_id = its_cmd_get_deviceid(its_cmd);
+	u32 event_id = its_cmd_get_id(its_cmd);
+	u32 coll_id = its_cmd_get_collection(its_cmd);
+	struct kvm_vcpu *vcpu;
+	struct its_itte *itte;
+	struct its_collection *collection;
+	int ret = 0;
+
+	mutex_lock(&its->its_lock);
+	itte = find_itte(its, device_id, event_id);
+	if (!itte) {
+		ret = E_ITS_MOVI_UNMAPPED_INTERRUPT;
+		goto out_unlock;
+	}
+	if (!its_is_collection_mapped(itte->collection)) {
+		ret = E_ITS_MOVI_UNMAPPED_COLLECTION;
+		goto out_unlock;
+	}
+
+	collection = find_collection(its, coll_id);
+	if (!its_is_collection_mapped(collection)) {
+		ret = E_ITS_MOVI_UNMAPPED_COLLECTION;
+		goto out_unlock;
+	}
+
+	itte->collection = collection;
+	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
+
+	spin_lock(&itte->irq->irq_lock);
+	itte->irq->target_vcpu = vcpu;
+	spin_unlock(&itte->irq->irq_lock);
+
+out_unlock:
+	mutex_unlock(&its->its_lock);
+	return ret;
+}
+
+static void vits_init_collection(struct vgic_its *its,
+				 struct its_collection *collection,
+				 u32 coll_id)
+{
+	collection->collection_id = coll_id;
+	collection->target_addr = COLLECTION_NOT_MAPPED;
+
+	list_add_tail(&collection->coll_list, &its->collection_list);
+}
+
+/* The MAPTI and MAPI commands map LPIs to ITTEs. */
+static int vits_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
+				u64 *its_cmd, u8 subcmd)
+{
+	u32 device_id = its_cmd_get_deviceid(its_cmd);
+	u32 event_id = its_cmd_get_id(its_cmd);
+	u32 coll_id = its_cmd_get_collection(its_cmd);
+	struct its_itte *itte;
+	struct its_device *device;
+	struct its_collection *collection, *new_coll = NULL;
+	int lpi_nr;
+	int ret = 0;
+
+	mutex_lock(&its->its_lock);
+
+	device = find_its_device(its, device_id);
+	if (!device) {
+		ret = E_ITS_MAPTI_UNMAPPED_DEVICE;
+		goto out_unlock;
+	}
+
+	collection = find_collection(its, coll_id);
+	if (!collection) {
+		new_coll = kzalloc(sizeof(struct its_collection), GFP_KERNEL);
+		if (!new_coll) {
+			ret = -ENOMEM;
+			goto out_unlock;
+		}
+	}
+
+	if (subcmd == GITS_CMD_MAPTI)
+		lpi_nr = its_cmd_get_physical_id(its_cmd);
+	else
+		lpi_nr = event_id;
+	if (lpi_nr < GIC_LPI_OFFSET ||
+	    lpi_nr >= max_lpis_propbaser(kvm->arch.vgic.propbaser))
+		return E_ITS_MAPTI_PHYSICALID_OOR;
+
+	itte = find_itte(its, device_id, event_id);
+	if (!itte) {
+		itte = kzalloc(sizeof(struct its_itte), GFP_KERNEL);
+		if (!itte) {
+			kfree(new_coll);
+			ret = -ENOMEM;
+			goto out_unlock;
+		}
+
+		itte->event_id	= event_id;
+		list_add_tail(&itte->itte_list, &device->itt_head);
+	}
+
+	if (!collection) {
+		collection = new_coll;
+		vits_init_collection(its, collection, coll_id);
+	}
+
+	itte->collection = collection;
+	itte->lpi = lpi_nr;
+	itte->irq = vgic_add_lpi(kvm, lpi_nr);
+	update_affinity_itte(kvm, itte);
+
+	/*
+	 * We "cache" the configuration table entries in out struct vgic_irq's.
+	 * However we only have those structs for mapped IRQs, so we read in
+	 * the respective config data from memory here upon mapping the LPI.
+	 */
+	update_lpi_config(kvm, itte->irq);
+
+out_unlock:
+	mutex_unlock(&its->its_lock);
+
+	return 0;
+}
+
+/* Requires the its_lock to be held. */
+static void vits_unmap_device(struct kvm *kvm, struct its_device *device)
+{
+	struct its_itte *itte, *temp;
+
+	/*
+	 * The spec says that unmapping a device with still valid
+	 * ITTEs associated is UNPREDICTABLE. We remove all ITTEs,
+	 * since we cannot leave the memory unreferenced.
+	 */
+	list_for_each_entry_safe(itte, temp, &device->itt_head, itte_list)
+		its_free_itte(kvm, itte);
+
+	list_del(&device->dev_list);
+	kfree(device);
+}
+
+/* MAPD maps or unmaps a device ID to Interrupt Translation Tables (ITTs). */
+static int vits_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
+				u64 *its_cmd)
+{
+	bool valid = its_cmd_get_validbit(its_cmd);
+	u32 device_id = its_cmd_get_deviceid(its_cmd);
+	struct its_device *device;
+	int ret = 0;
+
+	mutex_lock(&its->its_lock);
+
+	device = find_its_device(its, device_id);
+	if (device)
+		vits_unmap_device(kvm, device);
+
+	/*
+	 * The spec does not say whether unmapping a not-mapped device
+	 * is an error, so we are done in any case.
+	 */
+	if (!valid)
+		goto out_unlock;
+
+	device = kzalloc(sizeof(struct its_device), GFP_KERNEL);
+	if (!device) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
+	device->device_id = device_id;
+	INIT_LIST_HEAD(&device->itt_head);
+
+	list_add_tail(&device->dev_list, &its->device_list);
+
+out_unlock:
+	mutex_unlock(&its->its_lock);
+	return ret;
+}
+
+/* The MAPC command maps collection IDs to redistributors. */
+static int vits_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
+				u64 *its_cmd)
+{
+	u16 coll_id;
+	u32 target_addr;
+	struct its_collection *collection;
+	bool valid;
+	int ret = 0;
+
+	valid = its_cmd_get_validbit(its_cmd);
+	coll_id = its_cmd_get_collection(its_cmd);
+	target_addr = its_cmd_get_target_addr(its_cmd);
+
+	if (target_addr >= atomic_read(&kvm->online_vcpus))
+		return E_ITS_MAPC_PROCNUM_OOR;
+
+	mutex_lock(&its->its_lock);
+
+	collection = find_collection(its, coll_id);
+
+	if (!valid) {
+		struct its_device *device;
+		struct its_itte *itte;
+		/*
+		 * Clearing the mapping for that collection ID removes the
+		 * entry from the list. If there wasn't any before, we can
+		 * go home early.
+		 */
+		if (!collection)
+			goto out_unlock;
+
+		for_each_lpi_its(device, itte, its)
+			if (itte->collection &&
+			    itte->collection->collection_id == coll_id)
+				itte->collection = NULL;
+
+		list_del(&collection->coll_list);
+		kfree(collection);
+	} else {
+		if (!collection) {
+			collection = kzalloc(sizeof(struct its_collection),
+					     GFP_KERNEL);
+			if (!collection) {
+				ret = -ENOMEM;
+				goto out_unlock;
+			}
+		}
+
+		vits_init_collection(its, collection, coll_id);
+		collection->target_addr = target_addr;
+		update_affinity_collection(kvm, its, collection);
+	}
+
+out_unlock:
+	mutex_unlock(&its->its_lock);
+
+	return ret;
+}
+
+/* The CLEAR command removes the pending state for a particular LPI. */
+static int vits_cmd_handle_clear(struct kvm *kvm, struct vgic_its *its,
+				 u64 *its_cmd)
+{
+	u32 device_id;
+	u32 event_id;
+	struct its_itte *itte;
+	int ret = 0;
+
+	device_id = its_cmd_get_deviceid(its_cmd);
+	event_id = its_cmd_get_id(its_cmd);
+
+	mutex_lock(&its->its_lock);
+
+	itte = find_itte(its, device_id, event_id);
+	if (!itte) {
+		ret = E_ITS_CLEAR_UNMAPPED_INTERRUPT;
+		goto out_unlock;
+	}
+
+	itte->irq->pending = false;
+
+out_unlock:
+	mutex_unlock(&its->its_lock);
+	return ret;
+}
+
+/* The INV command syncs the configuration bits from the memory table. */
+static int vits_cmd_handle_inv(struct kvm *kvm, struct vgic_its *its,
+			       u64 *its_cmd)
+{
+	u32 device_id;
+	u32 event_id;
+	struct its_itte *itte;
+	int ret;
+
+	device_id = its_cmd_get_deviceid(its_cmd);
+	event_id = its_cmd_get_id(its_cmd);
+
+	mutex_lock(&its->its_lock);
+
+	itte = find_itte(its, device_id, event_id);
+	if (!itte) {
+		ret = E_ITS_INV_UNMAPPED_INTERRUPT;
+		goto out_unlock;
+	}
+
+	ret = update_lpi_config(kvm, itte->irq);
+
+out_unlock:
+	mutex_unlock(&its->its_lock);
+	return ret;
+}
+
+/*
+ * The INVALL command requests flushing of all IRQ data in this collection.
+ * Find the VCPU mapped to that collection, then iterate over the VM's list
+ * of mapped LPIs and update the configuration for each IRQ which targets
+ * the specified vcpu. The configuration will be read from the in-memory
+ * configuration table.
+ */
+static int vits_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
+				  u64 *its_cmd)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	u32 coll_id = its_cmd_get_collection(its_cmd);
+	struct its_collection *collection;
+	struct kvm_vcpu *vcpu;
+	struct vgic_irq *irq;
+
+	collection = find_collection(its, coll_id);
+	if (!its_is_collection_mapped(collection))
+		return E_ITS_INVALL_UNMAPPED_COLLECTION;
+
+	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
+
+	mutex_lock(&dist->lpi_list_lock);
+
+	list_for_each_entry(irq, &dist->lpi_list_head, lpi_entry)
+		update_lpi_config_filtered(kvm, irq, vcpu);
+
+	mutex_unlock(&dist->lpi_list_lock);
+
+	return 0;
+}
+
+/*
+ * The MOVALL command moves the pending state of all IRQs targeting one
+ * redistributor to another. We don't hold the pending state in the VCPUs,
+ * but in the IRQs instead, so there is really not much to do for us here.
+ * However the spec says that no IRQ must target the old redistributor
+ * afterwards, so we make sure that no LPI is using the associated target_vcpu.
+ * This command affects all LPIs in the system.
+ */
+static int vits_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
+				  u64 *its_cmd)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	u32 target1_addr = its_cmd_get_target_addr(its_cmd);
+	u32 target2_addr = its_cmd_mask_field(its_cmd, 3, 16, 32);
+	struct kvm_vcpu *vcpu1, *vcpu2;
+	struct vgic_irq *irq;
+
+	if (target1_addr >= atomic_read(&kvm->online_vcpus) ||
+	    target2_addr >= atomic_read(&kvm->online_vcpus))
+		return E_ITS_MOVALL_PROCNUM_OOR;
+
+	if (target1_addr == target2_addr)
+		return 0;
+
+	vcpu1 = kvm_get_vcpu(kvm, target1_addr);
+	vcpu2 = kvm_get_vcpu(kvm, target2_addr);
+
+	mutex_lock(&dist->lpi_list_lock);
+
+	list_for_each_entry(irq, &dist->lpi_list_head, lpi_entry) {
+		spin_lock(&irq->irq_lock);
+
+		if (irq->target_vcpu == vcpu1)
+			irq->target_vcpu = vcpu2;
+
+		spin_unlock(&irq->irq_lock);
+	}
+
+	mutex_unlock(&dist->lpi_list_lock);
+
+	return 0;
+}
+
+/*
+ * This function is called with the its_cmd lock held, but the ITS data
+ * structure lock dropped. It is within the responsibility of the actual
+ * command handlers to take care of proper locking when needed.
+ */
 static int vits_handle_command(struct kvm *kvm, struct vgic_its *its,
 			       u64 *its_cmd)
 {
-	return -ENODEV;
+	u8 cmd = its_cmd_get_command(its_cmd);
+	int ret = -ENODEV;
+
+	switch (cmd) {
+	case GITS_CMD_MAPD:
+		ret = vits_cmd_handle_mapd(kvm, its, its_cmd);
+		break;
+	case GITS_CMD_MAPC:
+		ret = vits_cmd_handle_mapc(kvm, its, its_cmd);
+		break;
+	case GITS_CMD_MAPI:
+		ret = vits_cmd_handle_mapi(kvm, its, its_cmd, cmd);
+		break;
+	case GITS_CMD_MAPTI:
+		ret = vits_cmd_handle_mapi(kvm, its, its_cmd, cmd);
+		break;
+	case GITS_CMD_MOVI:
+		ret = vits_cmd_handle_movi(kvm, its, its_cmd);
+		break;
+	case GITS_CMD_DISCARD:
+		ret = vits_cmd_handle_discard(kvm, its, its_cmd);
+		break;
+	case GITS_CMD_CLEAR:
+		ret = vits_cmd_handle_clear(kvm, its, its_cmd);
+		break;
+	case GITS_CMD_MOVALL:
+		ret = vits_cmd_handle_movall(kvm, its, its_cmd);
+		break;
+	case GITS_CMD_INV:
+		ret = vits_cmd_handle_inv(kvm, its, its_cmd);
+		break;
+	case GITS_CMD_INVALL:
+		ret = vits_cmd_handle_invall(kvm, its, its_cmd);
+		break;
+	case GITS_CMD_SYNC:
+		/* we ignore this command: we are in sync all of the time */
+		ret = 0;
+		break;
+	}
+
+	return ret;
 }
 
 static unsigned long vgic_mmio_read_its_cbaser(struct kvm *kvm,
-- 
2.8.2
