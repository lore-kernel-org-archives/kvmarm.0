Return-Path: <SRS0=QEDf=TJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA49FC04AB2
	for <kvmarm@archiver.kernel.org>; Thu,  9 May 2019 15:32:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6ABA32084E
	for <kvmarm@archiver.kernel.org>; Thu,  9 May 2019 15:32:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6ABA32084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 232CE4A4A3;
	Thu,  9 May 2019 11:32:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id P1PIt9HtEoLa; Thu,  9 May 2019 11:32:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B40544A4D5;
	Thu,  9 May 2019 11:32:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D226C4A4D7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 May 2019 11:32:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9tjHheGb-STm for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 May 2019 11:32:25 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E2DC4A49F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 May 2019 11:32:25 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9C8615AD;
 Thu,  9 May 2019 08:32:24 -0700 (PDT)
Received: from e119886-lin.cambridge.arm.com (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5A66C3F6C4;
 Thu,  9 May 2019 08:32:23 -0700 (PDT)
From: Andrew Murray <andrew.murray@arm.com>
To: Christoffer Dall <christoffer.dall@arm.com>,
 Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v6 3/5] KVM: arm/arm64: re-create event when setting counter
 value
Date: Thu,  9 May 2019 16:32:10 +0100
Message-Id: <20190509153212.24187-4-andrew.murray@arm.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509153212.24187-1-andrew.murray@arm.com>
References: <20190509153212.24187-1-andrew.murray@arm.com>
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

The perf event sample_period is currently set based upon the current
counter value, when PMXEVTYPER is written to and the perf event is created.
However the user may choose to write the type before the counter value in
which case sample_period will be set incorrectly. Let's instead decouple
event creation from PMXEVTYPER and (re)create the event in either
suitation.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 virt/kvm/arm/pmu.c | 42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 6e7c179103a6..ae1e886d4a1a 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -24,6 +24,7 @@
 #include <kvm/arm_pmu.h>
 #include <kvm/arm_vgic.h>
 
+static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
 /**
  * kvm_pmu_get_counter_value - get PMU counter value
  * @vcpu: The vcpu pointer
@@ -62,6 +63,9 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
 	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
 	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
+
+	/* Recreate the perf event to reflect the updated sample_period */
+	kvm_pmu_create_perf_event(vcpu, select_idx);
 }
 
 /**
@@ -378,23 +382,21 @@ static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
 }
 
 /**
- * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
+ * kvm_pmu_create_perf_event - create a perf event for a counter
  * @vcpu: The vcpu pointer
- * @data: The data guest writes to PMXEVTYPER_EL0
  * @select_idx: The number of selected counter
- *
- * When OS accesses PMXEVTYPER_EL0, that means it wants to set a PMC to count an
- * event with given hardware event number. Here we call perf_event API to
- * emulate this action and create a kernel perf event for it.
  */
-void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
-				    u64 select_idx)
+static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 {
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
 	struct perf_event *event;
 	struct perf_event_attr attr;
-	u64 eventsel, counter;
+	u64 eventsel, counter, reg, data;
+
+	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
+	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
+	data = __vcpu_sys_reg(vcpu, reg);
 
 	kvm_pmu_stop_counter(vcpu, pmc);
 	eventsel = data & ARMV8_PMU_EVTYPE_EVENT;
@@ -431,6 +433,28 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 	pmc->perf_event = event;
 }
 
+/**
+ * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
+ * @vcpu: The vcpu pointer
+ * @data: The data guest writes to PMXEVTYPER_EL0
+ * @select_idx: The number of selected counter
+ *
+ * When OS accesses PMXEVTYPER_EL0, that means it wants to set a PMC to count an
+ * event with given hardware event number. Here we call perf_event API to
+ * emulate this action and create a kernel perf event for it.
+ */
+void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
+				    u64 select_idx)
+{
+	u64 reg, event_type = data & ARMV8_PMU_EVTYPE_MASK;
+
+	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
+	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
+
+	__vcpu_sys_reg(vcpu, reg) = event_type;
+	kvm_pmu_create_perf_event(vcpu, select_idx);
+}
+
 bool kvm_arm_support_pmu_v3(void)
 {
 	/*
-- 
2.21.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
