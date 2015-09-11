From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v2 07/22] KVM: ARM64: Add reset and access handlers for
 PMCEID0 and PMCEID1 register
Date: Fri, 11 Sep 2015 16:55:00 +0800
Message-ID: <1441961715-11688-8-git-send-email-zhaoshenglong@huawei.com>
References: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C086941300
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2015 04:55:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id plK+NsAcM3hV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Sep 2015 04:55:30 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 48AE040FAB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2015 04:55:28 -0400 (EDT)
In-Reply-To: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

Add reset handler which gets host value of PMCEID0 or PMCEID1. Since
write action to PMCEID0 or PMCEID1 is ignored, add a new case for this.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 24b8972..b3bc717 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -251,6 +251,26 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 					  | (ARMV8_PMCR_MASK & 0xdecafbad);
 }
 
+static void reset_pmceid(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u32 pmceid;
+
+	if (r->reg == PMCEID0_EL0 || r->reg == c9_PMCEID0) {
+		asm volatile("mrs %0, pmceid0_el0\n" : "=r" (pmceid));
+		if (!vcpu_mode_is_32bit(vcpu))
+			vcpu_sys_reg(vcpu, r->reg) = pmceid;
+		else
+			vcpu_cp15(vcpu, r->reg) = pmceid;
+	} else {
+		/* PMCEID1_EL0 or c9_PMCEID1 */
+		asm volatile("mrs %0, pmceid1_el0\n" : "=r" (pmceid));
+		if (!vcpu_mode_is_32bit(vcpu))
+			vcpu_sys_reg(vcpu, r->reg) = pmceid;
+		else
+			vcpu_cp15(vcpu, r->reg) = pmceid;
+	}
+}
+
 /* PMU registers accessor. */
 static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 			    const struct sys_reg_params *p,
@@ -268,6 +288,9 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 			vcpu_sys_reg(vcpu, r->reg) = val;
 			break;
 		}
+		case PMCEID0_EL0:
+		case PMCEID1_EL0:
+			return ignore_write(vcpu, p);
 		default:
 			vcpu_sys_reg(vcpu, r->reg) = *vcpu_reg(vcpu, p->Rt);
 			break;
@@ -488,10 +511,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
@@ -692,6 +715,9 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 			vcpu_cp15(vcpu, r->reg) = val;
 			break;
 		}
+		case c9_PMCEID0:
+		case c9_PMCEID1:
+			return ignore_write(vcpu, p);
 		default:
 			vcpu_cp15(vcpu, r->reg) = *vcpu_reg(vcpu, p->Rt);
 			break;
@@ -738,8 +764,10 @@ static const struct sys_reg_desc cp15_regs[] = {
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
