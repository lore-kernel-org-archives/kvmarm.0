From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 4/5] KVM: arm/arm64: Properly handle arch-timer IRQs after vtimer_save_state
Date: Mon, 18 Dec 2017 11:00:56 +0100
Message-ID: <20171218100057.7839-5-christoffer.dall@linaro.org>
References: <20171218100057.7839-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171218100057.7839-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

The recent timer rework was assuming that once the timer was disabled,
we should no longer see any interrupts from the timer.  This assumption
turns out to not be true, and instead we have to handle the case when
the timer ISR runs even after the timer has been disabled.

This requires a couple of changes:

First, we should never overwrite the cached guest state of the timer
control register when the ISR runs, because KVM may have disabled its
timers when doing vcpu_put(), even though the guest still had the timer
enabled.

Second, we shouldn't assume that the timer is actually firing just
because we see an interrupt, but we should check the actual state of the
timer in the timer control register to understand if the hardware timer
is really firing or not.

We also add an ISB to vtimer_save_state() to ensure the timer is
actually disabled once we enable interrupts, which should clarify the
intention of the implementation, and reduce the risk of unwanted
interrupts.

Fixes: b103cc3f10c0 ("KVM: arm/arm64: Avoid timer save/restore in vcpu entry/exit")
Reported-by: Marc Zyngier <marc.zyngier@arm.com>
Reported-by: Jia He <hejianet@gmail.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Tested-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index aa9adfafe12b..14c018f990a7 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -92,16 +92,23 @@ static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
 {
 	struct kvm_vcpu *vcpu = *(struct kvm_vcpu **)dev_id;
 	struct arch_timer_context *vtimer;
+	u32 cnt_ctl;
 
-	if (!vcpu) {
-		pr_warn_once("Spurious arch timer IRQ on non-VCPU thread\n");
-		return IRQ_NONE;
-	}
-	vtimer = vcpu_vtimer(vcpu);
+	/*
+	 * We may see a timer interrupt after vcpu_put() has been called which
+	 * sets the CPU's vcpu pointer to NULL, because even though the timer
+	 * has been disabled in vtimer_save_state(), the hardware interrupt
+	 * signal may not have been retired from the interrupt controller yet.
+	 */
+	if (!vcpu)
+		return IRQ_HANDLED;
 
+	vtimer = vcpu_vtimer(vcpu);
 	if (!vtimer->irq.level) {
-		vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
-		if (kvm_timer_irq_can_fire(vtimer))
+		cnt_ctl = read_sysreg_el0(cntv_ctl);
+		cnt_ctl &= ARCH_TIMER_CTRL_ENABLE | ARCH_TIMER_CTRL_IT_STAT |
+			   ARCH_TIMER_CTRL_IT_MASK;
+		if (cnt_ctl == (ARCH_TIMER_CTRL_ENABLE | ARCH_TIMER_CTRL_IT_STAT))
 			kvm_timer_update_irq(vcpu, true, vtimer);
 	}
 
@@ -355,6 +362,7 @@ static void vtimer_save_state(struct kvm_vcpu *vcpu)
 
 	/* Disable the virtual timer */
 	write_sysreg_el0(0, cntv_ctl);
+	isb();
 
 	vtimer->loaded = false;
 out:
-- 
2.14.2
