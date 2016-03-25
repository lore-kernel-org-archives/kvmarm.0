From: Andre Przywara <andre.przywara@arm.com>
Subject: [RFC PATCH 03/45] KVM: arm/arm64: arch_timer: rework VGIC <-> timer interface
Date: Fri, 25 Mar 2016 02:04:26 +0000
Message-ID: <1458871508-17279-4-git-send-email-andre.przywara@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Adapt the interface between the virtualized arch timer and the
emulated VGIC to avoid the phys_map when possible.
This prepares the arch timer to go with both the existing VGIC
implementation and the new version later without too many code
changes.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/arm_vgic.h    |  7 ++++---
 virt/kvm/arm/arch_timer.c | 11 +++++------
 virt/kvm/arm/vgic.c       | 18 +++++++++---------
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 2b89e27..7656a46 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -345,13 +345,14 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
 			bool level);
 int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
-			       struct irq_phys_map *map, bool level);
+			       int virt_irq, bool level);
 void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 					   int virt_irq, int irq);
-int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
-bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
+int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map,
+			    int virt_irq);
+bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, int virt_irq);
 
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index a9ad4fe..74e3d4b 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -137,10 +137,10 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
 
 	timer->active_cleared_last = false;
 	timer->irq.level = new_level;
-	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->map->virt_irq,
+	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->irq.irq,
 				   timer->irq.level);
 	ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
-					 timer->map,
+					 timer->irq.irq,
 					 timer->irq.level);
 	WARN_ON(ret);
 }
@@ -246,7 +246,7 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	* to ensure that hardware interrupts from the timer triggers a guest
 	* exit.
 	*/
-	if (timer->irq.level || kvm_vgic_map_is_active(vcpu, timer->map))
+	if (timer->irq.level || kvm_vgic_map_is_active(vcpu, timer->irq.irq))
 		phys_active = true;
 	else
 		phys_active = false;
@@ -274,7 +274,7 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	if (timer->active_cleared_last && !phys_active)
 		return;
 
-	ret = irq_set_irqchip_state(timer->map->irq,
+	ret = irq_set_irqchip_state(host_vtimer_irq,
 				    IRQCHIP_STATE_ACTIVE,
 				    phys_active);
 	WARN_ON(ret);
@@ -476,8 +476,7 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 
 	timer_disarm(timer);
-	if (timer->map)
-		kvm_vgic_unmap_phys_irq(vcpu, timer->map);
+	kvm_vgic_unmap_phys_irq(vcpu, timer->map, timer->irq.irq);
 }
 
 void kvm_timer_enable(struct kvm *kvm)
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 00429b3..079b0a7 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1103,18 +1103,18 @@ static bool dist_active_irq(struct kvm_vcpu *vcpu)
 	return test_bit(vcpu->vcpu_id, dist->irq_active_on_cpu);
 }
 
-bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, struct irq_phys_map *map)
+bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, int virt_irq)
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
@@ -1522,7 +1522,6 @@ static int vgic_validate_injection(struct kvm_vcpu *vcpu, int irq, int level)
 }
 
 static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
-				   struct irq_phys_map *map,
 				   unsigned int irq_num, bool level)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
@@ -1661,14 +1660,14 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
 	if (map)
 		return -EINVAL;
 
-	return vgic_update_irq_pending(kvm, cpuid, NULL, irq_num, level);
+	return vgic_update_irq_pending(kvm, cpuid, irq_num, level);
 }
 
 /**
  * kvm_vgic_inject_mapped_irq - Inject a physically mapped IRQ to the vgic
  * @kvm:     The VM structure pointer
  * @cpuid:   The CPU for PPIs
- * @map:     Pointer to a irq_phys_map structure describing the mapping
+ * @virt_irq: The virtual IRQ to be injected
  * @level:   Edge-triggered:  true:  to trigger the interrupt
  *			      false: to ignore the call
  *	     Level-sensitive  true:  raise the input signal
@@ -1679,7 +1678,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
  * being HIGH and 0 being LOW and all devices being active-HIGH.
  */
 int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
-			       struct irq_phys_map *map, bool level)
+			       int virt_irq, bool level)
 {
 	int ret;
 
@@ -1687,7 +1686,7 @@ int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
 	if (ret)
 		return ret;
 
-	return vgic_update_irq_pending(kvm, cpuid, map, map->virt_irq, level);
+	return vgic_update_irq_pending(kvm, cpuid, virt_irq, level);
 }
 
 static irqreturn_t vgic_maintenance_handler(int irq, void *data)
@@ -1818,7 +1817,8 @@ static void vgic_free_phys_irq_map_rcu(struct rcu_head *rcu)
  *
  * Remove an existing mapping between virtual and physical interrupts.
  */
-int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map)
+int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map,
+			    int virt_irq)
 {
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	struct irq_phys_map_entry *entry;
-- 
2.7.3

