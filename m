From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 17/55] KVM: arm/arm64: vgic-new: Add IRQ sync/flush
 framework
Date: Fri,  6 May 2016 11:45:30 +0100
Message-ID: <1462531568-9799-18-git-send-email-andre.przywara@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A701849BDA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2016 06:43:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8hlYMQRnzUsd for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 May 2016 06:43:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62AB649BDB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2016 06:43:25 -0400 (EDT)
In-Reply-To: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
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

From: Marc Zyngier <marc.zyngier@arm.com>

Implement the framework for syncing IRQs between our emulation and
the list registers, which represent the guest's view of IRQs.
This is done in kvm_vgic_flush_hwstate and kvm_vgic_sync_hwstate,
which gets called on guest entry and exit.
The code talking to the actual GICv2/v3 hardware is added in the
following patches.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Changelog RFC..v1:
- split out vgic_clear_lr() from vgic_populate_lr()
- rename vgic_populate_lrs() to vgic_flush_lr_state()
- clean all LRs when the distributor is disabled
- use list_del() instead of list_del_init()
- add comments to explain the direction of sync/flush_hwstate
- remove unneeded BUG_ON(in_interrupt()

Changelog v2 .. v3:
- remove bogus v2 specific rebase leftovers

 include/kvm/vgic/vgic.h  |   4 +
 virt/kvm/arm/vgic/vgic.c | 193 +++++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h |   2 +
 3 files changed, 199 insertions(+)

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index 2bfb42c..5fae4a9 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -190,6 +190,10 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 #define vgic_valid_spi(k, i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
 			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
 
+bool kvm_vcpu_has_pending_irqs(struct kvm_vcpu *vcpu);
+void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
+void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu);
+
 /**
  * kvm_vgic_get_max_vcpus - Get the maximum number of VCPUs allowed by HW
  *
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 4fb20fd..c6f8b9b 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -305,3 +305,196 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 {
 	return vgic_update_irq_pending(kvm, cpuid, intid, level, false);
 }
+
+/**
+ * vgic_prune_ap_list - Remove non-relevant interrupts from the list
+ *
+ * @vcpu: The VCPU pointer
+ *
+ * Go over the list of "interesting" interrupts, and prune those that we
+ * won't have to consider in the near future.
+ */
+static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_irq *irq, *tmp;
+
+retry:
+	spin_lock(&vgic_cpu->ap_list_lock);
+
+	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
+		struct kvm_vcpu *target_vcpu, *vcpuA, *vcpuB;
+
+		spin_lock(&irq->irq_lock);
+
+		BUG_ON(vcpu != irq->vcpu);
+
+		target_vcpu = vgic_target_oracle(irq);
+
+		if (!target_vcpu) {
+			/*
+			 * We don't need to process this interrupt any
+			 * further, move it off the list.
+			 */
+			list_del(&irq->ap_list);
+			irq->vcpu = NULL;
+			spin_unlock(&irq->irq_lock);
+			continue;
+		}
+
+		if (target_vcpu == vcpu) {
+			/* We're on the right CPU */
+			spin_unlock(&irq->irq_lock);
+			continue;
+		}
+
+		/* This interrupt looks like it has to be migrated. */
+
+		spin_unlock(&irq->irq_lock);
+		spin_unlock(&vgic_cpu->ap_list_lock);
+
+		/*
+		 * Ensure locking order by always locking the smallest
+		 * ID first.
+		 */
+		if (vcpu->vcpu_id < target_vcpu->vcpu_id) {
+			vcpuA = vcpu;
+			vcpuB = target_vcpu;
+		} else {
+			vcpuA = target_vcpu;
+			vcpuB = vcpu;
+		}
+
+		spin_lock(&vcpuA->arch.vgic_cpu.ap_list_lock);
+		spin_lock(&vcpuB->arch.vgic_cpu.ap_list_lock);
+		spin_lock(&irq->irq_lock);
+
+		/*
+		 * If the affinity has been preserved, move the
+		 * interrupt around. Otherwise, it means things have
+		 * changed while the interrupt was unlocked, and we
+		 * need to replay this.
+		 *
+		 * In all cases, we cannot trust the list not to have
+		 * changed, so we restart from the beginning.
+		 */
+		if (target_vcpu == vgic_target_oracle(irq)) {
+			struct vgic_cpu *new_cpu = &target_vcpu->arch.vgic_cpu;
+
+			list_del(&irq->ap_list);
+			irq->vcpu = target_vcpu;
+			list_add_tail(&irq->ap_list, &new_cpu->ap_list_head);
+		}
+
+		spin_unlock(&irq->irq_lock);
+		spin_unlock(&vcpuB->arch.vgic_cpu.ap_list_lock);
+		spin_unlock(&vcpuA->arch.vgic_cpu.ap_list_lock);
+		goto retry;
+	}
+
+	spin_unlock(&vgic_cpu->ap_list_lock);
+}
+
+static inline void vgic_process_maintenance_interrupt(struct kvm_vcpu *vcpu)
+{
+}
+
+static inline void vgic_fold_lr_state(struct kvm_vcpu *vcpu)
+{
+}
+
+/* Requires the ap_list_lock and the irq_lock to be held. */
+static inline void vgic_populate_lr(struct kvm_vcpu *vcpu,
+				    struct vgic_irq *irq, int lr)
+{
+	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&vcpu->arch.vgic_cpu.ap_list_lock));
+	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&irq->irq_lock));
+}
+
+static inline void vgic_clear_lr(struct kvm_vcpu *vcpu, int lr)
+{
+}
+
+static inline void vgic_set_underflow(struct kvm_vcpu *vcpu)
+{
+}
+
+static int compute_ap_list_depth(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_irq *irq;
+	int count = 0;
+
+	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
+		spin_lock(&irq->irq_lock);
+		/* GICv2 SGIs can count for more than one... */
+		if (vgic_irq_is_sgi(irq->intid) && irq->source)
+			count += hweight8(irq->source);
+		else
+			count++;
+		spin_unlock(&irq->irq_lock);
+	}
+	return count;
+}
+
+/* Requires the VCPU's ap_list_lock to be held. */
+static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_irq *irq;
+	int count = 0;
+
+	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&vgic_cpu->ap_list_lock));
+
+	if (unlikely(!vcpu->kvm->arch.vgic.enabled))
+		goto out_clean;
+
+	if (compute_ap_list_depth(vcpu) > kvm_vgic_global_state.nr_lr) {
+		vgic_set_underflow(vcpu);
+		vgic_sort_ap_list(vcpu);
+	}
+
+	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
+		spin_lock(&irq->irq_lock);
+
+		if (unlikely(vgic_target_oracle(irq) != vcpu))
+			goto next;
+
+		/*
+		 * If we get an SGI with multiple sources, try to get
+		 * them in all at once.
+		 */
+		do {
+			vgic_populate_lr(vcpu, irq, count++);
+		} while (irq->source && count < kvm_vgic_global_state.nr_lr);
+
+next:
+		spin_unlock(&irq->irq_lock);
+
+		if (count == kvm_vgic_global_state.nr_lr)
+			break;
+	}
+
+out_clean:
+	vcpu->arch.vgic_cpu.used_lrs = count;
+
+	/* Nuke remaining LRs */
+	for ( ; count < kvm_vgic_global_state.nr_lr; count++)
+		vgic_clear_lr(vcpu, count);
+}
+
+/* Sync back the hardware VGIC state into our emulation after a guest's run. */
+void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
+{
+	vgic_process_maintenance_interrupt(vcpu);
+	vgic_fold_lr_state(vcpu);
+	vgic_prune_ap_list(vcpu);
+}
+
+/* Flush our emulation state into the GIC hardware before entering the guest. */
+void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
+{
+	spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
+	vgic_flush_lr_state(vcpu);
+	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
+}
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index c625767..29b96b9 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -16,6 +16,8 @@
 #ifndef __KVM_ARM_VGIC_NEW_H__
 #define __KVM_ARM_VGIC_NEW_H__
 
+#define vgic_irq_is_sgi(intid) ((intid) < VGIC_NR_SGIS)
+
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			      u32 intid);
 bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq);
-- 
2.7.3
