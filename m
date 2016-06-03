From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 11/13] KVM: arm64: implement ITS command queue command
 handlers
Date: Fri,  3 Jun 2016 15:02:50 +0100
Message-ID: <1464962572-3925-12-git-send-email-andre.przywara@arm.com>
References: <1464962572-3925-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DA0A49B54
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jun 2016 09:58:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SCW1NO0to3Go for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jun 2016 09:58:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC41F49B44
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jun 2016 09:58:41 -0400 (EDT)
In-Reply-To: <1464962572-3925-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The connection between a device, an event ID, the LPI number and the
allocated CPU is stored in in-memory tables in a GICv3, but their
format is not specified by the spec. Instead software uses a command
queue in a ring buffer to let the ITS implementation use their own
format.
Implement handlers for the various ITS commands and let them store
the requested relation into our own data structures.
To avoid kmallocs inside the ITS spinlock, we preallocate possibly
needed memory outside of the lock and free that if it turns out to
be not needed (mostly error handling).
Error handling is very basic at this point, as we don't have a good
way of communicating errors to the guest (usually a SError).
The INT command handler is missing at this point, as we gain the
capability of actually injecting MSIs into the guest only later on.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/linux/irqchip/arm-gic-v3.h |  19 +-
 virt/kvm/arm/vgic/vgic-its.c       | 513 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 530 insertions(+), 2 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 9e5fe01..f587d5d 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -254,7 +254,10 @@
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
@@ -265,6 +268,20 @@
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
index 84e6f3b..72145c1 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -22,6 +22,7 @@
 #include <linux/kvm_host.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
+#include <linux/slab.h>
 #include <linux/uaccess.h>
 
 #include <linux/irqchip/arm-gic-v3.h>
@@ -74,6 +75,34 @@ struct its_itte {
 	u32 event_id;
 };
 
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
+	list_for_each_entry(itte, &device->itt, itte_list)
+		if (itte->event_id == event_id)
+			return itte;
+
+	return NULL;
+}
+
 /* To be used as an iterator this macro misses the enclosing parentheses */
 #define for_each_lpi(dev, itte, its) \
 	list_for_each_entry(dev, &(its)->device_list, dev_list) \
@@ -93,6 +122,18 @@ static struct its_itte *find_itte_by_lpi(struct vgic_its *its, int lpi)
 
 #define BASER_BASE_ADDRESS(x) ((x) & 0xfffffffff000ULL)
 
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
 
@@ -106,6 +147,30 @@ static void update_lpi_config(struct kvm *kvm, struct its_itte *itte, u8 prop)
 	vgic_queue_irq_unlock(kvm, &itte->irq);
 }
 
+/*
+ * Finds all LPIs which are mapped to this collection and updates the
+ * struct irq's target_vcpu field accordingly.
+ * Needs to be called whenever either the collection for a LPIs has
+ * changed or the collection itself got retargetted.
+ */
+static void update_affinity(struct kvm *kvm, struct vgic_its *its,
+			    struct its_collection *coll)
+{
+	struct its_device *device;
+	struct its_itte *itte;
+	struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, coll->target_addr);
+
+	for_each_lpi(device, itte, its) {
+		if (!itte->collection ||
+		    coll->collection_id != itte->collection->collection_id)
+			continue;
+
+		spin_lock(&itte->irq.irq_lock);
+		itte->irq.target_vcpu = vcpu;
+		spin_unlock(&itte->irq.irq_lock);
+	}
+}
+
 #define GIC_LPI_OFFSET 8192
 
 /* We scan the table in chunks the size of the smallest page size */
@@ -320,6 +385,412 @@ static void its_free_itte(struct its_itte *itte)
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
+	spin_lock(&its->lock);
+	itte = find_itte(its, device_id, event_id);
+	if (itte && itte->collection) {
+		/*
+		 * Though the spec talks about removing the pending state, we
+		 * don't bother here since we clear the ITTE anyway and the
+		 * pending state is a property of the ITTE struct.
+		 */
+		its_free_itte(itte);
+		ret = 0;
+	}
+
+	spin_unlock(&its->lock);
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
+	struct its_itte *itte;
+	struct its_collection *collection;
+	int ret = 0;
+
+	spin_lock(&its->lock);
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
+	update_affinity(kvm, its, collection);
+
+out_unlock:
+	spin_unlock(&its->lock);
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
+	struct its_itte *itte, *new_itte;
+	struct its_device *device;
+	struct its_collection *collection, *new_coll;
+	int lpi_nr;
+	int ret = 0;
+
+	/* Preallocate possibly needed memory here outside of the lock */
+	new_coll = kmalloc(sizeof(struct its_collection), GFP_KERNEL);
+	new_itte = kzalloc(sizeof(struct its_itte), GFP_KERNEL);
+
+	spin_lock(&its->lock);
+
+	device = find_its_device(its, device_id);
+	if (!device) {
+		ret = E_ITS_MAPTI_UNMAPPED_DEVICE;
+		goto out_unlock;
+	}
+
+	collection = find_collection(its, coll_id);
+	if (!collection && !new_coll) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
+	if (subcmd == GITS_CMD_MAPTI)
+		lpi_nr = its_cmd_get_physical_id(its_cmd);
+	else
+		lpi_nr = event_id;
+	if (lpi_nr < GIC_LPI_OFFSET ||
+	    lpi_nr >= max_lpis_propbaser(kvm->arch.vgic.propbaser)) {
+		ret = E_ITS_MAPTI_PHYSICALID_OOR;
+		goto out_unlock;
+	}
+
+	itte = find_itte(its, device_id, event_id);
+	if (!itte) {
+		if (!new_itte) {
+			ret = -ENOMEM;
+			goto out_unlock;
+		}
+		itte = new_itte;
+
+		itte->event_id	= event_id;
+		list_add_tail(&itte->itte_list, &device->itt);
+	} else {
+		kfree(new_itte);
+	}
+
+	if (!collection) {
+		collection = new_coll;
+		vits_init_collection(its, collection, coll_id);
+	} else {
+		kfree(new_coll);
+	}
+
+	itte->collection = collection;
+	itte->lpi = lpi_nr;
+	itte->irq.intid = lpi_nr;
+	INIT_LIST_HEAD(&itte->irq.ap_list);
+	spin_lock_init(&itte->irq.irq_lock);
+	itte->irq.vcpu = NULL;
+	update_affinity(kvm, its, collection);
+
+out_unlock:
+	spin_unlock(&its->lock);
+	if (ret) {
+		kfree(new_coll);
+		kfree(new_itte);
+	}
+	return ret;
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
+	list_for_each_entry_safe(itte, temp, &device->itt, itte_list)
+		its_free_itte(itte);
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
+	struct its_device *device, *new_device = NULL;
+
+	/* We preallocate memory outside of the lock here */
+	if (valid) {
+		new_device = kzalloc(sizeof(struct its_device), GFP_KERNEL);
+		if (!new_device)
+			return -ENOMEM;
+	}
+
+	spin_lock(&its->lock);
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
+	device = new_device;
+
+	device->device_id = device_id;
+	INIT_LIST_HEAD(&device->itt);
+
+	list_add_tail(&device->dev_list, &its->device_list);
+
+out_unlock:
+	spin_unlock(&its->lock);
+	return 0;
+}
+
+/* The MAPC command maps collection IDs to redistributors. */
+static int vits_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
+				u64 *its_cmd)
+{
+	u16 coll_id;
+	u32 target_addr;
+	struct its_collection *collection, *new_coll = NULL;
+	bool valid;
+
+	valid = its_cmd_get_validbit(its_cmd);
+	coll_id = its_cmd_get_collection(its_cmd);
+	target_addr = its_cmd_get_target_addr(its_cmd);
+
+	if (target_addr >= atomic_read(&kvm->online_vcpus))
+		return E_ITS_MAPC_PROCNUM_OOR;
+
+	/* We preallocate memory outside of the lock here */
+	if (valid) {
+		new_coll = kmalloc(sizeof(struct its_collection), GFP_KERNEL);
+		if (!new_coll)
+			return -ENOMEM;
+	}
+
+	spin_lock(&its->lock);
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
+		for_each_lpi(device, itte, its)
+			if (itte->collection &&
+			    itte->collection->collection_id == coll_id)
+				itte->collection = NULL;
+
+		list_del(&collection->coll_list);
+		kfree(collection);
+	} else {
+		if (!collection)
+			collection = new_coll;
+		else
+			kfree(new_coll);
+
+		vits_init_collection(its, collection, coll_id);
+		collection->target_addr = target_addr;
+		update_affinity(kvm, its, collection);
+	}
+
+out_unlock:
+	spin_unlock(&its->lock);
+	return 0;
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
+	spin_lock(&its->lock);
+
+	itte = find_itte(its, device_id, event_id);
+	if (!itte) {
+		ret = E_ITS_CLEAR_UNMAPPED_INTERRUPT;
+		goto out_unlock;
+	}
+
+	itte->irq.pending = false;
+
+out_unlock:
+	spin_unlock(&its->lock);
+	return ret;
+}
+
+/* The INV command syncs the configuration bits from the memory tables. */
+static int vits_cmd_handle_inv(struct kvm *kvm, struct vgic_its *its,
+			       u64 *its_cmd)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	u32 device_id;
+	u32 event_id;
+	struct its_itte *itte, *new_itte;
+	gpa_t propbase;
+	int ret;
+	u8 prop;
+
+	device_id = its_cmd_get_deviceid(its_cmd);
+	event_id = its_cmd_get_id(its_cmd);
+
+	spin_lock(&its->lock);
+	itte = find_itte(its, device_id, event_id);
+	spin_unlock(&its->lock);
+	if (!itte)
+		return E_ITS_INV_UNMAPPED_INTERRUPT;
+
+	/*
+	 * We cannot read from guest memory inside the spinlock, so we
+	 * need to re-read our tables to learn whether the LPI number we are
+	 * using is still valid.
+	 */
+	do {
+		propbase = BASER_BASE_ADDRESS(dist->propbaser);
+		ret = kvm_read_guest(kvm, propbase + itte->lpi - GIC_LPI_OFFSET,
+				     &prop, 1);
+		if (ret)
+			return ret;
+
+		spin_lock(&its->lock);
+		new_itte = find_itte(its, device_id, event_id);
+		if (new_itte->lpi != itte->lpi) {
+			itte = new_itte;
+			spin_unlock(&its->lock);
+			continue;
+		}
+		update_lpi_config(kvm, itte, prop);
+		spin_unlock(&its->lock);
+	} while (0);
+	return 0;
+}
+
+/* The INVALL command requests flushing of all IRQ data in this collection. */
+static int vits_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
+				  u64 *its_cmd)
+{
+	u64 prop_base_reg, pend_base_reg;
+	u32 coll_id = its_cmd_get_collection(its_cmd);
+	struct its_collection *collection;
+	struct kvm_vcpu *vcpu;
+
+	collection = find_collection(its, coll_id);
+	if (!its_is_collection_mapped(collection))
+		return E_ITS_INVALL_UNMAPPED_COLLECTION;
+
+	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
+
+	pend_base_reg = vcpu->arch.vgic_cpu.pendbaser;
+	prop_base_reg = kvm->arch.vgic.propbaser;
+
+	its_update_lpis_configuration(kvm, its, prop_base_reg);
+	its_sync_lpi_pending_table(vcpu, its, pend_base_reg);
+
+	return 0;
+}
+
+/* The MOVALL command moves all IRQs from one redistributor to another. */
+static int vits_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
+				  u64 *its_cmd)
+{
+	u32 target1_addr = its_cmd_get_target_addr(its_cmd);
+	u32 target2_addr = its_cmd_mask_field(its_cmd, 3, 16, 32);
+	struct its_collection *collection;
+
+	if (target1_addr >= atomic_read(&kvm->online_vcpus) ||
+	    target2_addr >= atomic_read(&kvm->online_vcpus))
+		return E_ITS_MOVALL_PROCNUM_OOR;
+
+	if (target1_addr == target2_addr)
+		return 0;
+
+	spin_lock(&its->lock);
+	list_for_each_entry(collection, &its->collection_list,
+			    coll_list) {
+		if (collection && collection->target_addr == target1_addr)
+			collection->target_addr = target2_addr;
+		update_affinity(kvm, its, collection);
+	}
+
+	spin_unlock(&its->lock);
+	return 0;
+}
+
 /*
  * This function expects the ITS lock to be dropped, so the actual command
  * handlers must take care of proper locking when needed.
@@ -327,7 +798,47 @@ static void its_free_itte(struct its_itte *itte)
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
 
 static unsigned long vgic_mmio_read_its_cbaser(struct kvm_vcpu *vcpu,
-- 
2.8.2
