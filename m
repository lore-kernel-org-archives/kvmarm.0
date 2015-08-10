From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v3 07/10] KVM: arm/arm64: vgic: Allow HW interrupts for
 non-shared devices
Date: Mon, 10 Aug 2015 15:21:01 +0200
Message-ID: <1439212864-12954-8-git-send-email-eric.auger@linaro.org>
References: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B9DAD5A6B1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:09:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DzWW3PdaNa5B for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Aug 2015 09:09:02 -0400 (EDT)
Received: from mail-wi0-f180.google.com (mail-wi0-f180.google.com
 [209.85.212.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B4C55A6A9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:09:02 -0400 (EDT)
Received: by wicne3 with SMTP id ne3so21959887wic.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 06:22:03 -0700 (PDT)
In-Reply-To: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, feng.wu@intel.com
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

So far, the only use of the HW interrupt facility was the timer,
implying that the active state is context-switched for each vcpu,
as the device is is shared across all vcpus.

This does not work for a device that has been assigned to a VM,
as the guest is entierely in control of that device (the HW is
not shared). In that case, it makes sense to bypass the whole
active state switching.

Also the VGIC state machine is adapted to support those assigned
(non shared) HW IRQs:
- nly can be sampled when it is pending
- when queueing the IRQ (programming the LR), the pending state is
  removed as for edge sensitive IRQs
- queued state is not modelled. Level state is not modelled
- its injection always is valid since steming from the HW.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

- a mix of
  [PATCH v4 11/11] KVM: arm/arm64: vgic: Allow HW interrupts for
                   non-shared devices
  [RFC v2 2/4] KVM: arm: vgic: fix state machine for forwarded IRQ
---
 include/kvm/arm_vgic.h    |  6 +++--
 virt/kvm/arm/arch_timer.c |  3 ++-
 virt/kvm/arm/vgic.c       | 58 +++++++++++++++++++++++++++++++++++------------
 3 files changed, 49 insertions(+), 18 deletions(-)

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
index 9eb489a..fbd5ba5 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -400,7 +400,11 @@ void vgic_cpu_irq_clear(struct kvm_vcpu *vcpu, int irq)
 
 static bool vgic_can_sample_irq(struct kvm_vcpu *vcpu, int irq)
 {
-	return !vgic_irq_is_queued(vcpu, irq);
+	struct irq_phys_map *map = vgic_irq_map_search(vcpu, irq);
+	bool shared_hw = map && !map->shared;
+
+	return !vgic_irq_is_queued(vcpu, irq) ||
+			(shared_hw && vgic_dist_irq_is_pending(vcpu, irq));
 }
 
 /**
@@ -1150,19 +1154,26 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
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
+				ret = irq_set_irqchip_state(
+						map->irq,
+						IRQCHIP_STATE_ACTIVE,
+						true);
+				WARN_ON(ret);
+			}
 
 			/*
 			 * Make sure we're not going to sample this
@@ -1229,10 +1240,13 @@ bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
 
 static bool vgic_queue_hwirq(struct kvm_vcpu *vcpu, int irq)
 {
+	struct irq_phys_map *map = vgic_irq_map_search(vcpu, irq);
+	bool shared_hw = map && !map->shared;
+
 	if (!vgic_can_sample_irq(vcpu, irq))
 		return true; /* level interrupt, already queued */
 
-	if (vgic_queue_irq(vcpu, 0, irq)) {
+	if (vgic_queue_irq(vcpu, 0, irq) || shared_hw) {
 		if (vgic_irq_is_edge(vcpu, irq)) {
 			vgic_dist_irq_clear_pending(vcpu, irq);
 			vgic_cpu_irq_clear(vcpu, irq);
@@ -1411,7 +1425,12 @@ static int vgic_sync_hwirq(struct kvm_vcpu *vcpu, struct vgic_lr vlr)
 		return 0;
 
 	map = vgic_irq_map_search(vcpu, vlr.irq);
-	BUG_ON(!map || !map->active);
+	BUG_ON(!map);
+
+	if (!map->shared)
+		return 0;
+
+	BUG_ON(map->shared && !map->active);
 
 	ret = irq_get_irqchip_state(map->irq,
 				    IRQCHIP_STATE_ACTIVE,
@@ -1563,6 +1582,7 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 	int edge_triggered, level_triggered;
 	int enabled;
 	bool ret = true, can_inject = true;
+	bool shared_hw = map && !map->shared;
 
 	if (irq_num >= min(kvm->arch.vgic.nr_irqs, 1020))
 		return -EINVAL;
@@ -1573,7 +1593,8 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 	edge_triggered = vgic_irq_is_edge(vcpu, irq_num);
 	level_triggered = !edge_triggered;
 
-	if (!vgic_validate_injection(vcpu, irq_num, level)) {
+	if (!vgic_validate_injection(vcpu, irq_num, level) &&
+		!shared_hw) {
 		ret = false;
 		goto out;
 	}
@@ -1742,16 +1763,21 @@ static struct list_head *vgic_get_irq_phys_map_list(struct kvm_vcpu *vcpu,
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
@@ -1785,7 +1811,8 @@ struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 	if (map) {
 		/* Make sure this mapping matches */
 		if (map->phys_irq != phys_irq	||
-		    map->irq      != irq)
+		    map->irq      != irq	||
+		    map->shared   != shared)
 			map = ERR_PTR(-EINVAL);
 
 		/* Found an existing, valid mapping */
@@ -1796,6 +1823,7 @@ struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 	map->virt_irq = virt_irq;
 	map->phys_irq = phys_irq;
 	map->irq      = irq;
+	map->shared   = shared;
 
 	list_add_tail_rcu(&entry->entry, root);
 
@@ -1846,7 +1874,7 @@ static void vgic_free_phys_irq_map_rcu(struct rcu_head *rcu)
  */
 bool kvm_vgic_get_phys_irq_active(struct irq_phys_map *map)
 {
-	BUG_ON(!map);
+	BUG_ON(!map || !map->shared);
 	return map->active;
 }
 
@@ -1858,7 +1886,7 @@ bool kvm_vgic_get_phys_irq_active(struct irq_phys_map *map)
  */
 void kvm_vgic_set_phys_irq_active(struct irq_phys_map *map, bool active)
 {
-	BUG_ON(!map);
+	BUG_ON(!map || !map->shared);
 	map->active = active;
 }
 
-- 
1.9.1
