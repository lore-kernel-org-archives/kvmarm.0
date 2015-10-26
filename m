From: Christopher Covington <cov@codeaurora.org>
Subject: [kvm-unit-tests PATCHv5 3/3] arm: pmu: Add CPI checking
Date: Mon, 26 Oct 2015 11:38:50 -0400
Message-ID: <1445873930-9058-4-git-send-email-cov@codeaurora.org>
References: <1444662470-13045-1-git-send-email-cov@codeaurora.org>
 <1445873930-9058-1-git-send-email-cov@codeaurora.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1445873930-9058-1-git-send-email-cov@codeaurora.org>
Sender: kvm-owner@vger.kernel.org
To: drjones@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, wei@redhat.com
Cc: shannon.zhao@linaro.org, alistair.francis@xilinx.com, croberts@codeaurora.org, alindsay@codeaurora.org, Christopher Covington <cov@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

Calculate the numbers of cycles per instruction (CPI) implied by ARM
PMU cycle counter values. The code includes a strict checking facility
intended for the -icount option in TCG mode but it is not yet enabled
in the configuration file. Enabling it must wait on infrastructure
improvements which allow for different tests to be run on TCG versus
KVM.

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 arm/pmu.c | 105 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 104 insertions(+), 1 deletion(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index c44d708..59f26ab 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -43,6 +43,25 @@ static inline unsigned long get_pmccntr(void)
 	asm volatile("mrc p15, 0, %0, c9, c13, 0" : "=r" (cycles));
 	return cycles;
 }
+
+/*
+ * Extra instructions such as `mov rd, #0` inserted by the compiler would be
+ * difficult to compensate for, so hand assemble everything between, and
+ * including, the PMCR accesses to start and stop counting.
+ */
+static inline void loop(int i, uint32_t pmcr)
+{
+	uint32_t z = 0;
+
+	asm volatile(
+	"	mcr p15, 0, %[pmcr], c9, c12, 0\n"
+	"1:	subs %[i], %[i], #1\n"
+	"	bgt 1b\n"
+	"	mcr p15, 0, %[z], c9, c12, 0\n"
+	: [i] "+r" (i)
+	: [pmcr] "r" (pmcr), [z] "r" (z)
+	: "cc");
+}
 #elif defined(__aarch64__)
 static inline uint32_t get_pmcr(void)
 {
@@ -64,6 +83,23 @@ static inline unsigned long get_pmccntr(void)
 	asm volatile("mrs %0, pmccntr_el0" : "=r" (cycles));
 	return cycles;
 }
+
+/*
+ * Extra instructions inserted by the compiler would be difficult to compensate
+ * for, so hand assemble everything between, and including, the PMCR accesses
+ * to start and stop counting.
+ */
+static inline void loop(int i, uint32_t pmcr)
+{
+	asm volatile(
+	"	msr pmcr_el0, %[pmcr]\n"
+	"1:	subs %[i], %[i], #1\n"
+	"	b.gt 1b\n"
+	"	msr pmcr_el0, xzr\n"
+	: [i] "+r" (i)
+	: [pmcr] "r" (pmcr)
+	: "cc");
+}
 #endif
 
 struct pmu_data {
@@ -131,12 +167,79 @@ static bool check_cycles_increase(void)
 	return true;
 }
 
-int main(void)
+/*
+ * Execute a known number of guest instructions. Only odd instruction counts
+ * greater than or equal to 3 are supported by the in-line assembly code. The
+ * control register (PMCR_EL0) is initialized with the provided value (allowing
+ * for example for the cycle counter or event counters to be reset). At the end
+ * of the exact instruction loop, zero is written to PMCR_EL0 to disable
+ * counting, allowing the cycle counter or event counters to be read at the
+ * leisure of the calling code.
+ */
+static void measure_instrs(int num, uint32_t pmcr)
+{
+	int i = (num - 1) / 2;
+
+	assert(num >= 3 && ((num - 1) % 2 == 0));
+	loop(i, pmcr);
+}
+
+/*
+ * Measure cycle counts for various known instruction counts. Ensure that the
+ * cycle counter progresses (similar to check_cycles_increase() but with more
+ * instructions and using reset and stop controls). If supplied a positive,
+ * nonzero CPI parameter, also strictly check that every measurement matches
+ * it. Strict CPI checking is used to test -icount mode.
+ */
+static bool check_cpi(int cpi)
+{
+	struct pmu_data pmu = { {0} };
+
+	pmu.cycle_counter_reset = 1;
+	pmu.enable = 1;
+
+	if (cpi > 0)
+		printf("Checking for CPI=%d.\n", cpi);
+	printf("instrs : cycles0 cycles1 ...\n");
+
+	for (int i = 3; i < 300; i += 32) {
+		int avg, sum = 0;
+
+		printf("%d :", i);
+		for (int j = 0; j < NR_SAMPLES; j++) {
+			int cycles;
+
+			measure_instrs(i, pmu.pmcr_el0);
+			cycles = get_pmccntr();
+			printf(" %d", cycles);
+
+			if (!cycles || (cpi > 0 && cycles != i * cpi)) {
+				printf("\n");
+				return false;
+			}
+
+			sum += cycles;
+		}
+		avg = sum / NR_SAMPLES;
+		printf(" sum=%d avg=%d avg_ipc=%d avg_cpi=%d\n",
+			sum, avg, i / avg, avg / i);
+	}
+
+	return true;
+}
+
+int main(int argc, char *argv[])
 {
+	int cpi = 0;
+
+	if (argc > 1)
+		cpi = atol(argv[0]);
+
 	report_prefix_push("pmu");
 
 	report("Control register", check_pmcr());
 	report("Monotonically increasing cycle count", check_cycles_increase());
+	report("Cycle/instruction ratio", check_cpi(cpi));
 
 	return report_summary();
 }
-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

