From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 3/7] KVM: arm/arm64: vgic-v2: Always resample level interrupts
Date: Mon, 23 May 2016 13:36:59 +0100
Message-ID: <1464007023-11736-4-git-send-email-marc.zyngier@arm.com>
References: <1464007023-11736-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BF0249B87
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 May 2016 08:33:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5biQgB+h05n7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 May 2016 08:33:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A65049B43
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 May 2016 08:33:44 -0400 (EDT)
In-Reply-To: <1464007023-11736-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

When reading back from the list registers, we need to perform
two actions for level interrupts:
1) clear the soft-pending bit if the interrupt is not pending
   anymore *in the list register*
2) resample the line level and propagate it to the pending state

But these two actions linked, and we should *always* resample
the line level, no matter what state is in the list register.
Otherwise, we may end-up injecting spurious interrupts that
have been already retired.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-v2.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 8ad42c2..f659af0 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -112,10 +112,13 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 			}
 		}
 
-		/* Clear soft pending state when level IRQs have been acked */
-		if (irq->config == VGIC_CONFIG_LEVEL &&
-		    !(val & GICH_LR_PENDING_BIT)) {
-			irq->soft_pending = false;
+		/*
+		 * Clear soft pending state when level irqs have been acked.
+		 * Always resample the line level.
+		 */
+		if (irq->config == VGIC_CONFIG_LEVEL) {
+			if (!(val & GICH_LR_PENDING_BIT))
+				irq->soft_pending = false;
 			irq->pending = irq->line_level;
 		}
 
-- 
2.1.4
