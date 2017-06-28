From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 07/52] irqchip/gic-v3-its: Implement irq_set_irqchip_state
 for pending state
Date: Wed, 28 Jun 2017 16:03:26 +0100
Message-ID: <20170628150411.15846-8-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD69D43C7B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:04:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zKhH9GYKCZOO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:04:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5722D4113E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:04:40 -0400 (EDT)
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

Allow the pending state of an LPI to be set or cleared via
irq_set_irqchip_state.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 78 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index bbf7bb89aa62..391b87572549 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -169,6 +169,11 @@ struct its_cmd_desc {
 		struct {
 			struct its_device *dev;
 			u32 event_id;
+		} its_clear_cmd;
+
+		struct {
+			struct its_device *dev;
+			u32 event_id;
 		} its_int_cmd;
 
 		struct {
@@ -382,6 +387,40 @@ static struct its_collection *its_build_inv_cmd(struct its_cmd_block *cmd,
 	return col;
 }
 
+static struct its_collection *its_build_int_cmd(struct its_cmd_block *cmd,
+						struct its_cmd_desc *desc)
+{
+	struct its_collection *col;
+
+	col = dev_event_to_col(desc->its_int_cmd.dev,
+			       desc->its_int_cmd.event_id);
+
+	its_encode_cmd(cmd, GITS_CMD_INT);
+	its_encode_devid(cmd, desc->its_int_cmd.dev->device_id);
+	its_encode_event_id(cmd, desc->its_int_cmd.event_id);
+
+	its_fixup_cmd(cmd);
+
+	return col;
+}
+
+static struct its_collection *its_build_clear_cmd(struct its_cmd_block *cmd,
+						  struct its_cmd_desc *desc)
+{
+	struct its_collection *col;
+
+	col = dev_event_to_col(desc->its_clear_cmd.dev,
+			       desc->its_clear_cmd.event_id);
+
+	its_encode_cmd(cmd, GITS_CMD_CLEAR);
+	its_encode_devid(cmd, desc->its_clear_cmd.dev->device_id);
+	its_encode_event_id(cmd, desc->its_clear_cmd.event_id);
+
+	its_fixup_cmd(cmd);
+
+	return col;
+}
+
 static struct its_collection *its_build_invall_cmd(struct its_cmd_block *cmd,
 						   struct its_cmd_desc *desc)
 {
@@ -538,6 +577,26 @@ static void its_build_sync_cmd(struct its_cmd_block *sync_cmd,
 static BUILD_SINGLE_CMD_FUNC(its_send_single_command, its_cmd_builder_t,
 			     struct its_collection, its_build_sync_cmd)
 
+static void its_send_int(struct its_device *dev, u32 event_id)
+{
+	struct its_cmd_desc desc;
+
+	desc.its_int_cmd.dev = dev;
+	desc.its_int_cmd.event_id = event_id;
+
+	its_send_single_command(dev->its, its_build_int_cmd, &desc);
+}
+
+static void its_send_clear(struct its_device *dev, u32 event_id)
+{
+	struct its_cmd_desc desc;
+
+	desc.its_clear_cmd.dev = dev;
+	desc.its_clear_cmd.event_id = event_id;
+
+	its_send_single_command(dev->its, its_build_clear_cmd, &desc);
+}
+
 static void its_send_inv(struct its_device *dev, u32 event_id)
 {
 	struct its_cmd_desc desc;
@@ -701,6 +760,24 @@ static void its_irq_compose_msi_msg(struct irq_data *d, struct msi_msg *msg)
 	iommu_dma_map_msi_msg(d->irq, msg);
 }
 
+static int its_irq_set_irqchip_state(struct irq_data *d,
+				     enum irqchip_irq_state which,
+				     bool state)
+{
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	u32 event = its_get_event_id(d);
+
+	if (which != IRQCHIP_STATE_PENDING)
+		return -EINVAL;
+
+	if (state)
+		its_send_int(its_dev, event);
+	else
+		its_send_clear(its_dev, event);
+
+	return 0;
+}
+
 static struct irq_chip its_irq_chip = {
 	.name			= "ITS",
 	.irq_mask		= its_mask_irq,
@@ -708,6 +785,7 @@ static struct irq_chip its_irq_chip = {
 	.irq_eoi		= irq_chip_eoi_parent,
 	.irq_set_affinity	= its_set_affinity,
 	.irq_compose_msi_msg	= its_irq_compose_msi_msg,
+	.irq_set_irqchip_state	= its_irq_set_irqchip_state,
 };
 
 /*
-- 
2.11.0
