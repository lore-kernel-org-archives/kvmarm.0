Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9AFFC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 96A9F61BD3
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 96A9F61BD3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CF714B199;
	Wed, 17 Nov 2021 10:37:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D1kDCbNW9vS7; Wed, 17 Nov 2021 10:37:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F363A4B15A;
	Wed, 17 Nov 2021 10:37:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAACF4B17C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D+CNiudbLWui for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 10:37:29 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3545B4B17D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:28 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E1FDAED1;
 Wed, 17 Nov 2021 07:37:27 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4D74B3F5A1;
 Wed, 17 Nov 2021 07:37:26 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, mark.rutland@arm.com
Subject: [RFC PATCH v5 15/38] perf: arm_spe_pmu: Move struct arm_spe_pmu to a
 separate header file
Date: Wed, 17 Nov 2021 15:38:19 +0000
Message-Id: <20211117153842.302159-16-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211117153842.302159-1-alexandru.elisei@arm.com>
References: <20211117153842.302159-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

KVM will soon want to make use of struct arm_spe_pmu, move it to a separate
header where it will be easily accessible. This is a straightforward move
and functionality should not be impacted.

CC: Will Deacon <will@kernel.org>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 drivers/perf/arm_spe_pmu.c       | 29 +------------------
 include/linux/perf/arm_spe_pmu.h | 49 ++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 28 deletions(-)
 create mode 100644 include/linux/perf/arm_spe_pmu.h

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index d44bcc29d99c..ccb92c182527 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -27,7 +27,7 @@
 #include <linux/of_address.h>
 #include <linux/of_device.h>
 #include <linux/perf_event.h>
-#include <linux/perf/arm_pmu.h>
+#include <linux/perf/arm_spe_pmu.h>
 #include <linux/platform_device.h>
 #include <linux/printk.h>
 #include <linux/slab.h>
@@ -47,33 +47,6 @@ struct arm_spe_pmu_buf {
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
-#define SPE_PMU_FEAT_DEV_PROBED			(1UL << 63)
-	u64					features;
-
-	u16					max_record_sz;
-	u16					align;
-	struct perf_output_handle __percpu	*handle;
-};
-
-#define to_spe_pmu(p) (container_of(p, struct arm_spe_pmu, pmu))
-
 /* Convert a free-running index from perf into an SPE buffer offset */
 #define PERF_IDX2OFF(idx, buf)	((idx) % ((buf)->nr_pages << PAGE_SHIFT))
 
diff --git a/include/linux/perf/arm_spe_pmu.h b/include/linux/perf/arm_spe_pmu.h
new file mode 100644
index 000000000000..7711e59c5727
--- /dev/null
+++ b/include/linux/perf/arm_spe_pmu.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Split from from drivers/perf/arm_spe_pmu.c.
+ *
+ *  Copyright (C) 2021 ARM Limited
+ */
+
+#ifndef __ARM_SPE_PMU_H__
+#define __ARM_SPE_PMU_H__
+
+#include <linux/cpumask.h>
+#include <linux/perf_event.h>
+#include <linux/platform_device.h>
+#include <linux/types.h>
+
+#ifdef CONFIG_ARM_SPE_PMU
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
+#define SPE_PMU_FEAT_DEV_PROBED			(1UL << 63)
+	u64					features;
+
+	u16					max_record_sz;
+	u16					align;
+	struct perf_output_handle __percpu	*handle;
+};
+
+#define to_spe_pmu(p) (container_of(p, struct arm_spe_pmu, pmu))
+
+#define ARMV8_SPE_PDEV_NAME "arm,spe-v1"
+
+#endif /* CONFIG_ARM_SPE_PMU */
+
+#endif /* __ARM_SPE_PMU_H__ */
-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
