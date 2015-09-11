From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v2 10/22] KVM: ARM64: Add reset and access handlers for
 PMXEVCNTR register
Date: Fri, 11 Sep 2015 16:55:03 +0800
Message-ID: <1441961715-11688-11-git-send-email-zhaoshenglong@huawei.com>
References: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27DAB4304C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2015 04:55:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NmGsPOQGJKSo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Sep 2015 04:55:47 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B5898410D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2015 04:55:42 -0400 (EDT)
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

Since the reset value of PMXEVCNTR is UNKNOWN, use reset_unknown for
its reset handler. Add access handler which emulates writing and reading
PMXEVCNTR register. When reading PMXEVCNTR, call perf_event_read_value
to get the count value of the perf event.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 41 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 59b7bc9..a51c8de 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -280,6 +280,12 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 
 	if (p->is_write) {
 		switch (r->reg) {
+		case PMXEVCNTR_EL0: {
+			val = PMEVCNTR0_EL0 + vcpu_sys_reg(vcpu, PMSELR_EL0);
+			vcpu_sys_reg(vcpu, val) =
+					  *vcpu_reg(vcpu, p->Rt) & 0xffffffffUL;
+			break;
+		}
 		case PMXEVTYPER_EL0: {
 			val = vcpu_sys_reg(vcpu, PMSELR_EL0);
 			kvm_pmu_set_counter_event_type(vcpu,
@@ -303,7 +309,17 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 			break;
 		}
 	} else {
-		*vcpu_reg(vcpu, p->Rt) = vcpu_sys_reg(vcpu, r->reg);
+		switch (r->reg) {
+		case PMXEVCNTR_EL0: {
+			val = kvm_pmu_get_counter_value(vcpu,
+						vcpu_sys_reg(vcpu, PMSELR_EL0));
+			*vcpu_reg(vcpu, p->Rt) = val;
+			break;
+		}
+		default:
+			*vcpu_reg(vcpu, p->Rt) = vcpu_sys_reg(vcpu, r->reg);
+			break;
+		}
 	}
 
 	return true;
@@ -530,7 +546,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmu_regs, reset_unknown, PMXEVTYPER_EL0 },
 	/* PMXEVCNTR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b010),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_unknown, PMXEVCNTR_EL0 },
 	/* PMUSERENR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b000),
 	  trap_raz_wi },
@@ -714,6 +730,12 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 
 	if (p->is_write) {
 		switch (r->reg) {
+		case c9_PMXEVCNTR: {
+			val = c14_PMEVCNTR0 + vcpu_cp15(vcpu, c9_PMSELR);
+			vcpu_cp15(vcpu, val) =
+					  *vcpu_reg(vcpu, p->Rt) & 0xffffffffUL;
+			break;
+		}
 		case c9_PMXEVTYPER: {
 			val = vcpu_cp15(vcpu, c9_PMSELR);
 			kvm_pmu_set_counter_event_type(vcpu,
@@ -737,7 +759,17 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 			break;
 		}
 	} else {
-		*vcpu_reg(vcpu, p->Rt) = vcpu_cp15(vcpu, r->reg);
+		switch (r->reg) {
+		case c9_PMXEVCNTR: {
+			val = kvm_pmu_get_counter_value(vcpu,
+						    vcpu_cp15(vcpu, c9_PMSELR));
+			*vcpu_reg(vcpu, p->Rt) = val;
+			break;
+		}
+		default:
+			*vcpu_reg(vcpu, p->Rt) = vcpu_cp15(vcpu, r->reg);
+			break;
+		}
 	}
 
 	return true;
@@ -785,7 +817,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), access_pmu_cp15_regs,
 	  reset_unknown_cp15, c9_PMXEVTYPER },
-	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), access_pmu_cp15_regs,
+	  reset_unknown_cp15, c9_PMXEVCNTR },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 0), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), trap_raz_wi },
-- 
2.0.4
