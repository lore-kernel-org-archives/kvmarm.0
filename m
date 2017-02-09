From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 14/25] KVM: arm/arm64: Remove kvm_vgic_inject_mapped_irq
Date: Thu,  9 Feb 2017 14:59:12 +0000
Message-ID: <1486652363-7696-15-git-send-email-marc.zyngier@arm.com>
References: <1486652363-7696-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1486652363-7696-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, Pavel Fedin <p.fedin@samsung.com>, Shanker Donthineni <shankerd@codeaurora.org>, Jintack Lim <jintack@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

The only benefit of having kvm_vgic_inject_mapped_irq separate from
kvm_vgic_inject_irq is that we pass a boolean that we use for error
checking on the injection path.

While this could potentially help in some aspect of robustness, it's
also a little bit of a defensive move, and arguably callers into the
vgic should have make sure they have marked their virtual IRQs as mapped
if required.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
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
2.1.4
