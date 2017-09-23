From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v3 09/20] KVM: arm/arm64: Use separate timer for phys timer
 emulation
Date: Sat, 23 Sep 2017 02:41:56 +0200
Message-ID: <20170923004207.22356-10-cdall@linaro.org>
References: <20170923004207.22356-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E53949C6C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Sep 2017 20:42:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NGc+5iLslBvG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Sep 2017 20:42:07 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 337BA49C6D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Sep 2017 20:42:07 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id m127so7644065wmm.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Sep 2017 17:42:18 -0700 (PDT)
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

We were using the same hrtimer for emulating the physical timer and for
making sure a blocking VCPU thread would be eventually woken up.  That
worked fine in the previous arch timer design, but as we are about to
actually use the soft timer expire function for the physical timer
emulation, change the logic to use a dedicated hrtimer.

This has the added benefit of not having to cancel any work in the sync
path, which in turn allows us to run the flush and sync with IRQs
disabled.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 include/kvm/arm_arch_timer.h |  3 +++
 virt/kvm/arm/arch_timer.c    | 18 ++++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index dcbb2e1..16887c0 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -47,6 +47,9 @@ struct arch_timer_cpu {
 	/* Work queued with the above timer expires */
 	struct work_struct		expired;
 
+	/* Physical timer emulation */
+	struct hrtimer			phys_timer;
+
 	/* Background timer active */
 	bool				armed;
 
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index c2e8326..7f87099 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -178,6 +178,12 @@ static enum hrtimer_restart kvm_bg_timer_expire(struct hrtimer *hrt)
 	return HRTIMER_NORESTART;
 }
 
+static enum hrtimer_restart kvm_phys_timer_expire(struct hrtimer *hrt)
+{
+	WARN(1, "Timer only used to ensure guest exit - unexpected event.");
+	return HRTIMER_NORESTART;
+}
+
 bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 {
 	u64 cval, now;
@@ -255,7 +261,7 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
 }
 
 /* Schedule the background timer for the emulated timer. */
-static void kvm_timer_emulate(struct kvm_vcpu *vcpu,
+static void phys_timer_emulate(struct kvm_vcpu *vcpu,
 			      struct arch_timer_context *timer_ctx)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
@@ -267,7 +273,7 @@ static void kvm_timer_emulate(struct kvm_vcpu *vcpu,
 		return;
 
 	/*  The timer has not yet expired, schedule a background timer */
-	soft_timer_start(&timer->bg_timer, kvm_timer_compute_delta(timer_ctx));
+	soft_timer_start(&timer->phys_timer, kvm_timer_compute_delta(timer_ctx));
 }
 
 /*
@@ -424,7 +430,7 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	kvm_timer_update_state(vcpu);
 
 	/* Set the background timer for the physical timer emulation. */
-	kvm_timer_emulate(vcpu, vcpu_ptimer(vcpu));
+	phys_timer_emulate(vcpu, vcpu_ptimer(vcpu));
 
 	if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
 		kvm_timer_flush_hwstate_user(vcpu);
@@ -447,7 +453,7 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 	 * This is to cancel the background timer for the physical timer
 	 * emulation if it is set.
 	 */
-	soft_timer_cancel(&timer->bg_timer, &timer->expired);
+	soft_timer_cancel(&timer->phys_timer, NULL);
 
 	/*
 	 * The guest could have modified the timer registers or the timer
@@ -507,6 +513,9 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 	hrtimer_init(&timer->bg_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 	timer->bg_timer.function = kvm_bg_timer_expire;
 
+	hrtimer_init(&timer->phys_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	timer->phys_timer.function = kvm_phys_timer_expire;
+
 	vtimer->irq.irq = default_vtimer_irq.irq;
 	ptimer->irq.irq = default_ptimer_irq.irq;
 }
@@ -615,6 +624,7 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
 	soft_timer_cancel(&timer->bg_timer, &timer->expired);
+	soft_timer_cancel(&timer->phys_timer, NULL);
 	kvm_vgic_unmap_phys_irq(vcpu, vtimer->irq.irq);
 }
 
-- 
2.9.0
