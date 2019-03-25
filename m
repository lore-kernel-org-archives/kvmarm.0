From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v4 6/6] KVM: arm/arm64: support chained PMU counters
Date: Mon, 25 Mar 2019 18:30:06 +0000
Message-ID: <20190325183006.33115-7-andrew.murray@arm.com>
References: <20190325183006.33115-1-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27E354A34E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Mar 2019 14:30:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QGEf+yj8OmCC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Mar 2019 14:30:24 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E7554A46E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Mar 2019 14:30:24 -0400 (EDT)
In-Reply-To: <20190325183006.33115-1-andrew.murray@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Emulate chained PMU counters by creating a single 64 bit event counter
for a pair of chained KVM counters.

Please note that overflow interrupts are only supported on the high
counter of a chained counter pair.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 include/kvm/arm_pmu.h |   2 +
 virt/kvm/arm/pmu.c    | 256 +++++++++++++++++++++++++++++++++++++-----
 2 files changed, 231 insertions(+), 27 deletions(-)

diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index ee80dc8db990..ce5f380a6699 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -34,12 +34,14 @@ struct kvm_pmc {
 
 enum kvm_pmc_type {
 	KVM_PMC_TYPE_PAIR,
+	KVM_PMC_TYPE_CHAIN,
 };
 
 struct kvm_pmc_pair {
 	struct kvm_pmc low;
 	struct kvm_pmc high;
 	enum kvm_pmc_type type;
+	struct perf_event *chain_event;
 };
 
 struct kvm_pmu {
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 08acd60c538a..3a0f1e66c759 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -26,6 +26,8 @@
 
 static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
 
+#define PERF_ATTR_CFG1_KVM_PMU_CHAINED 0x1
+
 /**
  * kvm_pmu_pair_is_high_counter - determine if select_idx is a high/low counter
  * @select_idx: The counter index
@@ -62,6 +64,113 @@ static struct kvm_pmc *kvm_pmu_get_kvm_pmc(struct kvm_vcpu *vcpu,
 							: &pmc_pair->low;
 }
 
+/**
+ * kvm_pmu_pair_is_chained - determine if the pair is a chain
+ * @pmc: The PMU counter pointer
+ */
+static bool kvm_pmu_pair_is_chained(struct kvm_pmc *pmc)
+{
+	struct kvm_pmc_pair *pmc_pair = kvm_pmu_get_kvm_pmc_pair(pmc);
+
+	return (pmc_pair->type == KVM_PMC_TYPE_CHAIN);
+}
+
+/**
+ * kvm_pmu_event_is_chained - determine if the event type is chain
+ * @vcpu: The vcpu pointer
+ * @select_idx: The counter index
+ */
+static bool kvm_pmu_event_is_chained(struct kvm_vcpu *vcpu, u64 select_idx)
+{
+	u64 eventsel, reg;
+
+	select_idx |= 0x1;
+
+	if (select_idx == ARMV8_PMU_CYCLE_IDX)
+		return false;
+
+	reg = PMEVTYPER0_EL0 + select_idx;
+	eventsel = __vcpu_sys_reg(vcpu, reg) & ARMV8_PMU_EVTYPE_EVENT;
+
+	return armv8pmu_evtype_is_chain(eventsel);
+}
+
+/**
+ * kvm_pmu_get_perf_event - obtain a perf event from a pmc
+ * @pmc: The PMU counter pointer
+ *
+ * If we are handling the pmc pair as a chained pair then we return the
+ * chained event instead of the individual pmc event
+ */
+static struct perf_event *kvm_pmu_get_perf_event(struct kvm_pmc *pmc)
+{
+	struct kvm_pmc_pair *pmc_pair = kvm_pmu_get_kvm_pmc_pair(pmc);
+
+	if (kvm_pmu_pair_is_chained(pmc))
+		return pmc_pair->chain_event;
+
+	return pmc->perf_event;
+}
+
+/**
+ * kvm_pmu_set_perf_event - set a perf event to a pmc
+ * @pmc: The PMU counter pointer
+ * @perf_event: The perf event
+ *
+ * If we are handling the pmc pair as a chained pair then we set the
+ * chained event instead of the individual pmc event
+ */
+static void kvm_pmu_set_perf_event(struct kvm_pmc *pmc,
+				   struct perf_event *perf_event)
+{
+	struct kvm_pmc_pair *pmc_pair = kvm_pmu_get_kvm_pmc_pair(pmc);
+
+	if (kvm_pmu_pair_is_chained(pmc))
+		pmc_pair->chain_event = perf_event;
+	else
+		pmc->perf_event = perf_event;
+}
+
+/**
+ * kvm_pmu_get_pair_counter_value - get PMU counter value
+ * @vcpu: The vcpu pointer
+ * @pmc: The PMU counter pointer
+ */
+static u64 kvm_pmu_get_pair_counter_value(struct kvm_vcpu *vcpu,
+					  struct kvm_pmc *pmc)
+{
+	u64 counter, counter_high, reg, enabled, running;
+	struct perf_event *perf_event = kvm_pmu_get_perf_event(pmc);
+	struct kvm_pmc_pair *pmc_pair = kvm_pmu_get_kvm_pmc_pair(pmc);
+
+	if (kvm_pmu_pair_is_chained(pmc)) {
+		reg = PMEVCNTR0_EL0 + pmc_pair->low.idx;
+		counter = __vcpu_sys_reg(vcpu, reg);
+
+		reg = PMEVCNTR0_EL0 + pmc_pair->high.idx;
+		counter_high = __vcpu_sys_reg(vcpu, reg);
+
+		counter = lower_32_bits(counter) | (counter_high << 32);
+	} else {
+		reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
+		      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
+		counter = __vcpu_sys_reg(vcpu, reg);
+	}
+
+	/*
+	 * The real counter value is equal to the value of counter register plus
+	 * the value perf event counts.
+	 */
+	if (perf_event)
+		counter += perf_event_read_value(perf_event, &enabled,
+					      &running);
+
+	if (!kvm_pmu_pair_is_chained(pmc))
+		counter &= pmc->bitmask;
+
+	return counter;
+}
+
 /**
  * kvm_pmu_get_counter_value - get PMU counter value
  * @vcpu: The vcpu pointer
@@ -69,19 +178,14 @@ static struct kvm_pmc *kvm_pmu_get_kvm_pmc(struct kvm_vcpu *vcpu,
  */
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
 {
-	u64 counter, reg, enabled, running;
+	u64 counter;
 	struct kvm_pmc *pmc = kvm_pmu_get_kvm_pmc(vcpu, select_idx);
 
-	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
-	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
-	counter = __vcpu_sys_reg(vcpu, reg);
+	counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
 
-	/* The real counter value is equal to the value of counter register plus
-	 * the value perf event counts.
-	 */
-	if (pmc->perf_event)
-		counter += perf_event_read_value(pmc->perf_event, &enabled,
-						 &running);
+	if (kvm_pmu_pair_is_chained(pmc) &&
+	    kvm_pmu_pair_is_high_counter(select_idx))
+		counter >>= 32;
 
 	return counter & pmc->bitmask;
 }
@@ -110,10 +214,12 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
  */
 static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
 {
-	if (pmc->perf_event) {
-		perf_event_disable(pmc->perf_event);
-		perf_event_release_kernel(pmc->perf_event);
-		pmc->perf_event = NULL;
+	struct perf_event *perf_event = kvm_pmu_get_perf_event(pmc);
+
+	if (perf_event) {
+		perf_event_disable(perf_event);
+		perf_event_release_kernel(perf_event);
+		kvm_pmu_set_perf_event(pmc, NULL);
 	}
 }
 
@@ -125,15 +231,32 @@ static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
  */
 static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
 {
-	u64 counter, reg;
+	u64 counter, counter_low, counter_high, reg;
+	struct perf_event *perf_event = kvm_pmu_get_perf_event(pmc);
+	struct kvm_pmc_pair *pmc_pair = kvm_pmu_get_kvm_pmc_pair(pmc);
+
+	if (!perf_event)
+		return;
 
-	if (pmc->perf_event) {
+	if (kvm_pmu_pair_is_chained(pmc)) {
+		counter_low = kvm_pmu_get_counter_value(
+					vcpu, pmc_pair->low.idx);
+		counter_high = kvm_pmu_get_counter_value(
+					vcpu, pmc_pair->high.idx);
+
+		reg = PMEVCNTR0_EL0 + pmc_pair->low.idx;
+		__vcpu_sys_reg(vcpu, reg) = counter_low;
+
+		reg = PMEVCNTR0_EL0 + pmc_pair->high.idx;
+		__vcpu_sys_reg(vcpu, reg) = counter_high;
+	} else {
 		counter = kvm_pmu_get_counter_value(vcpu, pmc->idx);
 		reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
 		       ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
 		__vcpu_sys_reg(vcpu, reg) = counter;
-		kvm_pmu_release_perf_event(pmc);
 	}
+
+	kvm_pmu_release_perf_event(pmc);
 }
 
 /**
@@ -196,6 +319,7 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 {
 	int i;
 	struct kvm_pmc *pmc;
+	struct perf_event *perf_event;
 
 	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) || !val)
 		return;
@@ -205,9 +329,21 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 			continue;
 
 		pmc = kvm_pmu_get_kvm_pmc(vcpu, i);
-		if (pmc->perf_event) {
-			perf_event_enable(pmc->perf_event);
-			if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
+
+		/*
+		 * For high counters of chained events we must recreate the
+		 * perf event with the long (64bit) attribute set.
+		 */
+		if (kvm_pmu_pair_is_chained(pmc) &&
+		    kvm_pmu_pair_is_high_counter(i)) {
+			kvm_pmu_create_perf_event(vcpu, i);
+			continue;
+		}
+
+		perf_event = kvm_pmu_get_perf_event(pmc);
+		if (perf_event) {
+			perf_event_enable(perf_event);
+			if (perf_event->state != PERF_EVENT_STATE_ACTIVE)
 				kvm_debug("fail to enable perf event\n");
 		}
 	}
@@ -224,6 +360,7 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 {
 	int i;
 	struct kvm_pmc *pmc;
+	struct perf_event *perf_event;
 
 	if (!val)
 		return;
@@ -233,8 +370,20 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 			continue;
 
 		pmc = kvm_pmu_get_kvm_pmc(vcpu, i);
-		if (pmc->perf_event)
-			perf_event_disable(pmc->perf_event);
+
+		/*
+		 * For high counters of chained events we must recreate the
+		 * perf event with the long (64bit) attribute unset.
+		 */
+		perf_event = kvm_pmu_get_perf_event(pmc);
+		if (kvm_pmu_pair_is_chained(pmc) &&
+		    kvm_pmu_pair_is_high_counter(i)) {
+			kvm_pmu_create_perf_event(vcpu, i);
+			continue;
+		}
+
+		if (perf_event)
+			perf_event_disable(perf_event);
 	}
 }
 
@@ -430,10 +579,19 @@ static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
 static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 {
 	struct kvm_pmc *pmc = kvm_pmu_get_kvm_pmc(vcpu, select_idx);
+	struct kvm_pmc_pair *pmc_pair = kvm_pmu_get_kvm_pmc_pair(pmc);
 	struct perf_event *event;
 	struct perf_event_attr attr;
 	u64 eventsel, counter, reg, data;
 
+	/*
+	 * For chained counters the event type and filtering attributes are
+	 * obtained from the low/even counter. We also use this counter to
+	 * determine if the event is enabled/disabled.
+	 */
+	if (kvm_pmu_event_is_chained(vcpu, select_idx))
+		select_idx &= ~1UL;
+
 	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
 	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
 	data = __vcpu_sys_reg(vcpu, reg);
@@ -458,19 +616,61 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 	attr.config = (select_idx == ARMV8_PMU_CYCLE_IDX) ?
 		ARMV8_PMUV3_PERFCTR_CPU_CYCLES : eventsel;
 
-	counter = kvm_pmu_get_counter_value(vcpu, select_idx);
-	/* The initial sample period (overflow count) of an event. */
-	attr.sample_period = (-counter) & pmc->bitmask;
+	counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
 
-	event = perf_event_create_kernel_counter(&attr, -1, current,
+	if (kvm_pmu_event_is_chained(vcpu, pmc->idx)) {
+		/**
+		 * The initial sample period (overflow count) of an event. For
+		 * chained counters we only support overflow interrupts on the
+		 * high counter.
+		 */
+		attr.sample_period = (-counter) & 0xffffffffffffffffUL;
+		event = perf_event_create_kernel_counter(&attr, -1, current,
+							 kvm_pmu_perf_overflow,
+							 &pmc_pair->high);
+
+		if (kvm_pmu_counter_is_enabled(vcpu, pmc_pair->high.idx))
+			attr.config1 |= PERF_ATTR_CFG1_KVM_PMU_CHAINED;
+	} else {
+		/* The initial sample period (overflow count) of an event. */
+		attr.sample_period = (-counter) & pmc->bitmask;
+		event = perf_event_create_kernel_counter(&attr, -1, current,
 						 kvm_pmu_perf_overflow, pmc);
+	}
+
 	if (IS_ERR(event)) {
 		pr_err_once("kvm: pmu event creation failed %ld\n",
 			    PTR_ERR(event));
 		return;
 	}
 
-	pmc->perf_event = event;
+	kvm_pmu_set_perf_event(pmc, event);
+}
+
+/**
+ * Update the kvm_pmc_pair type based on the event type written in the
+ * typer register.
+ *
+ * @vcpu: The vcpu pointer
+ * @select_idx: The number of selected counter
+ */
+static void kvm_pmu_update_kvm_pmc_type(struct kvm_vcpu *vcpu, u64 select_idx)
+{
+	struct kvm_pmc *pmc = kvm_pmu_get_kvm_pmc(vcpu, select_idx);
+	struct kvm_pmc_pair *pmc_pair = kvm_pmu_get_kvm_pmc_pair(pmc);
+
+	if (kvm_pmu_event_is_chained(vcpu, pmc->idx)) {
+		/*
+		 * During promotion from paired to chained we must ensure
+		 * the adjacent counter is stopped and its event destroyed
+		 */
+		if (!kvm_pmu_pair_is_chained(pmc))
+			kvm_pmu_stop_counter(vcpu, &pmc_pair->low);
+
+		pmc_pair->type = KVM_PMC_TYPE_CHAIN;
+	} else {
+		pmc_pair->type = KVM_PMC_TYPE_PAIR;
+	}
 }
 
 /**
@@ -492,6 +692,8 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
 
 	__vcpu_sys_reg(vcpu, reg) = event_type;
+
+	kvm_pmu_update_kvm_pmc_type(vcpu, select_idx);
 	kvm_pmu_create_perf_event(vcpu, select_idx);
 }
 
-- 
2.21.0
