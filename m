From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 7/8] arm64: KVM: pmu: Make illegal accesses seen as successfully emulated
Date: Wed, 22 Feb 2017 11:47:27 +0000
Message-ID: <20170222114728.2472-8-marc.zyngier@arm.com>
References: <20170222114728.2472-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170222114728.2472-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Shannon Zhao <shannon.zhao@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Now that we can deliver an exception on an illegal PMU access,
we can stop pretending that they have failed to be emulated.

We can thus return "true" in all these cases.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 01c8d841851e..44b7a7325229 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -506,7 +506,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		return trap_raz_wi(vcpu, p, r);
 
 	if (pmu_access_el0_disabled(vcpu))
-		return false;
+		return true;
 
 	if (p->is_write) {
 		/* Only update writeable bits of PMCR */
@@ -532,7 +532,7 @@ static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		return trap_raz_wi(vcpu, p, r);
 
 	if (pmu_access_event_counter_el0_disabled(vcpu))
-		return false;
+		return true;
 
 	if (p->is_write)
 		vcpu_sys_reg(vcpu, PMSELR_EL0) = p->regval;
@@ -555,7 +555,7 @@ static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	BUG_ON(p->is_write);
 
 	if (pmu_access_el0_disabled(vcpu))
-		return false;
+		return true;
 
 	if (!(p->Op2 & 1))
 		pmceid = read_sysreg(pmceid0_el0);
@@ -594,14 +594,14 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 		if (r->Op2 == 2) {
 			/* PMXEVCNTR_EL0 */
 			if (pmu_access_event_counter_el0_disabled(vcpu))
-				return false;
+				return true;
 
 			idx = vcpu_sys_reg(vcpu, PMSELR_EL0)
 			      & ARMV8_PMU_COUNTER_MASK;
 		} else if (r->Op2 == 0) {
 			/* PMCCNTR_EL0 */
 			if (pmu_access_cycle_counter_el0_disabled(vcpu))
-				return false;
+				return true;
 
 			idx = ARMV8_PMU_CYCLE_IDX;
 		} else {
@@ -610,13 +610,13 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 	} else if (r->CRn == 0 && r->CRm == 9) {
 		/* PMCCNTR */
 		if (pmu_access_event_counter_el0_disabled(vcpu))
-			return false;
+			return true;
 
 		idx = ARMV8_PMU_CYCLE_IDX;
 	} else if (r->CRn == 14 && (r->CRm & 12) == 8) {
 		/* PMEVCNTRn_EL0 */
 		if (pmu_access_event_counter_el0_disabled(vcpu))
-			return false;
+			return true;
 
 		idx = ((r->CRm & 3) << 3) | (r->Op2 & 7);
 	} else {
@@ -624,11 +624,11 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 	}
 
 	if (!pmu_counter_idx_valid(vcpu, idx))
-		return false;
+		return true;
 
 	if (p->is_write) {
 		if (pmu_access_el0_disabled(vcpu))
-			return false;
+			return true;
 
 		kvm_pmu_set_counter_value(vcpu, idx, p->regval);
 	} else {
@@ -647,7 +647,7 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		return trap_raz_wi(vcpu, p, r);
 
 	if (pmu_access_el0_disabled(vcpu))
-		return false;
+		return true;
 
 	if (r->CRn == 9 && r->CRm == 13 && r->Op2 == 1) {
 		/* PMXEVTYPER_EL0 */
@@ -665,7 +665,7 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	}
 
 	if (!pmu_counter_idx_valid(vcpu, idx))
-		return false;
+		return true;
 
 	if (p->is_write) {
 		kvm_pmu_set_counter_event_type(vcpu, p->regval, idx);
@@ -686,7 +686,7 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		return trap_raz_wi(vcpu, p, r);
 
 	if (pmu_access_el0_disabled(vcpu))
-		return false;
+		return true;
 
 	mask = kvm_pmu_valid_counter_mask(vcpu);
 	if (p->is_write) {
@@ -745,7 +745,7 @@ static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		return trap_raz_wi(vcpu, p, r);
 
 	if (pmu_access_el0_disabled(vcpu))
-		return false;
+		return true;
 
 	if (p->is_write) {
 		if (r->CRm & 0x2)
@@ -770,7 +770,7 @@ static bool access_pmswinc(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		return trap_raz_wi(vcpu, p, r);
 
 	if (pmu_write_swinc_el0_disabled(vcpu))
-		return false;
+		return true;
 
 	if (p->is_write) {
 		mask = kvm_pmu_valid_counter_mask(vcpu);
@@ -779,7 +779,7 @@ static bool access_pmswinc(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	}
 
 	pend_undef(vcpu);
-	return false;
+	return true;
 }
 
 static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
-- 
2.11.0
