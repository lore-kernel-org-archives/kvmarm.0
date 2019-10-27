Return-Path: <SRS0=uKin=YU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D94CA9EBC
	for <kvmarm@archiver.kernel.org>; Sun, 27 Oct 2019 14:45:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 959F921726
	for <kvmarm@archiver.kernel.org>; Sun, 27 Oct 2019 14:45:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="GoZnRWa+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 959F921726
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C9DA4A588;
	Sun, 27 Oct 2019 10:45:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tpP7HmAyfBx8; Sun, 27 Oct 2019 10:45:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8F4C4AC6D;
	Sun, 27 Oct 2019 10:45:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16B014A4DF
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Oct 2019 10:45:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vl6tXJNHFkY2 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 27 Oct 2019 10:45:44 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B5254AC7A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Oct 2019 10:45:44 -0400 (EDT)
Received: from localhost.localdomain (82-132-239-15.dab.02.net [82.132.239.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 964F321850;
 Sun, 27 Oct 2019 14:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1572187543;
 bh=4p4ehDbcCf4jnmfKNDLsUPCt4d6b7P7XIpiuyCs7Ofo=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=GoZnRWa+aDn+mA8azofDmsN4Ly7qmoJlLT5hFFszRjEDqqBYGiAzCtyDYVyx4rF23
 tFXKiBTb8VjZqq2XTWVqzYvMAwP83czNwdh3ggALHaPkah00RBJ+0E5qlRy03sV59G
 uNwbNjWecXnReaaGyGKg+gc+Ml3RdDzkvoHJWKiY=
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 25/36] irqchip/gic-v4.1: Add initial SGI configuration
Date: Sun, 27 Oct 2019 14:42:23 +0000
Message-Id: <20191027144234.8395-26-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191027144234.8395-1-maz@kernel.org>
References: <20191027144234.8395-1-maz@kernel.org>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, Robert Richter <rrichter@marvell.com>,
 Jayachandran C <jnair@marvell.com>, Thomas Gleixner <tglx@linutronix.de>
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
index 6a3952d3c379..ef5988724aa3 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -329,6 +329,15 @@ struct its_cmd_desc {
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
 
@@ -474,6 +483,31 @@ static void its_encode_db(struct its_cmd_block *cmd, bool db)
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
@@ -785,6 +819,26 @@ static struct its_vpe *its_build_invdb_cmd(struct its_node *its,
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
@@ -3581,6 +3635,38 @@ static struct irq_chip its_vpe_4_1_irq_chip = {
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
@@ -3626,6 +3712,8 @@ static void its_sgi_irq_domain_free(struct irq_domain *domain,
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
