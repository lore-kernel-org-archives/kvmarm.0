From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 08/10] KVM: arm/arm64: vgic: Add vgic_{get,set}_phys_irq_active
Date: Wed,  8 Jul 2015 18:56:40 +0100
Message-ID: <1436378202-20224-9-git-send-email-marc.zyngier@arm.com>
References: <1436378202-20224-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1436378202-20224-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

In order to control the active state of an interrupt, introduce
a pair of accessors allowing the state to be set/queried.

This only affects the logical state, and the HW state will only be
applied at world-switch time.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h |  2 ++
 virt/kvm/arm/vgic.c    | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 32e57d2..9fd4023 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -356,6 +356,8 @@ int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
 struct irq_phys_map *vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 				       int virt_irq, int irq);
 int vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
+bool vgic_get_phys_irq_active(struct irq_phys_map *map);
+void vgic_set_phys_irq_active(struct irq_phys_map *map, bool active);
 
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index f8582d7..39f9479 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1744,6 +1744,18 @@ static void vgic_free_phys_irq_map_rcu(struct rcu_head *rcu)
 	kfree(entry);
 }
 
+bool vgic_get_phys_irq_active(struct irq_phys_map *map)
+{
+	BUG_ON(!map);
+	return map->active;
+}
+
+void vgic_set_phys_irq_active(struct irq_phys_map *map, bool active)
+{
+	BUG_ON(!map);
+	map->active = active;
+}
+
 int vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map)
 {
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
-- 
2.1.4

