From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 8/8] KVM: arm/arm64: vgic-new: Removel harmful BUG_ON
Date: Thu,  2 Jun 2016 12:21:00 +0200
Message-ID: <1464862860-1183-9-git-send-email-christoffer.dall@linaro.org>
References: <1464862860-1183-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8461A412A2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2016 06:17:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cktWuLWRU+h9 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jun 2016 06:17:24 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A70CC412DD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2016 06:17:24 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id a20so61042369wma.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Jun 2016 03:21:22 -0700 (PDT)
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

When changing the active bit from an MMIO trap, we decide to
explode if the intid is that of a private interrupt.

This flawed logic comes from the fact that we were assuming that
kvm_vcpu_kick() as called by kvm_arm_halt_vcpu() would not return before
the called vcpu responded, but this is not the case, so we need to
perform this wait even for private interrupts.

Dropping the BUG_ON seems like the right thing to do.

 [ Commit message tweaked by Christoffer ]

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
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
2.1.2.330.g565301e.dirty
