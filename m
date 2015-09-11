From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v2 19/22] KVM: ARM64: Add PMU overflow interrupt routing
Date: Fri, 11 Sep 2015 16:55:12 +0800
Message-ID: <1441961715-11688-20-git-send-email-zhaoshenglong@huawei.com>
References: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CC794200B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2015 04:55:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DZWr0BE+pZnQ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Sep 2015 04:55:46 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 950DC41711
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2015 04:55:39 -0400 (EDT)
In-Reply-To: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

When calling perf_event_create_kernel_counter to create perf_event,
assign a overflow handler. Then when perf event overflows, set
irq_pending and call kvm_vcpu_kick() to sync the interrupt.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm/kvm/arm.c    |  3 +++
 include/kvm/arm_pmu.h |  2 ++
 virt/kvm/arm/pmu.c    | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index bc738d2..ee5d667 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -28,6 +28,7 @@
 #include <linux/sched.h>
 #include <linux/kvm.h>
 #include <trace/events/kvm.h>
+#include <kvm/arm_pmu.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -547,6 +548,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 			preempt_enable();
 			kvm_timer_sync_hwstate(vcpu);
 			kvm_vgic_sync_hwstate(vcpu);
+			kvm_pmu_sync_hwstate(vcpu);
 			continue;
 		}
 
@@ -591,6 +593,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 		kvm_timer_sync_hwstate(vcpu);
 		kvm_vgic_sync_hwstate(vcpu);
+		kvm_pmu_sync_hwstate(vcpu);
 
 		ret = handle_exit(vcpu, run, ret);
 	}
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 1a27357..5f1ea2b 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -37,6 +37,7 @@ struct kvm_pmu {
 };
 
 #ifdef CONFIG_KVM_ARM_PMU
+void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu);
 unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
 					unsigned long select_idx);
 void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, unsigned long val);
@@ -45,6 +46,7 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, unsigned long val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned long data,
 				    unsigned long select_idx);
 #else
+void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu) {}
 unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
 					unsigned long select_idx)
 {
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 5f5a483..9e75372 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -21,6 +21,7 @@
 #include <linux/perf_event.h>
 #include <asm/kvm_emulate.h>
 #include <kvm/arm_pmu.h>
+#include <kvm/arm_vgic.h>
 
 /* PMU HW events mapping. */
 static struct kvm_pmu_hw_event_map {
@@ -90,6 +91,56 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu,
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
+
+	if (pmu->irq_pending && (pmu->irq_num != -1)) {
+		kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id, pmu->irq_num, 1);
+		pmu->irq_pending = false;
+	}
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
  * kvm_pmu_get_counter_value - get PMU counter value
  * @vcpu: The vcpu pointer
  * @select_idx: The counter index
@@ -311,7 +362,8 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned long data,
 	/* The initial sample period (overflow count) of an event. */
 	attr.sample_period = (-counter) & (((u64)1 << overflow_bit) - 1);
 
-	event = perf_event_create_kernel_counter(&attr, -1, current, NULL, pmc);
+	event = perf_event_create_kernel_counter(&attr, -1, current,
+						 kvm_pmu_perf_overflow, pmc);
 	if (IS_ERR(event)) {
 		printk_once("kvm: pmu event creation failed %ld\n",
 			    PTR_ERR(event));
-- 
2.0.4
