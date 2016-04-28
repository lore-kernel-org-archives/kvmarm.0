From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 18/54] KVM: arm/arm64: vgic-new: Add GICv3 world switch backend
Date: Thu, 28 Apr 2016 17:45:37 +0100
Message-ID: <1461861973-26464-19-git-send-email-andre.przywara@arm.com>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

As the GICv3 virtual interface registers differ from their GICv2
siblings, we need different handlers for processing maintenance
interrupts and reading/writing to the LRs.
Implement the respective handler functions and connect them to
existing code to be called if the host is using a GICv3.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Changelog RFC..v1:
- remove outdated comment about the dist_lock
- add WARN_ON about LR_STATE not being 0 in maintenance interrupts

Changelog v1 .. v2:
- inject the IRQ priority into the list register

 include/linux/irqchip/arm-gic-v3.h |   1 +
 virt/kvm/arm/vgic/vgic-v3.c        | 169 +++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.c           |  25 ++++--
 virt/kvm/arm/vgic/vgic.h           |  29 +++++++
 4 files changed, 219 insertions(+), 5 deletions(-)
 create mode 100644 virt/kvm/arm/vgic/vgic-v3.c

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index d5d798b..56fd2c5 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -275,6 +275,7 @@
 #define ICH_LR_ACTIVE_BIT		(1ULL << 63)
 #define ICH_LR_PHYS_ID_SHIFT		32
 #define ICH_LR_PHYS_ID_MASK		(0x3ffULL << ICH_LR_PHYS_ID_SHIFT)
+#define ICH_LR_PRIORITY_SHIFT		48
 
 #define ICH_MISR_EOI			(1 << 0)
 #define ICH_MISR_U			(1 << 1)
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
new file mode 100644
index 0000000..461229b
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -0,0 +1,169 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/irqchip/arm-gic-v3.h>
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <linux/irqchip/arm-gic.h>
+
+#include "vgic.h"
+
+void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
+	u32 model = vcpu->kvm->arch.vgic.vgic_model;
+
+	if (cpuif->vgic_misr & ICH_MISR_EOI) {
+		unsigned long eisr_bmap = cpuif->vgic_eisr;
+		int lr;
+
+		for_each_set_bit(lr, &eisr_bmap, kvm_vgic_global_state.nr_lr) {
+			u32 intid;
+			u64 val = cpuif->vgic_lr[lr];
+
+			if (model == KVM_DEV_TYPE_ARM_VGIC_V3)
+				intid = val & ICH_LR_VIRTUAL_ID_MASK;
+			else
+				intid = val & GICH_LR_VIRTUALID;
+
+			WARN_ON(cpuif->vgic_lr[lr] & ICH_LR_STATE);
+
+			kvm_notify_acked_irq(vcpu->kvm, 0,
+					     intid - VGIC_NR_PRIVATE_IRQS);
+
+			cpuif->vgic_elrsr |= 1ULL << lr;
+		}
+
+		/*
+		 * In the next iterations of the vcpu loop, if we sync
+		 * the vgic state after flushing it, but before
+		 * entering the guest (this happens for pending
+		 * signals and vmid rollovers), then make sure we
+		 * don't pick up any old maintenance interrupts here.
+		 */
+		cpuif->vgic_eisr = 0;
+	}
+
+	cpuif->vgic_hcr &= ~ICH_HCR_UIE;
+}
+
+void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
+
+	cpuif->vgic_hcr |= ICH_HCR_UIE;
+}
+
+void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
+	u32 model = vcpu->kvm->arch.vgic.vgic_model;
+	int lr;
+
+	/* Assumes ap_list_lock held */
+
+	for (lr = 0; lr < vcpu->arch.vgic_cpu.used_lrs; lr++) {
+		u64 val = cpuif->vgic_lr[lr];
+		u32 intid;
+		struct vgic_irq *irq;
+
+		if (model == KVM_DEV_TYPE_ARM_VGIC_V3)
+			intid = val & ICH_LR_VIRTUAL_ID_MASK;
+		else
+			intid = val & GICH_LR_VIRTUALID;
+		irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
+
+		spin_lock(&irq->irq_lock);
+
+		/* Always preserve the active bit */
+		irq->active = !!(val & ICH_LR_ACTIVE_BIT);
+
+		/* Edge is the only case where we preserve the pending bit */
+		if (irq->config == VGIC_CONFIG_EDGE &&
+		    (val & ICH_LR_PENDING_BIT)) {
+			irq->pending = true;
+
+			if (vgic_irq_is_sgi(intid) &&
+			    model == KVM_DEV_TYPE_ARM_VGIC_V2) {
+				u32 cpuid = val & GICH_LR_PHYSID_CPUID;
+
+				cpuid >>= GICH_LR_PHYSID_CPUID_SHIFT;
+				irq->source |= (1 << cpuid);
+			}
+		}
+
+		/* Clear soft pending state when level irqs have been acked */
+		if (irq->config == VGIC_CONFIG_LEVEL &&
+		    !(val & ICH_LR_PENDING_BIT)) {
+			irq->soft_pending = false;
+			irq->pending = irq->line_level;
+		}
+
+		spin_unlock(&irq->irq_lock);
+	}
+}
+
+/* Requires the irq to be locked already */
+void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
+{
+	u32 model = vcpu->kvm->arch.vgic.vgic_model;
+	u64 val = irq->intid;
+
+	if (irq->pending) {
+		val |= ICH_LR_PENDING_BIT;
+
+		if (irq->config == VGIC_CONFIG_EDGE)
+			irq->pending = false;
+
+		if (vgic_irq_is_sgi(irq->intid) &&
+		    model == KVM_DEV_TYPE_ARM_VGIC_V2) {
+			u32 src = ffs(irq->source);
+
+			BUG_ON(!src);
+			val |= (src - 1) << GICH_LR_PHYSID_CPUID_SHIFT;
+			irq->source &= ~(1 << (src - 1));
+			if (irq->source)
+				irq->pending = true;
+		}
+	}
+
+	if (irq->active)
+		val |= ICH_LR_ACTIVE_BIT;
+
+	if (irq->hw) {
+		val |= ICH_LR_HW;
+		val |= ((u64)irq->hwintid) << ICH_LR_PHYS_ID_SHIFT;
+	} else {
+		if (irq->config == VGIC_CONFIG_LEVEL)
+			val |= ICH_LR_EOI;
+	}
+
+	/*
+	 * Currently all guest IRQs are Group1, as Group0 would result
+	 * in a FIQ in the guest, which it wouldn't expect.
+	 * Eventually we want to make this configurable, so we may
+	 * revisit this in the future.
+	 */
+	if (model == KVM_DEV_TYPE_ARM_VGIC_V3)
+		val |= ICH_LR_GROUP;
+
+	val |= (u64)irq->priority << ICH_LR_PRIORITY_SHIFT;
+
+	vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[lr] = val;
+}
+
+void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr)
+{
+	vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[lr] = 0;
+}
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 9f75685..ae52928 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -397,12 +397,18 @@ retry:
 
 static inline void vgic_process_maintenance_interrupt(struct kvm_vcpu *vcpu)
 {
-	vgic_v2_process_maintenance(vcpu);
+	if (kvm_vgic_global_state.type == VGIC_V2)
+		vgic_v2_process_maintenance(vcpu);
+	else
+		vgic_v3_process_maintenance(vcpu);
 }
 
 static inline void vgic_fold_lr_state(struct kvm_vcpu *vcpu)
 {
-	vgic_v2_fold_lr_state(vcpu);
+	if (kvm_vgic_global_state.type == VGIC_V2)
+		vgic_v2_fold_lr_state(vcpu);
+	else
+		vgic_v3_fold_lr_state(vcpu);
 }
 
 /* Requires the ap_list_lock and the irq_lock to be held. */
@@ -412,17 +418,26 @@ static inline void vgic_populate_lr(struct kvm_vcpu *vcpu,
 	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&vcpu->arch.vgic_cpu.ap_list_lock));
 	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&irq->irq_lock));
 
-	vgic_v2_populate_lr(vcpu, irq, lr);
+	if (kvm_vgic_global_state.type == VGIC_V2)
+		vgic_v2_populate_lr(vcpu, irq, lr);
+	else
+		vgic_v3_populate_lr(vcpu, irq, lr);
 }
 
 static inline void vgic_clear_lr(struct kvm_vcpu *vcpu, int lr)
 {
-	vgic_v2_clear_lr(vcpu, lr);
+	if (kvm_vgic_global_state.type == VGIC_V2)
+		vgic_v2_clear_lr(vcpu, lr);
+	else
+		vgic_v3_clear_lr(vcpu, lr);
 }
 
 static inline void vgic_set_underflow(struct kvm_vcpu *vcpu)
 {
-	vgic_v2_set_underflow(vcpu);
+	if (kvm_vgic_global_state.type == VGIC_V2)
+		vgic_v2_set_underflow(vcpu);
+	else
+		vgic_v3_set_underflow(vcpu);
 }
 
 static int compute_ap_list_depth(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 0db490e..81b1a20 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -28,4 +28,33 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
 
+#ifdef CONFIG_KVM_ARM_VGIC_V3
+void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu);
+void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
+void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
+void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr);
+void vgic_v3_set_underflow(struct kvm_vcpu *vcpu);
+#else
+static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
+{
+}
+
+static inline void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
+{
+}
+
+static inline void vgic_v3_populate_lr(struct kvm_vcpu *vcpu,
+				       struct vgic_irq *irq, int lr)
+{
+}
+
+static inline void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr)
+{
+}
+
+static inline void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
+{
+}
+#endif
+
 #endif
-- 
2.7.3

