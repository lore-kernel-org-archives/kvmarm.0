From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v5 18/21] KVM: ARM64: Add PMU overflow interrupt routing
Date: Thu, 3 Dec 2015 14:11:28 +0800
Message-ID: <1449123091-20252-19-git-send-email-zhaoshenglong@huawei.com>
References: <1449123091-20252-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1449123091-20252-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: wei@redhat.com, hangaohuai@huawei.com, kvm@vger.kernel.org, will.deacon@arm.com, peter.huangpeng@huawei.com, cov@codeaurora.org, zhaoshenglong@huawei.com, alex.bennee@linaro.org, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
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
index 212a3de..4cb0ade 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -39,6 +39,7 @@ struct kvm_pmu {
 };
 
 #ifdef CONFIG_KVM_ARM_PMU
+void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu);
 unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx);
 void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val);
 void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val, bool all_enable);
@@ -49,6 +50,7 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 				    u32 select_idx);
 void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u32 val);
 #else
+void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu) {}
 unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
 {
 	return 0;
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index b81e35e..34e7386 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -21,6 +21,7 @@
 #include <linux/perf_event.h>
 #include <asm/kvm_emulate.h>
 #include <kvm/arm_pmu.h>
+#include <kvm/arm_vgic.h>
 
 /**
  * kvm_pmu_get_counter_value - get PMU counter value
@@ -79,6 +80,54 @@ static void kvm_pmu_stop_counter(struct kvm_pmc *pmc)
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
+	struct kvm_vcpu *vcpu = pmc->vcpu;
+	int idx = pmc->idx;
+
+	kvm_pmu_overflow_set(vcpu, BIT(idx));
+}
+
+/**
  * kvm_pmu_enable_counter - enable selected PMU counter
  * @vcpu: The vcpu pointer
  * @val: the value guest writes to PMCNTENSET register
@@ -338,7 +387,8 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
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
