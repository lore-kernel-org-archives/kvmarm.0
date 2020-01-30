Return-Path: <SRS0=cl91=3T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F0F4C35240
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 13:29:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2422C214DB
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 13:29:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="oUED5L20"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2422C214DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC99D4AEDD;
	Thu, 30 Jan 2020 08:29:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dtTVAR8P-E5o; Thu, 30 Jan 2020 08:29:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69DD84AEC0;
	Thu, 30 Jan 2020 08:29:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7188C4A551
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 08:29:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id actx3JzeH6xg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jan 2020 08:29:22 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 16B5C4AC6C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 08:29:22 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2F2C0215A4;
 Thu, 30 Jan 2020 13:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1580390961;
 bh=d9x4S66Ey4CIXpCN2s+iO/2nx8679dBTfse6yMAAItQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=oUED5L20w0DXl6v03FB5E2BPimGugCRBnWPHHJHPJ/MsPLpd52iJ7uMY7PsIsPWaX
 8uL8O+iHx9IPYmeAi8P2WOqS+yzGmmWuXXKqhd4E2cfgVIkYzdtdOH0fc3sI51hByf
 eSEV75hULqGBqPU16B+lyfXHAXYKUi1mGXHNzosU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1ix9q4-002BmW-0Q; Thu, 30 Jan 2020 13:26:32 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 20/23] KVM: arm64: pmu: Don't mark a counter as chained if the
 odd one is disabled
Date: Thu, 30 Jan 2020 13:25:55 +0000
Message-Id: <20200130132558.10201-21-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200130132558.10201-1-maz@kernel.org>
References: <20200130132558.10201-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 drjones@redhat.com, andrew.murray@arm.com, beata.michalska@linaro.org,
 christoffer.dall@arm.com, eric.auger@redhat.com, gshan@redhat.com,
 wanghaibin.wang@huawei.com, james.morse@arm.com, broonie@kernel.org,
 mark.rutland@arm.com, rmk+kernel@armlinux.org.uk,
 shannon.zhao@linux.alibaba.com, steven.price@arm.com, will@kernel.org,
 yuehaibing@huawei.com, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 YueHaibing <yuehaibing@huawei.com>, Steven Price <steven.price@arm.com>,
 Shannon Zhao <shannon.zhao@linux.alibaba.com>,
 Russell King <rmk+kernel@armlinux.org.uk>, Mark Brown <broonie@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Andrew Murray <andrew.murray@arm.com>
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

From: Eric Auger <eric.auger@redhat.com>

At the moment we update the chain bitmap on type setting. This
does not take into account the enable state of the odd register.

Let's make sure a counter is never considered as chained if
the high counter is disabled.

We recompute the chain state on enable/disable and type changes.

Also let create_perf_event() use the chain bitmap and not use
kvm_pmu_idx_has_chain_evtype().

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200124142535.29386-3-eric.auger@redhat.com
---
 virt/kvm/arm/pmu.c | 62 ++++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 29 deletions(-)

diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index c3f8b059881e..9f605e0b8dd7 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -15,6 +15,8 @@
 #include <kvm/arm_vgic.h>
 
 static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
+static void kvm_pmu_update_pmc_chained(struct kvm_vcpu *vcpu, u64 select_idx);
+static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
 
 #define PERF_ATTR_CFG1_KVM_PMU_CHAINED 0x1
 
@@ -75,6 +77,13 @@ static struct kvm_pmc *kvm_pmu_get_canonical_pmc(struct kvm_pmc *pmc)
 
 	return pmc;
 }
+static struct kvm_pmc *kvm_pmu_get_alternate_pmc(struct kvm_pmc *pmc)
+{
+	if (kvm_pmu_idx_is_high_counter(pmc->idx))
+		return pmc - 1;
+	else
+		return pmc + 1;
+}
 
 /**
  * kvm_pmu_idx_has_chain_evtype - determine if the event type is chain
@@ -294,15 +303,9 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 
 		pmc = &pmu->pmc[i];
 
-		/*
-		 * For high counters of chained events we must recreate the
-		 * perf event with the long (64bit) attribute set.
-		 */
-		if (kvm_pmu_pmc_is_chained(pmc) &&
-		    kvm_pmu_idx_is_high_counter(i)) {
-			kvm_pmu_create_perf_event(vcpu, i);
-			continue;
-		}
+		/* A change in the enable state may affect the chain state */
+		kvm_pmu_update_pmc_chained(vcpu, i);
+		kvm_pmu_create_perf_event(vcpu, i);
 
 		/* At this point, pmc must be the canonical */
 		if (pmc->perf_event) {
@@ -335,15 +338,9 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 
 		pmc = &pmu->pmc[i];
 
-		/*
-		 * For high counters of chained events we must recreate the
-		 * perf event with the long (64bit) attribute unset.
-		 */
-		if (kvm_pmu_pmc_is_chained(pmc) &&
-		    kvm_pmu_idx_is_high_counter(i)) {
-			kvm_pmu_create_perf_event(vcpu, i);
-			continue;
-		}
+		/* A change in the enable state may affect the chain state */
+		kvm_pmu_update_pmc_chained(vcpu, i);
+		kvm_pmu_create_perf_event(vcpu, i);
 
 		/* At this point, pmc must be the canonical */
 		if (pmc->perf_event)
@@ -585,15 +582,14 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 
 	counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
 
-	if (kvm_pmu_idx_has_chain_evtype(vcpu, pmc->idx)) {
+	if (kvm_pmu_pmc_is_chained(pmc)) {
 		/**
 		 * The initial sample period (overflow count) of an event. For
 		 * chained counters we only support overflow interrupts on the
 		 * high counter.
 		 */
 		attr.sample_period = (-counter) & GENMASK(63, 0);
-		if (kvm_pmu_counter_is_enabled(vcpu, pmc->idx + 1))
-			attr.config1 |= PERF_ATTR_CFG1_KVM_PMU_CHAINED;
+		attr.config1 |= PERF_ATTR_CFG1_KVM_PMU_CHAINED;
 
 		event = perf_event_create_kernel_counter(&attr, -1, current,
 							 kvm_pmu_perf_overflow,
@@ -624,25 +620,33 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
  * @select_idx: The number of selected counter
  *
  * Update the chained bitmap based on the event type written in the
- * typer register.
+ * typer register and the enable state of the odd register.
  */
 static void kvm_pmu_update_pmc_chained(struct kvm_vcpu *vcpu, u64 select_idx)
 {
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
-	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
+	struct kvm_pmc *pmc = &pmu->pmc[select_idx], *canonical_pmc;
+	bool new_state, old_state;
+
+	old_state = kvm_pmu_pmc_is_chained(pmc);
+	new_state = kvm_pmu_idx_has_chain_evtype(vcpu, pmc->idx) &&
+		    kvm_pmu_counter_is_enabled(vcpu, pmc->idx | 0x1);
 
-	if (kvm_pmu_idx_has_chain_evtype(vcpu, pmc->idx)) {
+	if (old_state == new_state)
+		return;
+
+	canonical_pmc = kvm_pmu_get_canonical_pmc(pmc);
+	kvm_pmu_stop_counter(vcpu, canonical_pmc);
+	if (new_state) {
 		/*
 		 * During promotion from !chained to chained we must ensure
 		 * the adjacent counter is stopped and its event destroyed
 		 */
-		if (!kvm_pmu_pmc_is_chained(pmc))
-			kvm_pmu_stop_counter(vcpu, pmc);
-
+		kvm_pmu_stop_counter(vcpu, kvm_pmu_get_alternate_pmc(pmc));
 		set_bit(pmc->idx >> 1, vcpu->arch.pmu.chained);
-	} else {
-		clear_bit(pmc->idx >> 1, vcpu->arch.pmu.chained);
+		return;
 	}
+	clear_bit(pmc->idx >> 1, vcpu->arch.pmu.chained);
 }
 
 /**
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
