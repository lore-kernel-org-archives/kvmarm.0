From: Christopher Covington <cov@codeaurora.org>
Subject: [kvm-unit-tests PATCHv3 1/3] arm: Add PMU test
Date: Tue,  6 Oct 2015 13:49:24 -0400
Message-ID: <1444153766-12532-2-git-send-email-cov@codeaurora.org>
References: <5612EDA5.9010506@redhat.com>
 <1444153766-12532-1-git-send-email-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA4D94169C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Oct 2015 13:48:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Kays7cy2YrS4 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Oct 2015 13:48:07 -0400 (EDT)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF81841390
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Oct 2015 13:48:06 -0400 (EDT)
In-Reply-To: <1444153766-12532-1-git-send-email-cov@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: drjones@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, wei@redhat.com
Cc: alindsay@codeaurora.org, croberts@codeaurora.org, shannon.zhao@linaro.org, alistair.francis@xilinx.com
List-Id: kvmarm@lists.cs.columbia.edu

Beginning with a simple sanity check of the control register, add
a unit test for the ARM Performance Monitors Unit (PMU).

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 arm/pmu.c               | 66 +++++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg       |  5 ++++
 config/config-arm64.mak |  4 ++-
 3 files changed, 74 insertions(+), 1 deletion(-)
 create mode 100644 arm/pmu.c

diff --git a/arm/pmu.c b/arm/pmu.c
new file mode 100644
index 0000000..91a3688
--- /dev/null
+++ b/arm/pmu.c
@@ -0,0 +1,66 @@
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
+			uint32_t zeros:4;
+			uint32_t num_counters:5;
+			uint32_t identification_code:8;
+			uint32_t implementer:8;
+		};
+	};
+};
+
+/* As a simple sanity check on the PMCR_EL0, ensure the implementer field isn't
+ * null. Also print out a couple other interesting fields for diagnostic
+ * purposes. For example, as of fall 2015, QEMU TCG mode doesn't implement
+ * event counters and therefore reports zero of them, but hopefully support for
+ * at least the instructions event will be added in the future and the reported
+ * number of event counters will become nonzero.
+ */
+static bool check_pmcr(void)
+{
+	struct pmu_data pmcr;
+
+	asm volatile("mrs %0, pmcr_el0" : "=r" (pmcr));
+
+	printf("PMU implementer:     %c\n", pmcr.implementer);
+	printf("Identification code: 0x%x\n", pmcr.identification_code);
+	printf("Event counters:      %d\n", pmcr.num_counters);
+
+	if (pmcr.implementer)
+		return true;
+
+	return false;
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
index e068a0c..fd94adb 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -35,3 +35,8 @@ file = selftest.flat
 smp = `getconf _NPROCESSORS_CONF`
 extra_params = -append 'smp'
 groups = selftest
+
+# Test PMU support without -icount
+[pmu]
+file = pmu.flat
+groups = pmu
diff --git a/config/config-arm64.mak b/config/config-arm64.mak
index d61b703..140b611 100644
--- a/config/config-arm64.mak
+++ b/config/config-arm64.mak
@@ -12,9 +12,11 @@ cflatobjs += lib/arm64/processor.o
 cflatobjs += lib/arm64/spinlock.o
 
 # arm64 specific tests
-tests =
+tests = $(TEST_DIR)/pmu.flat
 
 include config/config-arm-common.mak
 
 arch_clean: arm_clean
 	$(RM) lib/arm64/.*.d
+
+$(TEST_DIR)/pmu.elf: $(cstart.o) $(TEST_DIR)/pmu.o
-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
