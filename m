Return-Path: <SRS0=wAvJ=UQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7710C31E5B
	for <kvmarm@archiver.kernel.org>; Mon, 17 Jun 2019 19:01:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A5437206B7
	for <kvmarm@archiver.kernel.org>; Mon, 17 Jun 2019 19:01:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5437206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60E7E4A4EB;
	Mon, 17 Jun 2019 15:01:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 39p4f2ynN+tf; Mon, 17 Jun 2019 15:01:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A60054A531;
	Mon, 17 Jun 2019 15:01:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83ABA4A51D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jun 2019 15:01:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e5T0yKc5H9jp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Jun 2019 15:01:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 761294A529
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jun 2019 15:01:21 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E8402B;
 Mon, 17 Jun 2019 12:01:21 -0700 (PDT)
Received: from e119886-lin.cambridge.arm.com (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C468A3F246;
 Mon, 17 Jun 2019 12:01:19 -0700 (PDT)
From: Andrew Murray <andrew.murray@arm.com>
To: Christoffer Dall <christoffer.dall@arm.com>,
 Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v10 4/5] KVM: arm/arm64: remove pmc->bitmask
Date: Mon, 17 Jun 2019 20:01:04 +0100
Message-Id: <20190617190105.4662-5-andrew.murray@arm.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617190105.4662-1-andrew.murray@arm.com>
References: <20190617190105.4662-1-andrew.murray@arm.com>
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

We currently use pmc->bitmask to determine the width of the pmc - however
it's superfluous as the pmc index already describes if the pmc is a cycle
counter or event counter. The architecture clearly describes the widths of
these counters.

Let's remove the bitmask to simplify the code.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 include/kvm/arm_pmu.h |  1 -
 virt/kvm/arm/pmu.c    | 30 ++++++++++++++++++++----------
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index b73f31baca52..2f0e28dc5a9e 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -28,7 +28,6 @@
 struct kvm_pmc {
 	u8 idx;	/* index into the pmu->pmc array */
 	struct perf_event *perf_event;
-	u64 bitmask;
 };
 
 struct kvm_pmu {
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index ae1e886d4a1a..0588ad0ddb77 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -25,6 +25,18 @@
 #include <kvm/arm_vgic.h>
 
 static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
+
+/**
+ * kvm_pmu_idx_is_64bit - determine if select_idx is a 64bit counter
+ * @vcpu: The vcpu pointer
+ * @select_idx: The counter index
+ */
+static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
+{
+	return (select_idx == ARMV8_PMU_CYCLE_IDX &&
+		__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
+}
+
 /**
  * kvm_pmu_get_counter_value - get PMU counter value
  * @vcpu: The vcpu pointer
@@ -47,7 +59,10 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
 		counter += perf_event_read_value(pmc->perf_event, &enabled,
 						 &running);
 
-	return counter & pmc->bitmask;
+	if (!kvm_pmu_idx_is_64bit(vcpu, select_idx))
+		counter = lower_32_bits(counter);
+
+	return counter;
 }
 
 /**
@@ -113,7 +128,6 @@ void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
 	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
 		kvm_pmu_stop_counter(vcpu, &pmu->pmc[i]);
 		pmu->pmc[i].idx = i;
-		pmu->pmc[i].bitmask = 0xffffffffUL;
 	}
 }
 
@@ -348,8 +362,6 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
  */
 void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 {
-	struct kvm_pmu *pmu = &vcpu->arch.pmu;
-	struct kvm_pmc *pmc;
 	u64 mask;
 	int i;
 
@@ -368,11 +380,6 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 		for (i = 0; i < ARMV8_PMU_CYCLE_IDX; i++)
 			kvm_pmu_set_counter_value(vcpu, i, 0);
 	}
-
-	if (val & ARMV8_PMU_PMCR_LC) {
-		pmc = &pmu->pmc[ARMV8_PMU_CYCLE_IDX];
-		pmc->bitmask = 0xffffffffffffffffUL;
-	}
 }
 
 static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
@@ -420,7 +427,10 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 
 	counter = kvm_pmu_get_counter_value(vcpu, select_idx);
 	/* The initial sample period (overflow count) of an event. */
-	attr.sample_period = (-counter) & pmc->bitmask;
+	if (kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
+		attr.sample_period = (-counter) & GENMASK(63, 0);
+	else
+		attr.sample_period = (-counter) & GENMASK(31, 0);
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
 						 kvm_pmu_perf_overflow, pmc);
-- 
2.21.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
