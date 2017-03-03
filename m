From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH kvm-unit-tests v2 1/2] arm/arm64: Add PSCI tests
Date: Fri,  3 Mar 2017 15:30:56 +0100
Message-ID: <20170303143057.27275-2-drjones@redhat.com>
References: <20170303143057.27275-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3F5340C27
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Mar 2017 09:29:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oV1dCI7HAB1v for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Mar 2017 09:29:47 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A308B40BE9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Mar 2017 09:29:47 -0500 (EST)
In-Reply-To: <20170303143057.27275-1-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Levente Kurusa <lkurusa@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Levente Kurusa <lkurusa@redhat.com>

The cpu_on test exposed two races in KVM's PSCI emulation.

Signed-off-by: Levente Kurusa <lkurusa@redhat.com>
[Rewrote the cpu_on test to improve the chance of hitting the race.
 Also added affinity-info tests and made some minor cleanups. -drew]
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/Makefile.common |   1 +
 arm/psci.c          | 118 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg   |   6 +++
 3 files changed, 125 insertions(+)
 create mode 100644 arm/psci.c

diff --git a/arm/Makefile.common b/arm/Makefile.common
index f7193c3e6d64..74c7394eb7c1 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -14,6 +14,7 @@ tests-common += $(TEST_DIR)/spinlock-test.flat
 tests-common += $(TEST_DIR)/pci-test.flat
 tests-common += $(TEST_DIR)/pmu.flat
 tests-common += $(TEST_DIR)/gic.flat
+tests-common += $(TEST_DIR)/psci.flat
 
 tests-all = $(tests-common) $(tests)
 all: $(tests-all)
diff --git a/arm/psci.c b/arm/psci.c
new file mode 100644
index 000000000000..86f621b4ddba
--- /dev/null
+++ b/arm/psci.c
@@ -0,0 +1,118 @@
+/*
+ * PSCI tests
+ *
+ * Copyright (C) 2017, Red Hat, Inc.
+ * Author: Levente Kurusa <lkurusa@redhat.com>
+ * Author: Andrew Jones <drjones@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#include <libcflat.h>
+#include <asm/smp.h>
+#include <asm/psci.h>
+
+static bool psci_invalid_function(void)
+{
+	return psci_invoke(1337, 0, 0, 0) == PSCI_RET_NOT_SUPPORTED;
+}
+
+static int psci_affinity_info(unsigned long target_affinity, uint32_t lowest_affinity_level)
+{
+#ifdef __arm__
+	return psci_invoke(PSCI_0_2_FN_AFFINITY_INFO, target_affinity, lowest_affinity_level, 0);
+#else
+	return psci_invoke(PSCI_0_2_FN64_AFFINITY_INFO, target_affinity, lowest_affinity_level, 0);
+#endif
+}
+
+static bool psci_affinity_info_on(void)
+{
+	return psci_affinity_info(cpus[0], 0) == PSCI_0_2_AFFINITY_LEVEL_ON;
+}
+
+static bool psci_affinity_info_off(void)
+{
+	return psci_affinity_info(cpus[1], 0) == PSCI_0_2_AFFINITY_LEVEL_OFF;
+}
+
+static int cpu_on_ret[NR_CPUS];
+static cpumask_t cpu_on_ready, cpu_on_done;
+static volatile int cpu_on_start;
+
+static void cpu_on_secondary_entry(void)
+{
+	int cpu = smp_processor_id();
+
+	cpumask_set_cpu(cpu, &cpu_on_ready);
+	while (!cpu_on_start)
+		cpu_relax();
+	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(halt));
+	cpumask_set_cpu(cpu, &cpu_on_done);
+	halt();
+}
+
+static bool psci_cpu_on_test(void)
+{
+	bool failed = false;
+	int cpu;
+
+	cpumask_set_cpu(1, &cpu_on_ready);
+	cpumask_set_cpu(1, &cpu_on_done);
+
+	for_each_present_cpu(cpu) {
+		if (cpu < 2)
+			continue;
+		smp_boot_secondary(cpu, cpu_on_secondary_entry);
+	}
+
+	cpumask_set_cpu(0, &cpu_on_ready);
+	while (!cpumask_full(&cpu_on_ready))
+		cpu_relax();
+
+	cpu_on_start = 1;
+	smp_mb();
+
+	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(halt));
+	cpumask_set_cpu(0, &cpu_on_done);
+
+	while (!cpumask_full(&cpu_on_done))
+		cpu_relax();
+
+	for_each_present_cpu(cpu) {
+		if (cpu == 1)
+			continue;
+		if (cpu_on_ret[cpu] != PSCI_RET_SUCCESS && cpu_on_ret[cpu] != PSCI_RET_ALREADY_ON) {
+			report_info("unexpected cpu_on return value: caller=CPU%d, ret=%d", cpu, cpu_on_ret[cpu]);
+			failed = true;
+		}
+	}
+
+	return !failed;
+}
+
+int main(void)
+{
+	int ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
+
+	if (nr_cpus < 2) {
+		report_skip("At least 2 cpus required");
+		goto done;
+	}
+
+	report_info("PSCI version %d.%d", PSCI_VERSION_MAJOR(ver),
+					  PSCI_VERSION_MINOR(ver));
+	report("invalid-function", psci_invalid_function());
+	report("affinity-info-on", psci_affinity_info_on());
+	report("affinity-info-off", psci_affinity_info_off());
+	report("cpu-on", psci_cpu_on_test());
+
+done:
+#if 0
+	report_summary();
+	psci_invoke(PSCI_0_2_FN_SYSTEM_OFF, 0, 0, 0);
+	report("system-off", false);
+	return 1; /* only reaches here if system-off fails */
+#else
+	return report_summary();
+#endif
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 8cf94729d86e..c98658f7488b 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -91,3 +91,9 @@ file = gic.flat
 smp = $MAX_SMP
 extra_params = -machine gic-version=3 -append 'ipi'
 groups = gic
+
+# Test PSCI emulation
+[psci]
+file = psci.flat
+smp = $MAX_SMP
+groups = nodefault,psci
-- 
2.9.3
