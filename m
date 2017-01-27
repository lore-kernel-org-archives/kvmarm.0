From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC v2 07/10] KVM: arm/arm64: Set a background timer to the earliest
 timer expiration
Date: Thu, 26 Jan 2017 20:04:57 -0500
Message-ID: <1485479100-4966-8-git-send-email-jintack@cs.columbia.edu>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEAD340966
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s9d0BArVtfTV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Jan 2017 20:05:00 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4709540980
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:04:58 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0R156Ua051162
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:09 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id B466081
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:09 -0500 (EST)
Received: from sendprodmail03.cc.columbia.edu (sendprodmail03.cc.columbia.edu
 [128.59.72.15]) by hazelnut (Postfix) with ESMTP id 9DEC383
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:09 -0500 (EST)
Received: from mail-qt0-f199.google.com (mail-qt0-f199.google.com
 [209.85.216.199])
 by sendprodmail03.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0R159lj035931
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:09 -0500
Received: by mail-qt0-f199.google.com with SMTP id w20so61045299qtb.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 17:05:09 -0800 (PST)
In-Reply-To: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: pbonzini@redhat.com, rkrcmar@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, andre.przywara@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

When scheduling a background timer, consider both of the virtual and
physical timer and pick the earliest expiration time.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm/kvm/arm.c        |  3 ++-
 virt/kvm/arm/arch_timer.c | 55 ++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 44 insertions(+), 14 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 9a34a3c..9e94f87 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -301,7 +301,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	return kvm_timer_should_fire(vcpu, vcpu_vtimer(vcpu));
+	return kvm_timer_should_fire(vcpu, vcpu_vtimer(vcpu)) ||
+		kvm_timer_should_fire(vcpu, vcpu_ptimer(vcpu));
 }
 
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 3b6bd50..d3925e2 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -119,6 +119,35 @@ static u64 kvm_timer_compute_delta(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx)
+{
+	return !(timer_ctx->cnt_ctl & ARCH_TIMER_CTRL_IT_MASK) &&
+		(timer_ctx->cnt_ctl & ARCH_TIMER_CTRL_ENABLE);
+}
+
+/*
+ * Returns the earliest expiration time in ns among guest timers.
+ * Note that it will return 0 if none of timers can fire.
+ */
+static u64 kvm_timer_earliest_exp(struct kvm_vcpu *vcpu)
+{
+	u64 min_virt = ULLONG_MAX, min_phys = ULLONG_MAX;
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+
+	if (kvm_timer_irq_can_fire(vtimer))
+		min_virt = kvm_timer_compute_delta(vcpu, vtimer);
+
+	if (kvm_timer_irq_can_fire(ptimer))
+		min_phys = kvm_timer_compute_delta(vcpu, ptimer);
+
+	/* If none of timers can fire, then return 0 */
+	if ((min_virt == ULLONG_MAX) && (min_phys == ULLONG_MAX))
+		return 0;
+
+	return min(min_virt, min_phys);
+}
+
 static enum hrtimer_restart kvm_timer_expire(struct hrtimer *hrt)
 {
 	struct arch_timer_cpu *timer;
@@ -133,7 +162,7 @@ static enum hrtimer_restart kvm_timer_expire(struct hrtimer *hrt)
 	 * PoV (NTP on the host may have forced it to expire
 	 * early). If we should have slept longer, restart it.
 	 */
-	ns = kvm_timer_compute_delta(vcpu, vcpu_vtimer(vcpu));
+	ns = kvm_timer_earliest_exp(vcpu);
 	if (unlikely(ns)) {
 		hrtimer_forward_now(hrt, ns_to_ktime(ns));
 		return HRTIMER_RESTART;
@@ -143,12 +172,6 @@ static enum hrtimer_restart kvm_timer_expire(struct hrtimer *hrt)
 	return HRTIMER_NORESTART;
 }
 
-static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx)
-{
-	return !(timer_ctx->cnt_ctl & ARCH_TIMER_CTRL_IT_MASK) &&
-		(timer_ctx->cnt_ctl & ARCH_TIMER_CTRL_ENABLE);
-}
-
 bool kvm_timer_should_fire(struct kvm_vcpu *vcpu,
 			   struct arch_timer_context *timer_ctx)
 {
@@ -233,26 +256,32 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
 	BUG_ON(timer_is_armed(timer));
 
 	/*
-	 * No need to schedule a background timer if the guest timer has
+	 * No need to schedule a background timer if any guest timer has
 	 * already expired, because kvm_vcpu_block will return before putting
 	 * the thread to sleep.
 	 */
-	if (kvm_timer_should_fire(vcpu, vtimer))
+	if (kvm_timer_should_fire(vcpu, vtimer) ||
+	    kvm_timer_should_fire(vcpu, ptimer))
 		return;
 
 	/*
-	 * If the timer is not capable of raising interrupts (disabled or
+	 * If both timers are not capable of raising interrupts (disabled or
 	 * masked), then there's no more work for us to do.
 	 */
-	if (!kvm_timer_irq_can_fire(vtimer))
+	if (!kvm_timer_irq_can_fire(vtimer) &&
+	    !kvm_timer_irq_can_fire(ptimer))
 		return;
 
-	/*  The timer has not yet expired, schedule a background timer */
-	timer_arm(timer, kvm_timer_compute_delta(vcpu, vtimer));
+	/*
+	 * The guest timers have not yet expired, schedule a background timer.
+	 * Set the earliest expiration time among the guest timers.
+	 */
+	timer_arm(timer, kvm_timer_earliest_exp(vcpu));
 }
 
 void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
-- 
1.9.1
