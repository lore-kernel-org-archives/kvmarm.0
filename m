From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] KVM: arm/arm64: vgic-new: Removel harmful BUG_ON
Date: Thu,  2 Jun 2016 09:24:06 +0100
Message-ID: <1464855846-1625-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

When changing the active bit from an MMIO trap, we decide to
explode if the intid is that of a private interrupt.

This really looks like a leftover from a previous version, as
the callers explicitly check for private interrupts and handle
them correctly. I've managed to reproduce it using a custom
guest.

Dropping the BUG_ON seems like the right thing to do.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-mmio.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 059595e..9f6fab7 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -191,10 +191,8 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 	 * other thread sync back the IRQ.
 	 */
 	while (irq->vcpu && /* IRQ may have state in an LR somewhere */
-	       irq->vcpu->cpu != -1) { /* VCPU thread is running */
-		BUG_ON(irq->intid < VGIC_NR_PRIVATE_IRQS);
+	       irq->vcpu->cpu != -1) /* VCPU thread is running */
 		cond_resched_lock(&irq->irq_lock);
-	}
 
 	irq->active = new_active_state;
 	if (new_active_state)
-- 
2.1.4

