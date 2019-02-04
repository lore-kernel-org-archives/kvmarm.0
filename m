From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v2 4/5] KVM: arm/arm64: lazily create perf events on enable
Date: Mon,  4 Feb 2019 16:53:37 +0000
Message-ID: <1549299218-44714-5-git-send-email-andrew.murray@arm.com>
References: <1549299218-44714-1-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A1454A2E4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Feb 2019 11:53:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9uPLCyCgw-vW for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Feb 2019 11:53:52 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 211E04A2E5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Feb 2019 11:53:52 -0500 (EST)
In-Reply-To: <1549299218-44714-1-git-send-email-andrew.murray@arm.com>
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

To prevent re-creating perf events everytime the counter registers
are changed, let's instead lazily create the event when the event
is first enabled and destroy it when it changes.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 virt/kvm/arm/pmu.c | 96 ++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 68 insertions(+), 28 deletions(-)

diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 95d74ec..a64aeb2 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -24,7 +24,10 @@
 #include <kvm/arm_pmu.h>
 #include <kvm/arm_vgic.h>
 
+static void kvm_pmu_sync_counter_enable(struct kvm_vcpu *vcpu, u64 select_idx);
 static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
+static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
+
 /**
  * kvm_pmu_get_counter_value - get PMU counter value
  * @vcpu: The vcpu pointer
@@ -59,13 +62,15 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 {
 	u64 reg;
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
 
 	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
 	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
 	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
 
-	/* Recreate the perf event to reflect the updated sample_period */
-	kvm_pmu_create_perf_event(vcpu, select_idx);
+	kvm_pmu_stop_counter(vcpu, pmc);
+	kvm_pmu_sync_counter_enable(vcpu, select_idx);
 }
 
 /**
@@ -83,6 +88,7 @@ static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
 
 /**
  * kvm_pmu_stop_counter - stop PMU counter
+ * @vcpu: The vcpu pointer
  * @pmc: The PMU counter pointer
  *
  * If this counter has been configured to monitor some event, release it here.
@@ -143,6 +149,24 @@ u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 }
 
 /**
+ * kvm_pmu_enable_counter - create/enable a counter
+ * @vcpu: The vcpu pointer
+ * @select_idx: The counter index
+ */
+static void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 select_idx)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
+
+	if (!pmc->perf_event)
+		kvm_pmu_create_perf_event(vcpu, select_idx);
+
+	perf_event_enable(pmc->perf_event);
+	if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
+		kvm_debug("failed to enable perf event\n");
+}
+
+/**
  * kvm_pmu_enable_counter_mask - enable selected PMU counters
  * @vcpu: The vcpu pointer
  * @val: the value guest writes to PMCNTENSET register
@@ -152,8 +176,6 @@ u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 {
 	int i;
-	struct kvm_pmu *pmu = &vcpu->arch.pmu;
-	struct kvm_pmc *pmc;
 
 	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) || !val)
 		return;
@@ -162,16 +184,39 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 		if (!(val & BIT(i)))
 			continue;
 
-		pmc = &pmu->pmc[i];
-		if (pmc->perf_event) {
-			perf_event_enable(pmc->perf_event);
-			if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
-				kvm_debug("fail to enable perf event\n");
-		}
+		kvm_pmu_enable_counter(vcpu, i);
 	}
 }
 
 /**
+ * kvm_pmu_sync_counter_enable - reenable a counter if it should be enabled
+ * @vcpu: The vcpu pointer
+ * @select_idx: The counter index
+ */
+static void kvm_pmu_sync_counter_enable(struct kvm_vcpu *vcpu,
+					    u64 select_idx)
+{
+	u64 set = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
+
+	if (set & BIT(select_idx))
+		kvm_pmu_enable_counter_mask(vcpu, BIT(select_idx));
+}
+
+/**
+ * kvm_pmu_disable_counter - disable selected PMU counter
+ * @vcpu: The vcpu pointer
+ * @pmc: The counter to disable
+ */
+static void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 select_idx)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
+
+	if (pmc->perf_event)
+		perf_event_disable(pmc->perf_event);
+}
+
+/**
  * kvm_pmu_disable_counter_mask - disable selected PMU counters
  * @vcpu: The vcpu pointer
  * @val: the value guest writes to PMCNTENCLR register
@@ -181,8 +226,6 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 {
 	int i;
-	struct kvm_pmu *pmu = &vcpu->arch.pmu;
-	struct kvm_pmc *pmc;
 
 	if (!val)
 		return;
@@ -191,9 +234,7 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 		if (!(val & BIT(i)))
 			continue;
 
-		pmc = &pmu->pmc[i];
-		if (pmc->perf_event)
-			perf_event_disable(pmc->perf_event);
+		kvm_pmu_disable_counter(vcpu, i);
 	}
 }
 
@@ -375,16 +416,9 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 	}
 }
 
-static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
-{
-	return (__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) &&
-	       (__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & BIT(select_idx));
-}
-
 /**
- * kvm_pmu_create_perf_event - create a perf event for a counter
+ * kvm_pmu_counter_create_enabled_perf_event - create a perf event for a counter
  * @vcpu: The vcpu pointer
- * @data: Type of event as per PMXEVTYPER_EL0 format
  * @select_idx: The number of selected counter
  */
 static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
@@ -399,7 +433,6 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
 	data = __vcpu_sys_reg(vcpu, reg);
 
-	kvm_pmu_stop_counter(vcpu, pmc);
 	eventsel = data & ARMV8_PMU_EVTYPE_EVENT;
 
 	/* Software increment event does't need to be backed by a perf event */
@@ -411,7 +444,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 	attr.type = PERF_TYPE_RAW;
 	attr.size = sizeof(attr);
 	attr.pinned = 1;
-	attr.disabled = !kvm_pmu_counter_is_enabled(vcpu, select_idx);
+	attr.disabled = 1;
 	attr.exclude_user = data & ARMV8_PMU_EXCLUDE_EL0 ? 1 : 0;
 	attr.exclude_kernel = data & ARMV8_PMU_EXCLUDE_EL1 ? 1 : 0;
 	attr.exclude_hv = 1; /* Don't count EL2 events */
@@ -447,10 +480,17 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx)
 {
-	u64 event_type = data & ARMV8_PMU_EVTYPE_MASK;
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
+	u64 reg, event_type = data & ARMV8_PMU_EVTYPE_MASK;
+
+	kvm_pmu_stop_counter(vcpu, pmc);
+
+	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
+	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
 
-	__vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + select_idx) = event_type;
-	kvm_pmu_create_perf_event(vcpu, select_idx);
+	__vcpu_sys_reg(vcpu, reg) = event_type;
+	kvm_pmu_sync_counter_enable(vcpu, select_idx);
 }
 
 bool kvm_arm_support_pmu_v3(void)
-- 
2.7.4
