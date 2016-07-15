From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v3 08/10] arm/arm64: gicv2: add an IPI test
Date: Fri, 15 Jul 2016 15:00:39 +0200
Message-ID: <1468587641-7300-9-git-send-email-drjones@redhat.com>
References: <1468587641-7300-1-git-send-email-drjones@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1468587641-7300-1-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com, peter.maydell@linaro.org, alex.bennee@linaro.org
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, eric.auger@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
v2: add more details in the output if a test fails,
    report spurious interrupts if we get them
---
 arm/Makefile.common |   6 +-
 arm/gic.c           | 194 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg   |   7 ++
 3 files changed, 204 insertions(+), 3 deletions(-)
 create mode 100644 arm/gic.c

diff --git a/arm/Makefile.common b/arm/Makefile.common
index 41239c37e0920..bc38183ab86e0 100644
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
index 0000000000000..cf7ec1c90413c
--- /dev/null
+++ b/arm/gic.c
@@ -0,0 +1,194 @@
+/*
+ * GIC tests
+ *
+ * GICv2
+ *   . test sending/receiving IPIs
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
+	u32 iar = readl(gicv2_cpu_base() + GIC_CPU_INTACK);
+
+	if (iar != GICC_INT_SPURIOUS) {
+		writel(iar, gicv2_cpu_base() + GIC_CPU_EOI);
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
+		ipi_enable();
+
+		for_each_present_cpu(cpu) {
+			if (cpu == 0)
+				continue;
+			smp_boot_secondary(cpu, ipi_recv);
+		}
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
index ffd12e5794aa0..bb364675043f0 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -51,3 +51,10 @@ file = selftest.flat
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
-- 
2.7.4

