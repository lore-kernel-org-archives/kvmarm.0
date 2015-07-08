From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 10/10] KVM: arm/arm64: vgic: Allow non-shared device HW
 interrupts
Date: Wed,  8 Jul 2015 18:56:42 +0100
Message-ID: <1436378202-20224-11-git-send-email-marc.zyngier@arm.com>
References: <1436378202-20224-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0283658205
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 13:45:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RJkNiQ4X8szS for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jul 2015 13:45:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45B5A581EF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 13:45:31 -0400 (EDT)
In-Reply-To: <1436378202-20224-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andre Przywara <andre.przywara@arm.com>
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
 include/kvm/arm_vgic.h    |  5 ++--
 virt/kvm/arm/arch_timer.c |  2 +-
 virt/kvm/arm/vgic.c       | 62 ++++++++++++++++++++++++++++++++++++-----------
 3 files changed, 52 insertions(+), 17 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 9fd4023..31c987a 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -163,7 +163,8 @@ struct irq_phys_map {
 	u32			virt_irq;
 	u32			phys_irq;
 	u32			irq;
-	bool			active;
+	bool			shared;
+	bool			active; /* Only valid if shared */
 };
 
 struct irq_phys_map_entry {
@@ -354,7 +355,7 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
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
index 39f9479..3585bb0 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1123,18 +1123,21 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
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
 
@@ -1366,21 +1369,37 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
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
+	/*
+	 * For a non-shared interrupt, we have to catter for two
+	 * possible deactivation conditions
+	 *
+	 * - the interrupt is now inactive
+	 * - the interrupt is still active, but is flagged as not
+	 *   queued, indicating another interrupt has fired before we
+	 *   could observe the deactivate.
+	 */
+	if (!map->shared)
+		return !active || !vgic_irq_is_queued(vcpu, vlr.irq);
+
+	map->active = active;
+
+	if (active) {
 		ret = irq_set_irqchip_state(map->irq,
 					    IRQCHIP_STATE_ACTIVE,
 					    false);
@@ -1523,6 +1542,7 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 	int edge_triggered, level_triggered;
 	int enabled;
 	bool ret = true, can_inject = true;
+	struct irq_phys_map *map;
 
 	spin_lock(&dist->lock);
 
@@ -1569,6 +1589,18 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 		goto out;
 	}
 
+	map = vgic_irq_map_search(vcpu, irq_num);
+	if (map && !map->shared) {
+		/*
+		 * We are told to inject a HW irq, so we have to trust
+		 * the caller that the previous one has been EOIed,
+		 * and that a new one is now active. Clearing the
+		 * queued state will have the effect of making it
+		 * sample-able again.
+		 */
+		vgic_irq_clear_queued(vcpu, irq_num);
+	}
+
 	if (!vgic_can_sample_irq(vcpu, irq_num)) {
 		/*
 		 * Level interrupt in progress, will be picked up
@@ -1662,7 +1694,7 @@ static struct list_head *vgic_get_irq_phys_map(struct kvm_vcpu *vcpu,
 }
 
 struct irq_phys_map *vgic_map_phys_irq(struct kvm_vcpu *vcpu,
-				       int virt_irq, int irq)
+				       int virt_irq, int irq, bool shared)
 {
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	struct list_head *root = vgic_get_irq_phys_map(vcpu, virt_irq);
@@ -1691,7 +1723,8 @@ struct irq_phys_map *vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 	if (map) {
 		/* Make sure this mapping matches */
 		if (map->phys_irq != phys_irq	||
-		    map->irq      != irq)
+		    map->irq      != irq	||
+		    map->shared   != shared)
 			map = NULL;
 
 		goto out;
@@ -1706,6 +1739,7 @@ struct irq_phys_map *vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 	map->virt_irq = virt_irq;
 	map->phys_irq = phys_irq;
 	map->irq      = irq;
+	map->shared   = shared;
 
 	list_add_tail_rcu(&entry->entry, root);
 
@@ -1746,13 +1780,13 @@ static void vgic_free_phys_irq_map_rcu(struct rcu_head *rcu)
 
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
