Return-Path: <SRS0=hkx2=G5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24145C433E9
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 15:16:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C11F5206B5
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 15:16:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C11F5206B5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 601E04B2EA;
	Tue, 26 Jan 2021 10:16:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wVh0R9WQrdUG; Tue, 26 Jan 2021 10:16:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 983964B2F0;
	Tue, 26 Jan 2021 10:16:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC2324B2D2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 10:16:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 56-3R9guU3wN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2021 10:16:10 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C1A454B29E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 10:16:10 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B82CC23109;
 Tue, 26 Jan 2021 15:16:09 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l4Q4e-00A9nZ-29; Tue, 26 Jan 2021 15:16:08 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH 1/2] KVM: arm64: Turn kvm_arm_support_pmu_v3() into a static
 key
Date: Tue, 26 Jan 2021 15:15:20 +0000
Message-Id: <20210126151521.2958688-2-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126151521.2958688-1-maz@kernel.org>
References: <20210126151521.2958688-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, andre.przywara@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Andre Przywara <andre.przywara@arm.com>, kernel-team@android.com
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

We currently find out about the presence of a HW PMU (or the handling
of that PMU by perf, which amounts to the same thing) in a fairly
roundabout way, by checking the number of counters available to perf.
That's good enough for now, but we will soon need to find about about
that on paths where perf is out of reach (in the world switch).

Instead, let's turn kvm_arm_support_pmu_v3() into a static key.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/perf.c     | 10 ++++++++++
 arch/arm64/kvm/pmu-emul.c | 10 ----------
 include/kvm/arm_pmu.h     |  9 +++++++--
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/perf.c b/arch/arm64/kvm/perf.c
index d45b8b9a4415..198fa4266b2d 100644
--- a/arch/arm64/kvm/perf.c
+++ b/arch/arm64/kvm/perf.c
@@ -11,6 +11,8 @@
 
 #include <asm/kvm_emulate.h>
 
+DEFINE_STATIC_KEY_FALSE(kvm_arm_pmu_available);
+
 static int kvm_is_in_guest(void)
 {
         return kvm_get_running_vcpu() != NULL;
@@ -48,6 +50,14 @@ static struct perf_guest_info_callbacks kvm_guest_cbs = {
 
 int kvm_perf_init(void)
 {
+	/*
+	 * Check if HW_PERF_EVENTS are supported by checking the number of
+	 * hardware performance counters. This could ensure the presence of
+	 * a physical PMU and CONFIG_PERF_EVENT is selected.
+	 */
+	if (perf_num_counters() > 0)
+		static_branch_enable(&kvm_arm_pmu_available);
+
 	return perf_register_guest_info_callbacks(&kvm_guest_cbs);
 }
 
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 4ad66a532e38..44d500706ab9 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -813,16 +813,6 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 	return val & mask;
 }
 
-bool kvm_arm_support_pmu_v3(void)
-{
-	/*
-	 * Check if HW_PERF_EVENTS are supported by checking the number of
-	 * hardware performance counters. This could ensure the presence of
-	 * a physical PMU and CONFIG_PERF_EVENT is selected.
-	 */
-	return (perf_num_counters() > 0);
-}
-
 int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_vcpu_has_pmu(vcpu))
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 8dcb3e1477bc..6fd3cda608e4 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -13,6 +13,13 @@
 #define ARMV8_PMU_CYCLE_IDX		(ARMV8_PMU_MAX_COUNTERS - 1)
 #define ARMV8_PMU_MAX_COUNTER_PAIRS	((ARMV8_PMU_MAX_COUNTERS + 1) >> 1)
 
+DECLARE_STATIC_KEY_FALSE(kvm_arm_pmu_available);
+
+static __always_inline bool kvm_arm_support_pmu_v3(void)
+{
+	return static_branch_likely(&kvm_arm_pmu_available);
+}
+
 #ifdef CONFIG_HW_PERF_EVENTS
 
 struct kvm_pmc {
@@ -47,7 +54,6 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx);
-bool kvm_arm_support_pmu_v3(void);
 int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu,
 			    struct kvm_device_attr *attr);
 int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu,
@@ -87,7 +93,6 @@ static inline void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu,
 						  u64 data, u64 select_idx) {}
-static inline bool kvm_arm_support_pmu_v3(void) { return false; }
 static inline int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu,
 					  struct kvm_device_attr *attr)
 {
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
