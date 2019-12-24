Return-Path: <SRS0=PUN/=2O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A7DC2D0CF
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 11:11:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3B95E20409
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 11:11:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B95E20409
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E83E74AF71;
	Tue, 24 Dec 2019 06:11:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F7byUVkBbdCL; Tue, 24 Dec 2019 06:11:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B30004AF77;
	Tue, 24 Dec 2019 06:11:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF0534AF5D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 06:11:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JBjl46+scStB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Dec 2019 06:11:13 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C506B4AF41
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 06:11:13 -0500 (EST)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by cheepnis.misterjones.org with esmtpsa
 (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128) (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iji5n-000169-9k; Tue, 24 Dec 2019 12:11:11 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 02/32] irqchip/gic-v3: Add GICv4.1 VPEID size discovery
Date: Tue, 24 Dec 2019 11:10:25 +0000
Message-Id: <20191224111055.11836-3-maz@kernel.org>
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

While GICv4.0 mandates 16 bit worth of VPEIDs, GICv4.1 allows smaller
implementations to be built. Add the required glue to dynamically
compute the limit.

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c   | 11 ++++++++++-
 drivers/irqchip/irq-gic-v3.c       |  3 +++
 include/linux/irqchip/arm-gic-v3.h |  5 +++++
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index e05673bcd52b..d9d256471dc0 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -121,7 +121,16 @@ struct its_node {
 #define ITS_ITT_ALIGN		SZ_256
 
 /* The maximum number of VPEID bits supported by VLPI commands */
-#define ITS_MAX_VPEID_BITS	(16)
+#define ITS_MAX_VPEID_BITS						\
+	({								\
+		int nvpeid = 16;					\
+		if (gic_rdists->has_rvpeid &&				\
+		    gic_rdists->gicd_typer2 & GICD_TYPER2_VIL)		\
+			nvpeid = 1 + (gic_rdists->gicd_typer2 &		\
+				      GICD_TYPER2_VID);			\
+									\
+		nvpeid;							\
+	})
 #define ITS_MAX_VPEID		(1 << (ITS_MAX_VPEID_BITS))
 
 /* Convert page order to size in bytes */
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index ffcb018395ed..286f98222878 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -1576,6 +1576,9 @@ static int __init gic_init_bases(void __iomem *dist_base,
 
 	pr_info("%d SPIs implemented\n", GIC_LINE_NR - 32);
 	pr_info("%d Extended SPIs implemented\n", GIC_ESPI_NR);
+
+	gic_data.rdists.gicd_typer2 = readl_relaxed(gic_data.dist_base + GICD_TYPER2);
+
 	gic_data.domain = irq_domain_create_tree(handle, &gic_irq_domain_ops,
 						 &gic_data);
 	irq_domain_update_bus_token(gic_data.domain, DOMAIN_BUS_WIRED);
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 9a5f85d30701..9dfe64189d99 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -13,6 +13,7 @@
 #define GICD_CTLR			0x0000
 #define GICD_TYPER			0x0004
 #define GICD_IIDR			0x0008
+#define GICD_TYPER2			0x000C
 #define GICD_STATUSR			0x0010
 #define GICD_SETSPI_NSR			0x0040
 #define GICD_CLRSPI_NSR			0x0048
@@ -89,6 +90,9 @@
 #define GICD_TYPER_ESPIS(typer)						\
 	(((typer) & GICD_TYPER_ESPI) ? GICD_TYPER_SPIS((typer) >> 27) : 0)
 
+#define GICD_TYPER2_VIL			(1U << 7)
+#define GICD_TYPER2_VID			GENMASK(4, 0)
+
 #define GICD_IROUTER_SPI_MODE_ONE	(0U << 31)
 #define GICD_IROUTER_SPI_MODE_ANY	(1U << 31)
 
@@ -615,6 +619,7 @@ struct rdists {
 	void			*prop_table_va;
 	u64			flags;
 	u32			gicd_typer;
+	u32			gicd_typer2;
 	bool			has_vlpis;
 	bool			has_rvpeid;
 	bool			has_direct_lpi;
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
