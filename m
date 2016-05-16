From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH 08/10] arm/arm64: gicv2: add an IPI test
Date: Mon, 16 May 2016 09:57:22 +0200
Message-ID: <1463385444-12916-9-git-send-email-drjones@redhat.com>
References: <1463385444-12916-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6E8D407A0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 03:54:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ow3MlxzQzboZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2016 03:54:37 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C5A3B49B37
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 03:54:37 -0400 (EDT)
In-Reply-To: <1463385444-12916-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com, peter.maydell@linaro.org, alex.bennee@linaro.org
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/Makefile.common |   6 +-
 arm/gic.c           | 165 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg   |   7 +++
 3 files changed, 175 insertions(+), 3 deletions(-)
 create mode 100644 arm/gic.c

diff --git a/arm/Makefile.common b/arm/Makefile.common
index 13a185f7d4473..378fecc910c41 100644
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
index 0000000000000..24be9e0ade369
--- /dev/null
+++ b/arm/gic.c
@@ -0,0 +1,165 @@
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
+static int acked[NR_CPUS];
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
+			report("completed in < %d ms", true, ++i * 100);
+			return;
+		}
+	}
+	report("timed-out (5s timeout)", false);
+}
+
+static void ipi_handler(struct pt_regs *regs __unused)
+{
+	u32 iar = readl(gicv2_cpu_base() + GIC_CPU_INTACK);
+
+	if (iar != GICC_INT_SPURIOUS) {
+		writel(iar, gicv2_cpu_base() + GIC_CPU_EOI);
+		smp_rmb();
+		++acked[smp_processor_id()];
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
+	if (argc == 0) {
+
+		report_prefix_push("ipi");
+		ipi_enable();
+		ipi_test_self();
+
+	} else if (!strcmp(argv[0], "ipi")) {
+
+		report_prefix_push(argv[0]);
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
+		report_prefix_pop();
+
+	} else {
+		report_abort("Unknown subtest '%s'", argv[0]);
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
2.4.11
