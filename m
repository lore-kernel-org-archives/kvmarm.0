From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 07/17] arm64: KVM: vgic-v2: Avoid accessing GICH registers
Date: Wed, 17 Feb 2016 16:40:39 +0000
Message-ID: <1455727249-24752-8-git-send-email-marc.zyngier@arm.com>
References: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Andrew Jones <drjones@redhat.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

GICv2 registers are *slow*. As in "terrifyingly slow". Which is bad.
But we're equaly bad, as we make a point in accessing them even if
we don't have any interrupt in flight.

A good solution is to first find out if we have anything useful to
write into the GIC, and if we don't, to simply not do it. This
involves tracking which LRs actually have something valid there.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/vgic-v2-sr.c | 72 ++++++++++++++++++++++++++++-------------
 include/kvm/arm_vgic.h          |  2 ++
 2 files changed, 52 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v2-sr.c b/arch/arm64/kvm/hyp/vgic-v2-sr.c
index e717612..5ab8d63 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-sr.c
@@ -38,28 +38,41 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
 
 	nr_lr = vcpu->arch.vgic_cpu.nr_lr;
 	cpu_if->vgic_vmcr = readl_relaxed(base + GICH_VMCR);
-	cpu_if->vgic_misr = readl_relaxed(base + GICH_MISR);
-	eisr0  = readl_relaxed(base + GICH_EISR0);
-	elrsr0 = readl_relaxed(base + GICH_ELRSR0);
-	if (unlikely(nr_lr > 32)) {
-		eisr1  = readl_relaxed(base + GICH_EISR1);
-		elrsr1 = readl_relaxed(base + GICH_ELRSR1);
-	} else {
-		eisr1 = elrsr1 = 0;
-	}
+
+	if (vcpu->arch.vgic_cpu.live_lrs) {
+		eisr0  = readl_relaxed(base + GICH_EISR0);
+		elrsr0 = readl_relaxed(base + GICH_ELRSR0);
+		cpu_if->vgic_misr = readl_relaxed(base + GICH_MISR);
+		cpu_if->vgic_apr    = readl_relaxed(base + GICH_APR);
+
+		if (unlikely(nr_lr > 32)) {
+			eisr1  = readl_relaxed(base + GICH_EISR1);
+			elrsr1 = readl_relaxed(base + GICH_ELRSR1);
+		} else {
+			eisr1 = elrsr1 = 0;
+		}
+
 #ifdef CONFIG_CPU_BIG_ENDIAN
-	cpu_if->vgic_eisr  = ((u64)eisr0 << 32) | eisr1;
-	cpu_if->vgic_elrsr = ((u64)elrsr0 << 32) | elrsr1;
+		cpu_if->vgic_eisr  = ((u64)eisr0 << 32) | eisr1;
+		cpu_if->vgic_elrsr = ((u64)elrsr0 << 32) | elrsr1;
 #else
-	cpu_if->vgic_eisr  = ((u64)eisr1 << 32) | eisr0;
-	cpu_if->vgic_elrsr = ((u64)elrsr1 << 32) | elrsr0;
+		cpu_if->vgic_eisr  = ((u64)eisr1 << 32) | eisr0;
+		cpu_if->vgic_elrsr = ((u64)elrsr1 << 32) | elrsr0;
 #endif
-	cpu_if->vgic_apr    = readl_relaxed(base + GICH_APR);
 
-	writel_relaxed(0, base + GICH_HCR);
+		for (i = 0; i < nr_lr; i++)
+			if (vcpu->arch.vgic_cpu.live_lrs & (1UL << i))
+				cpu_if->vgic_lr[i] = readl_relaxed(base + GICH_LR0 + (i * 4));
 
-	for (i = 0; i < nr_lr; i++)
-		cpu_if->vgic_lr[i] = readl_relaxed(base + GICH_LR0 + (i * 4));
+		writel_relaxed(0, base + GICH_HCR);
+
+		vcpu->arch.vgic_cpu.live_lrs = 0;
+	} else {
+		cpu_if->vgic_eisr = 0;
+		cpu_if->vgic_elrsr = ~0UL;
+		cpu_if->vgic_misr = 0;
+		cpu_if->vgic_apr = 0;
+	}
 }
 
 /* vcpu is already in the HYP VA space */
@@ -70,15 +83,30 @@ void __hyp_text __vgic_v2_restore_state(struct kvm_vcpu *vcpu)
 	struct vgic_dist *vgic = &kvm->arch.vgic;
 	void __iomem *base = kern_hyp_va(vgic->vctrl_base);
 	int i, nr_lr;
+	u64 live_lrs = 0;
 
 	if (!base)
 		return;
 
-	writel_relaxed(cpu_if->vgic_hcr, base + GICH_HCR);
-	writel_relaxed(cpu_if->vgic_vmcr, base + GICH_VMCR);
-	writel_relaxed(cpu_if->vgic_apr, base + GICH_APR);
-
 	nr_lr = vcpu->arch.vgic_cpu.nr_lr;
+
 	for (i = 0; i < nr_lr; i++)
-		writel_relaxed(cpu_if->vgic_lr[i], base + GICH_LR0 + (i * 4));
+		if (cpu_if->vgic_lr[i] & GICH_LR_STATE)
+			live_lrs |= 1UL << i;
+
+	if (live_lrs) {
+		writel_relaxed(cpu_if->vgic_hcr, base + GICH_HCR);
+		writel_relaxed(cpu_if->vgic_apr, base + GICH_APR);
+		for (i = 0; i < nr_lr; i++) {
+			u32 val = 0;
+
+			if (live_lrs & (1UL << i))
+				val = cpu_if->vgic_lr[i];
+
+			writel_relaxed(val, base + GICH_LR0 + (i * 4));
+		}
+	}
+
+	writel_relaxed(cpu_if->vgic_vmcr, base + GICH_VMCR);
+	vcpu->arch.vgic_cpu.live_lrs = live_lrs;
 }
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 13a3d53..f473fd6 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -321,6 +321,8 @@ struct vgic_cpu {
 
 	/* Protected by the distributor's irq_phys_map_lock */
 	struct list_head	irq_phys_map_list;
+
+	u64		live_lrs;
 };
 
 #define LR_EMPTY	0xff
-- 
2.1.4

