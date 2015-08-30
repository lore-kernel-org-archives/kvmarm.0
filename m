From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 3/9] arm/arm64: KVM: vgic: Factor out level irq processing on guest exit
Date: Sun, 30 Aug 2015 15:54:20 +0200
Message-ID: <1440942866-23802-4-git-send-email-christoffer.dall@linaro.org>
References: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Currently vgic_process_maintenance() processes dealing with a completed
level-triggered interrupt directly, but we are soon going to reuse this
logic for level-triggered mapped interrupts with the HW bit set, so
move this logic into a separate static function.

Probably the most scary part of this commit is convincing yourself that
the current flow is safe compared to the old one.  In the following I
try to list the changes and why they are harmless:

  Move vgic_irq_clear_queued after kvm_notify_acked_irq:
    Harmless because the effect of clearing the queued flag wrt.
    kvm_set_irq is only that vgic_update_irq_pending does not set the
    pending bit on the emulated CPU interface or in the pending_on_cpu
    bitmask, but we set this in __kvm_vgic_sync_hwstate later on if the
    level is stil high.

  Move vgic_set_lr before kvm_notify_acked_irq:
    Also, harmless because the LR are cpu-local operations and
    kvm_notify_acked only affects the dist

  Move vgic_dist_irq_clear_soft_pend after kvm_notify_acked_irq:
    Also harmless because it's just a bit which is cleared and altering
    the line state does not affect this bit.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic.c | 88 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 50 insertions(+), 38 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 9eb489a..c5750be 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1312,12 +1312,56 @@ epilog:
 	}
 }
 
+static int process_level_irq(struct kvm_vcpu *vcpu, int lr, struct vgic_lr vlr)
+{
+	int level_pending = 0;
+
+	vlr.state = 0;
+	vlr.hwirq = 0;
+	vgic_set_lr(vcpu, lr, vlr);
+
+	/*
+	 * If the IRQ was EOIed (called from vgic_process_maintenance) or it
+	 * went from active to non-active (called from vgic_sync_hwirq) it was
+	 * also ACKed and we we therefore assume we can clear the soft pending
+	 * state (should it had been set) for this interrupt.
+	 *
+	 * Note: if the IRQ soft pending state was set after the IRQ was
+	 * acked, it actually shouldn't be cleared, but we have no way of
+	 * knowing that unless we start trapping ACKs when the soft-pending
+	 * state is set.
+	 */
+	vgic_dist_irq_clear_soft_pend(vcpu, vlr.irq);
+
+	/*
+	 * Tell the gic to start sampling the line of this interrupt again.
+	 */
+	vgic_irq_clear_queued(vcpu, vlr.irq);
+
+	/* Any additional pending interrupt? */
+	if (vgic_dist_irq_get_level(vcpu, vlr.irq)) {
+		vgic_cpu_irq_set(vcpu, vlr.irq);
+		level_pending = 1;
+	} else {
+		vgic_dist_irq_clear_pending(vcpu, vlr.irq);
+		vgic_cpu_irq_clear(vcpu, vlr.irq);
+	}
+
+	/*
+	 * Despite being EOIed, the LR may not have
+	 * been marked as empty.
+	 */
+	vgic_sync_lr_elrsr(vcpu, lr, vlr);
+
+	return level_pending;
+}
+
 static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 {
 	u32 status = vgic_get_interrupt_status(vcpu);
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
-	bool level_pending = false;
 	struct kvm *kvm = vcpu->kvm;
+	int level_pending = 0;
 
 	kvm_debug("STATUS = %08x\n", status);
 
@@ -1332,54 +1376,22 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 
 		for_each_set_bit(lr, eisr_ptr, vgic->nr_lr) {
 			struct vgic_lr vlr = vgic_get_lr(vcpu, lr);
-			WARN_ON(vgic_irq_is_edge(vcpu, vlr.irq));
 
-			spin_lock(&dist->lock);
-			vgic_irq_clear_queued(vcpu, vlr.irq);
+			WARN_ON(vgic_irq_is_edge(vcpu, vlr.irq));
 			WARN_ON(vlr.state & LR_STATE_MASK);
-			vlr.state = 0;
-			vgic_set_lr(vcpu, lr, vlr);
 
-			/*
-			 * If the IRQ was EOIed it was also ACKed and we we
-			 * therefore assume we can clear the soft pending
-			 * state (should it had been set) for this interrupt.
-			 *
-			 * Note: if the IRQ soft pending state was set after
-			 * the IRQ was acked, it actually shouldn't be
-			 * cleared, but we have no way of knowing that unless
-			 * we start trapping ACKs when the soft-pending state
-			 * is set.
-			 */
-			vgic_dist_irq_clear_soft_pend(vcpu, vlr.irq);
 
 			/*
 			 * kvm_notify_acked_irq calls kvm_set_irq()
-			 * to reset the IRQ level. Need to release the
-			 * lock for kvm_set_irq to grab it.
+			 * to reset the IRQ level, which grabs the dist->lock
+			 * so we call this before taking the dist->lock.
 			 */
-			spin_unlock(&dist->lock);
-
 			kvm_notify_acked_irq(kvm, 0,
 					     vlr.irq - VGIC_NR_PRIVATE_IRQS);
-			spin_lock(&dist->lock);
-
-			/* Any additional pending interrupt? */
-			if (vgic_dist_irq_get_level(vcpu, vlr.irq)) {
-				vgic_cpu_irq_set(vcpu, vlr.irq);
-				level_pending = true;
-			} else {
-				vgic_dist_irq_clear_pending(vcpu, vlr.irq);
-				vgic_cpu_irq_clear(vcpu, vlr.irq);
-			}
 
+			spin_lock(&dist->lock);
+			level_pending |= process_level_irq(vcpu, lr, vlr);
 			spin_unlock(&dist->lock);
-
-			/*
-			 * Despite being EOIed, the LR may not have
-			 * been marked as empty.
-			 */
-			vgic_sync_lr_elrsr(vcpu, lr, vlr);
 		}
 	}
 
-- 
2.1.2.330.g565301e.dirty

