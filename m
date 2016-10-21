From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [RFC PATCH 5/8] ARM: gic-v3-its: Add 32bit support to GICv3 ITS
Date: Fri, 21 Oct 2016 10:36:38 +0100
Message-ID: <1477042601-15227-6-git-send-email-vladimir.murzin@arm.com>
References: <1477042601-15227-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4627149B5D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2016 05:26:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eowqPAWs2teo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Oct 2016 05:26:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90B1049B5B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2016 05:26:44 -0400 (EDT)
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

Wire-up flush_dcache, readq- and writeq-like gic-v3-its assessors, so
GICv3 ITS gets all it needs to be built and run.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm/include/asm/arch_gicv3.h |   59 ++++++++++++++++++++++++++++++++-----
 1 file changed, 52 insertions(+), 7 deletions(-)

diff --git a/arch/arm/include/asm/arch_gicv3.h b/arch/arm/include/asm/arch_gicv3.h
index a808829..35a1e35 100644
--- a/arch/arm/include/asm/arch_gicv3.h
+++ b/arch/arm/include/asm/arch_gicv3.h
@@ -22,6 +22,7 @@
 
 #include <linux/io.h>
 #include <asm/barrier.h>
+#include <asm/cacheflush.h>
 #include <asm/cp15.h>
 
 #define ICC_EOIR1			__ACCESS_CP15(c12, 0, c12, 1)
@@ -230,19 +231,14 @@ static inline void gic_write_bpr1(u32 val)
  * AArch32, since the syndrome register doesn't provide any information for
  * them.
  * Consequently, the following IO helpers use 32bit accesses.
- *
- * There are only two registers that need 64bit accesses in this driver:
- * - GICD_IROUTERn, contain the affinity values associated to each interrupt.
- *   The upper-word (aff3) will always be 0, so there is no need for a lock.
- * - GICR_TYPER is an ID register and doesn't need atomicity.
  */
-static inline void gic_write_irouter(u64 val, volatile void __iomem *addr)
+static inline void __gic_writeq_nonatomic(u64 val, volatile void __iomem *addr)
 {
 	writel_relaxed((u32)val, addr);
 	writel_relaxed((u32)(val >> 32), addr + 4);
 }
 
-static inline u64 gic_read_typer(const volatile void __iomem *addr)
+static inline u64 __gic_readq_nonatomic(const volatile void __iomem *addr)
 {
 	u64 val;
 
@@ -251,5 +247,54 @@ static inline u64 gic_read_typer(const volatile void __iomem *addr)
 	return val;
 }
 
+#define gic_flush_dcache_to_poc(a,l)    __cpuc_flush_dcache_area((a), (l))
+
+/*
+ *  GICD_IROUTERn, contain the affinity values associated to each interrupt.
+ *  The upper-word (aff3) will always be 0, so there is no need for a lock.
+ */
+#define gic_write_irouter(v, c)		__gic_writeq_nonatomic(v, c)
+
+/*
+ * GICR_TYPER is an ID register and doesn't need atomicity.
+ */
+#define gic_read_typer(c)		__gic_readq_nonatomic(c)
+
+/*
+ * GITS_BASER - hi and lo bits may be accessed independently.
+ */
+#define gits_read_baser(c)		__gic_readq_nonatomic(c)
+#define gits_write_baser(v, c)		__gic_writeq_nonatomic(v, c)
+
+/*
+ * GITS_TYPER is an ID register and doesn't need atomicity.
+ */
+#define gits_read_typer(c)		__gic_readq_nonatomic(c)
+
+/*
+ * GICR_PENDBASER and GICR_PROPBASE are changed with LPIs disabled, so they
+ * won't be being used during any updates and can be changed non-atomically
+ */
+#define gicr_read_propbaser(c)		__gic_readq_nonatomic(c)
+#define gicr_write_propbaser(v, c)	__gic_writeq_nonatomic(v, c)
+#define gicr_read_pendbaser(c)		__gic_readq_nonatomic(c)
+#define gicr_write_pendbaser(v, c)	__gic_writeq_nonatomic(v, c)
+
+/*
+ * GITS_TYPER is an ID register and doesn't need atomicity.
+ */
+#define gits_read_typer(c)		__gic_readq_nonatomic(c)
+
+/*
+ * GITS_CBASER - hi and lo bits may be accessed independently.
+ */
+#define gits_read_cbaser(c)		__gic_readq_nonatomic(c)
+#define gits_write_cbaser(v, c)		__gic_writeq_nonatomic(v, c)
+
+/*
+ * GITS_CWRITER - hi and lo bits may be accessed independently.
+ */
+#define gits_write_cwriter(v, c)	__gic_writeq_nonatomic(v, c)
+
 #endif /* !__ASSEMBLY__ */
 #endif /* !__ASM_ARCH_GICV3_H */
-- 
1.7.9.5
