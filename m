From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v6 04/21] KVM: ARM64: Add reset and access handlers for
 PMCR_EL0 register
Date: Tue, 8 Dec 2015 20:47:23 +0800
Message-ID: <1449578860-15808-5-git-send-email-zhaoshenglong@huawei.com>
References: <1449578860-15808-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2261E41E71
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2015 07:46:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F6g3zlXgJWyY for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2015 07:46:47 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E1B07412A2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2015 07:46:46 -0500 (EST)
In-Reply-To: <1449578860-15808-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

Add reset handler which gets host value of PMCR_EL0 and make writable
bits architecturally UNKNOWN except PMCR.E to zero. Add a common access
handler for PMU registers which emulates writing and reading register
and add emulation for PMCR.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 97 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 95 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d2650e8..beb42f1 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -33,6 +33,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
 #include <asm/kvm_mmu.h>
+#include <asm/pmu.h>
 
 #include <trace/events/kvm.h>
 
@@ -438,6 +439,58 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	vcpu_sys_reg(vcpu, MPIDR_EL1) = (1ULL << 31) | mpidr;
 }
 
+static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u64 pmcr, val;
+
+	asm volatile("mrs %0, pmcr_el0\n" : "=r" (pmcr));
+	/* Writable bits of PMCR_EL0 (ARMV8_PMCR_MASK) is reset to UNKNOWN
+	 * except PMCR.E resetting to zero.
+	 */
+	val = ((pmcr & ~ARMV8_PMCR_MASK) | (ARMV8_PMCR_MASK & 0xdecafbad))
+	      & (~ARMV8_PMCR_E);
+	vcpu_sys_reg(vcpu, r->reg) = val;
+}
+
+/* PMU registers accessor. */
+static bool access_pmu_regs(struct kvm_vcpu *vcpu,
+			    struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	u64 val;
+
+	if (p->is_write) {
+		switch (r->reg) {
+		case PMCR_EL0: {
+			/* Only update writeable bits of PMCR */
+			val = vcpu_sys_reg(vcpu, r->reg);
+			val &= ~ARMV8_PMCR_MASK;
+			val |= p->regval & ARMV8_PMCR_MASK;
+			vcpu_sys_reg(vcpu, r->reg) = val;
+			break;
+		}
+		default:
+			vcpu_sys_reg(vcpu, r->reg) = p->regval;
+			break;
+		}
+	} else {
+		switch (r->reg) {
+		case PMCR_EL0: {
+			/* PMCR.P & PMCR.C are RAZ */
+			val = vcpu_sys_reg(vcpu, r->reg)
+			      & ~(ARMV8_PMCR_P | ARMV8_PMCR_C);
+			p->regval = val;
+			break;
+		}
+		default:
+			p->regval = vcpu_sys_reg(vcpu, r->reg);
+			break;
+		}
+	}
+
+	return true;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	/* DBGBVRn_EL1 */						\
@@ -622,7 +675,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* PMCR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b000),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_pmcr, PMCR_EL0, },
 	/* PMCNTENSET_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b001),
 	  trap_raz_wi },
@@ -856,6 +909,45 @@ static const struct sys_reg_desc cp14_64_regs[] = {
 	{ Op1( 0), CRm( 2), .access = trap_raz_wi },
 };
 
+/* PMU CP15 registers accessor. */
+static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
+				 struct sys_reg_params *p,
+				 const struct sys_reg_desc *r)
+{
+	u32 val;
+
+	if (p->is_write) {
+		switch (r->reg) {
+		case c9_PMCR: {
+			/* Only update writeable bits of PMCR */
+			val = vcpu_cp15(vcpu, r->reg);
+			val &= ~ARMV8_PMCR_MASK;
+			val |= p->regval & ARMV8_PMCR_MASK;
+			vcpu_cp15(vcpu, r->reg) = val;
+			break;
+		}
+		default:
+			vcpu_cp15(vcpu, r->reg) = p->regval;
+			break;
+		}
+	} else {
+		switch (r->reg) {
+		case c9_PMCR: {
+			/* PMCR.P & PMCR.C are RAZ */
+			val = vcpu_cp15(vcpu, r->reg)
+			      & ~(ARMV8_PMCR_P | ARMV8_PMCR_C);
+			p->regval = val;
+			break;
+		}
+		default:
+			p->regval = vcpu_cp15(vcpu, r->reg);
+			break;
+		}
+	}
+
+	return true;
+}
+
 /*
  * Trapped cp15 registers. TTBR0/TTBR1 get a double encoding,
  * depending on the way they are accessed (as a 32bit or a 64bit
@@ -884,7 +976,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 7), CRm(14), Op2( 2), access_dcsw },
 
 	/* PMU */
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 0), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 0), access_pmu_cp15_regs,
+	  NULL, c9_PMCR },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
-- 
2.0.4
