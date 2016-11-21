From: Wei Huang <wei@redhat.com>
Subject: [kvm-unit-tests PATCH v10 1/3] arm: Add PMU test
Date: Mon, 21 Nov 2016 14:24:53 -0600
Message-ID: <1479759895-10042-2-git-send-email-wei@redhat.com>
References: <1479759895-10042-1-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6489F402AF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Nov 2016 15:24:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F89kN2bsjBKh for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Nov 2016 15:24:21 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EBD35404AC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Nov 2016 15:24:20 -0500 (EST)
In-Reply-To: <1479759895-10042-1-git-send-email-wei@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christopher Covington <cov@codeaurora.org>

Beginning with a simple sanity check of the control register, add
a unit test for the ARM Performance Monitors Unit (PMU).

Signed-off-by: Christopher Covington <cov@codeaurora.org>
Signed-off-by: Wei Huang <wei@redhat.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arm/Makefile.common |  3 ++-
 arm/pmu.c           | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg   |  5 ++++
 3 files changed, 81 insertions(+), 1 deletion(-)
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
index 0000000..9d9c53b
--- /dev/null
+++ b/arm/pmu.c
@@ -0,0 +1,74 @@
+/*
+ * Test the ARM Performance Monitors Unit (PMU).
+ *
+ * Copyright (c) 2015-2016, The Linux Foundation. All rights reserved.
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
+
+#define PMU_PMCR_N_SHIFT   11
+#define PMU_PMCR_N_MASK    0x1f
+#define PMU_PMCR_ID_SHIFT  16
+#define PMU_PMCR_ID_MASK   0xff
+#define PMU_PMCR_IMP_SHIFT 24
+#define PMU_PMCR_IMP_MASK  0xff
+
+#if defined(__arm__)
+static inline uint32_t pmcr_read(void)
+{
+	uint32_t ret;
+
+	asm volatile("mrc p15, 0, %0, c9, c12, 0" : "=r" (ret));
+	return ret;
+}
+#elif defined(__aarch64__)
+static inline uint32_t pmcr_read(void)
+{
+	uint32_t ret;
+
+	asm volatile("mrs %0, pmcr_el0" : "=r" (ret));
+	return ret;
+}
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
+	pmcr = pmcr_read();
+
+	printf("PMU implementer:     %c\n",
+	       (pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK);
+	printf("Identification code: 0x%x\n",
+	       (pmcr >> PMU_PMCR_ID_SHIFT) & PMU_PMCR_ID_MASK);
+	printf("Event counters:      %d\n",
+	       (pmcr >> PMU_PMCR_N_SHIFT) & PMU_PMCR_N_MASK);
+
+	return ((pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK) != 0;
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
