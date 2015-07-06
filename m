From: shannon.zhao@linaro.org
Subject: [PATCH 14/18] KVM: ARM64: Add reset and access handlers for
 PMUSERENR_EL0 register
Date: Mon,  6 Jul 2015 10:17:44 +0800
Message-ID: <1436149068-3784-15-git-send-email-shannon.zhao@linaro.org>
References: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60A9157B00
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Jul 2015 22:07:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MqhQ9c-8W8Xo for <kvmarm@lists.cs.columbia.edu>;
 Sun,  5 Jul 2015 22:07:36 -0400 (EDT)
Received: from mail-pa0-f52.google.com (mail-pa0-f52.google.com
 [209.85.220.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 89AB857A93
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Jul 2015 22:07:36 -0400 (EDT)
Received: by pabvl15 with SMTP id vl15so87075572pab.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 05 Jul 2015 19:19:02 -0700 (PDT)
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

Since the reset value of PMUSERENR_EL0 is UNKNOWN, use reset_unknown for
its reset handler. Add access handler which emulates writing and reading
PMUSERENR_EL0 register.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 15 ++++++++++++++-
 include/kvm/arm_pmu.h     |  1 +
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ec80937..d5984d0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -522,6 +522,19 @@ static bool access_pmovsclr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+/* PMUSERENR_EL0 accessor. */
+static bool access_pmuserenr(struct kvm_vcpu *vcpu,
+			     const struct sys_reg_params *p,
+			     const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		vcpu->arch.pmu.user_enable |= *vcpu_reg(vcpu, p->Rt);
+	else
+		*vcpu_reg(vcpu, p->Rt) = vcpu->arch.pmu.user_enable;
+
+	return true;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	/* DBGBVRn_EL1 */						\
@@ -746,7 +759,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmxevcntr, reset_unknown, PMXEVCNTR_EL0 },
 	/* PMUSERENR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b000),
-	  trap_raz_wi },
+	  access_pmuserenr, reset_unknown, PMUSERENR_EL0 },
 	/* PMOVSSET_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b011),
 	  access_pmovsset, reset_unknown, PMOVSSET_EL0 },
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index dee8356..4f3d8a6 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -39,6 +39,7 @@ struct kvm_pmu {
 	/* IRQ pending flag */
 	bool irq_pending;
 	struct irq_work irq_work;
+	u32 user_enable;
 	struct kvm_pmc pmc[ARMV8_MAX_COUNTERS];
 #endif
 };
-- 
2.1.0
