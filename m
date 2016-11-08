From: Wei Huang <wei@redhat.com>
Subject: [kvm-unit-tests PATCH v8 2/3] arm: pmu: Check cycle count increases
Date: Tue,  8 Nov 2016 12:17:14 -0600
Message-ID: <1478629035-12938-3-git-send-email-wei@redhat.com>
References: <1478629035-12938-1-git-send-email-wei@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1478629035-12938-1-git-send-email-wei@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: cov@codeaurora.org
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org, alistair.francis@xilinx.com, croberts@codeaurora.org, alindsay@codeaurora.org, drjones@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Christopher Covington <cov@codeaurora.org>

Ensure that reads of the PMCCNTR_EL0 are monotonically increasing,
even for the smallest delta of two subsequent reads.

Signed-off-by: Christopher Covington <cov@codeaurora.org>
Signed-off-by: Wei Huang <wei@redhat.com>
---
 arm/pmu.c | 98 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index 0b29088..d5e3ac3 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -14,6 +14,7 @@
  */
 #include "libcflat.h"
 
+#define PMU_PMCR_E         (1 << 0)
 #define PMU_PMCR_N_SHIFT   11
 #define PMU_PMCR_N_MASK    0x1f
 #define PMU_PMCR_ID_SHIFT  16
@@ -21,6 +22,10 @@
 #define PMU_PMCR_IMP_SHIFT 24
 #define PMU_PMCR_IMP_MASK  0xff
 
+#define PMU_CYCLE_IDX      31
+
+#define NR_SAMPLES 10
+
 #if defined(__arm__)
 static inline uint32_t pmcr_read(void)
 {
@@ -29,6 +34,47 @@ static inline uint32_t pmcr_read(void)
 	asm volatile("mrc p15, 0, %0, c9, c12, 0" : "=r" (ret));
 	return ret;
 }
+
+static inline void pmcr_write(uint32_t value)
+{
+	asm volatile("mcr p15, 0, %0, c9, c12, 0" : : "r" (value));
+}
+
+static inline void pmselr_write(uint32_t value)
+{
+	asm volatile("mcr p15, 0, %0, c9, c12, 5" : : "r" (value));
+}
+
+static inline void pmxevtyper_write(uint32_t value)
+{
+	asm volatile("mcr p15, 0, %0, c9, c13, 1" : : "r" (value));
+}
+
+/*
+ * While PMCCNTR can be accessed as a 64 bit coprocessor register, returning 64
+ * bits doesn't seem worth the trouble when differential usage of the result is
+ * expected (with differences that can easily fit in 32 bits). So just return
+ * the lower 32 bits of the cycle count in AArch32.
+ */
+static inline uint32_t pmccntr_read(void)
+{
+	uint32_t cycles;
+
+	asm volatile("mrc p15, 0, %0, c9, c13, 0" : "=r" (cycles));
+	return cycles;
+}
+
+static inline void pmcntenset_write(uint32_t value)
+{
+	asm volatile("mcr p15, 0, %0, c9, c12, 1" : : "r" (value));
+}
+
+/* PMCCFILTR is an obsolete name for PMXEVTYPER31 in ARMv7 */
+static inline void pmccfiltr_write(uint32_t value)
+{
+	pmselr_write(PMU_CYCLE_IDX);
+	pmxevtyper_write(value);
+}
 #elif defined(__aarch64__)
 static inline uint32_t pmcr_read(void)
 {
@@ -37,6 +83,29 @@ static inline uint32_t pmcr_read(void)
 	asm volatile("mrs %0, pmcr_el0" : "=r" (ret));
 	return ret;
 }
+
+static inline void pmcr_write(uint32_t value)
+{
+	asm volatile("msr pmcr_el0, %0" : : "r" (value));
+}
+
+static inline uint32_t pmccntr_read(void)
+{
+	uint32_t cycles;
+
+	asm volatile("mrs %0, pmccntr_el0" : "=r" (cycles));
+	return cycles;
+}
+
+static inline void pmcntenset_write(uint32_t value)
+{
+	asm volatile("msr pmcntenset_el0, %0" : : "r" (value));
+}
+
+static inline void pmccfiltr_write(uint32_t value)
+{
+	asm volatile("msr pmccfiltr_el0, %0" : : "r" (value));
+}
 #endif
 
 /*
@@ -63,11 +132,40 @@ static bool check_pmcr(void)
 	return ((pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK) != 0;
 }
 
+/*
+ * Ensure that the cycle counter progresses between back-to-back reads.
+ */
+static bool check_cycles_increase(void)
+{
+	pmcr_write(pmcr_read() | PMU_PMCR_E);
+
+	for (int i = 0; i < NR_SAMPLES; i++) {
+		unsigned long a, b;
+
+		a = pmccntr_read();
+		b = pmccntr_read();
+
+		if (a >= b) {
+			printf("Read %ld then %ld.\n", a, b);
+			return false;
+		}
+	}
+
+	pmcr_write(pmcr_read() & ~PMU_PMCR_E);
+
+	return true;
+}
+
 int main(void)
 {
 	report_prefix_push("pmu");
 
+	/* init for PMU event access, right now only care about cycle count */
+	pmcntenset_write(1 << PMU_CYCLE_IDX);
+	pmccfiltr_write(0); /* count cycles in EL0, EL1, but not EL2 */
+
 	report("Control register", check_pmcr());
+	report("Monotonically increasing cycle count", check_cycles_increase());
 
 	return report_summary();
 }
-- 
1.8.3.1

