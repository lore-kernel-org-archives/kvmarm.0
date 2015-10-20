From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [GIT PULL 4/6] arm/arm64: KVM: Fix arch timer behavior for disabled interrupts
Date: Tue, 20 Oct 2015 18:19:05 +0200
Message-ID: <1445357947-6022-5-git-send-email-christoffer.dall@linaro.org>
References: <1445357947-6022-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1445357947-6022-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

We have an interesting issue when the guest disables the timer interrupt
on the VGIC, which happens when turning VCPUs off using PSCI, for
example.

The problem is that because the guest disables the virtual interrupt at
the VGIC level, we never inject interrupts to the guest and therefore
never mark the interrupt as active on the physical distributor.  The
host also never takes the timer interrupt (we only use the timer device
to trigger a guest exit and everything else is done in software), so the
interrupt does not become active through normal means.

The result is that we keep entering the guest with a programmed timer
that will always fire as soon as we context switch the hardware timer
state and run the guest, preventing forward progress for the VCPU.

Since the active state on the physical distributor is really part of the
timer logic, it is the job of our virtual arch timer driver to manage
this state.

The timer->map->active boolean field indicates whether we have signalled
this interrupt to the vgic and if that interrupt is still pending or
active.  As long as that is the case, the hardware doesn't have to
generate physical interrupts and therefore we mark the interrupt as
active on the physical distributor.

We also have to restore the pending state of an interrupt that was
queued to an LR but was retired from the LR for some reason, while
remaining pending in the LR.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Reported-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 19 +++++++++++++++++++
 virt/kvm/arm/vgic.c       | 43 +++++++++++--------------------------------
 2 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 48c6e1a..b9d3a32 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -137,6 +137,8 @@ bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
 void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	bool phys_active;
+	int ret;
 
 	/*
 	 * We're about to run this vcpu again, so there is no need to
@@ -151,6 +153,23 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	 */
 	if (kvm_timer_should_fire(vcpu))
 		kvm_timer_inject_irq(vcpu);
+
+	/*
+	 * We keep track of whether the edge-triggered interrupt has been
+	 * signalled to the vgic/guest, and if so, we mask the interrupt and
+	 * the physical distributor to prevent the timer from raising a
+	 * physical interrupt whenever we run a guest, preventing forward
+	 * VCPU progress.
+	 */
+	if (kvm_vgic_get_phys_irq_active(timer->map))
+		phys_active = true;
+	else
+		phys_active = false;
+
+	ret = irq_set_irqchip_state(timer->map->irq,
+				    IRQCHIP_STATE_ACTIVE,
+				    phys_active);
+	WARN_ON(ret);
 }
 
 /**
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 596455a..ea21bc2 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1092,6 +1092,15 @@ static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu)
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_lr vlr = vgic_get_lr(vcpu, lr_nr);
 
+	/*
+	 * We must transfer the pending state back to the distributor before
+	 * retiring the LR, otherwise we may loose edge-triggered interrupts.
+	 */
+	if (vlr.state & LR_STATE_PENDING) {
+		vgic_dist_irq_set_pending(vcpu, irq);
+		vlr.hwirq = 0;
+	}
+
 	vlr.state = 0;
 	vgic_set_lr(vcpu, lr_nr, vlr);
 	clear_bit(lr_nr, vgic_cpu->lr_used);
@@ -1241,7 +1250,7 @@ static void __kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	unsigned long *pa_percpu, *pa_shared;
-	int i, vcpu_id, lr, ret;
+	int i, vcpu_id;
 	int overflow = 0;
 	int nr_shared = vgic_nr_shared_irqs(dist);
 
@@ -1296,31 +1305,6 @@ epilog:
 		 */
 		clear_bit(vcpu_id, dist->irq_pending_on_cpu);
 	}
-
-	for (lr = 0; lr < vgic->nr_lr; lr++) {
-		struct vgic_lr vlr;
-
-		if (!test_bit(lr, vgic_cpu->lr_used))
-			continue;
-
-		vlr = vgic_get_lr(vcpu, lr);
-
-		/*
-		 * If we have a mapping, and the virtual interrupt is
-		 * presented to the guest (as pending or active), then we must
-		 * set the state to active in the physical world. See
-		 * Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt.
-		 */
-		if (vlr.state & LR_HW) {
-			struct irq_phys_map *map;
-			map = vgic_irq_map_search(vcpu, vlr.irq);
-
-			ret = irq_set_irqchip_state(map->irq,
-						    IRQCHIP_STATE_ACTIVE,
-						    true);
-			WARN_ON(ret);
-		}
-	}
 }
 
 static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
@@ -1430,13 +1414,8 @@ static int vgic_sync_hwirq(struct kvm_vcpu *vcpu, struct vgic_lr vlr)
 
 	WARN_ON(ret);
 
-	if (map->active) {
-		ret = irq_set_irqchip_state(map->irq,
-					    IRQCHIP_STATE_ACTIVE,
-					    false);
-		WARN_ON(ret);
+	if (map->active)
 		return 0;
-	}
 
 	return 1;
 }
-- 
2.1.2.330.g565301e.dirty

