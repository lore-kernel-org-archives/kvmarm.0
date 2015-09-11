From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v2 01/22] ARM64: Move PMU register related defines to asm/pmu.h
Date: Fri, 11 Sep 2015 16:54:54 +0800
Message-ID: <1441961715-11688-2-git-send-email-zhaoshenglong@huawei.com>
References: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA85341022
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2015 04:55:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z1UjD+GVutOy for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Sep 2015 04:55:30 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4C48C410D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2015 04:55:28 -0400 (EDT)
In-Reply-To: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

To use the ARMv8 PMU related register defines from the KVM code,
we move the relevant definitions to asm/pmu.h header file.

Signed-off-by: Anup Patel <anup.patel@linaro.org>
Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/include/asm/pmu.h   | 45 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/perf_event.c | 35 --------------------------------
 2 files changed, 45 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/include/asm/pmu.h b/arch/arm64/include/asm/pmu.h
index b7710a5..b9f394a 100644
--- a/arch/arm64/include/asm/pmu.h
+++ b/arch/arm64/include/asm/pmu.h
@@ -19,6 +19,51 @@
 #ifndef __ASM_PMU_H
 #define __ASM_PMU_H
 
+#define ARMV8_MAX_COUNTERS      32
+#define ARMV8_COUNTER_MASK      (ARMV8_MAX_COUNTERS - 1)
+
+/*
+ * Per-CPU PMCR: config reg
+ */
+#define ARMV8_PMCR_E		(1 << 0) /* Enable all counters */
+#define ARMV8_PMCR_P		(1 << 1) /* Reset all counters */
+#define ARMV8_PMCR_C		(1 << 2) /* Cycle counter reset */
+#define ARMV8_PMCR_D		(1 << 3) /* CCNT counts every 64th cpu cycle */
+#define ARMV8_PMCR_X		(1 << 4) /* Export to ETM */
+#define ARMV8_PMCR_DP		(1 << 5) /* Disable CCNT if non-invasive debug*/
+#define	ARMV8_PMCR_N_SHIFT	11	 /* Number of counters supported */
+#define	ARMV8_PMCR_N_MASK	0x1f
+#define	ARMV8_PMCR_MASK		0x3f	 /* Mask for writable bits */
+
+/*
+ * PMCNTEN: counters enable reg
+ */
+#define	ARMV8_CNTEN_MASK	0xffffffff	/* Mask for writable bits */
+
+/*
+ * PMINTEN: counters interrupt enable reg
+ */
+#define	ARMV8_INTEN_MASK	0xffffffff	/* Mask for writable bits */
+
+/*
+ * PMOVSR: counters overflow flag status reg
+ */
+#define	ARMV8_OVSR_MASK		0xffffffff	/* Mask for writable bits */
+#define	ARMV8_OVERFLOWED_MASK	ARMV8_OVSR_MASK
+
+/*
+ * PMXEVTYPER: Event selection reg
+ */
+#define	ARMV8_EVTYPE_MASK	0xc80003ff	/* Mask for writable bits */
+#define	ARMV8_EVTYPE_EVENT	0x3ff		/* Mask for EVENT bits */
+
+/*
+ * Event filters for PMUv3
+ */
+#define	ARMV8_EXCLUDE_EL1	(1 << 31)
+#define	ARMV8_EXCLUDE_EL0	(1 << 30)
+#define	ARMV8_INCLUDE_EL2	(1 << 27)
+
 #ifdef CONFIG_HW_PERF_EVENTS
 
 /* The events for a given PMU register set. */
diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index b31e9a4..96538d7 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -824,9 +824,6 @@ static const unsigned armv8_pmuv3_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
 #define	ARMV8_IDX_COUNTER0	1
 #define	ARMV8_IDX_COUNTER_LAST	(ARMV8_IDX_CYCLE_COUNTER + cpu_pmu->num_events - 1)
 
-#define	ARMV8_MAX_COUNTERS	32
-#define	ARMV8_COUNTER_MASK	(ARMV8_MAX_COUNTERS - 1)
-
 /*
  * ARMv8 low level PMU access
  */
@@ -837,38 +834,6 @@ static const unsigned armv8_pmuv3_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
 #define	ARMV8_IDX_TO_COUNTER(x)	\
 	(((x) - ARMV8_IDX_COUNTER0) & ARMV8_COUNTER_MASK)
 
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
-
 static inline u32 armv8pmu_pmcr_read(void)
 {
 	u32 val;
-- 
2.0.4
