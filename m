From: Wei Huang <wei@redhat.com>
Subject: [kvm-unit-tests PATCH v14 3/5] arm: Add PMU test
Date: Tue,  6 Dec 2016 12:05:26 -0600
Message-ID: <1481047528-16180-4-git-send-email-wei@redhat.com>
References: <1481047528-16180-1-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 573114022C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 13:04:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z-FIcJVhfDCV for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2016 13:04:39 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52A13402A3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 13:04:39 -0500 (EST)
In-Reply-To: <1481047528-16180-1-git-send-email-wei@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: cov@codeaurora.org
Cc: alindsay@codeaurora.org, kvm@vger.kernel.org, andre.przywara@arm.com, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, shannon.zhao@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Christopher Covington <cov@codeaurora.org>

Beginning with a simple sanity check of the control register, add
a unit test for the ARM Performance Monitors Unit (PMU).

Signed-off-by: Christopher Covington <cov@codeaurora.org>
Signed-off-by: Wei Huang <wei@redhat.com>
---
 arm/Makefile.common |  3 +-
 arm/pmu.c           | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg   |  5 +++
 3 files changed, 100 insertions(+), 1 deletion(-)
 create mode 100644 arm/pmu.c

diff --git a/arm/Makefile.common b/arm/Makefile.common
index f37b5c2..5da2fdd 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -12,7 +12,8 @@ endif
 tests-common = \
 	$(TEST_DIR)/selftest.flat \
 	$(TEST_DIR)/spinlock-test.flat \
-	$(TEST_DIR)/pci-test.flat
+	$(TEST_DIR)/pci-test.flat \
+	$(TEST_DIR)/pmu.flat
 
 all: test_cases
 
diff --git a/arm/pmu.c b/arm/pmu.c
new file mode 100644
index 0000000..bf6ac69
--- /dev/null
+++ b/arm/pmu.c
@@ -0,0 +1,93 @@
+/*
+ * Test the ARM Performance Monitors Unit (PMU).
+ *
+ * Copyright (c) 2015-2016, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2016, Red Hat Inc, Wei Huang <wei@redhat.com>
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
+#include "asm/barrier.h"
+#include "asm/sysreg.h"
+#include "asm/processor.h"
+
+#define PMU_PMCR_N_SHIFT   11
+#define PMU_PMCR_N_MASK    0x1f
+#define PMU_PMCR_ID_SHIFT  16
+#define PMU_PMCR_ID_MASK   0xff
+#define PMU_PMCR_IMP_SHIFT 24
+#define PMU_PMCR_IMP_MASK  0xff
+
+#define ID_DFR0_PERFMON_SHIFT 24
+#define ID_DFR0_PERFMON_MASK  0xf
+
+static unsigned int pmu_version;
+#if defined(__arm__)
+#define PMCR         __ACCESS_CP15(c9, 0, c12, 0)
+#define ID_DFR0      __ACCESS_CP15(c0, 0, c1, 2)
+
+static inline uint32_t get_id_dfr0(void) { return read_sysreg(ID_DFR0); }
+static inline uint32_t get_pmcr(void) { return read_sysreg(PMCR); }
+#elif defined(__aarch64__)
+static inline uint32_t get_id_dfr0(void) { return read_sysreg(id_dfr0_el1); }
+static inline uint32_t get_pmcr(void) { return read_sysreg(pmcr_el0); }
+#endif
+
+/*
+ * As a simple sanity check on the PMCR_EL0, ensure the implementer field isn't
+ * null. Also print out a couple other interesting fields for diagnostic
+ * purposes. For example, as of fall 2016, QEMU TCG mode doesn't implement
+ * event counters and therefore reports zero event counters, but hopefully
+ * support for at least the instructions event will be added in the future and
+ * the reported number of event counters will become nonzero.
+ */
+static bool check_pmcr(void)
+{
+	uint32_t pmcr;
+
+	pmcr = get_pmcr();
+
+	report_info("PMU implementer/ID code/counters: 0x%x(\"%c\")/0x%x/%d",
+		    (pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK,
+		    ((pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK) ? : ' ',
+		    (pmcr >> PMU_PMCR_ID_SHIFT) & PMU_PMCR_ID_MASK,
+		    (pmcr >> PMU_PMCR_N_SHIFT) & PMU_PMCR_N_MASK);
+
+	return ((pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK) != 0;
+}
+
+/* Return FALSE if no PMU found, otherwise return TRUE */
+bool pmu_probe(void)
+{
+	uint32_t dfr0;
+
+	/* probe pmu version */
+	dfr0 = get_id_dfr0();
+	pmu_version = (dfr0 >> ID_DFR0_PERFMON_SHIFT) & ID_DFR0_PERFMON_MASK;
+
+	if (pmu_version)
+		report_info("PMU version: %d", pmu_version);
+
+	return pmu_version;
+}
+
+int main(void)
+{
+	if (!pmu_probe()) {
+		printf("No PMU found, test skipped...\n");
+		return report_summary();
+	}
+
+	report_prefix_push("pmu");
+
+	report("Control register", check_pmcr());
+
+	return report_summary();
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index ae32a42..816f494 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -58,3 +58,8 @@ groups = selftest
 [pci-test]
 file = pci-test.flat
 groups = pci
+
+# Test PMU support
+[pmu]
+file = pmu.flat
+groups = pmu
-- 
1.8.3.1
