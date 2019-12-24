Return-Path: <SRS0=PUN/=2O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B63C2D0CF
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 11:41:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 980B7206CB
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 11:41:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 980B7206CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2902E4AF5C;
	Tue, 24 Dec 2019 06:41:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T1yqLmTFRZoR; Tue, 24 Dec 2019 06:41:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0114C4AF21;
	Tue, 24 Dec 2019 06:41:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24F9A4AF3F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 06:40:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kv5tN950enZM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Dec 2019 06:40:56 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 036DE4AEFC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 06:40:56 -0500 (EST)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by cheepnis.misterjones.org with esmtpsa
 (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128) (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iji5u-000169-TW; Tue, 24 Dec 2019 12:11:19 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 11/32] irqchip/gic-v4.1: Add VPE residency callback
Date: Tue, 24 Dec 2019 11:10:34 +0000
Message-Id: <20191224111055.11836-12-maz@kernel.org>
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

Making a VPE resident on GICv4.1 is pretty simple, as it is just a
single write to the local redistributor. We just need extra information
about which groups to enable, which the KVM code will have to provide.

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c   | 17 +++++++++++++++++
 include/linux/irqchip/arm-gic-v3.h |  9 +++++++++
 include/linux/irqchip/arm-gic-v4.h |  5 +++++
 3 files changed, 31 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 0da6baa48153..49850297fe56 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3625,12 +3625,29 @@ static void its_vpe_4_1_unmask_irq(struct irq_data *d)
 	its_vpe_4_1_send_inv(d);
 }
 
+static void its_vpe_4_1_schedule(struct its_vpe *vpe,
+				 struct its_cmd_info *info)
+{
+	void __iomem *vlpi_base = gic_data_rdist_vlpi_base();
+	u64 val = 0;
+
+	/* Schedule the VPE */
+	val |= GICR_VPENDBASER_Valid;
+	val |= info->g0en ? GICR_VPENDBASER_4_1_VGRP0EN : 0;
+	val |= info->g1en ? GICR_VPENDBASER_4_1_VGRP1EN : 0;
+	val |= FIELD_PREP(GICR_VPENDBASER_4_1_VPEID, vpe->vpe_id);
+
+	gits_write_vpendbaser(val, vlpi_base + GICR_VPENDBASER);
+}
+
 static int its_vpe_4_1_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
 {
+	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
 	struct its_cmd_info *info = vcpu_info;
 
 	switch (info->cmd_type) {
 	case SCHEDULE_VPE:
+		its_vpe_4_1_schedule(vpe, info);
 		return 0;
 
 	case DESCHEDULE_VPE:
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 33519b7c96cf..1c91dede7663 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -329,6 +329,15 @@
 #define GICR_VPENDBASER_IDAI		(1ULL << 62)
 #define GICR_VPENDBASER_Valid		(1ULL << 63)
 
+/*
+ * GICv4.1 VPENDBASER, used for VPE residency. On top of these fields,
+ * also use the above Valid, PendingLast and Dirty.
+ */
+#define GICR_VPENDBASER_4_1_DB		(1ULL << 62)
+#define GICR_VPENDBASER_4_1_VGRP0EN	(1ULL << 59)
+#define GICR_VPENDBASER_4_1_VGRP1EN	(1ULL << 58)
+#define GICR_VPENDBASER_4_1_VPEID	GENMASK_ULL(15, 0)
+
 /*
  * ITS registers, offsets from ITS_base
  */
diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
index 498e523085a7..d9c34968467a 100644
--- a/include/linux/irqchip/arm-gic-v4.h
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -100,6 +100,11 @@ struct its_cmd_info {
 	union {
 		struct its_vlpi_map	*map;
 		u8			config;
+		bool			req_db;
+		struct {
+			bool		g0en;
+			bool		g1en;
+		};
 	};
 };
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
