From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 46/59] KVM: arm/arm64: GICv4: Handle MOVALL applied to a vPE
Date: Mon, 31 Jul 2017 18:26:24 +0100
Message-ID: <20170731172637.29355-47-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 205A049C13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:27:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8ITXR8PXz8MU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Jul 2017 13:27:15 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A9BB49C5B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:27:14 -0400 (EDT)
In-Reply-To: <20170731172637.29355-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

The current implementation of MOVALL doesn't allow us to call
into the core ITS code as we hold a number of spinlocks.

Let's try a method used in other parts of the code, were we copy
the intids of the candicate interrupts, and then do whatever
we need to do with them outside of the critical section.

This allows us to move the interrupts one by one, at the expense
of a bit of CPU time. Who cares? MOVALL is such a stupid command
anyway...

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 2c065c970ba0..65cc77fde609 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1147,11 +1147,12 @@ static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
 static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 				      u64 *its_cmd)
 {
-	struct vgic_dist *dist = &kvm->arch.vgic;
 	u32 target1_addr = its_cmd_get_target_addr(its_cmd);
 	u32 target2_addr = its_cmd_mask_field(its_cmd, 3, 16, 32);
 	struct kvm_vcpu *vcpu1, *vcpu2;
 	struct vgic_irq *irq;
+	u32 *intids;
+	int irq_count, i;
 
 	if (target1_addr >= atomic_read(&kvm->online_vcpus) ||
 	    target2_addr >= atomic_read(&kvm->online_vcpus))
@@ -1163,19 +1164,31 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 	vcpu1 = kvm_get_vcpu(kvm, target1_addr);
 	vcpu2 = kvm_get_vcpu(kvm, target2_addr);
 
-	spin_lock(&dist->lpi_list_lock);
+	irq_count = vgic_copy_lpi_list(vcpu1, &intids);
+	if (irq_count < 0)
+		return irq_count;
 
-	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
-		spin_lock(&irq->irq_lock);
+	for (i = 0; i < irq_count; i++) {
+		irq = vgic_get_irq(kvm, NULL, intids[i]);
+		if (!irq)
+			continue;
 
 		if (irq->target_vcpu == vcpu1)
 			irq->target_vcpu = vcpu2;
 
-		spin_unlock(&irq->irq_lock);
-	}
+		if (irq->hw) {
+			struct its_vlpi_map map;
 
-	spin_unlock(&dist->lpi_list_lock);
+			if (!its_get_vlpi(irq->host_irq, &map)) {
+				map.vpe_idx = vcpu2->vcpu_id;
+				its_map_vlpi(irq->host_irq, &map);
+			}
+		}
 
+		vgic_put_irq(kvm, irq);
+	}
+
+	kfree(intids);
 	return 0;
 }
 
-- 
2.11.0
