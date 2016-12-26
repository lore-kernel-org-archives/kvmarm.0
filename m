From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 8/8] KVM: arm/arm64: Emulate the EL1 phys timer register access
Date: Mon, 26 Dec 2016 12:12:06 -0500
Message-ID: <1482772326-29110-9-git-send-email-jintack@cs.columbia.edu>
References: <1482772326-29110-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80F6A40625
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 12:23:02 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x6H6wA98rF9H for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Dec 2016 12:23:01 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 17550405DA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 12:23:00 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id uBQHM5fR032477
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 12:24:24 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id B363D80
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 12:24:24 -0500 (EST)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu
 [128.59.72.14]) by hazelnut (Postfix) with ESMTP id 9833380
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 12:24:24 -0500 (EST)
Received: from mail-qk0-f199.google.com (mail-qk0-f199.google.com
 [209.85.220.199])
 by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id uBQHOO3L015362
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 12:24:24 -0500
Received: by mail-qk0-f199.google.com with SMTP id q128so144242055qkd.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 09:24:24 -0800 (PST)
In-Reply-To: <1482772326-29110-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, catalin.marinas@arm.com, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Emulate read and write operations to CNTP_TVAL, CNTP_CVAL and CNTP_CTL.
Now the VM is able to use the EL1 physical timer.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/kvm/sys_regs.c    | 35 ++++++++++++++++++++++++++++++++---
 include/kvm/arm_arch_timer.h |  3 +++
 virt/kvm/arm/arch_timer.c    |  4 ++--
 3 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index fd9e747..7cef94f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -824,7 +824,15 @@ static bool access_cntp_tval(struct kvm_vcpu *vcpu,
 		struct sys_reg_params *p,
 		const struct sys_reg_desc *r)
 {
-	kvm_inject_undefined(vcpu);
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+	cycle_t now = kvm_phys_timer_read();
+
+	if (p->is_write) {
+		ptimer->cnt_cval = p->regval + now;
+		kvm_timer_emulate(vcpu, ptimer);
+	} else
+		p->regval = ptimer->cnt_cval - now;
+
 	return true;
 }
 
@@ -832,7 +840,21 @@ static bool access_cntp_ctl(struct kvm_vcpu *vcpu,
 		struct sys_reg_params *p,
 		const struct sys_reg_desc *r)
 {
-	kvm_inject_undefined(vcpu);
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+
+	if (p->is_write) {
+		/* ISTATUS bit is read-only */
+		ptimer->cnt_ctl = p->regval & ~ARCH_TIMER_CTRL_IT_STAT;
+		kvm_timer_emulate(vcpu, ptimer);
+	} else {
+		cycle_t now = kvm_phys_timer_read();
+
+		p->regval = ptimer->cnt_ctl;
+		/* Set ISTATUS bit if it's expired */
+		if (ptimer->cnt_cval <= now)
+			p->regval |= ARCH_TIMER_CTRL_IT_STAT;
+	}
+
 	return true;
 }
 
@@ -840,7 +862,14 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
 		struct sys_reg_params *p,
 		const struct sys_reg_desc *r)
 {
-	kvm_inject_undefined(vcpu);
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+
+	if (p->is_write) {
+		ptimer->cnt_cval = p->regval;
+		kvm_timer_emulate(vcpu, ptimer);
+	} else
+		p->regval = ptimer->cnt_cval;
+
 	return true;
 }
 
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 04ed9c1..776579b 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -75,6 +75,9 @@ bool kvm_timer_should_fire(struct kvm_vcpu *vcpu,
 			   struct arch_timer_context *timer_ctx);
 void kvm_timer_schedule(struct kvm_vcpu *vcpu);
 void kvm_timer_unschedule(struct kvm_vcpu *vcpu);
+void kvm_timer_emulate(struct kvm_vcpu *vcpu, struct arch_timer_context *timer);
+
+cycle_t kvm_phys_timer_read(void);
 
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
 
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index be8d953..7a161f8 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -39,7 +39,7 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 	vcpu_vtimer(vcpu)->active_cleared_last = false;
 }
 
-static cycle_t kvm_phys_timer_read(void)
+cycle_t kvm_phys_timer_read(void)
 {
 	return timecounter->cc->read(timecounter->cc);
 }
@@ -258,7 +258,7 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
  * Schedule the background timer for the emulated timer. The background timer
  * runs whenever vcpu is runnable and the timer is not expired.
  */
-static void kvm_timer_emulate(struct kvm_vcpu *vcpu,
+void kvm_timer_emulate(struct kvm_vcpu *vcpu,
 		       struct arch_timer_context *timer_ctx)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
-- 
1.9.1
