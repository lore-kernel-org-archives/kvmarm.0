From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v4 06/11] arm/arm64: add initial gicv2 support
Date: Tue,  8 Nov 2016 21:21:34 +0100
Message-ID: <1478636499-14339-7-git-send-email-drjones@redhat.com>
References: <1478636499-14339-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A1B2401F2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2016 15:21:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cZOntn1jUIRT for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Nov 2016 15:21:39 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52398404EF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2016 15:21:39 -0500 (EST)
In-Reply-To: <1478636499-14339-1-git-send-email-drjones@redhat.com>
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

Add some gicv2 support. This just adds init and enable
functions, allowing unit tests to start messing with it.

Signed-off-by: Andrew Jones <drjones@redhat.com>

---
v4:
 - only take defines from kernel we need now [Andre]
 - moved defines to asm/gic.h so they'll be shared with v3 [drew]
 - simplify enable by not caring if we reinit the distributor [drew]
 - init all GICD_INT_DEF_PRI_X4 registers [Eric]
---
 arm/Makefile.common    |  1 +
 lib/arm/asm/gic-v2.h   | 28 +++++++++++++++++++
 lib/arm/asm/gic.h      | 44 +++++++++++++++++++++++++++++
 lib/arm/gic.c          | 75 ++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/arm64/asm/gic-v2.h |  1 +
 lib/arm64/asm/gic.h    |  1 +
 6 files changed, 150 insertions(+)
 create mode 100644 lib/arm/asm/gic-v2.h
 create mode 100644 lib/arm/asm/gic.h
 create mode 100644 lib/arm/gic.c
 create mode 100644 lib/arm64/asm/gic-v2.h
 create mode 100644 lib/arm64/asm/gic.h

diff --git a/arm/Makefile.common b/arm/Makefile.common
index ccb554d9251a..41239c37e092 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -42,6 +42,7 @@ cflatobjs += lib/arm/mmu.o
 cflatobjs += lib/arm/bitops.o
 cflatobjs += lib/arm/psci.o
 cflatobjs += lib/arm/smp.o
+cflatobjs += lib/arm/gic.o
 
 libeabi = lib/arm/libeabi.a
 eabiobjs = lib/arm/eabi_compat.o
diff --git a/lib/arm/asm/gic-v2.h b/lib/arm/asm/gic-v2.h
new file mode 100644
index 000000000000..f91530f88355
--- /dev/null
+++ b/lib/arm/asm/gic-v2.h
@@ -0,0 +1,28 @@
+/*
+ * All GIC* defines are lifted from include/linux/irqchip/arm-gic.h
+ *
+ * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#ifndef _ASMARM_GIC_V2_H_
+#define _ASMARM_GIC_V2_H_
+
+#ifndef _ASMARM_GIC_H_
+#error Do not directly include <asm/gic-v2.h>. Include <asm/gic.h>
+#endif
+
+struct gicv2_data {
+	void *dist_base;
+	void *cpu_base;
+	unsigned int irq_nr;
+};
+extern struct gicv2_data gicv2_data;
+
+#define gicv2_dist_base()		(gicv2_data.dist_base)
+#define gicv2_cpu_base()		(gicv2_data.cpu_base)
+
+extern int gicv2_init(void);
+extern void gicv2_enable_defaults(void);
+
+#endif /* _ASMARM_GIC_V2_H_ */
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
new file mode 100644
index 000000000000..ec92f1064dc0
--- /dev/null
+++ b/lib/arm/asm/gic.h
@@ -0,0 +1,44 @@
+/*
+ * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#ifndef _ASMARM_GIC_H_
+#define _ASMARM_GIC_H_
+
+#include <asm/gic-v2.h>
+
+#define GIC_CPU_CTRL			0x00
+#define GIC_CPU_PRIMASK			0x04
+
+#define GICC_ENABLE			0x1
+#define GICC_INT_PRI_THRESHOLD		0xf0
+
+#define GIC_DIST_CTRL			0x000
+#define GIC_DIST_CTR			0x004
+#define GIC_DIST_ENABLE_SET		0x100
+#define GIC_DIST_PRI			0x400
+
+#define GICD_ENABLE			0x1
+#define GICD_INT_EN_SET_SGI		0x0000ffff
+#define GICD_INT_DEF_PRI		0xa0
+#define GICD_INT_DEF_PRI_X4		((GICD_INT_DEF_PRI << 24) |\
+					(GICD_INT_DEF_PRI << 16) |\
+					(GICD_INT_DEF_PRI << 8) |\
+					GICD_INT_DEF_PRI)
+
+#define GICD_TYPER_IRQS(typer)		((((typer) & 0x1f) + 1) * 32)
+
+#ifndef __ASSEMBLY__
+
+/*
+ * gic_init will try to find all known gics, and then
+ * initialize the gic data for the one found.
+ * returns
+ *  0   : no gic was found
+ *  > 0 : the gic version of the gic found
+ */
+extern int gic_init(void);
+
+#endif /* !__ASSEMBLY__ */
+#endif /* _ASMARM_GIC_H_ */
diff --git a/lib/arm/gic.c b/lib/arm/gic.c
new file mode 100644
index 000000000000..91d78c9a0cc2
--- /dev/null
+++ b/lib/arm/gic.c
@@ -0,0 +1,75 @@
+/*
+ * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#include <devicetree.h>
+#include <asm/gic.h>
+#include <asm/io.h>
+
+struct gicv2_data gicv2_data;
+
+/*
+ * Documentation/devicetree/bindings/interrupt-controller/arm,gic.txt
+ */
+static bool
+gic_get_dt_bases(const char *compatible, void **base1, void **base2)
+{
+	struct dt_pbus_reg reg;
+	struct dt_device gic;
+	struct dt_bus bus;
+	int node, ret;
+
+	dt_bus_init_defaults(&bus);
+	dt_device_init(&gic, &bus, NULL);
+
+	node = dt_device_find_compatible(&gic, compatible);
+	assert(node >= 0 || node == -FDT_ERR_NOTFOUND);
+
+	if (node == -FDT_ERR_NOTFOUND)
+		return false;
+
+	dt_device_bind_node(&gic, node);
+
+	ret = dt_pbus_translate(&gic, 0, &reg);
+	assert(ret == 0);
+	*base1 = ioremap(reg.addr, reg.size);
+
+	ret = dt_pbus_translate(&gic, 1, &reg);
+	assert(ret == 0);
+	*base2 = ioremap(reg.addr, reg.size);
+
+	return true;
+}
+
+int gicv2_init(void)
+{
+	return gic_get_dt_bases("arm,cortex-a15-gic",
+			&gicv2_data.dist_base, &gicv2_data.cpu_base);
+}
+
+int gic_init(void)
+{
+	if (gicv2_init())
+		return 2;
+	return 0;
+}
+
+void gicv2_enable_defaults(void)
+{
+	void *dist = gicv2_dist_base();
+	void *cpu_base = gicv2_cpu_base();
+	unsigned int i;
+
+	gicv2_data.irq_nr = GICD_TYPER_IRQS(readl(dist + GIC_DIST_CTR));
+	if (gicv2_data.irq_nr > 1020)
+		gicv2_data.irq_nr = 1020;
+
+	for (i = 0; i < gicv2_data.irq_nr; i += 4)
+		writel(GICD_INT_DEF_PRI_X4, dist + i + GIC_DIST_PRI);
+
+	writel(GICD_INT_EN_SET_SGI, dist + GIC_DIST_ENABLE_SET);
+	writel(GICD_ENABLE, dist + GIC_DIST_CTRL);
+	writel(GICC_INT_PRI_THRESHOLD, cpu_base + GIC_CPU_PRIMASK);
+	writel(GICC_ENABLE, cpu_base + GIC_CPU_CTRL);
+}
diff --git a/lib/arm64/asm/gic-v2.h b/lib/arm64/asm/gic-v2.h
new file mode 100644
index 000000000000..52226624a209
--- /dev/null
+++ b/lib/arm64/asm/gic-v2.h
@@ -0,0 +1 @@
+#include "../../arm/asm/gic-v2.h"
diff --git a/lib/arm64/asm/gic.h b/lib/arm64/asm/gic.h
new file mode 100644
index 000000000000..e5eb302a31b4
--- /dev/null
+++ b/lib/arm64/asm/gic.h
@@ -0,0 +1 @@
+#include "../../arm/asm/gic.h"
-- 
2.7.4
