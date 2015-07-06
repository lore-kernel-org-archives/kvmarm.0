From: shannon.zhao@linaro.org
Subject: [PATCH 09/18] KVM: ARM64: Add reset and access handlers for PMXEVCNTR_EL0 register
Date: Mon,  6 Jul 2015 10:17:39 +0800
Message-ID: <1436149068-3784-10-git-send-email-shannon.zhao@linaro.org>
References: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com, marc.zyngier@arm.com, alex.bennee@linaro.org, shannon.zhao@linaro.org, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

Since the reset value of PMXEVTYPER_EL0 is UNKNOWN, use reset_unknown
for its reset handler. Add access handler which emulates writing and
reading PMXEVTYPER_EL0 register. When reading PMXEVCNTR_EL0, call
perf_event_read_value to get the count value of the perf event.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 21 ++++++++++++++++++++-
 include/kvm/arm_pmu.h     | 11 +++++++++++
 virt/kvm/arm/pmu.c        | 37 +++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b4f8dd9..2bcf1a0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -356,6 +356,25 @@ static bool access_pmxevtyper(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_pmxevcntr(struct kvm_vcpu *vcpu,
+			     const struct sys_reg_params *p,
+			     const struct sys_reg_desc *r)
+{
+	unsigned long val;
+
+	if (p->is_write) {
+		val = *vcpu_reg(vcpu, p->Rt);
+		kvm_pmu_set_counter_value(vcpu, vcpu_sys_reg(vcpu, PMSELR_EL0),
+					  val & 0xffffffffUL);
+	} else {
+		val = kvm_pmu_get_counter_value(vcpu,
+						vcpu_sys_reg(vcpu, PMSELR_EL0));
+		*vcpu_reg(vcpu, p->Rt) = val;
+	}
+
+	return true;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	/* DBGBVRn_EL1 */						\
@@ -577,7 +596,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmxevtyper, reset_unknown, PMXEVTYPER_EL0 },
 	/* PMXEVCNTR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b010),
-	  trap_raz_wi },
+	  access_pmxevcntr, reset_unknown, PMXEVCNTR_EL0 },
 	/* PMUSERENR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b000),
 	  trap_raz_wi },
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 1050b24..40ab4a0 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -45,11 +45,22 @@ struct kvm_pmu {
 
 #ifdef CONFIG_KVM_ARM_PMU
 void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu);
+void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, unsigned long select_idx,
+			       unsigned long val);
+unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
+					unsigned long select_idx);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned long data,
 				    unsigned long select_idx);
 void kvm_pmu_init(struct kvm_vcpu *vcpu);
 #else
 static inline void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu) {}
+void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, unsigned long select_idx,
+			       unsigned long val) {}
+unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
+					unsigned long select_idx)
+{
+	return 0;
+}
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned long data,
 				    unsigned long select_idx) {}
 static inline void kvm_pmu_init(struct kvm_vcpu *vcpu) {}
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 50a3c82..361fa51 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -97,6 +97,43 @@ void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
 }
 
 /**
+ * kvm_pmu_set_counter_value - set PMU counter value
+ * @vcpu: The vcpu pointer
+ * @select_idx: The counter index
+ * @val: the value to be set
+ */
+void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, unsigned long select_idx,
+			       unsigned long val)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
+
+	pmc->counter = val;
+}
+
+/**
+ * kvm_pmu_set_counter_value - set PMU counter value
+ * @vcpu: The vcpu pointer
+ * @select_idx: The counter index
+ *
+ * Call perf_event API to get the event count
+ */
+unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
+					unsigned long select_idx)
+{
+	u64 enabled, running;
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
+	unsigned long counter = pmc->counter;
+
+	if (pmc->perf_event) {
+		counter += perf_event_read_value(pmc->perf_event,
+						&enabled, &running);
+	}
+	return counter;
+}
+
+/**
  * kvm_pmu_find_hw_event - find hardware event
  * @pmu: The pmu pointer
  * @event_select: The number of selected event type
-- 
2.1.0

