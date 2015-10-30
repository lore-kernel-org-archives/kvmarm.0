From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v4 10/21] KVM: ARM64: Add reset and access handlers for PMCCNTR register
Date: Fri, 30 Oct 2015 14:21:52 +0800
Message-ID: <1446186123-11548-11-git-send-email-zhaoshenglong@huawei.com>
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

Since the reset value of PMCCNTR is UNKNOWN, use reset_unknown for its
reset handler. Add a new case to emulate reading and writing to PMCCNTR
register.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b7ca2cd..059c84c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -491,6 +491,13 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 
 	if (p->is_write) {
 		switch (r->reg) {
+		case PMCCNTR_EL0: {
+			val = kvm_pmu_get_counter_value(vcpu,
+							ARMV8_MAX_COUNTERS - 1);
+			vcpu_sys_reg(vcpu, r->reg) +=
+					      (s64)*vcpu_reg(vcpu, p->Rt) - val;
+			break;
+		}
 		case PMXEVCNTR_EL0: {
 			int index = PMEVCNTR0_EL0
 				    + vcpu_sys_reg(vcpu, PMSELR_EL0);
@@ -529,6 +536,12 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
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
@@ -759,7 +772,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmu_regs, reset_pmceid, PMCEID1_EL0 },
 	/* PMCCNTR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b000),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_unknown, PMCCNTR_EL0 },
 	/* PMXEVTYPER_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b001),
 	  access_pmu_regs, reset_unknown, PMXEVTYPER_EL0 },
@@ -978,6 +991,13 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 
 	if (p->is_write) {
 		switch (r->reg) {
+		case c9_PMCCNTR: {
+			val = kvm_pmu_get_counter_value(vcpu,
+							ARMV8_MAX_COUNTERS - 1);
+			vcpu_cp15(vcpu, r->reg) += (s64)*vcpu_reg(vcpu, p->Rt)
+						   - val;
+			break;
+		}
 		case c9_PMXEVCNTR: {
 			int index = c14_PMEVCNTR0 + vcpu_cp15(vcpu, c9_PMSELR);
 
@@ -1014,6 +1034,12 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
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
@@ -1075,7 +1101,8 @@ static const struct sys_reg_desc cp15_regs[] = {
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
2.0.4


