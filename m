From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 70/79] KVM: arm/arm64: Cleanup the arch timer code's irqchip
 checking
Date: Sun, 23 Apr 2017 19:09:20 +0200
Message-ID: <20170423170929.27334-71-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8659C49D82
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:08:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9YcKokFt0U+c for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:08:03 -0400 (EDT)
Received: from mail-wr0-f182.google.com (mail-wr0-f182.google.com
 [209.85.128.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B837149D20
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:08:00 -0400 (EDT)
Received: by mail-wr0-f182.google.com with SMTP id w50so55839189wrc.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:47 -0700 (PDT)
In-Reply-To: <20170423170929.27334-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Currently we check if we have an in-kernel irqchip and if the vgic was
properly implemented several places in the arch timer code.  But, we
already predicate our enablement of the arm timers on having a valid
and initialized gic, so we can simply check if the timers are enabled or
not.

This also gets rid of the ugly "error that's not an error but used to
signal that the timer shouldn't poke the gic" construct we have.

Reviewed-by: Alexander Graf <agraf@suse.de>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 35d7100..363f0d2 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -189,8 +189,6 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 {
 	int ret;
 
-	BUG_ON(!vgic_initialized(vcpu->kvm));
-
 	timer_ctx->active_cleared_last = false;
 	timer_ctx->irq.level = new_level;
 	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer_ctx->irq.irq,
@@ -205,7 +203,7 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
  * Check if there was a change in the timer state (should we raise or lower
  * the line level to the GIC).
  */
-static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
+static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
@@ -217,16 +215,14 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
 	 * because the guest would never see the interrupt.  Instead wait
 	 * until we call this function from kvm_timer_flush_hwstate.
 	 */
-	if (!vgic_initialized(vcpu->kvm) || !timer->enabled)
-		return -ENODEV;
+	if (!timer->enabled)
+		return;
 
 	if (kvm_timer_should_fire(vtimer) != vtimer->irq.level)
 		kvm_timer_update_irq(vcpu, !vtimer->irq.level, vtimer);
 
 	if (kvm_timer_should_fire(ptimer) != ptimer->irq.level)
 		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
-
-	return 0;
 }
 
 /* Schedule the background timer for the emulated timer. */
@@ -295,13 +291,16 @@ void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
  */
 void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 {
+	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	bool phys_active;
 	int ret;
 
-	if (kvm_timer_update_state(vcpu))
+	if (unlikely(!timer->enabled))
 		return;
 
+	kvm_timer_update_state(vcpu);
+
 	/* Set the background timer for the physical timer emulation. */
 	kvm_timer_emulate(vcpu, vcpu_ptimer(vcpu));
 
-- 
2.9.0
