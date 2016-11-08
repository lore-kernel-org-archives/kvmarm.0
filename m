From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v4 07/11] arm/arm64: gicv2: add an IPI test
Date: Tue,  8 Nov 2016 21:21:35 +0100
Message-ID: <1478636499-14339-8-git-send-email-drjones@redhat.com>
References: <1478636499-14339-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F5FB40284
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2016 15:21:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 72Cs-za8-yEx for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Nov 2016 15:21:43 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EE44840199
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2016 15:21:41 -0500 (EST)
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

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
v4: properly mask irqnr in ipi_handler
v2: add more details in the output if a test fails,
    report spurious interrupts if we get them
---
 arm/Makefile.common |   6 +-
 arm/gic.c           | 195 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg   |   7 ++
 lib/arm/asm/gic.h   |   6 ++
 4 files changed, 211 insertions(+), 3 deletions(-)
 create mode 100644 arm/gic.c

diff --git a/arm/Makefile.common b/arm/Makefile.common
index 41239c37e092..bc38183ab86e 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -9,9 +9,9 @@ ifeq ($(LOADADDR),)
 	LOADADDR = 0x40000000
 endif
 
-tests-common = \
-	$(TEST_DIR)/selftest.flat \
-	$(TEST_DIR)/spinlock-test.flat
+tests-common  = $(TEST_DIR)/selftest.flat
+tests-common += $(TEST_DIR)/spinlock-test.flat
+tests-common += $(TEST_DIR)/gic.flat
 
 all: test_cases
 
diff --git a/arm/gic.c b/arm/gic.c
new file mode 100644
index 000000000000..efefab7296d4
--- /dev/null
+++ b/arm/gic.c
@@ -0,0 +1,195 @@
+/*
+ * GIC tests
+ *
+ * GICv2
+ *   + test sending/receiving IPIs
+ *
+ * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#include <libcflat.h>
+#include <asm/setup.h>
+#include <asm/processor.h>
+#include <asm/gic.h>
+#include <asm/smp.h>
+#include <asm/barrier.h>
+#include <asm/io.h>
+
+static int gic_version;
+static int acked[NR_CPUS], spurious[NR_CPUS];
+static cpumask_t ready;
+
+static void nr_cpu_check(int nr)
+{
+	if (nr_cpus < nr)
+		report_abort("At least %d cpus required", nr);
+}
+
+static void wait_on_ready(void)
+{
+	cpumask_set_cpu(smp_processor_id(), &ready);
+	while (!cpumask_full(&ready))
+		cpu_relax();
+}
+
+static void check_acked(cpumask_t *mask)
+{
+	int missing = 0, extra = 0, unexpected = 0;
+	int nr_pass, cpu, i;
+
+	/* Wait up to 5s for all interrupts to be delivered */
+	for (i = 0; i < 50; ++i) {
+		mdelay(100);
+		nr_pass = 0;
+		for_each_present_cpu(cpu) {
+			smp_rmb();
+			nr_pass += cpumask_test_cpu(cpu, mask) ?
+				acked[cpu] == 1 : acked[cpu] == 0;
+		}
+		if (nr_pass == nr_cpus) {
+			report("Completed in %d ms", true, ++i * 100);
+			return;
+		}
+	}
+
+	for_each_present_cpu(cpu) {
+		if (cpumask_test_cpu(cpu, mask)) {
+			if (!acked[cpu])
+				++missing;
+			else if (acked[cpu] > 1)
+				++extra;
+		} else {
+			if (acked[cpu])
+				++unexpected;
+		}
+	}
+
+	report("Timed-out (5s). ACKS: missing=%d extra=%d unexpected=%d",
+	       false, missing, extra, unexpected);
+}
+
+static void ipi_handler(struct pt_regs *regs __unused)
+{
+	u32 irqstat = readl(gicv2_cpu_base() + GIC_CPU_INTACK);
+	u32 irqnr = irqstat & GICC_IAR_INT_ID_MASK;
+
+	if (irqnr != GICC_INT_SPURIOUS) {
+		writel(irqstat, gicv2_cpu_base() + GIC_CPU_EOI);
+		smp_rmb(); /* pairs with wmb in ipi_test functions */
+		++acked[smp_processor_id()];
+		smp_wmb(); /* pairs with rmb in check_acked */
+	} else {
+		++spurious[smp_processor_id()];
+		smp_wmb();
+	}
+}
+
+static void ipi_test_self(void)
+{
+	cpumask_t mask;
+
+	report_prefix_push("self");
+	memset(acked, 0, sizeof(acked));
+	smp_wmb();
+	cpumask_clear(&mask);
+	cpumask_set_cpu(0, &mask);
+	writel(2 << 24, gicv2_dist_base() + GIC_DIST_SOFTINT);
+	check_acked(&mask);
+	report_prefix_pop();
+}
+
+static void ipi_test_smp(void)
+{
+	cpumask_t mask;
+	unsigned long tlist;
+
+	report_prefix_push("target-list");
+	memset(acked, 0, sizeof(acked));
+	smp_wmb();
+	tlist = cpumask_bits(&cpu_present_mask)[0] & 0xaa;
+	cpumask_bits(&mask)[0] = tlist;
+	writel((u8)tlist << 16, gicv2_dist_base() + GIC_DIST_SOFTINT);
+	check_acked(&mask);
+	report_prefix_pop();
+
+	report_prefix_push("broadcast");
+	memset(acked, 0, sizeof(acked));
+	smp_wmb();
+	cpumask_copy(&mask, &cpu_present_mask);
+	cpumask_clear_cpu(0, &mask);
+	writel(1 << 24, gicv2_dist_base() + GIC_DIST_SOFTINT);
+	check_acked(&mask);
+	report_prefix_pop();
+}
+
+static void ipi_enable(void)
+{
+	gicv2_enable_defaults();
+#ifdef __arm__
+	install_exception_handler(EXCPTN_IRQ, ipi_handler);
+#else
+	install_irq_handler(EL1H_IRQ, ipi_handler);
+#endif
+	local_irq_enable();
+}
+
+static void ipi_recv(void)
+{
+	ipi_enable();
+	cpumask_set_cpu(smp_processor_id(), &ready);
+	while (1)
+		wfi();
+}
+
+int main(int argc, char **argv)
+{
+	char pfx[8];
+	int cpu;
+
+	gic_version = gic_init();
+	if (!gic_version)
+		report_abort("No gic present!");
+
+	snprintf(pfx, 8, "gicv%d", gic_version);
+	report_prefix_push(pfx);
+
+	if (argc < 2) {
+
+		report_prefix_push("ipi");
+		ipi_enable();
+		ipi_test_self();
+		report_prefix_pop();
+
+	} else if (!strcmp(argv[1], "ipi")) {
+
+		report_prefix_push(argv[1]);
+		nr_cpu_check(2);
+
+		for_each_present_cpu(cpu) {
+			if (cpu == 0)
+				continue;
+			smp_boot_secondary(cpu, ipi_recv);
+		}
+		ipi_enable();
+		wait_on_ready();
+		ipi_test_self();
+		ipi_test_smp();
+
+		smp_rmb();
+		for_each_present_cpu(cpu) {
+			if (spurious[cpu]) {
+				printf("ipi: WARN: cpu%d got %d spurious "
+				       "interrupts\n",
+				       spurious[cpu], smp_processor_id());
+			}
+		}
+
+		report_prefix_pop();
+
+	} else {
+		report_abort("Unknown subtest '%s'", argv[1]);
+	}
+
+	return report_summary();
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 3f6fa45c587e..68bf5cd6008f 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -54,3 +54,10 @@ file = selftest.flat
 smp = $MAX_SMP
 extra_params = -append 'smp'
 groups = selftest
+
+# Test GIC emulation
+[gicv2-ipi]
+file = gic.flat
+smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
+extra_params = -machine gic-version=2 -append 'ipi'
+groups = gic
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index ec92f1064dc0..328e078a9ae1 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -10,14 +10,20 @@
 
 #define GIC_CPU_CTRL			0x00
 #define GIC_CPU_PRIMASK			0x04
+#define GIC_CPU_INTACK			0x0c
+#define GIC_CPU_EOI			0x10
 
 #define GICC_ENABLE			0x1
 #define GICC_INT_PRI_THRESHOLD		0xf0
 
+#define GICC_IAR_INT_ID_MASK		0x3ff
+#define GICC_INT_SPURIOUS		1023
+
 #define GIC_DIST_CTRL			0x000
 #define GIC_DIST_CTR			0x004
 #define GIC_DIST_ENABLE_SET		0x100
 #define GIC_DIST_PRI			0x400
+#define GIC_DIST_SOFTINT		0xf00
 
 #define GICD_ENABLE			0x1
 #define GICD_INT_EN_SET_SGI		0x0000ffff
-- 
2.7.4
