From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 07/10] KVM: arm/arm64: vgic: Allow HW interrupts to be
 queued to a guest
Date: Wed,  8 Jul 2015 18:56:39 +0100
Message-ID: <1436378202-20224-8-git-send-email-marc.zyngier@arm.com>
References: <1436378202-20224-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D890C581EC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 13:45:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5LB4RmGEixfD for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jul 2015 13:45:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF37C581A3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 13:45:26 -0400 (EDT)
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

To allow a HW interrupt to be injected into a guest, we lookup the
guest virtual interrupt in the irq_phys_map rbtree, and if we have
a match, encode both interrupts in the LR.

We also mark the interrupt as "active" at the host distributor level.

On guest EOI on the virtual interrupt, the host interrupt will be
deactivated.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 69 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 3424329..f8582d7 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1118,6 +1118,26 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
 	if (!vgic_irq_is_edge(vcpu, irq))
 		vlr.state |= LR_EOI_INT;
 
+	if (vlr.irq >= VGIC_NR_SGIS) {
+		struct irq_phys_map *map;
+		map = vgic_irq_map_search(vcpu, irq);
+
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
+			vgic_irq_set_queued(vcpu, irq);
+			WARN_ON(ret);
+		}
+	}
+
 	vgic_set_lr(vcpu, lr_nr, vlr);
 	vgic_sync_lr_elrsr(vcpu, lr_nr, vlr);
 }
@@ -1342,6 +1362,35 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 	return level_pending;
 }
 
+/* Return 1 if HW interrupt went from active to inactive, and 0 otherwise */
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
@@ -1356,14 +1405,31 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
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
+			 * interrupt to be queued again.
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
