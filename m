From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v5 10/21] KVM: ARM64: Add reset and access handlers for
 PMCCNTR register
Date: Thu, 3 Dec 2015 14:11:20 +0800
Message-ID: <1449123091-20252-11-git-send-email-zhaoshenglong@huawei.com>
References: <1449123091-20252-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8A4B49A0E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 01:11:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WeM38slPyMeu for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2015 01:11:27 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2309649969
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 01:11:21 -0500 (EST)
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

Since the reset value of PMCCNTR is UNKNOWN, use reset_unknown for its
reset handler. Add a new case to emulate reading and writing to PMCCNTR
register.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 43a634c..9e06fe8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -493,6 +493,13 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 
 	if (p->is_write) {
 		switch (r->reg) {
+		case PMCCNTR_EL0: {
+			val = kvm_pmu_get_counter_value(vcpu,
+							ARMV8_MAX_COUNTERS - 1);
+			vcpu_sys_reg(vcpu, r->reg) +=
+					      (s64)*vcpu_reg(vcpu, p->Rt) - val;
+			break;
+		}
 		case PMXEVCNTR_EL0: {
 			u64 idx = vcpu_sys_reg(vcpu, PMSELR_EL0)
 				  & ARMV8_COUNTER_MASK;
@@ -536,6 +543,12 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 		}
 	} else {
 		switch (r->reg) {
+		case PMCCNTR_EL0: {
+			val = kvm_pmu_get_counter_value(vcpu,
+							ARMV8_MAX_COUNTERS - 1);
+			*vcpu_reg(vcpu, p->Rt) = val;
+			break;
+		}
 		case PMXEVCNTR_EL0: {
 			u64 idx = vcpu_sys_reg(vcpu, PMSELR_EL0)
 				  & ARMV8_COUNTER_MASK;
@@ -772,7 +785,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmu_regs, reset_pmceid, PMCEID1_EL0 },
 	/* PMCCNTR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b000),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_unknown, PMCCNTR_EL0 },
 	/* PMXEVTYPER_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b001),
 	  access_pmu_regs, reset_unknown, PMXEVTYPER_EL0 },
@@ -991,6 +1004,13 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 
 	if (p->is_write) {
 		switch (r->reg) {
+		case c9_PMCCNTR: {
+			val = kvm_pmu_get_counter_value(vcpu,
+							ARMV8_MAX_COUNTERS - 1);
+			vcpu_cp15(vcpu, r->reg) += (s64)*vcpu_reg(vcpu, p->Rt)
+						   - val;
+			break;
+		}
 		case c9_PMXEVCNTR: {
 			u32 idx = vcpu_cp15(vcpu, c9_PMSELR)
 				  & ARMV8_COUNTER_MASK;
@@ -1034,6 +1054,12 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 		}
 	} else {
 		switch (r->reg) {
+		case c9_PMCCNTR: {
+			val = kvm_pmu_get_counter_value(vcpu,
+							ARMV8_MAX_COUNTERS - 1);
+			*vcpu_reg(vcpu, p->Rt) = val;
+			break;
+		}
 		case c9_PMXEVCNTR: {
 			u32 idx = vcpu_cp15(vcpu, c9_PMSELR)
 				  & ARMV8_COUNTER_MASK;
@@ -1101,7 +1127,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 	  NULL, c9_PMCEID0 },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmu_cp15_regs,
 	  NULL, c9_PMCEID1 },
-	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), access_pmu_cp15_regs,
+	  NULL, c9_PMCCNTR },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), access_pmu_cp15_regs,
 	  NULL, c9_PMXEVTYPER },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), access_pmu_cp15_regs,
-- 
2.0.4
