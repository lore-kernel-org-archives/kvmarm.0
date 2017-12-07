From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2 32/36] KVM: arm/arm64: Handle VGICv2 save/restore from the
 main VGIC code
Date: Thu,  7 Dec 2017 18:06:26 +0100
Message-ID: <20171207170630.592-33-christoffer.dall@linaro.org>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 058F649D61
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 12:04:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o3YsIcacX0nd for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Dec 2017 12:04:17 -0500 (EST)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 66EC749E03
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 12:04:17 -0500 (EST)
Received: by mail-wm0-f65.google.com with SMTP id n138so14267200wmg.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Dec 2017 09:07:33 -0800 (PST)
In-Reply-To: <20171207170630.592-1-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

We can program the GICv2 hypervisor control interface logic directly
from the core vgic code and can instead do the save/restore directly
from the flush/sync functions, which can lead to a number of future
optimizations.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---

Notes:
    Changes since v1:
     - Removed unnecessary kvm_hyp.h include
     - Adapted the patch based on having gotten rid of storing the elrsr
       prior to this patch.
     - No longer change the interrupt handling of the maintenance interrupt
       handler.  That seems to have been a leftover from an earlier version
       of the timer patches where we were syncing the vgic state after
       having enabled interrupts, leading to the maintenance interrupt firing.
    
       It may be possible to move the vgic sync function out to an
       interrupts enabled section later on, which would require
       re-introducing logic to disable the VGIC maintenance interrupt in the
       maintenance interrupt handler, but we leave this for future work as
       the immediate benefit is not clear.

 arch/arm/kvm/hyp/switch.c        |  4 ---
 arch/arm64/include/asm/kvm_hyp.h |  2 --
 arch/arm64/kvm/hyp/switch.c      |  4 ---
 virt/kvm/arm/hyp/vgic-v2-sr.c    | 65 ----------------------------------------
 virt/kvm/arm/vgic/vgic-v2.c      | 63 ++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.c         | 19 +++++++++++-
 virt/kvm/arm/vgic/vgic.h         |  3 ++
 7 files changed, 84 insertions(+), 76 deletions(-)

diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index 7b2bd25e3b10..214187446e63 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -91,16 +91,12 @@ static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
 {
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		__vgic_v3_save_state(vcpu);
-	else
-		__vgic_v2_save_state(vcpu);
 }
 
 static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
 {
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		__vgic_v3_restore_state(vcpu);
-	else
-		__vgic_v2_restore_state(vcpu);
 }
 
 static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 28d5f3cb4001..bd3fe6446728 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -121,8 +121,6 @@ typeof(orig) * __hyp_text fname(void)					\
 	return val;							\
 }
 
-void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
-void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
 int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
 void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index f9f104bfc27b..a7de1436a0e6 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -187,16 +187,12 @@ static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
 {
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		__vgic_v3_save_state(vcpu);
-	else
-		__vgic_v2_save_state(vcpu);
 }
 
 static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
 {
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		__vgic_v3_restore_state(vcpu);
-	else
-		__vgic_v2_restore_state(vcpu);
 }
 
 static bool __hyp_text __true_value(void)
diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index c536e3d87942..b433257f4348 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -22,71 +22,6 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 
-static void __hyp_text save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
-{
-	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
-	u64 elrsr;
-	int i;
-
-	elrsr = readl_relaxed(base + GICH_ELRSR0);
-	if (unlikely(used_lrs > 32))
-		elrsr |= ((u64)readl_relaxed(base + GICH_ELRSR1)) << 32;
-
-	for (i = 0; i < used_lrs; i++) {
-		if (elrsr & (1UL << i))
-			cpu_if->vgic_lr[i] &= ~GICH_LR_STATE;
-		else
-			cpu_if->vgic_lr[i] = readl_relaxed(base + GICH_LR0 + (i * 4));
-
-		writel_relaxed(0, base + GICH_LR0 + (i * 4));
-	}
-}
-
-/* vcpu is already in the HYP VA space */
-void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
-{
-	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
-	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	struct vgic_dist *vgic = &kvm->arch.vgic;
-	void __iomem *base = kern_hyp_va(vgic->vctrl_base);
-	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
-
-	if (!base)
-		return;
-
-	if (used_lrs) {
-		cpu_if->vgic_apr = readl_relaxed(base + GICH_APR);
-		save_lrs(vcpu, base);
-		writel_relaxed(0, base + GICH_HCR);
-	} else {
-		cpu_if->vgic_apr = 0;
-	}
-}
-
-/* vcpu is already in the HYP VA space */
-void __hyp_text __vgic_v2_restore_state(struct kvm_vcpu *vcpu)
-{
-	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
-	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	struct vgic_dist *vgic = &kvm->arch.vgic;
-	void __iomem *base = kern_hyp_va(vgic->vctrl_base);
-	int i;
-	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
-
-	if (!base)
-		return;
-
-	if (used_lrs) {
-		writel_relaxed(cpu_if->vgic_hcr, base + GICH_HCR);
-		writel_relaxed(cpu_if->vgic_apr, base + GICH_APR);
-		for (i = 0; i < used_lrs; i++) {
-			writel_relaxed(cpu_if->vgic_lr[i],
-				       base + GICH_LR0 + (i * 4));
-		}
-	}
-}
-
 #ifdef CONFIG_ARM64
 /*
  * __vgic_v2_perform_cpuif_access -- perform a GICV access on behalf of the
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index bb305d49cfdd..1e5f3eb6973d 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -421,6 +421,69 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 	return ret;
 }
 
+static void save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
+{
+	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
+	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
+	u64 elrsr;
+	int i;
+
+	elrsr = readl_relaxed(base + GICH_ELRSR0);
+	if (unlikely(used_lrs > 32))
+		elrsr |= ((u64)readl_relaxed(base + GICH_ELRSR1)) << 32;
+
+	for (i = 0; i < used_lrs; i++) {
+		if (elrsr & (1UL << i))
+			cpu_if->vgic_lr[i] &= ~GICH_LR_STATE;
+		else
+			cpu_if->vgic_lr[i] = readl_relaxed(base + GICH_LR0 + (i * 4));
+
+		writel_relaxed(0, base + GICH_LR0 + (i * 4));
+	}
+}
+
+void vgic_v2_save_state(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct vgic_dist *vgic = &kvm->arch.vgic;
+	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
+	void __iomem *base = vgic->vctrl_base;
+	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
+
+	if (!base)
+		return;
+
+	if (used_lrs) {
+		cpu_if->vgic_apr = readl_relaxed(base + GICH_APR);
+		save_lrs(vcpu, base);
+		writel_relaxed(0, base + GICH_HCR);
+	} else {
+		cpu_if->vgic_apr = 0;
+	}
+}
+
+void vgic_v2_restore_state(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct vgic_dist *vgic = &kvm->arch.vgic;
+	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
+	void __iomem *base = vgic->vctrl_base;
+	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
+	int i;
+
+	if (!base)
+		return;
+
+	if (used_lrs) {
+		writel_relaxed(cpu_if->vgic_hcr, base + GICH_HCR);
+		writel_relaxed(cpu_if->vgic_apr, base + GICH_APR);
+		for (i = 0; i < used_lrs; i++) {
+			writel_relaxed(cpu_if->vgic_lr[i],
+				       base + GICH_LR0 + (i * 4));
+		}
+	}
+}
+
 void vgic_v2_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index f6299eb1998f..5bf0804e79b4 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -750,11 +750,19 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 		vgic_clear_lr(vcpu, count);
 }
 
+static inline void vgic_save_state(struct kvm_vcpu *vcpu)
+{
+	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+		vgic_v2_save_state(vcpu);
+}
+
 /* Sync back the hardware VGIC state into our emulation after a guest's run. */
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 
+	vgic_save_state(vcpu);
+
 	WARN_ON(vgic_v4_sync_hwstate(vcpu));
 
 	/* An empty ap_list_head implies used_lrs == 0 */
@@ -766,6 +774,12 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 	vgic_prune_ap_list(vcpu);
 }
 
+static inline void vgic_restore_state(struct kvm_vcpu *vcpu)
+{
+	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+		vgic_v2_restore_state(vcpu);
+}
+
 /* Flush our emulation state into the GIC hardware before entering the guest. */
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 {
@@ -781,13 +795,16 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	 * this.
 	 */
 	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
-		return;
+		goto out;
 
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
 
 	spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
 	vgic_flush_lr_state(vcpu);
 	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
+
+out:
+	vgic_restore_state(vcpu);
 }
 
 void kvm_vgic_load(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 12c37b89f7a3..89b9547fba27 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -176,6 +176,9 @@ void vgic_v2_init_lrs(void);
 void vgic_v2_load(struct kvm_vcpu *vcpu);
 void vgic_v2_put(struct kvm_vcpu *vcpu);
 
+void vgic_v2_save_state(struct kvm_vcpu *vcpu);
+void vgic_v2_restore_state(struct kvm_vcpu *vcpu);
+
 static inline void vgic_get_irq_kref(struct vgic_irq *irq)
 {
 	if (irq->intid < VGIC_MIN_LPI)
-- 
2.14.2
