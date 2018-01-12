From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v3 37/41] KVM: arm/arm64: Handle VGICv2 save/restore from the main VGIC code
Date: Fri, 12 Jan 2018 13:07:43 +0100
Message-ID: <20180112120747.27999-38-christoffer.dall@linaro.org>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180112120747.27999-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

We can program the GICv2 hypervisor control interface logic directly
from the core vgic code and can instead do the save/restore directly
from the flush/sync functions, which can lead to a number of future
optimizations.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
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
index ffd62e31f134..16a5342c4821 100644
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
index 53a137821ee9..74b7d7598a51 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -196,16 +196,12 @@ static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
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
index c7c5ef190afa..12e2a28f437e 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -749,11 +749,19 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
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
@@ -765,6 +773,12 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
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
@@ -780,13 +794,16 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
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
