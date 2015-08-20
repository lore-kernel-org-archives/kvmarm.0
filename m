From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 22/25] KVM: arm/arm64: vgic: Prevent userspace injection of a mapped interrupt
Date: Thu, 20 Aug 2015 17:29:00 +0100
Message-ID: <1440088143-4722-23-git-send-email-marc.zyngier@arm.com>
References: <1440088143-4722-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440088143-4722-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Mario Smarduch <m.smarduch@samsung.com>, "Suzuki K. Poulose" <suzuki.poulose@arm.com>, Vladimir Murzin <vladimir.murzin@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Virtual interrupts mapped to a HW interrupt should only be triggered
from inside the kernel. Otherwise, you could end up confusing the
kernel (and the GIC's) state machine.

Rearrange the injection path so that kvm_vgic_inject_irq is
used for non-mapped interrupts, and kvm_vgic_inject_mapped_irq is
used for mapped interrupts. The latter should only be called from
inside the kernel (timer, irqfd).

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h |   2 +
 virt/kvm/arm/vgic.c    | 103 +++++++++++++++++++++++++++++++++----------------
 2 files changed, 72 insertions(+), 33 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index e789e47..d901f1a 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -350,6 +350,8 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu);
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
 			bool level);
+int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
+			       struct irq_phys_map *map, bool level);
 void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index b553a8f..9eb489a 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1555,7 +1555,8 @@ static int vgic_validate_injection(struct kvm_vcpu *vcpu, int irq, int level)
 }
 
 static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
-				  unsigned int irq_num, bool level)
+				   struct irq_phys_map *map,
+				   unsigned int irq_num, bool level)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct kvm_vcpu *vcpu;
@@ -1563,6 +1564,9 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 	int enabled;
 	bool ret = true, can_inject = true;
 
+	if (irq_num >= min(kvm->arch.vgic.nr_irqs, 1020))
+		return -EINVAL;
+
 	spin_lock(&dist->lock);
 
 	vcpu = kvm_get_vcpu(kvm, cpuid);
@@ -1625,18 +1629,46 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 out:
 	spin_unlock(&dist->lock);
 
-	return ret ? cpuid : -EINVAL;
+	if (ret) {
+		/* kick the specified vcpu */
+		kvm_vcpu_kick(kvm_get_vcpu(kvm, cpuid));
+	}
+
+	return 0;
+}
+
+static int vgic_lazy_init(struct kvm *kvm)
+{
+	int ret = 0;
+
+	if (unlikely(!vgic_initialized(kvm))) {
+		/*
+		 * We only provide the automatic initialization of the VGIC
+		 * for the legacy case of a GICv2. Any other type must
+		 * be explicitly initialized once setup with the respective
+		 * KVM device call.
+		 */
+		if (kvm->arch.vgic.vgic_model != KVM_DEV_TYPE_ARM_VGIC_V2)
+			return -EBUSY;
+
+		mutex_lock(&kvm->lock);
+		ret = vgic_init(kvm);
+		mutex_unlock(&kvm->lock);
+	}
+
+	return ret;
 }
 
 /**
  * kvm_vgic_inject_irq - Inject an IRQ from a device to the vgic
  * @kvm:     The VM structure pointer
  * @cpuid:   The CPU for PPIs
- * @irq_num: The IRQ number that is assigned to the device
+ * @irq_num: The IRQ number that is assigned to the device. This IRQ
+ *           must not be mapped to a HW interrupt.
  * @level:   Edge-triggered:  true:  to trigger the interrupt
  *			      false: to ignore the call
- *	     Level-sensitive  true:  activates an interrupt
- *			      false: deactivates an interrupt
+ *	     Level-sensitive  true:  raise the input signal
+ *			      false: lower the input signal
  *
  * The GIC is not concerned with devices being active-LOW or active-HIGH for
  * level-sensitive interrupts.  You can think of the level parameter as 1
@@ -1645,39 +1677,44 @@ out:
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
 			bool level)
 {
-	int ret = 0;
-	int vcpu_id;
-
-	if (unlikely(!vgic_initialized(kvm))) {
-		/*
-		 * We only provide the automatic initialization of the VGIC
-		 * for the legacy case of a GICv2. Any other type must
-		 * be explicitly initialized once setup with the respective
-		 * KVM device call.
-		 */
-		if (kvm->arch.vgic.vgic_model != KVM_DEV_TYPE_ARM_VGIC_V2) {
-			ret = -EBUSY;
-			goto out;
-		}
-		mutex_lock(&kvm->lock);
-		ret = vgic_init(kvm);
-		mutex_unlock(&kvm->lock);
+	struct irq_phys_map *map;
+	int ret;
 
-		if (ret)
-			goto out;
-	}
+	ret = vgic_lazy_init(kvm);
+	if (ret)
+		return ret;
 
-	if (irq_num >= min(kvm->arch.vgic.nr_irqs, 1020))
+	map = vgic_irq_map_search(kvm_get_vcpu(kvm, cpuid), irq_num);
+	if (map)
 		return -EINVAL;
 
-	vcpu_id = vgic_update_irq_pending(kvm, cpuid, irq_num, level);
-	if (vcpu_id >= 0) {
-		/* kick the specified vcpu */
-		kvm_vcpu_kick(kvm_get_vcpu(kvm, vcpu_id));
-	}
+	return vgic_update_irq_pending(kvm, cpuid, NULL, irq_num, level);
+}
 
-out:
-	return ret;
+/**
+ * kvm_vgic_inject_mapped_irq - Inject a physically mapped IRQ to the vgic
+ * @kvm:     The VM structure pointer
+ * @cpuid:   The CPU for PPIs
+ * @map:     Pointer to a irq_phys_map structure describing the mapping
+ * @level:   Edge-triggered:  true:  to trigger the interrupt
+ *			      false: to ignore the call
+ *	     Level-sensitive  true:  raise the input signal
+ *			      false: lower the input signal
+ *
+ * The GIC is not concerned with devices being active-LOW or active-HIGH for
+ * level-sensitive interrupts.  You can think of the level parameter as 1
+ * being HIGH and 0 being LOW and all devices being active-HIGH.
+ */
+int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
+			       struct irq_phys_map *map, bool level)
+{
+	int ret;
+
+	ret = vgic_lazy_init(kvm);
+	if (ret)
+		return ret;
+
+	return vgic_update_irq_pending(kvm, cpuid, map, map->virt_irq, level);
 }
 
 static irqreturn_t vgic_maintenance_handler(int irq, void *data)
-- 
2.1.4

