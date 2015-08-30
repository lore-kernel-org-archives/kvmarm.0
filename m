From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 7/9] arm/arm64: KVM: vgic: Move active state handling to flush_hwstate
Date: Sun, 30 Aug 2015 15:54:24 +0200
Message-ID: <1440942866-23802-8-git-send-email-christoffer.dall@linaro.org>
References: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

We currently set the physical active state only when we *inject* a new
pending virtual interrupt, but this is actually not correct, because we
could have been preempted and run something else on the system that
resets the active state to clear.  This causes us to run the VM with the
timer set to fire, but without setting the physical active state.

The solution is to always check the LR configurations, and we if have a
mapped interrupt in th LR in either the pending or active state
(virtual), then set the physical active state.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic.c | 42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 8299c24..9ed8d53 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1144,26 +1144,11 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
 		struct irq_phys_map *map;
 		map = vgic_irq_map_search(vcpu, irq);
 
-		/*
-		 * If we have a mapping, and the virtual interrupt is
-		 * being injected, then we must set the state to
-		 * active in the physical world. Otherwise the
-		 * physical interrupt will fire and the guest will
-		 * exit before processing the virtual interrupt.
-		 */
 		if (map) {
-			int ret;
-
-			BUG_ON(!map->active);
 			vlr.hwirq = map->phys_irq;
 			vlr.state |= LR_HW;
 			vlr.state &= ~LR_EOI_INT;
 
-			ret = irq_set_irqchip_state(map->irq,
-						    IRQCHIP_STATE_ACTIVE,
-						    true);
-			WARN_ON(ret);
-
 			/*
 			 * Make sure we're not going to sample this
 			 * again, as a HW-backed interrupt cannot be
@@ -1255,7 +1240,7 @@ static void __kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	unsigned long *pa_percpu, *pa_shared;
-	int i, vcpu_id;
+	int i, vcpu_id, lr, ret;
 	int overflow = 0;
 	int nr_shared = vgic_nr_shared_irqs(dist);
 
@@ -1310,6 +1295,31 @@ epilog:
 		 */
 		clear_bit(vcpu_id, dist->irq_pending_on_cpu);
 	}
+
+	for (lr = 0; lr < vgic->nr_lr; lr++) {
+		struct vgic_lr vlr;
+
+		if (!test_bit(lr, vgic_cpu->lr_used))
+			continue;
+
+		vlr = vgic_get_lr(vcpu, lr);
+
+		/*
+		 * If we have a mapping, and the virtual interrupt is
+		 * presented to the guest (as pending or active), then we must
+		 * set the state to active in the physical world. See
+		 * Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt.
+		 */
+		if (vlr.state & LR_HW) {
+			struct irq_phys_map *map;
+			map = vgic_irq_map_search(vcpu, vlr.irq);
+
+			ret = irq_set_irqchip_state(map->irq,
+						    IRQCHIP_STATE_ACTIVE,
+						    true);
+			WARN_ON(ret);
+		}
+	}
 }
 
 static int process_level_irq(struct kvm_vcpu *vcpu, int lr, struct vgic_lr vlr)
-- 
2.1.2.330.g565301e.dirty

