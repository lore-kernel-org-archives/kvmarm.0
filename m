From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 08/20] KVM: arm/arm64: Rename soft timer to bg_timer
Date: Fri, 20 Oct 2017 13:49:27 +0200
Message-ID: <20171020114939.12554-9-christoffer.dall@linaro.org>
References: <20171020114939.12554-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171020114939.12554-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <cdall@linaro.org>

As we are about to introduce a separate hrtimer for the physical timer,
call this timer bg_timer, because we refer to this timer as the
background timer in the code and comments elsewhere.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_arch_timer.h |  2 +-
 virt/kvm/arm/arch_timer.c    | 18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index d0beae98f755..0eed5bc9fd5e 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -43,7 +43,7 @@ struct arch_timer_cpu {
 	struct arch_timer_context	ptimer;
 
 	/* Background timer used when the guest is not running */
-	struct hrtimer			timer;
+	struct hrtimer			bg_timer;
 
 	/* Work queued with the above timer expires */
 	struct work_struct		expired;
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 223230191195..8ec392850e69 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -148,13 +148,13 @@ static u64 kvm_timer_earliest_exp(struct kvm_vcpu *vcpu)
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
@@ -261,7 +261,7 @@ static void kvm_timer_emulate(struct kvm_vcpu *vcpu,
 		return;
 
 	/*  The timer has not yet expired, schedule a background timer */
-	soft_timer_start(&timer->timer, kvm_timer_compute_delta(timer_ctx));
+	soft_timer_start(&timer->bg_timer, kvm_timer_compute_delta(timer_ctx));
 }
 
 /*
@@ -294,14 +294,14 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
 	 * The guest timers have not yet expired, schedule a background timer.
 	 * Set the earliest expiration time among the guest timers.
 	 */
-	soft_timer_start(&timer->timer, kvm_timer_earliest_exp(vcpu));
+	soft_timer_start(&timer->bg_timer, kvm_timer_earliest_exp(vcpu));
 }
 
 void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 
-	soft_timer_cancel(&timer->timer, &timer->expired);
+	soft_timer_cancel(&timer->bg_timer, &timer->expired);
 }
 
 static void kvm_timer_flush_hwstate_vgic(struct kvm_vcpu *vcpu)
@@ -437,7 +437,7 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 	 * This is to cancel the background timer for the physical timer
 	 * emulation if it is set.
 	 */
-	soft_timer_cancel(&timer->timer, &timer->expired);
+	soft_timer_cancel(&timer->bg_timer, &timer->expired);
 
 	/*
 	 * The guest could have modified the timer registers or the timer
@@ -494,8 +494,8 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 	vcpu_ptimer(vcpu)->cntvoff = 0;
 
 	INIT_WORK(&timer->expired, kvm_timer_inject_irq_work);
-	hrtimer_init(&timer->timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
-	timer->timer.function = kvm_timer_expire;
+	hrtimer_init(&timer->bg_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	timer->bg_timer.function = kvm_bg_timer_expire;
 
 	vtimer->irq.irq = default_vtimer_irq.irq;
 	ptimer->irq.irq = default_ptimer_irq.irq;
@@ -604,7 +604,7 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
-	soft_timer_cancel(&timer->timer, &timer->expired);
+	soft_timer_cancel(&timer->bg_timer, &timer->expired);
 	kvm_vgic_unmap_phys_irq(vcpu, vtimer->irq.irq);
 }
 
-- 
2.14.2
