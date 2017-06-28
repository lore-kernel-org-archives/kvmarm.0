From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 17/52] irqchip/gic-v3-its: Add VLPI map/unmap operations
Date: Wed, 28 Jun 2017 16:03:36 +0100
Message-ID: <20170628150411.15846-18-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F98A40EF3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:04:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I59BLbOwFkvY for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:04:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D68540FAF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:04:57 -0400 (EDT)
In-Reply-To: <20170628150411.15846-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

In order to let a VLPI being injected into a guest, the VLPI must
be mapped using the VMAPTI command. When moved to a different vcpu,
it must be moved with the VMOVI command.

These commands are issued via the irq_set_vcpu_affinity method,
making sure we unmap the corresponding host LPI first.

The reverse is also done when the VLPI is unmapped from the guest.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 250 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 247 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index c02e1e6cd169..527e4e95e10d 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -117,11 +117,17 @@ struct event_lpi_map {
 	u16			*col_map;
 	irq_hw_number_t		lpi_base;
 	int			nr_lpis;
+	struct mutex		vlpi_lock;
+	struct its_vm		*vm;
+	struct its_vlpi_map	*vlpi_maps;
+	int			nr_vlpis;
 };
 
 /*
- * The ITS view of a device - belongs to an ITS, a collection, owns an
- * interrupt translation table, and a list of interrupts.
+ * The ITS view of a device - belongs to an ITS, owns an interrupt
+ * translation table, and a list of interrupts.  If it some of its
+ * LPIs are injected into a guest (GICv4), the event_map.vm field
+ * indicates which one.
  */
 struct its_device {
 	struct list_head	entry;
@@ -207,6 +213,21 @@ struct its_cmd_desc {
 		struct {
 			struct its_collection *col;
 		} its_invall_cmd;
+
+		struct {
+			struct its_vpe *vpe;
+			struct its_device *dev;
+			u32 virt_id;
+			u32 event_id;
+			bool db_enabled;
+		} its_vmapti_cmd;
+
+		struct {
+			struct its_vpe *vpe;
+			struct its_device *dev;
+			u32 event_id;
+			bool db_enabled;
+		} its_vmovi_cmd;
 	};
 };
 
@@ -223,6 +244,9 @@ struct its_cmd_block {
 typedef struct its_collection *(*its_cmd_builder_t)(struct its_cmd_block *,
 						    struct its_cmd_desc *);
 
+typedef struct its_vpe *(*its_cmd_vbuilder_t)(struct its_cmd_block *,
+					      struct its_cmd_desc *);
+
 static void its_mask_encode(u64 *raw_cmd, u64 val, int h, int l)
 {
 	u64 mask = GENMASK_ULL(h, l);
@@ -275,6 +299,26 @@ static void its_encode_collection(struct its_cmd_block *cmd, u16 col)
 	its_mask_encode(&cmd->raw_cmd[2], col, 15, 0);
 }
 
+static void its_encode_vpeid(struct its_cmd_block *cmd, u16 vpeid)
+{
+	its_mask_encode(&cmd->raw_cmd[1], vpeid, 47, 32);
+}
+
+static void its_encode_virt_id(struct its_cmd_block *cmd, u32 virt_id)
+{
+	its_mask_encode(&cmd->raw_cmd[2], virt_id, 31, 0);
+}
+
+static void its_encode_db_phys_id(struct its_cmd_block *cmd, u32 db_phys_id)
+{
+	its_mask_encode(&cmd->raw_cmd[2], db_phys_id, 63, 32);
+}
+
+static void its_encode_db_valid(struct its_cmd_block *cmd, bool db_valid)
+{
+	its_mask_encode(&cmd->raw_cmd[2], db_valid, 0, 0);
+}
+
 static inline void its_fixup_cmd(struct its_cmd_block *cmd)
 {
 	/* Let's fixup BE commands */
@@ -433,6 +477,50 @@ static struct its_collection *its_build_invall_cmd(struct its_cmd_block *cmd,
 	return NULL;
 }
 
+static struct its_vpe *its_build_vmapti_cmd(struct its_cmd_block *cmd,
+					    struct its_cmd_desc *desc)
+{
+	u32 db;
+
+	if (desc->its_vmapti_cmd.db_enabled)
+		db = desc->its_vmapti_cmd.vpe->vpe_db_lpi;
+	else
+		db = 1023;
+
+	its_encode_cmd(cmd, GITS_CMD_VMAPTI);
+	its_encode_devid(cmd, desc->its_vmapti_cmd.dev->device_id);
+	its_encode_vpeid(cmd, desc->its_vmapti_cmd.vpe->vpe_id);
+	its_encode_event_id(cmd, desc->its_vmapti_cmd.event_id);
+	its_encode_db_phys_id(cmd, db);
+	its_encode_virt_id(cmd, desc->its_vmapti_cmd.virt_id);
+
+	its_fixup_cmd(cmd);
+
+	return desc->its_vmapti_cmd.vpe;
+}
+
+static struct its_vpe *its_build_vmovi_cmd(struct its_cmd_block *cmd,
+					   struct its_cmd_desc *desc)
+{
+	u32 db;
+
+	if (desc->its_vmovi_cmd.db_enabled)
+		db = desc->its_vmovi_cmd.vpe->vpe_db_lpi;
+	else
+		db = 1023;
+
+	its_encode_cmd(cmd, GITS_CMD_VMOVI);
+	its_encode_devid(cmd, desc->its_vmovi_cmd.dev->device_id);
+	its_encode_vpeid(cmd, desc->its_vmovi_cmd.vpe->vpe_id);
+	its_encode_event_id(cmd, desc->its_vmovi_cmd.event_id);
+	its_encode_db_phys_id(cmd, db);
+	its_encode_db_valid(cmd, true);
+
+	its_fixup_cmd(cmd);
+
+	return desc->its_vmovi_cmd.vpe;
+}
+
 static u64 its_cmd_ptr_to_offset(struct its_node *its,
 				 struct its_cmd_block *ptr)
 {
@@ -578,6 +666,18 @@ static void its_build_sync_cmd(struct its_cmd_block *sync_cmd,
 static BUILD_SINGLE_CMD_FUNC(its_send_single_command, its_cmd_builder_t,
 			     struct its_collection, its_build_sync_cmd)
 
+static void its_build_vsync_cmd(struct its_cmd_block *sync_cmd,
+				struct its_vpe *sync_vpe)
+{
+	its_encode_cmd(sync_cmd, GITS_CMD_VSYNC);
+	its_encode_vpeid(sync_cmd, sync_vpe->vpe_id);
+
+	its_fixup_cmd(sync_cmd);
+}
+
+static BUILD_SINGLE_CMD_FUNC(its_send_single_vcommand, its_cmd_vbuilder_t,
+			     struct its_vpe, its_build_vsync_cmd)
+
 static void its_send_int(struct its_device *dev, u32 event_id)
 {
 	struct its_cmd_desc desc;
@@ -671,6 +771,33 @@ static void its_send_invall(struct its_node *its, struct its_collection *col)
 	its_send_single_command(its, its_build_invall_cmd, &desc);
 }
 
+static void its_send_vmapti(struct its_device *dev, u32 id)
+{
+	struct its_vlpi_map *map = &dev->event_map.vlpi_maps[id];
+	struct its_cmd_desc desc;
+
+	desc.its_vmapti_cmd.vpe = map->vm->vpes[map->vpe_idx];
+	desc.its_vmapti_cmd.dev = dev;
+	desc.its_vmapti_cmd.virt_id = map->vintid;
+	desc.its_vmapti_cmd.event_id = id;
+	desc.its_vmapti_cmd.db_enabled = map->db_enabled;
+
+	its_send_single_vcommand(dev->its, its_build_vmapti_cmd, &desc);
+}
+
+static void its_send_vmovi(struct its_device *dev, u32 id)
+{
+	struct its_vlpi_map *map = &dev->event_map.vlpi_maps[id];
+	struct its_cmd_desc desc;
+
+	desc.its_vmovi_cmd.vpe = map->vm->vpes[map->vpe_idx];
+	desc.its_vmovi_cmd.dev = dev;
+	desc.its_vmovi_cmd.event_id = id;
+	desc.its_vmovi_cmd.db_enabled = map->db_enabled;
+
+	its_send_single_vcommand(dev->its, its_build_vmovi_cmd, &desc);
+}
+
 /*
  * irqchip functions - assumes MSI, mostly.
  */
@@ -780,19 +907,135 @@ static int its_irq_set_irqchip_state(struct irq_data *d,
 	return 0;
 }
 
+static int its_vlpi_map(struct irq_data *d, struct its_cmd_info *info)
+{
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	u32 event = its_get_event_id(d);
+	int ret = 0;
+
+	if (!info->map)
+		return -EINVAL;
+
+	mutex_lock(&its_dev->event_map.vlpi_lock);
+
+	if (!its_dev->event_map.vm) {
+		struct its_vlpi_map *maps;
+
+		maps = kzalloc(sizeof(*maps) * its_dev->event_map.nr_lpis,
+			       GFP_KERNEL);
+		if (!maps) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		its_dev->event_map.vm = info->map->vm;
+		its_dev->event_map.vlpi_maps = maps;
+	} else if (its_dev->event_map.vm != info->map->vm) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Get our private copy of the mapping information */
+	its_dev->event_map.vlpi_maps[event] = *info->map;
+
+	if (irqd_is_forwarded_to_vcpu(d)) {
+		/* Already mapped, move it around */
+		its_send_vmovi(its_dev, event);
+	} else {
+		/* Drop the physical mapping */
+		its_send_discard(its_dev, event);
+
+		/* and install the virtual one */
+		its_send_vmapti(its_dev, event);
+		irqd_set_forwarded_to_vcpu(d);
+
+		/* Increment the number of VLPIs */
+		its_dev->event_map.nr_vlpis++;
+	}
+
+out:
+	mutex_unlock(&its_dev->event_map.vlpi_lock);
+	return ret;
+}
+
+static int its_vlpi_get(struct irq_data *d, struct its_cmd_info *info)
+{
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	u32 event = its_get_event_id(d);
+	int ret = 0;
+
+	mutex_lock(&its_dev->event_map.vlpi_lock);
+
+	if (!its_dev->event_map.vm ||
+	    !its_dev->event_map.vlpi_maps[event].vm) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Copy our mapping information to the incoming request */
+	*info->map = its_dev->event_map.vlpi_maps[event];
+
+out:
+	mutex_unlock(&its_dev->event_map.vlpi_lock);
+	return ret;
+}
+
+static int its_vlpi_unmap(struct irq_data *d)
+{
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	u32 event = its_get_event_id(d);
+	int ret = 0;
+
+	mutex_lock(&its_dev->event_map.vlpi_lock);
+
+	if (!its_dev->event_map.vm || !irqd_is_forwarded_to_vcpu(d)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Drop the virtual mapping */
+	its_send_discard(its_dev, event);
+
+	/* and restore the physical one */
+	irqd_clr_forwarded_to_vcpu(d);
+	its_send_mapti(its_dev, d->hwirq, event);
+	lpi_update_config(d, 0xff, (LPI_PROP_DEFAULT_PRIO |
+				    LPI_PROP_ENABLED |
+				    LPI_PROP_GROUP1));
+
+	/*
+	 * Drop the refcount and make the device available again if
+	 * this was the last VLPI.
+	 */
+	if (!--its_dev->event_map.nr_vlpis) {
+		its_dev->event_map.vm = NULL;
+		kfree(its_dev->event_map.vlpi_maps);
+	}
+
+out:
+	mutex_unlock(&its_dev->event_map.vlpi_lock);
+	return ret;
+}
+
 static int its_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
 {
 	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
 	struct its_cmd_info *info = vcpu_info;
 
 	/* Need a v4 ITS */
-	if (!its_dev->its->is_v4 || !info)
+	if (!its_dev->its->is_v4)
 		return -EINVAL;
 
+	/* Unmap request? */
+	if (!info)
+		return its_vlpi_unmap(d);
+
 	switch (info->cmd_type) {
 	case MAP_VLPI:
+		return its_vlpi_map(d, info);
 
 	case GET_VLPI:
+		return its_vlpi_get(d, info);
 
 	case PROP_UPDATE_VLPI:
 	case PROP_UPDATE_AND_INV_VLPI:
@@ -1509,6 +1752,7 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 	dev->event_map.col_map = col_map;
 	dev->event_map.lpi_base = lpi_base;
 	dev->event_map.nr_lpis = nr_lpis;
+	mutex_init(&dev->event_map.vlpi_lock);
 	dev->device_id = dev_id;
 	INIT_LIST_HEAD(&dev->entry);
 
-- 
2.11.0
