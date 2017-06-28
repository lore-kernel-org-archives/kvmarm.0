From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 02/52] irqchip/gic-v3: Add redistributor iterator
Date: Wed, 28 Jun 2017 16:03:21 +0100
Message-ID: <20170628150411.15846-3-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F24D940D6B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:04:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id usqTB0WVCRJD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:04:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9A9F40187
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:04:31 -0400 (EDT)
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

In order to discover the VLPI properties, we need to iterate over
the redistributor regions. As we already have code that does this,
let's factor it out and make it slightly more generic.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3.c | 69 ++++++++++++++++++++++++++++++--------------
 1 file changed, 47 insertions(+), 22 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index c132f29322cc..bc58a4339a97 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -421,24 +421,14 @@ static void __init gic_dist_init(void)
 		gic_write_irouter(affinity, base + GICD_IROUTER + i * 8);
 }
 
-static int gic_populate_rdist(void)
+static int gic_iterate_rdists(int (*fn)(struct redist_region *, void __iomem *))
 {
-	unsigned long mpidr = cpu_logical_map(smp_processor_id());
-	u64 typer;
-	u32 aff;
+	int ret = -ENODEV;
 	int i;
 
-	/*
-	 * Convert affinity to a 32bit value that can be matched to
-	 * GICR_TYPER bits [63:32].
-	 */
-	aff = (MPIDR_AFFINITY_LEVEL(mpidr, 3) << 24 |
-	       MPIDR_AFFINITY_LEVEL(mpidr, 2) << 16 |
-	       MPIDR_AFFINITY_LEVEL(mpidr, 1) << 8 |
-	       MPIDR_AFFINITY_LEVEL(mpidr, 0));
-
 	for (i = 0; i < gic_data.nr_redist_regions; i++) {
 		void __iomem *ptr = gic_data.redist_regions[i].redist_base;
+		u64 typer;
 		u32 reg;
 
 		reg = readl_relaxed(ptr + GICR_PIDR2) & GIC_PIDR2_ARCH_MASK;
@@ -450,15 +440,9 @@ static int gic_populate_rdist(void)
 
 		do {
 			typer = gic_read_typer(ptr + GICR_TYPER);
-			if ((typer >> 32) == aff) {
-				u64 offset = ptr - gic_data.redist_regions[i].redist_base;
-				gic_data_rdist_rd_base() = ptr;
-				gic_data_rdist()->phys_base = gic_data.redist_regions[i].phys_base + offset;
-				pr_info("CPU%d: found redistributor %lx region %d:%pa\n",
-					smp_processor_id(), mpidr, i,
-					&gic_data_rdist()->phys_base);
+			ret = fn(gic_data.redist_regions + i, ptr);
+			if (!ret)
 				return 0;
-			}
 
 			if (gic_data.redist_regions[i].single_redist)
 				break;
@@ -473,9 +457,50 @@ static int gic_populate_rdist(void)
 		} while (!(typer & GICR_TYPER_LAST));
 	}
 
+	return ret ? -ENODEV : 0;
+}
+
+static int __gic_populate_rdist(struct redist_region *region, void __iomem *ptr)
+{
+	unsigned long mpidr = cpu_logical_map(smp_processor_id());
+	u64 typer;
+	u32 aff;
+
+	/*
+	 * Convert affinity to a 32bit value that can be matched to
+	 * GICR_TYPER bits [63:32].
+	 */
+	aff = (MPIDR_AFFINITY_LEVEL(mpidr, 3) << 24 |
+	       MPIDR_AFFINITY_LEVEL(mpidr, 2) << 16 |
+	       MPIDR_AFFINITY_LEVEL(mpidr, 1) << 8 |
+	       MPIDR_AFFINITY_LEVEL(mpidr, 0));
+
+	typer = gic_read_typer(ptr + GICR_TYPER);
+	if ((typer >> 32) == aff) {
+		u64 offset = ptr - region->redist_base;
+		gic_data_rdist_rd_base() = ptr;
+		gic_data_rdist()->phys_base = region->phys_base + offset;
+
+		pr_info("CPU%d: found redistributor %lx region %d:%pa\n",
+			smp_processor_id(), mpidr,
+			(int)(region - gic_data.redist_regions),
+			&gic_data_rdist()->phys_base);
+		return 0;
+	}
+
+	/* Try next one */
+	return 1;
+}
+
+static int gic_populate_rdist(void)
+{
+	if (gic_iterate_rdists(__gic_populate_rdist) == 0)
+		return 0;
+
 	/* We couldn't even deal with ourselves... */
 	WARN(true, "CPU%d: mpidr %lx has no re-distributor!\n",
-	     smp_processor_id(), mpidr);
+	     smp_processor_id(),
+	     (unsigned long)cpu_logical_map(smp_processor_id()));
 	return -ENODEV;
 }
 
-- 
2.11.0
