From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 04/52] irqchip/gic-v3-its: Move LPI definitions around
Date: Wed, 28 Jun 2017 16:03:23 +0100
Message-ID: <20170628150411.15846-5-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30C1940D6B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:04:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2r5ow3TaJSZT for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:04:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20E9640D94
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:04:35 -0400 (EDT)
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

The various LPI definitions are in the middle of the code, and
would be better placed at the beginning, given that we're going
to use some of them much earlier.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 45ea193325d2..335bd21c6f41 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -49,6 +49,21 @@
 #define RDIST_FLAGS_PROPBASE_NEEDS_FLUSHING	(1 << 0)
 
 /*
+ * We allocate 64kB for PROPBASE. That gives us at most 64K LPIs to
+ * deal with (one configuration byte per interrupt). PENDBASE has to
+ * be 64kB aligned (one bit per LPI, plus 8192 bits for SPI/PPI/SGI).
+ */
+#define LPI_PROPBASE_SZ		SZ_64K
+#define LPI_PENDBASE_SZ		(LPI_PROPBASE_SZ / 8 + SZ_1K)
+
+/*
+ * This is how many bits of ID we need, including the useless ones.
+ */
+#define LPI_NRBITS		ilog2(LPI_PROPBASE_SZ + SZ_8K)
+
+#define LPI_PROP_DEFAULT_PRIO	0xa0
+
+/*
  * Collection structure - just an ID, and a redistributor address to
  * ping. We use one per CPU as a bag of interrupts assigned to this
  * CPU.
@@ -785,20 +800,8 @@ static void its_lpi_free(struct event_lpi_map *map)
 	kfree(map->col_map);
 }
 
-/*
- * We allocate 64kB for PROPBASE. That gives us at most 64K LPIs to
- * deal with (one configuration byte per interrupt). PENDBASE has to
- * be 64kB aligned (one bit per LPI, plus 8192 bits for SPI/PPI/SGI).
- */
-#define LPI_PROPBASE_SZ		SZ_64K
-#define LPI_PENDBASE_SZ		(LPI_PROPBASE_SZ / 8 + SZ_1K)
 
-/*
- * This is how many bits of ID we need, including the useless ones.
- */
-#define LPI_NRBITS		ilog2(LPI_PROPBASE_SZ + SZ_8K)
 
-#define LPI_PROP_DEFAULT_PRIO	0xa0
 
 static int __init its_alloc_lpi_tables(void)
 {
-- 
2.11.0
