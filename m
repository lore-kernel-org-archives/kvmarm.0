From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v7 09/11] arm/arm64: add initial gicv3 support
Date: Wed, 23 Nov 2016 17:54:04 +0100
Message-ID: <20161123165406.32661-10-drjones@redhat.com>
References: <20161123165406.32661-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161123165406.32661-1-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peter.maydell@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, eric.auger@redhat.com, pbonzini@redhat.com, alex.bennee@linaro.org, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>

---
v7: split lib/arm/gic.c into gic-v2/3.c [Eric]
v6:
 - added comments [Alex]
 - added stride parameter to gicv3_set_redist_base [Andre]
 - redist-wait s/rwp/uwp/ and comment [Andre]
 - removed unnecessary wait-for-rwps [Andre]
v5: use modern register names [Andre]
v4:
 - only take defines from kernel we need now [Andre]
 - simplify enable by not caring if we reinit the distributor [drew]
v2:
 - configure irqs as NS GRP1
---
 arm/Makefile.common        |   2 +-
 lib/arm/asm/arch_gicv3.h   |  47 ++++++++++++++++++++
 lib/arm/asm/gic-v3.h       | 104 +++++++++++++++++++++++++++++++++++++++++++++
 lib/arm/asm/gic.h          |   5 ++-
 lib/arm/gic-v2.c           |  27 ++++++++++++
 lib/arm/gic-v3.c           |  61 ++++++++++++++++++++++++++
 lib/arm/gic.c              |  30 +++++--------
 lib/arm64/asm/arch_gicv3.h |  44 +++++++++++++++++++
 lib/arm64/asm/gic-v3.h     |   1 +
 lib/arm64/asm/sysreg.h     |  44 +++++++++++++++++++
 10 files changed, 343 insertions(+), 22 deletions(-)
 create mode 100644 lib/arm/asm/arch_gicv3.h
 create mode 100644 lib/arm/asm/gic-v3.h
 create mode 100644 lib/arm/gic-v2.c
 create mode 100644 lib/arm/gic-v3.c
 create mode 100644 lib/arm64/asm/arch_gicv3.h
 create mode 100644 lib/arm64/asm/gic-v3.h
 create mode 100644 lib/arm64/asm/sysreg.h

diff --git a/arm/Makefile.common b/arm/Makefile.common
index 2fe7aeeca6d4..6c0898f28be1 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -46,7 +46,7 @@ cflatobjs += lib/arm/mmu.o
 cflatobjs += lib/arm/bitops.o
 cflatobjs += lib/arm/psci.o
 cflatobjs += lib/arm/smp.o
-cflatobjs += lib/arm/gic.o
+cflatobjs += lib/arm/gic.o lib/arm/gic-v2.o lib/arm/gic-v3.o
 
 libeabi = lib/arm/libeabi.a
 eabiobjs = lib/arm/eabi_compat.o
diff --git a/lib/arm/asm/arch_gicv3.h b/lib/arm/asm/arch_gicv3.h
new file mode 100644
index 000000000000..276577452a14
--- /dev/null
+++ b/lib/arm/asm/arch_gicv3.h
@@ -0,0 +1,47 @@
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
+#include <libcflat.h>
+#include <asm/barrier.h>
+#include <asm/io.h>
+
+#define __stringify xstr
+
+#define __ACCESS_CP15(CRn, Op1, CRm, Op2)	p15, Op1, %0, CRn, CRm, Op2
+
+#define ICC_PMR				__ACCESS_CP15(c4, 0, c6, 0)
+#define ICC_IGRPEN1			__ACCESS_CP15(c12, 0, c12, 7)
+
+static inline void gicv3_write_pmr(u32 val)
+{
+	asm volatile("mcr " __stringify(ICC_PMR) : : "r" (val));
+}
+
+static inline void gicv3_write_grpen1(u32 val)
+{
+	asm volatile("mcr " __stringify(ICC_IGRPEN1) : : "r" (val));
+	isb();
+}
+
+/*
+ * We may access GICR_TYPER and GITS_TYPER by reading both the TYPER
+ * offset and the following offset (+ 4) and then combining them to
+ * form a 64-bit address.
+ */
+static inline u64 gicv3_read_typer(const volatile void __iomem *addr)
+{
+	u64 val = readl(addr);
+	val |= (u64)readl(addr + 4) << 32;
+	return val;
+}
+
+#endif /* !__ASSEMBLY__ */
+#endif /* _ASMARM_ARCH_GICV3_H_ */
diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
new file mode 100644
index 000000000000..73ade4681d21
--- /dev/null
+++ b/lib/arm/asm/gic-v3.h
@@ -0,0 +1,104 @@
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
+#ifndef _ASMARM_GIC_H_
+#error Do not directly include <asm/gic-v3.h>. Include <asm/gic.h>
+#endif
+
+/*
+ * Distributor registers
+ *
+ * We expect to be run in Non-secure mode, thus we define the
+ * group1 enable bits with respect to that view.
+ */
+#define GICD_CTLR_RWP			(1U << 31)
+#define GICD_CTLR_ARE_NS		(1U << 4)
+#define GICD_CTLR_ENABLE_G1A		(1U << 1)
+#define GICD_CTLR_ENABLE_G1		(1U << 0)
+
+/* Re-Distributor registers, offsets from RD_base */
+#define GICR_TYPER			0x0008
+
+#define GICR_TYPER_LAST			(1U << 4)
+
+/* Re-Distributor registers, offsets from SGI_base */
+#define GICR_IGROUPR0			GICD_IGROUPR
+#define GICR_ISENABLER0			GICD_ISENABLER
+#define GICR_IPRIORITYR0		GICD_IPRIORITYR
+
+#include <asm/arch_gicv3.h>
+
+#ifndef __ASSEMBLY__
+#include <asm/setup.h>
+#include <asm/smp.h>
+#include <asm/processor.h>
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
+extern void gicv3_set_redist_base(size_t stride);
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
+static inline void gicv3_redist_wait_for_uwp(void)
+{
+	/*
+	 * We can build on gic_do_wait_for_rwp, which uses GICD_ registers
+	 * because GICD_CTLR == GICR_CTLR and GICD_CTLR_RWP == GICR_CTLR_UWP
+	 */
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
index d816b96e46b4..21511997f2a9 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -6,11 +6,11 @@
 #ifndef _ASMARM_GIC_H_
 #define _ASMARM_GIC_H_
 
-#include <asm/gic-v2.h>
 
 /* Distributor registers */
 #define GICD_CTLR			0x0000
 #define GICD_TYPER			0x0004
+#define GICD_IGROUPR			0x0080
 #define GICD_ISENABLER			0x0100
 #define GICD_IPRIORITYR			0x0400
 #define GICD_SGIR			0x0f00
@@ -28,6 +28,9 @@
 #define GICC_INT_PRI_THRESHOLD		0xf0
 #define GICC_INT_SPURIOUS		0x3ff
 
+#include <asm/gic-v2.h>
+#include <asm/gic-v3.h>
+
 #ifndef __ASSEMBLY__
 
 /*
diff --git a/lib/arm/gic-v2.c b/lib/arm/gic-v2.c
new file mode 100644
index 000000000000..e80eb8f29488
--- /dev/null
+++ b/lib/arm/gic-v2.c
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#include <asm/gic.h>
+#include <asm/io.h>
+
+void gicv2_enable_defaults(void)
+{
+	void *dist = gicv2_dist_base();
+	void *cpu_base = gicv2_cpu_base();
+	unsigned int i;
+
+	gicv2_data.irq_nr = GICD_TYPER_IRQS(readl(dist + GICD_TYPER));
+	if (gicv2_data.irq_nr > 1020)
+		gicv2_data.irq_nr = 1020;
+
+	for (i = 0; i < gicv2_data.irq_nr; i += 4)
+		writel(GICD_INT_DEF_PRI_X4, dist + GICD_IPRIORITYR + i);
+
+	writel(GICD_INT_EN_SET_SGI, dist + GICD_ISENABLER + 0);
+	writel(GICD_ENABLE, dist + GICD_CTLR);
+
+	writel(GICC_INT_PRI_THRESHOLD, cpu_base + GICC_PMR);
+	writel(GICC_ENABLE, cpu_base + GICC_CTLR);
+}
diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
new file mode 100644
index 000000000000..c46d16e11782
--- /dev/null
+++ b/lib/arm/gic-v3.c
@@ -0,0 +1,61 @@
+/*
+ * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#include <asm/gic.h>
+#include <asm/io.h>
+
+void gicv3_set_redist_base(size_t stride)
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
+		ptr += stride; /* skip RD_base, SGI_base, etc. */
+	} while (!(typer & GICR_TYPER_LAST));
+
+	/* should never reach here */
+	assert(0);
+}
+
+void gicv3_enable_defaults(void)
+{
+	void *dist = gicv3_dist_base();
+	void *sgi_base;
+	unsigned int i;
+
+	gicv3_data.irq_nr = GICD_TYPER_IRQS(readl(dist + GICD_TYPER));
+	if (gicv3_data.irq_nr > 1020)
+		gicv3_data.irq_nr = 1020;
+
+	writel(0, dist + GICD_CTLR);
+	gicv3_dist_wait_for_rwp();
+
+	writel(GICD_CTLR_ARE_NS | GICD_CTLR_ENABLE_G1A | GICD_CTLR_ENABLE_G1,
+	       dist + GICD_CTLR);
+	gicv3_dist_wait_for_rwp();
+
+	for (i = 0; i < gicv3_data.irq_nr; i += 4)
+		writel(~0, dist + GICD_IGROUPR + i);
+
+	if (!gicv3_redist_base())
+		gicv3_set_redist_base(SZ_64K * 2);
+	sgi_base = gicv3_sgi_base();
+
+	writel(~0, sgi_base + GICR_IGROUPR0);
+
+	for (i = 0; i < 16; i += 4)
+		writel(GICD_INT_DEF_PRI_X4, sgi_base + GICR_IPRIORITYR0 + i);
+
+	writel(GICD_INT_EN_SET_SGI, sgi_base + GICR_ISENABLER0);
+
+	gicv3_write_pmr(GICC_INT_PRI_THRESHOLD);
+	gicv3_write_grpen1(1);
+}
diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index d655105e058b..4d3ddd9722b1 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -8,9 +8,11 @@
 #include <asm/io.h>
 
 struct gicv2_data gicv2_data;
+struct gicv3_data gicv3_data;
 
 /*
  * Documentation/devicetree/bindings/interrupt-controller/arm,gic.txt
+ * Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.txt
  */
 static bool
 gic_get_dt_bases(const char *compatible, void **base1, void **base2)
@@ -48,29 +50,17 @@ int gicv2_init(void)
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
-
-void gicv2_enable_defaults(void)
-{
-	void *dist = gicv2_dist_base();
-	void *cpu_base = gicv2_cpu_base();
-	unsigned int i;
-
-	gicv2_data.irq_nr = GICD_TYPER_IRQS(readl(dist + GICD_TYPER));
-	if (gicv2_data.irq_nr > 1020)
-		gicv2_data.irq_nr = 1020;
-
-	for (i = 0; i < gicv2_data.irq_nr; i += 4)
-		writel(GICD_INT_DEF_PRI_X4, dist + GICD_IPRIORITYR + i);
-
-	writel(GICD_INT_EN_SET_SGI, dist + GICD_ISENABLER + 0);
-	writel(GICD_ENABLE, dist + GICD_CTLR);
-
-	writel(GICC_INT_PRI_THRESHOLD, cpu_base + GICC_PMR);
-	writel(GICC_ENABLE, cpu_base + GICC_CTLR);
-}
diff --git a/lib/arm64/asm/arch_gicv3.h b/lib/arm64/asm/arch_gicv3.h
new file mode 100644
index 000000000000..6d353567f56a
--- /dev/null
+++ b/lib/arm64/asm/arch_gicv3.h
@@ -0,0 +1,44 @@
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
+#define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
+#define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
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
+static inline void gicv3_write_pmr(u32 val)
+{
+	asm volatile("msr_s " __stringify(ICC_PMR_EL1) ", %0" : : "r" ((u64)val));
+}
+
+static inline void gicv3_write_grpen1(u32 val)
+{
+	asm volatile("msr_s " __stringify(ICC_GRPEN1_EL1) ", %0" : : "r" ((u64)val));
+	isb();
+}
+
+#define gicv3_read_typer(c)		readq(c)
+
+#endif /* __ASSEMBLY__ */
+#endif /* _ASMARM64_ARCH_GICV3_H_ */
diff --git a/lib/arm64/asm/gic-v3.h b/lib/arm64/asm/gic-v3.h
new file mode 100644
index 000000000000..8ee5d4d9c181
--- /dev/null
+++ b/lib/arm64/asm/gic-v3.h
@@ -0,0 +1 @@
+#include "../../arm/asm/gic-v3.h"
diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
new file mode 100644
index 000000000000..544a46cb8cc5
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
2.9.3

