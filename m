Return-Path: <SRS0=41R7=3N=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50BF8C3F68F
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jan 2020 14:26:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 02637214AF
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jan 2020 14:26:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="br5PTrl9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02637214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 868074AF21;
	Fri, 24 Jan 2020 09:26:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id guSufZsXO08d; Fri, 24 Jan 2020 09:26:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42BE24AF27;
	Fri, 24 Jan 2020 09:26:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D91424AF12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jan 2020 09:26:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sgBqEaxAbGR7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jan 2020 09:25:59 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D759D4AF16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jan 2020 09:25:59 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1579875959;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=xEAR2ehPaQzmdLsxl6jN1GkcQCw47IKxWzKDNWjBegA=;
 b=br5PTrl9vCkuX2s36IS8f1ksZNhhlxch8kRIPDL5bjwx/3OvpCtCKUNdxCfgeeIbnYetuo
 LeTv8nVn1ZTwbbYyH+bWs7SH4L+d0pokTpgIo0JMrZdwcmswkPZ2sFKxpQoMeasajHhsca
 3xfcFhnSmn0WhQYHhYlU5eRrJgNBDp8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-Cr5zoAp6OrGBIatgqhhFPQ-1; Fri, 24 Jan 2020 09:25:53 -0500
X-MC-Unique: Cr5zoAp6OrGBIatgqhhFPQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2EBEA801A29;
 Fri, 24 Jan 2020 14:25:52 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 92E6619C69;
 Fri, 24 Jan 2020 14:25:49 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH 2/4] KVM: arm64: pmu: Don't mark a counter as chained if the
 odd one is disabled
Date: Fri, 24 Jan 2020 15:25:33 +0100
Message-Id: <20200124142535.29386-3-eric.auger@redhat.com>
In-Reply-To: <20200124142535.29386-1-eric.auger@redhat.com>
References: <20200124142535.29386-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: andrew.murray@arm.com
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

At the moment we update the chain bitmap on type setting. This
does not take into account the enable state of the odd register.

Let's make sure a counter is never considered as chained if
the high counter is disabled.

We recompute the chain state on enable/disable and type changes.

Also let create_perf_event() use the chain bitmap and not use
kvm_pu_idx_has_chain_evtype().

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Suggested-by: Marc Zyngier <maz@kernel.org>
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
 
-	if (kvm_pmu_idx_has_chain_evtype(vcpu, pmc->idx)) {
+	old_state = kvm_pmu_pmc_is_chained(pmc);
+	new_state = kvm_pmu_idx_has_chain_evtype(vcpu, pmc->idx) &&
+		    kvm_pmu_counter_is_enabled(vcpu, pmc->idx | 0x1);
+
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
