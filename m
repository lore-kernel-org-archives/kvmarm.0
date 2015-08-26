From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 2/4] irqchip: GICv3: Don't deactivate interrupts forwarded to a guest
Date: Wed, 26 Aug 2015 17:00:43 +0100
Message-ID: <1440604845-28229-3-git-send-email-marc.zyngier@arm.com>
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
 drivers/irqchip/irq-gic-v3.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index e4eba7e..51635af 100644
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
@@ -236,6 +241,16 @@ static void gic_mask_irq(struct irq_data *d)
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
+		gic_poke_irq(d, GICD_ICACTIVER);
 }
 
 static void gic_unmask_irq(struct irq_data *d)
@@ -306,9 +321,10 @@ static void gic_eoi_irq(struct irq_data *d)
 static void gic_eoimode1_eoi_irq(struct irq_data *d)
 {
 	/*
-	 * No need to deactivate an LPI.
+	 * No need to deactivate an LPI, or an interrupt that
+	 * is is getting forwarded to a vcpu.
 	 */
-	if (gic_irq(d) >= 8192)
+	if (gic_irq(d) >= 8192 || forwarded_irq(d))
 		return;
 	gic_write_dir(gic_irq(d));
 }
@@ -339,6 +355,12 @@ static int gic_set_type(struct irq_data *d, unsigned int type)
 	return gic_configure_irq(irq, type, base, rwp_wait);
 }
 
+static int gic_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu)
+{
+	d->handler_data = vcpu;
+	return 0;
+}
+
 static u64 gic_mpidr_to_affinity(u64 mpidr)
 {
 	u64 aff;
@@ -703,6 +725,7 @@ static struct irq_chip gic_eoimode1_chip = {
 	.irq_set_affinity	= gic_set_affinity,
 	.irq_get_irqchip_state	= gic_irq_get_irqchip_state,
 	.irq_set_irqchip_state	= gic_irq_set_irqchip_state,
+	.irq_set_vcpu_affinity	= gic_irq_set_vcpu_affinity,
 	.flags			= IRQCHIP_SET_TYPE_MASKED,
 };
 
-- 
2.1.4
