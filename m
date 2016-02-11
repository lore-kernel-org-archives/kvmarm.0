From: Julien Grall <julien.grall@arm.com>
Subject: [PATCH v2 5/6] irqchip/gic-v3: Parse and export virtual GIC
 information
Date: Thu, 11 Feb 2016 15:33:23 +0000
Message-ID: <1455204804-31830-6-git-send-email-julien.grall@arm.com>
References: <1455204804-31830-1-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B74BD49BE2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 10:27:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XqvsGH-T290k for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 10:27:47 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7176449BED
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 10:27:47 -0500 (EST)
In-Reply-To: <1455204804-31830-1-git-send-email-julien.grall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

Fill up the recently introduced gic_kvm_info with the virtual GIC
information.

Signed-off-by: Julien Grall <julien.grall@arm.com>

---
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Marc Zyngier <marc.zyngier@arm.com>

    Changes in v2:
        - Use 0 rather than a negative value to know when the maintenance IRQ
        is not present.
        - Use resource for vcpu and vctrl
---
 drivers/irqchip/irq-gic-v3.c           | 36 ++++++++++++++++++++++++++++++++++
 include/linux/irqchip/arm-gic-common.h |  1 +
 2 files changed, 37 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index d7be6dd..9992600 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 
 #include <linux/irqchip.h>
+#include <linux/irqchip/arm-gic-common.h>
 #include <linux/irqchip/arm-gic-v3.h>
 
 #include <asm/cputype.h>
@@ -53,6 +54,8 @@ struct gic_chip_data {
 static struct gic_chip_data gic_data __read_mostly;
 static struct static_key supports_deactivate = STATIC_KEY_INIT_TRUE;
 
+static struct gic_kvm_info gic_v3_kvm_info;
+
 #define gic_data_rdist()		(this_cpu_ptr(gic_data.rdists.rdist))
 #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
 #define gic_data_rdist_sgi_base()	(gic_data_rdist_rd_base() + SZ_64K)
@@ -811,6 +814,37 @@ static void gicv3_enable_quirks(void)
 #endif
 }
 
+static void __init gic_of_setup_kvm_info(struct device_node *node)
+{
+	int ret;
+	struct resource r;
+	u32 gicv_idx;
+
+	gic_v3_kvm_info.type = GIC_V3;
+
+	gic_v3_kvm_info.maint_irq = irq_of_parse_and_map(node, 0);
+
+	if (of_property_read_u32(node, "#redistributor-regions",
+				 &gicv_idx))
+		gicv_idx = 1;
+
+	gicv_idx += 3;	/* Also skip GICD, GICC, GICH */
+	ret = of_address_to_resource(node, gicv_idx, &r);
+	if (!ret) {
+		if (!PAGE_ALIGNED(r.start))
+			pr_warn("GICV physical address 0x%llx not page aligned\n",
+				(unsigned long long)r.start);
+		else if (!PAGE_ALIGNED(resource_size(&r)))
+			pr_warn("GICV size 0x%llx not a multiple of page size 0x%lx\n",
+				(unsigned long long)resource_size(&r),
+				PAGE_SIZE);
+		else
+			gic_v3_kvm_info.vcpu = r;
+	}
+
+	gic_set_kvm_info(&gic_v3_kvm_info);
+}
+
 static int __init gic_of_init(struct device_node *node, struct device_node *parent)
 {
 	void __iomem *dist_base;
@@ -908,6 +942,8 @@ static int __init gic_of_init(struct device_node *node, struct device_node *pare
 	gic_cpu_init();
 	gic_cpu_pm_init();
 
+	gic_of_setup_kvm_info(node);
+
 	return 0;
 
 out_free:
diff --git a/include/linux/irqchip/arm-gic-common.h b/include/linux/irqchip/arm-gic-common.h
index f7723b9..15d68c6 100644
--- a/include/linux/irqchip/arm-gic-common.h
+++ b/include/linux/irqchip/arm-gic-common.h
@@ -15,6 +15,7 @@
 
 enum gic_type {
 	GIC_V2,
+	GIC_V3,
 };
 
 struct gic_kvm_info {
-- 
1.9.1
