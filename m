From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v6 11/21] KVM: ARM64: Add access handler for PMXEVCNTR register
Date: Tue, 8 Dec 2015 20:47:30 +0800
Message-ID: <1449578860-15808-12-git-send-email-zhaoshenglong@huawei.com>
References: <1449578860-15808-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBF614968B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2015 07:46:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uxJawwnY8B+6 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2015 07:46:58 -0500 (EST)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [119.145.14.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C3664496C2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2015 07:46:51 -0500 (EST)
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

Accessing PMXEVCNTR register is mapped to the PMEVCNTRn or PMCCNTR which
is selected by PMSELR.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f7a73b5..2304937 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -516,6 +516,46 @@ out:
 	return true;
 }
 
+static bool access_pmu_pmxevcntr(struct kvm_vcpu *vcpu,
+				 struct sys_reg_params *p,
+				 const struct sys_reg_desc *r)
+{
+	u64 pmcr, idx, val;
+
+	if (!vcpu_mode_is_32bit(vcpu)) {
+		pmcr = vcpu_sys_reg(vcpu, PMCR_EL0);
+		idx = vcpu_sys_reg(vcpu, PMSELR_EL0) & ARMV8_COUNTER_MASK;
+
+		if (!pmu_counter_idx_valid(pmcr, idx))
+			goto out;
+
+		val = kvm_pmu_get_counter_value(vcpu, idx);
+		if (!p->is_write) {
+			p->regval = val;
+			goto out;
+		}
+
+		vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + idx) += (s64)p->regval - val;
+	} else {
+		pmcr = vcpu_cp15(vcpu, c9_PMCR);
+		idx = vcpu_cp15(vcpu, c9_PMSELR) & ARMV8_COUNTER_MASK;
+
+		if (!pmu_counter_idx_valid(pmcr, idx))
+			goto out;
+
+		val = kvm_pmu_get_counter_value(vcpu, idx);
+		if (!p->is_write) {
+			p->regval = val;
+			goto out;
+		}
+
+		vcpu_cp15(vcpu, c14_PMEVCNTR0 + idx) += (s64)p->regval - val;
+	}
+
+out:
+	return true;
+}
+
 /* PMU registers accessor. */
 static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 			    struct sys_reg_params *p,
@@ -804,7 +844,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmu_pmxevtyper },
 	/* PMXEVCNTR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b010),
-	  trap_raz_wi },
+	  access_pmu_pmxevcntr },
 	/* PMUSERENR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b000),
 	  trap_raz_wi },
@@ -1192,7 +1232,7 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), access_pmu_cp15_regs,
 	  NULL, c9_PMCCNTR },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), access_pmu_pmxevtyper },
-	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), access_pmu_pmxevcntr },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 0), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), trap_raz_wi },
-- 
2.0.4
