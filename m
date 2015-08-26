From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 1/4] irqchip: GICv3: Convert to EOImode == 1
Date: Wed, 26 Aug 2015 17:00:42 +0100
Message-ID: <1440604845-28229-2-git-send-email-marc.zyngier@arm.com>
References: <1440604845-28229-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1440604845-28229-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: kvm@vger.kernel.org, Eric Auger <eric.auger@linaro.org>, linux-kernel@vger.kernel.org, Jiang Liu <jiang.liu@linux.intel.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

So far, GICv3 has been used in with EOImode == 0. The effect of this
mode is to perform the priority drop and the deactivation of the
interrupt at the same time.

While this works perfectly for Linux (we only have a single priority),
it causes issues when an interrupt is forwarded to a guest, and when
we want the guest to perform the EOI itself.

For this case, the GIC architecture provides EOImode == 1, where:
- A write to ICC_EOIR1_EL1 drops the priority of the interrupt and
  leaves it active. Other interrupts at the same priority level can
  now be taken, but the active interrupt cannot be taken again
- A write to ICC_DIR_EL1 marks the interrupt as inactive, meaning
  it can now be taken again.

This patch converts the driver to be able to use this new mode,
depending on whether or not the kernel can behave as a hypervisor.
No feature change.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3.c       | 68 ++++++++++++++++++++++++++++++++++----
 include/linux/irqchip/arm-gic-v3.h |  9 +++++
 2 files changed, 71 insertions(+), 6 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index c52f7ba..e4eba7e 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -30,6 +30,7 @@
 #include <asm/cputype.h>
 #include <asm/exception.h>
 #include <asm/smp_plat.h>
+#include <asm/virt.h>
 
 #include "irq-gic-common.h"
 #include "irqchip.h"
@@ -50,6 +51,7 @@ struct gic_chip_data {
 };
 
 static struct gic_chip_data gic_data __read_mostly;
+static struct static_key supports_deactivate = STATIC_KEY_INIT_TRUE;
 
 #define gic_data_rdist()		(this_cpu_ptr(gic_data.rdists.rdist))
 #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
@@ -231,6 +233,11 @@ static void gic_mask_irq(struct irq_data *d)
 	gic_poke_irq(d, GICD_ICENABLER);
 }
 
+static void gic_eoimode1_mask_irq(struct irq_data *d)
+{
+	gic_mask_irq(d);
+}
+
 static void gic_unmask_irq(struct irq_data *d)
 {
 	gic_poke_irq(d, GICD_ISENABLER);
@@ -296,6 +303,16 @@ static void gic_eoi_irq(struct irq_data *d)
 	gic_write_eoir(gic_irq(d));
 }
 
+static void gic_eoimode1_eoi_irq(struct irq_data *d)
+{
+	/*
+	 * No need to deactivate an LPI.
+	 */
+	if (gic_irq(d) >= 8192)
+		return;
+	gic_write_dir(gic_irq(d));
+}
+
 static int gic_set_type(struct irq_data *d, unsigned int type)
 {
 	unsigned int irq = gic_irq(d);
@@ -343,15 +360,26 @@ static asmlinkage void __exception_irq_entry gic_handle_irq(struct pt_regs *regs
 
 		if (likely(irqnr > 15 && irqnr < 1020) || irqnr >= 8192) {
 			int err;
+
+			if (static_key_true(&supports_deactivate))
+				gic_write_eoir(irqnr);
+
 			err = handle_domain_irq(gic_data.domain, irqnr, regs);
 			if (err) {
 				WARN_ONCE(true, "Unexpected interrupt received!\n");
-				gic_write_eoir(irqnr);
+				if (static_key_true(&supports_deactivate)) {
+					if (irqnr < 8192)
+						gic_write_dir(irqnr);
+				} else {
+					gic_write_eoir(irqnr);
+				}
 			}
 			continue;
 		}
 		if (irqnr < 16) {
 			gic_write_eoir(irqnr);
+			if (static_key_true(&supports_deactivate))
+				gic_write_dir(irqnr);
 #ifdef CONFIG_SMP
 			handle_IPI(irqnr, regs);
 #else
@@ -451,8 +479,13 @@ static void gic_cpu_sys_reg_init(void)
 	/* Set priority mask register */
 	gic_write_pmr(DEFAULT_PMR_VALUE);
 
-	/* EOI deactivates interrupt too (mode 0) */
-	gic_write_ctlr(ICC_CTLR_EL1_EOImode_drop_dir);
+	if (static_key_true(&supports_deactivate)) {
+		/* EOI drops priority only (mode 1) */
+		gic_write_ctlr(ICC_CTLR_EL1_EOImode_drop);
+	} else {
+		/* EOI deactivates interrupt too (mode 0) */
+		gic_write_ctlr(ICC_CTLR_EL1_EOImode_drop_dir);
+	}
 
 	/* ... and let's hit the road... */
 	gic_write_grpen1(1);
@@ -661,11 +694,28 @@ static struct irq_chip gic_chip = {
 	.flags			= IRQCHIP_SET_TYPE_MASKED,
 };
 
+static struct irq_chip gic_eoimode1_chip = {
+	.name			= "GICv3",
+	.irq_mask		= gic_eoimode1_mask_irq,
+	.irq_unmask		= gic_unmask_irq,
+	.irq_eoi		= gic_eoimode1_eoi_irq,
+	.irq_set_type		= gic_set_type,
+	.irq_set_affinity	= gic_set_affinity,
+	.irq_get_irqchip_state	= gic_irq_get_irqchip_state,
+	.irq_set_irqchip_state	= gic_irq_set_irqchip_state,
+	.flags			= IRQCHIP_SET_TYPE_MASKED,
+};
+
 #define GIC_ID_NR		(1U << gic_data.rdists.id_bits)
 
 static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
 			      irq_hw_number_t hw)
 {
+	struct irq_chip *chip = &gic_chip;
+
+	if (static_key_true(&supports_deactivate))
+		chip = &gic_eoimode1_chip;
+
 	/* SGIs are private to the core kernel */
 	if (hw < 16)
 		return -EPERM;
@@ -679,13 +729,13 @@ static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
 	/* PPIs */
 	if (hw < 32) {
 		irq_set_percpu_devid(irq);
-		irq_domain_set_info(d, irq, hw, &gic_chip, d->host_data,
+		irq_domain_set_info(d, irq, hw, chip, d->host_data,
 				    handle_percpu_devid_irq, NULL, NULL);
 		set_irq_flags(irq, IRQF_VALID | IRQF_NOAUTOEN);
 	}
 	/* SPIs */
 	if (hw >= 32 && hw < gic_data.irq_nr) {
-		irq_domain_set_info(d, irq, hw, &gic_chip, d->host_data,
+		irq_domain_set_info(d, irq, hw, chip, d->host_data,
 				    handle_fasteoi_irq, NULL, NULL);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
@@ -693,7 +743,7 @@ static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
 	if (hw >= 8192 && hw < GIC_ID_NR) {
 		if (!gic_dist_supports_lpis())
 			return -EPERM;
-		irq_domain_set_info(d, irq, hw, &gic_chip, d->host_data,
+		irq_domain_set_info(d, irq, hw, chip, d->host_data,
 				    handle_fasteoi_irq, NULL, NULL);
 		set_irq_flags(irq, IRQF_VALID);
 	}
@@ -820,6 +870,12 @@ static int __init gic_of_init(struct device_node *node, struct device_node *pare
 	if (of_property_read_u64(node, "redistributor-stride", &redist_stride))
 		redist_stride = 0;
 
+	if (!is_hyp_mode_available())
+		static_key_slow_dec(&supports_deactivate);
+
+	if (static_key_true(&supports_deactivate))
+		pr_info("GIC: Using split EOI/Deactivate mode\n");
+
 	gic_data.dist_base = dist_base;
 	gic_data.redist_regions = rdist_regs;
 	gic_data.nr_redist_regions = nr_redist_regions;
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index ffbc034..bc98832 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -104,6 +104,8 @@
 #define GICR_SYNCR			0x00C0
 #define GICR_MOVLPIR			0x0100
 #define GICR_MOVALLR			0x0110
+#define GICR_ISACTIVER			GICD_ISACTIVER
+#define GICR_ICACTIVER			GICD_ICACTIVER
 #define GICR_IDREGS			GICD_IDREGS
 #define GICR_PIDR2			GICD_PIDR2
 
@@ -288,6 +290,7 @@
 #define ICH_VMCR_PMR_MASK		(0xffUL << ICH_VMCR_PMR_SHIFT)
 
 #define ICC_EOIR1_EL1			sys_reg(3, 0, 12, 12, 1)
+#define ICC_DIR_EL1			sys_reg(3, 0, 12, 11, 1)
 #define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
 #define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
 #define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
@@ -384,6 +387,12 @@ static inline void gic_write_eoir(u64 irq)
 	isb();
 }
 
+static inline void gic_write_dir(u64 irq)
+{
+	asm volatile("msr_s " __stringify(ICC_DIR_EL1) ", %0" : : "r" (irq));
+	isb();
+}
+
 struct irq_domain;
 int its_cpu_init(void);
 int its_init(struct device_node *node, struct rdists *rdists,
-- 
2.1.4
