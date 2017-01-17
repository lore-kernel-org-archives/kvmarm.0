From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 02/33] irqchip/gic-v3: Add VLPI/DirectLPI discovery
Date: Tue, 17 Jan 2017 10:20:23 +0000
Message-ID: <1484648454-21216-3-git-send-email-marc.zyngier@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70B6A400E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uX0+A4bxWA-0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jan 2017 05:19:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AE3A40194
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:26 -0500 (EST)
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

Add helper functions that probe for VLPI and DirectLPI properties.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3.c       | 22 ++++++++++++++++++++++
 include/linux/irqchip/arm-gic-v3.h |  3 +++
 2 files changed, 25 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 5cadec0..8a6de91 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -514,6 +514,24 @@ static int gic_populate_rdist(void)
 	return -ENODEV;
 }
 
+static int __gic_update_vlpi_properties(struct redist_region *region,
+					void __iomem *ptr)
+{
+	u64 typer = gic_read_typer(ptr + GICR_TYPER);
+	gic_data.rdists.has_vlpis &= !!(typer & GICR_TYPER_VLPIS);
+	gic_data.rdists.has_direct_lpi &= !!(typer & GICR_TYPER_DirectLPIS);
+
+	return 1;
+}
+
+static void gic_update_vlpi_properties(void)
+{
+	gic_scan_rdist_properties(__gic_update_vlpi_properties);
+	pr_info("%sVLPI support, %sdirect LPI support\n",
+		!gic_data.rdists.has_vlpis ? "no " : "",
+		!gic_data.rdists.has_direct_lpi ? "no " : "");
+}
+
 static void gic_cpu_sys_reg_init(void)
 {
 	/*
@@ -975,6 +993,8 @@ static int __init gic_init_bases(void __iomem *dist_base,
 	gic_data.domain = irq_domain_create_tree(handle, &gic_irq_domain_ops,
 						 &gic_data);
 	gic_data.rdists.rdist = alloc_percpu(typeof(*gic_data.rdists.rdist));
+	gic_data.rdists.has_vlpis = true;
+	gic_data.rdists.has_direct_lpi = true;
 
 	if (WARN_ON(!gic_data.domain) || WARN_ON(!gic_data.rdists.rdist)) {
 		err = -ENOMEM;
@@ -983,6 +1003,8 @@ static int __init gic_init_bases(void __iomem *dist_base,
 
 	set_handle_irq(gic_handle_irq);
 
+	gic_update_vlpi_properties();
+
 	if (IS_ENABLED(CONFIG_ARM_GIC_V3_ITS) && gic_dist_supports_lpis())
 		its_init(handle, &gic_data.rdists, gic_data.domain);
 
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index e808f8a..b162bfa 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -200,6 +200,7 @@
 
 #define GICR_TYPER_PLPIS		(1U << 0)
 #define GICR_TYPER_VLPIS		(1U << 1)
+#define GICR_TYPER_DirectLPIS		(1U << 3)
 #define GICR_TYPER_LAST			(1U << 4)
 
 #define GIC_V3_REDIST_SIZE		0x20000
@@ -427,6 +428,8 @@ struct rdists {
 	struct page		*prop_page;
 	int			id_bits;
 	u64			flags;
+	bool			has_vlpis;
+	bool			has_direct_lpi;
 };
 
 struct irq_domain;
-- 
2.1.4
