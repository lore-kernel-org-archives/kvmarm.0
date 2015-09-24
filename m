From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: [PATCH v3 04/20] KVM: ARM64: Add reset and access handlers for PMCR_EL0 register
Date: Thu, 24 Sep 2015 15:31:09 -0700
Message-ID: <1443133885-3366-5-git-send-email-shannon.zhao@linaro.org>
References: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, will.deacon@arm.com, wei@redhat.com, alex.bennee@linaro.org, peter.huangpeng@huawei.com, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Add reset handler which gets host value of PMCR_EL0 and make writable
bits architecturally UNKNOWN. Add a common access handler for PMU
registers which emulates writing and reading register and add emulation
for PMCR.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 81 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 79 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b41607d..60c0842 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -33,6 +33,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
 #include <asm/kvm_mmu.h>
+#include <asm/pmu.h>
 
 #include <trace/events/kvm.h>
 
@@ -446,6 +447,53 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	vcpu_sys_reg(vcpu, MPIDR_EL1) = (1ULL << 31) | mpidr;
 }
 
+static void vcpu_sysreg_write(struct kvm_vcpu *vcpu,
+			      const struct sys_reg_desc *r, u64 val)
+{
+	if (!vcpu_mode_is_32bit(vcpu))
+		vcpu_sys_reg(vcpu, r->reg) = val;
+	else
+		vcpu_cp15(vcpu, r->reg) = lower_32_bits(val);
+}
+
+static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u64 pmcr, val;
+
+	asm volatile("mrs %0, pmcr_el0\n" : "=r" (pmcr));
+	/* Writable bits of PMCR_EL0 (ARMV8_PMCR_MASK) is reset to UNKNOWN*/
+	val = (pmcr & ~ARMV8_PMCR_MASK) | (ARMV8_PMCR_MASK & 0xdecafbad);
+	vcpu_sysreg_write(vcpu, r, val);
+}
+
+/* PMU registers accessor. */
+static bool access_pmu_regs(struct kvm_vcpu *vcpu,
+			    const struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	unsigned long val;
+
+	if (p->is_write) {
+		switch (r->reg) {
+		case PMCR_EL0: {
+			/* Only update writeable bits of PMCR */
+			val = vcpu_sys_reg(vcpu, r->reg);
+			val &= ~ARMV8_PMCR_MASK;
+			val |= *vcpu_reg(vcpu, p->Rt) & ARMV8_PMCR_MASK;
+			vcpu_sys_reg(vcpu, r->reg) = val;
+			break;
+		}
+		default:
+			vcpu_sys_reg(vcpu, r->reg) = *vcpu_reg(vcpu, p->Rt);
+			break;
+		}
+	} else {
+		*vcpu_reg(vcpu, p->Rt) = vcpu_sys_reg(vcpu, r->reg);
+	}
+
+	return true;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	/* DBGBVRn_EL1 */						\
@@ -637,7 +685,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* PMCR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b000),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_pmcr, PMCR_EL0, },
 	/* PMCNTENSET_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b001),
 	  trap_raz_wi },
@@ -871,6 +919,34 @@ static const struct sys_reg_desc cp14_64_regs[] = {
 	{ Op1( 0), CRm( 2), .access = trap_raz_wi },
 };
 
+/* PMU CP15 registers accessor. */
+static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
+				 const struct sys_reg_params *p,
+				 const struct sys_reg_desc *r)
+{
+	unsigned long val;
+
+	if (p->is_write) {
+		switch (r->reg) {
+		case c9_PMCR: {
+			/* Only update writeable bits of PMCR */
+			val = vcpu_cp15(vcpu, r->reg);
+			val &= ~ARMV8_PMCR_MASK;
+			val |= *vcpu_reg(vcpu, p->Rt) & ARMV8_PMCR_MASK;
+			vcpu_cp15(vcpu, r->reg) = val;
+			break;
+		}
+		default:
+			vcpu_cp15(vcpu, r->reg) = *vcpu_reg(vcpu, p->Rt);
+			break;
+		}
+	} else {
+		*vcpu_reg(vcpu, p->Rt) = vcpu_cp15(vcpu, r->reg);
+	}
+
+	return true;
+}
+
 /*
  * Trapped cp15 registers. TTBR0/TTBR1 get a double encoding,
  * depending on the way they are accessed (as a 32bit or a 64bit
@@ -899,7 +975,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 7), CRm(14), Op2( 2), access_dcsw },
 
 	/* PMU */
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 0), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 0), access_pmu_cp15_regs,
+	  reset_pmcr, c9_PMCR },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
-- 
2.1.4

