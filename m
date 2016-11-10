From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v4 09/11] arm/arm64: add initial gicv3 support
Date: Thu, 10 Nov 2016 17:08:02 +0100
Message-ID: <1478794084-5273-10-git-send-email-drjones@redhat.com>
References: <1478794084-5273-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E855E40499
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2016 11:08:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y0SR4i+d4ogT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Nov 2016 11:08:09 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 546514047D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2016 11:08:09 -0500 (EST)
In-Reply-To: <1478794084-5273-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andrew Jones <drjones@redhat.com>

---
v4:
 - only take defines from kernel we need now [Andre]
 - simplify enable by not caring if we reinit the distributor [drew]
v2:
 - configure irqs as NS GRP1
---
 lib/arm/asm/arch_gicv3.h   | 42 +++++++++++++++++++++
 lib/arm/asm/gic-v3.h       | 92 ++++++++++++++++++++++++++++++++++++++++++++++
 lib/arm/asm/gic.h          |  1 +
 lib/arm/gic.c              | 56 ++++++++++++++++++++++++++++
 lib/arm64/asm/arch_gicv3.h | 44 ++++++++++++++++++++++
 lib/arm64/asm/gic-v3.h     |  1 +
 lib/arm64/asm/sysreg.h     | 44 ++++++++++++++++++++++
 7 files changed, 280 insertions(+)
 create mode 100644 lib/arm/asm/arch_gicv3.h
 create mode 100644 lib/arm/asm/gic-v3.h
 create mode 100644 lib/arm64/asm/arch_gicv3.h
 create mode 100644 lib/arm64/asm/gic-v3.h
 create mode 100644 lib/arm64/asm/sysreg.h

diff --git a/lib/arm/asm/arch_gicv3.h b/lib/arm/asm/arch_gicv3.h
new file mode 100644
index 000000000000..81a1e5f6c29c
--- /dev/null
+++ b/lib/arm/asm/arch_gicv3.h
@@ -0,0 +1,42 @@
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
index 000000000000..03321f8c860f
--- /dev/null
+++ b/lib/arm/asm/gic-v3.h
@@ -0,0 +1,92 @@
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
+#define GICD_CTLR			0x0000
+#define GICD_TYPER			0x0004
+#define GICD_IGROUPR			0x0080
+
+#define GICD_CTLR_RWP			(1U << 31)
+#define GICD_CTLR_ARE_NS		(1U << 4)
+#define GICD_CTLR_ENABLE_G1A		(1U << 1)
+#define GICD_CTLR_ENABLE_G1		(1U << 0)
+
+#define GICR_TYPER			0x0008
+#define GICR_IGROUPR0			GICD_IGROUPR
+#define GICR_TYPER_LAST			(1U << 4)
+
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
index 328e078a9ae1..4897bc592cdd 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -7,6 +7,7 @@
 #define _ASMARM_GIC_H_
 
 #include <asm/gic-v2.h>
+#include <asm/gic-v3.h>
 
 #define GIC_CPU_CTRL			0x00
 #define GIC_CPU_PRIMASK			0x04
diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index 91d78c9a0cc2..af58a11ea13e 100644
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
@@ -48,10 +50,18 @@ int gicv2_init(void)
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
 
@@ -73,3 +83,49 @@ void gicv2_enable_defaults(void)
 	writel(GICC_INT_PRI_THRESHOLD, cpu_base + GIC_CPU_PRIMASK);
 	writel(GICC_ENABLE, cpu_base + GIC_CPU_CTRL);
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
+	gicv3_data.irq_nr = GICD_TYPER_IRQS(readl(dist + GICD_TYPER));
+	if (gicv3_data.irq_nr > 1020)
+		gicv3_data.irq_nr = 1020;
+
+	writel(GICD_CTLR_ARE_NS | GICD_CTLR_ENABLE_G1A | GICD_CTLR_ENABLE_G1,
+	       dist + GICD_CTLR);
+	gicv3_dist_wait_for_rwp();
+
+	if (!gicv3_redist_base())
+		gicv3_set_redist_base();
+	sgi_base = gicv3_sgi_base();
+
+	writel(~0, sgi_base + GICR_IGROUPR0);
+	writel(GICD_INT_EN_SET_SGI, sgi_base + GIC_DIST_ENABLE_SET);
+
+	for (i = 0; i < 32; i += 4)
+		writel(GICD_INT_DEF_PRI_X4, sgi_base + GIC_DIST_PRI + i);
+	gicv3_redist_wait_for_rwp();
+
+	gicv3_write_pmr(0xf0);
+	gicv3_write_grpen1(1);
+}
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
2.7.4
