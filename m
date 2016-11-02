From: Wei Huang <wei@redhat.com>
Subject: [kvm-unit-tests PATCHv7 1/3] arm: Add PMU test
Date: Wed,  2 Nov 2016 17:22:15 -0500
Message-ID: <1478125337-11770-2-git-send-email-wei@redhat.com>
References: <1478125337-11770-1-git-send-email-wei@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1478125337-11770-1-git-send-email-wei@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: cov@codeaurora.org
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org, alistair.francis@xilinx.com, croberts@codeaurora.org, alindsay@codeaurora.org, drjones@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Beginning with a simple sanity check of the control register, add
a unit test for the ARM Performance Monitors Unit (PMU).

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 arm/Makefile.common |  3 +-
 arm/pmu.c           | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg   | 20 +++++++++++++
 3 files changed, 104 insertions(+), 1 deletion(-)
 create mode 100644 arm/pmu.c

diff --git a/arm/Makefile.common b/arm/Makefile.common
index ccb554d..f98f422 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -11,7 +11,8 @@ endif
 
 tests-common = \
 	$(TEST_DIR)/selftest.flat \
-	$(TEST_DIR)/spinlock-test.flat
+	$(TEST_DIR)/spinlock-test.flat \
+	$(TEST_DIR)/pmu.flat
 
 all: test_cases
 
diff --git a/arm/pmu.c b/arm/pmu.c
new file mode 100644
index 0000000..42d0ee1
--- /dev/null
+++ b/arm/pmu.c
@@ -0,0 +1,82 @@
+/*
+ * Test the ARM Performance Monitors Unit (PMU).
+ *
+ * Copyright 2015 The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU Lesser General Public License version 2.1 and
+ * only version 2.1 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
+ * for more details.
+ */
+#include "libcflat.h"
+
+#if defined(__arm__)
+static inline uint32_t get_pmcr(void)
+{
+	uint32_t ret;
+
+	asm volatile("mrc p15, 0, %0, c9, c12, 0" : "=r" (ret));
+	return ret;
+}
+#elif defined(__aarch64__)
+static inline uint32_t get_pmcr(void)
+{
+	uint32_t ret;
+
+	asm volatile("mrs %0, pmcr_el0" : "=r" (ret));
+	return ret;
+}
+#endif
+
+struct pmu_data {
+	union {
+		uint32_t pmcr_el0;
+		struct {
+			uint32_t enable:1;
+			uint32_t event_counter_reset:1;
+			uint32_t cycle_counter_reset:1;
+			uint32_t cycle_counter_clock_divider:1;
+			uint32_t event_counter_export:1;
+			uint32_t cycle_counter_disable_when_prohibited:1;
+			uint32_t cycle_counter_long:1;
+			uint32_t reserved:4;
+			uint32_t counters:5;
+			uint32_t identification_code:8;
+			uint32_t implementer:8;
+		};
+	};
+};
+
+/*
+ * As a simple sanity check on the PMCR_EL0, ensure the implementer field isn't
+ * null. Also print out a couple other interesting fields for diagnostic
+ * purposes. For example, as of fall 2015, QEMU TCG mode doesn't implement
+ * event counters and therefore reports zero event counters, but hopefully
+ * support for at least the instructions event will be added in the future and
+ * the reported number of event counters will become nonzero.
+ */
+static bool check_pmcr(void)
+{
+	struct pmu_data pmu;
+
+	pmu.pmcr_el0 = get_pmcr();
+
+	printf("PMU implementer:     %c\n", pmu.implementer);
+	printf("Identification code: 0x%x\n", pmu.identification_code);
+	printf("Event counters:      %d\n", pmu.counters);
+
+	return pmu.implementer != 0;
+}
+
+int main(void)
+{
+	report_prefix_push("pmu");
+
+	report("Control register", check_pmcr());
+
+	return report_summary();
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 3f6fa45..b647b69 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -54,3 +54,23 @@ file = selftest.flat
 smp = $MAX_SMP
 extra_params = -append 'smp'
 groups = selftest
+
+# Test PMU support (KVM)
+[pmu-kvm]
+file = pmu.flat
+groups = pmu
+accel = kvm
+
+# Test PMU support (TCG) with -icount IPC=1
+[pmu-tcg-icount-1]
+file = pmu.flat
+extra_params = -icount 0 -append '1'
+groups = pmu
+accel = tcg
+
+# Test PMU support (TCG) with -icount IPC=256
+[pmu-tcg-icount-256]
+file = pmu.flat
+extra_params = -icount 8 -append '256'
+groups = pmu
+accel = tcg
-- 
1.8.3.1

