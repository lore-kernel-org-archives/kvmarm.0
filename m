From: Christopher Covington <cov@codeaurora.org>
Subject: [kvm-unit-tests PATCHv4 2/3] arm: pmu: Check cycle count increases
Date: Mon, 12 Oct 2015 11:07:49 -0400
Message-ID: <1444662470-13045-3-git-send-email-cov@codeaurora.org>
References: <5612EDA5.9010506@redhat.com>
 <1444662470-13045-1-git-send-email-cov@codeaurora.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1444662470-13045-1-git-send-email-cov@codeaurora.org>
Sender: kvm-owner@vger.kernel.org
To: drjones@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, wei@redhat.com
Cc: shannon.zhao@linaro.org, alistair.francis@xilinx.com, croberts@codeaurora.org, alindsay@codeaurora.org, Christopher Covington <cov@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

Ensure that reads of the PMCCNTR_EL0 are monotonically increasing,
even for the smallest delta of two subsequent reads.

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 arm/pmu.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index 42d0ee1..ae81970 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -14,6 +14,8 @@
  */
 #include "libcflat.h"
 
+#define NR_SAMPLES 10
+
 #if defined(__arm__)
 static inline uint32_t get_pmcr(void)
 {
@@ -22,6 +24,19 @@ static inline uint32_t get_pmcr(void)
 	asm volatile("mrc p15, 0, %0, c9, c12, 0" : "=r" (ret));
 	return ret;
 }
+
+static inline void set_pmcr(uint32_t pmcr)
+{
+	asm volatile("mcr p15, 0, %0, c9, c12, 0" : : "r" (pmcr));
+}
+
+static inline unsigned long get_pmccntr(void)
+{
+	unsigned long cycles;
+
+	asm volatile("mrc p15, 0, %0, c9, c13, 0" : "=r" (cycles));
+	return cycles;
+}
 #elif defined(__aarch64__)
 static inline uint32_t get_pmcr(void)
 {
@@ -30,6 +45,19 @@ static inline uint32_t get_pmcr(void)
 	asm volatile("mrs %0, pmcr_el0" : "=r" (ret));
 	return ret;
 }
+
+static inline void set_pmcr(uint32_t pmcr)
+{
+	asm volatile("msr pmcr_el0, %0" : : "r" (pmcr));
+}
+
+static inline unsigned long get_pmccntr(void)
+{
+	unsigned long cycles;
+
+	asm volatile("mrs %0, pmccntr_el0" : "=r" (cycles));
+	return cycles;
+}
 #endif
 
 struct pmu_data {
@@ -72,11 +100,37 @@ static bool check_pmcr(void)
 	return pmu.implementer != 0;
 }
 
+/*
+ * Ensure that the cycle counter progresses between back-to-back reads.
+ */
+static bool check_cycles_increase(void)
+{
+	struct pmu_data pmu;
+
+	pmu.enable = 1;
+	set_pmcr(pmu.pmcr_el0);
+
+	for (int i = 0; i < NR_SAMPLES; i++) {
+		unsigned long a, b;
+
+		a = get_pmccntr();
+		b = get_pmccntr();
+
+		if (a >= b) {
+			printf("Read %ld then %ld.\n", a, b);
+			return false;
+		}
+	}
+
+	return true;
+}
+
 int main(void)
 {
 	report_prefix_push("pmu");
 
 	report("Control register", check_pmcr());
+	report("Monotonically increasing cycle count", check_cycles_increase());
 
 	return report_summary();
 }
-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

