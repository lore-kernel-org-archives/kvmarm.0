From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v2 1/5] KVM: arm/arm64: Cleanup the arch timer code's irqchip checking
Date: Fri,  3 Feb 2017 15:56:51 +0100
Message-ID: <20170203145655.15007-2-cdall@linaro.org>
References: <20170203145655.15007-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170203145655.15007-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>, Peter Maydell <peter.maydell@linaro.org>, Pekka Enberg <penberg@iki.fi>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Currently we check if we have an in-kernel irqchip and if the vgic was
properly implemented several places in the arch timer code.  But, we
already predicate our enablement of the arm timers on having a valid
and initialized gic, so we can simply check if the timers are enabled or
not.

This also gets rid of the ugly "error that's not an error but used to
signal that the timer shouldn't poke the gic" construct we have.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 35d7100..5099b30 100644
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
@@ -299,9 +295,11 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
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
