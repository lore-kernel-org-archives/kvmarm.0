From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 25/25] KVM: arm/arm64: Emulate the EL1 phys timer registers
Date: Thu,  9 Feb 2017 14:59:23 +0000
Message-ID: <1486652363-7696-26-git-send-email-marc.zyngier@arm.com>
References: <1486652363-7696-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FAA440BE3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Feb 2017 09:59:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R+42LY66Ltrf for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Feb 2017 09:59:53 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3230A40C75
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Feb 2017 09:59:52 -0500 (EST)
In-Reply-To: <1486652363-7696-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Jintack Lim <jintack@cs.columbia.edu>

Emulate read and write operations to CNTP_TVAL, CNTP_CVAL and CNTP_CTL.
Now VMs are able to use the EL1 physical timer.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c    | 37 ++++++++++++++++++++++++++++++++++---
 include/kvm/arm_arch_timer.h |  2 ++
 virt/kvm/arm/arch_timer.c    |  2 +-
 3 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1cd3464..0e26f8c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -824,7 +824,14 @@ static bool access_cntp_tval(struct kvm_vcpu *vcpu,
 		struct sys_reg_params *p,
 		const struct sys_reg_desc *r)
 {
-	kvm_inject_undefined(vcpu);
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+	u64 now = kvm_phys_timer_read();
+
+	if (p->is_write)
+		ptimer->cnt_cval = p->regval + now;
+	else
+		p->regval = ptimer->cnt_cval - now;
+
 	return true;
 }
 
@@ -832,7 +839,25 @@ static bool access_cntp_ctl(struct kvm_vcpu *vcpu,
 		struct sys_reg_params *p,
 		const struct sys_reg_desc *r)
 {
-	kvm_inject_undefined(vcpu);
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+
+	if (p->is_write) {
+		/* ISTATUS bit is read-only */
+		ptimer->cnt_ctl = p->regval & ~ARCH_TIMER_CTRL_IT_STAT;
+	} else {
+		u64 now = kvm_phys_timer_read();
+
+		p->regval = ptimer->cnt_ctl;
+		/*
+		 * Set ISTATUS bit if it's expired.
+		 * Note that according to ARMv8 ARM Issue A.k, ISTATUS bit is
+		 * UNKNOWN when ENABLE bit is 0, so we chose to set ISTATUS bit
+		 * regardless of ENABLE bit for our implementation convenience.
+		 */
+		if (ptimer->cnt_cval <= now)
+			p->regval |= ARCH_TIMER_CTRL_IT_STAT;
+	}
+
 	return true;
 }
 
@@ -840,7 +865,13 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
 		struct sys_reg_params *p,
 		const struct sys_reg_desc *r)
 {
-	kvm_inject_undefined(vcpu);
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+
+	if (p->is_write)
+		ptimer->cnt_cval = p->regval;
+	else
+		p->regval = ptimer->cnt_cval;
+
 	return true;
 }
 
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index f1d2fba0..fe797d6 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -72,6 +72,8 @@ bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx);
 void kvm_timer_schedule(struct kvm_vcpu *vcpu);
 void kvm_timer_unschedule(struct kvm_vcpu *vcpu);
 
+u64 kvm_phys_timer_read(void);
+
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
 
 void kvm_timer_init_vhe(void);
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 33257b5..35d7100 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -40,7 +40,7 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 	vcpu_vtimer(vcpu)->active_cleared_last = false;
 }
 
-static u64 kvm_phys_timer_read(void)
+u64 kvm_phys_timer_read(void)
 {
 	return timecounter->cc->read(timecounter->cc);
 }
-- 
2.1.4
