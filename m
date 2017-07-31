From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 11/59] irqchip/gic-v3-its: Rework LPI freeing
Date: Mon, 31 Jul 2017 18:25:49 +0100
Message-ID: <20170731172637.29355-12-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 825F849C2C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:25:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vNtEDVMar0at for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Jul 2017 13:25:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D5E549C19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:25:54 -0400 (EDT)
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

Rework LPI deallocation so that it can be reused by the v4 support
code.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index ebdb1603b95d..1298a9bca56a 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -875,16 +875,15 @@ static unsigned long *its_lpi_alloc_chunks(int nr_irqs, int *base, int *nr_ids)
 	return bitmap;
 }
 
-static void its_lpi_free(struct event_lpi_map *map)
+static void its_lpi_free_chunks(unsigned long *bitmap, int base, int nr_ids)
 {
-	int base = map->lpi_base;
-	int nr_ids = map->nr_lpis;
 	int lpi;
 
 	spin_lock(&lpi_lock);
 
 	for (lpi = base; lpi < (base + nr_ids); lpi += IRQS_PER_CHUNK) {
 		int chunk = its_lpi_to_chunk(lpi);
+
 		BUG_ON(chunk > lpi_chunks);
 		if (test_bit(chunk, lpi_bitmap)) {
 			clear_bit(chunk, lpi_bitmap);
@@ -895,8 +894,7 @@ static void its_lpi_free(struct event_lpi_map *map)
 
 	spin_unlock(&lpi_lock);
 
-	kfree(map->lpi_map);
-	kfree(map->col_map);
+	kfree(bitmap);
 }
 
 static struct page *its_allocate_prop_table(gfp_t gfp_flags)
@@ -1668,7 +1666,10 @@ static void its_irq_domain_free(struct irq_domain *domain, unsigned int virq,
 	/* If all interrupts have been freed, start mopping the floor */
 	if (bitmap_empty(its_dev->event_map.lpi_map,
 			 its_dev->event_map.nr_lpis)) {
-		its_lpi_free(&its_dev->event_map);
+		its_lpi_free_chunks(its_dev->event_map.lpi_map,
+				    its_dev->event_map.lpi_base,
+				    its_dev->event_map.nr_lpis);
+		kfree(its_dev->event_map.col_map);
 
 		/* Unmap device/itt */
 		its_send_mapd(its_dev, 0);
-- 
2.11.0
