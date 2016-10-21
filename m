From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [RFC PATCH 3/8] irqchip/gicv3-its: specialise flush_dcache operation
Date: Fri, 21 Oct 2016 10:36:36 +0100
Message-ID: <1477042601-15227-4-git-send-email-vladimir.murzin@arm.com>
References: <1477042601-15227-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2446149B40
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2016 05:26:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UYYCyN31yGZP for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Oct 2016 05:26:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A03B49B3D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2016 05:26:42 -0400 (EDT)
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

It'd be better to switch to CMA... but before that done redirect
flush_dcache operation, so 32-bit implementation could be wired
latter.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm64/include/asm/arch_gicv3.h |    3 +++
 drivers/irqchip/irq-gic-v3-its.c    |   17 ++++++++---------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/arch_gicv3.h b/arch/arm64/include/asm/arch_gicv3.h
index f8ae6d6..4f0402a 100644
--- a/arch/arm64/include/asm/arch_gicv3.h
+++ b/arch/arm64/include/asm/arch_gicv3.h
@@ -79,6 +79,7 @@
 
 #include <linux/stringify.h>
 #include <asm/barrier.h>
+#include <asm/cacheflush.h>
 
 #define read_gicreg(r)							\
 	({								\
@@ -187,5 +188,7 @@ static inline void gic_write_bpr1(u32 val)
 #define gic_read_typer(c)		readq_relaxed(c)
 #define gic_write_irouter(v, c)		writeq_relaxed(v, c)
 
+#define gic_flush_dcache_to_poc(a,l)	__flush_dcache_area((a), (l))
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ASM_ARCH_GICV3_H */
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index e992b01..86efa6e 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -37,7 +37,6 @@
 #include <linux/irqchip.h>
 #include <linux/irqchip/arm-gic-v3.h>
 
-#include <asm/cacheflush.h>
 #include <asm/cputype.h>
 #include <asm/exception.h>
 
@@ -433,7 +432,7 @@ static void its_flush_cmd(struct its_node *its, struct its_cmd_block *cmd)
 	 * the ITS.
 	 */
 	if (its->flags & ITS_FLAGS_CMDQ_NEEDS_FLUSHING)
-		__flush_dcache_area(cmd, sizeof(*cmd));
+		gic_flush_dcache_to_poc(cmd, sizeof(*cmd));
 	else
 		dsb(ishst);
 }
@@ -602,7 +601,7 @@ static void lpi_set_config(struct irq_data *d, bool enable)
 	 * Humpf...
 	 */
 	if (gic_rdists->flags & RDIST_FLAGS_PROPBASE_NEEDS_FLUSHING)
-		__flush_dcache_area(cfg, sizeof(*cfg));
+		gic_flush_dcache_to_poc(cfg, sizeof(*cfg));
 	else
 		dsb(ishst);
 	its_send_inv(its_dev, id);
@@ -817,7 +816,7 @@ static int __init its_alloc_lpi_tables(void)
 	       LPI_PROPBASE_SZ);
 
 	/* Make sure the GIC will observe the written configuration */
-	__flush_dcache_area(page_address(gic_rdists->prop_page), LPI_PROPBASE_SZ);
+	gic_flush_dcache_to_poc(page_address(gic_rdists->prop_page), LPI_PROPBASE_SZ);
 
 	return 0;
 }
@@ -910,7 +909,7 @@ static int its_setup_baser(struct its_node *its, struct its_baser *baser,
 		shr = tmp & GITS_BASER_SHAREABILITY_MASK;
 		if (!shr) {
 			cache = GITS_BASER_nC;
-			__flush_dcache_area(base, PAGE_ORDER_TO_SIZE(order));
+			gic_flush_dcache_to_poc(base, PAGE_ORDER_TO_SIZE(order));
 		}
 		goto retry_baser;
 	}
@@ -1102,7 +1101,7 @@ static void its_cpu_init_lpis(void)
 		}
 
 		/* Make sure the GIC will observe the zero-ed page */
-		__flush_dcache_area(page_address(pend_page), LPI_PENDBASE_SZ);
+		gic_flush_dcache_to_poc(page_address(pend_page), LPI_PENDBASE_SZ);
 
 		paddr = page_to_phys(pend_page);
 		pr_info("CPU%d: using LPI pending table @%pa\n",
@@ -1287,13 +1286,13 @@ static bool its_alloc_device_table(struct its_node *its, u32 dev_id)
 
 		/* Flush Lvl2 table to PoC if hw doesn't support coherency */
 		if (!(baser->val & GITS_BASER_SHAREABILITY_MASK))
-			__flush_dcache_area(page_address(page), baser->psz);
+			gic_flush_dcache_to_poc(page_address(page), baser->psz);
 
 		table[idx] = cpu_to_le64(page_to_phys(page) | GITS_BASER_VALID);
 
 		/* Flush Lvl1 entry to PoC if hw doesn't support coherency */
 		if (!(baser->val & GITS_BASER_SHAREABILITY_MASK))
-			__flush_dcache_area(table + idx, GITS_LVL1_ENTRY_SIZE);
+			gic_flush_dcache_to_poc(table + idx, GITS_LVL1_ENTRY_SIZE);
 
 		/* Ensure updated table contents are visible to ITS hardware */
 		dsb(sy);
@@ -1340,7 +1339,7 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 		return NULL;
 	}
 
-	__flush_dcache_area(itt, sz);
+	gic_flush_dcache_to_poc(itt, sz);
 
 	dev->its = its;
 	dev->itt = itt;
-- 
1.7.9.5
