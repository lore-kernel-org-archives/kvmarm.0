From: Christoffer Dall <cdall@linaro.org>
Subject: [RFC PATCH v2 16/19] KVM: arm/arm64: Move phys_timer_emulate function
Date: Mon, 17 Jul 2017 16:27:15 +0200
Message-ID: <20170717142718.13853-17-cdall@linaro.org>
References: <20170717142718.13853-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EBE949C30
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jul 2017 10:27:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jPUL-dC3j9Me for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Jul 2017 10:26:56 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E72F249C18
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jul 2017 10:26:54 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id f67so85841701wmh.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jul 2017 07:27:41 -0700 (PDT)
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

We are about to call phys_timer_emulate() from kvm_timer_update_state()
and modify phys_timer_emulate() at the same time.  Moving the function
and modifying it in a single patch makes the diff hard to read, so do
this separately first.

No functional change.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index d5b632d..1f82c21 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -252,6 +252,22 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 	}
 }
 
+/* Schedule the background timer for the emulated timer. */
+static void phys_timer_emulate(struct kvm_vcpu *vcpu,
+			      struct arch_timer_context *timer_ctx)
+{
+	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+
+	if (kvm_timer_should_fire(timer_ctx))
+		return;
+
+	if (!kvm_timer_irq_can_fire(timer_ctx))
+		return;
+
+	/*  The timer has not yet expired, schedule a background timer */
+	soft_timer_start(&timer->phys_timer, kvm_timer_compute_delta(timer_ctx));
+}
+
 /*
  * Check if there was a change in the timer state (should we raise or lower
  * the line level to the GIC).
@@ -278,22 +294,6 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
 		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
 }
 
-/* Schedule the background timer for the emulated timer. */
-static void phys_timer_emulate(struct kvm_vcpu *vcpu,
-			      struct arch_timer_context *timer_ctx)
-{
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
-
-	if (kvm_timer_should_fire(timer_ctx))
-		return;
-
-	if (!kvm_timer_irq_can_fire(timer_ctx))
-		return;
-
-	/*  The timer has not yet expired, schedule a background timer */
-	soft_timer_start(&timer->phys_timer, kvm_timer_compute_delta(timer_ctx));
-}
-
 static void vtimer_save_state(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
-- 
2.9.0
