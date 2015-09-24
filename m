From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: [PATCH v3 10/20] KVM: ARM64: Add reset and access handlers for PMCCNTR register
Date: Thu, 24 Sep 2015 15:31:15 -0700
Message-ID: <1443133885-3366-11-git-send-email-shannon.zhao@linaro.org>
References: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, will.deacon@arm.com, wei@redhat.com, alex.bennee@linaro.org, peter.huangpeng@huawei.com, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Since the reset value of PMCCNTR is UNKNOWN, use reset_unknown for its
reset handler. Add a new case to emulate reading to PMCCNTR register.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e7f6058..c38c2de 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -518,6 +518,12 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 		}
 	} else {
 		switch (r->reg) {
+		case PMCCNTR_EL0: {
+			val = kvm_pmu_get_counter_value(vcpu,
+							ARMV8_MAX_COUNTERS - 1);
+			*vcpu_reg(vcpu, p->Rt) = val;
+			break;
+		}
 		case PMXEVCNTR_EL0: {
 			val = kvm_pmu_get_counter_value(vcpu,
 						vcpu_sys_reg(vcpu, PMSELR_EL0));
@@ -748,7 +754,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmu_regs, reset_pmceid, PMCEID1_EL0 },
 	/* PMCCNTR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b000),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_unknown, PMCCNTR_EL0 },
 	/* PMXEVTYPER_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b001),
 	  access_pmu_regs, reset_unknown, PMXEVTYPER_EL0 },
@@ -997,6 +1003,12 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 		}
 	} else {
 		switch (r->reg) {
+		case c9_PMCCNTR: {
+			val = kvm_pmu_get_counter_value(vcpu,
+							ARMV8_MAX_COUNTERS - 1);
+			*vcpu_reg(vcpu, p->Rt) = val;
+			break;
+		}
 		case c9_PMXEVCNTR: {
 			val = kvm_pmu_get_counter_value(vcpu,
 						    vcpu_cp15(vcpu, c9_PMSELR));
@@ -1051,7 +1063,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 	  reset_pmceid, c9_PMCEID0 },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmu_cp15_regs,
 	  reset_pmceid, c9_PMCEID1 },
-	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), access_pmu_cp15_regs,
+	  reset_unknown_cp15, c9_PMCCNTR },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), access_pmu_cp15_regs,
 	  reset_unknown_cp15, c9_PMXEVTYPER },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), access_pmu_cp15_regs,
-- 
2.1.4

