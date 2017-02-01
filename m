From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH] KVM: arm/arm64: Remove kvm_vgic_inject_mapped_irq
Date: Wed,  1 Feb 2017 11:22:40 +0100
Message-ID: <20170201102240.29985-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47FC840284
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 05:22:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dvLCwE1DJ2OF for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Feb 2017 05:22:26 -0500 (EST)
Received: from mail-lf0-f42.google.com (mail-lf0-f42.google.com
 [209.85.215.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5866F408EB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 05:22:26 -0500 (EST)
Received: by mail-lf0-f42.google.com with SMTP id v186so226007342lfa.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Feb 2017 02:22:47 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The only benefit of having kvm_vgic_inject_mapped_irq separate from
kvm_vgic_inject_irq is that we pass a boolean that we use for error
checking on the injection path.

While this could potentially help in some aspect of robustness, it's
also a little bit of a defensive move, and arguably callers into the
vgic should have make sure they have marked their virtual IRQs as mapped
if required.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arch_timer.c |  3 ++-
 virt/kvm/arm/vgic/vgic.c  | 50 +++++++++++++++--------------------------------
 2 files changed, 18 insertions(+), 35 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 6a084cd..91ecf48 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -175,7 +175,8 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
 	timer->irq.level = new_level;
 	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->irq.irq,
 				   timer->irq.level);
-	ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
+
+	ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
 					 timer->irq.irq,
 					 timer->irq.level);
 	WARN_ON(ret);
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index dea12df..654dfd4 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -335,9 +335,22 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq)
 	return true;
 }
 
-static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
-				   unsigned int intid, bool level,
-				   bool mapped_irq)
+/**
+ * kvm_vgic_inject_irq - Inject an IRQ from a device to the vgic
+ * @kvm:     The VM structure pointer
+ * @cpuid:   The CPU for PPIs
+ * @intid:   The INTID to inject a new state to.
+ * @level:   Edge-triggered:  true:  to trigger the interrupt
+ *			      false: to ignore the call
+ *	     Level-sensitive  true:  raise the input signal
+ *			      false: lower the input signal
+ *
+ * The VGIC is not concerned with devices being active-LOW or active-HIGH for
+ * level-sensitive interrupts.  You can think of the level parameter as 1
+ * being HIGH and 0 being LOW and all devices being active-HIGH.
+ */
+int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
+			bool level)
 {
 	struct kvm_vcpu *vcpu;
 	struct vgic_irq *irq;
@@ -357,11 +370,6 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 	if (!irq)
 		return -EINVAL;
 
-	if (irq->hw != mapped_irq) {
-		vgic_put_irq(kvm, irq);
-		return -EINVAL;
-	}
-
 	spin_lock(&irq->irq_lock);
 
 	if (!vgic_validate_injection(irq, level)) {
@@ -382,32 +390,6 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 	return 0;
 }
 
-/**
- * kvm_vgic_inject_irq - Inject an IRQ from a device to the vgic
- * @kvm:     The VM structure pointer
- * @cpuid:   The CPU for PPIs
- * @intid:   The INTID to inject a new state to.
- * @level:   Edge-triggered:  true:  to trigger the interrupt
- *			      false: to ignore the call
- *	     Level-sensitive  true:  raise the input signal
- *			      false: lower the input signal
- *
- * The VGIC is not concerned with devices being active-LOW or active-HIGH for
- * level-sensitive interrupts.  You can think of the level parameter as 1
- * being HIGH and 0 being LOW and all devices being active-HIGH.
- */
-int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
-			bool level)
-{
-	return vgic_update_irq_pending(kvm, cpuid, intid, level, false);
-}
-
-int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid, unsigned int intid,
-			       bool level)
-{
-	return vgic_update_irq_pending(kvm, cpuid, intid, level, true);
-}
-
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, u32 virt_irq, u32 phys_irq)
 {
 	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
-- 
2.9.0
