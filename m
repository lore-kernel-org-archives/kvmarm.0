From: Andre Przywara <andre.przywara@arm.com>
Subject: [RFC PATCH] kvm-unit-tests: arm/arm64: strip GIC headers
Date: Tue,  8 Nov 2016 09:48:02 +0000
Message-ID: <20161108094802.15638-1-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

this is an illustrative patch which shows what can be removed from
the kvm-unit-tests GIC headers. If this patch finds mercy, it should be
squashed into the in-flight GIC patches, eventually.
The rationale for this patch is that while it seems like a good idea to
copy the header files with the GIC definitions from Linux, we should
avoid the danger of copying bugs on the way. This is especially true
for those definitions that are used by the very emulation code that we
are about to test. Beside this the headers contain much more definitions
than we actually need.
So strip those header files, by first removing all definitions that are
actually only useful for hypervisors. Also we remove definitions for
registers that are not needed yet. The idea is to add them one by one as
soon as we start to test functionality, so that review can be much easier
and safer.
Applies on top of Drew's v3 GIC series (as in his github branch).

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 lib/arm/asm/arch_gicv3.h   |  62 -------------
 lib/arm/asm/gic-v2.h       |  22 -----
 lib/arm/asm/gic-v3.h       | 227 ---------------------------------------------
 lib/arm64/asm/arch_gicv3.h |  43 ---------
 4 files changed, 354 deletions(-)

diff --git a/lib/arm/asm/arch_gicv3.h b/lib/arm/asm/arch_gicv3.h
index d529a7e..333bf49 100644
--- a/lib/arm/asm/arch_gicv3.h
+++ b/lib/arm/asm/arch_gicv3.h
@@ -16,7 +16,6 @@
 
 #define __stringify xstr
 
-
 #define __ACCESS_CP15(CRn, Op1, CRm, Op2)	p15, Op1, %0, CRn, CRm, Op2
 #define __ACCESS_CP15_64(Op1, CRm)		p15, Op1, %Q0, %R0, CRm
 
@@ -31,67 +30,6 @@
 
 #define ICC_HSRE			__ACCESS_CP15(c12, 4, c9, 5)
 
-#define ICH_VSEIR			__ACCESS_CP15(c12, 4, c9, 4)
-#define ICH_HCR				__ACCESS_CP15(c12, 4, c11, 0)
-#define ICH_VTR				__ACCESS_CP15(c12, 4, c11, 1)
-#define ICH_MISR			__ACCESS_CP15(c12, 4, c11, 2)
-#define ICH_EISR			__ACCESS_CP15(c12, 4, c11, 3)
-#define ICH_ELSR			__ACCESS_CP15(c12, 4, c11, 5)
-#define ICH_VMCR			__ACCESS_CP15(c12, 4, c11, 7)
-
-#define __LR0(x)			__ACCESS_CP15(c12, 4, c12, x)
-#define __LR8(x)			__ACCESS_CP15(c12, 4, c13, x)
-
-#define ICH_LR0				__LR0(0)
-#define ICH_LR1				__LR0(1)
-#define ICH_LR2				__LR0(2)
-#define ICH_LR3				__LR0(3)
-#define ICH_LR4				__LR0(4)
-#define ICH_LR5				__LR0(5)
-#define ICH_LR6				__LR0(6)
-#define ICH_LR7				__LR0(7)
-#define ICH_LR8				__LR8(0)
-#define ICH_LR9				__LR8(1)
-#define ICH_LR10			__LR8(2)
-#define ICH_LR11			__LR8(3)
-#define ICH_LR12			__LR8(4)
-#define ICH_LR13			__LR8(5)
-#define ICH_LR14			__LR8(6)
-#define ICH_LR15			__LR8(7)
-
-/* LR top half */
-#define __LRC0(x)			__ACCESS_CP15(c12, 4, c14, x)
-#define __LRC8(x)			__ACCESS_CP15(c12, 4, c15, x)
-
-#define ICH_LRC0			__LRC0(0)
-#define ICH_LRC1			__LRC0(1)
-#define ICH_LRC2			__LRC0(2)
-#define ICH_LRC3			__LRC0(3)
-#define ICH_LRC4			__LRC0(4)
-#define ICH_LRC5			__LRC0(5)
-#define ICH_LRC6			__LRC0(6)
-#define ICH_LRC7			__LRC0(7)
-#define ICH_LRC8			__LRC8(0)
-#define ICH_LRC9			__LRC8(1)
-#define ICH_LRC10			__LRC8(2)
-#define ICH_LRC11			__LRC8(3)
-#define ICH_LRC12			__LRC8(4)
-#define ICH_LRC13			__LRC8(5)
-#define ICH_LRC14			__LRC8(6)
-#define ICH_LRC15			__LRC8(7)
-
-#define __AP0Rx(x)			__ACCESS_CP15(c12, 4, c8, x)
-#define ICH_AP0R0			__AP0Rx(0)
-#define ICH_AP0R1			__AP0Rx(1)
-#define ICH_AP0R2			__AP0Rx(2)
-#define ICH_AP0R3			__AP0Rx(3)
-
-#define __AP1Rx(x)			__ACCESS_CP15(c12, 4, c9, x)
-#define ICH_AP1R0			__AP1Rx(0)
-#define ICH_AP1R1			__AP1Rx(1)
-#define ICH_AP1R2			__AP1Rx(2)
-#define ICH_AP1R3			__AP1Rx(3)
-
 /* Low-level accessors */
 
 static inline void gicv3_write_eoir(u32 irq)
diff --git a/lib/arm/asm/gic-v2.h b/lib/arm/asm/gic-v2.h
index 973c2bf..019d553 100644
--- a/lib/arm/asm/gic-v2.h
+++ b/lib/arm/asm/gic-v2.h
@@ -10,44 +10,22 @@
 
 #define GIC_CPU_CTRL			0x00
 #define GIC_CPU_PRIMASK			0x04
-#define GIC_CPU_BINPOINT		0x08
 #define GIC_CPU_INTACK			0x0c
 #define GIC_CPU_EOI			0x10
-#define GIC_CPU_RUNNINGPRI		0x14
-#define GIC_CPU_HIGHPRI			0x18
-#define GIC_CPU_ALIAS_BINPOINT		0x1c
-#define GIC_CPU_ACTIVEPRIO		0xd0
-#define GIC_CPU_IDENT			0xfc
-#define GIC_CPU_DEACTIVATE		0x1000
 
 #define GICC_ENABLE			0x1
 #define GICC_INT_PRI_THRESHOLD		0xf0
 
-#define GIC_CPU_CTRL_EOImodeNS		(1 << 9)
-
-#define GICC_IAR_INT_ID_MASK		0x3ff
 #define GICC_INT_SPURIOUS		1023
-#define GICC_DIS_BYPASS_MASK		0x1e0
 
 #define GIC_DIST_CTRL			0x000
-#define GIC_DIST_CTR			0x004
-#define GIC_DIST_IGROUP			0x080
 #define GIC_DIST_ENABLE_SET		0x100
 #define GIC_DIST_ENABLE_CLEAR		0x180
-#define GIC_DIST_PENDING_SET		0x200
-#define GIC_DIST_PENDING_CLEAR		0x280
-#define GIC_DIST_ACTIVE_SET		0x300
 #define GIC_DIST_ACTIVE_CLEAR		0x380
 #define GIC_DIST_PRI			0x400
-#define GIC_DIST_TARGET			0x800
-#define GIC_DIST_CONFIG			0xc00
 #define GIC_DIST_SOFTINT		0xf00
-#define GIC_DIST_SGI_PENDING_CLEAR	0xf10
-#define GIC_DIST_SGI_PENDING_SET	0xf20
 
 #define GICD_ENABLE			0x1
-#define GICD_DISABLE			0x0
-#define GICD_INT_ACTLOW_LVLTRIG		0x0
 #define GICD_INT_EN_CLR_X32		0xffffffff
 #define GICD_INT_EN_SET_SGI		0x0000ffff
 #define GICD_INT_EN_CLR_PPI		0xffff0000
diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index 8831389..29336fd 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -8,249 +8,22 @@
 #ifndef _ASMARM_GIC_V3_H_
 #define _ASMARM_GIC_V3_H_
 
-/*
- * Distributor registers. We assume we're running non-secure, with ARE
- * being set. Secure-only and non-ARE registers are not described.
- */
 #define GICD_CTLR			0x0000
 #define GICD_TYPER			0x0004
-#define GICD_IIDR			0x0008
-#define GICD_STATUSR			0x0010
-#define GICD_SETSPI_NSR			0x0040
-#define GICD_CLRSPI_NSR			0x0048
-#define GICD_SETSPI_SR			0x0050
-#define GICD_CLRSPI_SR			0x0058
-#define GICD_SEIR			0x0068
 #define GICD_IGROUPR			0x0080
-#define GICD_ISENABLER			0x0100
-#define GICD_ICENABLER			0x0180
-#define GICD_ISPENDR			0x0200
-#define GICD_ICPENDR			0x0280
-#define GICD_ISACTIVER			0x0300
-#define GICD_ICACTIVER			0x0380
-#define GICD_IPRIORITYR			0x0400
-#define GICD_ICFGR			0x0C00
-#define GICD_IGRPMODR			0x0D00
-#define GICD_NSACR			0x0E00
-#define GICD_IROUTER			0x6000
-#define GICD_IDREGS			0xFFD0
-#define GICD_PIDR2			0xFFE8
-
-/*
- * Those registers are actually from GICv2, but the spec demands that they
- * are implemented as RES0 if ARE is 1 (which we do in KVM's emulated GICv3).
- */
-#define GICD_ITARGETSR			0x0800
-#define GICD_SGIR			0x0F00
-#define GICD_CPENDSGIR			0x0F10
-#define GICD_SPENDSGIR			0x0F20
 
 #define GICD_CTLR_RWP			(1U << 31)
-#define GICD_CTLR_DS			(1U << 6)
 #define GICD_CTLR_ARE_NS		(1U << 4)
 #define GICD_CTLR_ENABLE_G1A		(1U << 1)
 #define GICD_CTLR_ENABLE_G1		(1U << 0)
-
-/*
- * In systems with a single security state (what we emulate in KVM)
- * the meaning of the interrupt group enable bits is slightly different
- */
-#define GICD_CTLR_ENABLE_SS_G1		(1U << 1)
-#define GICD_CTLR_ENABLE_SS_G0		(1U << 0)
-
-#define GICD_TYPER_LPIS			(1U << 17)
-#define GICD_TYPER_MBIS			(1U << 16)
-
-#define GICD_TYPER_ID_BITS(typer)	((((typer) >> 19) & 0x1f) + 1)
 #define GICD_TYPER_IRQS(typer)		((((typer) & 0x1f) + 1) * 32)
-#define GICD_TYPER_LPIS			(1U << 17)
 
-#define GICD_IROUTER_SPI_MODE_ONE	(0U << 31)
-#define GICD_IROUTER_SPI_MODE_ANY	(1U << 31)
-
-#define GIC_PIDR2_ARCH_MASK		0xf0
-#define GIC_PIDR2_ARCH_GICv3		0x30
-#define GIC_PIDR2_ARCH_GICv4		0x40
-
-#define GIC_V3_DIST_SIZE		0x10000
-
-/*
- * Re-Distributor registers, offsets from RD_base
- */
-#define GICR_CTLR			GICD_CTLR
-#define GICR_IIDR			0x0004
 #define GICR_TYPER			0x0008
-#define GICR_STATUSR			GICD_STATUSR
-#define GICR_WAKER			0x0014
-#define GICR_SETLPIR			0x0040
-#define GICR_CLRLPIR			0x0048
-#define GICR_SEIR			GICD_SEIR
-#define GICR_PROPBASER			0x0070
-#define GICR_PENDBASER			0x0078
-#define GICR_INVLPIR			0x00A0
-#define GICR_INVALLR			0x00B0
-#define GICR_SYNCR			0x00C0
-#define GICR_MOVLPIR			0x0100
-#define GICR_MOVALLR			0x0110
-#define GICR_ISACTIVER			GICD_ISACTIVER
-#define GICR_ICACTIVER			GICD_ICACTIVER
-#define GICR_IDREGS			GICD_IDREGS
-#define GICR_PIDR2			GICD_PIDR2
-
-#define GICR_CTLR_ENABLE_LPIS		(1UL << 0)
-
-#define GICR_TYPER_CPU_NUMBER(r)	(((r) >> 8) & 0xffff)
-
-#define GICR_WAKER_ProcessorSleep	(1U << 1)
-#define GICR_WAKER_ChildrenAsleep	(1U << 2)
-
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
-
-/*
- * Re-Distributor registers, offsets from SGI_base
- */
 #define GICR_IGROUPR0			GICD_IGROUPR
-#define GICR_ISENABLER0			GICD_ISENABLER
-#define GICR_ICENABLER0			GICD_ICENABLER
-#define GICR_ISPENDR0			GICD_ISPENDR
-#define GICR_ICPENDR0			GICD_ICPENDR
-#define GICR_ISACTIVER0			GICD_ISACTIVER
-#define GICR_ICACTIVER0			GICD_ICACTIVER
-#define GICR_IPRIORITYR0		GICD_IPRIORITYR
-#define GICR_ICFGR0			GICD_ICFGR
-#define GICR_IGRPMODR0			GICD_IGRPMODR
-#define GICR_NSACR			GICD_NSACR
 
-#define GICR_TYPER_PLPIS		(1U << 0)
-#define GICR_TYPER_VLPIS		(1U << 1)
 #define GICR_TYPER_LAST			(1U << 4)
 
-#define GIC_V3_REDIST_SIZE		0x20000
-
-#define LPI_PROP_GROUP1			(1 << 1)
-#define LPI_PROP_ENABLED		(1 << 0)
-
-/*
- * ITS registers, offsets from ITS_base
- */
-#define GITS_CTLR			0x0000
-#define GITS_IIDR			0x0004
-#define GITS_TYPER			0x0008
-#define GITS_CBASER			0x0080
-#define GITS_CWRITER			0x0088
-#define GITS_CREADR			0x0090
-#define GITS_BASER			0x0100
-#define GITS_PIDR2			GICR_PIDR2
-
-#define GITS_TRANSLATER			0x10040
-
-#define GITS_CTLR_ENABLE		(1U << 0)
-#define GITS_CTLR_QUIESCENT		(1U << 31)
-
-#define GITS_TYPER_DEVBITS_SHIFT	13
-#define GITS_TYPER_DEVBITS(r)		((((r) >> GITS_TYPER_DEVBITS_SHIFT) & 0x1f) + 1)
-#define GITS_TYPER_PTA			(1UL << 19)
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
-
-#define GITS_BASER_NR_REGS		8
-
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
-#define GITS_BASER_TYPE(r)		(((r) >> GITS_BASER_TYPE_SHIFT) & 7)
-#define GITS_BASER_ENTRY_SIZE_SHIFT	(48)
-#define GITS_BASER_ENTRY_SIZE(r)	((((r) >> GITS_BASER_ENTRY_SIZE_SHIFT) & 0xff) + 1)
-#define GITS_BASER_NonShareable		(0UL << 10)
-#define GITS_BASER_InnerShareable	(1UL << 10)
-#define GITS_BASER_OuterShareable	(2UL << 10)
-#define GITS_BASER_SHAREABILITY_SHIFT	(10)
-#define GITS_BASER_SHAREABILITY_MASK	(3UL << GITS_BASER_SHAREABILITY_SHIFT)
-#define GITS_BASER_PAGE_SIZE_SHIFT	(8)
-#define GITS_BASER_PAGE_SIZE_4K		(0UL << GITS_BASER_PAGE_SIZE_SHIFT)
-#define GITS_BASER_PAGE_SIZE_16K	(1UL << GITS_BASER_PAGE_SIZE_SHIFT)
-#define GITS_BASER_PAGE_SIZE_64K	(2UL << GITS_BASER_PAGE_SIZE_SHIFT)
-#define GITS_BASER_PAGE_SIZE_MASK	(3UL << GITS_BASER_PAGE_SIZE_SHIFT)
-#define GITS_BASER_PAGES_MAX		256
-
-#define GITS_BASER_TYPE_NONE		0
-#define GITS_BASER_TYPE_DEVICE		1
-#define GITS_BASER_TYPE_VCPU		2
-#define GITS_BASER_TYPE_CPU		3
-#define GITS_BASER_TYPE_COLLECTION	4
-#define GITS_BASER_TYPE_RESERVED5	5
-#define GITS_BASER_TYPE_RESERVED6	6
-#define GITS_BASER_TYPE_RESERVED7	7
-
-/*
- * ITS commands
- */
-#define GITS_CMD_MAPD			0x08
-#define GITS_CMD_MAPC			0x09
-#define GITS_CMD_MAPVI			0x0a
-#define GITS_CMD_MOVI			0x01
-#define GITS_CMD_DISCARD		0x0f
-#define GITS_CMD_INV			0x0c
-#define GITS_CMD_MOVALL			0x0e
-#define GITS_CMD_INVALL			0x0d
-#define GITS_CMD_INT			0x03
-#define GITS_CMD_CLEAR			0x04
-#define GITS_CMD_SYNC			0x05
-
-/*
- * CPU interface registers
- */
 #define ICC_CTLR_EL1_EOImode_drop_dir	(0U << 1)
-#define ICC_CTLR_EL1_EOImode_drop	(1U << 1)
-#define ICC_SRE_EL1_SRE			(1U << 0)
 
 #include <asm/arch_gicv3.h>
 
diff --git a/lib/arm64/asm/arch_gicv3.h b/lib/arm64/asm/arch_gicv3.h
index eff2efd..90e2353 100644
--- a/lib/arm64/asm/arch_gicv3.h
+++ b/lib/arm64/asm/arch_gicv3.h
@@ -21,49 +21,6 @@
 
 #define ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
 
-/*
- * System register definitions
- */
-#define ICH_VSEIR_EL2			sys_reg(3, 4, 12, 9, 4)
-#define ICH_HCR_EL2			sys_reg(3, 4, 12, 11, 0)
-#define ICH_VTR_EL2			sys_reg(3, 4, 12, 11, 1)
-#define ICH_MISR_EL2			sys_reg(3, 4, 12, 11, 2)
-#define ICH_EISR_EL2			sys_reg(3, 4, 12, 11, 3)
-#define ICH_ELSR_EL2			sys_reg(3, 4, 12, 11, 5)
-#define ICH_VMCR_EL2			sys_reg(3, 4, 12, 11, 7)
-
-#define __LR0_EL2(x)			sys_reg(3, 4, 12, 12, x)
-#define __LR8_EL2(x)			sys_reg(3, 4, 12, 13, x)
-
-#define ICH_LR0_EL2			__LR0_EL2(0)
-#define ICH_LR1_EL2			__LR0_EL2(1)
-#define ICH_LR2_EL2			__LR0_EL2(2)
-#define ICH_LR3_EL2			__LR0_EL2(3)
-#define ICH_LR4_EL2			__LR0_EL2(4)
-#define ICH_LR5_EL2			__LR0_EL2(5)
-#define ICH_LR6_EL2			__LR0_EL2(6)
-#define ICH_LR7_EL2			__LR0_EL2(7)
-#define ICH_LR8_EL2			__LR8_EL2(0)
-#define ICH_LR9_EL2			__LR8_EL2(1)
-#define ICH_LR10_EL2			__LR8_EL2(2)
-#define ICH_LR11_EL2			__LR8_EL2(3)
-#define ICH_LR12_EL2			__LR8_EL2(4)
-#define ICH_LR13_EL2			__LR8_EL2(5)
-#define ICH_LR14_EL2			__LR8_EL2(6)
-#define ICH_LR15_EL2			__LR8_EL2(7)
-
-#define __AP0Rx_EL2(x)			sys_reg(3, 4, 12, 8, x)
-#define ICH_AP0R0_EL2			__AP0Rx_EL2(0)
-#define ICH_AP0R1_EL2			__AP0Rx_EL2(1)
-#define ICH_AP0R2_EL2			__AP0Rx_EL2(2)
-#define ICH_AP0R3_EL2			__AP0Rx_EL2(3)
-
-#define __AP1Rx_EL2(x)			sys_reg(3, 4, 12, 9, x)
-#define ICH_AP1R0_EL2			__AP1Rx_EL2(0)
-#define ICH_AP1R1_EL2			__AP1Rx_EL2(1)
-#define ICH_AP1R2_EL2			__AP1Rx_EL2(2)
-#define ICH_AP1R3_EL2			__AP1Rx_EL2(3)
-
 #ifndef __ASSEMBLY__
 
 #include <libcflat.h>
-- 
2.9.0

