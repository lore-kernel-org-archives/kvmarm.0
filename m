From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 10/11] KVM: arm/arm64: timer: Allow the timer to control the active state
Date: Fri,  7 Aug 2015 16:45:46 +0100
Message-ID: <1438962347-17541-11-git-send-email-marc.zyngier@arm.com>
References: <1438962347-17541-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1438962347-17541-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

In order to remove the crude hack where we sneak the masked bit
into the timer's control register, make use of the phys_irq_map
API control the active state of the interrupt.

This causes some limited changes to allow for potential error
propagation.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/reset.c         |  4 +---
 arch/arm64/kvm/reset.c       |  4 +---
 include/kvm/arm_arch_timer.h |  7 +++++--
 virt/kvm/arm/arch_timer.c    | 29 ++++++++++++++++++++++-------
 4 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/arch/arm/kvm/reset.c b/arch/arm/kvm/reset.c
index f558c07..eeb85858 100644
--- a/arch/arm/kvm/reset.c
+++ b/arch/arm/kvm/reset.c
@@ -77,7 +77,5 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	kvm_reset_coprocs(vcpu);
 
 	/* Reset arch_timer context */
-	kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq);
-
-	return 0;
+	return kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq);
 }
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index b4af618..91cf535 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -121,7 +121,5 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	kvm_reset_sys_regs(vcpu);
 
 	/* Reset timer */
-	kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq);
-
-	return 0;
+	return kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq);
 }
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index e596675..e1e4d7c 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -52,13 +52,16 @@ struct arch_timer_cpu {
 
 	/* Timer IRQ */
 	const struct kvm_irq_level	*irq;
+
+	/* VGIC mapping */
+	struct irq_phys_map		*map;
 };
 
 int kvm_timer_hyp_init(void);
 void kvm_timer_enable(struct kvm *kvm);
 void kvm_timer_init(struct kvm *kvm);
-void kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
-			  const struct kvm_irq_level *irq);
+int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
+			 const struct kvm_irq_level *irq);
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu);
 void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 98c95f2..76e38d2 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -64,10 +64,10 @@ static void kvm_timer_inject_irq(struct kvm_vcpu *vcpu)
 	int ret;
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 
-	timer->cntv_ctl |= ARCH_TIMER_CTRL_IT_MASK;
-	ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
-				  timer->irq->irq,
-				  timer->irq->level);
+	kvm_vgic_set_phys_irq_active(timer->map, true);
+	ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
+					 timer->map,
+					 timer->irq->level);
 	WARN_ON(ret);
 }
 
@@ -117,7 +117,8 @@ bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
 	cycle_t cval, now;
 
 	if ((timer->cntv_ctl & ARCH_TIMER_CTRL_IT_MASK) ||
-		!(timer->cntv_ctl & ARCH_TIMER_CTRL_ENABLE))
+	    !(timer->cntv_ctl & ARCH_TIMER_CTRL_ENABLE) ||
+	    kvm_vgic_get_phys_irq_active(timer->map))
 		return false;
 
 	cval = timer->cntv_cval;
@@ -184,10 +185,11 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 	timer_arm(timer, ns);
 }
 
-void kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
-			  const struct kvm_irq_level *irq)
+int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
+			 const struct kvm_irq_level *irq)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct irq_phys_map *map;
 
 	/*
 	 * The vcpu timer irq number cannot be determined in
@@ -196,6 +198,17 @@ void kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 	 * vcpu timer irq number when the vcpu is reset.
 	 */
 	timer->irq = irq;
+
+	/*
+	 * Tell the VGIC that the virtual interrupt is tied to a
+	 * physical interrupt. We do that once per VCPU.
+	 */
+	map = kvm_vgic_map_phys_irq(vcpu, irq->irq, host_vtimer_irq);
+	if (WARN_ON(IS_ERR(map)))
+		return PTR_ERR(map);
+
+	timer->map = map;
+	return 0;
 }
 
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
@@ -335,6 +348,8 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 
 	timer_disarm(timer);
+	if (timer->map)
+		kvm_vgic_unmap_phys_irq(vcpu, timer->map);
 }
 
 void kvm_timer_enable(struct kvm *kvm)
-- 
2.1.4

