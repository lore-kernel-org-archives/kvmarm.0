From: shannon.zhao@linaro.org
Subject: [PATCH 10/18] KVM: ARM64: Add reset and access handlers for
 PMCCNTR_EL0 register
Date: Mon,  6 Jul 2015 10:17:40 +0800
Message-ID: <1436149068-3784-11-git-send-email-shannon.zhao@linaro.org>
References: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BC1A57ADB
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Jul 2015 22:07:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PeV4EBYJmxRG for <kvmarm@lists.cs.columbia.edu>;
 Sun,  5 Jul 2015 22:07:17 -0400 (EDT)
Received: from mail-pd0-f170.google.com (mail-pd0-f170.google.com
 [209.85.192.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88F7757A8A
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Jul 2015 22:07:17 -0400 (EDT)
Received: by pdbdz6 with SMTP id dz6so1061383pdb.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 05 Jul 2015 19:18:43 -0700 (PDT)
In-Reply-To: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
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

Since the reset value of PMCCNTR_EL0 is UNKNOWN, use reset_unknown for
its reset handler. Add access handler which emulates writing and reading
PMCCNTR_EL0 register.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2bcf1a0..29883df 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -375,6 +375,23 @@ static bool access_pmxevcntr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_pmccntr(struct kvm_vcpu *vcpu,
+			   const struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	unsigned long val;
+
+	if (p->is_write) {
+		val = *vcpu_reg(vcpu, p->Rt);
+		kvm_pmu_set_counter_value(vcpu, 31, val);
+	} else {
+		val = kvm_pmu_get_counter_value(vcpu, 31);
+		*vcpu_reg(vcpu, p->Rt) = val;
+	}
+
+	return true;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	/* DBGBVRn_EL1 */						\
@@ -590,7 +607,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmceid, reset_pmceid, PMCEID1_EL0, },
 	/* PMCCNTR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b000),
-	  trap_raz_wi },
+	  access_pmccntr, reset_unknown, PMCCNTR_EL0 },
 	/* PMXEVTYPER_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b001),
 	  access_pmxevtyper, reset_unknown, PMXEVTYPER_EL0 },
-- 
2.1.0
