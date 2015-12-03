From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v5 08/21] KVM: ARM64: Add reset and access handlers for
 PMXEVTYPER register
Date: Thu, 3 Dec 2015 14:11:18 +0800
Message-ID: <1449123091-20252-9-git-send-email-zhaoshenglong@huawei.com>
References: <1449123091-20252-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ED98498EF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 01:11:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DmSJdTaJlydJ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2015 01:11:21 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14C3649914
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 01:11:18 -0500 (EST)
In-Reply-To: <1449123091-20252-1-git-send-email-zhaoshenglong@huawei.com>
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

Since the reset value of PMXEVTYPER is UNKNOWN, use reset_unknown or
reset_unknown_cp15 for its reset handler. Add access handler which
emulates writing and reading PMXEVTYPER register. When writing to
PMXEVTYPER, call kvm_pmu_set_counter_event_type to create a perf_event
for the selected event type.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b0a8d88..6967a49 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -473,6 +473,17 @@ static void reset_pmceid(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	vcpu_sys_reg(vcpu, r->reg) = pmceid;
 }
 
+static bool pmu_counter_idx_valid(u64 pmcr, u64 idx)
+{
+	u64 val;
+
+	val = (pmcr >> ARMV8_PMCR_N_SHIFT) & ARMV8_PMCR_N_MASK;
+	if (idx >= val && idx != ARMV8_COUNTER_MASK)
+		return false;
+
+	return true;
+}
+
 /* PMU registers accessor. */
 static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 			    const struct sys_reg_params *p,
@@ -482,6 +493,20 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 
 	if (p->is_write) {
 		switch (r->reg) {
+		case PMXEVTYPER_EL0: {
+			u64 idx = vcpu_sys_reg(vcpu, PMSELR_EL0)
+				  & ARMV8_COUNTER_MASK;
+
+			if (!pmu_counter_idx_valid(vcpu_sys_reg(vcpu, PMCR_EL0),
+						   idx))
+				break;
+
+			val = *vcpu_reg(vcpu, p->Rt);
+			kvm_pmu_set_counter_event_type(vcpu, val, idx);
+			vcpu_sys_reg(vcpu, PMXEVTYPER_EL0) = val;
+			vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + idx) = val;
+			break;
+		}
 		case PMCR_EL0: {
 			/* Only update writeable bits of PMCR */
 			val = vcpu_sys_reg(vcpu, r->reg);
@@ -726,7 +751,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  trap_raz_wi },
 	/* PMXEVTYPER_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b001),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_unknown, PMXEVTYPER_EL0 },
 	/* PMXEVCNTR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b010),
 	  trap_raz_wi },
@@ -942,6 +967,20 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 
 	if (p->is_write) {
 		switch (r->reg) {
+		case c9_PMXEVTYPER: {
+			u32 idx = vcpu_cp15(vcpu, c9_PMSELR)
+				  & ARMV8_COUNTER_MASK;
+
+			if (!pmu_counter_idx_valid(vcpu_sys_reg(vcpu, c9_PMCR),
+						   idx))
+				break;
+
+			val = *vcpu_reg(vcpu, p->Rt);
+			kvm_pmu_set_counter_event_type(vcpu, val, idx);
+			vcpu_cp15(vcpu, c9_PMXEVTYPER) = val;
+			vcpu_cp15(vcpu, c14_PMEVTYPER0 + idx) = val;
+			break;
+		}
 		case c9_PMCR: {
 			/* Only update writeable bits of PMCR */
 			val = vcpu_cp15(vcpu, r->reg);
@@ -1015,7 +1054,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmu_cp15_regs,
 	  NULL, c9_PMCEID1 },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), trap_raz_wi },
-	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), access_pmu_cp15_regs,
+	  NULL, c9_PMXEVTYPER },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 0), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), trap_raz_wi },
-- 
2.0.4
