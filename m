From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 09/10] KVM: arm/arm64: timer: Allow the timer to control the active state
Date: Mon,  8 Jun 2015 18:04:04 +0100
Message-ID: <1433783045-8002-10-git-send-email-marc.zyngier@arm.com>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

In order to remove the crude hack where we sneak the masked bit
into the timer's control register, make use of the phys_irq_map
API control the active state of the interrupt.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_arch_timer.h |  3 +++
 virt/kvm/arm/arch_timer.c    | 13 +++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index e596675..9feebf1 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -52,6 +52,9 @@ struct arch_timer_cpu {
 
 	/* Timer IRQ */
 	const struct kvm_irq_level	*irq;
+
+	/* VGIC mapping */
+	struct irq_phys_map		*map;
 };
 
 int kvm_timer_hyp_init(void);
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 98c95f2..b9fff78 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -64,7 +64,7 @@ static void kvm_timer_inject_irq(struct kvm_vcpu *vcpu)
 	int ret;
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 
-	timer->cntv_ctl |= ARCH_TIMER_CTRL_IT_MASK;
+	vgic_set_phys_irq_active(timer->map, true);
 	ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
 				  timer->irq->irq,
 				  timer->irq->level);
@@ -117,7 +117,8 @@ bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
 	cycle_t cval, now;
 
 	if ((timer->cntv_ctl & ARCH_TIMER_CTRL_IT_MASK) ||
-		!(timer->cntv_ctl & ARCH_TIMER_CTRL_ENABLE))
+	    !(timer->cntv_ctl & ARCH_TIMER_CTRL_ENABLE) ||
+	    vgic_get_phys_irq_active(timer->map))
 		return false;
 
 	cval = timer->cntv_cval;
@@ -196,6 +197,13 @@ void kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 	 * vcpu timer irq number when the vcpu is reset.
 	 */
 	timer->irq = irq;
+
+	/*
+	 * Tell the VGIC that the virtual interrupt is tied to a
+	 * physical interrupt. We do that once per VCPU.
+	 */
+	timer->map = vgic_map_phys_irq(vcpu, irq->irq, host_vtimer_irq);
+	WARN_ON(!timer->map);
 }
 
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
@@ -335,6 +343,7 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 
 	timer_disarm(timer);
+	vgic_unmap_phys_irq(vcpu, timer->map);
 }
 
 void kvm_timer_enable(struct kvm *kvm)
-- 
2.1.4

