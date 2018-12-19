From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 14/28] KVM: arm/arm64: vgic: Do not cond_resched_lock() with
 IRQs disabled
Date: Wed, 19 Dec 2018 18:03:35 +0000
Message-ID: <20181219180349.242681-15-marc.zyngier@arm.com>
References: <20181219180349.242681-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FA634A369
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:04:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BxgzMnFV-vIJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Dec 2018 13:04:50 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCD584A39A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:04:48 -0500 (EST)
In-Reply-To: <20181219180349.242681-1-marc.zyngier@arm.com>
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
Cc: Punit Agrawal <punit.agrawal@arm.com>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Lukas Braun <koomi@moshbit.net>
List-Id: kvmarm@lists.cs.columbia.edu

From: Julien Thierry <julien.thierry@arm.com>

To change the active state of an MMIO, halt is requested for all vcpus of
the affected guest before modifying the IRQ state. This is done by calling
cond_resched_lock() in vgic_mmio_change_active(). However interrupts are
disabled at this point and we cannot reschedule a vcpu.

We actually don't need any of this, as kvm_arm_halt_guest ensures that
all the other vcpus are out of the guest. Let's just drop that useless
code.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Suggested-by: Christoffer Dall <christoffer.dall@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-mmio.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 2b450d49a046..7c2231950c33 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -313,27 +313,6 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 
 	spin_lock_irqsave(&irq->irq_lock, flags);
 
-	/*
-	 * If this virtual IRQ was written into a list register, we
-	 * have to make sure the CPU that runs the VCPU thread has
-	 * synced back the LR state to the struct vgic_irq.
-	 *
-	 * As long as the conditions below are true, we know the VCPU thread
-	 * may be on its way back from the guest (we kicked the VCPU thread in
-	 * vgic_change_active_prepare)  and still has to sync back this IRQ,
-	 * so we release and re-acquire the spin_lock to let the other thread
-	 * sync back the IRQ.
-	 *
-	 * When accessing VGIC state from user space, requester_vcpu is
-	 * NULL, which is fine, because we guarantee that no VCPUs are running
-	 * when accessing VGIC state from user space so irq->vcpu->cpu is
-	 * always -1.
-	 */
-	while (irq->vcpu && /* IRQ may have state in an LR somewhere */
-	       irq->vcpu != requester_vcpu && /* Current thread is not the VCPU thread */
-	       irq->vcpu->cpu != -1) /* VCPU thread is running */
-		cond_resched_lock(&irq->irq_lock);
-
 	if (irq->hw) {
 		vgic_hw_irq_change_active(vcpu, irq, active, !requester_vcpu);
 	} else {
-- 
2.19.2
