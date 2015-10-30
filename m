From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v4 13/21] KVM: ARM64: Add reset and access handlers for PMOVSSET and PMOVSCLR register
Date: Fri, 30 Oct 2015 14:21:55 +0800
Message-ID: <1446186123-11548-14-git-send-email-zhaoshenglong@huawei.com>
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

Since the reset value of PMOVSSET and PMOVSCLR is UNKNOWN, use
reset_unknown for its reset handler. Add a new case to emulate writing
PMOVSSET or PMOVSCLR register.

When writing non-zero value to PMOVSSET, pend PMU interrupt. When the
value writing to PMOVSCLR is equal to the current value, clear the PMU
pending interrupt.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 39 ++++++++++++++++++++++++++++++++++++---
 include/kvm/arm_pmu.h     |  4 ++++
 virt/kvm/arm/pmu.c        | 30 ++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6d2febf..e03d3b8d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -552,6 +552,21 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 			vcpu_sys_reg(vcpu, PMINTENSET_EL1) &= ~val;
 			break;
 		}
+		case PMOVSSET_EL0: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			kvm_pmu_overflow_set(vcpu, val);
+			vcpu_sys_reg(vcpu, r->reg) |= val;
+			vcpu_sys_reg(vcpu, PMOVSCLR_EL0) |= val;
+			break;
+		}
+		case PMOVSCLR_EL0: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			kvm_pmu_overflow_clear(vcpu, val,
+					       vcpu_sys_reg(vcpu, r->reg));
+			vcpu_sys_reg(vcpu, r->reg) &= ~val;
+			vcpu_sys_reg(vcpu, PMOVSSET_EL0) &= ~val;
+			break;
+		}
 		case PMCR_EL0: {
 			/* Only update writeable bits of PMCR */
 			val = vcpu_sys_reg(vcpu, r->reg);
@@ -790,7 +805,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmu_regs, reset_unknown, PMCNTENCLR_EL0 },
 	/* PMOVSCLR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b011),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_unknown, PMOVSCLR_EL0 },
 	/* PMSWINC_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b100),
 	  trap_raz_wi },
@@ -817,7 +832,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  trap_raz_wi },
 	/* PMOVSSET_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b011),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_unknown, PMOVSSET_EL0 },
 
 	/* TPIDR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1101), CRm(0b0000), Op2(0b010),
@@ -1083,6 +1098,21 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 			vcpu_cp15(vcpu, c9_PMINTENSET) &= ~val;
 			break;
 		}
+		case c9_PMOVSSET: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			kvm_pmu_overflow_set(vcpu, val);
+			vcpu_cp15(vcpu, r->reg) |= val;
+			vcpu_cp15(vcpu, c9_PMOVSCLR) |= val;
+			break;
+		}
+		case c9_PMOVSCLR: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			kvm_pmu_overflow_clear(vcpu, val,
+					       vcpu_cp15(vcpu, r->reg));
+			vcpu_cp15(vcpu, r->reg) &= ~val;
+			vcpu_cp15(vcpu, c9_PMOVSSET) &= ~val;
+			break;
+		}
 		case c9_PMCR: {
 			/* Only update writeable bits of PMCR */
 			val = vcpu_cp15(vcpu, r->reg);
@@ -1162,7 +1192,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 	  reset_unknown_cp15, c9_PMCNTENSET },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), access_pmu_cp15_regs,
 	  reset_unknown_cp15, c9_PMCNTENCLR },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), access_pmu_cp15_regs,
+	  reset_unknown_cp15, c9_PMOVSCLR },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmu_cp15_regs,
 	  reset_unknown_cp15, c9_PMSELR },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmu_cp15_regs,
@@ -1180,6 +1211,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 	  reset_unknown_cp15, c9_PMINTENSET },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), access_pmu_cp15_regs,
 	  reset_unknown_cp15, c9_PMINTENCLR },
+	{ Op1( 0), CRn( 9), CRm(14), Op2( 3), access_pmu_cp15_regs,
+	  reset_unknown_cp15, c9_PMOVSSET },
 
 	{ Op1( 0), CRn(10), CRm( 2), Op2( 0), access_vm_reg, NULL, c10_PRRR },
 	{ Op1( 0), CRn(10), CRm( 2), Op2( 1), access_vm_reg, NULL, c10_NMRR },
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 53d5907..ff17578 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -42,6 +42,8 @@ struct kvm_pmu {
 unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx);
 void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val);
 void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val, bool all_enable);
+void kvm_pmu_overflow_clear(struct kvm_vcpu *vcpu, u32 val, u32 reg);
+void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u32 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 				    u32 select_idx);
 #else
@@ -51,6 +53,8 @@ unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
 }
 void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val) {}
 void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val, bool all_enable) {}
+void kvm_pmu_overflow_clear(struct kvm_vcpu *vcpu, u32 val, u32 reg) {}
+void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u32 val) {}
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 				    u32 select_idx) {}
 #endif
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 3d9075e..5761386 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -121,6 +121,36 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val)
 }
 
 /**
+ * kvm_pmu_overflow_clear - clear PMU overflow interrupt
+ * @vcpu: The vcpu pointer
+ * @val: the value guest writes to PMOVSCLR register
+ * @reg: the current value of PMOVSCLR register
+ */
+void kvm_pmu_overflow_clear(struct kvm_vcpu *vcpu, u32 val, u32 reg)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+
+	/* If all overflow bits are cleared, clear interrupt pending status*/
+	if (val == reg)
+		pmu->irq_pending = false;
+}
+
+/**
+ * kvm_pmu_overflow_set - set PMU overflow interrupt
+ * @vcpu: The vcpu pointer
+ * @val: the value guest writes to PMOVSSET register
+ */
+void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u32 val)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+
+	if (val != 0) {
+		pmu->irq_pending = true;
+		kvm_vcpu_kick(vcpu);
+	}
+}
+
+/**
  * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
  * @vcpu: The vcpu pointer
  * @data: The data guest writes to PMXEVTYPER_EL0
-- 
2.0.4


