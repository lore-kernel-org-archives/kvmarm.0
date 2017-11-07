From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 14/26] KVM: arm/arm64: Use kvm_arm_timer_set/get_reg for guest
 register traps
Date: Tue,  7 Nov 2017 11:47:47 +0100
Message-ID: <20171107104800.30021-15-christoffer.dall@linaro.org>
References: <20171107104800.30021-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D01B49D88
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 05:46:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jPbn5BRaBF5p for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Nov 2017 05:46:39 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 06C7F49D92
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 05:46:36 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id b189so2701830wmd.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Nov 2017 02:48:30 -0800 (PST)
In-Reply-To: <20171107104800.30021-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <cdall@linaro.org>

When trapping on a guest access to one of the timer registers, we were
messing with the internals of the timer state from the sysregs handling
code, and that logic was about to receive more added complexity when
optimizing the timer handling code.

Therefore, since we already have timer register access functions (to
access registers from userspace), reuse those for the timer register
traps from a VM and let the timer code maintain its own consistency.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 41 ++++++++++++++---------------------------
 1 file changed, 14 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2e070d3baf9f..bb0e41b3154e 100644
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
2.14.2
