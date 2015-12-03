From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v5 13/21] KVM: ARM64: Add reset and access handlers for
 PMOVSSET and PMOVSCLR register
Date: Thu, 3 Dec 2015 14:11:23 +0800
Message-ID: <1449123091-20252-14-git-send-email-zhaoshenglong@huawei.com>
References: <1449123091-20252-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35E43498ED
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 01:23:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zhRsWczLl1T1 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2015 01:23:40 -0500 (EST)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [119.145.14.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5DEFF498E4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 01:23:38 -0500 (EST)
In-Reply-To: <1449123091-20252-1-git-send-email-zhaoshenglong@huawei.com>
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

Since the reset value of PMOVSSET and PMOVSCLR is UNKNOWN, use
reset_unknown for its reset handler. Add a new case to emulate writing
PMOVSSET or PMOVSCLR register.

When writing non-zero value to PMOVSSET, pend PMU interrupt. When the
value writing to PMOVSCLR is equal to the current value, clear the PMU
pending interrupt.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 25 +++++++++++++--
 include/kvm/arm_pmu.h     |  4 +++
 virt/kvm/arm/pmu.c        | 80 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 106 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a4f9177..f5e0732 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -559,6 +559,14 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 			vcpu_sys_reg(vcpu, PMINTENSET_EL1) &= ~val;
 			break;
 		}
+		case PMOVSSET_EL0: {
+			kvm_pmu_overflow_set(vcpu, *vcpu_reg(vcpu, p->Rt));
+			break;
+		}
+		case PMOVSCLR_EL0: {
+			kvm_pmu_overflow_clear(vcpu, *vcpu_reg(vcpu, p->Rt));
+			break;
+		}
 		case PMCR_EL0: {
 			/* Only update writeable bits of PMCR */
 			val = vcpu_sys_reg(vcpu, r->reg);
@@ -803,7 +811,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmu_regs, reset_unknown, PMCNTENCLR_EL0 },
 	/* PMOVSCLR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b011),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_unknown, PMOVSCLR_EL0 },
 	/* PMSWINC_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b100),
 	  trap_raz_wi },
@@ -830,7 +838,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  trap_raz_wi },
 	/* PMOVSSET_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b011),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_unknown, PMOVSSET_EL0 },
 
 	/* TPIDR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1101), CRm(0b0000), Op2(0b010),
@@ -1103,6 +1111,14 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 			vcpu_cp15(vcpu, c9_PMINTENSET) &= ~val;
 			break;
 		}
+		case c9_PMOVSSET: {
+			kvm_pmu_overflow_set(vcpu, *vcpu_reg(vcpu, p->Rt));
+			break;
+		}
+		case c9_PMOVSCLR: {
+			kvm_pmu_overflow_clear(vcpu, *vcpu_reg(vcpu, p->Rt));
+			break;
+		}
 		case c9_PMCR: {
 			/* Only update writeable bits of PMCR */
 			val = vcpu_cp15(vcpu, r->reg);
@@ -1188,7 +1204,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 	  NULL, c9_PMCNTENSET },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), access_pmu_cp15_regs,
 	  NULL, c9_PMCNTENCLR },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), access_pmu_cp15_regs,
+	  NULL, c9_PMOVSCLR },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmu_cp15_regs,
 	  NULL, c9_PMSELR },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmu_cp15_regs,
@@ -1206,6 +1223,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 	  NULL, c9_PMINTENSET },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), access_pmu_cp15_regs,
 	  NULL, c9_PMINTENCLR },
+	{ Op1( 0), CRn( 9), CRm(14), Op2( 3), access_pmu_cp15_regs,
+	  NULL, c9_PMOVSSET },
 
 	{ Op1( 0), CRn(10), CRm( 2), Op2( 0), access_vm_reg, NULL, c10_PRRR },
 	{ Op1( 0), CRn(10), CRm( 2), Op2( 1), access_vm_reg, NULL, c10_NMRR },
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index fff8f15..4f3154c 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -42,6 +42,8 @@ struct kvm_pmu {
 unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx);
 void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val);
 void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val, bool all_enable);
+void kvm_pmu_overflow_clear(struct kvm_vcpu *vcpu, u32 val);
+void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u32 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 				    u32 select_idx);
 #else
@@ -51,6 +53,8 @@ unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
 }
 void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val) {}
 void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val, bool all_enable) {}
+void kvm_pmu_overflow_clear(struct kvm_vcpu *vcpu, u32 val) {}
+void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u32 val) {}
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 				    u32 select_idx) {}
 #endif
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 0d143ca..296b4ad 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -125,6 +125,86 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val)
 	}
 }
 
+static unsigned long kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
+{
+	u32 val;
+
+	if (!vcpu_mode_is_32bit(vcpu))
+	val = (vcpu_sys_reg(vcpu, PMCR_EL0) >> ARMV8_PMCR_N_SHIFT)
+	      & ARMV8_PMCR_N_MASK;
+	else
+	val = (vcpu_cp15(vcpu, c9_PMCR) >> ARMV8_PMCR_N_SHIFT)
+	      & ARMV8_PMCR_N_MASK;
+
+	return GENMASK(val - 1, 0) | BIT(ARMV8_COUNTER_MASK);
+}
+
+/**
+ * kvm_pmu_overflow_clear - clear PMU overflow interrupt
+ * @vcpu: The vcpu pointer
+ * @val: the value guest writes to PMOVSCLR register
+ * @reg: the current value of PMOVSCLR register
+ */
+void kvm_pmu_overflow_clear(struct kvm_vcpu *vcpu, u32 val)
+{
+	u32 mask = kvm_pmu_valid_counter_mask(vcpu);
+
+	if (!vcpu_mode_is_32bit(vcpu)) {
+		vcpu_sys_reg(vcpu, PMOVSCLR_EL0) &= mask;
+		vcpu_sys_reg(vcpu, PMOVSCLR_EL0) &= ~val;
+		vcpu_sys_reg(vcpu, PMOVSSET_EL0) &= mask;
+		vcpu_sys_reg(vcpu, PMOVSSET_EL0) &= ~val;
+		val = vcpu_sys_reg(vcpu, PMOVSSET_EL0);
+	} else {
+		vcpu_cp15(vcpu, c9_PMOVSCLR) &= mask;
+		vcpu_cp15(vcpu, c9_PMOVSCLR) &= ~val;
+		vcpu_cp15(vcpu, c9_PMOVSSET) &= mask;
+		vcpu_cp15(vcpu, c9_PMOVSSET) &= ~val;
+		val = vcpu_cp15(vcpu, c9_PMOVSSET);
+	}
+
+	/* If all overflow bits are cleared, kick the vcpu to clear interrupt
+	 * pending status.
+	 */
+	if (val == 0)
+		kvm_vcpu_kick(vcpu);
+}
+
+/**
+ * kvm_pmu_overflow_set - set PMU overflow interrupt
+ * @vcpu: The vcpu pointer
+ * @val: the value guest writes to PMOVSSET register
+ */
+void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u32 val)
+{
+	u32 mask = kvm_pmu_valid_counter_mask(vcpu);
+
+	val &= mask;
+	if (val == 0)
+		return;
+
+	if (!vcpu_mode_is_32bit(vcpu)) {
+		vcpu_sys_reg(vcpu, PMOVSSET_EL0) &= mask;
+		vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= val;
+		vcpu_sys_reg(vcpu, PMOVSCLR_EL0) &= mask;
+		vcpu_sys_reg(vcpu, PMOVSCLR_EL0) |= val;
+		val = vcpu_sys_reg(vcpu, PMCNTENSET_EL0)
+		      & vcpu_sys_reg(vcpu, PMINTENSET_EL1)
+		      & vcpu_sys_reg(vcpu, PMOVSSET_EL0);
+	} else {
+		vcpu_cp15(vcpu, c9_PMOVSSET) &= mask;
+		vcpu_cp15(vcpu, c9_PMOVSSET) |= val;
+		vcpu_cp15(vcpu, c9_PMOVSCLR) &= mask;
+		vcpu_cp15(vcpu, c9_PMOVSCLR) |= val;
+		val = vcpu_cp15(vcpu, c9_PMCNTENSET)
+		      & vcpu_cp15(vcpu, c9_PMINTENSET)
+		      & vcpu_cp15(vcpu, c9_PMOVSSET);
+	}
+
+	if (val != 0)
+		kvm_vcpu_kick(vcpu);
+}
+
 /**
  * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
  * @vcpu: The vcpu pointer
-- 
2.0.4
