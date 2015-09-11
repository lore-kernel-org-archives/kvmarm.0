From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v2 13/22] KVM: ARM64: Add reset and access handlers for
 PMINTENSET and PMINTENCLR register
Date: Fri, 11 Sep 2015 16:55:06 +0800
Message-ID: <1441961715-11688-14-git-send-email-zhaoshenglong@huawei.com>
References: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B0A5413E1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2015 04:55:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tPZZ3eiqEcgy for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Sep 2015 04:55:39 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 61D0F40FAB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2015 04:55:32 -0400 (EDT)
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

Since the reset value of PMINTENSET and PMINTENCLR is UNKNOWN, use
reset_unknown for its reset handler. Add a new case to emulate writing
PMINTENSET or PMINTENCLR register.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 8307189..c3d4fb5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -311,6 +311,18 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 			vcpu_sys_reg(vcpu, PMCNTENSET_EL0) &= ~val;
 			break;
 		}
+		case PMINTENSET_EL1: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			vcpu_sys_reg(vcpu, r->reg) |= val;
+			vcpu_sys_reg(vcpu, PMINTENCLR_EL1) |= val;
+			break;
+		}
+		case PMINTENCLR_EL1: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			vcpu_sys_reg(vcpu, r->reg) &= ~val;
+			vcpu_sys_reg(vcpu, PMINTENSET_EL1) &= ~val;
+			break;
+		}
 		case PMCR_EL0: {
 			/* Only update writeable bits of PMCR */
 			val = vcpu_sys_reg(vcpu, r->reg);
@@ -500,10 +512,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* PMINTENSET_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b1001), CRm(0b1110), Op2(0b001),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_unknown, PMINTENSET_EL1 },
 	/* PMINTENCLR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b1001), CRm(0b1110), Op2(0b010),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_unknown, PMINTENCLR_EL1 },
 
 	/* MAIR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b1010), CRm(0b0010), Op2(0b000),
@@ -785,6 +797,18 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 			vcpu_cp15(vcpu, c9_PMCNTENSET) &= ~val;
 			break;
 		}
+		case c9_PMINTENSET: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			vcpu_cp15(vcpu, r->reg) |= val;
+			vcpu_cp15(vcpu, c9_PMINTENCLR) |= val;
+			break;
+		}
+		case c9_PMINTENCLR: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			vcpu_cp15(vcpu, r->reg) &= ~val;
+			vcpu_cp15(vcpu, c9_PMINTENSET) &= ~val;
+			break;
+		}
 		case c9_PMCR: {
 			/* Only update writeable bits of PMCR */
 			val = vcpu_cp15(vcpu, r->reg);
@@ -871,8 +895,10 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), access_pmu_cp15_regs,
 	  reset_unknown_cp15, c9_PMXEVCNTR },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 0), trap_raz_wi },
-	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), trap_raz_wi },
-	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), access_pmu_cp15_regs,
+	  reset_unknown_cp15, c9_PMINTENSET },
+	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), access_pmu_cp15_regs,
+	  reset_unknown_cp15, c9_PMINTENCLR },
 
 	{ Op1( 0), CRn(10), CRm( 2), Op2( 0), access_vm_reg, NULL, c10_PRRR },
 	{ Op1( 0), CRn(10), CRm( 2), Op2( 1), access_vm_reg, NULL, c10_NMRR },
-- 
2.0.4
