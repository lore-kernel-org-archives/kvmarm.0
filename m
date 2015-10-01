From: Christopher Covington <cov@codeaurora.org>
Subject: [PATCH] arm: Add PMU test
Date: Thu,  1 Oct 2015 15:47:21 -0400
Message-ID: <1443728841-10501-1-git-send-email-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AED32412F2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Oct 2015 15:45:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PMWO95O06lha for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Oct 2015 15:45:53 -0400 (EDT)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E578241252
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Oct 2015 15:45:52 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: drjones@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Beginning with just a read of the control register, add plumbing
for testing the ARM Performance Monitors Unit (PMU).

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 arm/pmu.c                    | 31 +++++++++++++++++++++++++++++++
 arm/unittests.cfg            |  5 +++++
 config/config-arm-common.mak |  4 +++-
 3 files changed, 39 insertions(+), 1 deletion(-)
 create mode 100644 arm/pmu.c

diff --git a/arm/pmu.c b/arm/pmu.c
new file mode 100644
index 0000000..b1e3c7a
--- /dev/null
+++ b/arm/pmu.c
@@ -0,0 +1,31 @@
+#include "libcflat.h"
+
+union pmcr_el0 {
+	struct {
+		unsigned int implementor:8;
+		unsigned int identification_code:8;
+		unsigned int num_counters:5;
+		unsigned int zeros:4;
+		unsigned int cycle_counter_long:1;
+		unsigned int cycle_counter_disable_when_prohibited:1;
+		unsigned int event_counter_export:1;
+		unsigned int cycle_counter_clock_divider:1;
+		unsigned int cycle_counter_reset:1;
+		unsigned int event_counter_reset:1;
+		unsigned int enable:1;
+	} split;
+	uint32_t full;
+};
+
+int main()
+{
+	union pmcr_el0 pmcr;
+
+	asm volatile("mrs %0, pmcr_el0\n" : "=r" (pmcr));
+
+	printf("PMU implementor:     0x%x\n", pmcr.split.implementor);
+	printf("Identification code: 0x%x\n", pmcr.split.identification_code);
+	printf("Event counters:      %d\n", pmcr.split.num_counters);
+
+	return report_summary();
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index e068a0c..d3deb6a 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -35,3 +35,8 @@ file = selftest.flat
 smp = `getconf _NPROCESSORS_CONF`
 extra_params = -append 'smp'
 groups = selftest
+
+# Test PMU support
+[pmu]
+file = pmu.flat
+groups = pmu
diff --git a/config/config-arm-common.mak b/config/config-arm-common.mak
index 698555d..b34d04c 100644
--- a/config/config-arm-common.mak
+++ b/config/config-arm-common.mak
@@ -11,7 +11,8 @@ endif
 
 tests-common = \
 	$(TEST_DIR)/selftest.flat \
-	$(TEST_DIR)/spinlock-test.flat
+	$(TEST_DIR)/spinlock-test.flat \
+	$(TEST_DIR)/pmu.flat
 
 all: test_cases
 
@@ -70,3 +71,4 @@ test_cases: $(generated_files) $(tests-common) $(tests)
 
 $(TEST_DIR)/selftest.elf: $(cstart.o) $(TEST_DIR)/selftest.o
 $(TEST_DIR)/spinlock-test.elf: $(cstart.o) $(TEST_DIR)/spinlock-test.o
+$(TEST_DIR)/pmu.elf: $(cstart.o) $(TEST_DIR)/pmu.o
-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
