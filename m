From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 07/26] KVM: arm/arm64: Rename soft timer to bg_timer
Date: Tue,  7 Nov 2017 11:47:40 +0100
Message-ID: <20171107104800.30021-8-christoffer.dall@linaro.org>
References: <20171107104800.30021-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09E5C49D52
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 05:46:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v0o1QOJJZh+6 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Nov 2017 05:46:26 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 11EB049D8A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 05:46:26 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id r196so2753104wmf.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Nov 2017 02:48:20 -0800 (PST)
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
