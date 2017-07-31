From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 04/59] irqchip/gic-v3-its: Move LPI definitions around
Date: Mon, 31 Jul 2017 18:25:42 +0100
Message-ID: <20170731172637.29355-5-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CD4449C32
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:25:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xszM7fctTu5V for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Jul 2017 13:25:39 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6850849C3E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:25:38 -0400 (EDT)
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

The various LPI definitions are in the middle of the code, and
would be better placed at the beginning, given that we're going
to use some of them much earlier.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 68932873eebc..ae6b2cee09fa 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -48,6 +48,19 @@
 
 #define RDIST_FLAGS_PROPBASE_NEEDS_FLUSHING	(1 << 0)
 
+static u32 lpi_id_bits;
+
+/*
+ * We allocate memory for PROPBASE to cover 2 ^ lpi_id_bits LPIs to
+ * deal with (one configuration byte per interrupt). PENDBASE has to
+ * be 64kB aligned (one bit per LPI, plus 8192 bits for SPI/PPI/SGI).
+ */
+#define LPI_NRBITS		lpi_id_bits
+#define LPI_PROPBASE_SZ		ALIGN(BIT(LPI_NRBITS), SZ_64K)
+#define LPI_PENDBASE_SZ		ALIGN(BIT(LPI_NRBITS) / 8, SZ_64K)
+
+#define LPI_PROP_DEFAULT_PRIO	0xa0
+
 /*
  * Collection structure - just an ID, and a redistributor address to
  * ping. We use one per CPU as a bag of interrupts assigned to this
@@ -695,7 +708,6 @@ static struct irq_chip its_irq_chip = {
 
 static unsigned long *lpi_bitmap;
 static u32 lpi_chunks;
-static u32 lpi_id_bits;
 static DEFINE_SPINLOCK(lpi_lock);
 
 static int its_lpi_to_chunk(int lpi)
@@ -790,17 +802,6 @@ static void its_lpi_free(struct event_lpi_map *map)
 	kfree(map->col_map);
 }
 
-/*
- * We allocate memory for PROPBASE to cover 2 ^ lpi_id_bits LPIs to
- * deal with (one configuration byte per interrupt). PENDBASE has to
- * be 64kB aligned (one bit per LPI, plus 8192 bits for SPI/PPI/SGI).
- */
-#define LPI_NRBITS		lpi_id_bits
-#define LPI_PROPBASE_SZ		ALIGN(BIT(LPI_NRBITS), SZ_64K)
-#define LPI_PENDBASE_SZ		ALIGN(BIT(LPI_NRBITS) / 8, SZ_64K)
-
-#define LPI_PROP_DEFAULT_PRIO	0xa0
-
 static int __init its_alloc_lpi_tables(void)
 {
 	phys_addr_t paddr;
-- 
2.11.0
