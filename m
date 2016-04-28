From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 07/54] KVM: arm/arm64: vgic: Remove irq_phys_map from
 interface
Date: Thu, 28 Apr 2016 17:45:26 +0100
Message-ID: <1461861973-26464-8-git-send-email-andre.przywara@arm.com>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 768A049B4E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2016 12:43:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lm2okcticthS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2016 12:43:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71CA649B46
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2016 12:43:47 -0400 (EDT)
In-Reply-To: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
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

Now that the virtual arch timer does not care about the irq_phys_map
anymore, let's rework kvm_vgic_map_phys_irq() to return an error
value instead. Any reference to that mapping can later be done by
passing the correct combination of VCPU and virtual IRQ number.
This makes the irq_phys_map handling completely private to the
VGIC code.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@linaro.org>
---
Changelog v1 .. v2:
- adaptations to changes in previous patches (removal of virt_irq)

 include/kvm/arm_vgic.h    |  3 +--
 virt/kvm/arm/arch_timer.c |  8 ++++----
 virt/kvm/arm/vgic.c       | 15 +++++++--------
 3 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 49c559e..f842d7d 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -343,8 +343,7 @@ int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
 			       unsigned int virt_irq, bool level);
 void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
-struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
-					   int virt_irq, int phys_irq);
+int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, int virt_irq, int phys_irq);
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq);
 bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
 
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 3a74b17..9475000 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -333,10 +333,10 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 			 const struct kvm_irq_level *irq)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
-	struct irq_phys_map *map;
 	struct irq_desc *desc;
 	struct irq_data *data;
 	int phys_irq;
+	int ret;
 
 	/*
 	 * The vcpu timer irq number cannot be determined in
@@ -374,9 +374,9 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 	 * Tell the VGIC that the virtual interrupt is tied to a
 	 * physical interrupt. We do that once per VCPU.
 	 */
-	map = kvm_vgic_map_phys_irq(vcpu, irq->irq, phys_irq);
-	if (WARN_ON(IS_ERR(map)))
-		return PTR_ERR(map);
+	ret = kvm_vgic_map_phys_irq(vcpu, irq->irq, phys_irq);
+	if (ret)
+		return ret;
 
 	return 0;
 }
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 41792c0..00386df 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1720,21 +1720,20 @@ static struct list_head *vgic_get_irq_phys_map_list(struct kvm_vcpu *vcpu,
  * the physical interrupt represented by @phys_irq. This mapping can be
  * established multiple times as long as the parameters are the same.
  *
- * Returns a valid pointer on success, and an error pointer otherwise
+ * Returns 0 on success or an error value otherwise.
  */
-struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
-					   int virt_irq, int phys_irq)
+int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, int virt_irq, int phys_irq)
 {
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	struct list_head *root = vgic_get_irq_phys_map_list(vcpu, virt_irq);
 	struct irq_phys_map *map;
 	struct irq_phys_map_entry *entry;
-
+	int ret = 0;
 
 	/* Create a new mapping */
 	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 
 	spin_lock(&dist->irq_phys_map_lock);
 
@@ -1743,7 +1742,7 @@ struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 	if (map) {
 		/* Make sure this mapping matches */
 		if (map->phys_irq != phys_irq)
-			map = ERR_PTR(-EINVAL);
+			ret = -EINVAL;
 
 		/* Found an existing, valid mapping */
 		goto out;
@@ -1759,9 +1758,9 @@ out:
 	spin_unlock(&dist->irq_phys_map_lock);
 	/* If we've found a hit in the existing list, free the useless
 	 * entry */
-	if (IS_ERR(map) || map != &entry->map)
+	if (ret || map != &entry->map)
 		kfree(entry);
-	return map;
+	return ret;
 }
 
 static struct irq_phys_map *vgic_irq_map_search(struct kvm_vcpu *vcpu,
-- 
2.7.3
