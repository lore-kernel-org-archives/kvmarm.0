From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 22/33] irqchip/gic-v3-its: Add VPE irq domain
 [de]activation
Date: Tue, 17 Jan 2017 10:20:43 +0000
Message-ID: <1484648454-21216-23-git-send-email-marc.zyngier@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1660A407E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hmzznt7bRxXX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jan 2017 05:19:54 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48C69405E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:54 -0500 (EST)
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

On activation, a VPE is mapped using the VMAPP command, followed
by a VINVALL for a good measure. On deactivation, the VPE is
simply unmapped.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 102 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 54d0075..598e25b 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -206,6 +206,16 @@ struct its_cmd_desc {
 
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
@@ -309,6 +319,16 @@ static void its_encode_db_valid(struct its_cmd_block *cmd, bool db_valid)
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
@@ -467,6 +487,36 @@ static struct its_collection *its_build_invall_cmd(struct its_cmd_block *cmd,
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
+	its_encode_vpt_addr(cmd, vpt_addr >> 16);
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
@@ -784,6 +834,37 @@ static void its_send_vmovi(struct its_device *dev, u32 id)
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
@@ -2094,9 +2175,30 @@ static void its_vpe_irq_domain_free(struct irq_domain *domain,
 	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
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
2.1.4
