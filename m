Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB786C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 80F3D61BFA
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 80F3D61BFA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35BFE4B133;
	Wed, 17 Nov 2021 10:37:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S02FZ8RBaTRC; Wed, 17 Nov 2021 10:37:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 201E94B1B0;
	Wed, 17 Nov 2021 10:37:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A8D44B154
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3O-f6pP4Tas2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 10:37:31 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED4FC4B119
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:29 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A70311FB;
 Wed, 17 Nov 2021 07:37:29 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 318BC3F5A1;
 Wed, 17 Nov 2021 07:37:28 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, mark.rutland@arm.com
Subject: [RFC PATCH v5 16/38] KVM: arm64: Allow SPE emulation when the SPE
 hardware is present
Date: Wed, 17 Nov 2021 15:38:20 +0000
Message-Id: <20211117153842.302159-17-alexandru.elisei@arm.com>
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

KVM SPE emulation requires at least one physical CPU to support SPE.  Each
time the SPE driver successfully probes the SPE hardware, keep track of the
CPUs that belong to the SPE instance and enable the static key that allows
SPE to emulated by KVM.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_spe.h | 20 ++++++++++++++++++++
 arch/arm64/kvm/Makefile          |  1 +
 arch/arm64/kvm/arm.c             |  1 +
 arch/arm64/kvm/spe.c             | 28 ++++++++++++++++++++++++++++
 drivers/perf/arm_spe_pmu.c       |  2 ++
 include/linux/perf/arm_spe_pmu.h |  6 ++++++
 6 files changed, 58 insertions(+)
 create mode 100644 arch/arm64/include/asm/kvm_spe.h
 create mode 100644 arch/arm64/kvm/spe.c

diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
new file mode 100644
index 000000000000..8f8b7dd7fd90
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2021 - ARM Ltd
+ */
+
+#ifndef __ARM64_KVM_SPE_H__
+#define __ARM64_KVM_SPE_H__
+
+#ifdef CONFIG_KVM_ARM_SPE
+DECLARE_STATIC_KEY_FALSE(kvm_spe_available);
+
+static __always_inline bool kvm_supports_spe(void)
+{
+	return static_branch_likely(&kvm_spe_available);
+}
+#else
+#define kvm_supports_spe()	(false)
+#endif /* CONFIG_KVM_ARM_SPE */
+
+#endif /* __ARM64_KVM_SPE_H__ */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 989bb5dad2c8..86092a0f8367 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -25,3 +25,4 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o
 
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o
+kvm-$(CONFIG_KVM_ARM_SPE)     += spe.o
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2cdb18d9a740..b2997b919be2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -37,6 +37,7 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_spe.h>
 #include <asm/kvm_emulate.h>
 #include <asm/sections.h>
 
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
new file mode 100644
index 000000000000..6cd0e24ddeec
--- /dev/null
+++ b/arch/arm64/kvm/spe.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021 - ARM Ltd
+ */
+
+#include <linux/cpumask.h>
+#include <linux/kvm_host.h>
+#include <linux/perf/arm_spe_pmu.h>
+
+#include <asm/kvm_spe.h>
+
+DEFINE_STATIC_KEY_FALSE(kvm_spe_available);
+
+static cpumask_t supported_cpus;
+static DEFINE_MUTEX(supported_cpus_lock);
+
+void kvm_host_spe_init(struct arm_spe_pmu *spe_pmu)
+{
+	if (!spe_pmu->pmsver)
+		return;
+
+	mutex_lock(&supported_cpus_lock);
+
+	static_branch_enable(&kvm_spe_available);
+	cpumask_or(&supported_cpus, &supported_cpus, &spe_pmu->supported_cpus);
+
+	mutex_unlock(&supported_cpus_lock);
+}
diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index ccb92c182527..4ffc02a98282 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -1183,6 +1183,8 @@ static int arm_spe_pmu_device_probe(struct platform_device *pdev)
 	if (ret)
 		goto out_teardown_dev;
 
+	kvm_host_spe_init(spe_pmu);
+
 	return 0;
 
 out_teardown_dev:
diff --git a/include/linux/perf/arm_spe_pmu.h b/include/linux/perf/arm_spe_pmu.h
index 7711e59c5727..505a8867daad 100644
--- a/include/linux/perf/arm_spe_pmu.h
+++ b/include/linux/perf/arm_spe_pmu.h
@@ -44,6 +44,12 @@ struct arm_spe_pmu {
 
 #define ARMV8_SPE_PDEV_NAME "arm,spe-v1"
 
+#ifdef CONFIG_KVM_ARM_SPE
+void kvm_host_spe_init(struct arm_spe_pmu *spe_pmu);
+#else
+#define kvm_host_spe_init(x)	do { } while(0)
+#endif
+
 #endif /* CONFIG_ARM_SPE_PMU */
 
 #endif /* __ARM_SPE_PMU_H__ */
-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
