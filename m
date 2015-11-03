From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v5 1/4] KVM: arm/arm64: Remove vgic_irq_lr_map
Date: Tue, 03 Nov 2015 11:34:05 +0300
Message-ID: <abde38cef368208668fd2a4ef90f77de52905fde.1446539212.git.p.fedin@samsung.com>
References: <cover.1446539212.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C062A498A4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2015 03:31:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GlbxUz6dqcCi for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Nov 2015 03:31:17 -0500 (EST)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E7DB49080
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2015 03:31:17 -0500 (EST)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NX8001HID54LPA0@mailout2.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 03 Nov 2015 08:34:16 +0000 (GMT)
In-reply-to: <cover.1446539212.git.p.fedin@samsung.com>
In-reply-to: <cover.1446539212.git.p.fedin@samsung.com>
References: <cover.1446539212.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Currently we use vgic_irq_lr_map in order to track which LRs hold which
IRQs, and lr_used bitmap in order to track which LRs are used or free.

vgic_irq_lr_map is actually used only in one place for piggy-back
optimization, and can be easily replaced by iteration over lr_used.
Therefore we remove it in order to get prepared for LPI support
introduction. After this number of IRQs will grow up to at least 16384,
while numbers from 1024 to 8192 are never going to be used. This would be
a huge memory waste.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 include/kvm/arm_vgic.h |  3 ---
 virt/kvm/arm/vgic.c    | 18 +++---------------
 2 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 8065801..c74dc7b 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -295,9 +295,6 @@ struct vgic_v3_cpu_if {
 };
 
 struct vgic_cpu {
-	/* per IRQ to LR mapping */
-	u8		*vgic_irq_lr_map;
-
 	/* Pending/active/both interrupts on this VCPU */
 	DECLARE_BITMAP(pending_percpu, VGIC_NR_PRIVATE_IRQS);
 	DECLARE_BITMAP(active_percpu, VGIC_NR_PRIVATE_IRQS);
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index d4669eb..54233e0 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1113,7 +1113,6 @@ static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu)
 	vlr.state = 0;
 	vgic_set_lr(vcpu, lr_nr, vlr);
 	clear_bit(lr_nr, vgic_cpu->lr_used);
-	vgic_cpu->vgic_irq_lr_map[irq] = LR_EMPTY;
 	vgic_sync_lr_elrsr(vcpu, lr_nr, vlr);
 }
 
@@ -1200,14 +1199,11 @@ bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
 
 	kvm_debug("Queue IRQ%d\n", irq);
 
-	lr = vgic_cpu->vgic_irq_lr_map[irq];
-
 	/* Do we have an active interrupt for the same CPUID? */
-	if (lr != LR_EMPTY) {
+	for_each_set_bit(lr, vgic_cpu->lr_used, vgic_cpu->nr_lr) {
 		vlr = vgic_get_lr(vcpu, lr);
-		if (vlr.source == sgi_source_id) {
+		if (vlr.irq == irq && vlr.source == sgi_source_id) {
 			kvm_debug("LR%d piggyback for IRQ%d\n", lr, vlr.irq);
-			BUG_ON(!test_bit(lr, vgic_cpu->lr_used));
 			vgic_queue_irq_to_lr(vcpu, irq, lr, vlr);
 			return true;
 		}
@@ -1220,7 +1216,6 @@ bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
 		return false;
 
 	kvm_debug("LR%d allocated for IRQ%d %x\n", lr, irq, sgi_source_id);
-	vgic_cpu->vgic_irq_lr_map[irq] = lr;
 	set_bit(lr, vgic_cpu->lr_used);
 
 	vlr.irq = irq;
@@ -1484,7 +1479,6 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 		clear_bit(lr, vgic_cpu->lr_used);
 
 		BUG_ON(vlr.irq >= dist->nr_irqs);
-		vgic_cpu->vgic_irq_lr_map[vlr.irq] = LR_EMPTY;
 	}
 
 	/* Check if we still have something up our sleeve... */
@@ -1912,12 +1906,10 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kfree(vgic_cpu->pending_shared);
 	kfree(vgic_cpu->active_shared);
 	kfree(vgic_cpu->pend_act_shared);
-	kfree(vgic_cpu->vgic_irq_lr_map);
 	vgic_destroy_irq_phys_map(vcpu->kvm, &vgic_cpu->irq_phys_map_list);
 	vgic_cpu->pending_shared = NULL;
 	vgic_cpu->active_shared = NULL;
 	vgic_cpu->pend_act_shared = NULL;
-	vgic_cpu->vgic_irq_lr_map = NULL;
 }
 
 static int vgic_vcpu_init_maps(struct kvm_vcpu *vcpu, int nr_irqs)
@@ -1928,18 +1920,14 @@ static int vgic_vcpu_init_maps(struct kvm_vcpu *vcpu, int nr_irqs)
 	vgic_cpu->pending_shared = kzalloc(sz, GFP_KERNEL);
 	vgic_cpu->active_shared = kzalloc(sz, GFP_KERNEL);
 	vgic_cpu->pend_act_shared = kzalloc(sz, GFP_KERNEL);
-	vgic_cpu->vgic_irq_lr_map = kmalloc(nr_irqs, GFP_KERNEL);
 
 	if (!vgic_cpu->pending_shared
 		|| !vgic_cpu->active_shared
-		|| !vgic_cpu->pend_act_shared
-		|| !vgic_cpu->vgic_irq_lr_map) {
+		|| !vgic_cpu->pend_act_shared) {
 		kvm_vgic_vcpu_destroy(vcpu);
 		return -ENOMEM;
 	}
 
-	memset(vgic_cpu->vgic_irq_lr_map, LR_EMPTY, nr_irqs);
-
 	/*
 	 * Store the number of LRs per vcpu, so we don't have to go
 	 * all the way to the distributor structure to find out. Only
-- 
2.4.4
