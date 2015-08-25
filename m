From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 2/4] irqchip: GICv3: Don't deactivate interrupts forwarded to a guest
Date: Tue, 25 Aug 2015 12:53:23 +0100
Message-ID: <1440503605-10185-3-git-send-email-marc.zyngier@arm.com>
References: <1440503605-10185-1-git-send-email-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440503605-10185-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: Eric Auger <eric.auger@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Jiang Liu <jiang.liu@linux.intel.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Commit 0a4377de3056 ("genirq: Introduce irq_set_vcpu_affinity() to
target an interrupt to a VCPU") added just what we needed at the
lowest level to allow an interrupt to be deactivated by a guest.

When such a request reaches the GIC, it knows it doesn't need to
perform the deactivation anymore, and can safely leave the guest
do its magic. This of course requires additional support in both
VFIO and KVM.

Reviewed-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index addd2ee..5aa9bf6 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -70,6 +70,11 @@ static inline int gic_irq_in_rdist(struct irq_data *d)
 	return gic_irq(d) < 32;
 }
 
+static inline bool forwarded_irq(struct irq_data *d)
+{
+	return d->handler_data != NULL;
+}
+
 static inline void __iomem *gic_dist_base(struct irq_data *d)
 {
 	if (gic_irq_in_rdist(d))	/* SGI+PPI -> SGI_base for this CPU */
@@ -231,6 +236,18 @@ static void gic_poke_irq(struct irq_data *d, u32 offset)
 static void gic_mask_irq(struct irq_data *d)
 {
 	gic_poke_irq(d, GICD_ICENABLER);
+	/*
+	 * When masking a forwarded interrupt, make sure it is
+	 * deactivated as well.
+	 *
+	 * This ensures that an interrupt that is getting
+	 * disabled/masked will not get "stuck", because there is
+	 * noone to deactivate it (guest is being terminated).
+	 */
+	if (static_key_true(&supports_deactivate)) {
+		if (forwarded_irq(d))
+			gic_poke_irq(d, GICD_ICACTIVER);
+	}
 }
 
 static void gic_unmask_irq(struct irq_data *d)
@@ -296,8 +313,11 @@ static int gic_irq_get_irqchip_state(struct irq_data *d,
 static void gic_eoi_irq(struct irq_data *d)
 {
 	if (static_key_true(&supports_deactivate)) {
-		/* No need to deactivate an LPI */
-		if (gic_irq(d) >= 8192)
+		/*
+		 * No need to deactivate an LPI, or an interrupt that
+		 * is is getting forwarded to a vcpu.
+		 */
+		if (gic_irq(d) >= 8192 || forwarded_irq(d))
 			return;
 		gic_write_dir(gic_irq(d));
 	} else {
@@ -331,6 +351,16 @@ static int gic_set_type(struct irq_data *d, unsigned int type)
 	return gic_configure_irq(irq, type, base, rwp_wait);
 }
 
+static int gic_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu)
+{
+	if (static_key_true(&supports_deactivate)) {
+		d->handler_data = vcpu;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 static u64 gic_mpidr_to_affinity(u64 mpidr)
 {
 	u64 aff;
@@ -683,6 +713,7 @@ static struct irq_chip gic_chip = {
 	.irq_set_affinity	= gic_set_affinity,
 	.irq_get_irqchip_state	= gic_irq_get_irqchip_state,
 	.irq_set_irqchip_state	= gic_irq_set_irqchip_state,
+	.irq_set_vcpu_affinity	= gic_irq_set_vcpu_affinity,
 	.flags			= IRQCHIP_SET_TYPE_MASKED,
 };
 
-- 
2.1.4
