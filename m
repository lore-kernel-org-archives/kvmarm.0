From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 05/54] KVM: arm/arm64: Remove the IRQ field from struct irq_phys_map
Date: Thu, 28 Apr 2016 17:45:24 +0100
Message-ID: <1461861973-26464-6-git-send-email-andre.przywara@arm.com>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

The communication of a Linux IRQ number from outside the VGIC to the
vgic was a leftover from the day when the vgic code cared about how a
particular device injects virtual interrupts mapped to a physical
interrupt.

We can safely remove this notion, leaving all physical IRQ handling to
be done in the device driver (the arch timer in this case), which makes
room for a saner API for the new VGIC.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@linaro.org>
---
Changelog v1 .. v2:
- update kerneldoc comments on kvm_vgic_map_phys_irq()

 include/kvm/arm_vgic.h    |  3 +--
 virt/kvm/arm/arch_timer.c | 22 ++++++++++++++++++++--
 virt/kvm/arm/vgic.c       | 28 ++++++----------------------
 3 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 43eeb18..49c559e 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -157,7 +157,6 @@ struct vgic_io_device {
 struct irq_phys_map {
 	u32			virt_irq;
 	u32			phys_irq;
-	u32			irq;
 };
 
 struct irq_phys_map_entry {
@@ -345,7 +344,7 @@ int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
 void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
-					   int virt_irq, int irq);
+					   int virt_irq, int phys_irq);
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq);
 bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
 
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 58b2439..b470632 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -301,7 +301,7 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	if (timer->active_cleared_last && !phys_active)
 		return;
 
-	ret = irq_set_irqchip_state(timer->map->irq,
+	ret = irq_set_irqchip_state(host_vtimer_irq,
 				    IRQCHIP_STATE_ACTIVE,
 				    phys_active);
 	WARN_ON(ret);
@@ -334,6 +334,9 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	struct irq_phys_map *map;
+	struct irq_desc *desc;
+	struct irq_data *data;
+	int phys_irq;
 
 	/*
 	 * The vcpu timer irq number cannot be determined in
@@ -353,10 +356,25 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 	kvm_timer_update_state(vcpu);
 
 	/*
+	 * Find the physical IRQ number corresponding to the host_vtimer_irq
+	 */
+	desc = irq_to_desc(host_vtimer_irq);
+	if (!desc) {
+		kvm_err("%s: no interrupt descriptor\n", __func__);
+		return -EINVAL;
+	}
+
+	data = irq_desc_get_irq_data(desc);
+	while (data->parent_data)
+		data = data->parent_data;
+
+	phys_irq = data->hwirq;
+
+	/*
 	 * Tell the VGIC that the virtual interrupt is tied to a
 	 * physical interrupt. We do that once per VCPU.
 	 */
-	map = kvm_vgic_map_phys_irq(vcpu, irq->irq, host_vtimer_irq);
+	map = kvm_vgic_map_phys_irq(vcpu, irq->irq, phys_irq);
 	if (WARN_ON(IS_ERR(map)))
 		return PTR_ERR(map);
 
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 2d7ae35..41792c0 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1712,38 +1712,24 @@ static struct list_head *vgic_get_irq_phys_map_list(struct kvm_vcpu *vcpu,
 /**
  * kvm_vgic_map_phys_irq - map a virtual IRQ to a physical IRQ
  * @vcpu: The VCPU pointer
- * @virt_irq: The virtual irq number
- * @irq: The Linux IRQ number
+ * @virt_irq: The virtual IRQ number for the guest
+ * @phys_irq: The hardware IRQ number of the host
  *
  * Establish a mapping between a guest visible irq (@virt_irq) and a
- * Linux irq (@irq). On injection, @virt_irq will be associated with
- * the physical interrupt represented by @irq. This mapping can be
+ * hardware irq (@phys_irq). On injection, @virt_irq will be associated with
+ * the physical interrupt represented by @phys_irq. This mapping can be
  * established multiple times as long as the parameters are the same.
  *
  * Returns a valid pointer on success, and an error pointer otherwise
  */
 struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
-					   int virt_irq, int irq)
+					   int virt_irq, int phys_irq)
 {
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	struct list_head *root = vgic_get_irq_phys_map_list(vcpu, virt_irq);
 	struct irq_phys_map *map;
 	struct irq_phys_map_entry *entry;
-	struct irq_desc *desc;
-	struct irq_data *data;
-	int phys_irq;
 
-	desc = irq_to_desc(irq);
-	if (!desc) {
-		kvm_err("%s: no interrupt descriptor\n", __func__);
-		return ERR_PTR(-EINVAL);
-	}
-
-	data = irq_desc_get_irq_data(desc);
-	while (data->parent_data)
-		data = data->parent_data;
-
-	phys_irq = data->hwirq;
 
 	/* Create a new mapping */
 	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
@@ -1756,8 +1742,7 @@ struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 	map = vgic_irq_map_search(vcpu, virt_irq);
 	if (map) {
 		/* Make sure this mapping matches */
-		if (map->phys_irq != phys_irq	||
-		    map->irq      != irq)
+		if (map->phys_irq != phys_irq)
 			map = ERR_PTR(-EINVAL);
 
 		/* Found an existing, valid mapping */
@@ -1767,7 +1752,6 @@ struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 	map           = &entry->map;
 	map->virt_irq = virt_irq;
 	map->phys_irq = phys_irq;
-	map->irq      = irq;
 
 	list_add_tail_rcu(&entry->entry, root);
 
-- 
2.7.3

