From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 17/20] KVM: arm/arm64: Move phys_timer_emulate function
Date: Fri, 20 Oct 2017 13:49:36 +0200
Message-ID: <20171020114939.12554-18-christoffer.dall@linaro.org>
References: <20171020114939.12554-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD99349D17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 07:49:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0D8IgVt7Tb5L for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Oct 2017 07:49:02 -0400 (EDT)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5544049D64
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 07:49:01 -0400 (EDT)
Received: by mail-wm0-f66.google.com with SMTP id k4so21985348wmc.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 04:50:07 -0700 (PDT)
In-Reply-To: <20171020114939.12554-1-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <cdall@linaro.org>

We are about to call phys_timer_emulate() from kvm_timer_update_state()
and modify phys_timer_emulate() at the same time.  Moving the function
and modifying it in a single patch makes the diff hard to read, so do
this separately first.

No functional change.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/arch_timer.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index d1a6fb12121f..7f4f12d48a1a 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -255,6 +255,22 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
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
@@ -281,22 +297,6 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
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
2.14.2
