From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 04/56] KVM: arm/arm64: vgic: avoid map in kvm_vgic_unmap_phys_irq()
Date: Mon, 16 May 2016 10:52:52 +0100
Message-ID: <1463392481-26583-5-git-send-email-andre.przywara@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

kvm_vgic_unmap_phys_irq() only needs the virtual IRQ number, so let's
just pass that between the arch timer and the VGIC to get rid of
the irq_phys_map pointer.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@linaro.org>
---
 include/kvm/arm_vgic.h    |  2 +-
 virt/kvm/arm/arch_timer.c |  2 +-
 virt/kvm/arm/vgic.c       | 11 ++++-------
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 9830232..c7bb184 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -347,7 +347,7 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 					   int virt_irq, int irq);
-int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
+int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq);
 bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
 
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 37f82c1..962b442 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -486,7 +486,7 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 
 	timer_disarm(timer);
 	if (timer->map)
-		kvm_vgic_unmap_phys_irq(vcpu, timer->map);
+		kvm_vgic_unmap_phys_irq(vcpu, timer->map->virt_irq);
 }
 
 void kvm_timer_enable(struct kvm *kvm)
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 2fd43a6..06abd59 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1812,25 +1812,22 @@ static void vgic_free_phys_irq_map_rcu(struct rcu_head *rcu)
 /**
  * kvm_vgic_unmap_phys_irq - Remove a virtual to physical IRQ mapping
  * @vcpu: The VCPU pointer
- * @map: The pointer to a mapping obtained through kvm_vgic_map_phys_irq
+ * @virt_irq: The virtual IRQ number to be unmapped
  *
  * Remove an existing mapping between virtual and physical interrupts.
  */
-int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map)
+int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq)
 {
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	struct irq_phys_map_entry *entry;
 	struct list_head *root;
 
-	if (!map)
-		return -EINVAL;
-
-	root = vgic_get_irq_phys_map_list(vcpu, map->virt_irq);
+	root = vgic_get_irq_phys_map_list(vcpu, virt_irq);
 
 	spin_lock(&dist->irq_phys_map_lock);
 
 	list_for_each_entry(entry, root, entry) {
-		if (&entry->map == map) {
+		if (entry->map.virt_irq == virt_irq) {
 			list_del_rcu(&entry->entry);
 			call_rcu(&entry->rcu, vgic_free_phys_irq_map_rcu);
 			break;
-- 
2.8.2

