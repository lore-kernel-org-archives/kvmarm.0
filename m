Return-Path: <SRS0=r5x+=SR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 380D2C10F12
	for <kvmarm@archiver.kernel.org>; Mon, 15 Apr 2019 15:08:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BB60D217D6
	for <kvmarm@archiver.kernel.org>; Mon, 15 Apr 2019 15:08:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB60D217D6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2057A4A48E;
	Mon, 15 Apr 2019 11:08:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YItNTTqcSTXt; Mon, 15 Apr 2019 11:08:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B06A14A4BD;
	Mon, 15 Apr 2019 11:08:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E13B54A48E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 11:08:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jme017tBzOi1 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Apr 2019 11:08:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 219954A48D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 11:08:41 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6BE04374;
 Mon, 15 Apr 2019 08:08:40 -0700 (PDT)
Received: from [10.1.196.92] (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 08B893F68F; Mon, 15 Apr 2019 08:08:38 -0700 (PDT)
Subject: Re: [PATCH v4 6/6] KVM: arm/arm64: support chained PMU counters
To: Andrew Murray <andrew.murray@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>
References: <20190325183006.33115-1-andrew.murray@arm.com>
 <20190325183006.33115-7-andrew.murray@arm.com>
From: Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
Organization: ARM Ltd
Message-ID: <a4309294-5be7-c758-e1bb-52861a231520@arm.com>
Date: Mon, 15 Apr 2019 16:08:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190325183006.33115-7-andrew.murray@arm.com>
Content-Language: en-US
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190415150837.NN5nNVzZSy0EILj_x-eaP6J1YgsAJBd-o6PKsKi1hIc@z>

On 25/03/2019 18:30, Andrew Murray wrote:
> Emulate chained PMU counters by creating a single 64 bit event counter
> for a pair of chained KVM counters.
> 
> Please note that overflow interrupts are only supported on the high
> counter of a chained counter pair.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>

Hi Andrew,

Sorry it's been a long time coming, but I finally got some bandwidth to 
have a look at this.

My main issue with the whole thing is that you create new abstractions 
that do not match the HW. Nowhere in the architecture there is the 
notion of "counter pair". You also duplicate some state in the sense 
that your new chain_event duplicates existing data structures (the 
perf_event pointer that exists in each and every PMC).

What I'm proposing is a slightly simpler approach that:

- tracks which "pair" of counters is actually chained
- for any counter, allow a "canonical" counter to be obtained: the low-
order counter if chained, and the counter itself otherwise
- the canonical counter is always holding the perf_event

Have a look at the patch below which applies on top of this series. I've 
only compile-tested it, so it is likely completely broken. Hopefully 
you'll see what I'm aiming for.

Thanks,

	M.

diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index ce5f380a6699..8b434745500a 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -32,21 +32,10 @@ struct kvm_pmc {
 	u64 bitmask;
 };
 
-enum kvm_pmc_type {
-	KVM_PMC_TYPE_PAIR,
-	KVM_PMC_TYPE_CHAIN,
-};
-
-struct kvm_pmc_pair {
-	struct kvm_pmc low;
-	struct kvm_pmc high;
-	enum kvm_pmc_type type;
-	struct perf_event *chain_event;
-};
-
 struct kvm_pmu {
 	int irq_num;
-	struct kvm_pmc_pair pmc_pair[ARMV8_PMU_MAX_COUNTER_PAIRS];
+	struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
+	DECLARE_BITMAP(chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
 	bool ready;
 	bool created;
 	bool irq_level;
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 3a0f1e66c759..f3b86d1d401a 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -28,6 +28,28 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
 
 #define PERF_ATTR_CFG1_KVM_PMU_CHAINED 0x1
 
+static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
+{
+	struct kvm_pmu *pmu;
+	struct kvm_vcpu_arch *vcpu_arch;
+
+	pmc -= pmc->idx;
+	pmu = container_of(pmc, struct kvm_pmu, pmc[0]);
+	vcpu_arch = container_of(pmu, struct kvm_vcpu_arch, pmu);
+	return container_of(vcpu_arch, struct kvm_vcpu, arch);
+}
+
+/**
+ * kvm_pmu_pair_is_chained - determine if the pair is a chain
+ * @pmc: The PMU counter pointer
+ */
+static bool kvm_pmu_pair_is_chained(struct kvm_pmc *pmc)
+{
+	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
+
+	return test_bit(pmc->idx >> 1, vcpu->arch.pmu.chained);
+}
+
 /**
  * kvm_pmu_pair_is_high_counter - determine if select_idx is a high/low counter
  * @select_idx: The counter index
@@ -37,16 +59,12 @@ static bool kvm_pmu_pair_is_high_counter(u64 select_idx)
 	return select_idx & 0x1;
 }
 
-/**
- * kvm_pmu_get_kvm_pmc_pair - obtain a pmc_pair from a pmc
- * @pmc: The PMU counter pointer
- */
-static struct kvm_pmc_pair *kvm_pmu_get_kvm_pmc_pair(struct kvm_pmc *pmc)
+static struct kvm_pmc *kvm_pmu_get_canonical_pmc(struct kvm_pmc *pmc)
 {
-	if (kvm_pmu_pair_is_high_counter(pmc->idx))
-		return container_of(pmc, struct kvm_pmc_pair, high);
-	else
-		return container_of(pmc, struct kvm_pmc_pair, low);
+	if (kvm_pmu_pair_is_chained(pmc) && (pmc->idx & 1))
+		return pmc - 1;
+
+	return pmc;
 }
 
 /**
@@ -58,21 +76,7 @@ static struct kvm_pmc *kvm_pmu_get_kvm_pmc(struct kvm_vcpu *vcpu,
 					   u64 select_idx)
 {
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
-	struct kvm_pmc_pair *pmc_pair = &pmu->pmc_pair[select_idx >> 1];
-
-	return kvm_pmu_pair_is_high_counter(select_idx) ? &pmc_pair->high
-							: &pmc_pair->low;
-}
-
-/**
- * kvm_pmu_pair_is_chained - determine if the pair is a chain
- * @pmc: The PMU counter pointer
- */
-static bool kvm_pmu_pair_is_chained(struct kvm_pmc *pmc)
-{
-	struct kvm_pmc_pair *pmc_pair = kvm_pmu_get_kvm_pmc_pair(pmc);
-
-	return (pmc_pair->type == KVM_PMC_TYPE_CHAIN);
+	return &pmu->pmc[select_idx];
 }
 
 /**
@@ -104,12 +108,7 @@ static bool kvm_pmu_event_is_chained(struct kvm_vcpu *vcpu, u64 select_idx)
  */
 static struct perf_event *kvm_pmu_get_perf_event(struct kvm_pmc *pmc)
 {
-	struct kvm_pmc_pair *pmc_pair = kvm_pmu_get_kvm_pmc_pair(pmc);
-
-	if (kvm_pmu_pair_is_chained(pmc))
-		return pmc_pair->chain_event;
-
-	return pmc->perf_event;
+	return kvm_pmu_get_canonical_pmc(pmc)->perf_event;
 }
 
 /**
@@ -123,12 +122,7 @@ static struct perf_event *kvm_pmu_get_perf_event(struct kvm_pmc *pmc)
 static void kvm_pmu_set_perf_event(struct kvm_pmc *pmc,
 				   struct perf_event *perf_event)
 {
-	struct kvm_pmc_pair *pmc_pair = kvm_pmu_get_kvm_pmc_pair(pmc);
-
-	if (kvm_pmu_pair_is_chained(pmc))
-		pmc_pair->chain_event = perf_event;
-	else
-		pmc->perf_event = perf_event;
+	kvm_pmu_get_canonical_pmc(pmc)->perf_event = perf_event;
 }
 
 /**
@@ -141,14 +135,13 @@ static u64 kvm_pmu_get_pair_counter_value(struct kvm_vcpu *vcpu,
 {
 	u64 counter, counter_high, reg, enabled, running;
 	struct perf_event *perf_event = kvm_pmu_get_perf_event(pmc);
-	struct kvm_pmc_pair *pmc_pair = kvm_pmu_get_kvm_pmc_pair(pmc);
 
 	if (kvm_pmu_pair_is_chained(pmc)) {
-		reg = PMEVCNTR0_EL0 + pmc_pair->low.idx;
+		pmc = kvm_pmu_get_canonical_pmc(pmc);
+		reg = PMEVCNTR0_EL0 + pmc->idx;
 		counter = __vcpu_sys_reg(vcpu, reg);
 
-		reg = PMEVCNTR0_EL0 + pmc_pair->high.idx;
-		counter_high = __vcpu_sys_reg(vcpu, reg);
+		counter_high = __vcpu_sys_reg(vcpu, reg + 1);
 
 		counter = lower_32_bits(counter) | (counter_high << 32);
 	} else {
@@ -233,22 +226,18 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
 {
 	u64 counter, counter_low, counter_high, reg;
 	struct perf_event *perf_event = kvm_pmu_get_perf_event(pmc);
-	struct kvm_pmc_pair *pmc_pair = kvm_pmu_get_kvm_pmc_pair(pmc);
 
 	if (!perf_event)
 		return;
 
 	if (kvm_pmu_pair_is_chained(pmc)) {
-		counter_low = kvm_pmu_get_counter_value(
-					vcpu, pmc_pair->low.idx);
-		counter_high = kvm_pmu_get_counter_value(
-					vcpu, pmc_pair->high.idx);
+		pmc = kvm_pmu_get_canonical_pmc(pmc);
+		counter_low = kvm_pmu_get_counter_value(vcpu, pmc->idx);
+		counter_high = kvm_pmu_get_counter_value(vcpu, pmc->idx + 1);
 
-		reg = PMEVCNTR0_EL0 + pmc_pair->low.idx;
+		reg = PMEVCNTR0_EL0 + pmc->idx;
 		__vcpu_sys_reg(vcpu, reg) = counter_low;
-
-		reg = PMEVCNTR0_EL0 + pmc_pair->high.idx;
-		__vcpu_sys_reg(vcpu, reg) = counter_high;
+		__vcpu_sys_reg(vcpu, reg + 1) = counter_high;
 	} else {
 		counter = kvm_pmu_get_counter_value(vcpu, pmc->idx);
 		reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
@@ -268,17 +257,15 @@ void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
 {
 	int i;
 	struct kvm_pmc *pmc;
-	struct kvm_pmc_pair *pmc_pair;
 
 	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
 		pmc = kvm_pmu_get_kvm_pmc(vcpu, i);
 		kvm_pmu_stop_counter(vcpu, pmc);
 		pmc->idx = i;
 		pmc->bitmask = 0xffffffffUL;
-
-		pmc_pair = kvm_pmu_get_kvm_pmc_pair(pmc);
-		pmc_pair->type = KVM_PMC_TYPE_PAIR;
 	}
+
+	bitmap_zero(vcpu->arch.pmu.chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
 }
 
 /**
@@ -471,18 +458,6 @@ void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu)
 	kvm_pmu_update_state(vcpu);
 }
 
-static inline struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
-{
-	struct kvm_pmu *pmu;
-	struct kvm_vcpu_arch *vcpu_arch;
-	struct kvm_pmc_pair *pair = kvm_pmu_get_kvm_pmc_pair(pmc);
-
-	pair -= (pmc->idx >> 1);
-	pmu = container_of(pair, struct kvm_pmu, pmc_pair[0]);
-	vcpu_arch = container_of(pmu, struct kvm_vcpu_arch, pmu);
-	return container_of(vcpu_arch, struct kvm_vcpu, arch);
-}
-
 /**
  * When the perf event overflows, set the overflow status and inform the vcpu.
  */
@@ -579,7 +554,6 @@ static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
 static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 {
 	struct kvm_pmc *pmc = kvm_pmu_get_kvm_pmc(vcpu, select_idx);
-	struct kvm_pmc_pair *pmc_pair = kvm_pmu_get_kvm_pmc_pair(pmc);
 	struct perf_event *event;
 	struct perf_event_attr attr;
 	u64 eventsel, counter, reg, data;
@@ -619,6 +593,8 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 	counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
 
 	if (kvm_pmu_event_is_chained(vcpu, pmc->idx)) {
+		struct kvm_pmc *canonical = kvm_pmu_get_canonical_pmc(pmc);
+
 		/**
 		 * The initial sample period (overflow count) of an event. For
 		 * chained counters we only support overflow interrupts on the
@@ -627,9 +603,9 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 		attr.sample_period = (-counter) & 0xffffffffffffffffUL;
 		event = perf_event_create_kernel_counter(&attr, -1, current,
 							 kvm_pmu_perf_overflow,
-							 &pmc_pair->high);
+							 canonical + 1);
 
-		if (kvm_pmu_counter_is_enabled(vcpu, pmc_pair->high.idx))
+		if (kvm_pmu_counter_is_enabled(vcpu, canonical->idx + 1))
 			attr.config1 |= PERF_ATTR_CFG1_KVM_PMU_CHAINED;
 	} else {
 		/* The initial sample period (overflow count) of an event. */
@@ -657,7 +633,6 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 static void kvm_pmu_update_kvm_pmc_type(struct kvm_vcpu *vcpu, u64 select_idx)
 {
 	struct kvm_pmc *pmc = kvm_pmu_get_kvm_pmc(vcpu, select_idx);
-	struct kvm_pmc_pair *pmc_pair = kvm_pmu_get_kvm_pmc_pair(pmc);
 
 	if (kvm_pmu_event_is_chained(vcpu, pmc->idx)) {
 		/*
@@ -665,11 +640,12 @@ static void kvm_pmu_update_kvm_pmc_type(struct kvm_vcpu *vcpu, u64 select_idx)
 		 * the adjacent counter is stopped and its event destroyed
 		 */
 		if (!kvm_pmu_pair_is_chained(pmc))
-			kvm_pmu_stop_counter(vcpu, &pmc_pair->low);
+			kvm_pmu_stop_counter(vcpu,
+					     kvm_pmu_get_canonical_pmc(pmc));
 
-		pmc_pair->type = KVM_PMC_TYPE_CHAIN;
+		set_bit(pmc->idx >> 1, vcpu->arch.pmu.chained);
 	} else {
-		pmc_pair->type = KVM_PMC_TYPE_PAIR;
+		clear_bit(pmc->idx >> 1, vcpu->arch.pmu.chained);
 	}
 }
 

-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
