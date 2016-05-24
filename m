From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 08/59] KVM: arm/arm64: vgic: Remove irq_phys_map from interface
Date: Tue, 24 May 2016 11:09:02 +0200
Message-ID: <1464080993-10884-9-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1A0649B70
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ahMOCnp3UTMl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 May 2016 05:06:31 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8775749B9F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:30 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id n129so15331728wmn.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 02:10:03 -0700 (PDT)
In-Reply-To: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

Now that the virtual arch timer does not care about the irq_phys_map
anymore, let's rework kvm_vgic_map_phys_irq() to return an error
value instead. Any reference to that mapping can later be done by
passing the correct combination of VCPU and virtual IRQ number.
This makes the irq_phys_map handling completely private to the
VGIC code.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 include/kvm/arm_vgic.h    |  3 +--
 virt/kvm/arm/arch_timer.c |  7 +------
 virt/kvm/arm/vgic.c       | 15 +++++++--------
 3 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 9ad7625..3e17fb4 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -344,8 +344,7 @@ int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
 			       unsigned int virt_irq, bool level);
 void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
-struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
-					   int virt_irq, int phys_irq);
+int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, int virt_irq, int phys_irq);
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq);
 bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
 
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 458d4d8..3232105 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -333,7 +333,6 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 			 const struct kvm_irq_level *irq)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
-	struct irq_phys_map *map;
 	struct irq_desc *desc;
 	struct irq_data *data;
 	int phys_irq;
@@ -374,11 +373,7 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 	 * Tell the VGIC that the virtual interrupt is tied to a
 	 * physical interrupt. We do that once per VCPU.
 	 */
-	map = kvm_vgic_map_phys_irq(vcpu, irq->irq, phys_irq);
-	if (WARN_ON(IS_ERR(map)))
-		return PTR_ERR(map);
-
-	return 0;
+	return kvm_vgic_map_phys_irq(vcpu, irq->irq, phys_irq);
 }
 
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index a7e496a..91d42a8 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1719,21 +1719,20 @@ static struct list_head *vgic_get_irq_phys_map_list(struct kvm_vcpu *vcpu,
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
 
@@ -1742,7 +1741,7 @@ struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 	if (map) {
 		/* Make sure this mapping matches */
 		if (map->phys_irq != phys_irq)
-			map = ERR_PTR(-EINVAL);
+			ret = -EINVAL;
 
 		/* Found an existing, valid mapping */
 		goto out;
@@ -1758,9 +1757,9 @@ out:
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
2.1.2.330.g565301e.dirty
