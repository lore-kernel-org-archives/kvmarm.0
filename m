From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v5 10/20] KVM: arm/arm64: Use separate timer for phys timer
 emulation
Date: Fri, 27 Oct 2017 10:34:31 +0200
Message-ID: <1509093281-15225-11-git-send-email-cdall@linaro.org>
References: <1509093281-15225-1-git-send-email-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1391E40651
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 04:34:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SWKy+K2YV6Zx for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 04:34:30 -0400 (EDT)
Received: from mail-lf0-f67.google.com (mail-lf0-f67.google.com
 [209.85.215.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 04D2A49D27
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 04:34:30 -0400 (EDT)
Received: by mail-lf0-f67.google.com with SMTP id l23so6517874lfk.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 01:35:54 -0700 (PDT)
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

We were using the same hrtimer for emulating the physical timer and for
making sure a blocking VCPU thread would be eventually woken up.  That
worked fine in the previous arch timer design, but as we are about to
actually use the soft timer expire function for the physical timer
emulation, change the logic to use a dedicated hrtimer.

This has the added benefit of not having to cancel any work in the sync
path, which in turn allows us to run the flush and sync with IRQs
disabled.

Note that the hrtimer used to program the host kernel's timer to
generate an exit from the guest when the emulated physical timer fires
never has to inject any work, and to share the soft_timer_cancel()
function with the bg_timer, we change the function to only cancel any
pending work if the pointer to the work struct is not null.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 include/kvm/arm_arch_timer.h |  3 +++
 virt/kvm/arm/arch_timer.c    | 21 ++++++++++++++++-----
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 0eed5bc..184c3ef 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -48,6 +48,9 @@ struct arch_timer_cpu {
 	/* Work queued with the above timer expires */
 	struct work_struct		expired;
 
+	/* Physical timer emulation */
+	struct hrtimer			phys_timer;
+
 	/* Is the timer enabled */
 	bool			enabled;
 };
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 8ec3928..4ad8537 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -65,7 +65,8 @@ static void soft_timer_start(struct hrtimer *hrt, u64 ns)
 static void soft_timer_cancel(struct hrtimer *hrt, struct work_struct *work)
 {
 	hrtimer_cancel(hrt);
-	cancel_work_sync(work);
+	if (work)
+		cancel_work_sync(work);
 }
 
 static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
@@ -172,6 +173,12 @@ static enum hrtimer_restart kvm_bg_timer_expire(struct hrtimer *hrt)
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
@@ -249,7 +256,7 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
 }
 
 /* Schedule the background timer for the emulated timer. */
-static void kvm_timer_emulate(struct kvm_vcpu *vcpu,
+static void phys_timer_emulate(struct kvm_vcpu *vcpu,
 			      struct arch_timer_context *timer_ctx)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
@@ -261,7 +268,7 @@ static void kvm_timer_emulate(struct kvm_vcpu *vcpu,
 		return;
 
 	/*  The timer has not yet expired, schedule a background timer */
-	soft_timer_start(&timer->bg_timer, kvm_timer_compute_delta(timer_ctx));
+	soft_timer_start(&timer->phys_timer, kvm_timer_compute_delta(timer_ctx));
 }
 
 /*
@@ -414,7 +421,7 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	kvm_timer_update_state(vcpu);
 
 	/* Set the background timer for the physical timer emulation. */
-	kvm_timer_emulate(vcpu, vcpu_ptimer(vcpu));
+	phys_timer_emulate(vcpu, vcpu_ptimer(vcpu));
 
 	if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
 		kvm_timer_flush_hwstate_user(vcpu);
@@ -437,7 +444,7 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 	 * This is to cancel the background timer for the physical timer
 	 * emulation if it is set.
 	 */
-	soft_timer_cancel(&timer->bg_timer, &timer->expired);
+	soft_timer_cancel(&timer->phys_timer, NULL);
 
 	/*
 	 * The guest could have modified the timer registers or the timer
@@ -497,6 +504,9 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 	hrtimer_init(&timer->bg_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 	timer->bg_timer.function = kvm_bg_timer_expire;
 
+	hrtimer_init(&timer->phys_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	timer->phys_timer.function = kvm_phys_timer_expire;
+
 	vtimer->irq.irq = default_vtimer_irq.irq;
 	ptimer->irq.irq = default_ptimer_irq.irq;
 }
@@ -605,6 +615,7 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
 	soft_timer_cancel(&timer->bg_timer, &timer->expired);
+	soft_timer_cancel(&timer->phys_timer, NULL);
 	kvm_vgic_unmap_phys_irq(vcpu, vtimer->irq.irq);
 }
 
-- 
2.7.4
