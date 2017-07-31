From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 13/59] irqchip/gic-v3-its: Generalize LPI configuration
Date: Mon, 31 Jul 2017 18:25:51 +0100
Message-ID: <20170731172637.29355-14-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F38549C3C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:26:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I9++bdpNsM4Q for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Jul 2017 13:25:59 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E733C40D25
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:25:58 -0400 (EDT)
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

We're are going to need to change a bit more than just the enable
bit in the LPI property table in the future. So let's change the
LPI configuration funtion to take a set of bits to be cleared,
and a set of bits to be set.

This way, we'll be able to use it when a guest updates an LPI
property (priority, for example).

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 1c2d6bdf85cb..7ef448a963c1 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -678,17 +678,18 @@ static inline u32 its_get_event_id(struct irq_data *d)
 	return d->hwirq - its_dev->event_map.lpi_base;
 }
 
-static void lpi_set_config(struct irq_data *d, bool enable)
+static void lpi_update_config(struct irq_data *d, u8 clr, u8 set)
 {
 	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
 	irq_hw_number_t hwirq = d->hwirq;
-	u32 id = its_get_event_id(d);
-	u8 *cfg = page_address(gic_rdists->prop_page) + hwirq - 8192;
+	struct page *prop_page;
+	u8 *cfg;
 
-	if (enable)
-		*cfg |= LPI_PROP_ENABLED;
-	else
-		*cfg &= ~LPI_PROP_ENABLED;
+	prop_page = gic_rdists->prop_page;
+
+	cfg = page_address(prop_page) + hwirq - 8192;
+	*cfg &= ~clr;
+	*cfg |= set;
 
 	/*
 	 * Make the above write visible to the redistributors.
@@ -699,17 +700,17 @@ static void lpi_set_config(struct irq_data *d, bool enable)
 		gic_flush_dcache_to_poc(cfg, sizeof(*cfg));
 	else
 		dsb(ishst);
-	its_send_inv(its_dev, id);
+	its_send_inv(its_dev, its_get_event_id(d));
 }
 
 static void its_mask_irq(struct irq_data *d)
 {
-	lpi_set_config(d, false);
+	lpi_update_config(d, LPI_PROP_ENABLED, 0);
 }
 
 static void its_unmask_irq(struct irq_data *d)
 {
-	lpi_set_config(d, true);
+	lpi_update_config(d, 0, LPI_PROP_ENABLED);
 }
 
 static int its_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
-- 
2.11.0
