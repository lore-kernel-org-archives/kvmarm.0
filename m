Return-Path: <SRS0=gg7X=XS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49591C4CEC4
	for <kvmarm@archiver.kernel.org>; Mon, 23 Sep 2019 18:27:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 06D9621783
	for <kvmarm@archiver.kernel.org>; Mon, 23 Sep 2019 18:27:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 06D9621783
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B64184A5EE;
	Mon, 23 Sep 2019 14:27:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Dxrqydco4LoZ; Mon, 23 Sep 2019 14:27:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76BFB4A5A6;
	Mon, 23 Sep 2019 14:27:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 844614A5BD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Sep 2019 14:27:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t3GuL7DqR5UM for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Sep 2019 14:27:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6855E4A677
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Sep 2019 14:27:22 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39C9E1B8E;
 Mon, 23 Sep 2019 11:27:22 -0700 (PDT)
Received: from big-swifty.lan (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 25C0F3F694;
 Mon, 23 Sep 2019 11:27:18 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH 15/35] irqchip/gic-v4.1: Add mask/unmask doorbell callbacks
Date: Mon, 23 Sep 2019 19:25:46 +0100
Message-Id: <20190923182606.32100-16-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190923182606.32100-1-maz@kernel.org>
References: <20190923182606.32100-1-maz@kernel.org>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

masking/unmasking doorbells on GICv4.1 relies on a new INVDB command,
which broadcasts the invalidation to all RDs.

Implement the new command as well as the masking callbacks, and plug
the whole thing into the v4.1 VPE irqchip.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c   | 60 ++++++++++++++++++++++++++++++
 include/linux/irqchip/arm-gic-v3.h |  3 +-
 2 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 4098ef6d030a..36653db372bc 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -309,6 +309,10 @@ struct its_cmd_desc {
 			u16 seq_num;
 			u16 its_list;
 		} its_vmovp_cmd;
+
+		struct {
+			struct its_vpe *vpe;
+		} its_invdb_cmd;
 	};
 };
 
@@ -750,6 +754,21 @@ static struct its_vpe *its_build_vmovp_cmd(struct its_node *its,
 	return valid_vpe(its, desc->its_vmovp_cmd.vpe);
 }
 
+static struct its_vpe *its_build_invdb_cmd(struct its_node *its,
+					   struct its_cmd_block *cmd,
+					   struct its_cmd_desc *desc)
+{
+	if (WARN_ON(!is_v4_1(its)))
+		return NULL;
+
+	its_encode_cmd(cmd, GITS_CMD_INVDB);
+	its_encode_vpeid(cmd, desc->its_invdb_cmd.vpe->vpe_id);
+
+	its_fixup_cmd(cmd);
+
+	return valid_vpe(its, desc->its_invdb_cmd.vpe);
+}
+
 static u64 its_cmd_ptr_to_offset(struct its_node *its,
 				 struct its_cmd_block *ptr)
 {
@@ -1117,6 +1136,14 @@ static void its_send_vinvall(struct its_node *its, struct its_vpe *vpe)
 	its_send_single_vcommand(its, its_build_vinvall_cmd, &desc);
 }
 
+static void its_send_invdb(struct its_node *its, struct its_vpe *vpe)
+{
+	struct its_cmd_desc desc;
+
+	desc.its_invdb_cmd.vpe = vpe;
+	its_send_single_vcommand(its, its_build_invdb_cmd, &desc);
+}
+
 /*
  * irqchip functions - assumes MSI, mostly.
  */
@@ -3403,6 +3430,37 @@ static struct irq_chip its_vpe_irq_chip = {
 	.irq_set_vcpu_affinity	= its_vpe_set_vcpu_affinity,
 };
 
+static void its_vpe_4_1_send_inv(struct irq_data *d)
+{
+	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
+	struct its_node *its;
+
+	/*
+	 * GICv4.1 wants doorbells to be invalidated using the
+	 * INVDB command in order to be broadcast to all RDs. Send
+	 * it to the first valid ITS, and let the HW do its magic.
+	 */
+	list_for_each_entry(its, &its_nodes, entry) {
+		if (!is_v4_1(its))
+			continue;
+
+		its_send_invdb(its, vpe);
+		break;
+	}
+}
+
+static void its_vpe_4_1_mask_irq(struct irq_data *d)
+{
+	lpi_write_config(d->parent_data, LPI_PROP_ENABLED, 0);
+	its_vpe_4_1_send_inv(d);
+}
+
+static void its_vpe_4_1_unmask_irq(struct irq_data *d)
+{
+	lpi_write_config(d->parent_data, 0, LPI_PROP_ENABLED);
+	its_vpe_4_1_send_inv(d);
+}
+
 static int its_vpe_4_1_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
 {
 	struct its_cmd_info *info = vcpu_info;
@@ -3424,6 +3482,8 @@ static int its_vpe_4_1_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
 
 static struct irq_chip its_vpe_4_1_irq_chip = {
 	.name			= "GICv4.1-vpe",
+	.irq_mask		= its_vpe_4_1_mask_irq,
+	.irq_unmask		= its_vpe_4_1_unmask_irq,
 	.irq_eoi		= irq_chip_eoi_parent,
 	.irq_set_affinity	= its_vpe_set_affinity,
 	.irq_set_vcpu_affinity	= its_vpe_4_1_set_vcpu_affinity,
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index f1d6de53e09b..8157737053e4 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -484,8 +484,9 @@
 #define GITS_CMD_VMAPTI			GITS_CMD_GICv4(GITS_CMD_MAPTI)
 #define GITS_CMD_VMOVI			GITS_CMD_GICv4(GITS_CMD_MOVI)
 #define GITS_CMD_VSYNC			GITS_CMD_GICv4(GITS_CMD_SYNC)
-/* VMOVP is the odd one, as it doesn't have a physical counterpart */
+/* VMOVP and INVDB are the odd ones, as they dont have a physical counterpart */
 #define GITS_CMD_VMOVP			GITS_CMD_GICv4(2)
+#define GITS_CMD_INVDB			GITS_CMD_GICv4(0xe)
 
 /*
  * ITS error numbers
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
