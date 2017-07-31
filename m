From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 25/59] irqchip/gic-v3-its: Add VPE affinity changes
Date: Mon, 31 Jul 2017 18:26:03 +0100
Message-ID: <20170731172637.29355-26-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C98449C25
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:26:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KaVqoEZwdnMO for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Jul 2017 13:26:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7213749C59
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:26:26 -0400 (EDT)
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

When we're about to run a vcpu, it is crucial that the redistributor
associated with the physical CPU is being told about the new residency.

This is abstracted by hijacking the irq_set_affinity method for the
doorbell interrupt associated with the VPE. It is expected that the
hypervisor will call this method before scheduling the VPE.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 96 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 16cdd1f60ebf..0a9aedaf6da2 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -148,6 +148,9 @@ static struct irq_domain *its_parent;
 #define ITS_LIST_MAX		16
 
 static unsigned long its_list_map;
+static u16 vmovp_seq_num;
+static DEFINE_RAW_SPINLOCK(vmovp_lock);
+
 static DEFINE_IDA(its_vpeid_ida);
 
 #define gic_data_rdist()		(raw_cpu_ptr(gic_rdists->rdist))
@@ -238,6 +241,13 @@ struct its_cmd_desc {
 			u32 event_id;
 			bool db_enabled;
 		} its_vmovi_cmd;
+
+		struct {
+			struct its_vpe *vpe;
+			struct its_collection *col;
+			u16 seq_num;
+			u16 its_list;
+		} its_vmovp_cmd;
 	};
 };
 
@@ -329,6 +339,16 @@ static void its_encode_db_valid(struct its_cmd_block *cmd, bool db_valid)
 	its_mask_encode(&cmd->raw_cmd[2], db_valid, 0, 0);
 }
 
+static void its_encode_seq_num(struct its_cmd_block *cmd, u16 seq_num)
+{
+	its_mask_encode(&cmd->raw_cmd[0], seq_num, 47, 32);
+}
+
+static void its_encode_its_list(struct its_cmd_block *cmd, u16 its_list)
+{
+	its_mask_encode(&cmd->raw_cmd[1], its_list, 15, 0);
+}
+
 static void its_encode_vpt_addr(struct its_cmd_block *cmd, u64 vpt_pa)
 {
 	its_mask_encode(&cmd->raw_cmd[3], vpt_pa >> 16, 50, 16);
@@ -571,6 +591,20 @@ static struct its_vpe *its_build_vmovi_cmd(struct its_cmd_block *cmd,
 	return desc->its_vmovi_cmd.vpe;
 }
 
+static struct its_vpe *its_build_vmovp_cmd(struct its_cmd_block *cmd,
+					   struct its_cmd_desc *desc)
+{
+	its_encode_cmd(cmd, GITS_CMD_VMOVP);
+	its_encode_seq_num(cmd, desc->its_vmovp_cmd.seq_num);
+	its_encode_its_list(cmd, desc->its_vmovp_cmd.its_list);
+	its_encode_vpeid(cmd, desc->its_vmovp_cmd.vpe->vpe_id);
+	its_encode_target(cmd, desc->its_vmovp_cmd.col->target_address);
+
+	its_fixup_cmd(cmd);
+
+	return desc->its_vmovp_cmd.vpe;
+}
+
 static u64 its_cmd_ptr_to_offset(struct its_node *its,
 				 struct its_cmd_block *ptr)
 {
@@ -865,6 +899,48 @@ static void its_send_vmapp(struct its_vpe *vpe, bool valid)
 	}
 }
 
+static void its_send_vmovp(struct its_vpe *vpe)
+{
+	struct its_cmd_desc desc;
+	struct its_node *its;
+	unsigned long flags;
+	int col_id = vpe->col_idx;
+
+	desc.its_vmovp_cmd.vpe = vpe;
+	desc.its_vmovp_cmd.its_list = (u16)its_list_map;
+
+	if (!its_list_map) {
+		its = list_first_entry(&its_nodes, struct its_node, entry);
+		desc.its_vmovp_cmd.seq_num = 0;
+		desc.its_vmovp_cmd.col = &its->collections[col_id];
+		its_send_single_vcommand(its, its_build_vmovp_cmd, &desc);
+		return;
+	}
+
+	/*
+	 * Yet another marvel of the architecture. If using the
+	 * its_list "feature", we need to make sure that all ITSs
+	 * receive all VMOVP commands in the same order. The only way
+	 * to guarantee this is to make vmovp a serialization point.
+	 *
+	 * Wall <-- Head.
+	 */
+	raw_spin_lock_irqsave(&vmovp_lock, flags);
+
+	desc.its_vmovp_cmd.seq_num = vmovp_seq_num++;
+
+	/* Emit VMOVPs */
+	list_for_each_entry(its, &its_nodes, entry) {
+		if (!its->is_v4)
+			continue;
+
+		desc.its_vmovp_cmd.col = &its->collections[col_id];
+		its_send_single_vcommand(its, its_build_vmovp_cmd, &desc);
+	}
+
+	raw_spin_unlock_irqrestore(&vmovp_lock, flags);
+}
+
 static void its_send_vinvall(struct its_vpe *vpe)
 {
 	struct its_cmd_desc desc;
@@ -2148,6 +2224,25 @@ static const struct irq_domain_ops its_domain_ops = {
 	.deactivate		= its_irq_domain_deactivate,
 };
 
+static int its_vpe_set_affinity(struct irq_data *d,
+				const struct cpumask *mask_val,
+				bool force)
+{
+	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
+	int cpu = cpumask_first(mask_val);
+
+	/*
+	 * Changing affinity is mega expensive, so let's be as lazy as
+	 * we can and only do it if we really have to.
+	 */
+	if (vpe->col_idx != cpu) {
+		vpe->col_idx = cpu;
+		its_send_vmovp(vpe);
+	}
+
+	return IRQ_SET_MASK_OK_DONE;
+}
+
 static void its_vpe_schedule(struct its_vpe *vpe)
 {
 	void * __iomem vlpi_base = gic_data_rdist_vlpi_base();
@@ -2237,6 +2332,7 @@ static int its_vpe_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
 
 static struct irq_chip its_vpe_irq_chip = {
 	.name			= "GICv4-vpe",
+	.irq_set_affinity	= its_vpe_set_affinity,
 	.irq_set_vcpu_affinity	= its_vpe_set_vcpu_affinity,
 };
 
-- 
2.11.0
