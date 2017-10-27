From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v5 18/20] KVM: arm/arm64: Avoid phys timer emulation in vcpu
 entry/exit
Date: Fri, 27 Oct 2017 10:34:39 +0200
Message-ID: <1509093281-15225-19-git-send-email-cdall@linaro.org>
References: <1509093281-15225-1-git-send-email-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18457405F9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 04:35:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aNTnr3uSYEJd for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 04:35:12 -0400 (EDT)
Received: from mail-lf0-f68.google.com (mail-lf0-f68.google.com
 [209.85.215.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DE26849D1F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 04:35:11 -0400 (EDT)
Received: by mail-lf0-f68.google.com with SMTP id g70so6548682lfl.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 01:36:36 -0700 (PDT)
In-Reply-To: <1509093281-15225-1-git-send-email-cdall@linaro.org>
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
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

There is no need to schedule and cancel a hrtimer when entering and
exiting the guest, because we know when the physical timer is going to
fire when the guest programs it, and we can simply program the hrtimer
at that point.

Now when the register modifications from the guest go through the
kvm_arm_timer_set/get_reg functions, which always call
kvm_timer_update_state(), we can simply consider the timer state in this
function and schedule and cancel the timers as needed.

This avoids looking at the physical timer emulation state when entering
and exiting the VCPU, allowing for faster servicing of the VM when
needed.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/arch_timer.c | 75 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 51 insertions(+), 24 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 7f4f12d..20e56c4 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -202,7 +202,27 @@ static enum hrtimer_restart kvm_bg_timer_expire(struct hrtimer *hrt)
 
 static enum hrtimer_restart kvm_phys_timer_expire(struct hrtimer *hrt)
 {
-	WARN(1, "Timer only used to ensure guest exit - unexpected event.");
+	struct arch_timer_context *ptimer;
+	struct arch_timer_cpu *timer;
+	struct kvm_vcpu *vcpu;
+	u64 ns;
+
+	timer = container_of(hrt, struct arch_timer_cpu, phys_timer);
+	vcpu = container_of(timer, struct kvm_vcpu, arch.timer_cpu);
+	ptimer = vcpu_ptimer(vcpu);
+
+	/*
+	 * Check that the timer has really expired from the guest's
+	 * PoV (NTP on the host may have forced it to expire
+	 * early). If not ready, schedule for a later time.
+	 */
+	ns = kvm_timer_compute_delta(ptimer);
+	if (unlikely(ns)) {
+		hrtimer_forward_now(hrt, ns_to_ktime(ns));
+		return HRTIMER_RESTART;
+	}
+
+	kvm_timer_update_irq(vcpu, true, ptimer);
 	return HRTIMER_NORESTART;
 }
 
@@ -256,24 +276,28 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 }
 
 /* Schedule the background timer for the emulated timer. */
-static void phys_timer_emulate(struct kvm_vcpu *vcpu,
-			      struct arch_timer_context *timer_ctx)
+static void phys_timer_emulate(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
-	if (kvm_timer_should_fire(timer_ctx))
-		return;
-
-	if (!kvm_timer_irq_can_fire(timer_ctx))
+	/*
+	 * If the timer can fire now we have just raised the IRQ line and we
+	 * don't need to have a soft timer scheduled for the future.  If the
+	 * timer cannot fire at all, then we also don't need a soft timer.
+	 */
+	if (kvm_timer_should_fire(ptimer) || !kvm_timer_irq_can_fire(ptimer)) {
+		soft_timer_cancel(&timer->phys_timer, NULL);
 		return;
+	}
 
-	/*  The timer has not yet expired, schedule a background timer */
-	soft_timer_start(&timer->phys_timer, kvm_timer_compute_delta(timer_ctx));
+	soft_timer_start(&timer->phys_timer, kvm_timer_compute_delta(ptimer));
 }
 
 /*
- * Check if there was a change in the timer state (should we raise or lower
- * the line level to the GIC).
+ * Check if there was a change in the timer state, so that we should either
+ * raise or lower the line level to the GIC or schedule a background timer to
+ * emulate the physical timer.
  */
 static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
 {
@@ -295,6 +319,8 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
 
 	if (kvm_timer_should_fire(ptimer) != ptimer->irq.level)
 		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
+
+	phys_timer_emulate(vcpu);
 }
 
 static void vtimer_save_state(struct kvm_vcpu *vcpu)
@@ -441,6 +467,9 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 
 	if (has_vhe())
 		disable_el1_phys_timer_access();
+
+	/* Set the background timer for the physical timer emulation. */
+	phys_timer_emulate(vcpu);
 }
 
 bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
@@ -476,12 +505,6 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 
 	if (unlikely(!timer->enabled))
 		return;
-
-	if (kvm_timer_should_fire(ptimer) != ptimer->irq.level)
-		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
-
-	/* Set the background timer for the physical timer emulation. */
-	phys_timer_emulate(vcpu, vcpu_ptimer(vcpu));
 }
 
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
@@ -497,6 +520,17 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 	vtimer_save_state(vcpu);
 
 	/*
+	 * Cancel the physical timer emulation, because the only case where we
+	 * need it after a vcpu_put is in the context of a sleeping VCPU, and
+	 * in that case we already factor in the deadline for the physical
+	 * timer when scheduling the bg_timer.
+	 *
+	 * In any case, we re-schedule the hrtimer for the physical timer when
+	 * coming back to the VCPU thread in kvm_timer_vcpu_load().
+	 */
+	soft_timer_cancel(&timer->phys_timer, NULL);
+
+	/*
 	 * The kernel may decide to run userspace after calling vcpu_put, so
 	 * we reset cntvoff to 0 to ensure a consistent read between user
 	 * accesses to the virtual counter and kernel access to the physical
@@ -538,16 +572,9 @@ static void unmask_vtimer_irq(struct kvm_vcpu *vcpu)
  */
 void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
 	/*
-	 * This is to cancel the background timer for the physical timer
-	 * emulation if it is set.
-	 */
-	soft_timer_cancel(&timer->phys_timer, NULL);
-
-	/*
 	 * If we entered the guest with the vtimer output asserted we have to
 	 * check if the guest has modified the timer so that we should lower
 	 * the line at this point.
-- 
2.7.4
