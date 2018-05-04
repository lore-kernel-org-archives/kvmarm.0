From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 2/2] KVM: ARM: VGIC/ITS: Promote irq_lock() in update_affinity
Date: Fri,  4 May 2018 18:19:45 +0100
Message-ID: <20180504171945.22118-2-andre.przywara@arm.com>
References: <20180504171945.22118-1-andre.przywara@arm.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180504171945.22118-1-andre.przywara@arm.com>
Sender: stable-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, Jan Glauber <jan.glauber@caviumnetworks.com>
List-Id: kvmarm@lists.cs.columbia.edu

Apparently the development of update_affinity() overlapped with the
promotion of irq_lock to be _irqsave, so the patch didn't convert this
lock over. This will make lockdep complain.

Fix this disabling IRQs around the lock.

Cc: stable@vger.kernel.org
Fixes: 08c9fd042117 ("KVM: arm/arm64: vITS: Add a helper to update the affinity of an LPI")
Reported-by: Jan Glauber <jan.glauber@caviumnetworks.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 41abf92f2699..51a80b600632 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -350,10 +350,11 @@ static int vgic_copy_lpi_list(struct kvm_vcpu *vcpu, u32 **intid_ptr)
 static int update_affinity(struct vgic_irq *irq, struct kvm_vcpu *vcpu)
 {
 	int ret = 0;
+	unsigned long flags;
 
-	spin_lock(&irq->irq_lock);
+	spin_lock_irqsave(&irq->irq_lock, flags);
 	irq->target_vcpu = vcpu;
-	spin_unlock(&irq->irq_lock);
+	spin_unlock_irqrestore(&irq->irq_lock, flags);
 
 	if (irq->hw) {
 		struct its_vlpi_map map;
-- 
2.14.1
