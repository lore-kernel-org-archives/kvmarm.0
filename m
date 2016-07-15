From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v3 07/10] arm/arm64: add initial gicv3 support
Date: Fri, 15 Jul 2016 15:00:38 +0200
Message-ID: <1468587641-7300-8-git-send-email-drjones@redhat.com>
References: <1468587641-7300-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED33F49B1A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2016 08:55:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lm7r+2mTPBfZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2016 08:55:09 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7BB6A49B32
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2016 08:55:08 -0400 (EDT)
In-Reply-To: <1468587641-7300-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com, peter.maydell@linaro.org, alex.bennee@linaro.org
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andrew Jones <drjones@redhat.com>

---
v2: configure irqs as NS GRP1
---
 lib/arm/asm/arch_gicv3.h   | 184 ++++++++++++++++++++++++++
 lib/arm/asm/gic-v3.h       | 321 +++++++++++++++++++++++++++++++++++++++++++++
 lib/arm/asm/gic.h          |   1 +
 lib/arm/gic.c              |  73 +++++++++++
 lib/arm64/asm/arch_gicv3.h | 169 ++++++++++++++++++++++++
 lib/arm64/asm/gic-v3.h     |   1 +
 lib/arm64/asm/sysreg.h     |  44 +++++++
 7 files changed, 793 insertions(+)
 create mode 100644 lib/arm/asm/arch_gicv3.h
 create mode 100644 lib/arm/asm/gic-v3.h
 create mode 100644 lib/arm64/asm/arch_gicv3.h
 create mode 100644 lib/arm64/asm/gic-v3.h
 create mode 100644 lib/arm64/asm/sysreg.h

diff --git a/lib/arm/asm/arch_gicv3.h b/lib/arm/asm/arch_gicv3.h
new file mode 100644
index 0000000000000..d529a7eb62807
--- /dev/null
+++ b/lib/arm/asm/arch_gicv3.h
@@ -0,0 +1,184 @@
+/*
+ * All ripped off from arch/arm/include/asm/arch_gicv3.h
+ *
+ * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#ifndef _ASMARM_ARCH_GICV3_H_
+#define _ASMARM_ARCH_GICV3_H_
+
+#ifndef __ASSEMBLY__
+
+#include <libcflat.h>
+#include <asm/barrier.h>
+#include <asm/io.h>
+
+#define __stringify xstr
+
+
+#define __ACCESS_CP15(CRn, Op1, CRm, Op2)	p15, Op1, %0, CRn, CRm, Op2
+#define __ACCESS_CP15_64(Op1, CRm)		p15, Op1, %Q0, %R0, CRm
+
+#define ICC_EOIR1			__ACCESS_CP15(c12, 0, c12, 1)
+#define ICC_DIR				__ACCESS_CP15(c12, 0, c11, 1)
+#define ICC_IAR1			__ACCESS_CP15(c12, 0, c12, 0)
+#define ICC_SGI1R			__ACCESS_CP15_64(0, c12)
+#define ICC_PMR				__ACCESS_CP15(c4, 0, c6, 0)
+#define ICC_CTLR			__ACCESS_CP15(c12, 0, c12, 4)
+#define ICC_SRE				__ACCESS_CP15(c12, 0, c12, 5)
+#define ICC_IGRPEN1			__ACCESS_CP15(c12, 0, c12, 7)
+
+#define ICC_HSRE			__ACCESS_CP15(c12, 4, c9, 5)
+
+#define ICH_VSEIR			__ACCESS_CP15(c12, 4, c9, 4)
+#define ICH_HCR				__ACCESS_CP15(c12, 4, c11, 0)
+#define ICH_VTR				__ACCESS_CP15(c12, 4, c11, 1)
+#define ICH_MISR			__ACCESS_CP15(c12, 4, c11, 2)
+#define ICH_EISR			__ACCESS_CP15(c12, 4, c11, 3)
+#define ICH_ELSR			__ACCESS_CP15(c12, 4, c11, 5)
+#define ICH_VMCR			__ACCESS_CP15(c12, 4, c11, 7)
+
+#define __LR0(x)			__ACCESS_CP15(c12, 4, c12, x)
+#define __LR8(x)			__ACCESS_CP15(c12, 4, c13, x)
+
+#define ICH_LR0				__LR0(0)
+#define ICH_LR1				__LR0(1)
+#define ICH_LR2				__LR0(2)
+#define ICH_LR3				__LR0(3)
+#define ICH_LR4				__LR0(4)
+#define ICH_LR5				__LR0(5)
+#define ICH_LR6				__LR0(6)
+#define ICH_LR7				__LR0(7)
+#define ICH_LR8				__LR8(0)
+#define ICH_LR9				__LR8(1)
+#define ICH_LR10			__LR8(2)
+#define ICH_LR11			__LR8(3)
+#define ICH_LR12			__LR8(4)
+#define ICH_LR13			__LR8(5)
+#define ICH_LR14			__LR8(6)
+#define ICH_LR15			__LR8(7)
+
+/* LR top half */
+#define __LRC0(x)			__ACCESS_CP15(c12, 4, c14, x)
+#define __LRC8(x)			__ACCESS_CP15(c12, 4, c15, x)
+
+#define ICH_LRC0			__LRC0(0)
+#define ICH_LRC1			__LRC0(1)
+#define ICH_LRC2			__LRC0(2)
+#define ICH_LRC3			__LRC0(3)
+#define ICH_LRC4			__LRC0(4)
+#define ICH_LRC5			__LRC0(5)
+#define ICH_LRC6			__LRC0(6)
+#define ICH_LRC7			__LRC0(7)
+#define ICH_LRC8			__LRC8(0)
+#define ICH_LRC9			__LRC8(1)
+#define ICH_LRC10			__LRC8(2)
+#define ICH_LRC11			__LRC8(3)
+#define ICH_LRC12			__LRC8(4)
+#define ICH_LRC13			__LRC8(5)
+#define ICH_LRC14			__LRC8(6)
+#define ICH_LRC15			__LRC8(7)
+
+#define __AP0Rx(x)			__ACCESS_CP15(c12, 4, c8, x)
+#define ICH_AP0R0			__AP0Rx(0)
+#define ICH_AP0R1			__AP0Rx(1)
+#define ICH_AP0R2			__AP0Rx(2)
+#define ICH_AP0R3			__AP0Rx(3)
+
+#define __AP1Rx(x)			__ACCESS_CP15(c12, 4, c9, x)
+#define ICH_AP1R0			__AP1Rx(0)
+#define ICH_AP1R1			__AP1Rx(1)
+#define ICH_AP1R2			__AP1Rx(2)
+#define ICH_AP1R3			__AP1Rx(3)
+
+/* Low-level accessors */
+
+static inline void gicv3_write_eoir(u32 irq)
+{
+	asm volatile("mcr " __stringify(ICC_EOIR1) : : "r" (irq));
+	isb();
+}
+
+static inline void gicv3_write_dir(u32 val)
+{
+	asm volatile("mcr " __stringify(ICC_DIR) : : "r" (val));
+	isb();
+}
+
+static inline u32 gicv3_read_iar(void)
+{
+	u32 irqstat;
+
+	asm volatile("mrc " __stringify(ICC_IAR1) : "=r" (irqstat));
+	dsb(sy);
+	return irqstat;
+}
+
+static inline void gicv3_write_pmr(u32 val)
+{
+	asm volatile("mcr " __stringify(ICC_PMR) : : "r" (val));
+}
+
+static inline void gicv3_write_ctlr(u32 val)
+{
+	asm volatile("mcr " __stringify(ICC_CTLR) : : "r" (val));
+	isb();
+}
+
+static inline void gicv3_write_grpen1(u32 val)
+{
+	asm volatile("mcr " __stringify(ICC_IGRPEN1) : : "r" (val));
+	isb();
+}
+
+static inline void gicv3_write_sgi1r(u64 val)
+{
+	asm volatile("mcrr " __stringify(ICC_SGI1R) : : "r" (val));
+}
+
+static inline u32 gicv3_read_sre(void)
+{
+	u32 val;
+
+	asm volatile("mrc " __stringify(ICC_SRE) : "=r" (val));
+	return val;
+}
+
+static inline void gicv3_write_sre(u32 val)
+{
+	asm volatile("mcr " __stringify(ICC_SRE) : : "r" (val));
+	isb();
+}
+
+/*
+ * Even in 32bit systems that use LPAE, there is no guarantee that the I/O
+ * interface provides true 64bit atomic accesses, so using strd/ldrd doesn't
+ * make much sense.
+ * Moreover, 64bit I/O emulation is extremely difficult to implement on
+ * AArch32, since the syndrome register doesn't provide any information for
+ * them.
+ * Consequently, the following IO helpers use 32bit accesses.
+ *
+ * There are only two registers that need 64bit accesses in this driver:
+ * - GICD_IROUTERn, contain the affinity values associated to each interrupt.
+ *   The upper-word (aff3) will always be 0, so there is no need for a lock.
+ * - GICR_TYPER is an ID register and doesn't need atomicity.
+ */
+static inline void gicv3_write_irouter(u64 val, volatile void __iomem *addr)
+{
+	writel((u32)val, addr);
+	writel((u32)(val >> 32), addr + 4);
+}
+
+static inline u64 gicv3_read_typer(const volatile void __iomem *addr)
+{
+	u64 val;
+
+	val = readl(addr);
+	val |= (u64)readl(addr + 4) << 32;
+	return val;
+}
+
+#endif /* !__ASSEMBLY__ */
+#endif /* _ASMARM_ARCH_GICV3_H_ */
diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
new file mode 100644
index 0000000000000..8831389e2a00d
--- /dev/null
+++ b/lib/arm/asm/gic-v3.h
@@ -0,0 +1,321 @@
+/*
+ * All GIC* defines are lifted from include/linux/irqchip/arm-gic-v3.h
+ *
+ * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#ifndef _ASMARM_GIC_V3_H_
+#define _ASMARM_GIC_V3_H_
+
+/*
+ * Distributor registers. We assume we're running non-secure, with ARE
+ * being set. Secure-only and non-ARE registers are not described.
+ */
+#define GICD_CTLR			0x0000
+#define GICD_TYPER			0x0004
+#define GICD_IIDR			0x0008
+#define GICD_STATUSR			0x0010
+#define GICD_SETSPI_NSR			0x0040
+#define GICD_CLRSPI_NSR			0x0048
+#define GICD_SETSPI_SR			0x0050
+#define GICD_CLRSPI_SR			0x0058
+#define GICD_SEIR			0x0068
+#define GICD_IGROUPR			0x0080
+#define GICD_ISENABLER			0x0100
+#define GICD_ICENABLER			0x0180
+#define GICD_ISPENDR			0x0200
+#define GICD_ICPENDR			0x0280
+#define GICD_ISACTIVER			0x0300
+#define GICD_ICACTIVER			0x0380
+#define GICD_IPRIORITYR			0x0400
+#define GICD_ICFGR			0x0C00
+#define GICD_IGRPMODR			0x0D00
+#define GICD_NSACR			0x0E00
+#define GICD_IROUTER			0x6000
+#define GICD_IDREGS			0xFFD0
+#define GICD_PIDR2			0xFFE8
+
+/*
+ * Those registers are actually from GICv2, but the spec demands that they
+ * are implemented as RES0 if ARE is 1 (which we do in KVM's emulated GICv3).
+ */
+#define GICD_ITARGETSR			0x0800
+#define GICD_SGIR			0x0F00
+#define GICD_CPENDSGIR			0x0F10
+#define GICD_SPENDSGIR			0x0F20
+
+#define GICD_CTLR_RWP			(1U << 31)
+#define GICD_CTLR_DS			(1U << 6)
+#define GICD_CTLR_ARE_NS		(1U << 4)
+#define GICD_CTLR_ENABLE_G1A		(1U << 1)
+#define GICD_CTLR_ENABLE_G1		(1U << 0)
+
+/*
+ * In systems with a single security state (what we emulate in KVM)
+ * the meaning of the interrupt group enable bits is slightly different
+ */
+#define GICD_CTLR_ENABLE_SS_G1		(1U << 1)
+#define GICD_CTLR_ENABLE_SS_G0		(1U << 0)
+
+#define GICD_TYPER_LPIS			(1U << 17)
+#define GICD_TYPER_MBIS			(1U << 16)
+
+#define GICD_TYPER_ID_BITS(typer)	((((typer) >> 19) & 0x1f) + 1)
+#define GICD_TYPER_IRQS(typer)		((((typer) & 0x1f) + 1) * 32)
+#define GICD_TYPER_LPIS			(1U << 17)
+
+#define GICD_IROUTER_SPI_MODE_ONE	(0U << 31)
+#define GICD_IROUTER_SPI_MODE_ANY	(1U << 31)
+
+#define GIC_PIDR2_ARCH_MASK		0xf0
+#define GIC_PIDR2_ARCH_GICv3		0x30
+#define GIC_PIDR2_ARCH_GICv4		0x40
+
+#define GIC_V3_DIST_SIZE		0x10000
+
+/*
+ * Re-Distributor registers, offsets from RD_base
+ */
+#define GICR_CTLR			GICD_CTLR
+#define GICR_IIDR			0x0004
+#define GICR_TYPER			0x0008
+#define GICR_STATUSR			GICD_STATUSR
+#define GICR_WAKER			0x0014
+#define GICR_SETLPIR			0x0040
+#define GICR_CLRLPIR			0x0048
+#define GICR_SEIR			GICD_SEIR
+#define GICR_PROPBASER			0x0070
+#define GICR_PENDBASER			0x0078
+#define GICR_INVLPIR			0x00A0
+#define GICR_INVALLR			0x00B0
+#define GICR_SYNCR			0x00C0
+#define GICR_MOVLPIR			0x0100
+#define GICR_MOVALLR			0x0110
+#define GICR_ISACTIVER			GICD_ISACTIVER
+#define GICR_ICACTIVER			GICD_ICACTIVER
+#define GICR_IDREGS			GICD_IDREGS
+#define GICR_PIDR2			GICD_PIDR2
+
+#define GICR_CTLR_ENABLE_LPIS		(1UL << 0)
+
+#define GICR_TYPER_CPU_NUMBER(r)	(((r) >> 8) & 0xffff)
+
+#define GICR_WAKER_ProcessorSleep	(1U << 1)
+#define GICR_WAKER_ChildrenAsleep	(1U << 2)
+
+#define GICR_PROPBASER_NonShareable	(0U << 10)
+#define GICR_PROPBASER_InnerShareable	(1U << 10)
+#define GICR_PROPBASER_OuterShareable	(2U << 10)
+#define GICR_PROPBASER_SHAREABILITY_MASK (3UL << 10)
+#define GICR_PROPBASER_nCnB		(0U << 7)
+#define GICR_PROPBASER_nC		(1U << 7)
+#define GICR_PROPBASER_RaWt		(2U << 7)
+#define GICR_PROPBASER_RaWb		(3U << 7)
+#define GICR_PROPBASER_WaWt		(4U << 7)
+#define GICR_PROPBASER_WaWb		(5U << 7)
+#define GICR_PROPBASER_RaWaWt		(6U << 7)
+#define GICR_PROPBASER_RaWaWb		(7U << 7)
+#define GICR_PROPBASER_CACHEABILITY_MASK (7U << 7)
+#define GICR_PROPBASER_IDBITS_MASK	(0x1f)
+
+#define GICR_PENDBASER_NonShareable	(0U << 10)
+#define GICR_PENDBASER_InnerShareable	(1U << 10)
+#define GICR_PENDBASER_OuterShareable	(2U << 10)
+#define GICR_PENDBASER_SHAREABILITY_MASK (3UL << 10)
+#define GICR_PENDBASER_nCnB		(0U << 7)
+#define GICR_PENDBASER_nC		(1U << 7)
+#define GICR_PENDBASER_RaWt		(2U << 7)
+#define GICR_PENDBASER_RaWb		(3U << 7)
+#define GICR_PENDBASER_WaWt		(4U << 7)
+#define GICR_PENDBASER_WaWb		(5U << 7)
+#define GICR_PENDBASER_RaWaWt		(6U << 7)
+#define GICR_PENDBASER_RaWaWb		(7U << 7)
+#define GICR_PENDBASER_CACHEABILITY_MASK (7U << 7)
+
+/*
+ * Re-Distributor registers, offsets from SGI_base
+ */
+#define GICR_IGROUPR0			GICD_IGROUPR
+#define GICR_ISENABLER0			GICD_ISENABLER
+#define GICR_ICENABLER0			GICD_ICENABLER
+#define GICR_ISPENDR0			GICD_ISPENDR
+#define GICR_ICPENDR0			GICD_ICPENDR
+#define GICR_ISACTIVER0			GICD_ISACTIVER
+#define GICR_ICACTIVER0			GICD_ICACTIVER
+#define GICR_IPRIORITYR0		GICD_IPRIORITYR
+#define GICR_ICFGR0			GICD_ICFGR
+#define GICR_IGRPMODR0			GICD_IGRPMODR
+#define GICR_NSACR			GICD_NSACR
+
+#define GICR_TYPER_PLPIS		(1U << 0)
+#define GICR_TYPER_VLPIS		(1U << 1)
+#define GICR_TYPER_LAST			(1U << 4)
+
+#define GIC_V3_REDIST_SIZE		0x20000
+
+#define LPI_PROP_GROUP1			(1 << 1)
+#define LPI_PROP_ENABLED		(1 << 0)
+
+/*
+ * ITS registers, offsets from ITS_base
+ */
+#define GITS_CTLR			0x0000
+#define GITS_IIDR			0x0004
+#define GITS_TYPER			0x0008
+#define GITS_CBASER			0x0080
+#define GITS_CWRITER			0x0088
+#define GITS_CREADR			0x0090
+#define GITS_BASER			0x0100
+#define GITS_PIDR2			GICR_PIDR2
+
+#define GITS_TRANSLATER			0x10040
+
+#define GITS_CTLR_ENABLE		(1U << 0)
+#define GITS_CTLR_QUIESCENT		(1U << 31)
+
+#define GITS_TYPER_DEVBITS_SHIFT	13
+#define GITS_TYPER_DEVBITS(r)		((((r) >> GITS_TYPER_DEVBITS_SHIFT) & 0x1f) + 1)
+#define GITS_TYPER_PTA			(1UL << 19)
+
+#define GITS_CBASER_VALID		(1UL << 63)
+#define GITS_CBASER_nCnB		(0UL << 59)
+#define GITS_CBASER_nC			(1UL << 59)
+#define GITS_CBASER_RaWt		(2UL << 59)
+#define GITS_CBASER_RaWb		(3UL << 59)
+#define GITS_CBASER_WaWt		(4UL << 59)
+#define GITS_CBASER_WaWb		(5UL << 59)
+#define GITS_CBASER_RaWaWt		(6UL << 59)
+#define GITS_CBASER_RaWaWb		(7UL << 59)
+#define GITS_CBASER_CACHEABILITY_MASK	(7UL << 59)
+#define GITS_CBASER_NonShareable	(0UL << 10)
+#define GITS_CBASER_InnerShareable	(1UL << 10)
+#define GITS_CBASER_OuterShareable	(2UL << 10)
+#define GITS_CBASER_SHAREABILITY_MASK	(3UL << 10)
+
+#define GITS_BASER_NR_REGS		8
+
+#define GITS_BASER_VALID		(1UL << 63)
+#define GITS_BASER_nCnB			(0UL << 59)
+#define GITS_BASER_nC			(1UL << 59)
+#define GITS_BASER_RaWt			(2UL << 59)
+#define GITS_BASER_RaWb			(3UL << 59)
+#define GITS_BASER_WaWt			(4UL << 59)
+#define GITS_BASER_WaWb			(5UL << 59)
+#define GITS_BASER_RaWaWt		(6UL << 59)
+#define GITS_BASER_RaWaWb		(7UL << 59)
+#define GITS_BASER_CACHEABILITY_MASK	(7UL << 59)
+#define GITS_BASER_TYPE_SHIFT		(56)
+#define GITS_BASER_TYPE(r)		(((r) >> GITS_BASER_TYPE_SHIFT) & 7)
+#define GITS_BASER_ENTRY_SIZE_SHIFT	(48)
+#define GITS_BASER_ENTRY_SIZE(r)	((((r) >> GITS_BASER_ENTRY_SIZE_SHIFT) & 0xff) + 1)
+#define GITS_BASER_NonShareable		(0UL << 10)
+#define GITS_BASER_InnerShareable	(1UL << 10)
+#define GITS_BASER_OuterShareable	(2UL << 10)
+#define GITS_BASER_SHAREABILITY_SHIFT	(10)
+#define GITS_BASER_SHAREABILITY_MASK	(3UL << GITS_BASER_SHAREABILITY_SHIFT)
+#define GITS_BASER_PAGE_SIZE_SHIFT	(8)
+#define GITS_BASER_PAGE_SIZE_4K		(0UL << GITS_BASER_PAGE_SIZE_SHIFT)
+#define GITS_BASER_PAGE_SIZE_16K	(1UL << GITS_BASER_PAGE_SIZE_SHIFT)
+#define GITS_BASER_PAGE_SIZE_64K	(2UL << GITS_BASER_PAGE_SIZE_SHIFT)
+#define GITS_BASER_PAGE_SIZE_MASK	(3UL << GITS_BASER_PAGE_SIZE_SHIFT)
+#define GITS_BASER_PAGES_MAX		256
+
+#define GITS_BASER_TYPE_NONE		0
+#define GITS_BASER_TYPE_DEVICE		1
+#define GITS_BASER_TYPE_VCPU		2
+#define GITS_BASER_TYPE_CPU		3
+#define GITS_BASER_TYPE_COLLECTION	4
+#define GITS_BASER_TYPE_RESERVED5	5
+#define GITS_BASER_TYPE_RESERVED6	6
+#define GITS_BASER_TYPE_RESERVED7	7
+
+/*
+ * ITS commands
+ */
+#define GITS_CMD_MAPD			0x08
+#define GITS_CMD_MAPC			0x09
+#define GITS_CMD_MAPVI			0x0a
+#define GITS_CMD_MOVI			0x01
+#define GITS_CMD_DISCARD		0x0f
+#define GITS_CMD_INV			0x0c
+#define GITS_CMD_MOVALL			0x0e
+#define GITS_CMD_INVALL			0x0d
+#define GITS_CMD_INT			0x03
+#define GITS_CMD_CLEAR			0x04
+#define GITS_CMD_SYNC			0x05
+
+/*
+ * CPU interface registers
+ */
+#define ICC_CTLR_EL1_EOImode_drop_dir	(0U << 1)
+#define ICC_CTLR_EL1_EOImode_drop	(1U << 1)
+#define ICC_SRE_EL1_SRE			(1U << 0)
+
+#include <asm/arch_gicv3.h>
+
+#define SZ_64K 0x10000
+
+#ifndef __ASSEMBLY__
+#include <libcflat.h>
+#include <asm/processor.h>
+#include <asm/setup.h>
+#include <asm/smp.h>
+#include <asm/io.h>
+
+struct gicv3_data {
+	void *dist_base;
+	void *redist_base[NR_CPUS];
+	unsigned int irq_nr;
+};
+extern struct gicv3_data gicv3_data;
+
+#define gicv3_dist_base()		(gicv3_data.dist_base)
+#define gicv3_redist_base()		(gicv3_data.redist_base[smp_processor_id()])
+#define gicv3_sgi_base()		(gicv3_data.redist_base[smp_processor_id()] + SZ_64K)
+
+extern int gicv3_init(void);
+extern void gicv3_enable_defaults(void);
+
+static inline void gicv3_do_wait_for_rwp(void *base)
+{
+	int count = 100000;	/* 1s */
+
+	while (readl(base + GICD_CTLR) & GICD_CTLR_RWP) {
+		if (!--count) {
+			printf("GICv3: RWP timeout!\n");
+			abort();
+		}
+		cpu_relax();
+		udelay(10);
+	};
+}
+
+static inline void gicv3_dist_wait_for_rwp(void)
+{
+	gicv3_do_wait_for_rwp(gicv3_dist_base());
+}
+
+static inline void gicv3_redist_wait_for_rwp(void)
+{
+	gicv3_do_wait_for_rwp(gicv3_redist_base());
+}
+
+static inline u32 mpidr_compress(u64 mpidr)
+{
+	u64 compressed = mpidr & MPIDR_HWID_BITMASK;
+
+	compressed = (((compressed >> 32) & 0xff) << 24) | compressed;
+	return compressed;
+}
+
+static inline u64 mpidr_uncompress(u32 compressed)
+{
+	u64 mpidr = ((u64)compressed >> 24) << 32;
+
+	mpidr |= compressed & MPIDR_HWID_BITMASK;
+	return mpidr;
+}
+
+#endif /* !__ASSEMBLY__ */
+#endif /* _ASMARM_GIC_V3_H_ */
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index b1237d1c5ef22..849d17cb36a4e 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -7,6 +7,7 @@
 #define _ASMARM_GIC_H_
 
 #include <asm/gic-v2.h>
+#include <asm/gic-v3.h>
 
 /*
  * gic_init will try to find all known gics, and then
diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index 64a3049c9e8ce..bb62407f7286e 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -10,9 +10,11 @@
 #include <asm/io.h>
 
 struct gicv2_data gicv2_data;
+struct gicv3_data gicv3_data;
 
 /*
  * Documentation/devicetree/bindings/interrupt-controller/arm,gic.txt
+ * Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.txt
  */
 static bool
 gic_get_dt_bases(const char *compatible, void **base1, void **base2)
@@ -50,10 +52,18 @@ int gicv2_init(void)
 			&gicv2_data.dist_base, &gicv2_data.cpu_base);
 }
 
+int gicv3_init(void)
+{
+	return gic_get_dt_bases("arm,gic-v3", &gicv3_data.dist_base,
+			&gicv3_data.redist_base[0]);
+}
+
 int gic_init(void)
 {
 	if (gicv2_init())
 		return 2;
+	else if (gicv3_init())
+		return 3;
 	return 0;
 }
 
@@ -67,3 +77,66 @@ void gicv2_enable_defaults(void)
 	writel(GICC_INT_PRI_THRESHOLD, gicv2_cpu_base() + GIC_CPU_PRIMASK);
 	writel(GICC_ENABLE, gicv2_cpu_base() + GIC_CPU_CTRL);
 }
+
+void gicv3_set_redist_base(void)
+{
+	u32 aff = mpidr_compress(get_mpidr());
+	void *ptr = gicv3_data.redist_base[0];
+	u64 typer;
+
+	do {
+		typer = gicv3_read_typer(ptr + GICR_TYPER);
+		if ((typer >> 32) == aff) {
+			gicv3_redist_base() = ptr;
+			return;
+		}
+		ptr += SZ_64K * 2; /* skip RD_base and SGI_base */
+	} while (!(typer & GICR_TYPER_LAST));
+	assert(0);
+}
+
+void gicv3_enable_defaults(void)
+{
+	void *dist = gicv3_dist_base();
+	void *sgi_base;
+	unsigned int i;
+
+	if (smp_processor_id() == 0) {
+		u32 typer = readl(dist + GICD_TYPER);
+
+		gicv3_data.irq_nr = GICD_TYPER_IRQS(typer);
+		if (gicv3_data.irq_nr > 1020) {
+			printf("GICD_TYPER_IRQS reported %d! "
+			       "Clamping to max=1020.\n", 1020);
+			gicv3_data.irq_nr = 1020;
+		}
+
+		writel(0, dist + GICD_CTLR);
+		gicv3_dist_wait_for_rwp();
+
+		for (i = 32; i < gicv3_data.irq_nr; i += 32)
+			writel(~0, dist + GICD_IGROUPR + i / 8);
+
+		writel(GICD_CTLR_ARE_NS | GICD_CTLR_ENABLE_G1A | GICD_CTLR_ENABLE_G1,
+		       dist + GICD_CTLR);
+		gicv3_dist_wait_for_rwp();
+	}
+
+	if (!gicv3_redist_base())
+		gicv3_set_redist_base();
+	sgi_base = gicv3_sgi_base();
+
+	writel(~0, sgi_base + GICR_IGROUPR0);
+
+	writel(GICD_INT_EN_CLR_X32, sgi_base + GIC_DIST_ACTIVE_CLEAR);
+	writel(GICD_INT_EN_CLR_PPI, sgi_base + GIC_DIST_ENABLE_CLEAR);
+	writel(GICD_INT_EN_SET_SGI, sgi_base + GIC_DIST_ENABLE_SET);
+
+	for (i = 0; i < 32; i += 4)
+		writel(GICD_INT_DEF_PRI_X4, sgi_base + GIC_DIST_PRI + i);
+	gicv3_redist_wait_for_rwp();
+
+	gicv3_write_pmr(0xf0);
+	gicv3_write_ctlr(ICC_CTLR_EL1_EOImode_drop_dir);
+	gicv3_write_grpen1(1);
+}
diff --git a/lib/arm64/asm/arch_gicv3.h b/lib/arm64/asm/arch_gicv3.h
new file mode 100644
index 0000000000000..eff2efdfe2d4d
--- /dev/null
+++ b/lib/arm64/asm/arch_gicv3.h
@@ -0,0 +1,169 @@
+/*
+ * All ripped off from arch/arm64/include/asm/arch_gicv3.h
+ *
+ * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#ifndef _ASMARM64_ARCH_GICV3_H_
+#define _ASMARM64_ARCH_GICV3_H_
+
+#include <asm/sysreg.h>
+
+#define ICC_EOIR1_EL1			sys_reg(3, 0, 12, 12, 1)
+#define ICC_DIR_EL1			sys_reg(3, 0, 12, 11, 1)
+#define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
+#define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
+#define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
+#define ICC_CTLR_EL1			sys_reg(3, 0, 12, 12, 4)
+#define ICC_SRE_EL1			sys_reg(3, 0, 12, 12, 5)
+#define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
+
+#define ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
+
+/*
+ * System register definitions
+ */
+#define ICH_VSEIR_EL2			sys_reg(3, 4, 12, 9, 4)
+#define ICH_HCR_EL2			sys_reg(3, 4, 12, 11, 0)
+#define ICH_VTR_EL2			sys_reg(3, 4, 12, 11, 1)
+#define ICH_MISR_EL2			sys_reg(3, 4, 12, 11, 2)
+#define ICH_EISR_EL2			sys_reg(3, 4, 12, 11, 3)
+#define ICH_ELSR_EL2			sys_reg(3, 4, 12, 11, 5)
+#define ICH_VMCR_EL2			sys_reg(3, 4, 12, 11, 7)
+
+#define __LR0_EL2(x)			sys_reg(3, 4, 12, 12, x)
+#define __LR8_EL2(x)			sys_reg(3, 4, 12, 13, x)
+
+#define ICH_LR0_EL2			__LR0_EL2(0)
+#define ICH_LR1_EL2			__LR0_EL2(1)
+#define ICH_LR2_EL2			__LR0_EL2(2)
+#define ICH_LR3_EL2			__LR0_EL2(3)
+#define ICH_LR4_EL2			__LR0_EL2(4)
+#define ICH_LR5_EL2			__LR0_EL2(5)
+#define ICH_LR6_EL2			__LR0_EL2(6)
+#define ICH_LR7_EL2			__LR0_EL2(7)
+#define ICH_LR8_EL2			__LR8_EL2(0)
+#define ICH_LR9_EL2			__LR8_EL2(1)
+#define ICH_LR10_EL2			__LR8_EL2(2)
+#define ICH_LR11_EL2			__LR8_EL2(3)
+#define ICH_LR12_EL2			__LR8_EL2(4)
+#define ICH_LR13_EL2			__LR8_EL2(5)
+#define ICH_LR14_EL2			__LR8_EL2(6)
+#define ICH_LR15_EL2			__LR8_EL2(7)
+
+#define __AP0Rx_EL2(x)			sys_reg(3, 4, 12, 8, x)
+#define ICH_AP0R0_EL2			__AP0Rx_EL2(0)
+#define ICH_AP0R1_EL2			__AP0Rx_EL2(1)
+#define ICH_AP0R2_EL2			__AP0Rx_EL2(2)
+#define ICH_AP0R3_EL2			__AP0Rx_EL2(3)
+
+#define __AP1Rx_EL2(x)			sys_reg(3, 4, 12, 9, x)
+#define ICH_AP1R0_EL2			__AP1Rx_EL2(0)
+#define ICH_AP1R1_EL2			__AP1Rx_EL2(1)
+#define ICH_AP1R2_EL2			__AP1Rx_EL2(2)
+#define ICH_AP1R3_EL2			__AP1Rx_EL2(3)
+
+#ifndef __ASSEMBLY__
+
+#include <libcflat.h>
+#include <asm/barrier.h>
+
+#define __stringify xstr
+
+/*
+ * Low-level accessors
+ *
+ * These system registers are 32 bits, but we make sure that the compiler
+ * sets the GP register's most significant bits to 0 with an explicit cast.
+ */
+
+static inline void gicv3_write_eoir(u32 irq)
+{
+	asm volatile("msr_s " __stringify(ICC_EOIR1_EL1) ", %0" : : "r" ((u64)irq));
+	isb();
+}
+
+static inline void gicv3_write_dir(u32 irq)
+{
+	asm volatile("msr_s " __stringify(ICC_DIR_EL1) ", %0" : : "r" ((u64)irq));
+	isb();
+}
+
+static inline u64 gicv3_read_iar_common(void)
+{
+	u64 irqstat;
+
+	asm volatile("mrs_s %0, " __stringify(ICC_IAR1_EL1) : "=r" (irqstat));
+	dsb(sy);
+	return irqstat;
+}
+
+static inline u32 gicv3_read_iar(void)
+{
+	return (u64)gicv3_read_iar_common();
+}
+
+/*
+ * Cavium ThunderX erratum 23154
+ *
+ * The gicv3 of ThunderX requires a modified version for reading the
+ * IAR status to ensure data synchronization (access to icc_iar1_el1
+ * is not sync'ed before and after).
+ */
+static inline u64 gicv3_read_iar_cavium_thunderx(void)
+{
+	u64 irqstat;
+
+	asm volatile(
+		"nop;nop;nop;nop\n\t"
+		"nop;nop;nop;nop\n\t"
+		"mrs_s %0, " __stringify(ICC_IAR1_EL1) "\n\t"
+		"nop;nop;nop;nop"
+		: "=r" (irqstat));
+	mb();
+
+	return irqstat;
+}
+
+static inline void gicv3_write_pmr(u32 val)
+{
+	asm volatile("msr_s " __stringify(ICC_PMR_EL1) ", %0" : : "r" ((u64)val));
+}
+
+static inline void gicv3_write_ctlr(u32 val)
+{
+	asm volatile("msr_s " __stringify(ICC_CTLR_EL1) ", %0" : : "r" ((u64)val));
+	isb();
+}
+
+static inline void gicv3_write_grpen1(u32 val)
+{
+	asm volatile("msr_s " __stringify(ICC_GRPEN1_EL1) ", %0" : : "r" ((u64)val));
+	isb();
+}
+
+static inline void gicv3_write_sgi1r(u64 val)
+{
+	asm volatile("msr_s " __stringify(ICC_SGI1R_EL1) ", %0" : : "r" (val));
+}
+
+static inline u32 gicv3_read_sre(void)
+{
+	u64 val;
+
+	asm volatile("mrs_s %0, " __stringify(ICC_SRE_EL1) : "=r" (val));
+	return val;
+}
+
+static inline void gicv3_write_sre(u32 val)
+{
+	asm volatile("msr_s " __stringify(ICC_SRE_EL1) ", %0" : : "r" ((u64)val));
+	isb();
+}
+
+#define gicv3_read_typer(c)		readq(c)
+#define gicv3_write_irouter(v, c)	writeq(v, c)
+
+#endif /* __ASSEMBLY__ */
+#endif /* _ASMARM64_ARCH_GICV3_H_ */
diff --git a/lib/arm64/asm/gic-v3.h b/lib/arm64/asm/gic-v3.h
new file mode 100644
index 0000000000000..8ee5d4d9c1819
--- /dev/null
+++ b/lib/arm64/asm/gic-v3.h
@@ -0,0 +1 @@
+#include "../../arm/asm/gic-v3.h"
diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
new file mode 100644
index 0000000000000..544a46cb8cc59
--- /dev/null
+++ b/lib/arm64/asm/sysreg.h
@@ -0,0 +1,44 @@
+/*
+ * Ripped off from arch/arm64/include/asm/sysreg.h
+ *
+ * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#ifndef _ASMARM64_SYSREG_H_
+#define _ASMARM64_SYSREG_H_
+
+#define sys_reg(op0, op1, crn, crm, op2) \
+	((((op0)&3)<<19)|((op1)<<16)|((crn)<<12)|((crm)<<8)|((op2)<<5))
+
+#ifdef __ASSEMBLY__
+	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
+	.equ	.L__reg_num_x\num, \num
+	.endr
+	.equ	.L__reg_num_xzr, 31
+
+	.macro	mrs_s, rt, sreg
+	.inst	0xd5200000|(\sreg)|(.L__reg_num_\rt)
+	.endm
+
+	.macro	msr_s, sreg, rt
+	.inst	0xd5000000|(\sreg)|(.L__reg_num_\rt)
+	.endm
+#else
+asm(
+"	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30\n"
+"	.equ	.L__reg_num_x\\num, \\num\n"
+"	.endr\n"
+"	.equ	.L__reg_num_xzr, 31\n"
+"\n"
+"	.macro	mrs_s, rt, sreg\n"
+"	.inst	0xd5200000|(\\sreg)|(.L__reg_num_\\rt)\n"
+"	.endm\n"
+"\n"
+"	.macro	msr_s, sreg, rt\n"
+"	.inst	0xd5000000|(\\sreg)|(.L__reg_num_\\rt)\n"
+"	.endm\n"
+);
+#endif
+
+#endif /* _ASMARM64_SYSREG_H_ */
-- 
2.7.4
