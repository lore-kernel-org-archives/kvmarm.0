From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v3 5/6] arm64: perf: extract chain helper into header
Date: Mon, 18 Feb 2019 13:48:03 +0000
Message-ID: <1550497684-26046-6-git-send-email-andrew.murray@arm.com>
References: <1550497684-26046-1-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 226824A426
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 08:49:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VNqsUWth629X for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Feb 2019 08:49:02 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 147744A3EF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 08:49:02 -0500 (EST)
In-Reply-To: <1550497684-26046-1-git-send-email-andrew.murray@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The ARMv8 Performance Monitors Extension includes an architectural
event type named CHAIN which allows for chaining counters together.

Let's extract the test for this event into a header file such that
other users, such as KVM (for PMU emulation) can make use of.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 arch/arm64/include/asm/perf_event.h | 5 +++++
 arch/arm64/kernel/perf_event.c      | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/perf_event.h b/arch/arm64/include/asm/perf_event.h
index c593761..cd13f3f 100644
--- a/arch/arm64/include/asm/perf_event.h
+++ b/arch/arm64/include/asm/perf_event.h
@@ -219,6 +219,11 @@
 #define ARMV8_PMU_USERENR_CR	(1 << 2) /* Cycle counter can be read at EL0 */
 #define ARMV8_PMU_USERENR_ER	(1 << 3) /* Event counter can be read at EL0 */
 
+static inline bool armv8pmu_evtype_is_chain(u64 evtype)
+{
+	return (evtype == ARMV8_PMUV3_PERFCTR_CHAIN);
+}
+
 #ifdef CONFIG_PERF_EVENTS
 struct pt_regs;
 extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index 1620a37..4cd1f7a 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -850,7 +850,7 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
 static int armv8pmu_filter_match(struct perf_event *event)
 {
 	unsigned long evtype = event->hw.config_base & ARMV8_PMU_EVTYPE_EVENT;
-	return evtype != ARMV8_PMUV3_PERFCTR_CHAIN;
+	return !armv8pmu_evtype_is_chain(evtype);
 }
 
 static void armv8pmu_reset(void *info)
-- 
2.7.4
