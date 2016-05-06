From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 07/55] KVM: arm/arm64: vgic: Remove irq_phys_map from interface
Date: Fri,  6 May 2016 11:45:20 +0100
Message-ID: <1462531568-9799-8-git-send-email-andre.przywara@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Now that the virtual arch timer does not care about the irq_phys_map
anymore, let's rework kvm_vgic_map_phys_irq() to return an error
value instead. Any reference to that mapping can later be done by
passing the correct combination of VCPU and virtual IRQ number.
This makes the irq_phys_map handling completely private to the
VGIC code.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@linaro.org>
---
Changelog v1 .. v2:
- adaptations to changes in previous patches (removal of virt_irq)

Changelog v2 .. v3:
- simplify return in kvm_timer_vcpu_reset()

 include/kvm/arm_vgic.h    |  3 +--
 virt/kvm/arm/arch_timer.c |  7 +------
 virt/kvm/arm/vgic.c       | 15 +++++++--------
 3 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 49c559e..f842d7d 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -343,8 +343,7 @@ int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
 			       unsigned int virt_irq, bool level);
 void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
-struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
-					   int virt_irq, int phys_irq);
+int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, int virt_irq, int phys_irq);
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq);
 bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
 
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index f2cd188..ebc4616 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -334,7 +334,6 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 			 const struct kvm_irq_level *irq)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
-	struct irq_phys_map *map;
 	struct irq_desc *desc;
 	struct irq_data *data;
 	int phys_irq;
@@ -375,11 +374,7 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 	 * Tell the VGIC that the virtual interrupt is tied to a
 	 * physical interrupt. We do that once per VCPU.
 	 */
-	map = kvm_vgic_map_phys_irq(vcpu, irq->irq, phys_irq);
-	if (WARN_ON(IS_ERR(map)))
-		return PTR_ERR(map);
-
-	return 0;
+	return kvm_vgic_map_phys_irq(vcpu, irq->irq, phys_irq);
 }
 
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 41792c0..00386df 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1720,21 +1720,20 @@ static struct list_head *vgic_get_irq_phys_map_list(struct kvm_vcpu *vcpu,
  * the physical interrupt represented by @phys_irq. This mapping can be
  * established multiple times as long as the parameters are the same.
  *
- * Returns a valid pointer on success, and an error pointer otherwise
+ * Returns 0 on success or an error value otherwise.
  */
-struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
-					   int virt_irq, int phys_irq)
+int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, int virt_irq, int phys_irq)
 {
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	struct list_head *root = vgic_get_irq_phys_map_list(vcpu, virt_irq);
 	struct irq_phys_map *map;
 	struct irq_phys_map_entry *entry;
-
+	int ret = 0;
 
 	/* Create a new mapping */
 	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 
 	spin_lock(&dist->irq_phys_map_lock);
 
@@ -1743,7 +1742,7 @@ struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 	if (map) {
 		/* Make sure this mapping matches */
 		if (map->phys_irq != phys_irq)
-			map = ERR_PTR(-EINVAL);
+			ret = -EINVAL;
 
 		/* Found an existing, valid mapping */
 		goto out;
@@ -1759,9 +1758,9 @@ out:
 	spin_unlock(&dist->irq_phys_map_lock);
 	/* If we've found a hit in the existing list, free the useless
 	 * entry */
-	if (IS_ERR(map) || map != &entry->map)
+	if (ret || map != &entry->map)
 		kfree(entry);
-	return map;
+	return ret;
 }
 
 static struct irq_phys_map *vgic_irq_map_search(struct kvm_vcpu *vcpu,
-- 
2.7.3

