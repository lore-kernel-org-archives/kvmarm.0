From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v7 07/17] irqchip: refactor and add GICv3 definitions
Date: Tue, 28 Jun 2016 13:32:20 +0100
Message-ID: <20160628123230.26255-8-andre.przywara@arm.com>
References: <20160628123230.26255-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE76F49B63
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 08:26:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zUa8MB0EBEaP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jun 2016 08:26:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B319849B75
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 08:26:51 -0400 (EDT)
In-Reply-To: <20160628123230.26255-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

arm-gic-v3.h contains bit and register definitions for the GICv3 and ITS,
at least for the bits the we currently care about.
The ITS emulation needs more definitions, so add them and refactor
the memory attribute #defines to be more universally usable.
To avoid changing all users, we still provide some of the old definitons
defined with the help of the new macros.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/linux/irqchip/arm-gic-v3.h | 165 +++++++++++++++++++++++--------------
 1 file changed, 105 insertions(+), 60 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index bfbd707..2699aa0 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -112,34 +112,53 @@
 #define GICR_WAKER_ProcessorSleep	(1U << 1)
 #define GICR_WAKER_ChildrenAsleep	(1U << 2)
 
-#define GICR_PROPBASER_NonShareable	(0U << 10)
-#define GICR_PROPBASER_InnerShareable	(1U << 10)
-#define GICR_PROPBASER_OuterShareable	(2U << 10)
-#define GICR_PROPBASER_SHAREABILITY_MASK (3UL << 10)
-#define GICR_PROPBASER_nCnB		(0U << 7)
-#define GICR_PROPBASER_nC		(1U << 7)
-#define GICR_PROPBASER_RaWt		(2U << 7)
-#define GICR_PROPBASER_RaWb		(3U << 7)
-#define GICR_PROPBASER_WaWt		(4U << 7)
-#define GICR_PROPBASER_WaWb		(5U << 7)
-#define GICR_PROPBASER_RaWaWt		(6U << 7)
-#define GICR_PROPBASER_RaWaWb		(7U << 7)
-#define GICR_PROPBASER_CACHEABILITY_MASK (7U << 7)
-#define GICR_PROPBASER_IDBITS_MASK	(0x1f)
-
-#define GICR_PENDBASER_NonShareable	(0U << 10)
-#define GICR_PENDBASER_InnerShareable	(1U << 10)
-#define GICR_PENDBASER_OuterShareable	(2U << 10)
-#define GICR_PENDBASER_SHAREABILITY_MASK (3UL << 10)
-#define GICR_PENDBASER_nCnB		(0U << 7)
-#define GICR_PENDBASER_nC		(1U << 7)
-#define GICR_PENDBASER_RaWt		(2U << 7)
-#define GICR_PENDBASER_RaWb		(3U << 7)
-#define GICR_PENDBASER_WaWt		(4U << 7)
-#define GICR_PENDBASER_WaWb		(5U << 7)
-#define GICR_PENDBASER_RaWaWt		(6U << 7)
-#define GICR_PENDBASER_RaWaWb		(7U << 7)
-#define GICR_PENDBASER_CACHEABILITY_MASK (7U << 7)
+#define GIC_BASER_CACHE_nCnB		0ULL
+#define GIC_BASER_CACHE_SameAsInner	0ULL
+#define GIC_BASER_CACHE_nC		1ULL
+#define GIC_BASER_CACHE_RaWt		2ULL
+#define GIC_BASER_CACHE_RaWb		3ULL
+#define GIC_BASER_CACHE_WaWt		4ULL
+#define GIC_BASER_CACHE_WaWb		5ULL
+#define GIC_BASER_CACHE_RaWaWt		6ULL
+#define GIC_BASER_CACHE_RaWaWb		7ULL
+#define GIC_BASER_CACHE_MASK		7ULL
+#define GIC_BASER_NonShareable		0ULL
+#define GIC_BASER_InnerShareable	1ULL
+#define GIC_BASER_OuterShareable	2ULL
+#define GIC_BASER_SHAREABILITY_MASK	3ULL
+
+#define GIC_BASER_CACHEABILITY(reg, inner_outer, type)			\
+	(GIC_BASER_CACHE_##type << reg##_##inner_outer##_CACHEABILITY_SHIFT)
+
+#define GIC_BASER_SHAREABILITY(reg, type)				\
+	(GIC_BASER_##type << reg##_SHAREABILITY_SHIFT)
+
+#define GICR_PROPBASER_SHAREABILITY_SHIFT		(10)
+#define GICR_PROPBASER_INNER_CACHEABILITY_SHIFT		(7)
+#define GICR_PROPBASER_OUTER_CACHEABILITY_SHIFT		(56)
+#define GICR_PROPBASER_SHAREABILITY_MASK				\
+	GIC_BASER_SHAREABILITY(GICR_PROPBASER, SHAREABILITY_MASK)
+#define GICR_PROPBASER_CACHEABILITY_MASK				\
+	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, MASK)
+
+#define GICR_PROPBASER_InnerShareable					\
+	GIC_BASER_SHAREABILITY(GICR_PROPBASER, InnerShareable)
+#define GICR_PROPBASER_nC GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, nC)
+#define GICR_PROPBASER_WaWb GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, WaWb)
+#define GICR_PROPBASER_IDBITS_MASK			(0x1f)
+
+#define GICR_PENDBASER_SHAREABILITY_SHIFT		(10)
+#define GICR_PENDBASER_INNER_CACHEABILITY_SHIFT		(7)
+#define GICR_PENDBASER_OUTER_CACHEABILITY_SHIFT		(56)
+#define GICR_PENDBASER_SHAREABILITY_MASK				\
+	GIC_BASER_SHAREABILITY(GICR_PENDBASER, SHAREABILITY_MASK)
+#define GICR_PENDBASER_CACHEABILITY_MASK				\
+	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, MASK)
+
+#define GICR_PENDBASER_InnerShareable					\
+	GIC_BASER_SHAREABILITY(GICR_PENDBASER, InnerShareable)
+#define GICR_PENDBASER_nC GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, nC)
+#define GICR_PENDBASER_WaWb GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, WaWb)
 
 /*
  * Re-Distributor registers, offsets from SGI_base
@@ -175,53 +194,62 @@
 #define GITS_CWRITER			0x0088
 #define GITS_CREADR			0x0090
 #define GITS_BASER			0x0100
+#define GITS_IDREGS_BASE		0xffd0
+#define GITS_PIDR0			0xffe0
+#define GITS_PIDR1			0xffe4
 #define GITS_PIDR2			GICR_PIDR2
+#define GITS_PIDR4			0xffd0
+#define GITS_CIDR0			0xfff0
+#define GITS_CIDR1			0xfff4
+#define GITS_CIDR2			0xfff8
+#define GITS_CIDR3			0xfffc
 
 #define GITS_TRANSLATER			0x10040
 
 #define GITS_CTLR_ENABLE		(1U << 0)
 #define GITS_CTLR_QUIESCENT		(1U << 31)
 
+#define GITS_TYPER_PLPIS		(1UL << 0)
+#define GITS_TYPER_IDBITS_SHIFT		8
 #define GITS_TYPER_DEVBITS_SHIFT	13
 #define GITS_TYPER_DEVBITS(r)		((((r) >> GITS_TYPER_DEVBITS_SHIFT) & 0x1f) + 1)
 #define GITS_TYPER_PTA			(1UL << 19)
-
-#define GITS_CBASER_VALID		(1UL << 63)
-#define GITS_CBASER_nCnB		(0UL << 59)
-#define GITS_CBASER_nC			(1UL << 59)
-#define GITS_CBASER_RaWt		(2UL << 59)
-#define GITS_CBASER_RaWb		(3UL << 59)
-#define GITS_CBASER_WaWt		(4UL << 59)
-#define GITS_CBASER_WaWb		(5UL << 59)
-#define GITS_CBASER_RaWaWt		(6UL << 59)
-#define GITS_CBASER_RaWaWb		(7UL << 59)
-#define GITS_CBASER_CACHEABILITY_MASK	(7UL << 59)
-#define GITS_CBASER_NonShareable	(0UL << 10)
-#define GITS_CBASER_InnerShareable	(1UL << 10)
-#define GITS_CBASER_OuterShareable	(2UL << 10)
-#define GITS_CBASER_SHAREABILITY_MASK	(3UL << 10)
+#define GITS_TYPER_HWCOLLCNT_SHIFT	24
+
+#define GITS_CBASER_VALID			(1UL << 63)
+#define GITS_CBASER_SHAREABILITY_SHIFT		(10)
+#define GITS_CBASER_INNER_CACHEABILITY_SHIFT	(59)
+#define GITS_CBASER_OUTER_CACHEABILITY_SHIFT	(53)
+#define GITS_CBASER_SHAREABILITY_MASK					\
+	GIC_BASER_SHAREABILITY(GITS_CBASER, SHAREABILITY_MASK)
+#define GITS_CBASER_CACHEABILITY_MASK					\
+	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, MASK)
+
+#define GITS_CBASER_InnerShareable					\
+	GIC_BASER_SHAREABILITY(GITS_CBASER, InnerShareable)
+#define GITS_CBASER_nC GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, nC)
+#define GITS_CBASER_WaWb GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, WaWb)
 
 #define GITS_BASER_NR_REGS		8
 
-#define GITS_BASER_VALID		(1UL << 63)
-#define GITS_BASER_nCnB			(0UL << 59)
-#define GITS_BASER_nC			(1UL << 59)
-#define GITS_BASER_RaWt			(2UL << 59)
-#define GITS_BASER_RaWb			(3UL << 59)
-#define GITS_BASER_WaWt			(4UL << 59)
-#define GITS_BASER_WaWb			(5UL << 59)
-#define GITS_BASER_RaWaWt		(6UL << 59)
-#define GITS_BASER_RaWaWb		(7UL << 59)
-#define GITS_BASER_CACHEABILITY_MASK	(7UL << 59)
-#define GITS_BASER_TYPE_SHIFT		(56)
+#define GITS_BASER_VALID			(1UL << 63)
+#define GITS_BASER_INDIRECT			(1ULL << 62)
+#define GITS_BASER_INNER_CACHEABILITY_SHIFT	(59)
+#define GITS_BASER_OUTER_CACHEABILITY_SHIFT	(53)
+#define GITS_BASER_INNER_CACHEABILITY_MASK				\
+	GIC_BASER_CACHEABILITY(GITS_BASER, INNER, MASK)
+#define GITS_BASER_SHAREABILITY_MASK					\
+	GIC_BASER_SHAREABILITY(GITS_BASER, SHAREABILITY_MASK)
+
+#define GITS_BASER_nC GIC_BASER_CACHEABILITY(GITS_BASER, INNER, nC)
+#define GITS_BASER_WaWb GIC_BASER_CACHEABILITY(GITS_BASER, INNER, WaWb)
+#define GITS_BASER_TYPE_SHIFT			(56)
 #define GITS_BASER_TYPE(r)		(((r) >> GITS_BASER_TYPE_SHIFT) & 7)
-#define GITS_BASER_ENTRY_SIZE_SHIFT	(48)
+#define GITS_BASER_ENTRY_SIZE_SHIFT		(48)
 #define GITS_BASER_ENTRY_SIZE(r)	((((r) >> GITS_BASER_ENTRY_SIZE_SHIFT) & 0xff) + 1)
-#define GITS_BASER_NonShareable		(0UL << 10)
-#define GITS_BASER_InnerShareable	(1UL << 10)
-#define GITS_BASER_OuterShareable	(2UL << 10)
 #define GITS_BASER_SHAREABILITY_SHIFT	(10)
-#define GITS_BASER_SHAREABILITY_MASK	(3UL << GITS_BASER_SHAREABILITY_SHIFT)
+#define GITS_BASER_InnerShareable					\
+	GIC_BASER_SHAREABILITY(GITS_BASER, InnerShareable)
 #define GITS_BASER_PAGE_SIZE_SHIFT	(8)
 #define GITS_BASER_PAGE_SIZE_4K		(0UL << GITS_BASER_PAGE_SIZE_SHIFT)
 #define GITS_BASER_PAGE_SIZE_16K	(1UL << GITS_BASER_PAGE_SIZE_SHIFT)
@@ -243,7 +271,10 @@
  */
 #define GITS_CMD_MAPD			0x08
 #define GITS_CMD_MAPC			0x09
-#define GITS_CMD_MAPVI			0x0a
+#define GITS_CMD_MAPTI			0x0a
+/* older GIC documentation used MAPVI for this command */
+#define GITS_CMD_MAPVI			GITS_CMD_MAPTI
+#define GITS_CMD_MAPI			0x0b
 #define GITS_CMD_MOVI			0x01
 #define GITS_CMD_DISCARD		0x0f
 #define GITS_CMD_INV			0x0c
@@ -254,6 +285,20 @@
 #define GITS_CMD_SYNC			0x05
 
 /*
+ * ITS error numbers
+ */
+#define E_ITS_MOVI_UNMAPPED_INTERRUPT           0x010107
+#define E_ITS_MOVI_UNMAPPED_COLLECTION          0x010109
+#define E_ITS_CLEAR_UNMAPPED_INTERRUPT          0x010507
+#define E_ITS_MAPC_PROCNUM_OOR                  0x010902
+#define E_ITS_MAPTI_UNMAPPED_DEVICE             0x010a04
+#define E_ITS_MAPTI_PHYSICALID_OOR              0x010a06
+#define E_ITS_INV_UNMAPPED_INTERRUPT            0x010c07
+#define E_ITS_INVALL_UNMAPPED_COLLECTION        0x010d09
+#define E_ITS_MOVALL_PROCNUM_OOR                0x010e01
+#define E_ITS_DISCARD_UNMAPPED_INTERRUPT        0x010f07
+
+/*
  * CPU interface registers
  */
 #define ICC_CTLR_EL1_EOImode_drop_dir	(0U << 1)
-- 
2.9.0
