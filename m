From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH] KVM: arm/arm64: Let vcpu thread modify its own active state
Date: Mon,  6 Mar 2017 01:56:39 -0800
Message-ID: <1488794199-22397-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2188140A74
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 04:55:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3dGo+B9PqgRw for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Mar 2017 04:55:23 -0500 (EST)
Received: from mail-wr0-f177.google.com (mail-wr0-f177.google.com
 [209.85.128.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AF4FD400E9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 04:55:23 -0500 (EST)
Received: by mail-wr0-f177.google.com with SMTP id u108so112379280wrb.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Mar 2017 01:56:43 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org, Eric Auger <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Jintack Lim <jintack@cs.columbia.edu>

Currently, if a vcpu thread tries to change its own active state when
the irq is already in AP list, it'll loop forever. Since the VCPU thread
has already synced back LR state to the struct vgic_irq, let it modify
its own state safely.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 virt/kvm/arm/vgic/vgic-mmio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 3654b4c..29101ab 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -185,9 +185,9 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 	 * If this virtual IRQ was written into a list register, we
 	 * have to make sure the CPU that runs the VCPU thread has
 	 * synced back LR state to the struct vgic_irq.  We can only
-	 * know this for sure, when either this irq is not assigned to
+	 * know this for sure, when this irq is not assigned to
 	 * anyone's AP list anymore, or the VCPU thread is not
-	 * running on any CPUs.
+	 * running on any CPUs, or current thread is the VCPU thread.
 	 *
 	 * In the opposite case, we know the VCPU thread may be on its
 	 * way back from the guest and still has to sync back this
@@ -195,6 +195,7 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 	 * other thread sync back the IRQ.
 	 */
 	while (irq->vcpu && /* IRQ may have state in an LR somewhere */
+	       irq->vcpu != vcpu && /* Current thread is not the VCPU thread */
 	       irq->vcpu->cpu != -1) /* VCPU thread is running */
 		cond_resched_lock(&irq->irq_lock);
 
-- 
2.5.0
