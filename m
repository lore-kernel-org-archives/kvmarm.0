Return-Path: <SRS0=zNRV=2K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6274BC2D0D4
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 14:31:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2434524688
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 14:31:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2434524688
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1FC64A5A6;
	Fri, 20 Dec 2019 09:31:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UJjOOgEG1601; Fri, 20 Dec 2019 09:31:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6EBA4AC68;
	Fri, 20 Dec 2019 09:31:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45ADD4A5A6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 09:31:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6ZiWPpV30pCi for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Dec 2019 09:31:01 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 277824A7E4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 09:31:01 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB5FF11D4;
 Fri, 20 Dec 2019 06:31:00 -0800 (PST)
Received: from e119886-lin.cambridge.arm.com (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0EEF63F718;
 Fri, 20 Dec 2019 06:30:58 -0800 (PST)
From: Andrew Murray <andrew.murray@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>
Subject: [PATCH v2 13/18] perf: arm_spe: Add KVM structure for obtaining IRQ
 info
Date: Fri, 20 Dec 2019 14:30:20 +0000
Message-Id: <20191220143025.33853-14-andrew.murray@arm.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191220143025.33853-1-andrew.murray@arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

KVM requires knowledge of the physical SPE IRQ number such that it can
associate it with any virtual IRQ for guests that require SPE emulation.

Let's create a structure to hold this information and an accessor that
KVM can use to retrieve this information.

We expect that each SPE device will have the same physical PPI number
and thus will warn when this is not the case.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 drivers/perf/arm_spe_pmu.c | 23 +++++++++++++++++++++++
 include/kvm/arm_spe.h      |  6 ++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 4e4984a55cd1..2d24af4cfcab 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -34,6 +34,9 @@
 #include <linux/smp.h>
 #include <linux/vmalloc.h>
 
+#include <linux/kvm_host.h>
+#include <kvm/arm_spe.h>
+
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
 #include <asm/mmu.h>
@@ -1127,6 +1130,24 @@ static void arm_spe_pmu_dev_teardown(struct arm_spe_pmu *spe_pmu)
 	free_percpu_irq(spe_pmu->irq, spe_pmu->handle);
 }
 
+#ifdef CONFIG_KVM_ARM_SPE
+static struct arm_spe_kvm_info arm_spe_kvm_info;
+
+struct arm_spe_kvm_info *arm_spe_get_kvm_info(void)
+{
+	return &arm_spe_kvm_info;
+}
+
+static void arm_spe_populate_kvm_info(struct arm_spe_pmu *spe_pmu)
+{
+	WARN_ON_ONCE(arm_spe_kvm_info.physical_irq != 0 &&
+		     arm_spe_kvm_info.physical_irq != spe_pmu->irq);
+	arm_spe_kvm_info.physical_irq = spe_pmu->irq;
+}
+#else
+static void arm_spe_populate_kvm_info(struct arm_spe_pmu *spe_pmu) {}
+#endif
+
 /* Driver and device probing */
 static int arm_spe_pmu_irq_probe(struct arm_spe_pmu *spe_pmu)
 {
@@ -1149,6 +1170,8 @@ static int arm_spe_pmu_irq_probe(struct arm_spe_pmu *spe_pmu)
 	}
 
 	spe_pmu->irq = irq;
+	arm_spe_populate_kvm_info(spe_pmu);
+
 	return 0;
 }
 
diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
index d1f3c564dfd0..9c65130d726d 100644
--- a/include/kvm/arm_spe.h
+++ b/include/kvm/arm_spe.h
@@ -17,6 +17,12 @@ struct kvm_spe {
 	bool irq_level;
 };
 
+struct arm_spe_kvm_info {
+	int physical_irq;
+};
+
+struct arm_spe_kvm_info *arm_spe_get_kvm_info(void);
+
 #ifdef CONFIG_KVM_ARM_SPE
 #define kvm_arm_spe_v1_ready(v)		((v)->arch.spe.ready)
 #define kvm_arm_spe_irq_initialized(v)		\
-- 
2.21.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
