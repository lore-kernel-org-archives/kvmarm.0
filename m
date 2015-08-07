From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 07/11] KVM: arm/arm64: vgic: Allow HW interrupts to be
 queued to a guest
Date: Fri,  7 Aug 2015 16:45:43 +0100
Message-ID: <1438962347-17541-8-git-send-email-marc.zyngier@arm.com>
References: <1438962347-17541-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC30C5A469
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Aug 2015 11:33:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2Fe+yNwvWZmr for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Aug 2015 11:33:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FF7E5A48C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Aug 2015 11:33:10 -0400 (EDT)
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

To allow a HW interrupt to be injected into a guest, we lookup the
guest virtual interrupt in the irq_phys_map list, and if we have
a match, encode both interrupts in the LR.

We also mark the interrupt as "active" at the host distributor level.

On guest EOI on the virtual interrupt, the host interrupt will be
deactivated.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic.c | 89 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 86 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 51c9900..9d009d2 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1140,6 +1140,39 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
 	if (!vgic_irq_is_edge(vcpu, irq))
 		vlr.state |= LR_EOI_INT;
 
+	if (vlr.irq >= VGIC_NR_SGIS) {
+		struct irq_phys_map *map;
+		map = vgic_irq_map_search(vcpu, irq);
+
+		/*
+		 * If we have a mapping, and the virtual interrupt is
+		 * being injected, then we must set the state to
+		 * active in the physical world. Otherwise the
+		 * physical interrupt will fire and the guest will
+		 * exit before processing the virtual interrupt.
+		 */
+		if (map) {
+			int ret;
+
+			BUG_ON(!map->active);
+			vlr.hwirq = map->phys_irq;
+			vlr.state |= LR_HW;
+			vlr.state &= ~LR_EOI_INT;
+
+			ret = irq_set_irqchip_state(map->irq,
+						    IRQCHIP_STATE_ACTIVE,
+						    true);
+			WARN_ON(ret);
+
+			/*
+			 * Make sure we're not going to sample this
+			 * again, as a HW-backed interrupt cannot be
+			 * in the PENDING_ACTIVE stage.
+			 */
+			vgic_irq_set_queued(vcpu, irq);
+		}
+	}
+
 	vgic_set_lr(vcpu, lr_nr, vlr);
 	vgic_sync_lr_elrsr(vcpu, lr_nr, vlr);
 }
@@ -1364,6 +1397,39 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 	return level_pending;
 }
 
+/*
+ * Save the physical active state, and reset it to inactive.
+ *
+ * Return 1 if HW interrupt went from active to inactive, and 0 otherwise.
+ */
+static int vgic_sync_hwirq(struct kvm_vcpu *vcpu, struct vgic_lr vlr)
+{
+	struct irq_phys_map *map;
+	int ret;
+
+	if (!(vlr.state & LR_HW))
+		return 0;
+
+	map = vgic_irq_map_search(vcpu, vlr.irq);
+	BUG_ON(!map || !map->active);
+
+	ret = irq_get_irqchip_state(map->irq,
+				    IRQCHIP_STATE_ACTIVE,
+				    &map->active);
+
+	WARN_ON(ret);
+
+	if (map->active) {
+		ret = irq_set_irqchip_state(map->irq,
+					    IRQCHIP_STATE_ACTIVE,
+					    false);
+		WARN_ON(ret);
+		return 0;
+	}
+
+	return 1;
+}
+
 /* Sync back the VGIC state after a guest run */
 static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
@@ -1378,14 +1444,31 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 	elrsr = vgic_get_elrsr(vcpu);
 	elrsr_ptr = u64_to_bitmask(&elrsr);
 
-	/* Clear mappings for empty LRs */
-	for_each_set_bit(lr, elrsr_ptr, vgic->nr_lr) {
+	/* Deal with HW interrupts, and clear mappings for empty LRs */
+	for (lr = 0; lr < vgic->nr_lr; lr++) {
 		struct vgic_lr vlr;
 
-		if (!test_and_clear_bit(lr, vgic_cpu->lr_used))
+		if (!test_bit(lr, vgic_cpu->lr_used))
 			continue;
 
 		vlr = vgic_get_lr(vcpu, lr);
+		if (vgic_sync_hwirq(vcpu, vlr)) {
+			/*
+			 * So this is a HW interrupt that the guest
+			 * EOI-ed. Clean the LR state and allow the
+			 * interrupt to be sampled again.
+			 */
+			vlr.state = 0;
+			vlr.hwirq = 0;
+			vgic_set_lr(vcpu, lr, vlr);
+			vgic_irq_clear_queued(vcpu, vlr.irq);
+			set_bit(lr, elrsr_ptr);
+		}
+
+		if (!test_bit(lr, elrsr_ptr))
+			continue;
+
+		clear_bit(lr, vgic_cpu->lr_used);
 
 		BUG_ON(vlr.irq >= dist->nr_irqs);
 		vgic_cpu->vgic_irq_lr_map[vlr.irq] = LR_EMPTY;
-- 
2.1.4
