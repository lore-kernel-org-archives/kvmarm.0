From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [RFC PATCH 4/8] irqchip/gicv3-its: specialise readq and writeq
 accesses
Date: Fri, 21 Oct 2016 10:36:37 +0100
Message-ID: <1477042601-15227-5-git-send-email-vladimir.murzin@arm.com>
References: <1477042601-15227-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5305549B40
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2016 05:26:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L3GiYrXmkOqA for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Oct 2016 05:26:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4740749B61
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2016 05:26:43 -0400 (EDT)
In-Reply-To: <1477042601-15227-1-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kbuild-all@01.org
List-Id: kvmarm@lists.cs.columbia.edu

readq and writeq type of assessors are not supported in AArch32, so we
need to specialise them and glue later with series of 32-bit accesses
on AArch32 side.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm64/include/asm/arch_gicv3.h |   16 ++++++++++++++++
 drivers/irqchip/irq-gic-v3-its.c    |   30 +++++++++++++++---------------
 2 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/arch_gicv3.h b/arch/arm64/include/asm/arch_gicv3.h
index 4f0402a..e0ada98 100644
--- a/arch/arm64/include/asm/arch_gicv3.h
+++ b/arch/arm64/include/asm/arch_gicv3.h
@@ -190,5 +190,21 @@ static inline void gic_write_bpr1(u32 val)
 
 #define gic_flush_dcache_to_poc(a,l)	__flush_dcache_area((a), (l))
 
+#define gits_read_typer(c)		readq_relaxed(c)
+
+#define gits_read_baser(c)		readq_relaxed(c)
+#define gits_write_baser(v, c)		writeq_relaxed(v, c)
+
+#define gits_read_cbaser(c)		readq_relaxed(c)
+#define gits_write_cbaser(v, c)		writeq_relaxed(v, c)
+
+#define gits_write_cwriter(v, c)	writeq_relaxed(v, c)
+
+#define gicr_read_propbaser(c)		readq_relaxed(c)
+#define gicr_write_propbaser(v, c)	writeq_relaxed(v, c)
+
+#define gicr_write_pendbaser(v, c)	writeq_relaxed(v, c)
+#define gicr_read_pendbaser(c)		readq_relaxed(c)
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ASM_ARCH_GICV3_H */
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 86efa6e..9f74abc 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -835,7 +835,7 @@ static u64 its_read_baser(struct its_node *its, struct its_baser *baser)
 {
 	u32 idx = baser - its->tables;
 
-	return readq_relaxed(its->base + GITS_BASER + (idx << 3));
+	return gits_read_baser(its->base + GITS_BASER + (idx << 3));
 }
 
 static void its_write_baser(struct its_node *its, struct its_baser *baser,
@@ -843,7 +843,7 @@ static void its_write_baser(struct its_node *its, struct its_baser *baser,
 {
 	u32 idx = baser - its->tables;
 
-	writeq_relaxed(val, its->base + GITS_BASER + (idx << 3));
+	gits_write_baser(val, its->base + GITS_BASER + (idx << 3));
 	baser->val = its_read_baser(its, baser);
 }
 
@@ -1022,7 +1022,7 @@ static void its_free_tables(struct its_node *its)
 
 static int its_alloc_tables(struct its_node *its)
 {
-	u64 typer = readq_relaxed(its->base + GITS_TYPER);
+	u64 typer = gits_read_typer(its->base + GITS_TYPER);
 	u32 ids = GITS_TYPER_DEVBITS(typer);
 	u64 shr = GITS_BASER_InnerShareable;
 	u64 cache = GITS_BASER_WaWb;
@@ -1125,8 +1125,8 @@ static void its_cpu_init_lpis(void)
 	       GICR_PROPBASER_WaWb |
 	       ((LPI_NRBITS - 1) & GICR_PROPBASER_IDBITS_MASK));
 
-	writeq_relaxed(val, rbase + GICR_PROPBASER);
-	tmp = readq_relaxed(rbase + GICR_PROPBASER);
+	gicr_write_propbaser(val, rbase + GICR_PROPBASER);
+	tmp = gicr_read_propbaser(rbase + GICR_PROPBASER);
 
 	if ((tmp ^ val) & GICR_PROPBASER_SHAREABILITY_MASK) {
 		if (!(tmp & GICR_PROPBASER_SHAREABILITY_MASK)) {
@@ -1138,7 +1138,7 @@ static void its_cpu_init_lpis(void)
 			val &= ~(GICR_PROPBASER_SHAREABILITY_MASK |
 				 GICR_PROPBASER_CACHEABILITY_MASK);
 			val |= GICR_PROPBASER_nC;
-			writeq_relaxed(val, rbase + GICR_PROPBASER);
+			gicr_write_propbaser(val, rbase + GICR_PROPBASER);
 		}
 		pr_info_once("GIC: using cache flushing for LPI property table\n");
 		gic_rdists->flags |= RDIST_FLAGS_PROPBASE_NEEDS_FLUSHING;
@@ -1149,8 +1149,8 @@ static void its_cpu_init_lpis(void)
 	       GICR_PENDBASER_InnerShareable |
 	       GICR_PENDBASER_WaWb);
 
-	writeq_relaxed(val, rbase + GICR_PENDBASER);
-	tmp = readq_relaxed(rbase + GICR_PENDBASER);
+	gicr_write_pendbaser(val, rbase + GICR_PENDBASER);
+	tmp = gicr_read_pendbaser(rbase + GICR_PENDBASER);
 
 	if (!(tmp & GICR_PENDBASER_SHAREABILITY_MASK)) {
 		/*
@@ -1160,7 +1160,7 @@ static void its_cpu_init_lpis(void)
 		val &= ~(GICR_PENDBASER_SHAREABILITY_MASK |
 			 GICR_PENDBASER_CACHEABILITY_MASK);
 		val |= GICR_PENDBASER_nC;
-		writeq_relaxed(val, rbase + GICR_PENDBASER);
+		gicr_write_pendbaser(val, rbase + GICR_PENDBASER);
 	}
 
 	/* Enable LPIs */
@@ -1197,7 +1197,7 @@ static void its_cpu_init_collection(void)
 		 * We now have to bind each collection to its target
 		 * redistributor.
 		 */
-		if (readq_relaxed(its->base + GITS_TYPER) & GITS_TYPER_PTA) {
+		if (gits_read_typer(its->base + GITS_TYPER) & GITS_TYPER_PTA) {
 			/*
 			 * This ITS wants the physical address of the
 			 * redistributor.
@@ -1207,7 +1207,7 @@ static void its_cpu_init_collection(void)
 			/*
 			 * This ITS wants a linear CPU number.
 			 */
-			target = readq_relaxed(gic_data_rdist_rd_base() + GICR_TYPER);
+			target = gic_read_typer(gic_data_rdist_rd_base() + GICR_TYPER);
 			target = GICR_TYPER_CPU_NUMBER(target) << 16;
 		}
 
@@ -1716,8 +1716,8 @@ static int __init its_probe_one(struct resource *res,
 		 (ITS_CMD_QUEUE_SZ / SZ_4K - 1)	|
 		 GITS_CBASER_VALID);
 
-	writeq_relaxed(baser, its->base + GITS_CBASER);
-	tmp = readq_relaxed(its->base + GITS_CBASER);
+	gits_write_cbaser(baser, its->base + GITS_CBASER);
+	tmp = gits_read_cbaser(its->base + GITS_CBASER);
 
 	if ((tmp ^ baser) & GITS_CBASER_SHAREABILITY_MASK) {
 		if (!(tmp & GITS_CBASER_SHAREABILITY_MASK)) {
@@ -1729,13 +1729,13 @@ static int __init its_probe_one(struct resource *res,
 			baser &= ~(GITS_CBASER_SHAREABILITY_MASK |
 				   GITS_CBASER_CACHEABILITY_MASK);
 			baser |= GITS_CBASER_nC;
-			writeq_relaxed(baser, its->base + GITS_CBASER);
+			gits_write_cbaser(baser, its->base + GITS_CBASER);
 		}
 		pr_info("ITS: using cache flushing for cmd queue\n");
 		its->flags |= ITS_FLAGS_CMDQ_NEEDS_FLUSHING;
 	}
 
-	writeq_relaxed(0, its->base + GITS_CWRITER);
+	gits_write_cwriter(0, its->base + GITS_CWRITER);
 	writel_relaxed(GITS_CTLR_ENABLE, its->base + GITS_CTLR);
 
 	err = its_init_domain(handle, its);
-- 
1.7.9.5
