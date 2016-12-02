From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 2/2] arm64: PMU: Reset PMSELR_EL0 to a sane value at boot time
Date: Fri,  2 Dec 2016 15:50:59 +0000
Message-ID: <1480693859-27249-3-git-send-email-marc.zyngier@arm.com>
References: <1480693859-27249-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 12A0F40796
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2016 10:50:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8KcLRNzuONHj for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Dec 2016 10:50:31 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1235740798
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2016 10:50:31 -0500 (EST)
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

In order to avoid any ugly surprise, let's reset PMSELR_EL0 to the
first valid value (avoiding the cycle counter which has been proven
to be troublesome) at CPU boot time. This ensures that no guest will
be faced with some odd value which it cannot modify (due to
MDCR_EL2.TPM being set).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kernel/perf_event.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index a65b757..42d1840 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -910,6 +910,14 @@ static void armv8pmu_reset(void *info)
 	 */
 	armv8pmu_pmcr_write(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C |
 			    ARMV8_PMU_PMCR_LC);
+
+	/*
+	 * If we have at least one available counter, reset to that
+	 * one so that no illegal value is left in PMSELR_EL0, which
+	 * could have an impact on a guest.
+	 */
+	if (armv8pmu_counter_valid(cpu_pmu, ARMV8_IDX_COUNTER0))
+		armv8pmu_select_counter(ARMV8_IDX_COUNTER0);
 }
 
 static int armv8_pmuv3_map_event(struct perf_event *event)
-- 
2.1.4
