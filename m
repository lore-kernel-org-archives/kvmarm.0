From: shannon.zhao@linaro.org
Subject: [PATCH 16/18] KVM: ARM64: Add access handlers for PMEVCNTRn_EL0 and PMEVTYPERn_EL0 register
Date: Mon,  6 Jul 2015 10:17:46 +0800
Message-ID: <1436149068-3784-17-git-send-email-shannon.zhao@linaro.org>
References: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com, marc.zyngier@arm.com, alex.bennee@linaro.org, shannon.zhao@linaro.org, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

Add access handler which emulates writing and reading PMEVCNTRn_EL0 and
PMEVTYPERn_EL0.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 106 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 70afcba..5663d83 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -548,6 +548,30 @@ static bool access_pmswinc(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+/* PMU reg accessor. */
+static bool access_pmu_reg(struct kvm_vcpu *vcpu,
+			   const struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	unsigned long val;
+
+	if (p->is_write) {
+		val = *vcpu_reg(vcpu, p->Rt);
+		if (!p->is_aarch32)
+			vcpu_sys_reg(vcpu, r->reg) = val;
+		else
+			vcpu_cp15(vcpu, r->reg) = val & 0xffffffffUL;
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
@@ -563,6 +587,20 @@ static bool access_pmswinc(struct kvm_vcpu *vcpu,
 	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b111),	\
 	  trap_debug_regs, reset_val, (DBGWCR0_EL1 + (n)), 0 }
 
+/* Macro to expand the PMEVCNTRn_EL0 register */
+#define PMU_PMEVCNTR_EL0(n)						\
+	/* PMEVCNTRn_EL0 */						\
+	{ Op0(0b11), Op1(0b011), CRn(0b1110),				\
+	  CRm((0b1000 | (((n) >> 3) & 0x3))), Op2(((n) & 0x7)),		\
+	  access_pmu_reg, reset_val, (PMEVCNTR0_EL0 + (n)*2), 0 }
+
+/* Macro to expand the PMEVTYPERn_EL0 register */
+#define PMU_PMEVTYPER_EL0(n)						\
+	/* PMEVTYPERn_EL0 */						\
+	{ Op0(0b11), Op1(0b011), CRn(0b1110),				\
+	  CRm((0b1100 | (((n) >> 3) & 0x3))), Op2(((n) & 0x7)),		\
+	  access_pmu_reg, reset_val, (PMEVTYPER0_EL0 + (n)*2), 0 }
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -784,6 +822,74 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ Op0(0b11), Op1(0b011), CRn(0b1101), CRm(0b0000), Op2(0b011),
 	  NULL, reset_unknown, TPIDRRO_EL0 },
 
+	/* PMEVCNTRn_EL0 */
+	PMU_PMEVCNTR_EL0(0),
+	PMU_PMEVCNTR_EL0(1),
+	PMU_PMEVCNTR_EL0(2),
+	PMU_PMEVCNTR_EL0(3),
+	PMU_PMEVCNTR_EL0(4),
+	PMU_PMEVCNTR_EL0(5),
+	PMU_PMEVCNTR_EL0(6),
+	PMU_PMEVCNTR_EL0(7),
+	PMU_PMEVCNTR_EL0(8),
+	PMU_PMEVCNTR_EL0(9),
+	PMU_PMEVCNTR_EL0(10),
+	PMU_PMEVCNTR_EL0(11),
+	PMU_PMEVCNTR_EL0(12),
+	PMU_PMEVCNTR_EL0(13),
+	PMU_PMEVCNTR_EL0(14),
+	PMU_PMEVCNTR_EL0(15),
+	PMU_PMEVCNTR_EL0(16),
+	PMU_PMEVCNTR_EL0(17),
+	PMU_PMEVCNTR_EL0(18),
+	PMU_PMEVCNTR_EL0(19),
+	PMU_PMEVCNTR_EL0(20),
+	PMU_PMEVCNTR_EL0(21),
+	PMU_PMEVCNTR_EL0(22),
+	PMU_PMEVCNTR_EL0(23),
+	PMU_PMEVCNTR_EL0(24),
+	PMU_PMEVCNTR_EL0(25),
+	PMU_PMEVCNTR_EL0(26),
+	PMU_PMEVCNTR_EL0(27),
+	PMU_PMEVCNTR_EL0(28),
+	PMU_PMEVCNTR_EL0(29),
+	PMU_PMEVCNTR_EL0(30),
+	/* PMEVTYPERn_EL0 */
+	PMU_PMEVTYPER_EL0(0),
+	PMU_PMEVTYPER_EL0(1),
+	PMU_PMEVTYPER_EL0(2),
+	PMU_PMEVTYPER_EL0(3),
+	PMU_PMEVTYPER_EL0(4),
+	PMU_PMEVTYPER_EL0(5),
+	PMU_PMEVTYPER_EL0(6),
+	PMU_PMEVTYPER_EL0(7),
+	PMU_PMEVTYPER_EL0(8),
+	PMU_PMEVTYPER_EL0(9),
+	PMU_PMEVTYPER_EL0(10),
+	PMU_PMEVTYPER_EL0(11),
+	PMU_PMEVTYPER_EL0(12),
+	PMU_PMEVTYPER_EL0(13),
+	PMU_PMEVTYPER_EL0(14),
+	PMU_PMEVTYPER_EL0(15),
+	PMU_PMEVTYPER_EL0(16),
+	PMU_PMEVTYPER_EL0(17),
+	PMU_PMEVTYPER_EL0(18),
+	PMU_PMEVTYPER_EL0(19),
+	PMU_PMEVTYPER_EL0(20),
+	PMU_PMEVTYPER_EL0(21),
+	PMU_PMEVTYPER_EL0(22),
+	PMU_PMEVTYPER_EL0(23),
+	PMU_PMEVTYPER_EL0(24),
+	PMU_PMEVTYPER_EL0(25),
+	PMU_PMEVTYPER_EL0(26),
+	PMU_PMEVTYPER_EL0(27),
+	PMU_PMEVTYPER_EL0(28),
+	PMU_PMEVTYPER_EL0(29),
+	PMU_PMEVTYPER_EL0(30),
+	/* PMCCFILTR_EL0 */
+	{ Op0(0b11), Op1(0b011), CRn(0b1110), CRm(0b1111), Op2(0b111),
+	  access_pmu_reg, reset_val, PMCCFILTR_EL0, 0 },
+
 	/* DACR32_EL2 */
 	{ Op0(0b11), Op1(0b100), CRn(0b0011), CRm(0b0000), Op2(0b000),
 	  NULL, reset_unknown, DACR32_EL2 },
-- 
2.1.0

