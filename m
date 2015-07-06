From: shannon.zhao@linaro.org
Subject: [PATCH 07/18] KVM: ARM64: PMU: Add perf event map and introduce perf event creating function
Date: Mon,  6 Jul 2015 10:17:37 +0800
Message-ID: <1436149068-3784-8-git-send-email-shannon.zhao@linaro.org>
References: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com, marc.zyngier@arm.com, alex.bennee@linaro.org, shannon.zhao@linaro.org, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

When we use tools like perf on host, perf passes the event type and the
id in this type category to kernel, then kernel will map them to event
number and write this number to PMU PMEVTYPER<n>_EL0 register. While
we're trapping and emulating guest accesses to PMU registers, we get the
event number and map it to the event type and the id reversely.

Check whether the event type is same with the one to be set. If not,
stop counter to monitor current event and find the event type map id.
According to the bits of data to configure this perf_event attr and
set exclude_host to 1 for guest. Then call perf_event API to create the
corresponding event and save the event pointer.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 include/kvm/arm_pmu.h |   4 ++
 virt/kvm/arm/pmu.c    | 173 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 177 insertions(+)

diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 27d14ca..1050b24 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -45,9 +45,13 @@ struct kvm_pmu {
 
 #ifdef CONFIG_KVM_ARM_PMU
 void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu);
+void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned long data,
+				    unsigned long select_idx);
 void kvm_pmu_init(struct kvm_vcpu *vcpu);
 #else
 static inline void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu) {}
+void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned long data,
+				    unsigned long select_idx) {}
 static inline void kvm_pmu_init(struct kvm_vcpu *vcpu) {}
 #endif
 
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index dc252d0..50a3c82 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -18,8 +18,68 @@
 #include <linux/cpu.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
+#include <linux/perf_event.h>
 #include <kvm/arm_pmu.h>
 
+/* PMU HW events mapping. */
+static struct kvm_pmu_hw_event_map {
+	unsigned eventsel;
+	unsigned event_type;
+} kvm_pmu_hw_events[] = {
+	[0] = { 0x11, PERF_COUNT_HW_CPU_CYCLES },
+	[1] = { 0x08, PERF_COUNT_HW_INSTRUCTIONS },
+	[2] = { 0x04, PERF_COUNT_HW_CACHE_REFERENCES },
+	[3] = { 0x03, PERF_COUNT_HW_CACHE_MISSES },
+	[4] = { 0x10, PERF_COUNT_HW_BRANCH_MISSES },
+};
+
+/* PMU HW cache events mapping. */
+static struct kvm_pmu_hw_cache_event_map {
+	unsigned eventsel;
+	unsigned cache_type;
+	unsigned cache_op;
+	unsigned cache_result;
+} kvm_pmu_hw_cache_events[] = {
+	[0] = { 0x04, PERF_COUNT_HW_CACHE_L1D, PERF_COUNT_HW_CACHE_OP_READ,
+		      PERF_COUNT_HW_CACHE_RESULT_ACCESS },
+	[1] = { 0x03, PERF_COUNT_HW_CACHE_L1D, PERF_COUNT_HW_CACHE_OP_READ,
+		      PERF_COUNT_HW_CACHE_RESULT_MISS },
+	[2] = { 0x04, PERF_COUNT_HW_CACHE_L1D, PERF_COUNT_HW_CACHE_OP_WRITE,
+		      PERF_COUNT_HW_CACHE_RESULT_ACCESS },
+	[3] = { 0x03, PERF_COUNT_HW_CACHE_L1D, PERF_COUNT_HW_CACHE_OP_WRITE,
+		      PERF_COUNT_HW_CACHE_RESULT_MISS },
+	[4] = { 0x12, PERF_COUNT_HW_CACHE_BPU, PERF_COUNT_HW_CACHE_OP_READ,
+		      PERF_COUNT_HW_CACHE_RESULT_ACCESS },
+	[5] = { 0x10, PERF_COUNT_HW_CACHE_BPU, PERF_COUNT_HW_CACHE_OP_READ,
+		      PERF_COUNT_HW_CACHE_RESULT_MISS },
+	[6] = { 0x12, PERF_COUNT_HW_CACHE_BPU, PERF_COUNT_HW_CACHE_OP_WRITE,
+		      PERF_COUNT_HW_CACHE_RESULT_ACCESS },
+	[7] = { 0x10, PERF_COUNT_HW_CACHE_BPU, PERF_COUNT_HW_CACHE_OP_WRITE,
+		      PERF_COUNT_HW_CACHE_RESULT_MISS },
+};
+
+/**
+ * kvm_pmu_stop_counter - stop PMU counter for the selected counter
+ * @vcpu: The vcpu pointer
+ * @select_idx: The counter index
+ *
+ * If this counter has been configured to monitor some event, disable and
+ * release it.
+ */
+static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu,
+				 unsigned long select_idx)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
+
+	if (pmc->perf_event) {
+		perf_event_disable(pmc->perf_event);
+		perf_event_release_kernel(pmc->perf_event);
+	}
+	pmc->perf_event = NULL;
+	pmc->eventsel = 0xff;
+}
+
 /**
  * kvm_pmu_vcpu_reset - reset pmu state for cpu
  * @vcpu: The vcpu pointer
@@ -27,12 +87,125 @@
  */
 void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
 {
+	int i;
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 
+	for (i = 0; i < ARMV8_MAX_COUNTERS; i++)
+		kvm_pmu_stop_counter(vcpu, i);
+	pmu->overflow_status = 0;
 	pmu->irq_pending = false;
 }
 
 /**
+ * kvm_pmu_find_hw_event - find hardware event
+ * @pmu: The pmu pointer
+ * @event_select: The number of selected event type
+ *
+ * Based on the number of selected event type, find out whether it belongs to
+ * PERF_TYPE_HARDWARE. If so, return the corresponding event id.
+ */
+static unsigned kvm_pmu_find_hw_event(struct kvm_pmu *pmu,
+				      unsigned long event_select)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(kvm_pmu_hw_events); i++)
+		if (kvm_pmu_hw_events[i].eventsel == event_select)
+			break;
+
+	if (i == ARRAY_SIZE(kvm_pmu_hw_events))
+		return PERF_COUNT_HW_MAX;
+
+	return kvm_pmu_hw_events[i].event_type;
+}
+
+/**
+ * kvm_pmu_find_hw_cache_event - find hardware cache event
+ * @pmu: The pmu pointer
+ * @event_select: The number of selected event type
+ *
+ * Based on the number of selected event type, find out whether it belongs to
+ * PERF_TYPE_HW_CACHE. If so, return the corresponding event id.
+ */
+static unsigned kvm_pmu_find_hw_cache_event(struct kvm_pmu *pmu,
+					    unsigned long event_select)
+{
+	int i;
+	unsigned config;
+
+	for (i = 0; i < ARRAY_SIZE(kvm_pmu_hw_cache_events); i++)
+		if (kvm_pmu_hw_cache_events[i].eventsel == event_select)
+			break;
+
+	if (i == ARRAY_SIZE(kvm_pmu_hw_cache_events))
+		return PERF_COUNT_HW_CACHE_MAX;
+
+	config = (kvm_pmu_hw_cache_events[i].cache_type & 0xff)
+		 | ((kvm_pmu_hw_cache_events[i].cache_op & 0xff) << 8)
+		 | ((kvm_pmu_hw_cache_events[i].cache_result & 0xff) << 16);
+
+	return config;
+}
+
+/**
+ * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
+ * @vcpu: The vcpu pointer
+ * @data: The data guest writes to PMXEVTYPER_EL0
+ * @select_idx: The number of selected counter
+ *
+ * Firstly check whether the event type is same with the one to be set.
+ * If not, stop counter to monitor current event and find the event type map id.
+ * According to the bits of data to configure this perf_event attr and set
+ * exclude_host to 1 for guest. Then call perf_event API to create the
+ * corresponding event and save the event pointer.
+ */
+void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned long data,
+				    unsigned long select_idx)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
+	struct perf_event *event;
+	struct perf_event_attr attr;
+	unsigned config, type = PERF_TYPE_RAW;
+
+	if ((data & ARMV8_EVTYPE_EVENT) == pmc->eventsel)
+		return;
+
+	kvm_pmu_stop_counter(vcpu, select_idx);
+	pmc->eventsel = data & ARMV8_EVTYPE_EVENT;
+
+	config = kvm_pmu_find_hw_event(pmu, pmc->eventsel);
+	if (config != PERF_COUNT_HW_MAX) {
+		type = PERF_TYPE_HARDWARE;
+	} else {
+		config = kvm_pmu_find_hw_cache_event(pmu, pmc->eventsel);
+		if (config != PERF_COUNT_HW_CACHE_MAX)
+			type = PERF_TYPE_HW_CACHE;
+	}
+
+	if (type == PERF_TYPE_RAW)
+		config = pmc->eventsel;
+
+	attr.type = type;
+	attr.size = sizeof(attr);
+	attr.pinned = true;
+	attr.exclude_user = data & ARMV8_EXCLUDE_EL0 ? 1 : 0;
+	attr.exclude_kernel = data & ARMV8_EXCLUDE_EL1 ? 1 : 0;
+	attr.exclude_hv = data & ARMV8_INCLUDE_EL2 ? 0 : 1;
+	attr.exclude_host = 1;
+	attr.config = config;
+	attr.sample_period = (-pmc->counter) & (((u64)1 << 32) - 1);
+
+	event = perf_event_create_kernel_counter(&attr, -1, current, NULL, pmc);
+	if (IS_ERR(event)) {
+		kvm_err("kvm: pmu event creation failed %ld\n",
+			  PTR_ERR(event));
+		return;
+	}
+	pmc->perf_event = event;
+}
+
+/**
  * kvm_pmu_init - Initialize global PMU state for per vcpu
  * @vcpu: The vcpu pointer
  *
-- 
2.1.0

