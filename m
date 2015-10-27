From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v4 2/3] KVM: arm/arm64: Clean up vgic_retire_lr() and
 surroundings
Date: Tue, 27 Oct 2015 11:37:30 +0300
Message-ID: <82a9773391b2545a6293b4fbb3d42dff12bd744b.1445934536.git.p.fedin@samsung.com>
References: <cover.1445934536.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A99D41349
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2015 04:34:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h+zIHConZW35 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2015 04:34:48 -0400 (EDT)
Received: from mailout4.w1.samsung.com (mailout4.w1.samsung.com
 [210.118.77.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CD52E412EF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2015 04:34:48 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NWV00HH4EMQNK60@mailout4.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 27 Oct 2015 08:37:38 +0000 (GMT)
In-reply-to: <cover.1445934536.git.p.fedin@samsung.com>
In-reply-to: <cover.1445934536.git.p.fedin@samsung.com>
References: <cover.1445934536.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

1. Remove unnecessary 'irq' argument, because irq number can be retrieved
   from the LR.
2. Since cff9211eb1a1f58ce7f5a2d596b617928fd4be0e
   ("arm/arm64: KVM: Fix arch timer behavior for disabled interrupts ")
   LR_STATE_PENDING is queued back by vgic_retire_lr() itself. Also, it
   clears vlr.state itself. Therefore, we remove the same, now duplicated,
   check with all accompanying bit manipulations from vgic_unqueue_irqs().
3. vgic_retire_lr() is always accompanied by vgic_irq_clear_queued(). Since
   it already does more than just clearing the LR, move
   vgic_irq_clear_queued() inside of it.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 virt/kvm/arm/vgic.c | 37 ++++++++++---------------------------
 1 file changed, 10 insertions(+), 27 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 265a410..96e45f3 100644
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
@@ -717,30 +717,14 @@ void vgic_unqueue_irqs(struct kvm_vcpu *vcpu)
 		 * interrupt then move the active state to the
 		 * distributor tracking bit.
 		 */
-		if (lr.state & LR_STATE_ACTIVE) {
+		if (lr.state & LR_STATE_ACTIVE)
 			vgic_irq_set_active(vcpu, lr.irq);
-			lr.state &= ~LR_STATE_ACTIVE;
-		}
 
 		/*
 		 * Reestablish the pending state on the distributor and the
-		 * CPU interface.  It may have already been pending, but that
-		 * is fine, then we are only setting a few bits that were
-		 * already set.
+		 * CPU interface and mark the LR as free for other use.
 		 */
-		if (lr.state & LR_STATE_PENDING) {
-			vgic_dist_irq_set_pending(vcpu, lr.irq);
-			lr.state &= ~LR_STATE_PENDING;
-		}
-
-		vgic_set_lr(vcpu, i, lr);
-
-		/*
-		 * Mark the LR as free for other use.
-		 */
-		BUG_ON(lr.state & LR_STATE_MASK);
-		vgic_retire_lr(i, lr.irq, vcpu);
-		vgic_irq_clear_queued(vcpu, lr.irq);
+		vgic_retire_lr(i, vcpu);
 
 		/* Finally update the VGIC state. */
 		vgic_update_state(vcpu->kvm);
@@ -1099,16 +1083,18 @@ static inline void vgic_enable(struct kvm_vcpu *vcpu)
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
 
@@ -1135,11 +1121,8 @@ static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu)
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
