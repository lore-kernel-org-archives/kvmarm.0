From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v4 18/21] KVM: ARM64: Add PMU overflow interrupt routing
Date: Fri, 30 Oct 2015 14:22:00 +0800
Message-ID: <1446186123-11548-19-git-send-email-zhaoshenglong@huawei.com>
References: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

When calling perf_event_create_kernel_counter to create perf_event,
assign a overflow handler. Then when perf event overflows, set
irq_pending and call kvm_vcpu_kick() to sync the interrupt.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm/kvm/arm.c    |  4 +++
 include/kvm/arm_pmu.h |  4 +++
 virt/kvm/arm/pmu.c    | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 83 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 78b2869..9c0fec4 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -28,6 +28,7 @@
 #include <linux/sched.h>
 #include <linux/kvm.h>
 #include <trace/events/kvm.h>
+#include <kvm/arm_pmu.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -551,6 +552,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm)) {
 			local_irq_enable();
+			kvm_pmu_sync_hwstate(vcpu);
 			kvm_vgic_sync_hwstate(vcpu);
 			preempt_enable();
 			kvm_timer_sync_hwstate(vcpu);
@@ -598,6 +600,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		kvm_guest_exit();
 		trace_kvm_exit(kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
 
+		kvm_pmu_post_sync_hwstate(vcpu);
+
 		kvm_vgic_sync_hwstate(vcpu);
 
 		preempt_enable();
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index acd025a..5e7f943 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -39,6 +39,8 @@ struct kvm_pmu {
 };
 
 #ifdef CONFIG_KVM_ARM_PMU
+void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu);
+void kvm_pmu_post_sync_hwstate(struct kvm_vcpu *vcpu);
 unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx);
 void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val);
 void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val, bool all_enable);
@@ -49,6 +51,8 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 				    u32 select_idx);
 void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u32 val);
 #else
+void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu) {}
+void kvm_pmu_post_sync_hwstate(struct kvm_vcpu *vcpu) {}
 unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
 {
 	return 0;
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 11d1bfb..6d48d9a 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -21,6 +21,7 @@
 #include <linux/perf_event.h>
 #include <asm/kvm_emulate.h>
 #include <kvm/arm_pmu.h>
+#include <kvm/arm_vgic.h>
 
 /**
  * kvm_pmu_get_counter_value - get PMU counter value
@@ -69,6 +70,78 @@ static void kvm_pmu_stop_counter(struct kvm_pmc *pmc)
 }
 
 /**
+ * kvm_pmu_sync_hwstate - sync pmu state for cpu
+ * @vcpu: The vcpu pointer
+ *
+ * Inject virtual PMU IRQ if IRQ is pending for this cpu.
+ */
+void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	u32 overflow;
+
+	if (!vcpu_mode_is_32bit(vcpu))
+		overflow = vcpu_sys_reg(vcpu, PMOVSSET_EL0);
+	else
+		overflow = vcpu_cp15(vcpu, c9_PMOVSSET);
+
+	if ((pmu->irq_pending || overflow != 0) && (pmu->irq_num != -1))
+		kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id, pmu->irq_num, 1);
+
+	pmu->irq_pending = false;
+}
+
+/**
+ * kvm_pmu_post_sync_hwstate - post sync pmu state for cpu
+ * @vcpu: The vcpu pointer
+ *
+ * Inject virtual PMU IRQ if IRQ is pending for this cpu when back from guest.
+ */
+void kvm_pmu_post_sync_hwstate(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+
+	if (pmu->irq_pending && (pmu->irq_num != -1))
+		kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id, pmu->irq_num, 1);
+
+	pmu->irq_pending = false;
+}
+
+/**
+ * When perf event overflows, set irq_pending and call kvm_vcpu_kick() to inject
+ * the interrupt.
+ */
+static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
+				  struct perf_sample_data *data,
+				  struct pt_regs *regs)
+{
+	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
+	struct kvm_vcpu *vcpu = pmc->vcpu;
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	int idx = pmc->idx;
+
+	if (!vcpu_mode_is_32bit(vcpu)) {
+		if ((vcpu_sys_reg(vcpu, PMINTENSET_EL1) >> idx) & 0x1) {
+			__set_bit(idx,
+			    (unsigned long *)&vcpu_sys_reg(vcpu, PMOVSSET_EL0));
+			__set_bit(idx,
+			    (unsigned long *)&vcpu_sys_reg(vcpu, PMOVSCLR_EL0));
+			pmu->irq_pending = true;
+			kvm_vcpu_kick(vcpu);
+		}
+	} else {
+		if ((vcpu_cp15(vcpu, c9_PMINTENSET) >> idx) & 0x1) {
+			__set_bit(idx,
+				(unsigned long *)&vcpu_cp15(vcpu, c9_PMOVSSET));
+			__set_bit(idx,
+				(unsigned long *)&vcpu_cp15(vcpu, c9_PMOVSCLR));
+			pmu->irq_pending = true;
+			kvm_vcpu_kick(vcpu);
+		}
+	}
+}
+
+/**
  * kvm_pmu_enable_counter - enable selected PMU counter
  * @vcpu: The vcpu pointer
  * @val: the value guest writes to PMCNTENSET register
@@ -293,7 +366,8 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 	/* The initial sample period (overflow count) of an event. */
 	attr.sample_period = (-counter) & pmc->bitmask;
 
-	event = perf_event_create_kernel_counter(&attr, -1, current, NULL, pmc);
+	event = perf_event_create_kernel_counter(&attr, -1, current,
+						 kvm_pmu_perf_overflow, pmc);
 	if (IS_ERR(event)) {
 		printk_once("kvm: pmu event creation failed %ld\n",
 			    PTR_ERR(event));
-- 
2.0.4


