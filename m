From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 04/56] KVM: arm/arm64: vgic: avoid map in
 kvm_vgic_unmap_phys_irq()
Date: Mon, 16 May 2016 10:53:49 +0100
Message-ID: <1463392481-26583-62-git-send-email-andre.przywara@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB8FE49C18
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:52:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Sx5tOkCF6l7b for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2016 05:52:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9BA349C0A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:52:37 -0400 (EDT)
In-Reply-To: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

kvm_vgic_unmap_phys_irq() only needs the virtual IRQ number, so let's
just pass that between the arch timer and the VGIC to get rid of
the irq_phys_map pointer.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@linaro.org>
---
 include/kvm/arm_vgic.h    |  2 +-
 virt/kvm/arm/arch_timer.c |  2 +-
 virt/kvm/arm/vgic.c       | 11 ++++-------
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 9830232..c7bb184 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -347,7 +347,7 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 					   int virt_irq, int irq);
-int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
+int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq);
 bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
 
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 37f82c1..962b442 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -486,7 +486,7 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 
 	timer_disarm(timer);
 	if (timer->map)
-		kvm_vgic_unmap_phys_irq(vcpu, timer->map);
+		kvm_vgic_unmap_phys_irq(vcpu, timer->map->virt_irq);
 }
 
 void kvm_timer_enable(struct kvm *kvm)
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 2fd43a6..06abd59 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1812,25 +1812,22 @@ static void vgic_free_phys_irq_map_rcu(struct rcu_head *rcu)
 /**
  * kvm_vgic_unmap_phys_irq - Remove a virtual to physical IRQ mapping
  * @vcpu: The VCPU pointer
- * @map: The pointer to a mapping obtained through kvm_vgic_map_phys_irq
+ * @virt_irq: The virtual IRQ number to be unmapped
  *
  * Remove an existing mapping between virtual and physical interrupts.
  */
-int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map)
+int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq)
 {
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	struct irq_phys_map_entry *entry;
 	struct list_head *root;
 
-	if (!map)
-		return -EINVAL;
-
-	root = vgic_get_irq_phys_map_list(vcpu, map->virt_irq);
+	root = vgic_get_irq_phys_map_list(vcpu, virt_irq);
 
 	spin_lock(&dist->irq_phys_map_lock);
 
 	list_for_each_entry(entry, root, entry) {
-		if (&entry->map == map) {
+		if (entry->map.virt_irq == virt_irq) {
 			list_del_rcu(&entry->entry);
 			call_rcu(&entry->rcu, vgic_free_phys_irq_map_rcu);
 			break;
-- 
2.8.2
