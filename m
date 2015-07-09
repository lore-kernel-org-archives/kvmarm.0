From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 6/6] irqchip: GIC: Don't deactivate interrupts forwarded to a
 guest
Date: Thu,  9 Jul 2015 14:19:11 +0100
Message-ID: <1436447951-22357-7-git-send-email-marc.zyngier@arm.com>
References: <1436447951-22357-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F50C583DB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 09:07:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AVUhpgHBF+3T for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2015 09:07:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7918A583D2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 09:07:53 -0400 (EDT)
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

Commit 0a4377de3056 ("genirq: Introduce irq_set_vcpu_affinity() to
target an interrupt to a VCPU") added just what we needed at the
lowest level to allow an interrupt to be deactivated by a guest.

When such a request reaches the GIC, it knows it doesn't need to
perform the deactivation anymore, and can safely leave the guest
do its magic. This of course requires additional support in both
VFIO and KVM.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 3c7f3a4..ca4074a 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -140,6 +140,11 @@ static inline unsigned int gic_irq(struct irq_data *d)
 	return d->hwirq;
 }
 
+static inline bool forwarded_irq(struct irq_data *d)
+{
+	return d->handler_data != NULL;
+}
+
 /*
  * Routines to acknowledge, disable and enable interrupts
  */
@@ -158,6 +163,12 @@ static int gic_peek_irq(struct irq_data *d, u32 offset)
 static void gic_mask_irq(struct irq_data *d)
 {
 	gic_poke_irq(d, GIC_DIST_ENABLE_CLEAR);
+	/*
+	 * When masking a forwarded interrupt, make sure it is
+	 * deactivated as well.
+	 */
+	if (static_key_true(&supports_deactivate) && forwarded_irq(d))
+		gic_poke_irq(d, GIC_DIST_ACTIVE_CLEAR);
 }
 
 static void gic_unmask_irq(struct irq_data *d)
@@ -167,10 +178,14 @@ static void gic_unmask_irq(struct irq_data *d)
 
 static void gic_eoi_irq(struct irq_data *d)
 {
-	if (static_key_true(&supports_deactivate))
+	if (static_key_true(&supports_deactivate)) {
+		/* Do not deactivate an IRQ forwarded to a vcpu. */
+		if (forwarded_irq(d))
+			return;
 		writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_DEACTIVATE);
-	else
+	} else {
 		writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_EOI);
+	}
 }
 
 static int gic_irq_set_irqchip_state(struct irq_data *d,
@@ -239,6 +254,18 @@ static int gic_set_type(struct irq_data *d, unsigned int type)
 	return gic_configure_irq(gicirq, type, base, NULL);
 }
 
+static int gic_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu)
+{
+	/* Only interrupts on the primary GIC can be forwarded to a vcpu. */
+	if (static_key_true(&supports_deactivate) &&
+	    irq_data_get_irq_chip_data(d) == &gic_data[0]) {
+		d->handler_data = vcpu;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 #ifdef CONFIG_SMP
 static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
 			    bool force)
@@ -334,6 +361,7 @@ static struct irq_chip gic_chip = {
 #endif
 	.irq_get_irqchip_state	= gic_irq_get_irqchip_state,
 	.irq_set_irqchip_state	= gic_irq_set_irqchip_state,
+	.irq_set_vcpu_affinity	= gic_irq_set_vcpu_affinity,
 	.flags			= IRQCHIP_SET_TYPE_MASKED,
 };
 
-- 
2.1.4
