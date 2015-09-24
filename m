From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: [PATCH v3 11/20] KVM: ARM64: Add reset and access handlers for PMCNTENSET and PMCNTENCLR register
Date: Thu, 24 Sep 2015 15:31:16 -0700
Message-ID: <1443133885-3366-12-git-send-email-shannon.zhao@linaro.org>
References: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, will.deacon@arm.com, wei@redhat.com, alex.bennee@linaro.org, peter.huangpeng@huawei.com, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Since the reset value of PMCNTENSET and PMCNTENCLR is UNKNOWN, use
reset_unknown for its reset handler. Add a new case to emulate writing
PMCNTENSET or PMCNTENCLR register.

When writing to PMCNTENSET, call perf_event_enable to enable the perf
event. When writing to PMCNTENCLR, call perf_event_disable to disable
the perf event.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 46 +++++++++++++++++++++++++++++++++++++++++----
 include/kvm/arm_pmu.h     |  4 ++++
 virt/kvm/arm/pmu.c        | 48 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c38c2de..98da5a2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -501,6 +501,24 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 						       val);
 			break;
 		}
+		case PMCNTENSET_EL0: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			kvm_pmu_enable_counter(vcpu, val);
+			/*Value 1 of PMCNTENSET_EL0 and PMCNTENCLR_EL0 means
+			 * corresponding counter enabled */
+			vcpu_sys_reg(vcpu, r->reg) |= val;
+			vcpu_sys_reg(vcpu, PMCNTENCLR_EL0) |= val;
+			break;
+		}
+		case PMCNTENCLR_EL0: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			kvm_pmu_disable_counter(vcpu, val);
+			/*Value 0 of PMCNTENSET_EL0 and PMCNTENCLR_EL0 means
+			 * corresponding counter disabled */
+			vcpu_sys_reg(vcpu, r->reg) &= ~val;
+			vcpu_sys_reg(vcpu, PMCNTENSET_EL0) &= ~val;
+			break;
+		}
 		case PMCR_EL0: {
 			/* Only update writeable bits of PMCR */
 			val = vcpu_sys_reg(vcpu, r->reg);
@@ -733,10 +751,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
@@ -986,6 +1004,24 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 						       val);
 			break;
 		}
+		case c9_PMCNTENSET: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			kvm_pmu_enable_counter(vcpu, val);
+			/*Value 1 of PMCNTENSET_EL0 and PMCNTENCLR_EL0 means
+			 * corresponding counter enabled */
+			vcpu_cp15(vcpu, r->reg) |= val;
+			vcpu_cp15(vcpu, c9_PMCNTENCLR) |= val;
+			break;
+		}
+		case c9_PMCNTENCLR: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			kvm_pmu_disable_counter(vcpu, val);
+			/*Value 0 of PMCNTENSET_EL0 and PMCNTENCLR_EL0 means
+			 * corresponding counter disabled */
+			vcpu_cp15(vcpu, r->reg) &= ~val;
+			vcpu_cp15(vcpu, c9_PMCNTENSET) &= ~val;
+			break;
+		}
 		case c9_PMCR: {
 			/* Only update writeable bits of PMCR */
 			val = vcpu_cp15(vcpu, r->reg);
@@ -1054,8 +1090,10 @@ static const struct sys_reg_desc cp15_regs[] = {
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
index b48cdc6..9b4ee5e 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -39,6 +39,8 @@ struct kvm_pmu {
 
 #ifdef CONFIG_KVM_ARM_PMU
 unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx);
+void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val);
+void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 				    u32 select_idx);
 #else
@@ -46,6 +48,8 @@ unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
 {
 	return 0;
 }
+void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val) {}
+void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val) {}
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 				    u32 select_idx) {}
 #endif
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 002ec79..46145d1 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -86,6 +86,54 @@ unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
 }
 
 /**
+ * kvm_pmu_enable_counter - enable selected PMU counter
+ * @vcpu: The vcpu pointer
+ * @val: the value guest writes to PMCNTENSET register
+ *
+ * Call perf_event_enable to start counting the perf event
+ */
+void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val)
+{
+	int i;
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc;
+
+	for (i = 0; i < 32; i++) {
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
+	for (i = 0; i < 32; i++) {
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
2.1.4

