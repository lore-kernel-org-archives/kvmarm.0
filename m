From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v10 05/21] KVM: ARM64: Add access handler for PMSELR register
Date: Wed, 27 Jan 2016 11:51:33 +0800
Message-ID: <1453866709-20324-6-git-send-email-zhaoshenglong@huawei.com>
References: <1453866709-20324-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 389AE407A6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 22:47:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bJeKiG22Q9tE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2016 22:47:45 -0500 (EST)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [119.145.14.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E5BF407A0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 22:47:43 -0500 (EST)
In-Reply-To: <1453866709-20324-1-git-send-email-zhaoshenglong@huawei.com>
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

Since the reset value of PMSELR_EL0 is UNKNOWN, use reset_unknown for
its reset handler. When reading PMSELR, return the PMSELR.SEL field to
guest.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 97fea84..fc60041 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -477,6 +477,21 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			  const struct sys_reg_desc *r)
+{
+	if (!kvm_arm_pmu_v3_ready(vcpu))
+		return trap_raz_wi(vcpu, p, r);
+
+	if (p->is_write)
+		vcpu_sys_reg(vcpu, PMSELR_EL0) = p->regval;
+	else
+		/* return PMSELR.SEL field */
+		p->regval = vcpu_sys_reg(vcpu, PMSELR_EL0) & ARMV8_COUNTER_MASK;
+
+	return true;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	/* DBGBVRn_EL1 */						\
@@ -676,7 +691,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  trap_raz_wi },
 	/* PMSELR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b101),
-	  trap_raz_wi },
+	  access_pmselr, reset_unknown, PMSELR_EL0 },
 	/* PMCEID0_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b110),
 	  trap_raz_wi },
@@ -927,7 +942,7 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmselr },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), trap_raz_wi },
-- 
2.0.4
