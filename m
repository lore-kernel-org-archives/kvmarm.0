From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 09/45] KVM: arm/arm64: vgic-new: Add GICv2 world switch backend
Date: Fri, 15 Apr 2016 18:11:20 +0100
Message-ID: <1460740316-8755-10-git-send-email-andre.przywara@arm.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B605949C06
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 13:10:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NHou8a3jFhAU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2016 13:10:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60A3249C11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 13:10:15 -0400 (EDT)
In-Reply-To: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

Processing maintenance interrupts and accessing the list registers
are dependent on the host's GIC version.
Introduce vgic-v2.c to contain GICv2 specific functions.
Implement the GICv2 specific code for syncing the emulation state
into the VGIC registers.
Also add vgic_v2_irq_change_affinity() to change the target VCPU of a
particular interrupt.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Changelog RFC..v1:
- remove explicit LR_STATE clearing on maintenance interrupt handling
- improve documentation for vgic_v2_populate_lr()
- remove WARN_ON on non-edge IRQs in maintenance interrupts
- simplify multi-CPU source SGI handling
---
 virt/kvm/arm/vgic/vgic-v2.c | 175 ++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.c    |  19 +++--
 virt/kvm/arm/vgic/vgic.h    |   6 ++
 3 files changed, 190 insertions(+), 10 deletions(-)
 create mode 100644 virt/kvm/arm/vgic/vgic-v2.c

diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
new file mode 100644
index 0000000..43c19fb
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -0,0 +1,175 @@
+/*
+ * Copyright (C) 2015, 2016 ARM Ltd.
+ *
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
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/irqchip/arm-gic.h>
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+
+#include "vgic.h"
+
+/*
+ * Call this function to convert a u64 value to an unsigned long * bitmask
+ * in a way that works on both 32-bit and 64-bit LE and BE platforms.
+ *
+ * Warning: Calling this function may modify *val.
+ */
+static unsigned long *u64_to_bitmask(u64 *val)
+{
+#if defined(CONFIG_CPU_BIG_ENDIAN) && BITS_PER_LONG == 32
+	*val = (*val >> 32) | (*val << 32);
+#endif
+	return (unsigned long *)val;
+}
+
+void vgic_v2_process_maintenance(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v2_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v2;
+
+	if (cpuif->vgic_misr & GICH_MISR_EOI) {
+		u64 eisr = cpuif->vgic_eisr;
+		unsigned long *eisr_bmap = u64_to_bitmask(&eisr);
+		int lr;
+
+		for_each_set_bit(lr, eisr_bmap, kvm_vgic_global_state.nr_lr) {
+			u32 intid = cpuif->vgic_lr[lr] & GICH_LR_VIRTUALID;
+
+			WARN_ON(cpuif->vgic_lr[lr] & GICH_LR_STATE);
+
+			kvm_notify_acked_irq(vcpu->kvm, 0,
+					     intid - VGIC_NR_PRIVATE_IRQS);
+
+			cpuif->vgic_elrsr |= 1ULL << lr;
+		}
+	}
+
+	/* check and disable underflow maintenance IRQ */
+	cpuif->vgic_hcr &= ~GICH_HCR_UIE;
+
+	/*
+	 * In the next iterations of the vcpu loop, if we sync the
+	 * vgic state after flushing it, but before entering the guest
+	 * (this happens for pending signals and vmid rollovers), then
+	 * make sure we don't pick up any old maintenance interrupts
+	 * here.
+	 */
+	cpuif->vgic_eisr = 0;
+}
+
+void vgic_v2_set_underflow(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v2_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v2;
+
+	cpuif->vgic_hcr |= GICH_HCR_UIE;
+}
+
+/*
+ * transfer the content of the LRs back into the corresponding ap_list:
+ * - active bit is transferred as is
+ * - pending bit is
+ *   - transferred as is in case of edge sensitive IRQs
+ *   - set to the line-level (resample time) for level sensitive IRQs
+ */
+void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v2_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v2;
+	int lr;
+
+	for (lr = 0; lr < vcpu->arch.vgic_cpu.used_lrs; lr++) {
+		u32 val = cpuif->vgic_lr[lr];
+		u32 intid = val & GICH_LR_VIRTUALID;
+		struct vgic_irq *irq;
+
+		irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
+
+		spin_lock(&irq->irq_lock);
+
+		/* Always preserve the active bit */
+		irq->active = !!(val & GICH_LR_ACTIVE_BIT);
+
+		/* Edge is the only case where we preserve the pending bit */
+		if (irq->config == VGIC_CONFIG_EDGE &&
+		    (val & GICH_LR_PENDING_BIT)) {
+			irq->pending = true;
+
+			if (vgic_irq_is_sgi(intid)) {
+				u32 cpuid = val & GICH_LR_PHYSID_CPUID;
+
+				cpuid >>= GICH_LR_PHYSID_CPUID_SHIFT;
+				irq->source |= (1 << cpuid);
+			}
+		}
+
+		/* Clear soft pending state when level IRQs have been acked */
+		if (irq->config == VGIC_CONFIG_LEVEL &&
+		    !(val & GICH_LR_PENDING_BIT)) {
+			irq->soft_pending = false;
+			irq->pending = irq->line_level;
+		}
+
+		spin_unlock(&irq->irq_lock);
+	}
+}
+
+/*
+ * Populates the particular LR with the state of a given IRQ:
+ * - for an edge sensitive IRQ the pending state is cleared in struct vgic_irq
+ * - for a level sensitive IRQ the pending state value is unchanged;
+ *   it is dictated directly by the input level
+ *
+ * If @irq describes an SGI with multiple sources, we choose the
+ * lowest-numbered source VCPU and clear that bit in the source bitmap.
+ *
+ * The irq_lock must be held by the caller.
+ */
+void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
+{
+	u32 val = irq->intid;
+
+	if (irq->pending) {
+		val |= GICH_LR_PENDING_BIT;
+
+		if (irq->config == VGIC_CONFIG_EDGE)
+			irq->pending = false;
+
+		if (vgic_irq_is_sgi(irq->intid)) {
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
+		val |= GICH_LR_ACTIVE_BIT;
+
+	if (irq->hw) {
+		val |= GICH_LR_HW;
+		val |= irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
+	} else {
+		if (irq->config == VGIC_CONFIG_LEVEL)
+			val |= GICH_LR_EOI;
+	}
+
+	vcpu->arch.vgic_cpu.vgic_v2.vgic_lr[lr] = val;
+}
+
+void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr)
+{
+	vcpu->arch.vgic_cpu.vgic_v2.vgic_lr[lr] = 0;
+}
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 65fa9ac..86c253d 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -385,10 +385,12 @@ retry:
 
 static inline void vgic_process_maintenance_interrupt(struct kvm_vcpu *vcpu)
 {
+	vgic_v2_process_maintenance(vcpu);
 }
 
 static inline void vgic_fold_lr_state(struct kvm_vcpu *vcpu)
 {
+	vgic_v2_fold_lr_state(vcpu);
 }
 
 /* Requires the ap_list_lock and the irq_lock to be held. */
@@ -397,14 +399,18 @@ static inline void vgic_populate_lr(struct kvm_vcpu *vcpu,
 {
 	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&vcpu->arch.vgic_cpu.ap_list_lock));
 	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&irq->irq_lock));
+
+	vgic_v2_populate_lr(vcpu, irq, lr);
 }
 
 static inline void vgic_clear_lr(struct kvm_vcpu *vcpu, int lr)
 {
+	vgic_v2_clear_lr(vcpu, lr);
 }
 
 static inline void vgic_set_underflow(struct kvm_vcpu *vcpu)
 {
+	vgic_v2_set_underflow(vcpu);
 }
 
 static int compute_ap_list_depth(struct kvm_vcpu *vcpu)
@@ -429,14 +435,12 @@ static int compute_ap_list_depth(struct kvm_vcpu *vcpu)
 static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
-	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
-	u32 model = dist->vgic_model;
 	struct vgic_irq *irq;
 	int count = 0;
 
 	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(vgic_cpu->ap_list_lock));
 
-	if (unlikely(!dist->enabled))
+	if (unlikely(!vcpu->kvm->arch.vgic.enabled))
 		goto out_clean;
 
 	if (compute_ap_list_depth(vcpu) > kvm_vgic_global_state.nr_lr) {
@@ -454,14 +458,9 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 		 * If we get an SGI with multiple sources, try to get
 		 * them in all at once.
 		 */
-		if (model == KVM_DEV_TYPE_ARM_VGIC_V2 &&
-		    vgic_irq_is_sgi(irq->intid)) {
-			while (irq->source &&
-			       count < kvm_vgic_global_state.nr_lr)
-				vgic_populate_lr(vcpu, irq, count++);
-		} else {
+		do {
 			vgic_populate_lr(vcpu, irq, count++);
-		}
+		} while (irq->source && count < kvm_vgic_global_state.nr_lr);
 
 next:
 		spin_unlock(&irq->irq_lock);
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 29b96b9..0db490e 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -22,4 +22,10 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			      u32 intid);
 bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq);
 
+void vgic_v2_process_maintenance(struct kvm_vcpu *vcpu);
+void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
+void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
+void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
+void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
+
 #endif
-- 
2.7.3
