Return-Path: <SRS0=yNs4=TT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CDDC04AB4
	for <kvmarm@archiver.kernel.org>; Sun, 19 May 2019 10:08:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 512B220657
	for <kvmarm@archiver.kernel.org>; Sun, 19 May 2019 10:08:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 512B220657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AB474A504;
	Sun, 19 May 2019 06:08:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2iUfO5ZZIqUD; Sun, 19 May 2019 06:07:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CF854A4E8;
	Sun, 19 May 2019 06:07:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E4DAE4A4E8
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 May 2019 06:07:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 74SFOO5-7scj for <kvmarm@lists.cs.columbia.edu>;
 Sun, 19 May 2019 06:07:56 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5F73E4A4E5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 May 2019 06:07:56 -0400 (EDT)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 2FE1C505548047439AB4;
 Sun, 19 May 2019 18:07:38 +0800 (CST)
Received: from HGHY1z004218071.china.huawei.com (10.177.29.32) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Sun, 19 May 2019 18:07:29 +0800
From: Xiang Zheng <zhengxiang9@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: ARM64: Update perf event when setting PMU count value
Date: Sun, 19 May 2019 18:05:59 +0800
Message-ID: <20190519100559.7188-1-zhengxiang9@huawei.com>
X-Mailer: git-send-email 2.15.1.windows.2
MIME-Version: 1.0
X-Originating-IP: [10.177.29.32]
X-CFilter-Loop: Reflected
Cc: marc.zyngier@arm.com
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

Guest will adjust the sample period and set PMU counter value when
it takes a long time to handle the PMU interrupts.

However, we don't have a corresponding change on the virtual PMU
which is emulated via a perf event. It could cause a large number
of PMU interrupts injected to guest. Then guest will get hang for
handling these interrupts.

So update the sample_period of perf event if the counter value is
changed to avoid this case.

Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
---
 virt/kvm/arm/pmu.c | 54 +++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 45 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 1c5b76c..cbad3ec 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -24,6 +24,11 @@
 #include <kvm/arm_pmu.h>
 #include <kvm/arm_vgic.h>
 
+static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
+static struct perf_event *kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu,
+						    struct kvm_pmc *pmc,
+						    struct perf_event_attr *attr);
+
 /**
  * kvm_pmu_get_counter_value - get PMU counter value
  * @vcpu: The vcpu pointer
@@ -57,11 +62,29 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
  */
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 {
-	u64 reg;
+	u64 reg, counter, old_sample_period;
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
+	struct perf_event *event;
+	struct perf_event_attr attr;
 
 	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
 	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
 	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
+
+	if (pmc->perf_event) {
+		attr = pmc->perf_event->attr;
+		old_sample_period = attr.sample_period;
+		counter = kvm_pmu_get_counter_value(vcpu, select_idx);
+		attr.sample_period = (-counter) & pmc->bitmask;
+		if (attr.sample_period == old_sample_period)
+			return;
+
+		kvm_pmu_stop_counter(vcpu, pmc);
+		event = kvm_pmu_create_perf_event(vcpu, pmc, &attr);
+		if (event)
+			pmc->perf_event = event;
+	}
 }
 
 /**
@@ -303,6 +326,24 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
 	}
 }
 
+static struct perf_event *kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu,
+						    struct kvm_pmc *pmc,
+						    struct perf_event_attr *attr)
+{
+	struct perf_event *event;
+
+	event = perf_event_create_kernel_counter(attr, -1, current,
+						 kvm_pmu_perf_overflow, pmc);
+
+	if (IS_ERR(event)) {
+		pr_err_once("kvm: pmu event creation failed %ld\n",
+			    PTR_ERR(event));
+		return NULL;
+	}
+
+	return event;
+}
+
 /**
  * kvm_pmu_software_increment - do software increment
  * @vcpu: The vcpu pointer
@@ -416,15 +457,10 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 	/* The initial sample period (overflow count) of an event. */
 	attr.sample_period = (-counter) & pmc->bitmask;
 
-	event = perf_event_create_kernel_counter(&attr, -1, current,
-						 kvm_pmu_perf_overflow, pmc);
-	if (IS_ERR(event)) {
-		pr_err_once("kvm: pmu event creation failed %ld\n",
-			    PTR_ERR(event));
-		return;
-	}
+	event = kvm_pmu_create_perf_event(vcpu, pmc, &attr);
 
-	pmc->perf_event = event;
+	if (event)
+		pmc->perf_event = event;
 }
 
 bool kvm_arm_support_pmu_v3(void)
-- 
1.8.3.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
