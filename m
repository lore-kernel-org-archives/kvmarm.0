From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v13 01/20] ARM64: Move PMU register related defines to
 asm/perf_event.h
Date: Wed, 24 Feb 2016 13:08:21 +0800
Message-ID: <1456290520-10012-2-git-send-email-zhaoshenglong@huawei.com>
References: <1456290520-10012-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C1F5412ED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2016 00:07:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vO1pToJOyv-y for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Feb 2016 00:07:31 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1456412E6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2016 00:07:28 -0500 (EST)
In-Reply-To: <1456290520-10012-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, shannon.zhao@linaro.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

To use the ARMv8 PMU related register defines from the KVM code, we move
the relevant definitions to asm/perf_event.h header file and rename them
with prefix ARMV8_PMU_.

Signed-off-by: Anup Patel <anup.patel@linaro.org>
Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/include/asm/perf_event.h | 35 +++++++++++++++++++
 arch/arm64/kernel/perf_event.c      | 68 ++++++++++---------------------------
 2 files changed, 52 insertions(+), 51 deletions(-)

diff --git a/arch/arm64/include/asm/perf_event.h b/arch/arm64/include/asm/perf_event.h
index 7bd3cdb..5c77ef8 100644
--- a/arch/arm64/include/asm/perf_event.h
+++ b/arch/arm64/include/asm/perf_event.h
@@ -17,6 +17,41 @@
 #ifndef __ASM_PERF_EVENT_H
 #define __ASM_PERF_EVENT_H
 
+#define	ARMV8_PMU_MAX_COUNTERS	32
+#define	ARMV8_PMU_COUNTER_MASK	(ARMV8_PMU_MAX_COUNTERS - 1)
+
+/*
+ * Per-CPU PMCR: config reg
+ */
+#define ARMV8_PMU_PMCR_E	(1 << 0) /* Enable all counters */
+#define ARMV8_PMU_PMCR_P	(1 << 1) /* Reset all counters */
+#define ARMV8_PMU_PMCR_C	(1 << 2) /* Cycle counter reset */
+#define ARMV8_PMU_PMCR_D	(1 << 3) /* CCNT counts every 64th cpu cycle */
+#define ARMV8_PMU_PMCR_X	(1 << 4) /* Export to ETM */
+#define ARMV8_PMU_PMCR_DP	(1 << 5) /* Disable CCNT if non-invasive debug*/
+#define	ARMV8_PMU_PMCR_N_SHIFT	11	 /* Number of counters supported */
+#define	ARMV8_PMU_PMCR_N_MASK	0x1f
+#define	ARMV8_PMU_PMCR_MASK	0x3f	 /* Mask for writable bits */
+
+/*
+ * PMOVSR: counters overflow flag status reg
+ */
+#define	ARMV8_PMU_OVSR_MASK		0xffffffff	/* Mask for writable bits */
+#define	ARMV8_PMU_OVERFLOWED_MASK	ARMV8_PMU_OVSR_MASK
+
+/*
+ * PMXEVTYPER: Event selection reg
+ */
+#define	ARMV8_PMU_EVTYPE_MASK	0xc80003ff	/* Mask for writable bits */
+#define	ARMV8_PMU_EVTYPE_EVENT	0x3ff		/* Mask for EVENT bits */
+
+/*
+ * Event filters for PMUv3
+ */
+#define	ARMV8_PMU_EXCLUDE_EL1	(1 << 31)
+#define	ARMV8_PMU_EXCLUDE_EL0	(1 << 30)
+#define	ARMV8_PMU_INCLUDE_EL2	(1 << 27)
+
 #ifdef CONFIG_PERF_EVENTS
 struct pt_regs;
 extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index f7ab14c..212c9fc4 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -24,6 +24,7 @@
 #include <linux/of.h>
 #include <linux/perf/arm_pmu.h>
 #include <linux/platform_device.h>
+#include <asm/perf_event.h>
 
 /*
  * ARMv8 PMUv3 Performance Events handling code.
@@ -333,9 +334,6 @@ static const struct attribute_group *armv8_pmuv3_attr_groups[] = {
 #define	ARMV8_IDX_COUNTER_LAST(cpu_pmu) \
 	(ARMV8_IDX_CYCLE_COUNTER + cpu_pmu->num_events - 1)
 
-#define	ARMV8_MAX_COUNTERS	32
-#define	ARMV8_COUNTER_MASK	(ARMV8_MAX_COUNTERS - 1)
-
 /*
  * ARMv8 low level PMU access
  */
@@ -344,39 +342,7 @@ static const struct attribute_group *armv8_pmuv3_attr_groups[] = {
  * Perf Event to low level counters mapping
  */
 #define	ARMV8_IDX_TO_COUNTER(x)	\
-	(((x) - ARMV8_IDX_COUNTER0) & ARMV8_COUNTER_MASK)
-
-/*
- * Per-CPU PMCR: config reg
- */
-#define ARMV8_PMCR_E		(1 << 0) /* Enable all counters */
-#define ARMV8_PMCR_P		(1 << 1) /* Reset all counters */
-#define ARMV8_PMCR_C		(1 << 2) /* Cycle counter reset */
-#define ARMV8_PMCR_D		(1 << 3) /* CCNT counts every 64th cpu cycle */
-#define ARMV8_PMCR_X		(1 << 4) /* Export to ETM */
-#define ARMV8_PMCR_DP		(1 << 5) /* Disable CCNT if non-invasive debug*/
-#define	ARMV8_PMCR_N_SHIFT	11	 /* Number of counters supported */
-#define	ARMV8_PMCR_N_MASK	0x1f
-#define	ARMV8_PMCR_MASK		0x3f	 /* Mask for writable bits */
-
-/*
- * PMOVSR: counters overflow flag status reg
- */
-#define	ARMV8_OVSR_MASK		0xffffffff	/* Mask for writable bits */
-#define	ARMV8_OVERFLOWED_MASK	ARMV8_OVSR_MASK
-
-/*
- * PMXEVTYPER: Event selection reg
- */
-#define	ARMV8_EVTYPE_MASK	0xc80003ff	/* Mask for writable bits */
-#define	ARMV8_EVTYPE_EVENT	0x3ff		/* Mask for EVENT bits */
-
-/*
- * Event filters for PMUv3
- */
-#define	ARMV8_EXCLUDE_EL1	(1 << 31)
-#define	ARMV8_EXCLUDE_EL0	(1 << 30)
-#define	ARMV8_INCLUDE_EL2	(1 << 27)
+	(((x) - ARMV8_IDX_COUNTER0) & ARMV8_PMU_COUNTER_MASK)
 
 static inline u32 armv8pmu_pmcr_read(void)
 {
@@ -387,14 +353,14 @@ static inline u32 armv8pmu_pmcr_read(void)
 
 static inline void armv8pmu_pmcr_write(u32 val)
 {
-	val &= ARMV8_PMCR_MASK;
+	val &= ARMV8_PMU_PMCR_MASK;
 	isb();
 	asm volatile("msr pmcr_el0, %0" :: "r" (val));
 }
 
 static inline int armv8pmu_has_overflowed(u32 pmovsr)
 {
-	return pmovsr & ARMV8_OVERFLOWED_MASK;
+	return pmovsr & ARMV8_PMU_OVERFLOWED_MASK;
 }
 
 static inline int armv8pmu_counter_valid(struct arm_pmu *cpu_pmu, int idx)
@@ -453,7 +419,7 @@ static inline void armv8pmu_write_counter(struct perf_event *event, u32 value)
 static inline void armv8pmu_write_evtype(int idx, u32 val)
 {
 	if (armv8pmu_select_counter(idx) == idx) {
-		val &= ARMV8_EVTYPE_MASK;
+		val &= ARMV8_PMU_EVTYPE_MASK;
 		asm volatile("msr pmxevtyper_el0, %0" :: "r" (val));
 	}
 }
@@ -499,7 +465,7 @@ static inline u32 armv8pmu_getreset_flags(void)
 	asm volatile("mrs %0, pmovsclr_el0" : "=r" (value));
 
 	/* Write to clear flags */
-	value &= ARMV8_OVSR_MASK;
+	value &= ARMV8_PMU_OVSR_MASK;
 	asm volatile("msr pmovsclr_el0, %0" :: "r" (value));
 
 	return value;
@@ -637,7 +603,7 @@ static void armv8pmu_start(struct arm_pmu *cpu_pmu)
 
 	raw_spin_lock_irqsave(&events->pmu_lock, flags);
 	/* Enable all counters */
-	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMCR_E);
+	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
 	raw_spin_unlock_irqrestore(&events->pmu_lock, flags);
 }
 
@@ -648,7 +614,7 @@ static void armv8pmu_stop(struct arm_pmu *cpu_pmu)
 
 	raw_spin_lock_irqsave(&events->pmu_lock, flags);
 	/* Disable all counters */
-	armv8pmu_pmcr_write(armv8pmu_pmcr_read() & ~ARMV8_PMCR_E);
+	armv8pmu_pmcr_write(armv8pmu_pmcr_read() & ~ARMV8_PMU_PMCR_E);
 	raw_spin_unlock_irqrestore(&events->pmu_lock, flags);
 }
 
@@ -658,7 +624,7 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
 	int idx;
 	struct arm_pmu *cpu_pmu = to_arm_pmu(event->pmu);
 	struct hw_perf_event *hwc = &event->hw;
-	unsigned long evtype = hwc->config_base & ARMV8_EVTYPE_EVENT;
+	unsigned long evtype = hwc->config_base & ARMV8_PMU_EVTYPE_EVENT;
 
 	/* Always place a cycle counter into the cycle counter. */
 	if (evtype == ARMV8_PMUV3_PERFCTR_CLOCK_CYCLES) {
@@ -692,11 +658,11 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
 	if (attr->exclude_idle)
 		return -EPERM;
 	if (attr->exclude_user)
-		config_base |= ARMV8_EXCLUDE_EL0;
+		config_base |= ARMV8_PMU_EXCLUDE_EL0;
 	if (attr->exclude_kernel)
-		config_base |= ARMV8_EXCLUDE_EL1;
+		config_base |= ARMV8_PMU_EXCLUDE_EL1;
 	if (!attr->exclude_hv)
-		config_base |= ARMV8_INCLUDE_EL2;
+		config_base |= ARMV8_PMU_INCLUDE_EL2;
 
 	/*
 	 * Install the filter into config_base as this is used to
@@ -719,28 +685,28 @@ static void armv8pmu_reset(void *info)
 	}
 
 	/* Initialize & Reset PMNC: C and P bits. */
-	armv8pmu_pmcr_write(ARMV8_PMCR_P | ARMV8_PMCR_C);
+	armv8pmu_pmcr_write(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C);
 }
 
 static int armv8_pmuv3_map_event(struct perf_event *event)
 {
 	return armpmu_map_event(event, &armv8_pmuv3_perf_map,
 				&armv8_pmuv3_perf_cache_map,
-				ARMV8_EVTYPE_EVENT);
+				ARMV8_PMU_EVTYPE_EVENT);
 }
 
 static int armv8_a53_map_event(struct perf_event *event)
 {
 	return armpmu_map_event(event, &armv8_a53_perf_map,
 				&armv8_a53_perf_cache_map,
-				ARMV8_EVTYPE_EVENT);
+				ARMV8_PMU_EVTYPE_EVENT);
 }
 
 static int armv8_a57_map_event(struct perf_event *event)
 {
 	return armpmu_map_event(event, &armv8_a57_perf_map,
 				&armv8_a57_perf_cache_map,
-				ARMV8_EVTYPE_EVENT);
+				ARMV8_PMU_EVTYPE_EVENT);
 }
 
 static void armv8pmu_read_num_pmnc_events(void *info)
@@ -748,7 +714,7 @@ static void armv8pmu_read_num_pmnc_events(void *info)
 	int *nb_cnt = info;
 
 	/* Read the nb of CNTx counters supported from PMNC */
-	*nb_cnt = (armv8pmu_pmcr_read() >> ARMV8_PMCR_N_SHIFT) & ARMV8_PMCR_N_MASK;
+	*nb_cnt = (armv8pmu_pmcr_read() >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
 
 	/* Add the CPU cycles counter */
 	*nb_cnt += 1;
-- 
2.0.4
