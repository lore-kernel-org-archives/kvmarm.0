From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/2] arm64: PMU: Do not use PMSELR_EL0 to access PMCCFILTR_EL0
Date: Fri,  2 Dec 2016 15:50:58 +0000
Message-ID: <1480693859-27249-2-git-send-email-marc.zyngier@arm.com>
References: <1480693859-27249-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C19884080A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2016 10:50:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LzGE2DWi1U8w for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Dec 2016 10:50:29 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4541A40798
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2016 10:50:29 -0500 (EST)
In-Reply-To: <1480693859-27249-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: Itaru Kitayama <itaru.kitayama@riken.jp>, Catalin Marinas <catalin.marinas@arm.com>, Hoan Tran <hotran@apm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Tai Tri Nguyen <ttnguyen@apm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The ARMv8 architecture allows the cycle counter to be configured
by setting PMSELR_EL0.SEL==0x1f and then accessing PMXEVTYPER_EL0,
hence accessing PMCCFILTR_EL0. But it disallows the use of
PMSELR_EL0.SEL==0x1f to access the cycle counter itself through
PMXEVCNTR_EL0.

Linux itself doesn't violate this rule, but we may end up with
PMSELR_EL0.SEL being set to 0x1f when we enter a guest. If that
guest accesses PMXEVCNTR_EL0, the access may UNDEF at EL1,
despite the guest not having done anything wrong.

In order to avoid this unfortunate course of events (haha!), let's
apply the same method armv8pmu_write_counter and co are using,
explicitely checking for the cycle counter and writing to
PMCCFILTR_EL0 directly. This prevents writing 0x1f to PMSELR_EL0,
and saves a Linux guest an extra trap.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kernel/perf_event.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index 57ae9d9..a65b757 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -632,7 +632,10 @@ static inline void armv8pmu_write_counter(struct perf_event *event, u32 value)
 
 static inline void armv8pmu_write_evtype(int idx, u32 val)
 {
-	if (armv8pmu_select_counter(idx) == idx) {
+	if (idx == ARMV8_IDX_CYCLE_COUNTER) {
+		val &= ARMV8_PMU_EVTYPE_MASK & ~ARMV8_PMU_EVTYPE_EVENT;
+		write_sysreg(val, pmccfiltr_el0);
+	} else if (armv8pmu_select_counter(idx) == idx) {
 		val &= ARMV8_PMU_EVTYPE_MASK;
 		write_sysreg(val, pmxevtyper_el0);
 	}
-- 
2.1.4
