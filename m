Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DC574AE13B
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451606; cv=none; b=lP7TAty6nckwW64zsCiK9y7cfkSUtztBX5iltfnR7fslGFoKxdn28hU7ZWoFKie1E07bOLEmANzDXfM1py/k5EX6xFDhKHQ7uYJ0SR/gIUsKnTEZriSOb7Ors7gqpIbArO+F6p7QrkRJkQrgzG1XLTb2klJC2u7onbKiGOb3NLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451606; c=relaxed/simple;
	bh=D2a2hpoZbRtbWKbY81S+gcAgHjVEDoGKGOMNGJCMcUw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDYF6uGUyfK9nED1MB7PpeN2PuABtVADXw41CVSBdqAFOw6aBaTz+B93fhBxx64orBtJ6QpHyaSSwzFJ6BLUwzm0Ztuv+6cgq97gj160iGDbgasEtQZqn2v1B2+DIgeWTdDyDj7uKlBA0r8GMA7XLyLoKG7kloue/FcCNxEDqxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RY4wQ/WY; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RY4wQ/WY"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0DC8D1650;
	Thu,  3 Sep 2026 09:06:40 -0700 (PDT)
Received: from e140010.cambridge.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 062AB3F673;
	Thu,  3 Sep 2026 09:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788451603; bh=D2a2hpoZbRtbWKbY81S+gcAgHjVEDoGKGOMNGJCMcUw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=RY4wQ/WYfJjGrpPYqFx4m9bD5ULAfnHgK3QgBTlrFSX8CpGulrdL3KgWkUpJ4Lrms
	 wu7ogrg7I0JhacXCfBEDKDvepNUypqiPTZOJEkpr4kEiVZ2K08ldGOTj31REAh5h5t
	 Kr7qKnsPEIAgwImXFxDIG8uoh8k2J/u6p468M4gg=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	will@kernel.org,
	mark.rutland@arm.com,
	linux-perf-users@vger.kernel.org,
	catalin.marinas@arm.com,
	james.clark@linaro.org
Subject: [RFC PATCH v7 04/28] perf: arm_spe_pmu: Move struct arm_spe_pmu to a separate header file
Date: Thu,  3 Sep 2026 17:05:59 +0100
Message-ID: <20260903160623.315525-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260903160623.315525-1-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM will soon want to make use of struct arm_spe_pmu, move it to a separate
header where it will be easily accessible.

Cc: Will Deacon <will@kernel.org>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 drivers/perf/arm_spe_pmu.c       | 33 +--------------------
 include/linux/perf/arm_spe_pmu.h | 50 ++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 32 deletions(-)
 create mode 100644 include/linux/perf/arm_spe_pmu.h

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index b70f3fedf028..79c571a649d5 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -28,6 +28,7 @@
 #include <linux/of.h>
 #include <linux/perf_event.h>
 #include <linux/perf/arm_pmu.h>
+#include <linux/perf/arm_spe_pmu.h>
 #include <linux/platform_device.h>
 #include <linux/printk.h>
 #include <linux/slab.h>
@@ -67,38 +68,6 @@ struct arm_spe_pmu_buf {
 	void					*base;
 };
 
-struct arm_spe_pmu {
-	struct pmu				pmu;
-	struct platform_device			*pdev;
-	cpumask_t				supported_cpus;
-	struct hlist_node			hotplug_node;
-
-	int					irq; /* PPI */
-	u16					pmsver;
-	u16					min_period;
-	u16					counter_sz;
-
-#define SPE_PMU_FEAT_FILT_EVT			(1UL << 0)
-#define SPE_PMU_FEAT_FILT_TYP			(1UL << 1)
-#define SPE_PMU_FEAT_FILT_LAT			(1UL << 2)
-#define SPE_PMU_FEAT_ARCH_INST			(1UL << 3)
-#define SPE_PMU_FEAT_LDS			(1UL << 4)
-#define SPE_PMU_FEAT_ERND			(1UL << 5)
-#define SPE_PMU_FEAT_INV_FILT_EVT		(1UL << 6)
-#define SPE_PMU_FEAT_DISCARD			(1UL << 7)
-#define SPE_PMU_FEAT_EFT			(1UL << 8)
-#define SPE_PMU_FEAT_FDS			(1UL << 9)
-#define SPE_PMU_FEAT_DEV_PROBED			(1UL << 63)
-	u64					features;
-
-	u64					pmsevfr_res0;
-	u16					max_record_sz;
-	u16					align;
-	struct perf_output_handle __percpu	*handle;
-};
-
-#define to_spe_pmu(p) (container_of(p, struct arm_spe_pmu, pmu))
-
 /* Convert a free-running index from perf into an SPE buffer offset */
 #define PERF_IDX2OFF(idx, buf) \
 	((idx) % ((unsigned long)(buf)->nr_pages << PAGE_SHIFT))
diff --git a/include/linux/perf/arm_spe_pmu.h b/include/linux/perf/arm_spe_pmu.h
new file mode 100644
index 000000000000..af86fd184050
--- /dev/null
+++ b/include/linux/perf/arm_spe_pmu.h
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Split from driver/perf/arm_spe_pmu.c
+ *
+ * Copyright (C) 2016 ARM Limited
+ */
+
+#ifndef __PERF_ARM_SPE_PMU_H__
+#define __PERF_ARM_SPE_PMU_H__
+
+#include <linux/cpumask.h>
+#include <linux/container_of.h>
+#include <linux/list.h>
+#include <linux/perf_event.h>
+#include <linux/platform_device.h>
+#include <linux/types.h>
+
+struct arm_spe_pmu {
+	struct pmu				pmu;
+	struct platform_device			*pdev;
+	cpumask_t				supported_cpus;
+	struct hlist_node			hotplug_node;
+
+	int					irq; /* PPI */
+	u16					pmsver;
+	u16					min_period;
+	u16					counter_sz;
+
+#define SPE_PMU_FEAT_FILT_EVT			(1UL << 0)
+#define SPE_PMU_FEAT_FILT_TYP			(1UL << 1)
+#define SPE_PMU_FEAT_FILT_LAT			(1UL << 2)
+#define SPE_PMU_FEAT_ARCH_INST			(1UL << 3)
+#define SPE_PMU_FEAT_LDS			(1UL << 4)
+#define SPE_PMU_FEAT_ERND			(1UL << 5)
+#define SPE_PMU_FEAT_INV_FILT_EVT		(1UL << 6)
+#define SPE_PMU_FEAT_DISCARD			(1UL << 7)
+#define SPE_PMU_FEAT_EFT			(1UL << 8)
+#define SPE_PMU_FEAT_FDS			(1UL << 9)
+#define SPE_PMU_FEAT_DEV_PROBED			(1UL << 63)
+	u64					features;
+
+	u64					pmsevfr_res0;
+	u16					max_record_sz;
+	u16					align;
+	struct perf_output_handle __percpu	*handle;
+};
+
+#define to_spe_pmu(p) (container_of(p, struct arm_spe_pmu, pmu))
+
+#endif /* __PERF_ARM_SPE_PMU_H__ */
-- 
2.43.0

