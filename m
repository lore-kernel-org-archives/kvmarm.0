From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 3/4] irqchip: GIC: Convert to EOImode == 1
Date: Tue, 25 Aug 2015 12:53:24 +0100
Message-ID: <1440503605-10185-4-git-send-email-marc.zyngier@arm.com>
References: <1440503605-10185-1-git-send-email-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440503605-10185-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Jiang Liu <jiang.liu@linux.intel.com>, Eric Auger <eric.auger@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

So far, GICv2 has been used with EOImode == 0. The effect of this
mode is to perform the priority drop and the deactivation of the
interrupt at the same time.

While this works perfectly for Linux (we only have a single priority),
it causes issues when an interrupt is forwarded to a guest, and when
we want the guest to perform the EOI itself.

For this case, the GIC architecture provides EOImode == 1, where:
- A write to the EOI register drops the priority of the interrupt
  and leaves it active. Other interrupts at the same priority level
  can now be taken, but the active interrupt cannot be taken again
- A write to the DIR marks the interrupt as inactive, meaning it can
  now be taken again.

We only enable this feature when booted in HYP mode and that
the device-tree reported a suitable CPU interface. Observable behaviour
should remain unchanged.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic.c       | 51 +++++++++++++++++++++++++++++++++++++++--
 include/linux/irqchip/arm-gic.h |  4 ++++
 2 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 4dd8826..505aaf3 100644
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
@@ -137,6 +140,14 @@ static inline unsigned int gic_irq(struct irq_data *d)
 	return d->hwirq;
 }
 
+static inline bool primary_gic_irq(struct irq_data *d)
+{
+	if (MAX_GIC_NR > 1)
+		return irq_data_get_irq_chip_data(d) == &gic_data[0];
+
+	return true;
+}
+
 /*
  * Routines to acknowledge, disable and enable interrupts
  */
@@ -164,7 +175,14 @@ static void gic_unmask_irq(struct irq_data *d)
 
 static void gic_eoi_irq(struct irq_data *d)
 {
-	writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_EOI);
+	u32 deact_offset = GIC_CPU_EOI;
+
+	if (static_key_true(&supports_deactivate)) {
+		if (primary_gic_irq(d))
+			deact_offset = GIC_CPU_DEACTIVATE;
+	}
+
+	writel_relaxed(gic_irq(d), gic_cpu_base(d) + deact_offset);
 }
 
 static int gic_irq_set_irqchip_state(struct irq_data *d,
@@ -272,11 +290,15 @@ static void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
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
@@ -359,6 +381,10 @@ static void gic_cpu_if_up(void)
 {
 	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
 	u32 bypass = 0;
+	u32 mode = 0;
+
+	if (static_key_true(&supports_deactivate))
+		mode = GIC_CPU_CTRL_EOImodeNS;
 
 	/*
 	* Preserve bypass disable bits to be written back later
@@ -366,7 +392,7 @@ static void gic_cpu_if_up(void)
 	bypass = readl(cpu_base + GIC_CPU_CTRL);
 	bypass &= GICC_DIS_BYPASS_MASK;
 
-	writel_relaxed(bypass | GICC_ENABLE, cpu_base + GIC_CPU_CTRL);
+	writel_relaxed(bypass | mode | GICC_ENABLE, cpu_base + GIC_CPU_CTRL);
 }
 
 
@@ -986,6 +1012,8 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 		register_cpu_notifier(&gic_cpu_notifier);
 #endif
 		set_handle_irq(gic_handle_irq);
+		if (static_key_true(&supports_deactivate))
+			pr_info("GIC: Using split EOI/Deactivate mode\n");
 	}
 
 	gic_dist_init(gic);
@@ -1001,6 +1029,7 @@ gic_of_init(struct device_node *node, struct device_node *parent)
 {
 	void __iomem *cpu_base;
 	void __iomem *dist_base;
+	struct resource cpu_res;
 	u32 percpu_offset;
 	int irq;
 
@@ -1013,6 +1042,16 @@ gic_of_init(struct device_node *node, struct device_node *parent)
 	cpu_base = of_iomap(node, 1);
 	WARN(!cpu_base, "unable to map gic cpu registers\n");
 
+	of_address_to_resource(node, 1, &cpu_res);
+
+	/*
+	 * Disable split EOI/Deactivate if either HYP is not available
+	 * or the CPU interface is too small.
+	 */
+	if (gic_cnt == 0 && (!is_hyp_mode_available() ||
+			     resource_size(&cpu_res) < SZ_8K))
+		static_key_slow_dec(&supports_deactivate);
+
 	if (of_property_read_u32(node, "cpu-offset", &percpu_offset))
 		percpu_offset = 0;
 
@@ -1132,6 +1171,14 @@ gic_v2_acpi_init(struct acpi_table_header *table)
 	}
 
 	/*
+	 * Disable split EOI/Deactivate if HYP is not available. ACPI
+	 * guarantees that we'll always have a GICv2, so the CPU
+	 * interface will always be the right size.
+	 */
+	if (!is_hyp_mode_available())
+		static_key_slow_dec(&supports_deactivate);
+
+	/*
 	 * Initialize zero GIC instance (no multi-GIC support). Also, set GIC
 	 * as default IRQ domain to allow for GSI registration and GSI to IRQ
 	 * number translation (see acpi_register_gsi() and acpi_gsi_to_irq()).
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
