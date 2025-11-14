Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2057626F478
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136466; cv=none; b=fBe2aHBiTU9Sz9UKMbQt8bAkqYAFt718vCOQ6fSbP5xPlYalI4VlqMvH62V472i4gBuG1DHZP1sAWzmkyX9dWfFA7DVXuiT61yBPyC5BaAntYrmL7VNUr2qitCO6NDOWv23UAeBO7b5fXorljOgIszSmEhnaFMBvwv4OEl+OXXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136466; c=relaxed/simple;
	bh=KjqLAAjuqdC1sy5a7qqmlMDfyA9VHLWA/x+psnpQiR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jL1f4ohU7cUq5m1zmLK+bXSYOUYOuP+c7+OIKhm5GTdTUQtLMFk/jKRSCo+47w7OEgkC+sUl2iVXSFLlw7caC3+c2tb0v05D3vc5VIWQATg+4UnMXwM3G/bMY3JMNX3Qt+nx5Qm7Mrrxk1UAHWeJf8SdNlYWxnk1i7rAEp0lCFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B63A51BB0;
	Fri, 14 Nov 2025 08:07:36 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3797B3F5A1;
	Fri, 14 Nov 2025 08:07:42 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: james.clark@linaro.org,
	mark.rutland@arm.com,
	james.morse@arm.com
Subject: [RFC PATCH v6 04/35] perf: arm_spe_pmu: Move struct arm_spe_pmu to a separate header file
Date: Fri, 14 Nov 2025 16:06:45 +0000
Message-ID: <20251114160717.163230-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251114160717.163230-1-alexandru.elisei@arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
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
 drivers/perf/arm_spe_pmu.c       | 32 +--------------------
 include/linux/perf/arm_spe_pmu.h | 49 ++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 31 deletions(-)
 create mode 100644 include/linux/perf/arm_spe_pmu.h

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index fa50645fedda..188ea783a569 100644
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
@@ -67,37 +68,6 @@ struct arm_spe_pmu_buf {
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
index 000000000000..86085a7559d9
--- /dev/null
+++ b/include/linux/perf/arm_spe_pmu.h
@@ -0,0 +1,49 @@
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
2.51.2

