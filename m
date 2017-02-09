From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 22/25] KVM: arm/arm64: Set a background timer to the earliest
 timer expiration
Date: Thu,  9 Feb 2017 14:59:20 +0000
Message-ID: <1486652363-7696-23-git-send-email-marc.zyngier@arm.com>
References: <1486652363-7696-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A5AB40C22
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Feb 2017 09:59:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6N6wrxAffEeL for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Feb 2017 09:59:46 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0AE140C9D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Feb 2017 09:59:45 -0500 (EST)
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

When scheduling a background timer, consider both of the virtual and
physical timer and pick the earliest expiration time.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/arm.c        |  3 ++-
 virt/kvm/arm/arch_timer.c | 53 +++++++++++++++++++++++++++++++++++------------
 2 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 0ecd6cf..21c493a 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -300,7 +300,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	return kvm_timer_should_fire(vcpu_vtimer(vcpu));
+	return kvm_timer_should_fire(vcpu_vtimer(vcpu)) ||
+	       kvm_timer_should_fire(vcpu_ptimer(vcpu));
 }
 
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 7f9a664..0ea7452 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -118,6 +118,35 @@ static u64 kvm_timer_compute_delta(struct arch_timer_context *timer_ctx)
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
+		min_virt = kvm_timer_compute_delta(vtimer);
+
+	if (kvm_timer_irq_can_fire(ptimer))
+		min_phys = kvm_timer_compute_delta(ptimer);
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
@@ -132,7 +161,7 @@ static enum hrtimer_restart kvm_timer_expire(struct hrtimer *hrt)
 	 * PoV (NTP on the host may have forced it to expire
 	 * early). If we should have slept longer, restart it.
 	 */
-	ns = kvm_timer_compute_delta(vcpu_vtimer(vcpu));
+	ns = kvm_timer_earliest_exp(vcpu);
 	if (unlikely(ns)) {
 		hrtimer_forward_now(hrt, ns_to_ktime(ns));
 		return HRTIMER_RESTART;
@@ -142,12 +171,6 @@ static enum hrtimer_restart kvm_timer_expire(struct hrtimer *hrt)
 	return HRTIMER_NORESTART;
 }
 
-static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx)
-{
-	return !(timer_ctx->cnt_ctl & ARCH_TIMER_CTRL_IT_MASK) &&
-		(timer_ctx->cnt_ctl & ARCH_TIMER_CTRL_ENABLE);
-}
-
 bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 {
 	u64 cval, now;
@@ -215,26 +238,30 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
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
-	if (kvm_timer_should_fire(vtimer))
+	if (kvm_timer_should_fire(vtimer) || kvm_timer_should_fire(ptimer))
 		return;
 
 	/*
-	 * If the timer is not capable of raising interrupts (disabled or
+	 * If both timers are not capable of raising interrupts (disabled or
 	 * masked), then there's no more work for us to do.
 	 */
-	if (!kvm_timer_irq_can_fire(vtimer))
+	if (!kvm_timer_irq_can_fire(vtimer) && !kvm_timer_irq_can_fire(ptimer))
 		return;
 
-	/*  The timer has not yet expired, schedule a background timer */
-	timer_arm(timer, kvm_timer_compute_delta(vtimer));
+	/*
+	 * The guest timers have not yet expired, schedule a background timer.
+	 * Set the earliest expiration time among the guest timers.
+	 */
+	timer_arm(timer, kvm_timer_earliest_exp(vcpu));
 }
 
 void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
-- 
2.1.4
