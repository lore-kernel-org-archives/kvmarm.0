From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 32/37] KVM: arm/arm64: Handle VGICv2 save/restore from the
 main VGIC code
Date: Thu, 12 Oct 2017 12:41:36 +0200
Message-ID: <20171012104141.26902-33-christoffer.dall@linaro.org>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE79549D3F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IRAysnTj0Kkk for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Oct 2017 06:41:43 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9D6F49D5E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:42 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id i124so12077790wmf.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 03:42:27 -0700 (PDT)
In-Reply-To: <20171012104141.26902-1-christoffer.dall@linaro.org>
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
 arch/arm/kvm/hyp/switch.c        |  4 --
 arch/arm64/include/asm/kvm_hyp.h |  2 -
 arch/arm64/kvm/hyp/switch.c      |  4 --
 virt/kvm/arm/hyp/vgic-v2-sr.c    | 83 ------------------------------------
 virt/kvm/arm/vgic/vgic-init.c    | 22 ++++++----
 virt/kvm/arm/vgic/vgic-v2.c      | 92 ++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.c         | 21 ++++++++-
 virt/kvm/arm/vgic/vgic.h         |  5 +++
 8 files changed, 130 insertions(+), 103 deletions(-)

diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index c3b9799..0d834f8 100644
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
index 28d5f3c..bd3fe64 100644
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
index 5692aa0..90da506 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -186,16 +186,12 @@ static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
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
index a3f18d3..b433257 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -22,89 +22,6 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 
-static void __hyp_text save_elrsr(struct kvm_vcpu *vcpu, void __iomem *base)
-{
-	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	int nr_lr = (kern_hyp_va(&kvm_vgic_global_state))->nr_lr;
-	u32 elrsr0, elrsr1;
-
-	elrsr0 = readl_relaxed(base + GICH_ELRSR0);
-	if (unlikely(nr_lr > 32))
-		elrsr1 = readl_relaxed(base + GICH_ELRSR1);
-	else
-		elrsr1 = 0;
-
-#ifdef CONFIG_CPU_BIG_ENDIAN
-	cpu_if->vgic_elrsr = ((u64)elrsr0 << 32) | elrsr1;
-#else
-	cpu_if->vgic_elrsr = ((u64)elrsr1 << 32) | elrsr0;
-#endif
-}
-
-static void __hyp_text save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
-{
-	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	int i;
-	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
-
-	for (i = 0; i < used_lrs; i++) {
-		if (cpu_if->vgic_elrsr & (1UL << i))
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
-
-		save_elrsr(vcpu, base);
-		save_lrs(vcpu, base);
-
-		writel_relaxed(0, base + GICH_HCR);
-	} else {
-		cpu_if->vgic_elrsr = ~0UL;
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
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 5801261f..fa2b565 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -425,14 +425,16 @@ static int vgic_init_cpu_dying(unsigned int cpu)
 	return 0;
 }
 
-static irqreturn_t vgic_maintenance_handler(int irq, void *data)
+static irqreturn_t vgic_v3_maintenance_handler(int irq, void *data)
 {
-	/*
-	 * We cannot rely on the vgic maintenance interrupt to be
-	 * delivered synchronously. This means we can only use it to
-	 * exit the VM, and we perform the handling of EOIed
-	 * interrupts on the exit path (see vgic_process_maintenance).
-	 */
+	BUG(); /* Not implemented lazy save/restore on GICv3 */
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t vgic_v2_maintenance_handler(int irq, void *data)
+{
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)data;
+	vgic_v2_handle_maintenance(vcpu);
 	return IRQ_HANDLED;
 }
 
@@ -464,6 +466,7 @@ void kvm_vgic_init_cpu_hardware(void)
 int kvm_vgic_hyp_init(void)
 {
 	const struct gic_kvm_info *gic_kvm_info;
+	irqreturn_t (*handler)(int irq, void *data);
 	int ret;
 
 	gic_kvm_info = gic_get_kvm_info();
@@ -478,6 +481,7 @@ int kvm_vgic_hyp_init(void)
 	switch (gic_kvm_info->type) {
 	case GIC_V2:
 		ret = vgic_v2_probe(gic_kvm_info);
+		handler = vgic_v2_maintenance_handler;
 		break;
 	case GIC_V3:
 		ret = vgic_v3_probe(gic_kvm_info);
@@ -485,6 +489,7 @@ int kvm_vgic_hyp_init(void)
 			static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
 			kvm_info("GIC system register CPU interface enabled\n");
 		}
+		handler = vgic_v3_maintenance_handler;
 		break;
 	default:
 		ret = -ENODEV;
@@ -494,8 +499,7 @@ int kvm_vgic_hyp_init(void)
 		return ret;
 
 	kvm_vgic_global_state.maint_irq = gic_kvm_info->maint_irq;
-	ret = request_percpu_irq(kvm_vgic_global_state.maint_irq,
-				 vgic_maintenance_handler,
+	ret = request_percpu_irq(kvm_vgic_global_state.maint_irq, handler,
 				 "vgic", kvm_get_running_vcpus());
 	if (ret) {
 		kvm_err("Cannot register interrupt %d\n",
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 8089710..259079b 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -37,6 +37,17 @@ void vgic_v2_init_lrs(void)
 		vgic_v2_write_lr(i, 0);
 }
 
+void vgic_v2_handle_maintenance(struct kvm_vcpu *vcpu)
+{
+	void __iomem *base = kvm_vgic_global_state.vctrl_base;
+
+	/*
+	 * Disable maintenance interrupt as we only use it to generate an exit
+	 * from the VM.
+	 */
+	writel_relaxed(0, base + GICH_HCR);
+}
+
 void vgic_v2_set_underflow(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v2_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v2;
@@ -393,6 +404,87 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 	return ret;
 }
 
+static void save_elrsr(struct kvm_vcpu *vcpu, void __iomem *base)
+{
+	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
+	int nr_lr = kvm_vgic_global_state.nr_lr;
+	u32 elrsr0, elrsr1;
+
+	elrsr0 = readl_relaxed(base + GICH_ELRSR0);
+	if (unlikely(nr_lr > 32))
+		elrsr1 = readl_relaxed(base + GICH_ELRSR1);
+	else
+		elrsr1 = 0;
+
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	cpu_if->vgic_elrsr = ((u64)elrsr0 << 32) | elrsr1;
+#else
+	cpu_if->vgic_elrsr = ((u64)elrsr1 << 32) | elrsr0;
+#endif
+}
+
+static void save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
+{
+	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
+	int i;
+	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
+
+	for (i = 0; i < used_lrs; i++) {
+		if (cpu_if->vgic_elrsr & (1UL << i))
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
+
+		save_elrsr(vcpu, base);
+		save_lrs(vcpu, base);
+
+		writel_relaxed(0, base + GICH_HCR);
+	} else {
+		cpu_if->vgic_elrsr = ~0UL;
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
index b1bd238..790fd66 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -18,6 +18,8 @@
 #include <linux/kvm_host.h>
 #include <linux/list_sort.h>
 
+#include <asm/kvm_hyp.h>
+
 #include "vgic.h"
 
 #define CREATE_TRACE_POINTS
@@ -683,11 +685,19 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
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
 	/* An empty ap_list_head implies used_lrs == 0 */
 	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
 		return;
@@ -697,6 +707,12 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
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
@@ -710,13 +726,16 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
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
index 4f8aecb..9895396 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -167,6 +167,11 @@ int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 void vgic_v2_init_lrs(void);
 void vgic_v2_load(struct kvm_vcpu *vcpu);
 void vgic_v2_put(struct kvm_vcpu *vcpu);
+void vgic_v2_handle_maintenance(struct kvm_vcpu *vcpu);
+
+void vgic_v2_save_state(struct kvm_vcpu *vcpu);
+void vgic_v2_restore_state(struct kvm_vcpu *vcpu);
+
 
 static inline void vgic_get_irq_kref(struct vgic_irq *irq)
 {
-- 
2.9.0
