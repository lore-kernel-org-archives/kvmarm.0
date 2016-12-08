From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH kvm-unit-tests v2 1/2] arm/pmu: fix probe on AArch64
Date: Thu,  8 Dec 2016 18:05:48 +0100
Message-ID: <20161208170549.8793-2-drjones@redhat.com>
References: <20161208170549.8793-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB9F24044D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2016 12:04:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ETJNV36yxGvU for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2016 12:04:54 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 041254044B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2016 12:04:54 -0500 (EST)
In-Reply-To: <20161208170549.8793-1-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

The spec for ID_DFR0_EL1 says "In an AArch64-only implementation,
this register is UNKNOWN." Indeed ThunderX just returns zero when
that register is read. This means we can't rely on a non-zero
value to determine if we can test the PMU. For AArch64 we need to
read ID_AA64DFR0_EL1. This patch has the side effect of no longer
running PMU tests on TCG for AArch64. That's actually another fix,
though, as TCG chooses not to implement a PMU for AArch64 at this
time. The only way it worked before was probing the wrong register
and proceeding even though the version was 2, which is not a valid
version for AArch64. When TCG eventually implements a PMU things
should "just work".

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/pmu.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index a39dae43c99e..c4d5c97dbf87 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -28,15 +28,15 @@
 #define PMU_PMCR_IMP_SHIFT 24
 #define PMU_PMCR_IMP_MASK  0xff
 
-#define ID_DFR0_PERFMON_SHIFT 24
-#define ID_DFR0_PERFMON_MASK  0xf
-
-#define PMU_CYCLE_IDX         31
+#define PMU_CYCLE_IDX      31
 
 #define NR_SAMPLES 10
 
 static unsigned int pmu_version;
 #if defined(__arm__)
+#define ID_DFR0_PERFMON_SHIFT 24
+#define ID_DFR0_PERFMON_MASK  0xf
+
 #define PMCR         __ACCESS_CP15(c9, 0, c12, 0)
 #define ID_DFR0      __ACCESS_CP15(c0, 0, c1, 2)
 #define PMSELR       __ACCESS_CP15(c9, 0, c12, 5)
@@ -50,6 +50,11 @@ static inline uint32_t get_pmcr(void) { return read_sysreg(PMCR); }
 static inline void set_pmcr(uint32_t v) { write_sysreg(v, PMCR); }
 static inline void set_pmcntenset(uint32_t v) { write_sysreg(v, PMCNTENSET); }
 
+static inline uint8_t get_pmu_version(void)
+{
+	return (get_id_dfr0() >> ID_DFR0_PERFMON_SHIFT) & ID_DFR0_PERFMON_MASK;
+}
+
 static inline uint64_t get_pmccntr(void)
 {
 	if (pmu_version == 0x3)
@@ -95,7 +100,10 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
 	: "cc");
 }
 #elif defined(__aarch64__)
-static inline uint32_t get_id_dfr0(void) { return read_sysreg(id_dfr0_el1); }
+#define ID_AA64DFR0_PERFMON_SHIFT 8
+#define ID_AA64DFR0_PERFMON_MASK  0xf
+
+static inline uint32_t get_id_aa64dfr0(void) { return read_sysreg(id_aa64dfr0_el1); }
 static inline uint32_t get_pmcr(void) { return read_sysreg(pmcr_el0); }
 static inline void set_pmcr(uint32_t v) { write_sysreg(v, pmcr_el0); }
 static inline uint64_t get_pmccntr(void) { return read_sysreg(pmccntr_el0); }
@@ -103,6 +111,12 @@ static inline void set_pmccntr(uint64_t v) { write_sysreg(v, pmccntr_el0); }
 static inline void set_pmcntenset(uint32_t v) { write_sysreg(v, pmcntenset_el0); }
 static inline void set_pmccfiltr(uint32_t v) { write_sysreg(v, pmccfiltr_el0); }
 
+static inline uint8_t get_pmu_version(void)
+{
+	uint8_t ver = (get_id_aa64dfr0() >> ID_AA64DFR0_PERFMON_SHIFT) & ID_AA64DFR0_PERFMON_MASK;
+	return ver == 1 ? 3 : ver;
+}
+
 /*
  * Extra instructions inserted by the compiler would be difficult to compensate
  * for, so hand assemble everything between, and including, the PMCR accesses
@@ -256,16 +270,9 @@ static bool check_cpi(int cpi)
 /* Return FALSE if no PMU found, otherwise return TRUE */
 bool pmu_probe(void)
 {
-	uint32_t dfr0;
-
-	/* probe pmu version */
-	dfr0 = get_id_dfr0();
-	pmu_version = (dfr0 >> ID_DFR0_PERFMON_SHIFT) & ID_DFR0_PERFMON_MASK;
-
-	if (pmu_version)
-		report_info("PMU version: %d", pmu_version);
-
-	return pmu_version;
+	pmu_version = get_pmu_version();
+	report_info("PMU version: %d", pmu_version);
+	return pmu_version != 0 && pmu_version != 0xf;
 }
 
 int main(int argc, char *argv[])
-- 
2.9.3
