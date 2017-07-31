From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 19/59] irqchip/gic-v3-its: Add VPE domain infrastructure
Date: Mon, 31 Jul 2017 18:25:57 +0100
Message-ID: <20170731172637.29355-20-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A555449C23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:26:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qL8NU5wMa4R0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Jul 2017 13:26:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF62E4104E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:26:12 -0400 (EDT)
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

Add the basic GICv4 VPE (vcpu in GICv4 parlance) infrastructure
(irqchip, irq domain) that is going to be populated in the following
patches.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index b618c259be8b..1fa345d53088 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2026,6 +2026,13 @@ static const struct irq_domain_ops its_domain_ops = {
 	.deactivate		= its_irq_domain_deactivate,
 };
 
+static struct irq_chip its_vpe_irq_chip = {
+	.name			= "GICv4-vpe",
+};
+
+static const struct irq_domain_ops its_vpe_domain_ops = {
+};
+
 static int its_force_quiescent(void __iomem *base)
 {
 	u32 count = 1000000;	/* 1s */
@@ -2142,6 +2149,11 @@ static int its_init_domain(struct fwnode_handle *handle, struct its_node *its)
 	return 0;
 }
 
+static int its_init_vpe_domain(void)
+{
+	return 0;
+}
+
 static int __init its_compute_its_list_map(struct resource *res,
 					   void __iomem *its_base)
 {
@@ -2484,6 +2496,9 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
 		    struct irq_domain *parent_domain)
 {
 	struct device_node *of_node;
+	struct its_node *its;
+	bool has_v4 = false;
+	int err;
 
 	its_parent = parent_domain;
 	of_node = to_of_node(handle);
@@ -2498,5 +2513,21 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
 	}
 
 	gic_rdists = rdists;
-	return its_alloc_lpi_tables();
+	err = its_alloc_lpi_tables();
+	if (err)
+		return err;
+
+	its_lpi_init(rdists->id_bits);
+
+	list_for_each_entry(its, &its_nodes, entry)
+		has_v4 |= its->is_v4;
+
+	if (has_v4 & rdists->has_vlpis) {
+		if (its_init_vpe_domain()) {
+			rdists->has_vlpis = false;
+			pr_err("ITS: Disabling GICv4 support\n");
+		}
+	}
+
+	return 0;
 }
-- 
2.11.0
