From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 1/2] KVM: arm/arm64: vgic: Don't populate multiple LRs with
 the same vintid
Date: Sun, 11 Mar 2018 12:49:55 +0000
Message-ID: <20180311124956.7683-2-marc.zyngier@arm.com>
References: <20180311124956.7683-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78B66400D4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Mar 2018 08:43:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2LUYNXHZDwev for <kvmarm@lists.cs.columbia.edu>;
 Sun, 11 Mar 2018 08:42:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EAAB402B8
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Mar 2018 08:42:48 -0400 (EDT)
In-Reply-To: <20180311124956.7683-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The vgic code is trying to be clever when injecting GICv2 SGIs,
and will happily populate LRs with the same interrupt number if
they come from multiple vcpus (after all, they are distinct
interrupt sources).

Unfortunately, this is against the letter of the architecture,
and the GICv2 architecture spec says "Each valid interrupt stored
in the List registers must have a unique VirtualID for that
virtual CPU interface.". GICv3 has similar (although slightly
ambiguous) restrictions.

This results in guests locking up when using GICv2-on-GICv3, for
example. The obvious fix is to stop trying so hard, and inject
a single vcpu per SGI per guest entry. After all, pending SGIs
with multiple source vcpus are pretty rare, and are mostly seen
in scenario where the physical CPUs are severely overcomitted.

But as we now only inject a single instance of a multi-source SGI per
vcpu entry, we may delay those interrupts for longer than strictly
necessary, and run the risk of injecting lower priority interrupts
in the meantime.

In order to address this, we adopt a three stage strategy:
- If we encounter a multi-source SGI in the AP list while computing
  its depth, we force the list to be sorted
- When populating the LRs, we prevent the injection of any interrupt
  of lower priority than that of the first multi-source SGI we've
  injected.
- Finally, the injection of a multi-source SGI triggers the request
  of a maintenance interrupt when there will be no pending interrupt
  in the LRs (HCR_NPIE).

At the point where the last pending interrupt in the LRs switches
from Pending to Active, the maintenance interrupt will be delivered,
allowing us to add the remaining SGIs using the same process.

Cc: stable@vger.kernel.org
Fixes: 0919e84c0fc1 ("KVM: arm/arm64: vgic-new: Add IRQ sync/flush framework")
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/irqchip/arm-gic-v3.h |  1 +
 include/linux/irqchip/arm-gic.h    |  1 +
 virt/kvm/arm/vgic/vgic-v2.c        |  9 +++++-
 virt/kvm/arm/vgic/vgic-v3.c        |  9 +++++-
 virt/kvm/arm/vgic/vgic.c           | 61 +++++++++++++++++++++++++++++---------
 virt/kvm/arm/vgic/vgic.h           |  2 ++
 6 files changed, 67 insertions(+), 16 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index c00c4c33e432..b26eccc78fb1 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -503,6 +503,7 @@
 
 #define ICH_HCR_EN			(1 << 0)
 #define ICH_HCR_UIE			(1 << 1)
+#define ICH_HCR_NPIE			(1 << 3)
 #define ICH_HCR_TC			(1 << 10)
 #define ICH_HCR_TALL0			(1 << 11)
 #define ICH_HCR_TALL1			(1 << 12)
diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index d3453ee072fc..68d8b1f73682 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -84,6 +84,7 @@
 
 #define GICH_HCR_EN			(1 << 0)
 #define GICH_HCR_UIE			(1 << 1)
+#define GICH_HCR_NPIE			(1 << 3)
 
 #define GICH_LR_VIRTUALID		(0x3ff << 0)
 #define GICH_LR_PHYSID_CPUID_SHIFT	(10)
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index c32d7b93ffd1..44264d11be02 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -37,6 +37,13 @@ void vgic_v2_init_lrs(void)
 		vgic_v2_write_lr(i, 0);
 }
 
+void vgic_v2_set_npie(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v2_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v2;
+
+	cpuif->vgic_hcr |= GICH_HCR_NPIE;
+}
+
 void vgic_v2_set_underflow(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v2_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v2;
@@ -64,7 +71,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 	int lr;
 	unsigned long flags;
 
-	cpuif->vgic_hcr &= ~GICH_HCR_UIE;
+	cpuif->vgic_hcr &= ~(GICH_HCR_UIE | GICH_HCR_NPIE);
 
 	for (lr = 0; lr < vgic_cpu->used_lrs; lr++) {
 		u32 val = cpuif->vgic_lr[lr];
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 6b329414e57a..0ff2006f3781 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -26,6 +26,13 @@ static bool group1_trap;
 static bool common_trap;
 static bool gicv4_enable;
 
+void vgic_v3_set_npie(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
+
+	cpuif->vgic_hcr |= ICH_HCR_NPIE;
+}
+
 void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
@@ -47,7 +54,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 	int lr;
 	unsigned long flags;
 
-	cpuif->vgic_hcr &= ~ICH_HCR_UIE;
+	cpuif->vgic_hcr &= ~(ICH_HCR_UIE | ICH_HCR_NPIE);
 
 	for (lr = 0; lr < vgic_cpu->used_lrs; lr++) {
 		u64 val = cpuif->vgic_lr[lr];
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index c7c5ef190afa..859cf88657d5 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -684,22 +684,37 @@ static inline void vgic_set_underflow(struct kvm_vcpu *vcpu)
 		vgic_v3_set_underflow(vcpu);
 }
 
+static inline void vgic_set_npie(struct kvm_vcpu *vcpu)
+{
+	if (kvm_vgic_global_state.type == VGIC_V2)
+		vgic_v2_set_npie(vcpu);
+	else
+		vgic_v3_set_npie(vcpu);
+}
+
 /* Requires the ap_list_lock to be held. */
-static int compute_ap_list_depth(struct kvm_vcpu *vcpu)
+static int compute_ap_list_depth(struct kvm_vcpu *vcpu,
+				 bool *multi_sgi)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_irq *irq;
 	int count = 0;
 
+	*multi_sgi = false;
+
 	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&vgic_cpu->ap_list_lock));
 
 	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
 		spin_lock(&irq->irq_lock);
 		/* GICv2 SGIs can count for more than one... */
-		if (vgic_irq_is_sgi(irq->intid) && irq->source)
-			count += hweight8(irq->source);
-		else
+		if (vgic_irq_is_sgi(irq->intid) && irq->source) {
+			int w = hweight8(irq->source);
+
+			count += w;
+			*multi_sgi |= (w > 1);
+		} else {
 			count++;
+		}
 		spin_unlock(&irq->irq_lock);
 	}
 	return count;
@@ -710,28 +725,43 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_irq *irq;
-	int count = 0;
+	int count;
+	bool npie = false;
+	bool multi_sgi;
+	u8 prio = 0xff;
 
 	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&vgic_cpu->ap_list_lock));
 
-	if (compute_ap_list_depth(vcpu) > kvm_vgic_global_state.nr_lr)
+	count = compute_ap_list_depth(vcpu, &multi_sgi);
+	if (count > kvm_vgic_global_state.nr_lr || multi_sgi)
 		vgic_sort_ap_list(vcpu);
 
+	count = 0;
+
 	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
 		spin_lock(&irq->irq_lock);
 
-		if (unlikely(vgic_target_oracle(irq) != vcpu))
-			goto next;
-
 		/*
-		 * If we get an SGI with multiple sources, try to get
-		 * them in all at once.
+		 * If we have multi-SGIs in the pipeline, we need to
+		 * guarantee that they are all seen before any IRQ of
+		 * lower priority. In that case, we need to filter out
+		 * these interrupts by exiting early. This is easy as
+		 * the AP list has been sorted already.
 		 */
-		do {
+		if (multi_sgi && irq->priority > prio) {
+			spin_unlock(&irq->irq_lock);
+			break;
+		}
+
+		if (likely(vgic_target_oracle(irq) == vcpu)) {
 			vgic_populate_lr(vcpu, irq, count++);
-		} while (irq->source && count < kvm_vgic_global_state.nr_lr);
 
-next:
+			if (irq->source) {
+				npie = true;
+				prio = irq->priority;
+			}
+		}
+
 		spin_unlock(&irq->irq_lock);
 
 		if (count == kvm_vgic_global_state.nr_lr) {
@@ -742,6 +772,9 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	if (npie)
+		vgic_set_npie(vcpu);
+
 	vcpu->arch.vgic_cpu.used_lrs = count;
 
 	/* Nuke remaining LRs */
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 12c37b89f7a3..91f37c05e817 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -159,6 +159,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
+void vgic_v2_set_npie(struct kvm_vcpu *vcpu);
 int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
 int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			 int offset, u32 *val);
@@ -188,6 +189,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v3_set_underflow(struct kvm_vcpu *vcpu);
+void vgic_v3_set_npie(struct kvm_vcpu *vcpu);
 void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_enable(struct kvm_vcpu *vcpu);
-- 
2.14.2
