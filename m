From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH] arm/pmu: fix probe on AArch64-only machines
Date: Thu,  8 Dec 2016 16:23:15 +0100
Message-ID: <20161208152315.28752-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E54F4028D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2016 10:22:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x4mB3Zh2+Yyq for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2016 10:22:19 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E8E84022C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2016 10:22:18 -0500 (EST)
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
that register is read. That means we can't rely on a non-zero
value to determine if we can test the PMU. As the pmu-version is
only needed by ARM/AArch32, then if we're running AArch64 code,
we can return true from pmu_probe() even when pmu-version is zero.

Signed-off-by: Andrew Jones <drjones@redhat.com>

---
Applies on top of not-yet-merged
https://lists.gnu.org/archive/html/qemu-devel/2016-12/msg00811.html
---
 arm/pmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index a39dae43c99e..a0597c5b7806 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -37,6 +37,7 @@
 
 static unsigned int pmu_version;
 #if defined(__arm__)
+#define is_aarch64() (false)
 #define PMCR         __ACCESS_CP15(c9, 0, c12, 0)
 #define ID_DFR0      __ACCESS_CP15(c0, 0, c1, 2)
 #define PMSELR       __ACCESS_CP15(c9, 0, c12, 5)
@@ -95,6 +96,7 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
 	: "cc");
 }
 #elif defined(__aarch64__)
+#define is_aarch64() (true)
 static inline uint32_t get_id_dfr0(void) { return read_sysreg(id_dfr0_el1); }
 static inline uint32_t get_pmcr(void) { return read_sysreg(pmcr_el0); }
 static inline void set_pmcr(uint32_t v) { write_sysreg(v, pmcr_el0); }
@@ -265,7 +267,7 @@ bool pmu_probe(void)
 	if (pmu_version)
 		report_info("PMU version: %d", pmu_version);
 
-	return pmu_version;
+	return pmu_version || is_aarch64();
 }
 
 int main(int argc, char *argv[])
-- 
2.9.3
