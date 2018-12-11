From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v7 1/5] arm64: arm_pmu: remove unnecessary isb instruction
Date: Tue, 11 Dec 2018 12:13:36 +0000
Message-ID: <1544530420-1477-2-git-send-email-andrew.murray@arm.com>
References: <1544530420-1477-1-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 799794A33B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 07:14:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 48gS39vbm7Ao for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 07:14:07 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 759EB4A322
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 07:14:07 -0500 (EST)
In-Reply-To: <1544530420-1477-1-git-send-email-andrew.murray@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The armv8pmu_enable_event_counter function issues an isb instruction
after enabling a pair of counters - this doesn't provide any value
and is inconsistent with the armv8pmu_disable_event_counter.

In any case armv8pmu_enable_event_counter is always called with the
PMU stopped. Starting the PMU with armv8pmu_start results in an isb
instruction being issued prior to writing to PMCR_EL0.

Let's remove the unnecessary isb instruction.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm64/kernel/perf_event.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index 8e38d52..de564ae 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -652,7 +652,6 @@ static inline void armv8pmu_enable_event_counter(struct perf_event *event)
 	armv8pmu_enable_counter(idx);
 	if (armv8pmu_event_is_chained(event))
 		armv8pmu_enable_counter(idx - 1);
-	isb();
 }
 
 static inline int armv8pmu_disable_counter(int idx)
-- 
2.7.4
