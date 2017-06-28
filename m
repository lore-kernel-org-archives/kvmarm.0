From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 33/52] irqchip/gic-v4: Enable low-level GICv4 operations
Date: Wed, 28 Jun 2017 16:03:52 +0100
Message-ID: <20170628150411.15846-34-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42C0F49BFC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SGdkedHbVDIG for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:05:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3F5E49BFF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:24 -0400 (EDT)
In-Reply-To: <20170628150411.15846-1-marc.zyngier@arm.com>
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
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

Get the show on the road...

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/Makefile           |  2 +-
 drivers/irqchip/irq-gic-v3-its.c   |  3 ++-
 drivers/irqchip/irq-gic-v4.c       | 13 +++++++++++++
 include/linux/irqchip/arm-gic-v4.h |  2 ++
 4 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index b64c59b838a0..4ca95310254b 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -28,7 +28,7 @@ obj-$(CONFIG_ARM_GIC_PM)		+= irq-gic-pm.o
 obj-$(CONFIG_ARCH_REALVIEW)		+= irq-gic-realview.o
 obj-$(CONFIG_ARM_GIC_V2M)		+= irq-gic-v2m.o
 obj-$(CONFIG_ARM_GIC_V3)		+= irq-gic-v3.o irq-gic-common.o
-obj-$(CONFIG_ARM_GIC_V3_ITS)		+= irq-gic-v3-its.o irq-gic-v3-its-pci-msi.o irq-gic-v3-its-platform-msi.o
+obj-$(CONFIG_ARM_GIC_V3_ITS)		+= irq-gic-v3-its.o irq-gic-v3-its-pci-msi.o irq-gic-v3-its-platform-msi.o irq-gic-v4.o
 obj-$(CONFIG_PARTITION_PERCPU)		+= irq-partition-percpu.o
 obj-$(CONFIG_HISILICON_IRQ_MBIGEN)	+= irq-mbigen.o
 obj-$(CONFIG_ARM_NVIC)			+= irq-nvic.o
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 3784bea2b994..284e6e6785cf 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2970,7 +2970,8 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
 		has_v4 |= its->is_v4;
 
 	if (has_v4 & rdists->has_vlpis) {
-		if (its_init_vpe_domain()) {
+		if (its_init_vpe_domain() ||
+		    its_init_v4(parent_domain, &its_vpe_domain_ops)) {
 			rdists->has_vlpis = false;
 			pr_err("ITS: Disabling GICv4 support\n");
 		}
diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
index 4ce5fdd1db15..7f573d65f440 100644
--- a/drivers/irqchip/irq-gic-v4.c
+++ b/drivers/irqchip/irq-gic-v4.c
@@ -194,3 +194,16 @@ int its_prop_update_vlpi(int irq, u8 config, bool inv)
 
 	return irq_set_vcpu_affinity(irq, &info);
 }
+
+int its_init_v4(struct irq_domain *domain, const struct irq_domain_ops *ops)
+{
+	if (domain) {
+		pr_info("ITS: Enabling GICv4 support\n");
+		gic_domain = domain;
+		vpe_domain_ops = ops;
+		return 0;
+	}
+
+	pr_err("ITS: No GICv4 VPE domain allocated\n");
+	return -ENODEV;
+}
diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
index 843c9ff29269..862d20ab67d0 100644
--- a/include/linux/irqchip/arm-gic-v4.h
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -97,4 +97,6 @@ int its_get_vlpi(int irq, struct its_vlpi_map *map);
 int its_unmap_vlpi(int irq);
 int its_prop_update_vlpi(int irq, u8 config, bool inv);
 
+int its_init_v4(struct irq_domain *domain, const struct irq_domain_ops *ops);
+
 #endif
-- 
2.11.0
