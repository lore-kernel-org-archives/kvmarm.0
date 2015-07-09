From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 2/6] irqchip: GIC: Convert to EOImode == 1
Date: Thu,  9 Jul 2015 14:19:07 +0100
Message-ID: <1436447951-22357-3-git-send-email-marc.zyngier@arm.com>
References: <1436447951-22357-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 022D7583AB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 09:07:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HWZX9voOJSzR for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2015 09:07:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E14B583AA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 09:07:45 -0400 (EDT)
In-Reply-To: <1436447951-22357-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: kvm@vger.kernel.org, Jiang Liu <jiang.liu@linux.intel.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

So far, GICv2 has been used in with EOImode == 0. The effect of this
mode is to perform the priority drop and the deactivation of the
interrupt at the same time.

While this works perfectly for Linux (we only have a single priority),
it causes issues when an interrupt is forwarded to a guest, and when
we want the guest to perform the EOI itself.

For this case, the GIC architecture provides EOImode == 1, where:
- A write to the EOI register drops the priority of the interrupt and leaves
it active. Other interrupts at the same priority level can now be taken,
but the active interrupt cannot be taken again
- A write to the DIR marks the interrupt as inactive, meaning it can
now be taken again.

We only enable this feature when booted in HYP mode and that
the device-tree reporte a suitable CPU interface. Observable behaviour
should remain unchanged.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic.c       | 32 +++++++++++++++++++++++++++++---
 include/linux/irqchip/arm-gic.h |  4 ++++
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 8d7e1c8..e264675 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -46,6 +46,7 @@
 #include <asm/irq.h>
 #include <asm/exception.h>
 #include <asm/smp_plat.h>
+#include <asm/virt.h>
 
 #include "irq-gic-common.h"
 #include "irqchip.h"
@@ -82,6 +83,8 @@ static DEFINE_RAW_SPINLOCK(irq_controller_lock);
 #define NR_GIC_CPU_IF 8
 static u8 gic_cpu_map[NR_GIC_CPU_IF] __read_mostly;
 
+static struct static_key supports_deactivate = STATIC_KEY_INIT_TRUE;
+
 #ifndef MAX_GIC_NR
 #define MAX_GIC_NR	1
 #endif
@@ -164,7 +167,10 @@ static void gic_unmask_irq(struct irq_data *d)
 
 static void gic_eoi_irq(struct irq_data *d)
 {
-	writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_EOI);
+	if (static_key_true(&supports_deactivate))
+		writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_DEACTIVATE);
+	else
+		writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_EOI);
 }
 
 static int gic_irq_set_irqchip_state(struct irq_data *d,
@@ -272,11 +278,15 @@ static void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
 		irqnr = irqstat & GICC_IAR_INT_ID_MASK;
 
 		if (likely(irqnr > 15 && irqnr < 1021)) {
+			if (static_key_true(&supports_deactivate))
+				writel_relaxed(irqstat, cpu_base + GIC_CPU_EOI);
 			handle_domain_irq(gic->domain, irqnr, regs);
 			continue;
 		}
 		if (irqnr < 16) {
 			writel_relaxed(irqstat, cpu_base + GIC_CPU_EOI);
+			if (static_key_true(&supports_deactivate))
+				writel_relaxed(irqstat, cpu_base + GIC_CPU_DEACTIVATE);
 #ifdef CONFIG_SMP
 			handle_IPI(irqnr, regs);
 #endif
@@ -358,7 +368,11 @@ static u8 gic_get_cpumask(struct gic_chip_data *gic)
 static void gic_cpu_if_up(void)
 {
 	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
-	u32 bypass = 0;
+	u32 bypass;
+	u32 mode = 0;
+
+	if (static_key_true(&supports_deactivate))
+		mode = GIC_CPU_CTRL_EOImodeNS;
 
 	/*
 	* Preserve bypass disable bits to be written back later
@@ -366,7 +380,7 @@ static void gic_cpu_if_up(void)
 	bypass = readl(cpu_base + GIC_CPU_CTRL);
 	bypass &= GICC_DIS_BYPASS_MASK;
 
-	writel_relaxed(bypass | GICC_ENABLE, cpu_base + GIC_CPU_CTRL);
+	writel_relaxed(bypass | mode | GICC_ENABLE, cpu_base + GIC_CPU_CTRL);
 }
 
 
@@ -986,6 +1000,9 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 		register_cpu_notifier(&gic_cpu_notifier);
 #endif
 		set_handle_irq(gic_handle_irq);
+		pr_info ("GIC: Using EOImode == %d\n",
+			 static_key_true(&supports_deactivate));
+
 	}
 
 	gic_dist_init(gic);
@@ -1001,6 +1018,7 @@ gic_of_init(struct device_node *node, struct device_node *parent)
 {
 	void __iomem *cpu_base;
 	void __iomem *dist_base;
+	struct resource cpu_res;
 	u32 percpu_offset;
 	int irq;
 
@@ -1013,6 +1031,11 @@ gic_of_init(struct device_node *node, struct device_node *parent)
 	cpu_base = of_iomap(node, 1);
 	WARN(!cpu_base, "unable to map gic cpu registers\n");
 
+	of_address_to_resource(node, 1, &cpu_res);
+	if (!gic_cnt &&
+	    (!is_hyp_mode_available() || resource_size(&cpu_res) < SZ_8K))
+		static_key_slow_dec(&supports_deactivate);
+
 	if (of_property_read_u32(node, "cpu-offset", &percpu_offset))
 		percpu_offset = 0;
 
@@ -1131,6 +1154,9 @@ gic_v2_acpi_init(struct acpi_table_header *table)
 		return -ENOMEM;
 	}
 
+	if (!is_hyp_mode_available())
+		static_key_slow_dec(&supports_deactivate);
+
 	/*
 	 * Initialize zero GIC instance (no multi-GIC support). Also, set GIC
 	 * as default IRQ domain to allow for GSI registration and GSI to IRQ
diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index 9de976b..b1533c0 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -20,9 +20,13 @@
 #define GIC_CPU_ALIAS_BINPOINT		0x1c
 #define GIC_CPU_ACTIVEPRIO		0xd0
 #define GIC_CPU_IDENT			0xfc
+#define GIC_CPU_DEACTIVATE		0x1000
 
 #define GICC_ENABLE			0x1
 #define GICC_INT_PRI_THRESHOLD		0xf0
+
+#define GIC_CPU_CTRL_EOImodeNS		(1 << 9)
+
 #define GICC_IAR_INT_ID_MASK		0x3ff
 #define GICC_INT_SPURIOUS		1023
 #define GICC_DIS_BYPASS_MASK		0x1e0
-- 
2.1.4
