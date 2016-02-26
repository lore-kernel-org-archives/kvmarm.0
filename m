From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v15 15/20] KVM: ARM64: Add PMU overflow interrupt routing
Date: Fri, 26 Feb 2016 19:29:19 +0800
Message-ID: <1456486159-14564-1-git-send-email-zhaoshenglong@huawei.com>
References: <1456324417-18992-1-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1456324417-18992-1-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

When calling perf_event_create_kernel_counter to create perf_event,
assign a overflow handler. Then when the perf event overflows, set the
corresponding bit of guest PMOVSSET register. If this counter is enabled
and its interrupt is enabled as well, kick the vcpu to sync the
interrupt.

On VM entry, if there is counter overflowed and interrupt level is
changed, inject the interrupt with corresponding level. On VM exit, sync
the interrupt level as well if it has been changed.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/arm.c    |  8 ++++--
 include/kvm/arm_pmu.h |  5 ++++
 virt/kvm/arm/pmu.c    | 69 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index dda1959..a7e50d7 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -28,6 +28,7 @@
 #include <linux/sched.h>
 #include <linux/kvm.h>
 #include <trace/events/kvm.h>
+#include <kvm/arm_pmu.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -577,6 +578,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 * non-preemptible context.
 		 */
 		preempt_disable();
+		kvm_pmu_flush_hwstate(vcpu);
 		kvm_timer_flush_hwstate(vcpu);
 		kvm_vgic_flush_hwstate(vcpu);
 
@@ -593,6 +595,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
 			vcpu->arch.power_off || vcpu->arch.pause) {
 			local_irq_enable();
+			kvm_pmu_sync_hwstate(vcpu);
 			kvm_timer_sync_hwstate(vcpu);
 			kvm_vgic_sync_hwstate(vcpu);
 			preempt_enable();
@@ -642,10 +645,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
 
 		/*
-		 * We must sync the timer state before the vgic state so that
-		 * the vgic can properly sample the updated state of the
+		 * We must sync the PMU and timer state before the vgic state so
+		 * that the vgic can properly sample the updated state of the
 		 * interrupt line.
 		 */
+		kvm_pmu_sync_hwstate(vcpu);
 		kvm_timer_sync_hwstate(vcpu);
 
 		kvm_vgic_sync_hwstate(vcpu);
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 8bc92d1..9c184ed 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -35,6 +35,7 @@ struct kvm_pmu {
 	int irq_num;
 	struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
 	bool ready;
+	bool irq_level;
 };
 
 #define kvm_arm_pmu_v3_ready(v)		((v)->arch.pmu.ready)
@@ -44,6 +45,8 @@ u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu);
 void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val);
+void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu);
+void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu);
 void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
@@ -67,6 +70,8 @@ static inline u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 static inline void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val) {}
+static inline void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu) {}
+static inline void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu,
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index cda869c..74e858c 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -21,6 +21,7 @@
 #include <linux/perf_event.h>
 #include <asm/kvm_emulate.h>
 #include <kvm/arm_pmu.h>
+#include <kvm/arm_vgic.h>
 
 /**
  * kvm_pmu_get_counter_value - get PMU counter value
@@ -180,6 +181,71 @@ void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val)
 		kvm_vcpu_kick(vcpu);
 }
 
+static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	bool overflow;
+
+	if (!kvm_arm_pmu_v3_ready(vcpu))
+		return;
+
+	overflow = !!kvm_pmu_overflow_status(vcpu);
+	if (pmu->irq_level != overflow) {
+		pmu->irq_level = overflow;
+		kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
+				    pmu->irq_num, overflow);
+	}
+}
+
+/**
+ * kvm_pmu_flush_hwstate - flush pmu state to cpu
+ * @vcpu: The vcpu pointer
+ *
+ * Check if the PMU has overflowed while we were running in the host, and inject
+ * an interrupt if that was the case.
+ */
+void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu)
+{
+	kvm_pmu_update_state(vcpu);
+}
+
+/**
+ * kvm_pmu_sync_hwstate - sync pmu state from cpu
+ * @vcpu: The vcpu pointer
+ *
+ * Check if the PMU has overflowed while we were running in the guest, and
+ * inject an interrupt if that was the case.
+ */
+void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu)
+{
+	kvm_pmu_update_state(vcpu);
+}
+
+static inline struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
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
+ * When perf event overflows, call kvm_pmu_overflow_set to set overflow status.
+ */
+static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
+				  struct perf_sample_data *data,
+				  struct pt_regs *regs)
+{
+	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
+	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
+	int idx = pmc->idx;
+
+	kvm_pmu_overflow_set(vcpu, BIT(idx));
+}
+
 /**
  * kvm_pmu_software_increment - do software increment
  * @vcpu: The vcpu pointer
@@ -291,7 +357,8 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 	/* The initial sample period (overflow count) of an event. */
 	attr.sample_period = (-counter) & pmc->bitmask;
 
-	event = perf_event_create_kernel_counter(&attr, -1, current, NULL, pmc);
+	event = perf_event_create_kernel_counter(&attr, -1, current,
+						 kvm_pmu_perf_overflow, pmc);
 	if (IS_ERR(event)) {
 		pr_err_once("kvm: pmu event creation failed %ld\n",
 			    PTR_ERR(event));
-- 
2.0.4


