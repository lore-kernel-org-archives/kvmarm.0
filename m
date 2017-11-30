From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] KVM: arm/arm64: Fix spinlock acquisition in vgic_set_owner
Date: Thu, 30 Nov 2017 17:00:30 +0000
Message-ID: <20171130170030.29827-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

vgic_set_owner acquires the irq lock without disabling interrupts,
resulting in a lockdep splat (an interrupt could fire and result
in the same lock being taken if the same virtual irq is to be
injected).

In practice, it is almost impossible to trigger this bug, but
better safe than sorry. Convert the lock acquisition to a
spin_lock_irqsave() and keep lockdep happy.

Reported-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index b168a328a9e0..8d863e6405a5 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -492,6 +492,7 @@ int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid)
 int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned int intid, void *owner)
 {
 	struct vgic_irq *irq;
+	unsigned long flags;
 	int ret = 0;
 
 	if (!vgic_initialized(vcpu->kvm))
@@ -502,12 +503,12 @@ int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned int intid, void *owner)
 		return -EINVAL;
 
 	irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
-	spin_lock(&irq->irq_lock);
+	spin_lock_irqsave(&irq->irq_lock, flags);
 	if (irq->owner && irq->owner != owner)
 		ret = -EEXIST;
 	else
 		irq->owner = owner;
-	spin_unlock(&irq->irq_lock);
+	spin_unlock_irqrestore(&irq->irq_lock, flags);
 
 	return ret;
 }
-- 
2.11.0
