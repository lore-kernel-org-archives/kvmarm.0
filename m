From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 3/7] KVM: arm/arm64: directly pass virtual IRQ number on kvm_vgic_map_is_active()
Date: Fri, 15 Apr 2016 15:04:03 +0100
Message-ID: <1460729047-6346-4-git-send-email-andre.przywara@arm.com>
References: <1460729047-6346-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1460729047-6346-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

For getting the active state of a mapped IRQ, we actually only need
the virtual IRQ number, not the pointer to the mapping entry.
Pass the virtual IRQ number from the arch timer to the VGIC directly.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/arm_vgic.h    | 2 +-
 virt/kvm/arm/arch_timer.c | 2 +-
 virt/kvm/arm/vgic.c       | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index c4574da..5a34adc 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -347,7 +347,7 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 					   int virt_irq, int irq);
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
-bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
+bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
 
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index eb56f1e..793465b 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -246,7 +246,7 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	* to ensure that hardware interrupts from the timer triggers a guest
 	* exit.
 	*/
-	if (timer->irq.level || kvm_vgic_map_is_active(vcpu, timer->map))
+	if (timer->irq.level || kvm_vgic_map_is_active(vcpu, timer->map->virt_irq))
 		phys_active = true;
 	else
 		phys_active = false;
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 9937d41..6911327 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1103,18 +1103,18 @@ static bool dist_active_irq(struct kvm_vcpu *vcpu)
 	return test_bit(vcpu->vcpu_id, dist->irq_active_on_cpu);
 }
 
-bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, struct irq_phys_map *map)
+bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
 {
 	int i;
 
 	for (i = 0; i < vcpu->arch.vgic_cpu.nr_lr; i++) {
 		struct vgic_lr vlr = vgic_get_lr(vcpu, i);
 
-		if (vlr.irq == map->virt_irq && vlr.state & LR_STATE_ACTIVE)
+		if (vlr.irq == virt_irq && vlr.state & LR_STATE_ACTIVE)
 			return true;
 	}
 
-	return vgic_irq_is_active(vcpu, map->virt_irq);
+	return vgic_irq_is_active(vcpu, virt_irq);
 }
 
 /*
-- 
2.7.3

