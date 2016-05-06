From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 02/55] KVM: arm/arm64: vgic: avoid map in kvm_vgic_inject_mapped_irq()
Date: Fri,  6 May 2016 11:45:15 +0100
Message-ID: <1462531568-9799-3-git-send-email-andre.przywara@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

When we want to inject a hardware mapped IRQ into a guest, we actually
only need the virtual IRQ number from the irq_phys_map.
So let's pass this number directly from the arch timer to the VGIC
to avoid using the map as a parameter.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@linaro.org>
---
 include/kvm/arm_vgic.h    | 2 +-
 virt/kvm/arm/arch_timer.c | 2 +-
 virt/kvm/arm/vgic.c       | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 281caf8..c4574da 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -341,7 +341,7 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
 			bool level);
 int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
-			       struct irq_phys_map *map, bool level);
+			       unsigned int virt_irq, bool level);
 void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 9aaa35d..ceec146 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -178,7 +178,7 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
 	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->map->virt_irq,
 				   timer->irq.level);
 	ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
-					 timer->map,
+					 timer->map->virt_irq,
 					 timer->irq.level);
 	WARN_ON(ret);
 }
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 7282881..9937d41 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1667,7 +1667,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
  * kvm_vgic_inject_mapped_irq - Inject a physically mapped IRQ to the vgic
  * @kvm:     The VM structure pointer
  * @cpuid:   The CPU for PPIs
- * @map:     Pointer to a irq_phys_map structure describing the mapping
+ * @virt_irq: The virtual IRQ to be injected
  * @level:   Edge-triggered:  true:  to trigger the interrupt
  *			      false: to ignore the call
  *	     Level-sensitive  true:  raise the input signal
@@ -1678,7 +1678,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
  * being HIGH and 0 being LOW and all devices being active-HIGH.
  */
 int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
-			       struct irq_phys_map *map, bool level)
+			       unsigned int virt_irq, bool level)
 {
 	int ret;
 
@@ -1686,7 +1686,7 @@ int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
 	if (ret)
 		return ret;
 
-	return vgic_update_irq_pending(kvm, cpuid, map->virt_irq, level);
+	return vgic_update_irq_pending(kvm, cpuid, virt_irq, level);
 }
 
 static irqreturn_t vgic_maintenance_handler(int irq, void *data)
-- 
2.7.3

