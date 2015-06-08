From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 10/10] KVM: arm/arm64: vgic: Allow non-shared device HW interrupts
Date: Mon,  8 Jun 2015 18:04:05 +0100
Message-ID: <1433783045-8002-11-git-send-email-marc.zyngier@arm.com>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

So far, the only use of the HW interrupt facility is the timer,
implying that the active state is context-switched for each vcpu,
as the device is is shared across all vcpus.

This does not work for a device that has been assigned to a VM,
as the guest is entierely in control of that device (the HW is
not shared). In that case, it makes sense to bypass the whole
active state switchint, and only track the deactivation of the
interrupt.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h    |  5 +++--
 virt/kvm/arm/arch_timer.c |  2 +-
 virt/kvm/arm/vgic.c       | 37 ++++++++++++++++++++++++-------------
 3 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 1c653c1..5d47d60 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -164,7 +164,8 @@ struct irq_phys_map {
 	u32			virt_irq;
 	u32			phys_irq;
 	u32			irq;
-	bool			active;
+	bool			shared;
+	bool			active; /* Only valid if shared */
 };
 
 struct vgic_dist {
@@ -347,7 +348,7 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
 struct irq_phys_map *vgic_map_phys_irq(struct kvm_vcpu *vcpu,
-				       int virt_irq, int irq);
+				       int virt_irq, int irq, bool shared);
 int vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
 bool vgic_get_phys_irq_active(struct irq_phys_map *map);
 void vgic_set_phys_irq_active(struct irq_phys_map *map, bool active);
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index b9fff78..9544d79 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -202,7 +202,7 @@ void kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 	 * Tell the VGIC that the virtual interrupt is tied to a
 	 * physical interrupt. We do that once per VCPU.
 	 */
-	timer->map = vgic_map_phys_irq(vcpu, irq->irq, host_vtimer_irq);
+	timer->map = vgic_map_phys_irq(vcpu, irq->irq, host_vtimer_irq, true);
 	WARN_ON(!timer->map);
 }
 
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index f376b56..4223166 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1125,18 +1125,21 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
 		map = vgic_irq_map_search(vcpu, irq);
 
 		if (map) {
-			int ret;
-
-			BUG_ON(!map->active);
 			vlr.hwirq = map->phys_irq;
 			vlr.state |= LR_HW;
 			vlr.state &= ~LR_EOI_INT;
 
-			ret = irq_set_irqchip_state(map->irq,
-						    IRQCHIP_STATE_ACTIVE,
-						    true);
 			vgic_irq_set_queued(vcpu, irq);
-			WARN_ON(ret);
+
+			if (map->shared) {
+				int ret;
+
+				BUG_ON(!map->active);
+				ret = irq_set_irqchip_state(map->irq,
+							    IRQCHIP_STATE_ACTIVE,
+							    true);
+				WARN_ON(ret);
+			}
 		}
 	}
 
@@ -1368,21 +1371,28 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 static int vgic_sync_hwirq(struct kvm_vcpu *vcpu, struct vgic_lr vlr)
 {
 	struct irq_phys_map *map;
+	bool active;
 	int ret;
 
 	if (!(vlr.state & LR_HW))
 		return 0;
 
 	map = vgic_irq_map_search(vcpu, vlr.irq);
-	BUG_ON(!map || !map->active);
+	BUG_ON(!map);
+	BUG_ON(map->shared && !map->active);
 
 	ret = irq_get_irqchip_state(map->irq,
 				    IRQCHIP_STATE_ACTIVE,
-				    &map->active);
+				    &active);
 
 	WARN_ON(ret);
 
-	if (map->active) {
+	if (!map->shared)
+		return !active;
+
+	map->active = active;
+
+	if (active) {
 		ret = irq_set_irqchip_state(map->irq,
 					    IRQCHIP_STATE_ACTIVE,
 					    false);
@@ -1663,7 +1673,7 @@ static struct rb_root *vgic_get_irq_phys_map(struct kvm_vcpu *vcpu,
 }
 
 struct irq_phys_map *vgic_map_phys_irq(struct kvm_vcpu *vcpu,
-				       int virt_irq, int irq)
+				       int virt_irq, int irq, bool shared)
 {
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	struct rb_root *root = vgic_get_irq_phys_map(vcpu, virt_irq);
@@ -1710,6 +1720,7 @@ struct irq_phys_map *vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 	new_map->virt_irq = virt_irq;
 	new_map->phys_irq = phys_irq;
 	new_map->irq = irq;
+	new_map->shared = shared;
 
 	rb_link_node(&new_map->node, parent, new);
 	rb_insert_color(&new_map->node, root);
@@ -1746,13 +1757,13 @@ static struct irq_phys_map *vgic_irq_map_search(struct kvm_vcpu *vcpu,
 
 bool vgic_get_phys_irq_active(struct irq_phys_map *map)
 {
-	BUG_ON(!map);
+	BUG_ON(!map || !map->shared);
 	return map->active;
 }
 
 void vgic_set_phys_irq_active(struct irq_phys_map *map, bool active)
 {
-	BUG_ON(!map);
+	BUG_ON(!map || !map->shared);
 	map->active = active;
 }
 
-- 
2.1.4

