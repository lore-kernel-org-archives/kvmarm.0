From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v3 08/20] KVM: arm/arm64: Rename soft timer to bg_timer
Date: Sat, 23 Sep 2017 02:41:55 +0200
Message-ID: <20170923004207.22356-9-cdall@linaro.org>
References: <20170923004207.22356-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD56949C64
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Sep 2017 20:42:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mlucMn3tE982 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Sep 2017 20:42:06 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D613749C89
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Sep 2017 20:42:05 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id m72so3844094wmc.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Sep 2017 17:42:17 -0700 (PDT)
In-Reply-To: <20170923004207.22356-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

As we are about to introduce a separate hrtimer for the physical timer,
call this timer bg_timer, because we refer to this timer as the
background timer in the code and comments elsewhere.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 include/kvm/arm_arch_timer.h |  3 +--
 virt/kvm/arm/arch_timer.c    | 22 +++++++++++-----------
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index f0053f8..dcbb2e1 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -43,8 +43,7 @@ struct arch_timer_cpu {
 	struct arch_timer_context	ptimer;
 
 	/* Background timer used when the guest is not running */
-	struct hrtimer			timer;
-
+	struct hrtimer			bg_timer;
 	/* Work queued with the above timer expires */
 	struct work_struct		expired;
 
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 871d8ae..c2e8326 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -56,7 +56,7 @@ u64 kvm_phys_timer_read(void)
 	return timecounter->cc->read(timecounter->cc);
 }
 
-static bool soft_timer_is_armed(struct arch_timer_cpu *timer)
+static bool bg_timer_is_armed(struct arch_timer_cpu *timer)
 {
 	return timer->armed;
 }
@@ -154,13 +154,13 @@ static u64 kvm_timer_earliest_exp(struct kvm_vcpu *vcpu)
 	return min(min_virt, min_phys);
 }
 
-static enum hrtimer_restart kvm_timer_expire(struct hrtimer *hrt)
+static enum hrtimer_restart kvm_bg_timer_expire(struct hrtimer *hrt)
 {
 	struct arch_timer_cpu *timer;
 	struct kvm_vcpu *vcpu;
 	u64 ns;
 
-	timer = container_of(hrt, struct arch_timer_cpu, timer);
+	timer = container_of(hrt, struct arch_timer_cpu, bg_timer);
 	vcpu = container_of(timer, struct kvm_vcpu, arch.timer_cpu);
 
 	/*
@@ -267,7 +267,7 @@ static void kvm_timer_emulate(struct kvm_vcpu *vcpu,
 		return;
 
 	/*  The timer has not yet expired, schedule a background timer */
-	soft_timer_start(&timer->timer, kvm_timer_compute_delta(timer_ctx));
+	soft_timer_start(&timer->bg_timer, kvm_timer_compute_delta(timer_ctx));
 }
 
 /*
@@ -281,7 +281,7 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
-	BUG_ON(soft_timer_is_armed(timer));
+	BUG_ON(bg_timer_is_armed(timer));
 
 	/*
 	 * No need to schedule a background timer if any guest timer has
@@ -303,14 +303,14 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
 	 * Set the earliest expiration time among the guest timers.
 	 */
 	timer->armed = true;
-	soft_timer_start(&timer->timer, kvm_timer_earliest_exp(vcpu));
+	soft_timer_start(&timer->bg_timer, kvm_timer_earliest_exp(vcpu));
 }
 
 void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 
-	soft_timer_cancel(&timer->timer, &timer->expired);
+	soft_timer_cancel(&timer->bg_timer, &timer->expired);
 	timer->armed = false;
 }
 
@@ -447,7 +447,7 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 	 * This is to cancel the background timer for the physical timer
 	 * emulation if it is set.
 	 */
-	soft_timer_cancel(&timer->timer, &timer->expired);
+	soft_timer_cancel(&timer->bg_timer, &timer->expired);
 
 	/*
 	 * The guest could have modified the timer registers or the timer
@@ -504,8 +504,8 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 	vcpu_ptimer(vcpu)->cntvoff = 0;
 
 	INIT_WORK(&timer->expired, kvm_timer_inject_irq_work);
-	hrtimer_init(&timer->timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
-	timer->timer.function = kvm_timer_expire;
+	hrtimer_init(&timer->bg_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	timer->bg_timer.function = kvm_bg_timer_expire;
 
 	vtimer->irq.irq = default_vtimer_irq.irq;
 	ptimer->irq.irq = default_ptimer_irq.irq;
@@ -614,7 +614,7 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
-	soft_timer_cancel(&timer->timer, &timer->expired);
+	soft_timer_cancel(&timer->bg_timer, &timer->expired);
 	kvm_vgic_unmap_phys_irq(vcpu, vtimer->irq.irq);
 }
 
-- 
2.9.0
