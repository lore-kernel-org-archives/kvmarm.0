From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 18/25] KVM: arm/arm64: Decouple kvm timer functions from
 virtual timer
Date: Thu,  9 Feb 2017 14:59:16 +0000
Message-ID: <1486652363-7696-19-git-send-email-marc.zyngier@arm.com>
References: <1486652363-7696-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 874BD40C25
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Feb 2017 09:59:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o1ftqQMgwzfB for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Feb 2017 09:59:38 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BC1F40B5B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Feb 2017 09:59:37 -0500 (EST)
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

Now that we have a separate structure for timer context, make functions
generic so that they can work with any timer context, not just the
virtual timer context.  This does not change the virtual timer
functionality.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/arm.c           |  2 +-
 include/kvm/arm_arch_timer.h |  2 +-
 virt/kvm/arm/arch_timer.c    | 54 ++++++++++++++++++++------------------------
 3 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index f93f2171..0ecd6cf 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -300,7 +300,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	return kvm_timer_should_fire(vcpu);
+	return kvm_timer_should_fire(vcpu_vtimer(vcpu));
 }
 
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 2c8560b..f46fa3b 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -66,7 +66,7 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu);
 u64 kvm_arm_timer_get_reg(struct kvm_vcpu *, u64 regid);
 int kvm_arm_timer_set_reg(struct kvm_vcpu *, u64 regid, u64 value);
 
-bool kvm_timer_should_fire(struct kvm_vcpu *vcpu);
+bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx);
 void kvm_timer_schedule(struct kvm_vcpu *vcpu);
 void kvm_timer_unschedule(struct kvm_vcpu *vcpu);
 
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 5004a67..5261f98 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -98,13 +98,12 @@ static void kvm_timer_inject_irq_work(struct work_struct *work)
 	kvm_vcpu_kick(vcpu);
 }
 
-static u64 kvm_timer_compute_delta(struct kvm_vcpu *vcpu)
+static u64 kvm_timer_compute_delta(struct arch_timer_context *timer_ctx)
 {
 	u64 cval, now;
-	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
-	cval = vtimer->cnt_cval;
-	now = kvm_phys_timer_read() - vtimer->cntvoff;
+	cval = timer_ctx->cnt_cval;
+	now = kvm_phys_timer_read() - timer_ctx->cntvoff;
 
 	if (now < cval) {
 		u64 ns;
@@ -133,7 +132,7 @@ static enum hrtimer_restart kvm_timer_expire(struct hrtimer *hrt)
 	 * PoV (NTP on the host may have forced it to expire
 	 * early). If we should have slept longer, restart it.
 	 */
-	ns = kvm_timer_compute_delta(vcpu);
+	ns = kvm_timer_compute_delta(vcpu_vtimer(vcpu));
 	if (unlikely(ns)) {
 		hrtimer_forward_now(hrt, ns_to_ktime(ns));
 		return HRTIMER_RESTART;
@@ -143,43 +142,39 @@ static enum hrtimer_restart kvm_timer_expire(struct hrtimer *hrt)
 	return HRTIMER_NORESTART;
 }
 
-static bool kvm_timer_irq_can_fire(struct kvm_vcpu *vcpu)
+static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx)
 {
-	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
-
-	return !(vtimer->cnt_ctl & ARCH_TIMER_CTRL_IT_MASK) &&
-		(vtimer->cnt_ctl & ARCH_TIMER_CTRL_ENABLE);
+	return !(timer_ctx->cnt_ctl & ARCH_TIMER_CTRL_IT_MASK) &&
+		(timer_ctx->cnt_ctl & ARCH_TIMER_CTRL_ENABLE);
 }
 
-bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
+bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 {
-	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	u64 cval, now;
 
-	if (!kvm_timer_irq_can_fire(vcpu))
+	if (!kvm_timer_irq_can_fire(timer_ctx))
 		return false;
 
-	cval = vtimer->cnt_cval;
-	now = kvm_phys_timer_read() - vtimer->cntvoff;
+	cval = timer_ctx->cnt_cval;
+	now = kvm_phys_timer_read() - timer_ctx->cntvoff;
 
 	return cval <= now;
 }
 
-static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
+static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
+				 struct arch_timer_context *timer_ctx)
 {
 	int ret;
-	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
 	BUG_ON(!vgic_initialized(vcpu->kvm));
 
-	vtimer->active_cleared_last = false;
-	vtimer->irq.level = new_level;
-	trace_kvm_timer_update_irq(vcpu->vcpu_id, vtimer->irq.irq,
-				   vtimer->irq.level);
+	timer_ctx->active_cleared_last = false;
+	timer_ctx->irq.level = new_level;
+	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer_ctx->irq.irq,
+				   timer_ctx->irq.level);
 
-	ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
-					 vtimer->irq.irq,
-					 vtimer->irq.level);
+	ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id, timer_ctx->irq.irq,
+				  timer_ctx->irq.level);
 	WARN_ON(ret);
 }
 
@@ -201,8 +196,8 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
 	if (!vgic_initialized(vcpu->kvm) || !timer->enabled)
 		return -ENODEV;
 
-	if (kvm_timer_should_fire(vcpu) != vtimer->irq.level)
-		kvm_timer_update_irq(vcpu, !vtimer->irq.level);
+	if (kvm_timer_should_fire(vtimer) != vtimer->irq.level)
+		kvm_timer_update_irq(vcpu, !vtimer->irq.level, vtimer);
 
 	return 0;
 }
@@ -215,6 +210,7 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
 void kvm_timer_schedule(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
 	BUG_ON(timer_is_armed(timer));
 
@@ -223,18 +219,18 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
 	 * already expired, because kvm_vcpu_block will return before putting
 	 * the thread to sleep.
 	 */
-	if (kvm_timer_should_fire(vcpu))
+	if (kvm_timer_should_fire(vtimer))
 		return;
 
 	/*
 	 * If the timer is not capable of raising interrupts (disabled or
 	 * masked), then there's no more work for us to do.
 	 */
-	if (!kvm_timer_irq_can_fire(vcpu))
+	if (!kvm_timer_irq_can_fire(vtimer))
 		return;
 
 	/*  The timer has not yet expired, schedule a background timer */
-	timer_arm(timer, kvm_timer_compute_delta(vcpu));
+	timer_arm(timer, kvm_timer_compute_delta(vtimer));
 }
 
 void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
-- 
2.1.4
