From: shannon.zhao@linaro.org
Subject: [PATCH 08/18] KVM: ARM64: Add reset and access handlers for PMXEVTYPER_EL0 register
Date: Mon,  6 Jul 2015 10:17:38 +0800
Message-ID: <1436149068-3784-9-git-send-email-shannon.zhao@linaro.org>
References: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com, marc.zyngier@arm.com, alex.bennee@linaro.org, shannon.zhao@linaro.org, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

Since the reset value of PMXEVTYPER_EL0 is UNKNOWN, use reset_unknown
for its reset handler. Add access handler which emulates writing and
reading PMXEVTYPER_EL0 register. When writing to PMXEVTYPER_EL0, call
kvm_pmu_set_counter_event_type create a perf event for the selected
event type.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1df9ef3..b4f8dd9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -331,6 +331,31 @@ static bool access_pmceid(struct kvm_vcpu *vcpu,
 	}
 }
 
+/* PMXEVTYPER_EL0 accessor. */
+static bool access_pmxevtyper(struct kvm_vcpu *vcpu,
+			      const struct sys_reg_params *p,
+			      const struct sys_reg_desc *r)
+{
+	unsigned long val;
+
+	if (p->is_write) {
+		if (!p->is_aarch32)
+			vcpu_sys_reg(vcpu, r->reg) = *vcpu_reg(vcpu, p->Rt);
+		else
+			vcpu_cp15(vcpu, r->reg) = *vcpu_reg(vcpu, p->Rt);
+		kvm_pmu_set_counter_event_type(vcpu, *vcpu_reg(vcpu, p->Rt),
+					       vcpu_sys_reg(vcpu, PMSELR_EL0));
+	} else {
+		if (!p->is_aarch32)
+			val = vcpu_sys_reg(vcpu, r->reg);
+		else
+			val = vcpu_cp15(vcpu, r->reg);
+		*vcpu_reg(vcpu, p->Rt) = val;
+	}
+
+	return true;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	/* DBGBVRn_EL1 */						\
@@ -549,7 +574,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  trap_raz_wi },
 	/* PMXEVTYPER_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b001),
-	  trap_raz_wi },
+	  access_pmxevtyper, reset_unknown, PMXEVTYPER_EL0 },
 	/* PMXEVCNTR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b010),
 	  trap_raz_wi },
-- 
2.1.0

