From: Christoffer Dall <cdall@linaro.org>
Subject: [RFC PATCH v2 06/19] KVM: arm/arm64: Make timer_arm and timer_disarm
 helpers more generic
Date: Mon, 17 Jul 2017 16:27:05 +0200
Message-ID: <20170717142718.13853-7-cdall@linaro.org>
References: <20170717142718.13853-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E21640CE9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jul 2017 10:26:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cRNdB98xhFrD for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Jul 2017 10:26:45 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5CBB540D16
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jul 2017 10:26:45 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id f67so85836501wmh.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jul 2017 07:27:31 -0700 (PDT)
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

We are about to add an additional soft timer to the arch timer state for
a VCPU and would like to be able to reuse the functions to program and
cancel a timer, so we make them slightly more generic and rename to make
it more clear that these functions work on soft timers and not the
hardware resource that this code is managing.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 8e89d63..871d8ae 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -56,26 +56,22 @@ u64 kvm_phys_timer_read(void)
 	return timecounter->cc->read(timecounter->cc);
 }
 
-static bool timer_is_armed(struct arch_timer_cpu *timer)
+static bool soft_timer_is_armed(struct arch_timer_cpu *timer)
 {
 	return timer->armed;
 }
 
-/* timer_arm: as in "arm the timer", not as in ARM the company */
-static void timer_arm(struct arch_timer_cpu *timer, u64 ns)
+static void soft_timer_start(struct hrtimer *hrt, u64 ns)
 {
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
+	if (work)
+		cancel_work_sync(work);
 }
 
 static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
@@ -271,7 +267,7 @@ static void kvm_timer_emulate(struct kvm_vcpu *vcpu,
 		return;
 
 	/*  The timer has not yet expired, schedule a background timer */
-	timer_arm(timer, kvm_timer_compute_delta(timer_ctx));
+	soft_timer_start(&timer->timer, kvm_timer_compute_delta(timer_ctx));
 }
 
 /*
@@ -285,7 +281,7 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
-	BUG_ON(timer_is_armed(timer));
+	BUG_ON(soft_timer_is_armed(timer));
 
 	/*
 	 * No need to schedule a background timer if any guest timer has
@@ -306,13 +302,16 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
 	 * The guest timers have not yet expired, schedule a background timer.
 	 * Set the earliest expiration time among the guest timers.
 	 */
-	timer_arm(timer, kvm_timer_earliest_exp(vcpu));
+	timer->armed = true;
+	soft_timer_start(&timer->timer, kvm_timer_earliest_exp(vcpu));
 }
 
 void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
-	timer_disarm(timer);
+
+	soft_timer_cancel(&timer->timer, &timer->expired);
+	timer->armed = false;
 }
 
 static void kvm_timer_flush_hwstate_vgic(struct kvm_vcpu *vcpu)
@@ -448,7 +447,7 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 	 * This is to cancel the background timer for the physical timer
 	 * emulation if it is set.
 	 */
-	timer_disarm(timer);
+	soft_timer_cancel(&timer->timer, &timer->expired);
 
 	/*
 	 * The guest could have modified the timer registers or the timer
@@ -615,7 +614,7 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
-	timer_disarm(timer);
+	soft_timer_cancel(&timer->timer, &timer->expired);
 	kvm_vgic_unmap_phys_irq(vcpu, vtimer->irq.irq);
 }
 
-- 
2.9.0
