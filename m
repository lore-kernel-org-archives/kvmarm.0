From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v9 3/9] KVM: arm/arm64: Don't cache the timer IRQ level
Date: Wed, 20 Dec 2017 12:36:00 +0100
Message-ID: <20171220113606.7030-4-christoffer.dall@linaro.org>
References: <20171220113606.7030-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA22549DB1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Dec 2017 06:32:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bNekkRqzvKFx for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Dec 2017 06:32:32 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B943649D6A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Dec 2017 06:32:32 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id i11so9104495wmf.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Dec 2017 03:36:22 -0800 (PST)
In-Reply-To: <20171220113606.7030-1-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The timer logic was designed after a strict idea of modeling an
interrupt line level in software, meaning that only transitions in the
level need to be reported to the VGIC.  This works well for the timer,
because the arch timer code is in complete control of the device and can
track the transitions of the line.

However, as we are about to support using the HW bit in the VGIC not
just for the timer, but also for VFIO which cannot track transitions of
the interrupt line, we have to decide on an interface between the GIC
and other subsystems for level triggered mapped interrupts, which both
the timer and VFIO can use.

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

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index f9555b1e7f15..9376fe03bf2e 100644
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
