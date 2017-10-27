From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v5 17/20] KVM: arm/arm64: Move phys_timer_emulate function
Date: Fri, 27 Oct 2017 10:34:38 +0200
Message-ID: <1509093281-15225-18-git-send-email-cdall@linaro.org>
References: <1509093281-15225-1-git-send-email-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 748C649D26
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 04:35:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FUufvQbl2GHo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 04:35:07 -0400 (EDT)
Received: from mail-lf0-f66.google.com (mail-lf0-f66.google.com
 [209.85.215.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6BA9D49D1F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 04:35:07 -0400 (EDT)
Received: by mail-lf0-f66.google.com with SMTP id p184so6511723lfe.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 01:36:32 -0700 (PDT)
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
index d1a6fb1..7f4f12d 100644
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
2.7.4
