From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH kvm-unit-tests 1/2] arm64: add vtimer test
Date: Tue,  4 Jul 2017 15:58:37 +0200
Message-ID: <20170704135838.9061-2-drjones@redhat.com>
References: <20170704135838.9061-1-drjones@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170704135838.9061-1-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: agraf@suse.de, cdall@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Alexander Graf <agraf@suse.de>

All virtualization capable ARM cores support the ARM virtual timer.

Add minimalistic check for firing a virtual timer event, confirming
by checking that the timer pin is marked as pending on the GIC.

Signed-off-by: Alexander Graf <agraf@suse.de>
[ Applied my review comments and a few other tweaks. ]
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/Makefile.arm64 |   2 +-
 arm/timer.c        | 114 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg  |   6 +++
 lib/arm/asm/gic.h  |   4 ++
 4 files changed, 125 insertions(+), 1 deletion(-)
 create mode 100644 arm/timer.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 24319d6c00ed..f04bbf476763 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -14,7 +14,7 @@ cflatobjs += lib/arm64/spinlock.o
 OBJDIRS += lib/arm64
 
 # arm64 specific tests
-tests =
+tests = $(TEST_DIR)/timer.flat
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/arm/timer.c b/arm/timer.c
new file mode 100644
index 000000000000..ec110ee08d97
--- /dev/null
+++ b/arm/timer.c
@@ -0,0 +1,114 @@
+/*
+ * Timer tests for the ARM virt machine.
+ *
+ * Copyright (C) 2017, Alexander Graf <agraf@suse.de>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
+ */
+#include <libcflat.h>
+#include <devicetree.h>
+#include <asm/processor.h>
+#include <asm/gic.h>
+#include <asm/io.h>
+
+#define CNTV_CTL_ENABLE  (1 << 0)
+#define CNTV_CTL_IMASK   (1 << 1)
+#define CNTV_CTL_ISTATUS (1 << 2)
+
+static u32 vtimer_irq, vtimer_irq_flags;
+static void *gic_ispendr;
+
+static bool gic_vtimer_pending(void)
+{
+	return readl(gic_ispendr) & (1 << PPI(vtimer_irq));
+}
+
+static bool test_cval_10msec(void)
+{
+	u64 time_10ms = read_sysreg(cntfrq_el0) / 100;
+	u64 time_1us = time_10ms / 10000;
+	u64 before_timer, after_timer;
+	s64 difference;
+
+	/* Program timer to fire in 10 ms */
+	before_timer = read_sysreg(cntvct_el0);
+	write_sysreg(before_timer + time_10ms, cntv_cval_el0);
+
+	/* Wait for the timer to fire */
+	while (!(read_sysreg(cntv_ctl_el0) & CNTV_CTL_ISTATUS))
+		;
+
+	/* It fired, check how long it took */
+	after_timer = read_sysreg(cntvct_el0);
+	difference = after_timer - (before_timer + time_10ms);
+
+	report_info("After timer: 0x%016lx", after_timer);
+	report_info("Expected   : 0x%016lx", before_timer + time_10ms);
+	report_info("Difference : %ld us", difference / time_1us);
+
+	if (difference < 0) {
+		printf("CNTV_CTL_EL0.ISTATUS set too early\n");
+		return false;
+	}
+	return difference < time_10ms;
+}
+
+static void test_vtimer(void)
+{
+	report_prefix_push("vtimer-busy-loop");
+
+	/* Enable the timer */
+	write_sysreg(~0, cntv_cval_el0);
+	isb();
+	write_sysreg(CNTV_CTL_ENABLE, cntv_ctl_el0);
+
+	report("not pending before", !gic_vtimer_pending());
+	report("latency within 10 ms", test_cval_10msec());
+	report("pending after", gic_vtimer_pending());
+
+	/* Disable the timer again */
+	write_sysreg(0, cntv_ctl_el0);
+
+	report_prefix_pop();
+}
+
+static void test_init(void)
+{
+	const struct fdt_property *prop;
+	const void *fdt = dt_fdt();
+	int node, len;
+	u32 *data;
+
+	node = fdt_node_offset_by_compatible(fdt, -1, "arm,armv8-timer");
+	assert(node >= 0);
+	prop = fdt_get_property(fdt, node, "interrupts", &len);
+	assert(prop && len == (4 * 3 * sizeof(u32)));
+	data = (u32 *)prop->data;
+	assert(fdt32_to_cpu(data[6]) == 1);
+	vtimer_irq = fdt32_to_cpu(data[7]);
+	vtimer_irq_flags = fdt32_to_cpu(data[8]);
+
+	gic_enable_defaults();
+
+	switch (gic_version()) {
+	case 2:
+		gic_ispendr = gicv2_dist_base() + GICD_ISPENDR;
+		break;
+	case 3:
+		gic_ispendr = gicv3_sgi_base() + GICD_ISPENDR;
+		break;
+	}
+}
+
+int main(void)
+{
+	printf("CNTFRQ_EL0   : 0x%016lx\n", read_sysreg(cntfrq_el0));
+	printf("CNTVCT_EL0   : 0x%016lx\n", read_sysreg(cntvct_el0));
+	printf("CNTV_CTL_EL0 : 0x%016lx\n", read_sysreg(cntv_ctl_el0));
+	printf("CNTV_CVAL_EL0: 0x%016lx\n", read_sysreg(cntv_cval_el0));
+
+	test_init();
+	test_vtimer();
+
+	return report_summary();
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 73a2419fefe6..bdfedf86b01c 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -109,3 +109,9 @@ groups = gic
 file = psci.flat
 smp = $MAX_SMP
 groups = psci
+
+# Timer tests
+[timer]
+file = timer.flat
+groups = timer
+timeout = 2s
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index c688ccc74c79..2eb4af8d6c81 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -12,6 +12,8 @@
 #define GICD_TYPER			0x0004
 #define GICD_IGROUPR			0x0080
 #define GICD_ISENABLER			0x0100
+#define GICD_ISPENDR			0x0200
+#define GICD_ICPENDR			0x0280
 #define GICD_ISACTIVER			0x0300
 #define GICD_ICACTIVER			0x0380
 #define GICD_IPRIORITYR			0x0400
@@ -33,6 +35,8 @@
 #include <asm/gic-v2.h>
 #include <asm/gic-v3.h>
 
+#define PPI(irq)			((irq) + 16)
+
 #ifndef __ASSEMBLY__
 #include <asm/cpumask.h>
 
-- 
2.9.4
