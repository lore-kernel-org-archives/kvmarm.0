From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 11/13] KVM: arm64: implement ITS command queue command handlers
Date: Fri, 29 May 2015 10:53:27 +0100
Message-ID: <1432893209-27313-12-git-send-email-andre.przywara@arm.com>
References: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6E9A52490
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2015 05:44:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qNv8+adgCA+t for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 May 2015 05:44:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DE965249A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2015 05:43:58 -0400 (EDT)
In-Reply-To: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The connection between a device, an event ID, the LPI number and the
allocated CPU is stored in in-memory tables in a GICv3, but their
format is not specified by the spec. Instead software uses a command
queue to let the ITS implementation use their own format.
Implement handlers for the various ITS commands and let them store
the requested relation into our own data structures.
Error handling is very basic at this point, as we don't have a good
way of communicating errors to the guest (usually a SError).

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/linux/irqchip/arm-gic-v3.h |   1 +
 virt/kvm/arm/its-emul.c            | 422 ++++++++++++++++++++++++++++++++++++-
 virt/kvm/arm/its-emul.h            |  11 +
 3 files changed, 433 insertions(+), 1 deletion(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 0b450c7..651aacc 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -254,6 +254,7 @@
 #define GITS_CMD_MAPD			0x08
 #define GITS_CMD_MAPC			0x09
 #define GITS_CMD_MAPVI			0x0a
+#define GITS_CMD_MAPI			0x0b
 #define GITS_CMD_MOVI			0x01
 #define GITS_CMD_DISCARD		0x0f
 #define GITS_CMD_INV			0x0c
diff --git a/virt/kvm/arm/its-emul.c b/virt/kvm/arm/its-emul.c
index afd440e..574cf05 100644
--- a/virt/kvm/arm/its-emul.c
+++ b/virt/kvm/arm/its-emul.c
@@ -22,6 +22,7 @@
 #include <linux/kvm_host.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
+#include <linux/slab.h>
 
 #include <linux/irqchip/arm-gic-v3.h>
 #include <kvm/arm_vgic.h>
@@ -55,6 +56,34 @@ struct its_itte {
 	unsigned long *pending;
 };
 
+static struct its_device *find_its_device(struct kvm *kvm, u32 device_id)
+{
+	struct vgic_its *its = &kvm->arch.vgic.its;
+	struct its_device *device;
+
+	list_for_each_entry(device, &its->device_list, dev_list)
+		if (device_id == device->device_id)
+			return device;
+
+	return NULL;
+}
+
+static struct its_itte *find_itte(struct kvm *kvm, u32 device_id, u32 event_id)
+{
+	struct its_device *device;
+	struct its_itte *itte;
+
+	device = find_its_device(kvm, device_id);
+	if (device == NULL)
+		return NULL;
+
+	list_for_each_entry(itte, &device->itt, itte_list)
+		if (itte->event_id == event_id)
+			return itte;
+
+	return NULL;
+}
+
 #define for_each_lpi(dev, itte, kvm) \
 	list_for_each_entry(dev, &(kvm)->arch.vgic.its.device_list, dev_list) \
 		list_for_each_entry(itte, &(dev)->itt, itte_list)
@@ -71,6 +100,19 @@ static struct its_itte *find_itte_by_lpi(struct kvm *kvm, int lpi)
 	return NULL;
 }
 
+static struct its_collection *find_collection(struct kvm *kvm, int coll_id)
+{
+	struct its_collection *collection;
+
+	list_for_each_entry(collection, &kvm->arch.vgic.its.collection_list,
+			    coll_list) {
+		if (coll_id == collection->collection_id)
+			return collection;
+	}
+
+	return NULL;
+}
+
 #define LPI_PROP_ENABLE_BIT(p)	((p) & LPI_PROP_ENABLED)
 #define LPI_PROP_PRIORITY(p)	((p) & 0xfc)
 
@@ -345,9 +387,386 @@ void vits_unqueue_lpi(struct kvm_vcpu *vcpu, int lpi)
 	spin_unlock(&its->lock);
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
+/*
+ * Handles the DISCARD command, which frees an ITTE.
+ * Must be called with the ITS lock held.
+ */
+static int vits_cmd_handle_discard(struct kvm *kvm, u64 *its_cmd)
+{
+	u32 device_id;
+	u32 event_id;
+	struct its_itte *itte;
+
+	device_id = its_cmd_get_deviceid(its_cmd);
+	event_id = its_cmd_get_id(its_cmd);
+
+	itte = find_itte(kvm, device_id, event_id);
+	if (!itte || !itte->collection)
+		return E_ITS_DISCARD_UNMAPPED_INTERRUPT;
+
+	clear_bit(itte->collection->target_addr, itte->pending);
+
+	list_del(&itte->itte_list);
+	kfree(itte);
+	return 0;
+}
+
+/*
+ * Handles the MOVI command, which moves an ITTE to a different collection.
+ * Must be called with the ITS lock held.
+ */
+static int vits_cmd_handle_movi(struct kvm *kvm, u64 *its_cmd)
+{
+	u32 device_id = its_cmd_get_deviceid(its_cmd);
+	u32 event_id = its_cmd_get_id(its_cmd);
+	u32 coll_id = its_cmd_get_collection(its_cmd);
+	struct its_itte *itte;
+	struct its_collection *collection;
+
+	itte = find_itte(kvm, device_id, event_id);
+	if (!itte)
+		return E_ITS_MOVI_UNMAPPED_INTERRUPT;
+	if (!itte->collection)
+		return E_ITS_MOVI_UNMAPPED_COLLECTION;
+
+	collection = find_collection(kvm, coll_id);
+	if (!collection)
+		return E_ITS_MOVI_UNMAPPED_COLLECTION;
+
+	if (test_and_clear_bit(itte->collection->target_addr, itte->pending))
+		set_bit(collection->target_addr, itte->pending);
+
+	itte->collection = collection;
+
+	return 0;
+}
+
+static struct its_collection *vits_new_collection(struct kvm *kvm, u32 coll_id)
+{
+	struct its_collection *collection;
+
+	collection = kmalloc(sizeof(struct its_collection), GFP_KERNEL);
+	if (!collection)
+		return NULL;
+	collection->collection_id = coll_id;
+
+	list_add_tail(&collection->coll_list,
+		&kvm->arch.vgic.its.collection_list);
+
+	return collection;
+}
+
+/*
+ * Handles the MAPVI and MAPI command, which maps LPIs to ITTEs.
+ * Must be called with the ITS lock held.
+ */
+static int vits_cmd_handle_mapi(struct kvm *kvm, u64 *its_cmd, u8 cmd)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	u32 device_id = its_cmd_get_deviceid(its_cmd);
+	u32 event_id = its_cmd_get_id(its_cmd);
+	u32 coll_id = its_cmd_get_collection(its_cmd);
+	struct its_itte *itte;
+	struct its_device *device;
+	struct its_collection *collection, *new_coll = NULL;
+	int lpi_nr;
+
+	device = find_its_device(kvm, device_id);
+	if (!device)
+		return E_ITS_MAPVI_UNMAPPED_DEVICE;
+
+	collection = find_collection(kvm, coll_id);
+	if (!collection) {
+		new_coll = vits_new_collection(kvm, coll_id);
+		if (!new_coll)
+			return -ENOMEM;
+	}
+
+	if (cmd == GITS_CMD_MAPVI)
+		lpi_nr = its_cmd_get_physical_id(its_cmd);
+	else
+		lpi_nr = event_id;
+	if (lpi_nr < GIC_LPI_OFFSET ||
+	    lpi_nr >= PROPBASE_TSIZE(dist->propbaser))
+		return E_ITS_MAPVI_PHYSICALID_OOR;
+
+	itte = find_itte(kvm, device_id, event_id);
+	if (!itte) {
+		/* Allocate a new ITTE */
+		itte = kzalloc(sizeof(struct its_itte), GFP_KERNEL);
+		if (!itte) {
+			kfree(new_coll);
+			return -ENOMEM;
+		}
+		itte->pending = kcalloc(BITS_TO_LONGS(dist->nr_cpus),
+					sizeof(long), GFP_KERNEL);
+		if (!itte->pending) {
+			kfree(itte);
+			kfree(new_coll);
+			return -ENOMEM;
+		}
+
+		itte->event_id	= event_id;
+
+		list_add_tail(&itte->itte_list, &device->itt);
+	}
+
+	itte->collection = collection ? collection : new_coll;
+	itte->lpi = lpi_nr;
+
+	return 0;
+}
+
+static void vits_unmap_device(struct kvm *kvm, struct its_device *device)
+{
+	struct its_itte *itte, *temp;
+
+	/*
+	 * The spec says that unmapping a device with still valid
+	 * ITTEs associated is UNPREDICTABLE. We remove all ITTEs,
+	 * since we cannot leave the memory unreferenced.
+	 */
+	list_for_each_entry_safe(itte, temp, &device->itt, itte_list) {
+		list_del(&itte->itte_list);
+		kfree(itte);
+	}
+
+	list_del(&device->dev_list);
+	kfree(device);
+}
+
+/* Must be called with the ITS lock held. */
+static int vits_cmd_handle_mapd(struct kvm *kvm, u64 *its_cmd)
+{
+	bool valid = its_cmd_get_validbit(its_cmd);
+	u32 device_id = its_cmd_get_deviceid(its_cmd);
+	struct its_device *device;
+
+	device = find_its_device(kvm, device_id);
+	if (device)
+		vits_unmap_device(kvm, device);
+
+	/*
+	 * The spec does not say whether unmapping a not-mapped device
+	 * is an error, so we are done in any case.
+	 */
+	if (!valid)
+		return 0;
+
+	device = kzalloc(sizeof(struct its_device), GFP_KERNEL);
+	if (!device)
+		return -ENOMEM;
+
+	device->device_id = device_id;
+	INIT_LIST_HEAD(&device->itt);
+
+	list_add_tail(&device->dev_list,
+		      &kvm->arch.vgic.its.device_list);
+
+	return 0;
+}
+
+/* Must be called with the ITS lock held. */
+static int vits_cmd_handle_mapc(struct kvm *kvm, u64 *its_cmd)
+{
+	u16 coll_id;
+	u32 target_addr;
+	struct its_collection *collection;
+	bool valid;
+
+	valid = its_cmd_get_validbit(its_cmd);
+	coll_id = its_cmd_get_collection(its_cmd);
+	target_addr = its_cmd_get_target_addr(its_cmd);
+
+	if (target_addr >= atomic_read(&kvm->online_vcpus))
+		return E_ITS_MAPC_PROCNUM_OOR;
+
+	collection = find_collection(kvm, coll_id);
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
+			return 0;
+
+		for_each_lpi(device, itte, kvm)
+			if (itte->collection &&
+			    itte->collection->collection_id == coll_id)
+				itte->collection = NULL;
+
+		list_del(&collection->coll_list);
+		kfree(collection);
+		return 0;
+	}
+
+	if (!collection) {
+		collection = vits_new_collection(kvm, coll_id);
+		if (!collection)
+			return -ENOMEM;
+	}
+
+	collection->target_addr = target_addr;
+
+	return 0;
+}
+
+/* Must be called with the ITS lock held. */
+static int vits_cmd_handle_clear(struct kvm *kvm, u64 *its_cmd)
+{
+	u32 device_id;
+	u32 event_id;
+	struct its_itte *itte;
+
+	device_id = its_cmd_get_deviceid(its_cmd);
+	event_id = its_cmd_get_id(its_cmd);
+
+	itte = find_itte(kvm, device_id, event_id);
+	if (!itte)
+		return E_ITS_CLEAR_UNMAPPED_INTERRUPT;
+
+	if (itte->collection)
+		clear_bit(itte->collection->target_addr, itte->pending);
+	return 0;
+}
+
+/* Must be called with the ITS lock held. */
+static int vits_cmd_handle_inv(struct kvm *kvm, u64 *its_cmd)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	u32 device_id;
+	u32 event_id;
+	struct its_itte *itte;
+	gpa_t propbase;
+	int ret;
+	u8 prop;
+
+	device_id = its_cmd_get_deviceid(its_cmd);
+	event_id = its_cmd_get_id(its_cmd);
+
+	itte = find_itte(kvm, device_id, event_id);
+	if (!itte)
+		return E_ITS_INV_UNMAPPED_INTERRUPT;
+
+	propbase = BASER_BASE_ADDRESS(dist->propbaser);
+	ret = kvm_read_guest(kvm, propbase + itte->lpi - GIC_LPI_OFFSET,
+			     &prop, 1);
+	if (ret)
+		return ret;
+
+	update_lpi_property(kvm, itte, prop);
+	return 0;
+}
+
+/* Must be called with the ITS lock held. */
+static int vits_cmd_handle_invall(struct kvm *kvm, u64 *its_cmd)
+{
+	u32 coll_id = its_cmd_get_collection(its_cmd);
+	struct its_collection *collection;
+	struct kvm_vcpu *vcpu;
+
+	collection = find_collection(kvm, coll_id);
+	if (!collection)
+		return E_ITS_INVALL_UNMAPPED_COLLECTION;
+
+	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
+
+	its_update_lpi_properties(kvm);
+	its_sync_lpi_pending_table(vcpu);
+
+	return 0;
+}
+
+/* Must be called with the ITS lock held. */
+static int vits_cmd_handle_movall(struct kvm *kvm, u64 *its_cmd)
+{
+	u32 target1_addr = its_cmd_get_target_addr(its_cmd);
+	u32 target2_addr = its_cmd_mask_field(its_cmd, 3, 16, 32);
+	struct its_collection *collection;
+	struct its_device *device;
+	struct its_itte *itte;
+
+	if (target1_addr >= atomic_read(&kvm->online_vcpus) ||
+	    target2_addr >= atomic_read(&kvm->online_vcpus))
+		return E_ITS_MOVALL_PROCNUM_OOR;
+
+	if (target1_addr == target2_addr)
+		return 0;
+
+	for_each_lpi(device, itte, kvm) {
+		/* remap all collections mapped to target address 1 */
+		collection = itte->collection;
+		if (collection && collection->target_addr == target1_addr)
+			collection->target_addr = target2_addr;
+
+		/* move pending state if LPI is affected */
+		if (test_and_clear_bit(target1_addr, itte->pending))
+			set_bit(target2_addr, itte->pending);
+	}
+
+	return 0;
+}
+
+/* Must be called with the ITS lock held. */
 static int vits_handle_command(struct kvm_vcpu *vcpu, u64 *its_cmd)
 {
-	return -ENODEV;
+	u8 cmd = its_cmd_get_command(its_cmd);
+	int ret = -ENODEV;
+
+	switch (cmd) {
+	case GITS_CMD_MAPD:
+		ret = vits_cmd_handle_mapd(vcpu->kvm, its_cmd);
+		break;
+	case GITS_CMD_MAPC:
+		ret = vits_cmd_handle_mapc(vcpu->kvm, its_cmd);
+		break;
+	case GITS_CMD_MAPI:
+		ret = vits_cmd_handle_mapi(vcpu->kvm, its_cmd, cmd);
+		break;
+	case GITS_CMD_MAPVI:
+		ret = vits_cmd_handle_mapi(vcpu->kvm, its_cmd, cmd);
+		break;
+	case GITS_CMD_MOVI:
+		ret = vits_cmd_handle_movi(vcpu->kvm, its_cmd);
+		break;
+	case GITS_CMD_DISCARD:
+		ret = vits_cmd_handle_discard(vcpu->kvm, its_cmd);
+		break;
+	case GITS_CMD_CLEAR:
+		ret = vits_cmd_handle_clear(vcpu->kvm, its_cmd);
+		break;
+	case GITS_CMD_MOVALL:
+		ret = vits_cmd_handle_movall(vcpu->kvm, its_cmd);
+		break;
+	case GITS_CMD_INV:
+		ret = vits_cmd_handle_inv(vcpu->kvm, its_cmd);
+		break;
+	case GITS_CMD_INVALL:
+		ret = vits_cmd_handle_invall(vcpu->kvm, its_cmd);
+		break;
+	case GITS_CMD_SYNC:
+		/* we ignore those commands: we are in sync all of the time */
+		break;
+	}
+
+	return ret;
 }
 
 static bool handle_mmio_gits_cbaser(struct kvm_vcpu *vcpu,
@@ -532,6 +951,7 @@ void vits_destroy(struct kvm *kvm)
 		list_for_each_safe(cur, temp, &dev->itt) {
 			itte = (container_of(cur, struct its_itte, itte_list));
 			list_del(cur);
+			kfree(itte->pending);
 			kfree(itte);
 		}
 		list_del(dev_cur);
diff --git a/virt/kvm/arm/its-emul.h b/virt/kvm/arm/its-emul.h
index cc5d5ff..6152d04 100644
--- a/virt/kvm/arm/its-emul.h
+++ b/virt/kvm/arm/its-emul.h
@@ -36,4 +36,15 @@ void vits_destroy(struct kvm *kvm);
 bool vits_queue_lpis(struct kvm_vcpu *vcpu);
 void vits_unqueue_lpi(struct kvm_vcpu *vcpu, int irq);
 
+#define E_ITS_MOVI_UNMAPPED_INTERRUPT		0x010107
+#define E_ITS_MOVI_UNMAPPED_COLLECTION		0x010109
+#define E_ITS_CLEAR_UNMAPPED_INTERRUPT		0x010507
+#define E_ITS_MAPC_PROCNUM_OOR			0x010902
+#define E_ITS_MAPVI_UNMAPPED_DEVICE		0x010a04
+#define E_ITS_MAPVI_PHYSICALID_OOR		0x010a06
+#define E_ITS_INV_UNMAPPED_INTERRUPT		0x010c07
+#define E_ITS_INVALL_UNMAPPED_COLLECTION	0x010d09
+#define E_ITS_MOVALL_PROCNUM_OOR		0x010e01
+#define E_ITS_DISCARD_UNMAPPED_INTERRUPT	0x010f07
+
 #endif
-- 
2.3.5
