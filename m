From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v6 18/21] KVM: ARM64: Add PMU overflow interrupt routing
Date: Tue, 8 Dec 2015 20:47:37 +0800
Message-ID: <1449578860-15808-19-git-send-email-zhaoshenglong@huawei.com>
References: <1449578860-15808-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1757B412A2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2015 07:47:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2JayzGx+6w+N for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2015 07:47:11 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 47C4849794
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2015 07:47:07 -0500 (EST)
In-Reply-To: <1449578860-15808-1-git-send-email-zhaoshenglong@huawei.com>
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
Cc: kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

When calling perf_event_create_kernel_counter to create perf_event,
assign a overflow handler. Then when perf event overflows, call
kvm_vcpu_kick() to sync the interrupt.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm/kvm/arm.c    |  2 ++
 include/kvm/arm_pmu.h |  2 ++
 virt/kvm/arm/pmu.c    | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index e06fd29..cd696ef 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -28,6 +28,7 @@
 #include <linux/sched.h>
 #include <linux/kvm.h>
 #include <trace/events/kvm.h>
+#include <kvm/arm_pmu.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -569,6 +570,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 * non-preemptible context.
 		 */
 		preempt_disable();
+		kvm_pmu_flush_hwstate(vcpu);
 		kvm_timer_flush_hwstate(vcpu);
 		kvm_vgic_flush_hwstate(vcpu);
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index a131f76..c4041008 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -38,6 +38,7 @@ struct kvm_pmu {
 };
 
 #ifdef CONFIG_KVM_ARM_PMU
+void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu);
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx);
 void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val);
 void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val, bool all_enable);
@@ -48,6 +49,7 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 				    u32 select_idx);
 void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u32 val);
 #else
+void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu) {}
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
 {
 	return 0;
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 9b9c706..ff182d6 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -21,6 +21,7 @@
 #include <linux/perf_event.h>
 #include <asm/kvm_emulate.h>
 #include <kvm/arm_pmu.h>
+#include <kvm/arm_vgic.h>
 
 /**
  * kvm_pmu_get_counter_value - get PMU counter value
@@ -90,6 +91,54 @@ static void kvm_pmu_stop_counter(struct kvm_pmc *pmc)
 }
 
 /**
+ * kvm_pmu_flush_hwstate - flush pmu state to cpu
+ * @vcpu: The vcpu pointer
+ *
+ * Inject virtual PMU IRQ if IRQ is pending for this cpu.
+ */
+void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	u32 overflow;
+
+	if (pmu->irq_num == -1)
+		return;
+
+	if (!vcpu_mode_is_32bit(vcpu)) {
+		if (!(vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMCR_E))
+			return;
+
+		overflow = vcpu_sys_reg(vcpu, PMCNTENSET_EL0)
+			   & vcpu_sys_reg(vcpu, PMINTENSET_EL1)
+			   & vcpu_sys_reg(vcpu, PMOVSSET_EL0);
+	} else {
+		if (!(vcpu_cp15(vcpu, c9_PMCR) & ARMV8_PMCR_E))
+			return;
+
+		overflow = vcpu_cp15(vcpu, c9_PMCNTENSET)
+			   & vcpu_cp15(vcpu, c9_PMINTENSET)
+			   & vcpu_cp15(vcpu, c9_PMOVSSET);
+	}
+
+	kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id, pmu->irq_num,
+			    overflow ? 1 : 0);
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
+/**
  * kvm_pmu_enable_counter - enable selected PMU counter
  * @vcpu: The vcpu pointer
  * @val: the value guest writes to PMCNTENSET register
@@ -341,7 +390,8 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
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
