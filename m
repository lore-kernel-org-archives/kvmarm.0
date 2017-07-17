From: Christoffer Dall <cdall@linaro.org>
Subject: [RFC PATCH v2 15/19] KVM: arm/arm64: Use kvm_arm_timer_set/get_reg
 for guest register traps
Date: Mon, 17 Jul 2017 16:27:14 +0200
Message-ID: <20170717142718.13853-16-cdall@linaro.org>
References: <20170717142718.13853-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F6D449C01
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jul 2017 10:26:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5RPzQCIHSJqy for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Jul 2017 10:26:55 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0FE3849C43
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jul 2017 10:26:53 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id w126so77800152wme.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jul 2017 07:27:40 -0700 (PDT)
In-Reply-To: <20170717142718.13853-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

When trapping on a guest access to one of the timer registers, we were
messing with the internals of the timer state from the sysregs handling
code, and that logic was about to receive more added complexity when
optimizing the timer handling code.

Therefore, since we already have timer register access functions (to
access registers from userspace), reuse those for the timer register
traps from a VM and let the timer code maintain its own consistency.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 41 ++++++++++++++---------------------------
 1 file changed, 14 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7786288..fcd7f0e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -841,13 +841,16 @@ static bool access_cntp_tval(struct kvm_vcpu *vcpu,
 		struct sys_reg_params *p,
 		const struct sys_reg_desc *r)
 {
-	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 	u64 now = kvm_phys_timer_read();
+	u64 cval;
 
-	if (p->is_write)
-		ptimer->cnt_cval = p->regval + now;
-	else
-		p->regval = ptimer->cnt_cval - now;
+	if (p->is_write) {
+		kvm_arm_timer_set_reg(vcpu, KVM_REG_ARM_PTIMER_CVAL,
+				      p->regval + now);
+	} else {
+		cval = kvm_arm_timer_get_reg(vcpu, KVM_REG_ARM_PTIMER_CVAL);
+		p->regval = cval - now;
+	}
 
 	return true;
 }
@@ -856,24 +859,10 @@ static bool access_cntp_ctl(struct kvm_vcpu *vcpu,
 		struct sys_reg_params *p,
 		const struct sys_reg_desc *r)
 {
-	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
-
-	if (p->is_write) {
-		/* ISTATUS bit is read-only */
-		ptimer->cnt_ctl = p->regval & ~ARCH_TIMER_CTRL_IT_STAT;
-	} else {
-		u64 now = kvm_phys_timer_read();
-
-		p->regval = ptimer->cnt_ctl;
-		/*
-		 * Set ISTATUS bit if it's expired.
-		 * Note that according to ARMv8 ARM Issue A.k, ISTATUS bit is
-		 * UNKNOWN when ENABLE bit is 0, so we chose to set ISTATUS bit
-		 * regardless of ENABLE bit for our implementation convenience.
-		 */
-		if (ptimer->cnt_cval <= now)
-			p->regval |= ARCH_TIMER_CTRL_IT_STAT;
-	}
+	if (p->is_write)
+		kvm_arm_timer_set_reg(vcpu, KVM_REG_ARM_PTIMER_CTL, p->regval);
+	else
+		p->regval = kvm_arm_timer_get_reg(vcpu, KVM_REG_ARM_PTIMER_CTL);
 
 	return true;
 }
@@ -882,12 +871,10 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
 		struct sys_reg_params *p,
 		const struct sys_reg_desc *r)
 {
-	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
-
 	if (p->is_write)
-		ptimer->cnt_cval = p->regval;
+		kvm_arm_timer_set_reg(vcpu, KVM_REG_ARM_PTIMER_CVAL, p->regval);
 	else
-		p->regval = ptimer->cnt_cval;
+		p->regval = kvm_arm_timer_get_reg(vcpu, KVM_REG_ARM_PTIMER_CVAL);
 
 	return true;
 }
-- 
2.9.0
