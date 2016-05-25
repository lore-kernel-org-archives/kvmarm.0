From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 3/7] KVM: arm/arm64: vgic-v2: Always resample level interrupts
Date: Wed, 25 May 2016 15:26:35 +0100
Message-ID: <1464186399-16604-4-git-send-email-marc.zyngier@arm.com>
References: <1464186399-16604-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464186399-16604-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

When reading back from the list registers, we need to perform
two actions for level interrupts:
1) clear the soft-pending bit if the interrupt is not pending
   anymore *in the list register*
2) resample the line level and propagate it to the pending state

But these two actions shouldn't be linked, and we should *always*
resample the line level, no matter what state is in the list
register. Otherwise, we may end-up injecting spurious interrupts
that have been already retired.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-v2.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 8ad42c2..e31405e 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -112,11 +112,15 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 			}
 		}
 
-		/* Clear soft pending state when level IRQs have been acked */
-		if (irq->config == VGIC_CONFIG_LEVEL &&
-		    !(val & GICH_LR_PENDING_BIT)) {
-			irq->soft_pending = false;
-			irq->pending = irq->line_level;
+		/*
+		 * Clear soft pending state when level irqs have been acked.
+		 * Always regenerate the pending state.
+		 */
+		if (irq->config == VGIC_CONFIG_LEVEL) {
+			if (!(val & GICH_LR_PENDING_BIT))
+				irq->soft_pending = false;
+
+			irq->pending = irq->line_level || irq->soft_pending;
 		}
 
 		spin_unlock(&irq->irq_lock);
-- 
2.1.4

