From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 01/12] KVM: arm/arm64: vgic-v2: Avoid accessing GICH
 registers
Date: Mon,  7 Mar 2016 09:33:23 +0000
Message-ID: <1457343214-19547-2-git-send-email-marc.zyngier@arm.com>
References: <1457343214-19547-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 933CF412ED
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2016 04:26:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kqZuYlyfXQvu for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Mar 2016 04:26:17 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC67A4998D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2016 04:26:16 -0500 (EST)
In-Reply-To: <1457343214-19547-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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
 include/kvm/arm_vgic.h        |  2 ++
 virt/kvm/arm/hyp/vgic-v2-sr.c | 72 ++++++++++++++++++++++++++++++-------------
 2 files changed, 52 insertions(+), 22 deletions(-)

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
diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index 9514a7d..aa0fdb8 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -36,28 +36,41 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
 
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
@@ -68,15 +81,30 @@ void __hyp_text __vgic_v2_restore_state(struct kvm_vcpu *vcpu)
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
-- 
2.1.4
