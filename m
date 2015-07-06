From: shannon.zhao@linaro.org
Subject: [PATCH 13/18] KVM: ARM64: Add reset and access handlers for PMOVSSET_EL0 and PMOVSCLR_EL0 register
Date: Mon,  6 Jul 2015 10:17:43 +0800
Message-ID: <1436149068-3784-14-git-send-email-shannon.zhao@linaro.org>
References: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com, marc.zyngier@arm.com, alex.bennee@linaro.org, shannon.zhao@linaro.org, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

Since the reset value of PMOVSSET_EL0 and PMOVSCLR_EL0 is UNKNOWN, use
reset_unknown for its reset handler. Add access handler which emulates
writing and reading PMOVSSET_EL0 or PMOVSCLR_EL0 register.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index cbc07b8..ec80937 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -496,6 +496,32 @@ static bool access_pmintenclr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+/* PMOVSSET_EL0 accessor. */
+static bool access_pmovsset(struct kvm_vcpu *vcpu,
+			    const struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		vcpu->arch.pmu.overflow_status |= *vcpu_reg(vcpu, p->Rt);
+	else
+		*vcpu_reg(vcpu, p->Rt) = vcpu->arch.pmu.overflow_status;
+
+	return true;
+}
+
+/* PMOVSCLR_EL0 accessor. */
+static bool access_pmovsclr(struct kvm_vcpu *vcpu,
+			    const struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		vcpu->arch.pmu.overflow_status &= (~*vcpu_reg(vcpu, p->Rt));
+	else
+		*vcpu_reg(vcpu, p->Rt) = vcpu->arch.pmu.overflow_status;
+
+	return true;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	/* DBGBVRn_EL1 */						\
@@ -696,7 +722,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmcntenclr, reset_unknown, PMCNTENCLR_EL0 },
 	/* PMOVSCLR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b011),
-	  trap_raz_wi },
+	  access_pmovsclr, reset_unknown, PMOVSCLR_EL0 },
 	/* PMSWINC_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b100),
 	  trap_raz_wi },
@@ -723,7 +749,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  trap_raz_wi },
 	/* PMOVSSET_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b011),
-	  trap_raz_wi },
+	  access_pmovsset, reset_unknown, PMOVSSET_EL0 },
 
 	/* TPIDR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1101), CRm(0b0000), Op2(0b010),
-- 
2.1.0

