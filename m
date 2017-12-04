From: Christoffer Dall <cdall@kernel.org>
Subject: [PATCH v6 3/8] KVM: arm/arm64: Don't cache the timer IRQ level
Date: Mon,  4 Dec 2017 21:05:01 +0100
Message-ID: <20171204200506.3224-4-cdall@kernel.org>
References: <20171204200506.3224-1-cdall@kernel.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171204200506.3224-1-cdall@kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

The timer was modeled after a strict idea of modelling an interrupt line
level in software, meaning that only transitions in the level needed to
be reported to the VGIC.  This works well for the timer, because the
arch timer code is in complete control of the device and can track the
transitions of the line.

However, as we are about to support using the HW bit in the VGIC not
just for the timer, but also for VFIO which cannot track transitions of
the interrupt line, we have to decide on an interface for level
triggered mapped interrupts to the GIC, which both the timer and VFIO
can use.

VFIO only sees an asserting transition of the physical interrupt line,
and tells the VGIC when that happens.  That means that part of the
interrupt flow is offloaded to the hardware.

To use the same interface for VFIO devices and the timer, we therefore
have to change the timer (we cannot change VFIO because it doesn't know
the details of the device it is assigning to a VM).

Luckily, changing the timer is simple, we just need to stop 'caching'
the line level, but instead let the VGIC know the state of the timer
every time there is a potential change in the line level, and when the
line level should be asserted from the timer ISR.  The VGIC can ignore
extra notifications using its validate mechanism.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 4151250ce8da..dd5aca05c500 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -99,11 +99,9 @@ static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
 	}
 	vtimer = vcpu_vtimer(vcpu);
 
-	if (!vtimer->irq.level) {
-		vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
-		if (kvm_timer_irq_can_fire(vtimer))
-			kvm_timer_update_irq(vcpu, true, vtimer);
-	}
+	vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
+	if (kvm_timer_irq_can_fire(vtimer))
+		kvm_timer_update_irq(vcpu, true, vtimer);
 
 	if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
 		kvm_vtimer_update_mask_user(vcpu);
@@ -324,12 +322,20 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+	bool level;
 
 	if (unlikely(!timer->enabled))
 		return;
 
-	if (kvm_timer_should_fire(vtimer) != vtimer->irq.level)
-		kvm_timer_update_irq(vcpu, !vtimer->irq.level, vtimer);
+	/*
+	 * The vtimer virtual interrupt is a 'mapped' interrupt, meaning part
+	 * of its lifecycle is offloaded to the hardware, and we therefore may
+	 * not have lowered the irq.level value before having to signal a new
+	 * interrupt, but have to signal an interrupt every time the level is
+	 * asserted.
+	 */
+	level = kvm_timer_should_fire(vtimer);
+	kvm_timer_update_irq(vcpu, level, vtimer);
 
 	if (kvm_timer_should_fire(ptimer) != ptimer->irq.level)
 		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
-- 
2.14.2
