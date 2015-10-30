From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v4 17/21] KVM: ARM64: Add helper to handle PMCR register bits
Date: Fri, 30 Oct 2015 14:21:59 +0800
Message-ID: <1446186123-11548-18-git-send-email-zhaoshenglong@huawei.com>
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

According to ARMv8 spec, when writing 1 to PMCR.E, all counters are
enabled by PMCNTENSET, while writing 0 to PMCR.E, all counters are
disabled. When writing 1 to PMCR.P, reset all event counters, not
including PMCCNTR, to zero. When writing 1 to PMCR.C, reset PMCCNTR to
zero.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c |  2 ++
 include/kvm/arm_pmu.h     |  2 ++
 virt/kvm/arm/pmu.c        | 50 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 50bf3fb..a0bb9d2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -578,6 +578,7 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 			val &= ~ARMV8_PMCR_MASK;
 			val |= *vcpu_reg(vcpu, p->Rt) & ARMV8_PMCR_MASK;
 			vcpu_sys_reg(vcpu, r->reg) = val;
+			kvm_pmu_handle_pmcr(vcpu, val);
 			break;
 		}
 		case PMCEID0_EL0:
@@ -1213,6 +1214,7 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 			val &= ~ARMV8_PMCR_MASK;
 			val |= *vcpu_reg(vcpu, p->Rt) & ARMV8_PMCR_MASK;
 			vcpu_cp15(vcpu, r->reg) = val;
+			kvm_pmu_handle_pmcr(vcpu, val);
 			break;
 		}
 		case c9_PMCEID0:
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index d7de7f1..acd025a 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -47,6 +47,7 @@ void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u32 val);
 void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u32 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 				    u32 select_idx);
+void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u32 val);
 #else
 unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
 {
@@ -59,6 +60,7 @@ void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u32 val) {}
 void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u32 val) {}
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 				    u32 select_idx) {}
+void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u32 val) {}
 #endif
 
 #endif
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index ae21089..11d1bfb 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -121,6 +121,56 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val)
 }
 
 /**
+ * kvm_pmu_handle_pmcr - handle PMCR register
+ * @vcpu: The vcpu pointer
+ * @val: the value guest writes to PMCR register
+ */
+void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u32 val)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc;
+	u32 enable;
+	int i;
+
+	if (val & ARMV8_PMCR_E) {
+		if (!vcpu_mode_is_32bit(vcpu))
+			enable = vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
+		else
+			enable = vcpu_cp15(vcpu, c9_PMCNTENSET);
+
+		kvm_pmu_enable_counter(vcpu, enable, true);
+	} else
+		kvm_pmu_disable_counter(vcpu, 0xffffffffUL);
+
+	if (val & ARMV8_PMCR_C) {
+		pmc = &pmu->pmc[ARMV8_MAX_COUNTERS - 1];
+		if (pmc->perf_event)
+			local64_set(&pmc->perf_event->count, 0);
+		if (!vcpu_mode_is_32bit(vcpu))
+			vcpu_sys_reg(vcpu, PMCCNTR_EL0) = 0;
+		else
+			vcpu_cp15(vcpu, c9_PMCCNTR) = 0;
+	}
+
+	if (val & ARMV8_PMCR_P) {
+		for (i = 0; i < ARMV8_MAX_COUNTERS - 1; i++) {
+			pmc = &pmu->pmc[i];
+			if (pmc->perf_event)
+				local64_set(&pmc->perf_event->count, 0);
+			if (!vcpu_mode_is_32bit(vcpu))
+				vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = 0;
+			else
+				vcpu_cp15(vcpu, c14_PMEVCNTR0 + i) = 0;
+		}
+	}
+
+	if (val & ARMV8_PMCR_LC) {
+		pmc = &pmu->pmc[ARMV8_MAX_COUNTERS - 1];
+		pmc->bitmask = 0xffffffffffffffffUL;
+	}
+}
+
+/**
  * kvm_pmu_overflow_clear - clear PMU overflow interrupt
  * @vcpu: The vcpu pointer
  * @val: the value guest writes to PMOVSCLR register
-- 
2.0.4


