From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 4/8] KVM: arm/arm64: vgic-v3: Always resample level interrupts
Date: Thu,  2 Jun 2016 12:20:56 +0200
Message-ID: <1464862860-1183-5-git-send-email-christoffer.dall@linaro.org>
References: <1464862860-1183-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464862860-1183-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

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
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-v3.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 336a461..346b4ad 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -101,11 +101,15 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 			}
 		}
 
-		/* Clear soft pending state when level irqs have been acked */
-		if (irq->config == VGIC_CONFIG_LEVEL &&
-		    !(val & ICH_LR_PENDING_BIT)) {
-			irq->soft_pending = false;
-			irq->pending = irq->line_level;
+		/*
+		 * Clear soft pending state when level irqs have been acked.
+		 * Always regenerate the pending state.
+		 */
+		if (irq->config == VGIC_CONFIG_LEVEL) {
+			if (!(val & ICH_LR_PENDING_BIT))
+				irq->soft_pending = false;
+
+			irq->pending = irq->line_level || irq->soft_pending;
 		}
 
 		spin_unlock(&irq->irq_lock);
-- 
2.1.2.330.g565301e.dirty

