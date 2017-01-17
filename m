From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 01/33] irqchip/gic-v3: Add redistributor iterator
Date: Tue, 17 Jan 2017 10:20:22 +0000
Message-ID: <1484648454-21216-2-git-send-email-marc.zyngier@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75585400E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9HLZ1itWGDx8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jan 2017 05:19:25 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 480454018B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:25 -0500 (EST)
In-Reply-To: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
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
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

In order to discover the VLPI properties, we need to iterate over
the redistributor regions. As we already have code that does this,
let's factor it out and make it slightly more generic.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3.c | 77 ++++++++++++++++++++++++++++++++------------
 1 file changed, 56 insertions(+), 21 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index c132f29..5cadec0 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -421,24 +421,15 @@ static void __init gic_dist_init(void)
 		gic_write_irouter(affinity, base + GICD_IROUTER + i * 8);
 }
 
-static int gic_populate_rdist(void)
+static int gic_scan_rdist_properties(int (*fn)(struct redist_region *,
+					       void __iomem *))
 {
-	unsigned long mpidr = cpu_logical_map(smp_processor_id());
-	u64 typer;
-	u32 aff;
+	int ret = 0;
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
@@ -450,14 +441,14 @@ static int gic_populate_rdist(void)
 
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
+			switch (ret) {
+			case 0:
 				return 0;
+			case -1:
+				break;
+			default:
+				ret = 0;
 			}
 
 			if (gic_data.redist_regions[i].single_redist)
@@ -473,9 +464,53 @@ static int gic_populate_rdist(void)
 		} while (!(typer & GICR_TYPER_LAST));
 	}
 
+	if (ret == -1)
+		ret = -ENODEV;
+
+	return 0;
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
+	if (gic_scan_rdist_properties(__gic_populate_rdist) == 0)
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
2.1.4
