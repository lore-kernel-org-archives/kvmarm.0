From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v7 15/19] KVM: ARM64: Add access handler for PMUSERENR register
Date: Tue, 15 Dec 2015 16:49:35 +0800
Message-ID: <1450169379-12336-16-git-send-email-zhaoshenglong@huawei.com>
References: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

The reset value of PMUSERENR_EL0 is UNKNOWN, use reset_unknown.

PMUSERENR_EL0 holds some bits which decide whether PMU registers can be
accessed from EL0. Add some check helpers to handle the access from EL0.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 124 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 119 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b2ccc25..bad3dfd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -452,12 +452,44 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	vcpu_sys_reg(vcpu, r->reg) = val;
 }
 
+static inline bool pmu_access_el0_disabled(struct kvm_vcpu *vcpu)
+{
+	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
+
+	return !((reg & 0x1) || vcpu_mode_priv(vcpu));
+}
+
+static inline bool pmu_write_swinc_el0_disabled(struct kvm_vcpu *vcpu)
+{
+	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
+
+	return !((reg & 0x3) || vcpu_mode_priv(vcpu));
+}
+
+static inline bool pmu_access_cycle_counter_el0_disabled(struct kvm_vcpu *vcpu)
+{
+	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
+
+	return !((reg & 0x5) || vcpu_mode_priv(vcpu));
+}
+
+static inline bool pmu_access_event_counter_el0_disabled(struct kvm_vcpu *vcpu)
+{
+	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
+
+	return !((reg & 0x9) || vcpu_mode_priv(vcpu));
+}
+
 static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
 {
 	u64 val;
+	bool unaccessible = pmu_access_el0_disabled(vcpu);
 
 	if (p->is_write) {
+		if (unaccessible)
+			return ignore_write(vcpu, p);
+
 		/* Only update writeable bits of PMCR */
 		val = vcpu_sys_reg(vcpu, r->reg);
 		val &= ~ARMV8_PMCR_MASK;
@@ -465,6 +497,9 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		vcpu_sys_reg(vcpu, r->reg) = val;
 		kvm_pmu_handle_pmcr(vcpu, val);
 	} else {
+		if (unaccessible)
+			return read_zero(vcpu, p);
+
 		/* PMCR.P & PMCR.C are RAZ */
 		val = vcpu_sys_reg(vcpu, r->reg)
 		      & ~(ARMV8_PMCR_P | ARMV8_PMCR_C);
@@ -477,9 +512,17 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
+	bool unaccessible = pmu_access_event_counter_el0_disabled(vcpu);
+
 	if (p->is_write) {
+		if (unaccessible)
+			return ignore_write(vcpu, p);
+
 		vcpu_sys_reg(vcpu, r->reg) = p->regval;
 	} else {
+		if (unaccessible)
+			return read_zero(vcpu, p);
+
 		/* return PMSELR.SEL field */
 		p->regval = vcpu_sys_reg(vcpu, r->reg) & ARMV8_COUNTER_MASK;
 	}
@@ -494,6 +537,8 @@ static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 	if (p->is_write)
 		return write_to_read_only(vcpu, p);
+	else if (pmu_access_el0_disabled(vcpu))
+		return read_zero(vcpu, p);
 
 	if (!(p->Op2 & 1))
 		asm volatile("mrs %0, pmceid0_el0\n" : "=r" (pmceid));
@@ -521,6 +566,7 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			       const struct sys_reg_desc *r)
 {
 	u64 idx, reg;
+	bool unaccessible = pmu_access_el0_disabled(vcpu);
 
 	if (r->CRn == 9) {
 		/* PMXEVTYPER_EL0 */
@@ -558,9 +604,15 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	}
 
 	if (p->is_write) {
+		if (unaccessible)
+			return ignore_write(vcpu, p);
+
 		kvm_pmu_set_counter_event_type(vcpu, p->regval, idx);
 		vcpu_sys_reg(vcpu, reg) = p->regval & ARMV8_EVTYPE_MASK;
 	} else {
+		if (unaccessible)
+			return read_zero(vcpu, p);
+
 		p->regval = vcpu_sys_reg(vcpu, reg) & ARMV8_EVTYPE_MASK;
 	}
 
@@ -572,6 +624,7 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 			      const struct sys_reg_desc *r)
 {
 	u64 idx, reg, val;
+	bool unaccessible = false;
 
 	if (!p->is_aarch32) {
 		if (r->CRn == 9 && r->CRm == 13 && r->Op2 == 2)
@@ -591,13 +644,22 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 
 	switch (reg) {
 	case PMEVCNTR0_EL0 ... PMEVCNTR30_EL0:
+		if (pmu_access_event_counter_el0_disabled(vcpu))
+			unaccessible = true;
+
 		idx = reg - PMEVCNTR0_EL0;
 		break;
 	case PMCCNTR_EL0:
+		if (pmu_access_cycle_counter_el0_disabled(vcpu))
+			unaccessible = true;
+
 		idx = ARMV8_CYCLE_IDX;
 		break;
 	default:
 		/* PMXEVCNTR_EL0 */
+		if (pmu_access_event_counter_el0_disabled(vcpu))
+			unaccessible = true;
+
 		idx = vcpu_sys_reg(vcpu, PMSELR_EL0) & ARMV8_COUNTER_MASK;
 		if (!pmu_counter_idx_valid(vcpu, idx))
 			return true;
@@ -608,10 +670,17 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 	}
 
 	val = kvm_pmu_get_counter_value(vcpu, idx);
-	if (p->is_write)
+	if (p->is_write) {
+		if (unaccessible)
+			return ignore_write(vcpu, p);
+
 		vcpu_sys_reg(vcpu, reg) += (s64)p->regval - val;
-	else
+	} else {
+		if (unaccessible)
+			return read_zero(vcpu, p);
+
 		p->regval = val;
+	}
 
 	return true;
 }
@@ -628,9 +697,13 @@ static bool access_pmcntenset(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			      const struct sys_reg_desc *r)
 {
 	u64 val, mask;
+	bool unaccessible = pmu_access_el0_disabled(vcpu);
 
 	mask = kvm_pmu_valid_counter_mask(vcpu);
 	if (p->is_write) {
+		if (unaccessible)
+			return ignore_write(vcpu, p);
+
 		val = p->regval & mask;
 		if (r->Op2 & 0x1) {
 			/* accessing PMCNTENSET_EL0 */
@@ -643,6 +716,9 @@ static bool access_pmcntenset(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			kvm_pmu_disable_counter(vcpu, val);
 		}
 	} else {
+		if (unaccessible)
+			return read_zero(vcpu, p);
+
 		p->regval = vcpu_sys_reg(vcpu, r->reg) & mask;
 	}
 
@@ -653,8 +729,12 @@ static bool access_pmintenset(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			      const struct sys_reg_desc *r)
 {
 	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
+	bool unaccessible = !vcpu_mode_priv(vcpu);
 
 	if (p->is_write) {
+		if (unaccessible)
+			return ignore_write(vcpu, p);
+
 		if (r->Op2 & 0x1) {
 			/* accessing PMINTENSET_EL1 */
 			vcpu_sys_reg(vcpu, r->reg) |= (p->regval & mask);
@@ -664,6 +744,9 @@ static bool access_pmintenset(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			vcpu_sys_reg(vcpu, r->reg) &= ~p->regval;
 		}
 	} else {
+		if (unaccessible)
+			return read_zero(vcpu, p);
+
 		p->regval = vcpu_sys_reg(vcpu, r->reg) & mask;
 	}
 
@@ -674,8 +757,12 @@ static bool access_pmovsset(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			    const struct sys_reg_desc *r)
 {
 	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
+	bool unaccessible = pmu_access_el0_disabled(vcpu);
 
 	if (p->is_write) {
+		if (unaccessible)
+			return ignore_write(vcpu, p);
+
 		if (r->CRm & 0x2) {
 			/* accessing PMOVSSET_EL0 */
 			kvm_pmu_overflow_set(vcpu, p->regval & mask);
@@ -685,6 +772,9 @@ static bool access_pmovsset(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			vcpu_sys_reg(vcpu, r->reg) &= ~p->regval;
 		}
 	} else {
+		if (unaccessible)
+			return read_zero(vcpu, p);
+
 		p->regval = vcpu_sys_reg(vcpu, r->reg) & mask;
 	}
 
@@ -695,6 +785,9 @@ static bool access_pmswinc(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
 	if (p->is_write) {
+		if (pmu_write_swinc_el0_disabled(vcpu))
+			return ignore_write(vcpu, p);
+
 		kvm_pmu_software_increment(vcpu, p->regval);
 		return true;
 	} else {
@@ -702,6 +795,24 @@ static bool access_pmswinc(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	}
 }
 
+static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			     const struct sys_reg_desc *r)
+{
+	if (p->is_write) {
+		if (!vcpu_mode_priv(vcpu))
+			return write_to_read_only(vcpu, p);
+
+		vcpu_sys_reg(vcpu, r->reg) = p->regval & 0xf;
+	} else {
+		if (pmu_access_el0_disabled(vcpu))
+			return read_zero(vcpu, p);
+
+		p->regval = vcpu_sys_reg(vcpu, r->reg) & 0xf;
+	}
+
+	return true;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	/* DBGBVRn_EL1 */						\
@@ -931,9 +1042,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	/* PMXEVCNTR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b010),
 	  access_pmu_evcntr },
-	/* PMUSERENR_EL0 */
+	/* PMUSERENR_EL0
+	 * This register resets as unknown in 64bit mode while it resets as zero
+	 * in 32bit mode. Here we choose to reset it as zero for consistency.
+	 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b000),
-	  trap_raz_wi },
+	  access_pmuserenr, reset_val, PMUSERENR_EL0, 0 },
 	/* PMOVSSET_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b011),
 	  access_pmovsset, reset_unknown, PMOVSSET_EL0 },
@@ -1258,7 +1372,7 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), access_pmu_evcntr },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), access_pmu_evtyper },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), access_pmu_evcntr },
-	{ Op1( 0), CRn( 9), CRm(14), Op2( 0), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(14), Op2( 0), access_pmuserenr },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), access_pmintenset },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), access_pmintenset },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 3), access_pmovsset },
-- 
2.0.4


