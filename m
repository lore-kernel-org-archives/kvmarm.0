From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 1/3] KVM: arm/arm64: Cleanup the arch timer code's irqchip
 checking
Date: Tue, 27 Sep 2016 21:08:04 +0200
Message-ID: <20160927190806.22988-2-christoffer.dall@linaro.org>
References: <20160927190806.22988-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFA8B41267
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 14:58:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AtAygjcYlSBB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 14:58:33 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E7A61412DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 14:58:32 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id b130so30170810wmc.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 12:07:56 -0700 (PDT)
In-Reply-To: <20160927190806.22988-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexander Graf <agraf@suse.de>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

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
index 27a1f63..824ed26 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -171,8 +171,6 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
 	int ret;
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 
-	BUG_ON(!vgic_initialized(vcpu->kvm));
-
 	timer->active_cleared_last = false;
 	timer->irq.level = new_level;
 	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->irq.irq,
@@ -187,7 +185,7 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
  * Check if there was a change in the timer state (should we raise or lower
  * the line level to the GIC).
  */
-static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
+static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 
@@ -197,13 +195,11 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
 	 * because the guest would never see the interrupt.  Instead wait
 	 * until we call this function from kvm_timer_flush_hwstate.
 	 */
-	if (!vgic_initialized(vcpu->kvm) || !timer->enabled)
-		return -ENODEV;
+	if (!timer->enabled)
+		return;
 
 	if (kvm_timer_should_fire(vcpu) != timer->irq.level)
 		kvm_timer_update_irq(vcpu, !timer->irq.level);
-
-	return 0;
 }
 
 /*
@@ -255,9 +251,11 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	bool phys_active;
 	int ret;
 
-	if (kvm_timer_update_state(vcpu))
+	if (unlikely(!timer->enabled))
 		return;
 
+	kvm_timer_update_state(vcpu);
+
 	/*
 	* If we enter the guest with the virtual input level to the VGIC
 	* asserted, then we have already told the VGIC what we need to, and
-- 
2.9.0
