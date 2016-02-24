From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v13 08/20] KVM: ARM64: PMU: Add perf event map and introduce
 perf event creating function
Date: Wed, 24 Feb 2016 13:08:28 +0800
Message-ID: <1456290520-10012-9-git-send-email-zhaoshenglong@huawei.com>
References: <1456290520-10012-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D75B54977A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2016 00:03:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N7nuylhes8Pt for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Feb 2016 00:03:37 -0500 (EST)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [119.145.14.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 42A0B48529
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2016 00:03:34 -0500 (EST)
In-Reply-To: <1456290520-10012-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, shannon.zhao@linaro.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

When we use tools like perf on host, perf passes the event type and the
id of this event type category to kernel, then kernel will map them to
hardware event number and write this number to PMU PMEVTYPER<n>_EL0
register. When getting the event number in KVM, directly use raw event
type to create a perf_event for it.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_pmu.h |  4 +++
 virt/kvm/arm/pmu.c    | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index b70058e..c5737797 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -43,6 +43,8 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu);
 void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val);
+void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
+				    u64 select_idx);
 #else
 struct kvm_pmu {
 };
@@ -61,6 +63,8 @@ static inline u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 }
 static inline void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val) {}
+static inline void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu,
+						  u64 data, u64 select_idx) {}
 #endif
 
 #endif
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index f8dc174..591a11d 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -62,6 +62,27 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 	vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
 }
 
+/**
+ * kvm_pmu_stop_counter - stop PMU counter
+ * @pmc: The PMU counter pointer
+ *
+ * If this counter has been configured to monitor some event, release it here.
+ */
+static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
+{
+	u64 counter, reg;
+
+	if (pmc->perf_event) {
+		counter = kvm_pmu_get_counter_value(vcpu, pmc->idx);
+		reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
+		       ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
+		vcpu_sys_reg(vcpu, reg) = counter;
+		perf_event_disable(pmc->perf_event);
+		perf_event_release_kernel(pmc->perf_event);
+		pmc->perf_event = NULL;
+	}
+}
+
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 {
 	u64 val = vcpu_sys_reg(vcpu, PMCR_EL0) >> ARMV8_PMU_PMCR_N_SHIFT;
@@ -127,3 +148,56 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val)
 			perf_event_disable(pmc->perf_event);
 	}
 }
+
+static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
+{
+	return (vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) &&
+	       (vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & BIT(select_idx));
+}
+
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
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
+	struct perf_event *event;
+	struct perf_event_attr attr;
+	u64 eventsel, counter;
+
+	kvm_pmu_stop_counter(vcpu, pmc);
+	eventsel = data & ARMV8_PMU_EVTYPE_EVENT;
+
+	memset(&attr, 0, sizeof(struct perf_event_attr));
+	attr.type = PERF_TYPE_RAW;
+	attr.size = sizeof(attr);
+	attr.pinned = 1;
+	attr.disabled = !kvm_pmu_counter_is_enabled(vcpu, select_idx);
+	attr.exclude_user = data & ARMV8_PMU_EXCLUDE_EL0 ? 1 : 0;
+	attr.exclude_kernel = data & ARMV8_PMU_EXCLUDE_EL1 ? 1 : 0;
+	attr.exclude_hv = 1; /* Don't count EL2 events */
+	attr.exclude_host = 1; /* Don't count host events */
+	attr.config = eventsel;
+
+	counter = kvm_pmu_get_counter_value(vcpu, select_idx);
+	/* The initial sample period (overflow count) of an event. */
+	attr.sample_period = (-counter) & pmc->bitmask;
+
+	event = perf_event_create_kernel_counter(&attr, -1, current, NULL, pmc);
+	if (IS_ERR(event)) {
+		pr_err_once("kvm: pmu event creation failed %ld\n",
+			    PTR_ERR(event));
+		return;
+	}
+
+	pmc->perf_event = event;
+}
-- 
2.0.4
