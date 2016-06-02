From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 3/8] KVM: arm/arm64: vgic-v2: Always resample level interrupts
Date: Thu,  2 Jun 2016 12:20:55 +0200
Message-ID: <1464862860-1183-4-git-send-email-christoffer.dall@linaro.org>
References: <1464862860-1183-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 979C5411BE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2016 06:17:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9etHmEndV5z3 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jun 2016 06:17:15 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE07B410EB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2016 06:17:15 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id n184so72398682wmn.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Jun 2016 03:21:13 -0700 (PDT)
In-Reply-To: <1464862860-1183-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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
2.1.2.330.g565301e.dirty
