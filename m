From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v6 07/21] KVM: ARM64: PMU: Add perf event map and introduce
 perf event creating function
Date: Tue, 8 Dec 2015 20:47:26 +0800
Message-ID: <1449578860-15808-8-git-send-email-zhaoshenglong@huawei.com>
References: <1449578860-15808-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97C1E413E1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2015 07:46:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rCDVGD7Uso5z for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2015 07:46:50 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF05D412DD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2015 07:46:47 -0500 (EST)
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

When we use tools like perf on host, perf passes the event type and the
id of this event type category to kernel, then kernel will map them to
hardware event number and write this number to PMU PMEVTYPER<n>_EL0
register. When getting the event number in KVM, directly use raw event
type to create a perf_event for it.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/include/asm/pmu.h |   2 +
 arch/arm64/kvm/Makefile      |   1 +
 include/kvm/arm_pmu.h        |  13 ++++
 virt/kvm/arm/pmu.c           | 138 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 154 insertions(+)
 create mode 100644 virt/kvm/arm/pmu.c

diff --git a/arch/arm64/include/asm/pmu.h b/arch/arm64/include/asm/pmu.h
index 4264ea0..e3cb6b3 100644
--- a/arch/arm64/include/asm/pmu.h
+++ b/arch/arm64/include/asm/pmu.h
@@ -28,6 +28,8 @@
 #define ARMV8_PMCR_D		(1 << 3) /* CCNT counts every 64th cpu cycle */
 #define ARMV8_PMCR_X		(1 << 4) /* Export to ETM */
 #define ARMV8_PMCR_DP		(1 << 5) /* Disable CCNT if non-invasive debug*/
+/* Determines which PMCCNTR_EL0 bit generates an overflow */
+#define ARMV8_PMCR_LC		(1 << 6)
 #define	ARMV8_PMCR_N_SHIFT	11	 /* Number of counters supported */
 #define	ARMV8_PMCR_N_MASK	0x1f
 #define	ARMV8_PMCR_MASK		0x3f	 /* Mask for writable bits */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 1949fe5..18d56d8 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -27,3 +27,4 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3-emul.o
 kvm-$(CONFIG_KVM_ARM_HOST) += vgic-v3-switch.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
+kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index dea78f8..36bde48 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -37,4 +37,17 @@ struct kvm_pmu {
 #endif
 };
 
+#ifdef CONFIG_KVM_ARM_PMU
+u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx);
+void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
+				    u32 select_idx);
+#else
+u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
+{
+	return 0;
+}
+void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
+				    u32 select_idx) {}
+#endif
+
 #endif
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
new file mode 100644
index 0000000..15babf1
--- /dev/null
+++ b/virt/kvm/arm/pmu.c
@@ -0,0 +1,138 @@
+/*
+ * Copyright (C) 2015 Linaro Ltd.
+ * Author: Shannon Zhao <shannon.zhao@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/cpu.h>
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <linux/perf_event.h>
+#include <asm/kvm_emulate.h>
+#include <kvm/arm_pmu.h>
+
+/**
+ * kvm_pmu_get_counter_value - get PMU counter value
+ * @vcpu: The vcpu pointer
+ * @select_idx: The counter index
+ */
+u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
+{
+	u64 counter, enabled, running;
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
+
+	if (!vcpu_mode_is_32bit(vcpu))
+		counter = vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + select_idx);
+	else
+		counter = vcpu_cp15(vcpu, c14_PMEVCNTR0 + select_idx);
+
+	if (pmc->perf_event)
+		counter += perf_event_read_value(pmc->perf_event, &enabled,
+						 &running);
+
+	return counter & pmc->bitmask;
+}
+
+static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u32 select_idx)
+{
+	if (!vcpu_mode_is_32bit(vcpu))
+		return (vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMCR_E) &
+		       (vcpu_sys_reg(vcpu, PMCNTENSET_EL0) >> select_idx);
+	else
+		return (vcpu_sys_reg(vcpu, c9_PMCR) & ARMV8_PMCR_E) &
+		       (vcpu_sys_reg(vcpu, c9_PMCNTENSET) >> select_idx);
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
+ * kvm_pmu_stop_counter - stop PMU counter
+ * @pmc: The PMU counter pointer
+ *
+ * If this counter has been configured to monitor some event, release it here.
+ */
+static void kvm_pmu_stop_counter(struct kvm_pmc *pmc)
+{
+	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
+	u64 counter;
+
+	if (pmc->perf_event) {
+		counter = kvm_pmu_get_counter_value(vcpu, pmc->idx);
+		if (!vcpu_mode_is_32bit(vcpu))
+			vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + pmc->idx) = counter;
+		else
+			vcpu_cp15(vcpu, c14_PMEVCNTR0 + pmc->idx) = counter;
+
+		perf_event_release_kernel(pmc->perf_event);
+		pmc->perf_event = NULL;
+	}
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
+void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
+				    u32 select_idx)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
+	struct perf_event *event;
+	struct perf_event_attr attr;
+	u32 eventsel;
+	u64 counter;
+
+	kvm_pmu_stop_counter(pmc);
+	eventsel = data & ARMV8_EVTYPE_EVENT;
+
+	memset(&attr, 0, sizeof(struct perf_event_attr));
+	attr.type = PERF_TYPE_RAW;
+	attr.size = sizeof(attr);
+	attr.pinned = 1;
+	attr.disabled = kvm_pmu_counter_is_enabled(vcpu, select_idx);
+	attr.exclude_user = data & ARMV8_EXCLUDE_EL0 ? 1 : 0;
+	attr.exclude_kernel = data & ARMV8_EXCLUDE_EL1 ? 1 : 0;
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
+		printk_once("kvm: pmu event creation failed %ld\n",
+			    PTR_ERR(event));
+		return;
+	}
+
+	pmc->perf_event = event;
+}
-- 
2.0.4
