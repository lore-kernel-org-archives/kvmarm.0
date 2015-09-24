From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: [PATCH v3 09/20] KVM: ARM64: Add reset and access handlers for PMXEVCNTR register
Date: Thu, 24 Sep 2015 15:31:14 -0700
Message-ID: <1443133885-3366-10-git-send-email-shannon.zhao@linaro.org>
References: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, will.deacon@arm.com, wei@redhat.com, alex.bennee@linaro.org, peter.huangpeng@huawei.com, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Since the reset value of PMXEVCNTR is UNKNOWN, use reset_unknown for
its reset handler. Add access handler which emulates writing and reading
PMXEVCNTR register. When reading PMXEVCNTR, call perf_event_read_value
to get the count value of the perf event.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 41 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 605972e..e7f6058 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -488,6 +488,12 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 
 	if (p->is_write) {
 		switch (r->reg) {
+		case PMXEVCNTR_EL0: {
+			val = PMEVCNTR0_EL0 + vcpu_sys_reg(vcpu, PMSELR_EL0);
+			vcpu_sys_reg(vcpu, val) =
+					  *vcpu_reg(vcpu, p->Rt) & 0xffffffffUL;
+			break;
+		}
 		case PMXEVTYPER_EL0: {
 			val = vcpu_sys_reg(vcpu, PMSELR_EL0);
 			kvm_pmu_set_counter_event_type(vcpu,
@@ -511,7 +517,17 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 			break;
 		}
 	} else {
-		*vcpu_reg(vcpu, p->Rt) = vcpu_sys_reg(vcpu, r->reg);
+		switch (r->reg) {
+		case PMXEVCNTR_EL0: {
+			val = kvm_pmu_get_counter_value(vcpu,
+						vcpu_sys_reg(vcpu, PMSELR_EL0));
+			*vcpu_reg(vcpu, p->Rt) = val;
+			break;
+		}
+		default:
+			*vcpu_reg(vcpu, p->Rt) = vcpu_sys_reg(vcpu, r->reg);
+			break;
+		}
 	}
 
 	return true;
@@ -738,7 +754,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmu_regs, reset_unknown, PMXEVTYPER_EL0 },
 	/* PMXEVCNTR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b010),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_unknown, PMXEVCNTR_EL0 },
 	/* PMUSERENR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b000),
 	  trap_raz_wi },
@@ -951,6 +967,12 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 
 	if (p->is_write) {
 		switch (r->reg) {
+		case c9_PMXEVCNTR: {
+			val = c14_PMEVCNTR0 + vcpu_cp15(vcpu, c9_PMSELR);
+			vcpu_cp15(vcpu, val) =
+					  *vcpu_reg(vcpu, p->Rt) & 0xffffffffUL;
+			break;
+		}
 		case c9_PMXEVTYPER: {
 			val = vcpu_cp15(vcpu, c9_PMSELR);
 			kvm_pmu_set_counter_event_type(vcpu,
@@ -974,7 +996,17 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 			break;
 		}
 	} else {
-		*vcpu_reg(vcpu, p->Rt) = vcpu_cp15(vcpu, r->reg);
+		switch (r->reg) {
+		case c9_PMXEVCNTR: {
+			val = kvm_pmu_get_counter_value(vcpu,
+						    vcpu_cp15(vcpu, c9_PMSELR));
+			*vcpu_reg(vcpu, p->Rt) = val;
+			break;
+		}
+		default:
+			*vcpu_reg(vcpu, p->Rt) = vcpu_cp15(vcpu, r->reg);
+			break;
+		}
 	}
 
 	return true;
@@ -1022,7 +1054,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), access_pmu_cp15_regs,
 	  reset_unknown_cp15, c9_PMXEVTYPER },
-	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), access_pmu_cp15_regs,
+	  reset_unknown_cp15, c9_PMXEVCNTR },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 0), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), trap_raz_wi },
-- 
2.1.4

