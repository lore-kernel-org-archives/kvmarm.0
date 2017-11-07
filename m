From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 06/26] KVM: arm/arm64: Make timer_arm and timer_disarm helpers
 more generic
Date: Tue,  7 Nov 2017 11:47:39 +0100
Message-ID: <20171107104800.30021-7-christoffer.dall@linaro.org>
References: <20171107104800.30021-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5B2649D14
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 05:46:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YOT+hNQ8BWSU for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Nov 2017 05:46:24 -0500 (EST)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E4D349D6B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 05:46:24 -0500 (EST)
Received: by mail-wm0-f65.google.com with SMTP id t139so2849045wmt.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Nov 2017 02:48:19 -0800 (PST)
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

We are about to add an additional soft timer to the arch timer state for
a VCPU and would like to be able to reuse the functions to program and
cancel a timer, so we make them slightly more generic and rename to make
it more clear that these functions work on soft timers and not the
hardware resource that this code is managing.

The armed flag on the timer state is only used to assert a condition,
and we don't rely on this assertion in any meaningful way, so we can
simply get rid of this flack and slightly reduce complexity.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 include/kvm/arm_arch_timer.h |  3 ---
 virt/kvm/arm/arch_timer.c    | 33 +++++++++++----------------------
 2 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index f0053f884b4a..d0beae98f755 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -48,9 +48,6 @@ struct arch_timer_cpu {
 	/* Work queued with the above timer expires */
 	struct work_struct		expired;
 
-	/* Background timer active */
-	bool				armed;
-
 	/* Is the timer enabled */
 	bool			enabled;
 };
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 8e89d63005c7..223230191195 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -56,26 +56,16 @@ u64 kvm_phys_timer_read(void)
 	return timecounter->cc->read(timecounter->cc);
 }
 
-static bool timer_is_armed(struct arch_timer_cpu *timer)
+static void soft_timer_start(struct hrtimer *hrt, u64 ns)
 {
-	return timer->armed;
-}
-
-/* timer_arm: as in "arm the timer", not as in ARM the company */
-static void timer_arm(struct arch_timer_cpu *timer, u64 ns)
-{
-	timer->armed = true;
-	hrtimer_start(&timer->timer, ktime_add_ns(ktime_get(), ns),
+	hrtimer_start(hrt, ktime_add_ns(ktime_get(), ns),
 		      HRTIMER_MODE_ABS);
 }
 
-static void timer_disarm(struct arch_timer_cpu *timer)
+static void soft_timer_cancel(struct hrtimer *hrt, struct work_struct *work)
 {
-	if (timer_is_armed(timer)) {
-		hrtimer_cancel(&timer->timer);
-		cancel_work_sync(&timer->expired);
-		timer->armed = false;
-	}
+	hrtimer_cancel(hrt);
+	cancel_work_sync(work);
 }
 
 static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
@@ -271,7 +261,7 @@ static void kvm_timer_emulate(struct kvm_vcpu *vcpu,
 		return;
 
 	/*  The timer has not yet expired, schedule a background timer */
-	timer_arm(timer, kvm_timer_compute_delta(timer_ctx));
+	soft_timer_start(&timer->timer, kvm_timer_compute_delta(timer_ctx));
 }
 
 /*
@@ -285,8 +275,6 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
-	BUG_ON(timer_is_armed(timer));
-
 	/*
 	 * No need to schedule a background timer if any guest timer has
 	 * already expired, because kvm_vcpu_block will return before putting
@@ -306,13 +294,14 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
 	 * The guest timers have not yet expired, schedule a background timer.
 	 * Set the earliest expiration time among the guest timers.
 	 */
-	timer_arm(timer, kvm_timer_earliest_exp(vcpu));
+	soft_timer_start(&timer->timer, kvm_timer_earliest_exp(vcpu));
 }
 
 void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
-	timer_disarm(timer);
+
+	soft_timer_cancel(&timer->timer, &timer->expired);
 }
 
 static void kvm_timer_flush_hwstate_vgic(struct kvm_vcpu *vcpu)
@@ -448,7 +437,7 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 	 * This is to cancel the background timer for the physical timer
 	 * emulation if it is set.
 	 */
-	timer_disarm(timer);
+	soft_timer_cancel(&timer->timer, &timer->expired);
 
 	/*
 	 * The guest could have modified the timer registers or the timer
@@ -615,7 +604,7 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
-	timer_disarm(timer);
+	soft_timer_cancel(&timer->timer, &timer->expired);
 	kvm_vgic_unmap_phys_irq(vcpu, vtimer->irq.irq);
 }
 
-- 
2.14.2
