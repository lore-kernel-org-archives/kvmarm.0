From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 4/4] irqchip: GIC: Don't deactivate interrupts forwarded to a guest
Date: Wed, 26 Aug 2015 17:00:45 +0100
Message-ID: <1440604845-28229-5-git-send-email-marc.zyngier@arm.com>
References: <1440604845-28229-1-git-send-email-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440604845-28229-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Jiang Liu <jiang.liu@linux.intel.com>, Eric Auger <eric.auger@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Commit 0a4377de3056 ("genirq: Introduce irq_set_vcpu_affinity() to
target an interrupt to a VCPU") added just what we needed at the
lowest level to allow an interrupt to be deactivated by a guest.

When such a request reaches the GIC, it knows it doesn't need to
perform the deactivation anymore, and can safely leave the guest
do its magic. This of course requires additional support in both
VFIO and KVM.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 9215897..0f1f00c 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -140,6 +140,36 @@ static inline unsigned int gic_irq(struct irq_data *d)
 	return d->hwirq;
 }
 
+static inline bool cascading_gic_irq(struct irq_data *d)
+{
+	void *data = irq_data_get_irq_handler_data(d);
+
+	/*
+	 * If handler_data pointing to one of the secondary GICs, then
+	 * this is a cascading interrupt, and it cannot possibly be
+	 * forwarded.
+	 */
+	if (data >= (void *)(gic_data + 1) &&
+	    data <  (void *)(gic_data + MAX_GIC_NR))
+		return true;
+
+	return false;
+}
+
+static inline bool forwarded_irq(struct irq_data *d)
+{
+	/*
+	 * A forwarded interrupt:
+	 * - is on the primary GIC
+	 * - has its handler_data set to a value
+	 * - that isn't a secondary GIC
+	 */
+	if (d->handler_data && !cascading_gic_irq(d))
+		return true;
+
+	return false;
+}
+
 /*
  * Routines to acknowledge, disable and enable interrupts
  */
@@ -163,6 +193,16 @@ static void gic_mask_irq(struct irq_data *d)
 static void gic_eoimode1_mask_irq(struct irq_data *d)
 {
 	gic_mask_irq(d);
+	/*
+	 * When masking a forwarded interrupt, make sure it is
+	 * deactivated as well.
+	 *
+	 * This ensures that an interrupt that is getting
+	 * disabled/masked will not get "stuck", because there is
+	 * noone to deactivate it (guest is being terminated).
+	 */
+	if (forwarded_irq(d))
+		gic_poke_irq(d, GIC_DIST_ACTIVE_CLEAR);
 }
 
 static void gic_unmask_irq(struct irq_data *d)
@@ -177,6 +217,10 @@ static void gic_eoi_irq(struct irq_data *d)
 
 static void gic_eoimode1_eoi_irq(struct irq_data *d)
 {
+	/* Do not deactivate an IRQ forwarded to a vcpu. */
+	if (forwarded_irq(d))
+		return;
+
 	writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_DEACTIVATE);
 }
 
@@ -246,6 +290,16 @@ static int gic_set_type(struct irq_data *d, unsigned int type)
 	return gic_configure_irq(gicirq, type, base, NULL);
 }
 
+static int gic_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu)
+{
+	/* Only interrupts on the primary GIC can be forwarded to a vcpu. */
+	if (cascading_gic_irq(d))
+		return -EINVAL;
+
+	d->handler_data = vcpu;
+	return 0;
+}
+
 #ifdef CONFIG_SMP
 static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
 			    bool force)
@@ -355,6 +409,7 @@ static struct irq_chip gic_eoimode1_chip = {
 #endif
 	.irq_get_irqchip_state	= gic_irq_get_irqchip_state,
 	.irq_set_irqchip_state	= gic_irq_set_irqchip_state,
+	.irq_set_vcpu_affinity	= gic_irq_set_vcpu_affinity,
 	.flags			= IRQCHIP_SET_TYPE_MASKED,
 };
 
-- 
2.1.4
