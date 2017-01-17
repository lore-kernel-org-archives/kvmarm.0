From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 18/33] irqchip/gic-v3-its: Add VLPI map/unmap operations
Date: Tue, 17 Jan 2017 10:20:39 +0000
Message-ID: <1484648454-21216-19-git-send-email-marc.zyngier@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2521A4019A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8NdEgnZt0-2b for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jan 2017 05:19:50 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7B2D402EC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:48 -0500 (EST)
In-Reply-To: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
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
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

In order to let a VLPI being injected into a guest, the VLPI must
be mapped using the VMAPTI command. When moved to a different vcpu,
it must be moved with the VMOVI command.

These commands are issued via the irq_set_vcpu_affinity method,
making sure we unmap the corresponding host LPI first.

The reverse is also done when the VLPI is unmapped from the guest.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 174 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 174 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 1bd78ca..d50a019 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -115,6 +115,7 @@ struct its_node {
 struct event_lpi_map {
 	unsigned long		*lpi_map;
 	u16			*col_map;
+	struct its_vlpi_map	*vlpi_map;
 	irq_hw_number_t		lpi_base;
 	int			nr_lpis;
 };
@@ -201,6 +202,21 @@ struct its_cmd_desc {
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
 
@@ -217,6 +233,9 @@ struct its_cmd_block {
 typedef struct its_collection *(*its_cmd_builder_t)(struct its_cmd_block *,
 						    struct its_cmd_desc *);
 
+typedef struct its_vpe *(*its_cmd_vbuilder_t)(struct its_cmd_block *,
+					      struct its_cmd_desc *);
+
 static void its_mask_encode(u64 *raw_cmd, u64 val, int h, int l)
 {
 	u64 mask = GENMASK_ULL(h, l);
@@ -269,6 +288,26 @@ static void its_encode_collection(struct its_cmd_block *cmd, u16 col)
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
@@ -427,6 +466,50 @@ static struct its_collection *its_build_invall_cmd(struct its_cmd_block *cmd,
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
@@ -570,6 +653,16 @@ static void its_build_sync_cmd(struct its_cmd_block *sync_cmd,
 static __its_send_single_cmd(its_send_single_command, its_cmd_builder_t,
 			     struct its_collection, its_build_sync_cmd)
 
+static void its_build_vsync_cmd(struct its_cmd_block *sync_cmd,
+				struct its_vpe *sync_vpe)
+{
+	its_encode_cmd(sync_cmd, GITS_CMD_VSYNC);
+	its_encode_vpeid(sync_cmd, sync_vpe->vpe_id);
+}
+
+static __its_send_single_cmd(its_send_single_vcommand, its_cmd_vbuilder_t,
+			     struct its_vpe, its_build_vsync_cmd)
+
 static void its_send_int(struct its_device *dev, u32 event_id)
 {
 	struct its_cmd_desc desc;
@@ -663,6 +756,33 @@ static void its_send_invall(struct its_node *its, struct its_collection *col)
 	its_send_single_command(its, its_build_invall_cmd, &desc);
 }
 
+static void its_send_vmapti(struct its_device *dev, u32 id)
+{
+	struct its_vlpi *vlpi = &dev->event_map.vlpi_map->vlpis[id];
+	struct its_cmd_desc desc;
+
+	desc.its_vmapti_cmd.vpe = dev->event_map.vlpi_map->vpes[vlpi->vpe_idx];
+	desc.its_vmapti_cmd.dev = dev;
+	desc.its_vmapti_cmd.virt_id = vlpi->vintid;
+	desc.its_vmapti_cmd.event_id = id;
+	desc.its_vmapti_cmd.db_enabled = vlpi->db_enabled;
+
+	its_send_single_vcommand(dev->its, its_build_vmapti_cmd, &desc);
+}
+
+static void its_send_vmovi(struct its_device *dev, u32 id)
+{
+	struct its_vlpi *vlpi = &dev->event_map.vlpi_map->vlpis[id];
+	struct its_cmd_desc desc;
+
+	desc.its_vmovi_cmd.vpe = dev->event_map.vlpi_map->vpes[vlpi->vpe_idx];
+	desc.its_vmovi_cmd.dev = dev;
+	desc.its_vmovi_cmd.event_id = id;
+	desc.its_vmovi_cmd.db_enabled = vlpi->db_enabled;
+
+	its_send_single_vcommand(dev->its, its_build_vmovi_cmd, &desc);
+}
+
 /*
  * irqchip functions - assumes MSI, mostly.
  */
@@ -754,6 +874,20 @@ static void its_irq_compose_msi_msg(struct irq_data *d, struct msi_msg *msg)
 	iommu_dma_map_msi_msg(d->irq, msg);
 }
 
+static int its_install_vlpi_map(struct its_device *its_dev,
+				struct its_vlpi_map *map)
+{
+	struct its_vlpi_map *old_map;
+
+	if (map->nr_vlpis != its_dev->event_map.nr_lpis)
+		return -EINVAL;
+	old_map = cmpxchg(&its_dev->event_map.vlpi_map, NULL, map);
+	if (old_map && WARN_ON(old_map != map))
+		return -EINVAL;
+
+	return 0;
+}
+
 static int its_irq_set_irqchip_state(struct irq_data *d,
 				     enum irqchip_irq_state which,
 				     bool state)
@@ -785,11 +919,51 @@ static int its_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
 	switch (info->cmd_type) {
 	case MAP_VLPI:
 	{
+		int ret;
+
+		if (!info->map)
+			return -EINVAL;
+
+		ret = its_install_vlpi_map(its_dev, info->map);
+		if (ret)
+			return ret;
+
+		if (irqd_is_forwarded_to_vcpu(d)) {
+			/* Already mapped, move it around */
+			its_send_vmovi(its_dev, event);
+		} else {
+			/* Drop the physical mapping */
+			its_send_discard(its_dev, event);
+
+			/* and install the virtual one */
+			its_send_vmapti(its_dev, event);
+			irqd_set_forwarded_to_vcpu(d);
+
+			/*
+			 * The host will never see that interrupt
+			 * firing again, so it is vital that we don't
+			 * do any lazy masking.
+			 */
+			irq_set_status_flags(d->irq, IRQ_DISABLE_UNLAZY);
+		}
+
 		return 0;
 	}
 
 	case UNMAP_VLPI:
 	{
+		if (!its_dev->event_map.vlpi_map ||
+		    !irqd_is_forwarded_to_vcpu(d))
+			return -EINVAL;
+
+		/* Drop the virtual mapping */
+		its_send_discard(its_dev, event);
+
+		/* and restore the physical one */
+		irqd_clr_forwarded_to_vcpu(d);
+		irq_clear_status_flags(d->irq, IRQ_DISABLE_UNLAZY);
+		its_send_mapvi(its_dev, d->hwirq, event);
+
 		return 0;
 	}
 
-- 
2.1.4
