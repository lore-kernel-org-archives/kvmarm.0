From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v3 3/3] KVM: arm/arm64: Refactor vgic_retire_lr()
Date: Mon, 26 Oct 2015 12:00:30 +0300
Message-ID: <d0305551f0e1b1183b1903121466e598c47846f6.1445849885.git.p.fedin@samsung.com>
References: <cover.1445849885.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <cover.1445849885.git.p.fedin@samsung.com>
In-reply-to: <cover.1445849885.git.p.fedin@samsung.com>
References: <cover.1445849885.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

1. Remove unnecessary 'irq' argument, because irq number can be retrieved
   from the LR.
2. vgic_retire_lr() is always accompanied by vgic_irq_clear_queued(). Since
   it already does more than just clearing the LR, move
   vgic_irq_clear_queued() inside of it.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 virt/kvm/arm/vgic.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 43f2564..fe451d4 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -105,7 +105,7 @@
 #include "vgic.h"
 
 static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu);
-static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu);
+static void vgic_retire_lr(int lr_nr, struct kvm_vcpu *vcpu);
 static struct vgic_lr vgic_get_lr(const struct kvm_vcpu *vcpu, int lr);
 static void vgic_set_lr(struct kvm_vcpu *vcpu, int lr, struct vgic_lr lr_desc);
 static u64 vgic_get_elrsr(struct kvm_vcpu *vcpu);
@@ -724,8 +724,7 @@ void vgic_unqueue_irqs(struct kvm_vcpu *vcpu)
 		 * Reestablish the pending state on the distributor and the
 		 * CPU interface and mark the LR as free for other use.
 		 */
-		vgic_retire_lr(i, lr.irq, vcpu);
-		vgic_irq_clear_queued(vcpu, lr.irq);
+		vgic_retire_lr(i, vcpu);
 
 		/* Finally update the VGIC state. */
 		vgic_update_state(vcpu->kvm);
@@ -1078,16 +1077,18 @@ static inline void vgic_enable(struct kvm_vcpu *vcpu)
 	vgic_ops->enable(vcpu);
 }
 
-static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu)
+static void vgic_retire_lr(int lr_nr, struct kvm_vcpu *vcpu)
 {
 	struct vgic_lr vlr = vgic_get_lr(vcpu, lr_nr);
 
+	vgic_irq_clear_queued(vcpu, vlr.irq);
+
 	/*
 	 * We must transfer the pending state back to the distributor before
 	 * retiring the LR, otherwise we may loose edge-triggered interrupts.
 	 */
 	if (vlr.state & LR_STATE_PENDING) {
-		vgic_dist_irq_set_pending(vcpu, irq);
+		vgic_dist_irq_set_pending(vcpu, vlr.irq);
 		vlr.hwirq = 0;
 	}
 
@@ -1113,11 +1114,8 @@ static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu)
 	for_each_clear_bit(lr, elrsr_ptr, vgic->nr_lr) {
 		struct vgic_lr vlr = vgic_get_lr(vcpu, lr);
 
-		if (!vgic_irq_is_enabled(vcpu, vlr.irq)) {
-			vgic_retire_lr(lr, vlr.irq, vcpu);
-			if (vgic_irq_is_queued(vcpu, vlr.irq))
-				vgic_irq_clear_queued(vcpu, vlr.irq);
-		}
+		if (!vgic_irq_is_enabled(vcpu, vlr.irq))
+			vgic_retire_lr(lr, vcpu);
 	}
 }
 
-- 
2.4.4

