From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v5 09/21] KVM: ARM64: Add reset and access handlers for PMXEVCNTR register
Date: Thu, 3 Dec 2015 14:11:19 +0800
Message-ID: <1449123091-20252-10-git-send-email-zhaoshenglong@huawei.com>
References: <1449123091-20252-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1449123091-20252-1-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

Since the reset value of PMXEVCNTR is UNKNOWN, use reset_unknown for
its reset handler. Add access handler which emulates writing and reading
PMXEVCNTR register. When reading PMXEVCNTR, call perf_event_read_value
to get the count value of the perf event.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 53 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6967a49..43a634c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -493,6 +493,18 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 
 	if (p->is_write) {
 		switch (r->reg) {
+		case PMXEVCNTR_EL0: {
+			u64 idx = vcpu_sys_reg(vcpu, PMSELR_EL0)
+				  & ARMV8_COUNTER_MASK;
+
+			if (!pmu_counter_idx_valid(vcpu_sys_reg(vcpu, PMCR_EL0),
+						   idx))
+				break;
+
+			val = kvm_pmu_get_counter_value(vcpu, idx);
+			vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + idx) += (s64)*vcpu_reg(vcpu, p->Rt) - val;
+			break;
+		}
 		case PMXEVTYPER_EL0: {
 			u64 idx = vcpu_sys_reg(vcpu, PMSELR_EL0)
 				  & ARMV8_COUNTER_MASK;
@@ -524,6 +536,18 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 		}
 	} else {
 		switch (r->reg) {
+		case PMXEVCNTR_EL0: {
+			u64 idx = vcpu_sys_reg(vcpu, PMSELR_EL0)
+				  & ARMV8_COUNTER_MASK;
+
+			if (!pmu_counter_idx_valid(vcpu_sys_reg(vcpu, PMCR_EL0),
+						   idx))
+				break;
+
+			val = kvm_pmu_get_counter_value(vcpu, idx);
+			*vcpu_reg(vcpu, p->Rt) = val;
+			break;
+		}
 		case PMCR_EL0: {
 			/* PMCR.P & PMCR.C are RAZ */
 			val = vcpu_sys_reg(vcpu, r->reg)
@@ -754,7 +778,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmu_regs, reset_unknown, PMXEVTYPER_EL0 },
 	/* PMXEVCNTR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b010),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_unknown, PMXEVCNTR_EL0 },
 	/* PMUSERENR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b000),
 	  trap_raz_wi },
@@ -967,6 +991,18 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 
 	if (p->is_write) {
 		switch (r->reg) {
+		case c9_PMXEVCNTR: {
+			u32 idx = vcpu_cp15(vcpu, c9_PMSELR)
+				  & ARMV8_COUNTER_MASK;
+
+			if (!pmu_counter_idx_valid(vcpu_sys_reg(vcpu, c9_PMCR),
+						   idx))
+				break;
+
+			val = kvm_pmu_get_counter_value(vcpu, idx);
+			vcpu_cp15(vcpu, c14_PMEVCNTR0 + idx) += (s64)*vcpu_reg(vcpu, p->Rt) - val;
+			break;
+		}
 		case c9_PMXEVTYPER: {
 			u32 idx = vcpu_cp15(vcpu, c9_PMSELR)
 				  & ARMV8_COUNTER_MASK;
@@ -998,6 +1034,18 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 		}
 	} else {
 		switch (r->reg) {
+		case c9_PMXEVCNTR: {
+			u32 idx = vcpu_cp15(vcpu, c9_PMSELR)
+				  & ARMV8_COUNTER_MASK;
+
+			if (!pmu_counter_idx_valid(vcpu_sys_reg(vcpu, c9_PMCR),
+						   idx))
+				break;
+
+			val = kvm_pmu_get_counter_value(vcpu, idx);
+			*vcpu_reg(vcpu, p->Rt) = val;
+			break;
+		}
 		case c9_PMCR: {
 			/* PMCR.P & PMCR.C are RAZ */
 			val = vcpu_cp15(vcpu, r->reg)
@@ -1056,7 +1104,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), access_pmu_cp15_regs,
 	  NULL, c9_PMXEVTYPER },
-	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), access_pmu_cp15_regs,
+	  NULL, c9_PMXEVCNTR },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 0), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), trap_raz_wi },
-- 
2.0.4


