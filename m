From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 20/33] irqchip/gic-v3-its: Add VPE domain infrastructure
Date: Tue, 17 Jan 2017 10:20:41 +0000
Message-ID: <1484648454-21216-21-git-send-email-marc.zyngier@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFE844086D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a7j8++uRLUO1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jan 2017 05:19:51 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85BAE408BA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:51 -0500 (EST)
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

Add the basic GICv4 VPE (vcpu in GICv4 parlance) infrastructure
(irqchip, irq domain) that is going to be populated in the following
patches.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 6931018..ddd8096 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1918,6 +1918,13 @@ static const struct irq_domain_ops its_domain_ops = {
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
@@ -2017,6 +2024,27 @@ static int its_init_domain(struct fwnode_handle *handle, struct its_node *its)
 	return 0;
 }
 
+static struct irq_domain *its_init_vpe_domain(void)
+{
+	struct fwnode_handle *handle;
+	struct irq_domain *domain;
+
+	handle = irq_domain_alloc_fwnode("VPE domain");
+	if (!handle)
+		return NULL;
+
+	domain = irq_domain_create_tree(handle, &its_vpe_domain_ops, NULL);
+	if (!domain) {
+		kfree(handle);
+		return NULL;
+	}
+
+	domain->parent = its_parent;
+	domain->bus_token = DOMAIN_BUS_NEXUS;
+
+	return domain;
+}
+
 static int __init its_probe_one(struct resource *res,
 				struct fwnode_handle *handle, int numa_node)
 {
@@ -2266,6 +2294,8 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
 		    struct irq_domain *parent_domain)
 {
 	struct device_node *of_node;
+	struct its_node *its;
+	bool has_v4 = false;
 
 	its_parent = parent_domain;
 	of_node = to_of_node(handle);
@@ -2283,5 +2313,11 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
 	its_alloc_lpi_tables();
 	its_lpi_init(rdists->id_bits);
 
+	list_for_each_entry(its, &its_nodes, entry)
+		has_v4 |= its->is_v4;
+
+	if (has_v4 & rdists->has_vlpis)
+		its_init_vpe_domain();
+
 	return 0;
 }
-- 
2.1.4
