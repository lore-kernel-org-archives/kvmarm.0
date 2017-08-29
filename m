From: Christoffer Dall <cdall@linaro.org>
Subject: [RFC PATCH 3/4] KVM: arm/arm64: Rearrange kvm_vgic_[un]map_phys code in vgic.c
Date: Tue, 29 Aug 2017 11:39:01 +0200
Message-ID: <20170829093902.15379-4-cdall@linaro.org>
References: <20170829093902.15379-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170829093902.15379-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, Eric Auger <eric.auger@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

The small indirection of a static function made the locking very obvious
but becomes pretty ugly as we start passing function pointer around.
Let's inline these two functions first to make the following patch more
readable.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/vgic/vgic.c | 38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 2691a0a..e3ce2fa 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -428,12 +428,17 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 	return 0;
 }
 
-/* @irq->irq_lock must be held */
-static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
-			    unsigned int host_irq)
+int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
+			  u32 vintid)
 {
+	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
 	struct irq_desc *desc;
 	struct irq_data *data;
+	int ret = 0;
+
+	BUG_ON(!irq);
+
+	spin_lock(&irq->irq_lock);
 
 	/*
 	 * Find the physical IRQ number corresponding to @host_irq
@@ -441,7 +446,8 @@ static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 	desc = irq_to_desc(host_irq);
 	if (!desc) {
 		kvm_err("%s: no interrupt descriptor\n", __func__);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 	data = irq_desc_get_irq_data(desc);
 	while (data->parent_data)
@@ -450,29 +456,10 @@ static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 	irq->hw = true;
 	irq->host_irq = host_irq;
 	irq->hwintid = data->hwirq;
-	return 0;
-}
-
-/* @irq->irq_lock must be held */
-static inline void kvm_vgic_unmap_irq(struct vgic_irq *irq)
-{
-	irq->hw = false;
-	irq->hwintid = 0;
-}
-
-int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
-			  u32 vintid)
-{
-	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
-	int ret;
 
-	BUG_ON(!irq);
-
-	spin_lock(&irq->irq_lock);
-	ret = kvm_vgic_map_irq(vcpu, irq, host_irq);
+out:
 	spin_unlock(&irq->irq_lock);
 	vgic_put_irq(vcpu->kvm, irq);
-
 	return ret;
 }
 
@@ -487,7 +474,8 @@ int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid)
 	BUG_ON(!irq);
 
 	spin_lock(&irq->irq_lock);
-	kvm_vgic_unmap_irq(irq);
+	irq->hw = false;
+	irq->hwintid = 0;
 	spin_unlock(&irq->irq_lock);
 	vgic_put_irq(vcpu->kvm, irq);
 
-- 
2.9.0
