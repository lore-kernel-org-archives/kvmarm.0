From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v11 01/21] ARM64: Move PMU register related defines to asm/pmu.h
Date: Fri, 5 Feb 2016 15:13:56 +0800
Message-ID: <1454656456-11640-2-git-send-email-zhaoshenglong@huawei.com>
References: <1454656456-11640-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1454656456-11640-1-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

To use the ARMv8 PMU related register defines from the KVM code,
we move the relevant definitions to asm/pmu.h header file.

Signed-off-by: Anup Patel <anup.patel@linaro.org>
Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/include/asm/pmu.h   | 67 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/perf_event.c | 36 +----------------------
 2 files changed, 68 insertions(+), 35 deletions(-)
 create mode 100644 arch/arm64/include/asm/pmu.h

diff --git a/arch/arm64/include/asm/pmu.h b/arch/arm64/include/asm/pmu.h
new file mode 100644
index 0000000..4406184
--- /dev/null
+++ b/arch/arm64/include/asm/pmu.h
@@ -0,0 +1,67 @@
+/*
+ * PMU support
+ *
+ * Copyright (C) 2012 ARM Limited
+ * Author: Will Deacon <will.deacon@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_PMU_H
+#define __ASM_PMU_H
+
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
+#endif /* __ASM_PMU_H */
diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index f7ab14c..8fad83d 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -24,6 +24,7 @@
 #include <linux/of.h>
 #include <linux/perf/arm_pmu.h>
 #include <linux/platform_device.h>
+#include <asm/pmu.h>
 
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
@@ -346,38 +344,6 @@ static const struct attribute_group *armv8_pmuv3_attr_groups[] = {
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


