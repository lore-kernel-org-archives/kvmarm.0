Return-Path: <SRS0=gg7X=XS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F0C1C4CECF
	for <kvmarm@archiver.kernel.org>; Mon, 23 Sep 2019 18:28:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4345C20665
	for <kvmarm@archiver.kernel.org>; Mon, 23 Sep 2019 18:28:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4345C20665
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F25C14A57B;
	Mon, 23 Sep 2019 14:28:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oDkzdQW3qXwz; Mon, 23 Sep 2019 14:28:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B186A4A67A;
	Mon, 23 Sep 2019 14:28:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 487534A555
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Sep 2019 14:27:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dNAtN0nEVNRd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Sep 2019 14:27:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 266874A5A0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Sep 2019 14:27:58 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EDF7422C8;
 Mon, 23 Sep 2019 11:27:57 -0700 (PDT)
Received: from big-swifty.lan (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7A8643F694;
 Mon, 23 Sep 2019 11:27:55 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH 24/35] irqchip/gic-v4.1: Add initial SGI configuration
Date: Mon, 23 Sep 2019 19:25:55 +0100
Message-Id: <20190923182606.32100-25-maz@kernel.org>
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

The GICv4.1 ITS has yet another new command (VSGI) which allows
a VPE-targeted SGI to be configured (or have its pending state
cleared). Add support for this command and plumb it into the
activate irqdomain callback so that it is ready to be used.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c   | 88 ++++++++++++++++++++++++++++++
 include/linux/irqchip/arm-gic-v3.h |  3 +-
 2 files changed, 90 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 69c26be709be..5234b9eef8ad 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -314,6 +314,15 @@ struct its_cmd_desc {
 		struct {
 			struct its_vpe *vpe;
 		} its_invdb_cmd;
+
+		struct {
+			struct its_vpe *vpe;
+			u8 sgi;
+			u8 priority;
+			bool enable;
+			bool group;
+			bool clear;
+		} its_vsgi_cmd;
 	};
 };
 
@@ -459,6 +468,31 @@ static void its_encode_db(struct its_cmd_block *cmd, bool db)
 	its_mask_encode(&cmd->raw_cmd[2], db, 63, 63);
 }
 
+static void its_encode_sgi_intid(struct its_cmd_block *cmd, u8 sgi)
+{
+	its_mask_encode(&cmd->raw_cmd[0], sgi, 35, 32);
+}
+
+static void its_encode_sgi_priority(struct its_cmd_block *cmd, u8 prio)
+{
+	its_mask_encode(&cmd->raw_cmd[0], prio >> 4, 23, 20);
+}
+
+static void its_encode_sgi_group(struct its_cmd_block *cmd, bool grp)
+{
+	its_mask_encode(&cmd->raw_cmd[0], grp, 10, 10);
+}
+
+static void its_encode_sgi_clear(struct its_cmd_block *cmd, bool clr)
+{
+	its_mask_encode(&cmd->raw_cmd[0], clr, 9, 9);
+}
+
+static void its_encode_sgi_enable(struct its_cmd_block *cmd, bool en)
+{
+	its_mask_encode(&cmd->raw_cmd[0], en, 8, 8);
+}
+
 static inline void its_fixup_cmd(struct its_cmd_block *cmd)
 {
 	/* Let's fixup BE commands */
@@ -770,6 +804,26 @@ static struct its_vpe *its_build_invdb_cmd(struct its_node *its,
 	return valid_vpe(its, desc->its_invdb_cmd.vpe);
 }
 
+static struct its_vpe *its_build_vsgi_cmd(struct its_node *its,
+					  struct its_cmd_block *cmd,
+					  struct its_cmd_desc *desc)
+{
+	if (WARN_ON(!is_v4_1(its)))
+		return NULL;
+
+	its_encode_cmd(cmd, GITS_CMD_VSGI);
+	its_encode_vpeid(cmd, desc->its_vsgi_cmd.vpe->vpe_id);
+	its_encode_sgi_intid(cmd, desc->its_vsgi_cmd.sgi);
+	its_encode_sgi_priority(cmd, desc->its_vsgi_cmd.priority);
+	its_encode_sgi_group(cmd, desc->its_vsgi_cmd.group);
+	its_encode_sgi_clear(cmd, desc->its_vsgi_cmd.clear);
+	its_encode_sgi_enable(cmd, desc->its_vsgi_cmd.enable);
+
+	its_fixup_cmd(cmd);
+
+	return valid_vpe(its, desc->its_vsgi_cmd.vpe);
+}
+
 static u64 its_cmd_ptr_to_offset(struct its_node *its,
 				 struct its_cmd_block *ptr)
 {
@@ -3574,6 +3628,38 @@ static struct irq_chip its_vpe_4_1_irq_chip = {
 	.irq_set_vcpu_affinity	= its_vpe_4_1_set_vcpu_affinity,
 };
 
+static struct its_node *find_4_1_its(void)
+{
+	static struct its_node *its = NULL;
+
+	if (!its) {
+		list_for_each_entry(its, &its_nodes, entry) {
+			if (is_v4_1(its))
+				return its;
+		}
+
+		/* Oops? */
+		its = NULL;
+	}
+
+	return its;
+}
+
+static void its_configure_sgi(struct irq_data *d, bool clear)
+{
+	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
+	struct its_cmd_desc desc;
+
+	desc.its_vsgi_cmd.vpe = vpe;
+	desc.its_vsgi_cmd.sgi = d->hwirq;
+	desc.its_vsgi_cmd.priority = vpe->sgi_config[d->hwirq].priority;
+	desc.its_vsgi_cmd.enable = vpe->sgi_config[d->hwirq].enabled;
+	desc.its_vsgi_cmd.group = vpe->sgi_config[d->hwirq].group;
+	desc.its_vsgi_cmd.clear = clear;
+
+	its_send_single_vcommand(find_4_1_its(), its_build_vsgi_cmd, &desc);
+}
+
 static int its_sgi_set_affinity(struct irq_data *d,
 				const struct cpumask *mask_val,
 				bool force)
@@ -3619,6 +3705,8 @@ static void its_sgi_irq_domain_free(struct irq_domain *domain,
 static int its_sgi_irq_domain_activate(struct irq_domain *domain,
 				       struct irq_data *d, bool reserve)
 {
+	/* Write out the initial SGI configuration */
+	its_configure_sgi(d, false);
 	return 0;
 }
 
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 5f3278cbf247..c73176d3ab2b 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -497,8 +497,9 @@
 #define GITS_CMD_VMAPTI			GITS_CMD_GICv4(GITS_CMD_MAPTI)
 #define GITS_CMD_VMOVI			GITS_CMD_GICv4(GITS_CMD_MOVI)
 #define GITS_CMD_VSYNC			GITS_CMD_GICv4(GITS_CMD_SYNC)
-/* VMOVP and INVDB are the odd ones, as they dont have a physical counterpart */
+/* VMOVP, VSGI and INVDB are the odd ones, as they dont have a physical counterpart */
 #define GITS_CMD_VMOVP			GITS_CMD_GICv4(2)
+#define GITS_CMD_VSGI			GITS_CMD_GICv4(3)
 #define GITS_CMD_INVDB			GITS_CMD_GICv4(0xe)
 
 /*
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
