From: shannon.zhao@linaro.org
Subject: [PATCH 04/18] KVM: ARM64: Add reset and access handlers for PMCR_EL0 register
Date: Mon,  6 Jul 2015 10:17:34 +0800
Message-ID: <1436149068-3784-5-git-send-email-shannon.zhao@linaro.org>
References: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com, marc.zyngier@arm.com, alex.bennee@linaro.org, shannon.zhao@linaro.org, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

Add reset handler which gets host value of PMCR_EL0 and make writable
bits architecturally UNKNOWN. Add access handler which emulates
writing and reading PMCR_EL0 register.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c370b40..152ee17 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -33,6 +33,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
 #include <asm/kvm_mmu.h>
+#include <asm/pmu.h>
 
 #include <trace/events/kvm.h>
 
@@ -236,6 +237,44 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	vcpu_sys_reg(vcpu, MPIDR_EL1) = (1ULL << 31) | mpidr;
 }
 
+static void reset_pmcr_el0(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u32 pmcr;
+
+	asm volatile("mrs %0, pmcr_el0\n" : "=r" (pmcr));
+	vcpu_sys_reg(vcpu, PMCR_EL0) = (pmcr & ~ARMV8_PMCR_MASK)
+				       | (ARMV8_PMCR_MASK & 0xdecafbad);
+}
+
+/* PMCR_EL0 accessor. Only called as long as MDCR_EL2.TPMCR is set. */
+static bool access_pmcr(struct kvm_vcpu *vcpu,
+			const struct sys_reg_params *p,
+			const struct sys_reg_desc *r)
+{
+	unsigned long val;
+
+	if (p->is_write) {
+		/* Only update writeable bits of PMCR */
+		if (!p->is_aarch32)
+			val = vcpu_sys_reg(vcpu, r->reg);
+		else
+			val = vcpu_cp15(vcpu, r->reg);
+		val &= ~ARMV8_PMCR_MASK;
+		val |= *vcpu_reg(vcpu, p->Rt) & ARMV8_PMCR_MASK;
+		if (!p->is_aarch32)
+			vcpu_sys_reg(vcpu, r->reg) = val;
+		else
+			vcpu_cp15(vcpu, r->reg) = val;
+	} else {
+		if (!p->is_aarch32)
+			*vcpu_reg(vcpu, p->Rt) = vcpu_sys_reg(vcpu, r->reg);
+		else
+			*vcpu_reg(vcpu, p->Rt) = vcpu_cp15(vcpu, r->reg);
+	}
+
+	return true;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	/* DBGBVRn_EL1 */						\
@@ -427,7 +466,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* PMCR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b000),
-	  trap_raz_wi },
+	  access_pmcr, reset_pmcr_el0, PMCR_EL0, },
 	/* PMCNTENSET_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b001),
 	  trap_raz_wi },
-- 
2.1.0

