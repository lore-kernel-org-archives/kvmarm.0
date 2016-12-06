From: Wei Huang <wei@redhat.com>
Subject: [kvm-unit-tests PATCH v14 5/5] arm: pmu: Add CPI checking
Date: Tue,  6 Dec 2016 12:05:28 -0600
Message-ID: <1481047528-16180-6-git-send-email-wei@redhat.com>
References: <1481047528-16180-1-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64468401E8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 13:04:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pEcfAp9eTutb for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2016 13:04:44 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D7A73405A2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 13:04:43 -0500 (EST)
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

Calculate the numbers of cycles per instruction (CPI) implied by ARM
PMU cycle counter values. The code includes a strict checking facility
intended for the -icount option in TCG mode in the configuration file.

Signed-off-by: Christopher Covington <cov@codeaurora.org>
Signed-off-by: Wei Huang <wei@redhat.com>
---
 arm/pmu.c         | 133 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 arm/unittests.cfg |  14 ++++++
 2 files changed, 146 insertions(+), 1 deletion(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index d9ff19d..a39dae4 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -58,6 +58,14 @@ static inline uint64_t get_pmccntr(void)
 		return read_sysreg(PMCCNTR32);
 }
 
+static inline void set_pmccntr(uint64_t value)
+{
+	if (pmu_version == 0x3)
+		write_sysreg(value, PMCCNTR64);
+	else
+		write_sysreg(value & 0xffffffff, PMCCNTR32);
+}
+
 /* PMCCFILTR is an obsolete name for PMXEVTYPER31 in ARMv7 */
 static inline void set_pmccfiltr(uint32_t value)
 {
@@ -65,13 +73,56 @@ static inline void set_pmccfiltr(uint32_t value)
 	write_sysreg(value, PMXEVTYPER);
 	isb();
 }
+
+/*
+ * Extra instructions inserted by the compiler would be difficult to compensate
+ * for, so hand assemble everything between, and including, the PMCR accesses
+ * to start and stop counting. isb instructions were inserted to make sure
+ * pmccntr read after this function returns the exact instructions executed in
+ * the controlled block. Total instrs = isb + mcr + 2*loop = 2 + 2*loop.
+ */
+static inline void precise_instrs_loop(int loop, uint32_t pmcr)
+{
+	asm volatile(
+	"	mcr	p15, 0, %[pmcr], c9, c12, 0\n"
+	"	isb\n"
+	"1:	subs	%[loop], %[loop], #1\n"
+	"	bgt	1b\n"
+	"	mcr	p15, 0, %[z], c9, c12, 0\n"
+	"	isb\n"
+	: [loop] "+r" (loop)
+	: [pmcr] "r" (pmcr), [z] "r" (0)
+	: "cc");
+}
 #elif defined(__aarch64__)
 static inline uint32_t get_id_dfr0(void) { return read_sysreg(id_dfr0_el1); }
 static inline uint32_t get_pmcr(void) { return read_sysreg(pmcr_el0); }
 static inline void set_pmcr(uint32_t v) { write_sysreg(v, pmcr_el0); }
 static inline uint64_t get_pmccntr(void) { return read_sysreg(pmccntr_el0); }
+static inline void set_pmccntr(uint64_t v) { write_sysreg(v, pmccntr_el0); }
 static inline void set_pmcntenset(uint32_t v) { write_sysreg(v, pmcntenset_el0); }
 static inline void set_pmccfiltr(uint32_t v) { write_sysreg(v, pmccfiltr_el0); }
+
+/*
+ * Extra instructions inserted by the compiler would be difficult to compensate
+ * for, so hand assemble everything between, and including, the PMCR accesses
+ * to start and stop counting. isb instructions are inserted to make sure
+ * pmccntr read after this function returns the exact instructions executed
+ * in the controlled block. Total instrs = isb + msr + 2*loop = 2 + 2*loop.
+ */
+static inline void precise_instrs_loop(int loop, uint32_t pmcr)
+{
+	asm volatile(
+	"	msr	pmcr_el0, %[pmcr]\n"
+	"	isb\n"
+	"1:	subs	%[loop], %[loop], #1\n"
+	"	b.gt	1b\n"
+	"	msr	pmcr_el0, xzr\n"
+	"	isb\n"
+	: [loop] "+r" (loop)
+	: [pmcr] "r" (pmcr)
+	: "cc");
+}
 #endif
 
 /*
@@ -128,6 +179,80 @@ static bool check_cycles_increase(void)
 	return success;
 }
 
+/*
+ * Execute a known number of guest instructions. Only even instruction counts
+ * greater than or equal to 4 are supported by the in-line assembly code. The
+ * control register (PMCR_EL0) is initialized with the provided value (allowing
+ * for example for the cycle counter or event counters to be reset). At the end
+ * of the exact instruction loop, zero is written to PMCR_EL0 to disable
+ * counting, allowing the cycle counter or event counters to be read at the
+ * leisure of the calling code.
+ */
+static void measure_instrs(int num, uint32_t pmcr)
+{
+	int loop = (num - 2) / 2;
+
+	assert(num >= 4 && ((num - 2) % 2 == 0));
+	precise_instrs_loop(loop, pmcr);
+}
+
+/*
+ * Measure cycle counts for various known instruction counts. Ensure that the
+ * cycle counter progresses (similar to check_cycles_increase() but with more
+ * instructions and using reset and stop controls). If supplied a positive,
+ * nonzero CPI parameter, it also strictly checks that every measurement matches
+ * it. Strict CPI checking is used to test -icount mode.
+ */
+static bool check_cpi(int cpi)
+{
+	uint32_t pmcr = get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E;
+
+	/* init before event access, this test only cares about cycle count */
+	set_pmcntenset(1 << PMU_CYCLE_IDX);
+	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
+
+	if (cpi > 0)
+		printf("Checking for CPI=%d.\n", cpi);
+	printf("instrs : cycles0 cycles1 ...\n");
+
+	for (unsigned int i = 4; i < 300; i += 32) {
+		uint64_t avg, sum = 0;
+
+		printf("%4d:", i);
+		for (int j = 0; j < NR_SAMPLES; j++) {
+			uint64_t cycles;
+
+			set_pmccntr(0);
+			measure_instrs(i, pmcr);
+			cycles = get_pmccntr();
+			printf(" %4"PRId64"", cycles);
+
+			if (!cycles) {
+				printf("\ncycles not incrementing!\n");
+				return false;
+			} else if (cpi > 0 && cycles != i * cpi) {
+				printf("\nunexpected cycle count received!\n");
+				return false;
+			} else if ((cycles >> 32) != 0) {
+				/* The cycles taken by the loop above should
+				 * fit in 32 bits easily. We check the upper
+				 * 32 bits of the cycle counter to make sure
+				 * there is no supprise. */
+				printf("\ncycle count bigger than 32bit!\n");
+				return false;
+			}
+
+			sum += cycles;
+		}
+		avg = sum / NR_SAMPLES;
+		printf(" avg=%-4"PRId64" %s=%-3"PRId64"\n", avg,
+		       (avg >= i) ? "cpi" : "ipc",
+		       (avg >= i) ? avg / i : i / avg);
+	}
+
+	return true;
+}
+
 /* Return FALSE if no PMU found, otherwise return TRUE */
 bool pmu_probe(void)
 {
@@ -143,8 +268,13 @@ bool pmu_probe(void)
 	return pmu_version;
 }
 
-int main(void)
+int main(int argc, char *argv[])
 {
+	int cpi = 0;
+
+	if (argc > 1)
+		cpi = atol(argv[1]);
+
 	if (!pmu_probe()) {
 		printf("No PMU found, test skipped...\n");
 		return report_summary();
@@ -154,6 +284,7 @@ int main(void)
 
 	report("Control register", check_pmcr());
 	report("Monotonically increasing cycle count", check_cycles_increase());
+	report("Cycle/instruction ratio", check_cpi(cpi));
 
 	return report_summary();
 }
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 816f494..044d97c 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -63,3 +63,17 @@ groups = pci
 [pmu]
 file = pmu.flat
 groups = pmu
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
