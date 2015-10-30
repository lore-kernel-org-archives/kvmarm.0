From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v4 11/21] KVM: ARM64: Add reset and access handlers for PMCNTENSET and PMCNTENCLR register
Date: Fri, 30 Oct 2015 14:21:53 +0800
Message-ID: <1446186123-11548-12-git-send-email-zhaoshenglong@huawei.com>
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

Since the reset value of PMCNTENSET and PMCNTENCLR is UNKNOWN, use
reset_unknown for its reset handler. Add a new case to emulate writing
PMCNTENSET or PMCNTENCLR register.

When writing to PMCNTENSET, call perf_event_enable to enable the perf
event. When writing to PMCNTENCLR, call perf_event_disable to disable
the perf event.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 52 +++++++++++++++++++++++++++++++++++++++++++----
 include/kvm/arm_pmu.h     |  4 ++++
 virt/kvm/arm/pmu.c        | 52 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 104 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 059c84c..c358ae0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -519,6 +519,27 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 							 *vcpu_reg(vcpu, p->Rt);
 			break;
 		}
+		case PMCNTENSET_EL0: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			kvm_pmu_enable_counter(vcpu, val,
+				   vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMCR_E);
+			/* Value 1 of PMCNTENSET_EL0 and PMCNTENCLR_EL0 means
+			 * corresponding counter enabled.
+			 */
+			vcpu_sys_reg(vcpu, r->reg) |= val;
+			vcpu_sys_reg(vcpu, PMCNTENCLR_EL0) |= val;
+			break;
+		}
+		case PMCNTENCLR_EL0: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			kvm_pmu_disable_counter(vcpu, val);
+			/* Value 0 of PMCNTENSET_EL0 and PMCNTENCLR_EL0 means
+			 * corresponding counter disabled.
+			 */
+			vcpu_sys_reg(vcpu, r->reg) &= ~val;
+			vcpu_sys_reg(vcpu, PMCNTENSET_EL0) &= ~val;
+			break;
+		}
 		case PMCR_EL0: {
 			/* Only update writeable bits of PMCR */
 			val = vcpu_sys_reg(vcpu, r->reg);
@@ -751,10 +772,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmu_regs, reset_pmcr, PMCR_EL0, },
 	/* PMCNTENSET_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b001),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_unknown, PMCNTENSET_EL0 },
 	/* PMCNTENCLR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b010),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_unknown, PMCNTENCLR_EL0 },
 	/* PMOVSCLR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b011),
 	  trap_raz_wi },
@@ -1017,6 +1038,27 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 							 *vcpu_reg(vcpu, p->Rt);
 			break;
 		}
+		case c9_PMCNTENSET: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			kvm_pmu_enable_counter(vcpu, val,
+				       vcpu_cp15(vcpu, c9_PMCR) & ARMV8_PMCR_E);
+			/* Value 1 of PMCNTENSET_EL0 and PMCNTENCLR_EL0 means
+			 * corresponding counter enabled.
+			 */
+			vcpu_cp15(vcpu, r->reg) |= val;
+			vcpu_cp15(vcpu, c9_PMCNTENCLR) |= val;
+			break;
+		}
+		case c9_PMCNTENCLR: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			kvm_pmu_disable_counter(vcpu, val);
+			/* Value 0 of PMCNTENSET_EL0 and PMCNTENCLR_EL0 means
+			 * corresponding counter disabled.
+			 */
+			vcpu_cp15(vcpu, r->reg) &= ~val;
+			vcpu_cp15(vcpu, c9_PMCNTENSET) &= ~val;
+			break;
+		}
 		case c9_PMCR: {
 			/* Only update writeable bits of PMCR */
 			val = vcpu_cp15(vcpu, r->reg);
@@ -1092,8 +1134,10 @@ static const struct sys_reg_desc cp15_regs[] = {
 	/* PMU */
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 0), access_pmu_cp15_regs,
 	  reset_pmcr, c9_PMCR },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), trap_raz_wi },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), access_pmu_cp15_regs,
+	  reset_unknown_cp15, c9_PMCNTENSET },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), access_pmu_cp15_regs,
+	  reset_unknown_cp15, c9_PMCNTENCLR },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmu_cp15_regs,
 	  reset_unknown_cp15, c9_PMSELR },
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 1908c88..53d5907 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -40,6 +40,8 @@ struct kvm_pmu {
 
 #ifdef CONFIG_KVM_ARM_PMU
 unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx);
+void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val);
+void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val, bool all_enable);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 				    u32 select_idx);
 #else
@@ -47,6 +49,8 @@ unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
 {
 	return 0;
 }
+void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val) {}
+void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val, bool all_enable) {}
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 				    u32 select_idx) {}
 #endif
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 900a64c..3d9075e 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -69,6 +69,58 @@ static void kvm_pmu_stop_counter(struct kvm_pmc *pmc)
 }
 
 /**
+ * kvm_pmu_enable_counter - enable selected PMU counter
+ * @vcpu: The vcpu pointer
+ * @val: the value guest writes to PMCNTENSET register
+ * @all_enable: the value of PMCR.E
+ *
+ * Call perf_event_enable to start counting the perf event
+ */
+void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val, bool all_enable)
+{
+	int i;
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc;
+
+	if (!all_enable)
+		return;
+
+	for (i = 0; i < ARMV8_MAX_COUNTERS; i++) {
+		if ((val >> i) & 0x1) {
+			pmc = &pmu->pmc[i];
+			if (pmc->perf_event) {
+				perf_event_enable(pmc->perf_event);
+				if (pmc->perf_event->state
+				    != PERF_EVENT_STATE_ACTIVE)
+					kvm_debug("fail to enable event\n");
+			}
+		}
+	}
+}
+
+/**
+ * kvm_pmu_disable_counter - disable selected PMU counter
+ * @vcpu: The vcpu pointer
+ * @val: the value guest writes to PMCNTENCLR register
+ *
+ * Call perf_event_disable to stop counting the perf event
+ */
+void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val)
+{
+	int i;
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc;
+
+	for (i = 0; i < ARMV8_MAX_COUNTERS; i++) {
+		if ((val >> i) & 0x1) {
+			pmc = &pmu->pmc[i];
+			if (pmc->perf_event)
+				perf_event_disable(pmc->perf_event);
+		}
+	}
+}
+
+/**
  * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
  * @vcpu: The vcpu pointer
  * @data: The data guest writes to PMXEVTYPER_EL0
-- 
2.0.4


