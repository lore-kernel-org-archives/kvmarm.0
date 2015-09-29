From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v3 3/8] arm/arm64: KVM: vgic: Factor out level irq processing
 on guest exit
Date: Tue, 29 Sep 2015 16:49:00 +0200
Message-ID: <1443538145-11990-4-git-send-email-christoffer.dall@linaro.org>
References: <1443538145-11990-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4927B412EF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2015 10:47:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j-h0n38x2y52 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Sep 2015 10:47:36 -0400 (EDT)
Received: from mail-la0-f46.google.com (mail-la0-f46.google.com
 [209.85.215.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7FD6F41172
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2015 10:47:35 -0400 (EDT)
Received: by laer8 with SMTP id r8so11593225lae.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2015 07:49:09 -0700 (PDT)
In-Reply-To: <1443538145-11990-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Currently vgic_process_maintenance() processes dealing with a completed
level-triggered interrupt directly, but we are soon going to reuse this
logic for level-triggered mapped interrupts with the HW bit set, so
move this logic into a separate static function.

Probably the most scary part of this commit is convincing yourself that
the current flow is safe compared to the old one.  In the following I
try to list the changes and why they are harmless:

  Move vgic_irq_clear_queued after kvm_notify_acked_irq:
    Harmless because the only potential effect of clearing the queued
    flag wrt.  kvm_set_irq is that vgic_update_irq_pending does not set
    the pending bit on the emulated CPU interface or in the
    pending_on_cpu bitmask if the function is called with level=1.
    However, the point of kvm_notify_acked_irq is to call kvm_set_irq
    with level=0, and we set the queued flag again in
    __kvm_vgic_sync_hwstate later on if the level is stil high.

  Move vgic_set_lr before kvm_notify_acked_irq:
    Also, harmless because the LR are cpu-local operations and
    kvm_notify_acked only affects the dist

  Move vgic_dist_irq_clear_soft_pend after kvm_notify_acked_irq:
    Also harmless because it's just a bit which is cleared and altering
    the line state does not affect this bit.

Reviewed-by: Eric Auger <eric.auger@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic.c | 88 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 50 insertions(+), 38 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 6bd1c9b..fe0e5db 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1322,12 +1322,56 @@ epilog:
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
 
@@ -1342,54 +1386,22 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 
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
