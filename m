From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v4 06/21] KVM: ARM64: Add reset and access handlers for PMCEID0 and PMCEID1 register
Date: Fri, 30 Oct 2015 14:21:48 +0800
Message-ID: <1446186123-11548-7-git-send-email-zhaoshenglong@huawei.com>
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

Add reset handler which gets host value of PMCEID0 or PMCEID1. Since
write action to PMCEID0 or PMCEID1 is ignored, add a new case for this.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 35d232e..cb82b15 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -469,6 +469,19 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	vcpu_sysreg_write(vcpu, r, val);
 }
 
+static void reset_pmceid(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u64 pmceid;
+
+	if (r->reg == PMCEID0_EL0 || r->reg == c9_PMCEID0)
+		asm volatile("mrs %0, pmceid0_el0\n" : "=r" (pmceid));
+	else
+		/* PMCEID1_EL0 or c9_PMCEID1 */
+		asm volatile("mrs %0, pmceid1_el0\n" : "=r" (pmceid));
+
+	vcpu_sysreg_write(vcpu, r, pmceid);
+}
+
 /* PMU registers accessor. */
 static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 			    const struct sys_reg_params *p,
@@ -486,6 +499,9 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 			vcpu_sys_reg(vcpu, r->reg) = val;
 			break;
 		}
+		case PMCEID0_EL0:
+		case PMCEID1_EL0:
+			return ignore_write(vcpu, p);
 		default:
 			vcpu_sys_reg(vcpu, r->reg) = *vcpu_reg(vcpu, p->Rt);
 			break;
@@ -710,10 +726,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmu_regs, reset_unknown, PMSELR_EL0 },
 	/* PMCEID0_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b110),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_pmceid, PMCEID0_EL0 },
 	/* PMCEID1_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b111),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_pmceid, PMCEID1_EL0 },
 	/* PMCCNTR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b000),
 	  trap_raz_wi },
@@ -943,6 +959,9 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 			vcpu_cp15(vcpu, r->reg) = val;
 			break;
 		}
+		case c9_PMCEID0:
+		case c9_PMCEID1:
+			return ignore_write(vcpu, p);
 		default:
 			vcpu_cp15(vcpu, r->reg) = *vcpu_reg(vcpu, p->Rt);
 			break;
@@ -1000,8 +1019,10 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmu_cp15_regs,
 	  reset_unknown_cp15, c9_PMSELR },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), trap_raz_wi },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmu_cp15_regs,
+	  reset_pmceid, c9_PMCEID0 },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmu_cp15_regs,
+	  reset_pmceid, c9_PMCEID1 },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), trap_raz_wi },
-- 
2.0.4


