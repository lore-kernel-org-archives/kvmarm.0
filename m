From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 21/25] KVM: arm/arm64: vgic: Add vgic_{get,set}_phys_irq_active
Date: Thu, 20 Aug 2015 17:28:59 +0100
Message-ID: <1440088143-4722-22-git-send-email-marc.zyngier@arm.com>
References: <1440088143-4722-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440088143-4722-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Mario Smarduch <m.smarduch@samsung.com>, "Suzuki K. Poulose" <suzuki.poulose@arm.com>, Vladimir Murzin <vladimir.murzin@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

In order to control the active state of an interrupt, introduce
a pair of accessors allowing the state to be set/queried.

This only affects the logical state, and the HW state will only be
applied at world-switch time.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h |  2 ++
 virt/kvm/arm/vgic.c    | 24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index c0e6354..e789e47 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -356,6 +356,8 @@ int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
 struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 					   int virt_irq, int irq);
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
+bool kvm_vgic_get_phys_irq_active(struct irq_phys_map *map);
+void kvm_vgic_set_phys_irq_active(struct irq_phys_map *map, bool active);
 
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 9d009d2..b553a8f 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1802,6 +1802,30 @@ static void vgic_free_phys_irq_map_rcu(struct rcu_head *rcu)
 }
 
 /**
+ * kvm_vgic_get_phys_irq_active - Return the active state of a mapped IRQ
+ *
+ * Return the logical active state of a mapped interrupt. This doesn't
+ * necessarily reflects the current HW state.
+ */
+bool kvm_vgic_get_phys_irq_active(struct irq_phys_map *map)
+{
+	BUG_ON(!map);
+	return map->active;
+}
+
+/**
+ * kvm_vgic_set_phys_irq_active - Set the active state of a mapped IRQ
+ *
+ * Set the logical active state of a mapped interrupt. This doesn't
+ * immediately affects the HW state.
+ */
+void kvm_vgic_set_phys_irq_active(struct irq_phys_map *map, bool active)
+{
+	BUG_ON(!map);
+	map->active = active;
+}
+
+/**
  * kvm_vgic_unmap_phys_irq - Remove a virtual to physical IRQ mapping
  * @vcpu: The VCPU pointer
  * @map: The pointer to a mapping obtained through kvm_vgic_map_phys_irq
-- 
2.1.4

