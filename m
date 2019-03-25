From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v4 5/6] KVM: arm/arm64: represent paired counters with
 kvm_pmc_pair
Date: Mon, 25 Mar 2019 18:30:05 +0000
Message-ID: <20190325183006.33115-6-andrew.murray@arm.com>
References: <20190325183006.33115-1-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B1614A441
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Mar 2019 14:30:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GHem6MdEXqcb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Mar 2019 14:30:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB88F4A432
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Mar 2019 14:30:22 -0400 (EDT)
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

The CHAIN PMU event implicitly creates a relationship between a pair
of adjacent counters, this is due to the high counter counting overflows
occurring in the low counter.

To facilitate emulation of chained counters let's represent this
relationship via a struct kvm_pmc_pair that holds a pair of counters.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 include/kvm/arm_pmu.h | 13 +++++++-
 virt/kvm/arm/pmu.c    | 78 ++++++++++++++++++++++++++++++++-----------
 2 files changed, 71 insertions(+), 20 deletions(-)

diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index b73f31baca52..ee80dc8db990 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -22,6 +22,7 @@
 #include <asm/perf_event.h>
 
 #define ARMV8_PMU_CYCLE_IDX		(ARMV8_PMU_MAX_COUNTERS - 1)
+#define ARMV8_PMU_MAX_COUNTER_PAIRS	((ARMV8_PMU_MAX_COUNTERS + 1) >> 1)
 
 #ifdef CONFIG_KVM_ARM_PMU
 
@@ -31,9 +32,19 @@ struct kvm_pmc {
 	u64 bitmask;
 };
 
+enum kvm_pmc_type {
+	KVM_PMC_TYPE_PAIR,
+};
+
+struct kvm_pmc_pair {
+	struct kvm_pmc low;
+	struct kvm_pmc high;
+	enum kvm_pmc_type type;
+};
+
 struct kvm_pmu {
 	int irq_num;
-	struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
+	struct kvm_pmc_pair pmc_pair[ARMV8_PMU_MAX_COUNTER_PAIRS];
 	bool ready;
 	bool created;
 	bool irq_level;
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index ae1e886d4a1a..08acd60c538a 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -25,6 +25,43 @@
 #include <kvm/arm_vgic.h>
 
 static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
+
+/**
+ * kvm_pmu_pair_is_high_counter - determine if select_idx is a high/low counter
+ * @select_idx: The counter index
+ */
+static bool kvm_pmu_pair_is_high_counter(u64 select_idx)
+{
+	return select_idx & 0x1;
+}
+
+/**
+ * kvm_pmu_get_kvm_pmc_pair - obtain a pmc_pair from a pmc
+ * @pmc: The PMU counter pointer
+ */
+static struct kvm_pmc_pair *kvm_pmu_get_kvm_pmc_pair(struct kvm_pmc *pmc)
+{
+	if (kvm_pmu_pair_is_high_counter(pmc->idx))
+		return container_of(pmc, struct kvm_pmc_pair, high);
+	else
+		return container_of(pmc, struct kvm_pmc_pair, low);
+}
+
+/**
+ * kvm_pmu_get_kvm_pmc - obtain a pmc based on select_idx
+ * @vcpu: The vcpu pointer
+ * @select_idx: The counter index
+ */
+static struct kvm_pmc *kvm_pmu_get_kvm_pmc(struct kvm_vcpu *vcpu,
+					   u64 select_idx)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc_pair *pmc_pair = &pmu->pmc_pair[select_idx >> 1];
+
+	return kvm_pmu_pair_is_high_counter(select_idx) ? &pmc_pair->high
+							: &pmc_pair->low;
+}
+
 /**
  * kvm_pmu_get_counter_value - get PMU counter value
  * @vcpu: The vcpu pointer
@@ -33,8 +70,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
 {
 	u64 counter, reg, enabled, running;
-	struct kvm_pmu *pmu = &vcpu->arch.pmu;
-	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
+	struct kvm_pmc *pmc = kvm_pmu_get_kvm_pmc(vcpu, select_idx);
 
 	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
 	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
@@ -108,12 +144,17 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
 void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
 {
 	int i;
-	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc;
+	struct kvm_pmc_pair *pmc_pair;
 
 	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
-		kvm_pmu_stop_counter(vcpu, &pmu->pmc[i]);
-		pmu->pmc[i].idx = i;
-		pmu->pmc[i].bitmask = 0xffffffffUL;
+		pmc = kvm_pmu_get_kvm_pmc(vcpu, i);
+		kvm_pmu_stop_counter(vcpu, pmc);
+		pmc->idx = i;
+		pmc->bitmask = 0xffffffffUL;
+
+		pmc_pair = kvm_pmu_get_kvm_pmc_pair(pmc);
+		pmc_pair->type = KVM_PMC_TYPE_PAIR;
 	}
 }
 
@@ -125,10 +166,12 @@ void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
 void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	int i;
-	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc;
 
-	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++)
-		kvm_pmu_release_perf_event(&pmu->pmc[i]);
+	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
+		pmc = kvm_pmu_get_kvm_pmc(vcpu, i);
+		kvm_pmu_release_perf_event(pmc);
+	}
 }
 
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
@@ -152,7 +195,6 @@ u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 {
 	int i;
-	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	struct kvm_pmc *pmc;
 
 	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) || !val)
@@ -162,7 +204,7 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 		if (!(val & BIT(i)))
 			continue;
 
-		pmc = &pmu->pmc[i];
+		pmc = kvm_pmu_get_kvm_pmc(vcpu, i);
 		if (pmc->perf_event) {
 			perf_event_enable(pmc->perf_event);
 			if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
@@ -181,7 +223,6 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 {
 	int i;
-	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	struct kvm_pmc *pmc;
 
 	if (!val)
@@ -191,7 +232,7 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 		if (!(val & BIT(i)))
 			continue;
 
-		pmc = &pmu->pmc[i];
+		pmc = kvm_pmu_get_kvm_pmc(vcpu, i);
 		if (pmc->perf_event)
 			perf_event_disable(pmc->perf_event);
 	}
@@ -285,9 +326,10 @@ static inline struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu;
 	struct kvm_vcpu_arch *vcpu_arch;
+	struct kvm_pmc_pair *pair = kvm_pmu_get_kvm_pmc_pair(pmc);
 
-	pmc -= pmc->idx;
-	pmu = container_of(pmc, struct kvm_pmu, pmc[0]);
+	pair -= (pmc->idx >> 1);
+	pmu = container_of(pair, struct kvm_pmu, pmc_pair[0]);
 	vcpu_arch = container_of(pmu, struct kvm_vcpu_arch, pmu);
 	return container_of(vcpu_arch, struct kvm_vcpu, arch);
 }
@@ -348,7 +390,6 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
  */
 void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 {
-	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	struct kvm_pmc *pmc;
 	u64 mask;
 	int i;
@@ -370,7 +411,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 	}
 
 	if (val & ARMV8_PMU_PMCR_LC) {
-		pmc = &pmu->pmc[ARMV8_PMU_CYCLE_IDX];
+		pmc = kvm_pmu_get_kvm_pmc(vcpu, ARMV8_PMU_CYCLE_IDX);
 		pmc->bitmask = 0xffffffffffffffffUL;
 	}
 }
@@ -388,8 +429,7 @@ static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
  */
 static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 {
-	struct kvm_pmu *pmu = &vcpu->arch.pmu;
-	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
+	struct kvm_pmc *pmc = kvm_pmu_get_kvm_pmc(vcpu, select_idx);
 	struct perf_event *event;
 	struct perf_event_attr attr;
 	u64 eventsel, counter, reg, data;
-- 
2.21.0
