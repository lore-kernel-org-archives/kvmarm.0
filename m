From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v7 4/5] arm64: arm_pmu: Add support for
 exclude_host/exclude_guest attributes
Date: Tue, 11 Dec 2018 12:13:39 +0000
Message-ID: <1544530420-1477-5-git-send-email-andrew.murray@arm.com>
References: <1544530420-1477-1-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85C854A384
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 07:14:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QSIRHR8ieF88 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 07:14:14 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 293BF4A361
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 07:14:14 -0500 (EST)
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

Add support for the :G and :H attributes in perf by handling the
exclude_host/exclude_guest event attributes.

We notify KVM of counters that we wish to be enabled or disabled on
guest entry/exit and thus defer from starting or stopping :G events
as per the events exclude_host attribute.

With both VHE and non-VHE we switch the counters between host/guest
at EL2. We are able to eliminate counters counting host events on
the boundaries of guest entry/exit when using :G by filtering out
EL2 for exclude_host. However when using :H unless exclude_hv is set
on non-VHE then there is a small blackout window at the guest
entry/exit where host events are not captured.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 arch/arm64/kernel/perf_event.c | 51 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 44 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index de564ae..4a3c73d 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -26,6 +26,7 @@
 
 #include <linux/acpi.h>
 #include <linux/clocksource.h>
+#include <linux/kvm_host.h>
 #include <linux/of.h>
 #include <linux/perf/arm_pmu.h>
 #include <linux/platform_device.h>
@@ -647,11 +648,26 @@ static inline int armv8pmu_enable_counter(int idx)
 
 static inline void armv8pmu_enable_event_counter(struct perf_event *event)
 {
+	struct perf_event_attr *attr = &event->attr;
 	int idx = event->hw.idx;
+	int flags = 0;
+	u32 counter_bits = BIT(ARMV8_IDX_TO_COUNTER(idx));
 
-	armv8pmu_enable_counter(idx);
 	if (armv8pmu_event_is_chained(event))
-		armv8pmu_enable_counter(idx - 1);
+		counter_bits |= BIT(ARMV8_IDX_TO_COUNTER(idx - 1));
+
+	if (!attr->exclude_host)
+		flags |= KVM_PMU_EVENTS_HOST;
+	if (!attr->exclude_guest)
+		flags |= KVM_PMU_EVENTS_GUEST;
+
+	kvm_set_pmu_events(counter_bits, flags);
+
+	if (!attr->exclude_host) {
+		armv8pmu_enable_counter(idx);
+		if (armv8pmu_event_is_chained(event))
+			armv8pmu_enable_counter(idx - 1);
+	}
 }
 
 static inline int armv8pmu_disable_counter(int idx)
@@ -664,11 +680,20 @@ static inline int armv8pmu_disable_counter(int idx)
 static inline void armv8pmu_disable_event_counter(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
+	struct perf_event_attr *attr = &event->attr;
 	int idx = hwc->idx;
+	u32 counter_bits = BIT(ARMV8_IDX_TO_COUNTER(idx));
 
 	if (armv8pmu_event_is_chained(event))
-		armv8pmu_disable_counter(idx - 1);
-	armv8pmu_disable_counter(idx);
+		counter_bits |= BIT(ARMV8_IDX_TO_COUNTER(idx - 1));
+
+	kvm_clr_pmu_events(counter_bits);
+
+	if (!attr->exclude_host) {
+		if (armv8pmu_event_is_chained(event))
+			armv8pmu_disable_counter(idx - 1);
+		armv8pmu_disable_counter(idx);
+	}
 }
 
 static inline int armv8pmu_enable_intens(int idx)
@@ -943,16 +968,25 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
 	 * Therefore we ignore exclude_hv in this configuration, since
 	 * there's no hypervisor to sample anyway. This is consistent
 	 * with other architectures (x86 and Power).
+	 *
+	 * To eliminate counting host events on the boundaries of
+	 * guest entry/exit we ensure EL2 is not included in hyp mode
+	 * with !exclude_host.
 	 */
 	if (is_kernel_in_hyp_mode()) {
-		if (!attr->exclude_kernel)
+		if (!attr->exclude_kernel && !attr->exclude_host)
 			config_base |= ARMV8_PMU_INCLUDE_EL2;
 	} else {
-		if (attr->exclude_kernel)
-			config_base |= ARMV8_PMU_EXCLUDE_EL1;
 		if (!attr->exclude_hv)
 			config_base |= ARMV8_PMU_INCLUDE_EL2;
 	}
+
+	/*
+	 * Filter out !VHE kernels and guest kernels
+	 */
+	if (attr->exclude_kernel)
+		config_base |= ARMV8_PMU_EXCLUDE_EL1;
+
 	if (attr->exclude_user)
 		config_base |= ARMV8_PMU_EXCLUDE_EL0;
 
@@ -976,6 +1010,9 @@ static void armv8pmu_reset(void *info)
 		armv8pmu_disable_intens(idx);
 	}
 
+	/* Clear the counters we flip at guest entry/exit */
+	kvm_clr_pmu_events(U32_MAX);
+
 	/*
 	 * Initialize & Reset PMNC. Request overflow interrupt for
 	 * 64 bit cycle counter but cheat in armv8pmu_write_counter().
-- 
2.7.4
