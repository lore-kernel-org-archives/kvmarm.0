From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 08/33] irqchip/gic-v3-its: Implement irq_set_irqchip_state
 for pending state
Date: Tue, 17 Jan 2017 10:20:29 +0000
Message-ID: <1484648454-21216-9-git-send-email-marc.zyngier@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 236DF405E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3f98G1d3A2uJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jan 2017 05:19:35 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAA3D4079A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:34 -0500 (EST)
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

Allow the pending state of an LPI to be set or cleared via
irq_set_irqchip_state.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 78 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 520b764..b28fb19 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -163,6 +163,11 @@ struct its_cmd_desc {
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
@@ -376,6 +381,40 @@ static struct its_collection *its_build_inv_cmd(struct its_cmd_block *cmd,
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
@@ -530,6 +569,26 @@ static void its_build_sync_cmd(struct its_cmd_block *sync_cmd,
 static __its_send_single_cmd(its_send_single_command, its_cmd_builder_t,
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
@@ -693,6 +752,24 @@ static void its_irq_compose_msi_msg(struct irq_data *d, struct msi_msg *msg)
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
@@ -700,6 +777,7 @@ static struct irq_chip its_irq_chip = {
 	.irq_eoi		= irq_chip_eoi_parent,
 	.irq_set_affinity	= its_set_affinity,
 	.irq_compose_msi_msg	= its_irq_compose_msi_msg,
+	.irq_set_irqchip_state	= its_irq_set_irqchip_state,
 };
 
 /*
-- 
2.1.4
