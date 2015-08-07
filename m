From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 11/11] KVM: arm/arm64: vgic: Allow HW interrupts for
 non-shared devices
Date: Fri,  7 Aug 2015 16:45:47 +0100
Message-ID: <1438962347-17541-12-git-send-email-marc.zyngier@arm.com>
References: <1438962347-17541-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD9365A4AD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Aug 2015 11:33:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A6sND5MmZS4l for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Aug 2015 11:33:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F42B5A498
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Aug 2015 11:33:16 -0400 (EDT)
In-Reply-To: <1438962347-17541-1-git-send-email-marc.zyngier@arm.com>
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
active state switching, and only track the deactivation of the
interrupt.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h    |  6 ++--
 virt/kvm/arm/arch_timer.c |  3 +-
 virt/kvm/arm/vgic.c       | 73 ++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 65 insertions(+), 17 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index d901f1a..7ef9ce0 100644
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
@@ -356,7 +357,8 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
 struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
-					   int virt_irq, int irq);
+					   int virt_irq, int irq,
+					   bool shared);
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
 bool kvm_vgic_get_phys_irq_active(struct irq_phys_map *map);
 void kvm_vgic_set_phys_irq_active(struct irq_phys_map *map, bool active);
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 76e38d2..db21d8f 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -203,7 +203,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 	 * Tell the VGIC that the virtual interrupt is tied to a
 	 * physical interrupt. We do that once per VCPU.
 	 */
-	map = kvm_vgic_map_phys_irq(vcpu, irq->irq, host_vtimer_irq);
+	map = kvm_vgic_map_phys_irq(vcpu, irq->irq,
+				    host_vtimer_irq, true);
 	if (WARN_ON(IS_ERR(map)))
 		return PTR_ERR(map);
 
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 9eb489a..3a3c06f5 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1150,19 +1150,25 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
 		 * active in the physical world. Otherwise the
 		 * physical interrupt will fire and the guest will
 		 * exit before processing the virtual interrupt.
+		 *
+		 * This is of course only valid for a shared
+		 * interrupt. A non shared interrupt should already be
+		 * active.
 		 */
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
-			WARN_ON(ret);
+			if (map->shared) {
+				int ret;
+
+				BUG_ON(!map->active);
+				ret = irq_set_irqchip_state(map->irq,
+							    IRQCHIP_STATE_ACTIVE,
+							    true);
+				WARN_ON(ret);
+			}
 
 			/*
 			 * Make sure we're not going to sample this
@@ -1405,21 +1411,42 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
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
+	 * For a non-shared interrupt, we have to cater for two
+	 * possible deactivation conditions:
+	 *
+	 * - the physical interrupt is now inactive (EOIed from the
+	 *   guest)
+	 * - the physical interrupt is still active, but its virtual
+	 *   counterpart is flagged as "not queued", indicating another
+	 *   interrupt has fired between the EOI and the guest exit.
+	 *
+	 * Also, we are not deactivating a non-shared interrupt
+	 * ourselves. This is always left to the guest, who solely own
+	 * the device.
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
@@ -1612,6 +1639,17 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 		goto out;
 	}
 
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
@@ -1742,16 +1780,21 @@ static struct list_head *vgic_get_irq_phys_map_list(struct kvm_vcpu *vcpu,
  * @vcpu: The VCPU pointer
  * @virt_irq: The virtual irq number
  * @irq: The Linux IRQ number
+ * @shared: Indicates if the interrupt has to be context-switched or
+ *          if it is private to a VM
  *
  * Establish a mapping between a guest visible irq (@virt_irq) and a
  * Linux irq (@irq). On injection, @virt_irq will be associated with
  * the physical interrupt represented by @irq. This mapping can be
  * established multiple times as long as the parameters are the same.
+ * If @shared is true, the active state of the interrupt will be
+ * context-switched.
  *
  * Returns a valid pointer on success, and an error pointer otherwise
  */
 struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
-					   int virt_irq, int irq)
+					   int virt_irq, int irq,
+					   bool shared)
 {
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	struct list_head *root = vgic_get_irq_phys_map_list(vcpu, virt_irq);
@@ -1785,7 +1828,8 @@ struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 	if (map) {
 		/* Make sure this mapping matches */
 		if (map->phys_irq != phys_irq	||
-		    map->irq      != irq)
+		    map->irq      != irq	||
+		    map->shared   != shared)
 			map = ERR_PTR(-EINVAL);
 
 		/* Found an existing, valid mapping */
@@ -1796,6 +1840,7 @@ struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 	map->virt_irq = virt_irq;
 	map->phys_irq = phys_irq;
 	map->irq      = irq;
+	map->shared   = shared;
 
 	list_add_tail_rcu(&entry->entry, root);
 
@@ -1846,7 +1891,7 @@ static void vgic_free_phys_irq_map_rcu(struct rcu_head *rcu)
  */
 bool kvm_vgic_get_phys_irq_active(struct irq_phys_map *map)
 {
-	BUG_ON(!map);
+	BUG_ON(!map || !map->shared);
 	return map->active;
 }
 
@@ -1858,7 +1903,7 @@ bool kvm_vgic_get_phys_irq_active(struct irq_phys_map *map)
  */
 void kvm_vgic_set_phys_irq_active(struct irq_phys_map *map, bool active)
 {
-	BUG_ON(!map);
+	BUG_ON(!map || !map->shared);
 	map->active = active;
 }
 
-- 
2.1.4
