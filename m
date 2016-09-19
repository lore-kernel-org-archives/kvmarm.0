From: Alexander Graf <agraf@suse.de>
Subject: [PATCH] arm: Add simple arch timer test
Date: Mon, 19 Sep 2016 13:44:40 +0200
Message-ID: <1474285480-215480-1-git-send-email-agraf@suse.de>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org
Cc: kvmarm@lists.cs.columbia.edu, drjones@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

All virtualization capable ARM cores support the ARM architected virtual timer.

This patch adds minimalistic checks whether we can fire a virtual timer event
using them. It does not actually trigger an interrupt yet, as infrastructure
for that is missing. However, it does check whether the timer pin is marked as
pending on the GIC.

Signed-off-by: Alexander Graf <agraf@suse.de>
---
 arm/Makefile.arm64 |   2 +-
 arm/vtimer-test.c  | 122 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 123 insertions(+), 1 deletion(-)
 create mode 100644 arm/vtimer-test.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 0b0761c..5b3fbe8 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -12,7 +12,7 @@ cflatobjs += lib/arm64/processor.o
 cflatobjs += lib/arm64/spinlock.o
 
 # arm64 specific tests
-tests =
+tests = $(TEST_DIR)/vtimer-test.flat
 
 include $(TEST_DIR)/Makefile.common
 
diff --git a/arm/vtimer-test.c b/arm/vtimer-test.c
new file mode 100644
index 0000000..a3e24ce
--- /dev/null
+++ b/arm/vtimer-test.c
@@ -0,0 +1,122 @@
+/*
+ * Unit tests for the virtual timer on the ARM virt machine
+ *
+ * Copyright (C) 2016, Alexander Graf <agraf@suse.de>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#include <libcflat.h>
+#include <asm/io.h>
+
+#define VTIMER_CTL_ENABLE  (1 << 0)
+#define VTIMER_CTL_IMASK   (1 << 1)
+#define VTIMER_CTL_ISTATUS (1 << 2)
+
+#define VIRT_GIC_DIST_BASE 0x08000000
+#define GIC_DIST_PENDING_SET            0x200
+#define GIC_DIST_PENDING_CLEAR          0x280
+#define GIC_DIST_ACTIVE_SET             0x300
+#define GIC_DIST_ACTIVE_CLEAR           0x380
+
+#define VIRT_GIC_CPU_BASE  0x08010000
+
+#define ARCH_TIMER_VIRT_IRQ   11
+#define ARCH_TIMER_S_EL1_IRQ  13
+#define ARCH_TIMER_NS_EL1_IRQ 14
+#define ARCH_TIMER_NS_EL2_IRQ 10
+
+static void write_vtimer_ctl(u64 val)
+{
+	asm volatile("msr cntv_ctl_el0, %0" : : "r" (val));
+}
+
+static void write_vtimer_cval(u64 val)
+{
+	asm volatile("msr cntv_cval_el0, %0" : : "r" (val));
+}
+
+static u64 read_vtimer_ctl(void)
+{
+	u64 val;
+	asm volatile("mrs %0, cntv_ctl_el0" : "=r" (val));
+	return val;
+}
+
+static u64 read_vtimer_cval(void)
+{
+	u64 val;
+	asm volatile("mrs %0, cntv_cval_el0" : "=r" (val));
+	return val;
+}
+
+static u64 read_vtimer_val(void)
+{
+	u64 val;
+	asm volatile("mrs %0, cntvct_el0" : "=r" (val));
+	return val;
+}
+
+static u64 read_vtimer_freq(void)
+{
+	u64 val;
+	asm volatile("mrs %0, cntfrq_el0" : "=r" (val));
+	return val;
+}
+
+static bool gic_vtimer_pending(void)
+{
+	u32 *pending = (u32*)(VIRT_GIC_DIST_BASE + GIC_DIST_PENDING_SET);
+	return (readl(pending) & (1 << (ARCH_TIMER_VIRT_IRQ + 16)));
+}
+
+static bool test_cval_10msec(void)
+{
+	u64 time_10ms = read_vtimer_freq() / 100;
+	u64 time_1us = time_10ms / 10000;
+	u64 before_timer = read_vtimer_val();
+	u64 after_timer, latency;
+
+	/* Program timer to fire in 10ms */
+	write_vtimer_cval(before_timer + time_10ms);
+
+	/* Wait for the timer to fire */
+	while (!(read_vtimer_ctl() & VTIMER_CTL_ISTATUS)) ;
+
+	/* It fired, check how long it took */
+	after_timer = read_vtimer_val();
+
+	latency = (after_timer - (before_timer + time_10ms));
+	printf("After timer: 0x%lx\n", after_timer);
+	printf("Expected   : 0x%lx\n", before_timer + time_10ms);
+	printf("Latency    : %ld us\n", latency / time_1us);
+
+	return latency < time_10ms;
+}
+
+static void test_vtimer(void)
+{
+	printf("\n=== vtimer with busy loop ===\n");
+
+	/* Enable the timer */
+	write_vtimer_cval(-1);
+	write_vtimer_ctl(VTIMER_CTL_ENABLE);
+
+	report("timer is not pending before", !gic_vtimer_pending());
+	report("latency is within 10ms", test_cval_10msec());
+	report("timer is pending after", gic_vtimer_pending());
+
+	/* Disable the timer again */
+	write_vtimer_ctl(0);
+}
+
+int main(void)
+{
+	printf("vtimer ctl:  0x%lx\n", read_vtimer_ctl());
+	printf("vtimer cval: 0x%lx\n", read_vtimer_cval());
+	printf("vtimer val:  0x%lx\n", read_vtimer_val());
+	printf("vtimer freq: 0x%lx\n", read_vtimer_freq());
+
+	test_vtimer();
+
+	return report_summary();
+}
-- 
1.8.5.6

