From: Christopher Covington <cov@codeaurora.org>
Subject: [kvm-unit-tests PATCHv3 3/3] arm: pmu: Add CPI checking
Date: Tue,  6 Oct 2015 13:49:26 -0400
Message-ID: <1444153766-12532-4-git-send-email-cov@codeaurora.org>
References: <5612EDA5.9010506@redhat.com>
 <1444153766-12532-1-git-send-email-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68D7941278
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Oct 2015 13:48:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GjzmmSoLkhPu for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Oct 2015 13:48:15 -0400 (EDT)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E2BF42CD5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Oct 2015 13:48:15 -0400 (EDT)
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

Check the numbers of cycles per instruction (CPI) implied by ARM PMU
cycle counter values. Check that in -icount mode these strictly
match the specified rate.

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 arm/pmu.c         | 72 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 arm/unittests.cfg | 13 ++++++++++
 2 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 589e605..0ad113d 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -84,12 +84,82 @@ static bool check_cycles_increase(void)
 	return true;
 }
 
-int main(void)
+/* Execute a known number of guest instructions. Only odd instruction counts
+ * greater than or equal to 3 are supported by the in-line assembly code. The
+ * control register (PMCR_EL0) is initialized with the provided value (allowing
+ * for example for the cycle counter or event counters to be reset). At the end
+ * of the exact instruction loop, zero is written to PMCR_EL0 to disable
+ * counting, allowing the cycle counter or event counters to be read at the
+ * leisure of the calling code.
+ */
+static void measure_instrs(int num, struct pmu_data pmcr)
+{
+	int i = (num - 1) / 2;
+
+	if (num < 3 || ((num - 1) % 2))
+		abort();
+
+	asm volatile(
+		"msr pmcr_el0, %[pmcr]\n"
+		"1: subs %[i], %[i], #1\n"
+		"b.gt 1b\n"
+		"msr pmcr_el0, xzr"
+	: [i] "+r" (i) : [pmcr] "r" (pmcr) : "cc");
+}
+
+/* Measure cycle counts for various known instruction counts. Ensure that the
+ * cycle counter progresses (similar to check_cycles_increase() but with more
+ * instructions and using reset and stop controls). If supplied a positive,
+ * nonzero CPI parameter, also strictly check that every measurement matches
+ * it. Strict CPI checking is used to test -icount mode.
+ */
+static bool check_cpi(int cpi)
+{
+	struct pmu_data pmcr;
+
+	pmcr.cycle_counter_reset = 1;
+	pmcr.enable = 1;
+
+	if (cpi > 0)
+		printf("Checking for CPI=%d.\n", cpi);
+	printf("instrs : cycles0 cycles1 ...\n");
+
+	for (int i = 3; i < 300; i += 32) {
+		int avg, sum = 0;
+
+		printf("%d :", i);
+		for (int j = 0; j < samples; j++) {
+			int cycles;
+
+			measure_instrs(i, pmcr);
+			asm volatile("mrs %0, pmccntr_el0" : "=r" (cycles));
+			printf(" %d", cycles);
+
+			if (!cycles || (cpi > 0 && cycles != i * cpi)) {
+				printf("\n");
+				return false;
+			}
+
+			sum += cycles;
+		}
+		avg = sum / samples;
+		printf(" sum=%d avg=%d avg_ipc=%d avg_cpi=%d\n",
+			sum, avg, i / avg, avg / i);
+	}
+
+	return true;
+}
+
+int main(int argc, char *argv[])
 {
 	report_prefix_push("pmu");
 
 	report("Control register", check_pmcr());
 	report("Monotonically increasing cycle count", check_cycles_increase());
 
+	int cpi = (argc == 1 ? atol(argv[0]) : 0);
+
+	report("Cycle/instruction ratio", check_cpi(cpi));
+
 	return report_summary();
 }
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index fd94adb..333ee0d 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -39,4 +39,17 @@ groups = selftest
 # Test PMU support without -icount
 [pmu]
 file = pmu.flat
+extra_params = -append '-1'
+groups = pmu
+
+# Test PMU support with -icount IPC=1
+[pmu-icount-1]
+file = pmu.flat
+extra_params = -icount 0 -append '1'
+groups = pmu
+
+# Test PMU support with -icount IPC=256
+[pmu-icount-256]
+file = pmu.flat
+extra_params = -icount 8 -append '256'
 groups = pmu
-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
