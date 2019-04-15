From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 6/6] KVM: arm/arm64: support chained PMU counters
Date: Mon, 15 Apr 2019 16:08:37 +0100
Message-ID: <a4309294-5be7-c758-e1bb-52861a231520@arm.com>
References: <20190325183006.33115-1-andrew.murray@arm.com>
 <20190325183006.33115-7-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190325183006.33115-7-andrew.murray@arm.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Andrew Murray <andrew.murray@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: Julien Thierry <julien.thierry@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

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
