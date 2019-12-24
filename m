Return-Path: <SRS0=PUN/=2O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BAB7C2D0D2
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 11:11:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 50AB420409
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 11:11:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 50AB420409
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09E2C4AF74;
	Tue, 24 Dec 2019 06:11:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AmBPRw9FNtFO; Tue, 24 Dec 2019 06:11:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 575744AF5E;
	Tue, 24 Dec 2019 06:11:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5929F4AF55
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 06:11:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FkALu8GmzaMm for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Dec 2019 06:11:21 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AAC4C4AF5E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 06:11:17 -0500 (EST)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by cheepnis.misterjones.org with esmtpsa
 (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128) (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iji5s-000169-GZ; Tue, 24 Dec 2019 12:11:16 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 08/32] irqchip/gic-v4.1: Implement the v4.1 flavour of VMOVP
Date: Tue, 24 Dec 2019 11:10:31 +0000
Message-Id: <20191224111055.11836-9-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191224111055.11836-1-maz@kernel.org>
References: <20191224111055.11836-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, tglx@linutronix.de, jason@lakedaemon.net,
 lorenzo.pieralisi@arm.com, Andrew.Murray@arm.com, yuzenghui@huawei.com,
 rrichter@marvell.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, Robert Richter <rrichter@marvell.com>,
 Thomas Gleixner <tglx@linutronix.de>
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

With GICv4.1, VMOVP is extended to allow a default doorbell to be
specified, as well as a validity bit for this doorbell. As an added
bonus, VMOVP isn't required anymore of moving a VPE between
redistributors that share the same affinity.

Let's add this support to the VMOVP builder, and make sure we don't
issue the command if we don't really need to.

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 40 ++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 86c69b5cc156..fd9d3b6bb465 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -471,6 +471,17 @@ static void its_encode_vmapp_default_db(struct its_cmd_block *cmd,
 	its_mask_encode(&cmd->raw_cmd[1], vpe_db_lpi, 31, 0);
 }
 
+static void its_encode_vmovp_default_db(struct its_cmd_block *cmd,
+					u32 vpe_db_lpi)
+{
+	its_mask_encode(&cmd->raw_cmd[3], vpe_db_lpi, 31, 0);
+}
+
+static void its_encode_db(struct its_cmd_block *cmd, bool db)
+{
+	its_mask_encode(&cmd->raw_cmd[2], db, 63, 63);
+}
+
 static inline void its_fixup_cmd(struct its_cmd_block *cmd)
 {
 	/* Let's fixup BE commands */
@@ -757,6 +768,11 @@ static struct its_vpe *its_build_vmovp_cmd(struct its_node *its,
 	its_encode_vpeid(cmd, desc->its_vmovp_cmd.vpe->vpe_id);
 	its_encode_target(cmd, target);
 
+	if (is_v4_1(its)) {
+		its_encode_db(cmd, true);
+		its_encode_vmovp_default_db(cmd, desc->its_vmovp_cmd.vpe->vpe_db_lpi);
+	}
+
 	its_fixup_cmd(cmd);
 
 	return valid_vpe(its, desc->its_vmovp_cmd.vpe);
@@ -3328,7 +3344,7 @@ static int its_vpe_set_affinity(struct irq_data *d,
 				bool force)
 {
 	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
-	int cpu = cpumask_first(mask_val);
+	int from, cpu = cpumask_first(mask_val);
 
 	/*
 	 * Changing affinity is mega expensive, so let's be as lazy as
@@ -3336,14 +3352,24 @@ static int its_vpe_set_affinity(struct irq_data *d,
 	 * into the proxy device, we need to move the doorbell
 	 * interrupt to its new location.
 	 */
-	if (vpe->col_idx != cpu) {
-		int from = vpe->col_idx;
+	if (vpe->col_idx == cpu)
+		goto out;
 
-		vpe->col_idx = cpu;
-		its_send_vmovp(vpe);
-		its_vpe_db_proxy_move(vpe, from, cpu);
-	}
+	from = vpe->col_idx;
+	vpe->col_idx = cpu;
+
+	/*
+	 * GICv4.1 allows us to skip VMOVP if moving to a cpu whose RD
+	 * is sharing its VPE table with the current one.
+	 */
+	if (gic_data_rdist_cpu(cpu)->vpe_table_mask &&
+	    cpumask_test_cpu(from, gic_data_rdist_cpu(cpu)->vpe_table_mask))
+		goto out;
 
+	its_send_vmovp(vpe);
+	its_vpe_db_proxy_move(vpe, from, cpu);
+
+out:
 	irq_data_update_effective_affinity(d, cpumask_of(cpu));
 
 	return IRQ_SET_MASK_OK_DONE;
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
