From: Wei Huang <wei@redhat.com>
Subject: [kvm-unit-tests PATCHv7 3/3] arm: pmu: Add CPI checking
Date: Wed,  2 Nov 2016 17:22:17 -0500
Message-ID: <1478125337-11770-4-git-send-email-wei@redhat.com>
References: <1478125337-11770-1-git-send-email-wei@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1478125337-11770-1-git-send-email-wei@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: cov@codeaurora.org
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org, alistair.francis@xilinx.com, croberts@codeaurora.org, alindsay@codeaurora.org, drjones@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Calculate the numbers of cycles per instruction (CPI) implied by ARM
PMU cycle counter values.

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 arm/pmu.c | 109 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 108 insertions(+), 1 deletion(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 65b7df1..ca00422 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -62,6 +62,23 @@ static inline void disable_counter(uint32_t idx)
 {
 	asm volatile("mrc p15, 0, %0, c9, c12, 1" : : "r" (1 << idx));
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
+	"	mcr	p15, 0, %[pmcr], c9, c12, 0\n"
+	"1:	subs	%[i], %[i], #1\n"
+	"	bgt	1b\n"
+	"	mcr	p15, 0, %[z], c9, c12, 0\n"
+	: [i] "+r" (i)
+	: [pmcr] "r" (pmcr), [z] "r" (0)
+	: "cc");
+}
 #elif defined(__aarch64__)
 static inline uint32_t get_pmcr(void)
 {
@@ -98,6 +115,23 @@ static inline void disable_counter(uint32_t idx)
 {
 	asm volatile("msr pmcntensclr_el0, %0" : : "r" (1 << idx));
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
+	"	msr	pmcr_el0, %[pmcr]\n"
+	"1:	subs	%[i], %[i], #1\n"
+	"	b.gt	1b\n"
+	"	msr	pmcr_el0, xzr\n"
+	: [i] "+r" (i)
+	: [pmcr] "r" (pmcr)
+	: "cc");
+}
 #endif
 
 struct pmu_data {
@@ -171,12 +205,85 @@ static bool check_cycles_increase(void)
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
+	struct pmu_data pmu = {{0}};
+
+	enable_counter(ARMV8_PMU_CYCLE_IDX);
+	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
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
+	pmu.enable = 0;
+	set_pmcr(pmu.pmcr_el0);
+
+	return true;
+}
+
+int main(int argc, char *argv[])
 {
+	int cpi = 0;
+
+	if (argc >= 1)
+		cpi = atol(argv[0]);
+
 	report_prefix_push("pmu");
 
 	report("Control register", check_pmcr());
 	report("Monotonically increasing cycle count", check_cycles_increase());
+	report("Cycle/instruction ratio", check_cpi(cpi));
 
 	return report_summary();
 }
-- 
1.8.3.1

