From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 34/59] irqchip/gic-v4: Enable low-level GICv4 operations
Date: Mon, 31 Jul 2017 18:26:12 +0100
Message-ID: <20170731172637.29355-35-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17EB749C3E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:26:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qpj0xG98sD0b for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Jul 2017 13:26:47 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F37AB40D17
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:26:46 -0400 (EDT)
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
index e88d856cc09c..7dd05ad6bcfb 100644
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
index a5b1317d89eb..9f32cd42238f 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3109,7 +3109,8 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
 		has_v4 |= its->is_v4;
 
 	if (has_v4 & rdists->has_vlpis) {
-		if (its_init_vpe_domain()) {
+		if (its_init_vpe_domain() ||
+		    its_init_v4(parent_domain, &its_vpe_domain_ops)) {
 			rdists->has_vlpis = false;
 			pr_err("ITS: Disabling GICv4 support\n");
 		}
diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
index d10d73477d01..400d9bbb0e56 100644
--- a/drivers/irqchip/irq-gic-v4.c
+++ b/drivers/irqchip/irq-gic-v4.c
@@ -209,3 +209,16 @@ int its_prop_update_vlpi(int irq, u8 config, bool inv)
 
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
index f495d4d1f7d7..3cf72af2c796 100644
--- a/include/linux/irqchip/arm-gic-v4.h
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -98,4 +98,6 @@ int its_get_vlpi(int irq, struct its_vlpi_map *map);
 int its_unmap_vlpi(int irq);
 int its_prop_update_vlpi(int irq, u8 config, bool inv);
 
+int its_init_v4(struct irq_domain *domain, const struct irq_domain_ops *ops);
+
 #endif
-- 
2.11.0
