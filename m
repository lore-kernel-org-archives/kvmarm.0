From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 18/52] irqchip/gic-v3-its: Add VLPI configuration handling
Date: Wed, 28 Jun 2017 16:03:37 +0100
Message-ID: <20170628150411.15846-19-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73A9C41050
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id psaT2hMpSogk for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:05:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45A2B49BF6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:04:59 -0400 (EDT)
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

When a VLPI is reconfigured (enabled, disabled, change in priority),
the full configuration byte must be written, and the caches invalidated.

Also, when using the irq_mask/irq_unmask methods, it is necessary
to disable the doorbell for that particular interrupt (by mapping it
to 1023) on top of clearing the Enable bit.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 73 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 69 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 527e4e95e10d..2e5e0499a0e6 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -808,18 +808,26 @@ static inline u32 its_get_event_id(struct irq_data *d)
 	return d->hwirq - its_dev->event_map.lpi_base;
 }
 
-static void lpi_update_config(struct irq_data *d, u8 clr, u8 set)
+static void lpi_write_config(struct irq_data *d, u8 clr, u8 set)
 {
 	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
-	irq_hw_number_t hwirq = d->hwirq;
+	irq_hw_number_t hwirq;
 	struct page *prop_page;
 	u8 *cfg;
 
-	prop_page = gic_rdists->prop_page;
+	if (irqd_is_forwarded_to_vcpu(d)) {
+		u32 event = its_get_event_id(d);
+
+		prop_page = its_dev->event_map.vm->vprop_page;
+		hwirq = its_dev->event_map.vlpi_maps[event].vintid;
+	} else {
+		prop_page = gic_rdists->prop_page;
+		hwirq = d->hwirq;
+	}
 
 	cfg = page_address(prop_page) + hwirq - 8192;
 	*cfg &= ~clr;
-	*cfg |= set;
+	*cfg |= set | LPI_PROP_GROUP1;
 
 	/*
 	 * Make the above write visible to the redistributors.
@@ -830,16 +838,52 @@ static void lpi_update_config(struct irq_data *d, u8 clr, u8 set)
 		gic_flush_dcache_to_poc(cfg, sizeof(*cfg));
 	else
 		dsb(ishst);
+}
+
+static void lpi_update_config(struct irq_data *d, u8 clr, u8 set)
+{
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+
+	lpi_write_config(d, clr, set);
 	its_send_inv(its_dev, its_get_event_id(d));
 }
 
+static void its_vlpi_set_doorbell(struct irq_data *d, bool enable)
+{
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	u32 event = its_get_event_id(d);
+
+	if (its_dev->event_map.vlpi_maps[event].db_enabled == enable)
+		return;
+
+	its_dev->event_map.vlpi_maps[event].db_enabled = enable;
+
+	/*
+	 * More fun with the architecture:
+	 *
+	 * Ideally, we'd issue a VMAPTI to set the doorbell to its LPI
+	 * value or to 1023, depending on the enable bit. But that
+	 * would be issueing a mapping for an /existing/ DevID+EventID
+	 * pair, which is UNPREDICTABLE. Instead, let's issue a VMOVI
+	 * to the /same/ vPE, using this opportunity to adjust the
+	 * doorbell. Mouahahahaha. We loves it, Precious.
+	 */
+	its_send_vmovi(its_dev, event);
+}
+
 static void its_mask_irq(struct irq_data *d)
 {
+	if (irqd_is_forwarded_to_vcpu(d))
+		its_vlpi_set_doorbell(d, false);
+
 	lpi_update_config(d, LPI_PROP_ENABLED, 0);
 }
 
 static void its_unmask_irq(struct irq_data *d)
 {
+	if (irqd_is_forwarded_to_vcpu(d))
+		its_vlpi_set_doorbell(d, true);
+
 	lpi_update_config(d, 0, LPI_PROP_ENABLED);
 }
 
@@ -852,6 +896,10 @@ static int its_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
 	struct its_collection *target_col;
 	u32 id = its_get_event_id(d);
 
+	/* A forwarded interrupt should use irq_set_vcpu_affinity */
+	if (irqd_is_forwarded_to_vcpu(d))
+		return -EINVAL;
+
        /* lpi cannot be routed to a redistributor that is on a foreign node */
 	if (its_dev->its->flags & ITS_FLAGS_WORKAROUND_CAVIUM_23144) {
 		if (its_dev->its->numa_node >= 0) {
@@ -1017,6 +1065,22 @@ static int its_vlpi_unmap(struct irq_data *d)
 	return ret;
 }
 
+static int its_vlpi_prop_update(struct irq_data *d, struct its_cmd_info *info)
+{
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+
+	if (!its_dev->event_map.vm || !irqd_is_forwarded_to_vcpu(d))
+		return -EINVAL;
+
+	if (info->cmd_type == PROP_UPDATE_AND_INV_VLPI)
+		lpi_update_config(d, 0xff, info->config);
+	else
+		lpi_write_config(d, 0xff, info->config);
+	its_vlpi_set_doorbell(d, !!(info->config & LPI_PROP_ENABLED));
+
+	return 0;
+}
+
 static int its_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
 {
 	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
@@ -1039,6 +1103,7 @@ static int its_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
 
 	case PROP_UPDATE_VLPI:
 	case PROP_UPDATE_AND_INV_VLPI:
+		return its_vlpi_prop_update(d, info);
 
 	default:
 		return -EINVAL;
-- 
2.11.0
