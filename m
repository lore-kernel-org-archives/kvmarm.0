From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 21/59] irqchip/gic-v3-its: Add VPE irq domain [de]activation
Date: Mon, 31 Jul 2017 18:25:59 +0100
Message-ID: <20170731172637.29355-22-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A767749C2B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:26:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xi1CdwxCkLOX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Jul 2017 13:26:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 545DB4104E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:26:17 -0400 (EDT)
In-Reply-To: <20170731172637.29355-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

On activation, a VPE is mapped using the VMAPP command, followed
by a VINVALL for a good measure. On deactivation, the VPE is
simply unmapped.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 102 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 0f9a487448b9..5ca1e571c1b4 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -215,6 +215,16 @@ struct its_cmd_desc {
 
 		struct {
 			struct its_vpe *vpe;
+		} its_vinvall_cmd;
+
+		struct {
+			struct its_vpe *vpe;
+			struct its_collection *col;
+			bool valid;
+		} its_vmapp_cmd;
+
+		struct {
+			struct its_vpe *vpe;
 			struct its_device *dev;
 			u32 virt_id;
 			u32 event_id;
@@ -318,6 +328,16 @@ static void its_encode_db_valid(struct its_cmd_block *cmd, bool db_valid)
 	its_mask_encode(&cmd->raw_cmd[2], db_valid, 0, 0);
 }
 
+static void its_encode_vpt_addr(struct its_cmd_block *cmd, u64 vpt_pa)
+{
+	its_mask_encode(&cmd->raw_cmd[3], vpt_pa >> 16, 50, 16);
+}
+
+static void its_encode_vpt_size(struct its_cmd_block *cmd, u8 vpt_size)
+{
+	its_mask_encode(&cmd->raw_cmd[3], vpt_size, 4, 0);
+}
+
 static inline void its_fixup_cmd(struct its_cmd_block *cmd)
 {
 	/* Let's fixup BE commands */
@@ -476,6 +496,36 @@ static struct its_collection *its_build_invall_cmd(struct its_cmd_block *cmd,
 	return NULL;
 }
 
+static struct its_vpe *its_build_vinvall_cmd(struct its_cmd_block *cmd,
+					     struct its_cmd_desc *desc)
+{
+	its_encode_cmd(cmd, GITS_CMD_VINVALL);
+	its_encode_vpeid(cmd, desc->its_vinvall_cmd.vpe->vpe_id);
+
+	its_fixup_cmd(cmd);
+
+	return desc->its_vinvall_cmd.vpe;
+}
+
+static struct its_vpe *its_build_vmapp_cmd(struct its_cmd_block *cmd,
+					   struct its_cmd_desc *desc)
+{
+	unsigned long vpt_addr;
+
+	vpt_addr = virt_to_phys(page_address(desc->its_vmapp_cmd.vpe->vpt_page));
+
+	its_encode_cmd(cmd, GITS_CMD_VMAPP);
+	its_encode_vpeid(cmd, desc->its_vmapp_cmd.vpe->vpe_id);
+	its_encode_valid(cmd, desc->its_vmapp_cmd.valid);
+	its_encode_target(cmd, desc->its_vmapp_cmd.col->target_address);
+	its_encode_vpt_addr(cmd, vpt_addr);
+	its_encode_vpt_size(cmd, LPI_NRBITS - 1);
+
+	its_fixup_cmd(cmd);
+
+	return desc->its_vmapp_cmd.vpe;
+}
+
 static struct its_vpe *its_build_vmapti_cmd(struct its_cmd_block *cmd,
 					    struct its_cmd_desc *desc)
 {
@@ -797,6 +847,37 @@ static void its_send_vmovi(struct its_device *dev, u32 id)
 	its_send_single_vcommand(dev->its, its_build_vmovi_cmd, &desc);
 }
 
+static void its_send_vmapp(struct its_vpe *vpe, bool valid)
+{
+	struct its_cmd_desc desc;
+	struct its_node *its;
+
+	desc.its_vmapp_cmd.vpe = vpe;
+	desc.its_vmapp_cmd.valid = valid;
+
+	list_for_each_entry(its, &its_nodes, entry) {
+		if (!its->is_v4)
+			continue;
+
+		desc.its_vmapp_cmd.col = &its->collections[vpe->col_idx];
+		its_send_single_vcommand(its, its_build_vmapp_cmd, &desc);
+	}
+}
+
+static void its_send_vinvall(struct its_vpe *vpe)
+{
+	struct its_cmd_desc desc;
+	struct its_node *its;
+
+	desc.its_vinvall_cmd.vpe = vpe;
+
+	list_for_each_entry(its, &its_nodes, entry) {
+		if (!its->is_v4)
+			continue;
+		its_send_single_vcommand(its, its_build_vinvall_cmd, &desc);
+	}
+}
+
 /*
  * irqchip functions - assumes MSI, mostly.
  */
@@ -2197,9 +2278,30 @@ static int its_vpe_irq_domain_alloc(struct irq_domain *domain, unsigned int virq
 	return err;
 }
 
+static void its_vpe_irq_domain_activate(struct irq_domain *domain,
+					struct irq_data *d)
+{
+	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
+
+	/* Map the VPE to the first possible CPU */
+	vpe->col_idx = cpumask_first(cpu_online_mask);
+	its_send_vmapp(vpe, true);
+	its_send_vinvall(vpe);
+}
+
+static void its_vpe_irq_domain_deactivate(struct irq_domain *domain,
+					  struct irq_data *d)
+{
+	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
+
+	its_send_vmapp(vpe, false);
+}
+
 static const struct irq_domain_ops its_vpe_domain_ops = {
 	.alloc			= its_vpe_irq_domain_alloc,
 	.free			= its_vpe_irq_domain_free,
+	.activate		= its_vpe_irq_domain_activate,
+	.deactivate		= its_vpe_irq_domain_deactivate,
 };
 
 static int its_force_quiescent(void __iomem *base)
-- 
2.11.0
